//
//  LocationMonitor.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-23.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import MapKit
import Parse

class LocationMonitor: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationMonitor()
    let locationManager = CLLocationManager()
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        pickUpMessages()
    }
    
    override init(){
        super.init()
        locationManager.distanceFilter = 5
        locationManager.delegate = self
    }
    
    func pickUpMessages(){
        let parseController = ParseIOController()
        let query = Message.query()!
        query.fromLocalDatastore()
        query.whereKey("postUsers", containsAllObjectsInArray: [PFUser.currentUser()!])
        query.whereKey("pickedUp", equalTo: false)
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if let results = objects as? [Message]{
                var filteredResults = parseController.filterUnreceivedMessages(results, setTimer: false)
                filteredResults = parseController.filterMessagesToUser(filteredResults, user: PFUser.currentUser()!)
                if filteredResults.count > 0{
                    for message in filteredResults {
                        message.pickedUp = true
                        message.pinInBackground()
                        message.saveInBackground()
                    }
                    let alertString = String(filteredResults.count) + " messages were transferred from the ravens in your rookery."
                    let notification = UILocalNotification()
                    notification.alertBody = alertString
                    notification.alertTitle = "Messages Received!"
                    notification.soundName = "squack"
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                }
            }
        })
    }
    
    func cleanUpMonitoredRegions(){
        if locationManager.monitoredRegions.count > 0 {
            for object in locationManager.monitoredRegions{
                if let region = object as? CLCircularRegion{
                    locationManager.stopMonitoringForRegion(region)
                }
            }
        }
    }
    
    func startMonitoringRegion(location:CLLocation){
        cleanUpMonitoredRegions()
        let circularRegion = CLCircularRegion(center: location.coordinate, radius: CLLocationDistance(50), identifier: "rookery")
        locationManager.startMonitoringForRegion(circularRegion)
    }
}


