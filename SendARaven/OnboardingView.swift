//
//  OnboardingView.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-22.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit

class OnboardingView: UIView {
    
    var headerContainer: UILabel?
    var contentContainer: UILabel?
    var imageContainer: UIImageView?
    var contentView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        let blur = UIView(frame: CGRectZero)
        self.addSubview(blur)
        blur.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addConstraint(NSLayoutConstraint(item: blur,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: blur,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: blur,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: blur,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0))
        
        let contentView = UIView(frame: CGRectZero)
        blur.addSubview(contentView)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.layer.cornerRadius = 20.0
        contentView.layer.masksToBounds = true
        self.contentView = contentView
        
        blur.addConstraint(NSLayoutConstraint(item: contentView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: blur,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.8,
            constant: 0))
        
        blur.addConstraint(NSLayoutConstraint(item: contentView,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: blur,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0))
        
        blur.addConstraint(NSLayoutConstraint(item: contentView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.Width,
            multiplier: 960/640,
            constant: 0))
        
        blur.addConstraint(NSLayoutConstraint(item: contentView,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: blur,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0,
            constant: 0))
        
        let imageView = UIImageView(frame: CGRectZero)
        contentView.addSubview(imageView)
        imageView.backgroundColor = UIColor.blueColor()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        imageView.image = UIImage(named: "rookery")
        
        imageContainer = imageView

        
        contentView.addConstraint(NSLayoutConstraint(item: imageView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1,
            constant: 0))

        contentView.addConstraint(NSLayoutConstraint(item: imageView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1,
            constant: 0))
        
        
        let fade = UIImageView(frame: CGRectZero)
        imageView.addSubview(fade)
        fade.setTranslatesAutoresizingMaskIntoConstraints(false)
        fade.image = UIImage(named: "fade")
        
        imageView.addConstraint(NSLayoutConstraint(item: fade,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imageView,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0))
        
        imageView.addConstraint(NSLayoutConstraint(item: fade,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imageView,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0))
        
        imageView.addConstraint(NSLayoutConstraint(item: fade,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imageView,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1,
            constant: 0))
        
        imageView.addConstraint(NSLayoutConstraint(item: fade,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imageView,
            attribute: NSLayoutAttribute.Height,
            multiplier: 15/100,
            constant: 0))
        
        let headerLabel = UILabel(frame: CGRectZero)
        contentView.addSubview(headerLabel)
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.text = "Header"
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.font = UIFont(name: "Avenir-Medium", size: 24)
        
        headerContainer = headerLabel
        
        contentView.addConstraint(NSLayoutConstraint(item: headerLabel,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imageView,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: headerLabel,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.LeftMargin,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: headerLabel,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.RightMargin,
            multiplier: 1,
            constant: 0))
        
        let contentLabel = UILabel(frame: CGRectZero)
        contentView.addSubview(contentLabel)
        contentLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentLabel.text = "content"
        contentLabel.textAlignment = NSTextAlignment.Center
        contentLabel.font = UIFont(name: "Avenir", size: 14)
        contentLabel.numberOfLines = 0
        
        contentContainer = contentLabel
        
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: headerLabel,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.LeftMargin,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.RightMargin,
            multiplier: 1,
            constant: 0))



        
    }

}
