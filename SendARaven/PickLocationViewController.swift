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

protocol PickLocationViewControllerDelegate{
    func pickLocationViewControllerSaved(controller: PickLocationViewController, locationString: String)
}

class PickLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    let locationManager = CLLocationManager()
    var initialLocation = false
    var location:CLLocation?
    var annotation:MKAnnotation?
    var circularRegion: CLCircularRegion?
    var locationString: String?
    var delegate: PickLocationViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton(okButton)
        setupButton(backButton)
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if let user = PFUser.currentUser(){
            if let userLocation = user["location"] as? PFGeoPoint{
                location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location!.coordinate
                self.annotation = annotation
                self.zoomMap(location!)
                mapView.addAnnotation(annotation)
                self.updateNeighbourhood(location!)
            } else {
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
                backButton.hidden = true
            }
        }
        mapView.delegate = self
        
        let tapRecogniser = UITapGestureRecognizer(target: self, action: "addPin:")
        mapView.addGestureRecognizer(tapRecogniser);
    }

    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func okButton(sender: AnyObject) {
        if let finalLocation = location {
            self.assignLocationToCurrentUser(finalLocation)
        }
        if let finalRegion = circularRegion {
            locationManager.startMonitoringForRegion(circularRegion)
        }
        delegate?.pickLocationViewControllerSaved(self, locationString: locationString!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupButton(button: UIButton){
        button.layer.cornerRadius = okButton.frame.size.width/2
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2.0
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPin(tapRecognizer: UITapGestureRecognizer){
        mapView.removeAnnotation(self.annotation)
        mapView.showsUserLocation = false
        let tappedLocation = mapView.convertPoint(tapRecognizer.locationInView(mapView), toCoordinateFromView: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = tappedLocation
        self.annotation = annotation
        location = CLLocation(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude)
        self.updateNeighbourhood(location!)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "tower")
            annotationView.image = UIImage(named:"tower")
            annotationView.centerOffset.y -= 25
        return annotationView
    }
    

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let thisLocation = locations.first as? CLLocation{
            if initialLocation == false {
                location = thisLocation
                self.zoomMap(thisLocation)
                initialLocation = true
                locationManager.stopUpdatingLocation()
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
                    var description = ""
                    if placemark.thoroughfare != nil {
                       description += placemark.thoroughfare
                        if placemark.subLocality != nil{
                            description += ", "
                        }
                    }
                    if placemark.subLocality != nil{
                        description += placemark.subLocality
                    }
                    self.locationLabel.text = description
                    self.locationString = description
                })
            }
        })
    }
    
    func assignLocationToCurrentUser(thisLocation: CLLocation){
        let geoPoint = PFGeoPoint(latitude: thisLocation.coordinate.latitude, longitude: thisLocation.coordinate.longitude)
        if let user = PFUser.currentUser(){
            user["locationString"] = locationString
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
