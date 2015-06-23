//
//  OnboardingMapView.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-23.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import MapKit

class OnboardingMapView: OnboardingView {
    var mapContainer: MKMapView?
    var locationLabel: UILabel?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMap()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMap()
    }

    func setupMap() {
        let mapView = MKMapView(frame: CGRectZero)
        imageContainer!.addSubview(mapView)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        mapContainer = mapView
        
        imageContainer!.addConstraint(NSLayoutConstraint(item: mapView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imageContainer!,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0))
        
        imageContainer!.addConstraint(NSLayoutConstraint(item: mapView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imageContainer!,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0))
        
        imageContainer!.addConstraint(NSLayoutConstraint(item: mapView,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imageContainer!,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1,
            constant: 0))
        
        imageContainer!.addConstraint(NSLayoutConstraint(item: mapView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imageContainer!,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0))
        
//        let locationLabel = UILabel(frame: CGRectZero)
//        contentView!.addSubview(locationLabel)
//        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.locationLabel = locationLabel
//        locationLabel.text = "here"
//        
//        contentView!.addConstraint(NSLayoutConstraint(item: locationLabel,
//            attribute: NSLayoutAttribute.Top,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: contentContainer!,
//            attribute: NSLayoutAttribute.Bottom,
//            multiplier: 1,
//            constant: 8))
//        
//        contentView!.addConstraint(NSLayoutConstraint(item: locationLabel,
//            attribute: NSLayoutAttribute.Left,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: contentView!,
//            attribute: NSLayoutAttribute.LeftMargin,
//            multiplier: 1.0,
//            constant: 0))
//        
//        contentView!.addConstraint(NSLayoutConstraint(item: locationLabel,
//            attribute: NSLayoutAttribute.Right,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: contentView!,
//            attribute: NSLayoutAttribute.RightMargin,
//            multiplier: 1,
//            constant: 0))
        
        let fade = UIImageView(frame: CGRectZero)
        mapView.addSubview(fade)
        fade.setTranslatesAutoresizingMaskIntoConstraints(false)
        fade.image = UIImage(named: "fade")
        
        mapView.addConstraint(NSLayoutConstraint(item: fade,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mapView,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0))
        
        mapView.addConstraint(NSLayoutConstraint(item: fade,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mapView,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0))
        
        mapView.addConstraint(NSLayoutConstraint(item: fade,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mapView,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1,
            constant: 0))
        
        mapView.addConstraint(NSLayoutConstraint(item: fade,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mapView,
            attribute: NSLayoutAttribute.Height,
            multiplier: 15/100,
            constant: 0))
        
    }
}
