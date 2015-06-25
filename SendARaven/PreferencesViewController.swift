//
//  PreferencesViewController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-24.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import Parse

class PreferencesViewController: UITableViewController, UITableViewDelegate, PickLocationViewControllerDelegate {

    @IBOutlet var headerImage: UIImageView!
    @IBOutlet weak var rookeryLocation: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    var locationString: String?
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerSize = CGSizeMake(view.frame.size.width, view.frame.size.width * 2/3)
        headerImage.frame.size = headerSize
        headerImage.userInteractionEnabled = true
        setupButtons()
        
        if let user = PFUser.currentUser() {
            locationString = user["locationString"] as? String
            rookeryLocation.text = locationString
            emailField.text = user["email"] as? String
            user.fetchIfNeededInBackground()
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        rookeryLocation.text = locationString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupButtons(){
        let cancelButton = UIButton(frame: CGRectZero)
        headerImage.addSubview(cancelButton)
        let cancelRect = CGRectMake(8, headerImage.frame.size.height-58, 50, 50)
        cancelButton.frame = cancelRect
        cancelButton.setImage(UIImage(named: "x"), forState: UIControlState.Normal)
        cancelButton.backgroundColor = UIColor.ravenRed()
        cancelButton.layer.cornerRadius = cancelButton.frame.size.width/2
        cancelButton.addTarget(self, action: "cancelButtonPressed:", forControlEvents:.TouchUpInside)
        cancelButton.layer.shadowColor = UIColor.blackColor().CGColor
        cancelButton.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        cancelButton.layer.shadowOpacity = 0.2
        cancelButton.layer.shadowRadius = 2.0
        
        let confirmButton = UIButton(frame: CGRectZero)
        headerImage.addSubview(confirmButton)
        let confirmRect = CGRectMake(headerImage.frame.size.width-58, headerImage.frame.size.height-58, 50, 50)
        confirmButton.frame = confirmRect
        confirmButton.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        confirmButton.backgroundColor = UIColor.ravenGreen()
        confirmButton.layer.cornerRadius = cancelButton.frame.size.width/2
        confirmButton.addTarget(self, action: "confirmButtonPressed:", forControlEvents:.TouchUpInside)
        confirmButton.layer.shadowColor = UIColor.blackColor().CGColor
        confirmButton.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        confirmButton.layer.shadowOpacity = 0.2
        confirmButton.layer.shadowRadius = 2.0

    }
    
    func cancelButtonPressed(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirmButtonPressed(sender: UIButton){
        if let user = PFUser.currentUser(){
            if newPasswordField.text != confirmPasswordField.text{
                var alert = UIAlertController(title: "Oh No!", message: "Passwords don't match", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                user["email"] = emailField.text
                user["username"] = emailField.text
                if newPasswordField.text != "" {
                    user["password"] = newPasswordField.text
                }
                user.saveInBackground()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func pickLocationViewControllerSaved(controller: PickLocationViewController, locationString: String) {
        self.locationString = locationString
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pickLocation"{
            let destination = segue.destinationViewController as? PickLocationViewController
            destination?.delegate = self
        }
    }
    
    
}
