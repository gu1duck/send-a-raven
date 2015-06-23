//
//  OnboardingViewController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-22.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        bodyView.headerContainer?.text = "Create a Rookery"
        bodyView.contentContainer?.text = "In order to use the app, you'll need to set up a rookery wher you can receive ravens. This requires that you enable location services on the next card."
        
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
        
        let bodyView2 = UIView(frame: view.bounds)
        scrollView.addSubview(bodyView2)
        bodyView2.setTranslatesAutoresizingMaskIntoConstraints(false)
        bodyView2.backgroundColor = UIColor.blueColor()
        
        scrollView.addConstraint(NSLayoutConstraint(item: bodyView2,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: bodyView,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1.0,
            constant: 0))
        
        scrollView.addConstraint(NSLayoutConstraint(item: bodyView2,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: bodyView,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0))
        
        scrollView.addConstraint(NSLayoutConstraint(item: bodyView2,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: bodyView,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0))
        
        scrollView.addConstraint(NSLayoutConstraint(item: bodyView2,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: bodyView,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0))

        scrollView.addConstraint(NSLayoutConstraint(item: bodyView2,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: scrollView,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0))


        
        

        // Do any additional setup after loading the view.
    }

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
