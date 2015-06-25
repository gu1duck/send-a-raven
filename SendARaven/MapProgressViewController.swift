//
//  MapProgressViewController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-25.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import MapKit

class MapProgressViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var origin: CLLocation!
    var raven: CLLocation!
    var destination: CLLocation!
    var sent: NSDate!
    var arrival: NSDate!
    var now: NSDate!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.layer.shadowColor = UIColor.blackColor().CGColor
        mapView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        mapView.layer.shadowOpacity = 0.6
        mapView.layer.shadowRadius = 2
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        
        
        sent = NSDate(timeIntervalSince1970: 1435255706)
        arrival = NSDate(timeIntervalSince1970: 1435262906)
        now = NSDate()
        
        let totalTime = arrival.timeIntervalSince1970 - sent.timeIntervalSince1970
        let elapsedTime = now.timeIntervalSince1970 - sent.timeIntervalSince1970
        let progress = elapsedTime / totalTime
        
        origin = CLLocation(latitude: 49.281930, longitude: -123.107901)
        destination = CLLocation(latitude: 49.285625, longitude: -123.111291)
        raven = CLLocation(latitude: origin.coordinate.latitude + (destination.coordinate.latitude - origin.coordinate.latitude) * progress, longitude: origin.coordinate.longitude + (destination.coordinate.longitude - origin.coordinate.longitude) * progress)
        
        
        var locations = [origin, raven, destination]
        
        var coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        
        var polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        mapView.addOverlay(polyline)
        
        for location in locations{
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
        }
        
        zoomMap(raven)
        
    
        
        
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var annotationView:MKAnnotationView!
        if annotation.coordinate.latitude == destination.coordinate.latitude && annotation.coordinate.longitude == destination.coordinate.longitude {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "destination")
            annotationView.image = UIImage(named:"tower")
            annotationView.centerOffset.y -= 25
        } else if annotation.coordinate.latitude == raven.coordinate.latitude && annotation.coordinate.longitude == raven.coordinate.longitude {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "raven")
            annotationView.image = UIImage(named:"ravenPin")
            annotationView.centerOffset.y -= 5
            annotationView.layer.shadowColor = UIColor.blackColor().CGColor
            annotationView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            annotationView.layer.shadowOpacity = 0.4
            annotationView.layer.shadowRadius = 1
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.ravenRed().colorWithAlphaComponent(0.5)
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zoomMap (thisLocation: CLLocation){
        var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let coordinateRegion = MKCoordinateRegion(center: thisLocation.coordinate, span: span);
        mapView.setRegion(coordinateRegion, animated:true)
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
