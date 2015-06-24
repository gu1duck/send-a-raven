//
//  LoginViewController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmPasswordField: LoginTextField!
    @IBOutlet weak var passwordField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var SignUpY: NSLayoutConstraint!
    @IBOutlet weak var LoginY: NSLayoutConstraint!
    @IBOutlet weak var signupHeight: NSLayoutConstraint!
    @IBOutlet weak var loginHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    var signupMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPasswordField.hidden = true
        confirmPasswordField.alpha = 0
        loginButton.clipsToBounds = true
        signupButton.clipsToBounds = true
        loginButton.alpha = 0
        signupButton.alpha = 0
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        titleLabel.layer.shadowColor = UIColor.raven().CGColor
        titleLabel.layer.shadowOffset = CGSizeZero
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowRadius = 2
    }
    
    @IBAction func signupButton(sender: AnyObject)
    {
        self.view.endEditing(true)
        if signupMode{
            
            let destination = passwordField.frame
            self.SignUpY.constant -= 28
            self.LoginY.constant -= 28
            self.signupHeight.constant += 20
            self.loginHeight.constant += 20
            
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.confirmPasswordField.alpha = 0
                self.confirmPasswordField.frame = destination
                self.view.layoutIfNeeded()
                self.signupButton.layer.cornerRadius += 10
                self.loginButton.layer.cornerRadius += 10
                self.loginButton.backgroundColor = UIColor.whiteColor()
                self.signupButton.backgroundColor = UIColor.lightGrayColor()
                self.signupButton.setImage(nil, forState: UIControlState.Normal)
                self.loginButton.setImage(nil, forState: UIControlState.Normal)
                self.signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
                self.loginButton.setTitle("Login", forState: UIControlState.Normal)
                }, completion: { (Bool) -> Void in
                self.confirmPasswordField.hidden = true
            })
        } else {
            let destination = confirmPasswordField.frame
            confirmPasswordField.frame = passwordField.frame
            self.SignUpY.constant += 28
            self.LoginY.constant += 28
            self.signupHeight.constant -= 20
            self.loginHeight.constant -= 20
            confirmPasswordField.hidden = false
            self.signupButton.setTitle("", forState: UIControlState.Normal)
            self.loginButton.setTitle("", forState: UIControlState.Normal)
            
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.confirmPasswordField.alpha = 1
                self.confirmPasswordField.frame = destination
                self.view.layoutIfNeeded()
                self.signupButton.layer.cornerRadius -= 10
                self.loginButton.layer.cornerRadius -= 10
                self.loginButton.backgroundColor = UIColor(red: 52/256, green: 213/256, blue: 112/256, alpha: 1)
                self.signupButton.backgroundColor = UIColor(red: 245/256, green: 91/256, blue: 91/256, alpha: 1)
                self.signupButton.setImage(UIImage(named:"x"), forState: UIControlState.Normal)
                self.loginButton.setImage(UIImage(named:"check"), forState: UIControlState.Normal)
                }, completion: nil)
        }
        signupMode = !signupMode
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        self.view.endEditing(true)
        if signupMode{
            if passwordField.text == confirmPasswordField.text {
                var user = PFUser()
                user.username = emailField.text
                user.password = passwordField.text
                user.email = emailField.text
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo?["error"] as? String
                        let alert = UIAlertController(title: "Oops", message: errorString!, preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelAction = UIAlertAction(title: "Darn", style: .Cancel) { (action) in
                        }
                        alert.addAction(cancelAction)
                        self.showViewController(alert, sender: self)
                    } else {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            } else {
                let alert = UIAlertController(title: "Oops", message: "Passwords don't match!", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "Darn", style: .Cancel) { (action) in
                }
                alert.addAction(cancelAction)
                self.showViewController(alert, sender: self)
            }
        } else  {
            PFUser.logInWithUsernameInBackground(emailField.text, password:passwordField.text) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    if let thisError = error{
            
                        let alert = UIAlertController(title: "Oops", message: thisError.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelAction = UIAlertAction(title: "Darn", style: .Cancel) { (action) in
                            
                        }
                        alert.addAction(cancelAction)
                        self.showViewController(alert, sender: self)
                    }
                }
            }
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        signupButton.layer.cornerRadius = loginButton.frame.size.height/2
        var signUpYFrame = signupButton.frame
        var loginYFrame = loginButton.frame
        var signUpDest = signupButton.frame
        var loginDest = loginButton.frame
        signUpYFrame.origin.y = view.frame.size.height
        loginYFrame.origin.y = view.frame.size.height
        signupButton.frame = signUpYFrame
        loginButton.frame = loginYFrame
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.signupButton.frame = signUpDest
            self.loginButton.frame = loginDest
            self.signupButton.alpha = 1
            self.loginButton.alpha = 1
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        signupButton.layer.cornerRadius = loginButton.frame.size.height/2
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            if signupMode {
                confirmPasswordField.becomeFirstResponder()
            } else {
                passwordField.resignFirstResponder()
            }
        }else if textField == confirmPasswordField{
            confirmPasswordField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.frame.origin.y + textField.frame.size.height > self.view.frame.height * 0.4{
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                var frameUp = self.view.frame
                frameUp.origin.y = -textField.frame.origin.y/2
                self.view.frame = frameUp
            })
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.frame = UIScreen.mainScreen().bounds
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
