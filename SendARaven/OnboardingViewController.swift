//
//  OnboardingViewController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-22.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import MapKit
import Parse

protocol OnboardingViewControllerDelegate {
    func onboardingViewControllerDismissed(controller: OnboardingViewController)
}

class OnboardingViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate {
    
//    weak var mapView: MKMapView?
    
    let locationManager = CLLocationManager()
//    var initialLocation = false
//    var location:CLLocation?
//    var locationLabel: UILabel?
    
    var delegate: OnboardingViewControllerDelegate?
    
    var scrollView: UIScrollView?
    var pageControl: UIPageControl?

    override func viewDidLoad() {
        if let user = PFUser.currentUser(){
            user["onboarded"] = true
            user.saveInBackground()
        }
        super.viewDidLoad()
        locationManager.delegate = self
        //locationManager.startUpdatingLocation()
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        view.addSubview(blur)
        blur.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addConstraint(NSLayoutConstraint(item: blur,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: blur,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: blur,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: blur,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0))

        
        let scrollView = UIScrollView(frame: CGRectZero)
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.pagingEnabled = true
        blur.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        self.scrollView = scrollView
        
        blur.addConstraint(NSLayoutConstraint(item: scrollView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: blur,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0))
        
        blur.addConstraint(NSLayoutConstraint(item: scrollView,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: blur,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0))
        
        blur.addConstraint(NSLayoutConstraint(item: scrollView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: blur,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0))
        
        blur.addConstraint(NSLayoutConstraint(item: scrollView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: blur,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0))
        
        let bodyView = OnboardingView(frame: CGRectZero)
        bodyView.imageContainer?.image = UIImage(named: "raven-flight")
        bodyView.headerContainer?.text = "Prepare for Ravens"
        bodyView.contentContainer?.text = "Send-A-Raven delivers images at the speed of actual ravens. If you enable push notifications when prompted, you will be informed when they arrive."
        
        scrollView.addSubview(bodyView)
        bodyView.setTranslatesAutoresizingMaskIntoConstraints(false)
        bodyView.userInteractionEnabled = true
        
        scrollView.addConstraint(NSLayoutConstraint(item: bodyView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: scrollView,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1.0,
            constant: 0))
        
        scrollView.addConstraint(NSLayoutConstraint(item: bodyView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: scrollView,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0))
        
        scrollView.addConstraint(NSLayoutConstraint(item: bodyView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: scrollView,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0))
        
        scrollView.addConstraint(NSLayoutConstraint(item: bodyView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: scrollView,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0))
        
        let bodyView2 = OnboardingView(frame: CGRectZero)
        placeView(bodyView2, toRightOf: bodyView)
        bodyView2.imageContainer?.image = UIImage(named: "map")
        bodyView2.headerContainer?.text = "Location Services"
        bodyView2.contentContainer?.text = "To calculate delivery speeds, the app needs to know your location. To use the app, Select 'Yes' when prompted. Your present location is never shared."
        
        let bodyView3 = OnboardingView(frame: CGRectZero)
        placeView(bodyView3, toRightOf: bodyView2)
        bodyView3.headerContainer?.text = "Place A Rookery"
        bodyView3.contentContainer?.text = "Messages sent to you will be delivered to a location you declare as your rookery. They will be delivered to you when you go there. Your rookery's location is public, so don't use your home."
        
        let endCap = UIView(frame: CGRectZero)
        placeView(endCap, toRightOf: bodyView3)
        
//        let bodyView4 = newMapViewToRightOfView(bodyView3)
//        bodyView4.headerContainer?.text = "Place A Rookery"
//        bodyView4.contentContainer?.text = "Travel to your rookery and tap Ok to set it."
//        //bodyView4.locationLabel?.text = "here"
//        mapView = bodyView4.mapContainer
//        locationLabel = bodyView4.locationLabel
//        //mapView!.showsUserLocation = true

        
        scrollView.addConstraint(NSLayoutConstraint(item: endCap,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: scrollView,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0))
        

        var pageControl = UIPageControl()
        blur.addSubview(pageControl)
        
        //blur.bringSubviewToFront(pageControl)
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.numberOfPages = 3;
        self.pageControl = pageControl;
        
        blur.addConstraint(NSLayoutConstraint(item: pageControl,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: blur,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: -10))
        
        blur.addConstraint(NSLayoutConstraint(item: pageControl,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: blur,
            attribute: NSLayoutAttribute.BottomMargin,
            multiplier: 1.0,
            constant: 0))
        
        let closeIndicator = UIImageView(image: UIImage(named: "x"))
        blur.addSubview(closeIndicator)
        closeIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        closeIndicator.alpha = 0.2
        
        blur.addConstraint(NSLayoutConstraint(item: closeIndicator,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: pageControl,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0,
            constant: 0))
        
        blur.addConstraint(NSLayoutConstraint(item: closeIndicator,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: pageControl,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 4))
        
        blur.addConstraint(NSLayoutConstraint(item: closeIndicator,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 16))
        
        blur.addConstraint(NSLayoutConstraint(item: closeIndicator,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: closeIndicator,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0))


    }
    
    func placeView(bodyView2: UIView, toRightOf: UIView) {
        scrollView!.addSubview(bodyView2)
        bodyView2.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        scrollView!.addConstraint(NSLayoutConstraint(item: bodyView2,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: toRightOf,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1.0,
            constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: bodyView2,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: toRightOf,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: bodyView2,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: toRightOf,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0))
        
        scrollView!.addConstraint(NSLayoutConstraint(item: bodyView2,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: toRightOf,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0))
        }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= self.view.frame.size
            .width{
                let userNotificationTypes = (UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound)
                let userNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
                let application = UIApplication .sharedApplication()
                application.registerUserNotificationSettings(userNotificationSettings)
                application.registerForRemoteNotifications()
        }
        if scrollView.contentOffset.x >= 2 * self.view.frame.size
            .width{
                
                locationManager.requestAlwaysAuthorization()
        }
        if scrollView.contentOffset.x >= 11/4 * self.view.frame.size
            .width{
                
//                self.dismissViewControllerAnimated(true, completion: nil)
                delegate?.onboardingViewControllerDismissed(self)
        }

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = Double(scrollView.contentOffset.x)
        let width = Double(view.frame.size.width)
        let intPage = Int(offset/width)
        pageControl!.currentPage = intPage
    }
    
//    func newMapViewToRightOfView(bodyView:OnboardingView) -> OnboardingMapView{
//        let bodyView2 = OnboardingMapView(frame: view.bounds)
//        scrollView!.addSubview(bodyView2)
//        bodyView2.setTranslatesAutoresizingMaskIntoConstraints(false)
//        
//        scrollView!.addConstraint(NSLayoutConstraint(item: bodyView2,
//            attribute: NSLayoutAttribute.Width,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: bodyView,
//            attribute: NSLayoutAttribute.Width,
//            multiplier: 1.0,
//            constant: 0))
//        
//        scrollView!.addConstraint(NSLayoutConstraint(item: bodyView2,
//            attribute: NSLayoutAttribute.Height,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: bodyView,
//            attribute: NSLayoutAttribute.Height,
//            multiplier: 1.0,
//            constant: 0))
//        
//        scrollView!.addConstraint(NSLayoutConstraint(item: bodyView2,
//            attribute: NSLayoutAttribute.Left,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: bodyView,
//            attribute: NSLayoutAttribute.Right,
//            multiplier: 1.0,
//            constant: 0))
//        
//        scrollView!.addConstraint(NSLayoutConstraint(item: bodyView2,
//            attribute: NSLayoutAttribute.Top,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: bodyView,
//            attribute: NSLayoutAttribute.Top,
//            multiplier: 1.0,
//            constant: 0))
//        
//        return bodyView2
//        
//    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        if let thisLocation = locations.first as? CLLocation{
//            if initialLocation == false && mapView != nil {
//                location = thisLocation
//                let circularRegion = CLCircularRegion(center: thisLocation.coordinate, radius: CLLocationDistance(50), identifier: "here")
//                self.zoomMap(thisLocation)
//                initialLocation = true
//                locationManager.stopUpdatingLocation()
//                self.updateNeighbourhood(thisLocation)
//            }
//        }
//    }

//    func zoomMap (thisLocation: CLLocation){
//        var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        let coordinateRegion = MKCoordinateRegion(center: thisLocation.coordinate, span: span);
//        mapView?.setRegion(coordinateRegion, animated:true)
//    }
//    
//    func updateNeighbourhood (thisLocation: CLLocation){
//        let geoCoder = CLGeocoder()
//        geoCoder.reverseGeocodeLocation(thisLocation, completionHandler: {(placemarks, error) in
//            if (error != nil) {
//                println("reverse geodcode fail: \(error.localizedDescription)")
//            }
//            let pm = placemarks as! [CLPlacemark]
//            if let placemark = pm.first {
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.locationLabel!.text = placemark.thoroughfare + ", " + placemark.subLocality
//                })
//            }
//        })
//    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    func setup(){
        self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
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
