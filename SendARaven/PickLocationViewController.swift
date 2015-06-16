//
//  PickLocationViewController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-15.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import MapKit
import Parse

class PickLocationViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager?
    var initialLocation = false
    var location:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        mapView.showsUserLocation = true
    }

    @IBAction func okButton(sender: AnyObject) {
        if let finalLocation = location {
            self.assignLocationToCurrentUser(finalLocation)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let thisLocation = locations.first as? CLLocation{
            if initialLocation == false {
                location = thisLocation
                let circularRegion = CLCircularRegion(center: thisLocation.coordinate, radius: CLLocationDistance(50), identifier: "here")
                self.zoomMap(thisLocation)
                initialLocation = true
                locationManager!.stopUpdatingLocation()
                self.updateNeighbourhood(thisLocation)
            }
        }
    }
    
    func zoomMap (thisLocation: CLLocation){
        var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let coordinateRegion = MKCoordinateRegion(center: thisLocation.coordinate, span: span);
        mapView.setRegion(coordinateRegion, animated:true)
    }
    
    func updateNeighbourhood (thisLocation: CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(thisLocation, completionHandler: {(placemarks, error) in
            if (error != nil) {
                println("reverse geodcode fail: \(error.localizedDescription)")
            }
            let pm = placemarks as! [CLPlacemark]
            if let placemark = pm.first {
                dispatch_async(dispatch_get_main_queue(), {
                    self.locationLabel.text = placemark.thoroughfare + ", " + placemark.subLocality
                })
            }
        })
    }
    
    func assignLocationToCurrentUser(thisLocation: CLLocation){
        let geoPoint = PFGeoPoint(latitude: thisLocation.coordinate.latitude, longitude: thisLocation.coordinate.longitude)
        if let user = PFUser.currentUser(){
            user["location"] = geoPoint
            user.saveInBackgroundWithBlock{(success: Bool, error:NSError?) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
