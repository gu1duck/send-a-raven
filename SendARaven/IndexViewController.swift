//
//  IndexViewController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-15.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MapKit

class IndexViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate, ParseIOControllerDelegate {
    
    @IBOutlet weak var newChatField: UITextField!
    var conversations = [Message]()
    let parseController = ParseIOController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newChatField.delegate  = self
        parseController.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let user = PFUser.currentUser(){
            PFInstallation.currentInstallation()["user"] = user
            if user["location"] == nil{
                if let pickLocation = self.storyboard?.instantiateViewControllerWithIdentifier("locationPicker") as? PickLocationViewController{
                    self.presentViewController(pickLocation, animated: true, completion: nil)
                }
            } else {
                parseController.getInforForIndexView([user], local: true, index: true)
                parseController.getInforForIndexView([user], local: false, index: true)
                self.tableView.reloadData()
            }
        } else {
            
            let onboardingController = OnboardingViewController()
            self.presentViewController(onboardingController, animated: true, completion: nil)
//            var loginController = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as? LoginViewController
//            self.presentViewController(loginController!, animated:true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func updateData(messages: [Message]) {
        conversations = messages
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! IndexCell
        
        let message = conversations[indexPath.row]
        
        let otherUser = message.otherUser()
        cell.label1!.text = otherUser.username
        cell.label2!.text = message.postContent

        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func newChat(sender: AnyObject) {
        self.newChatField.resignFirstResponder()
        if let userName = newChatField.text{
            let query = PFUser.query()
            query!.whereKey("username", equalTo:userName)
            if let otherUser = query?.getFirstObject() as? PFUser{
                let chatController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as? ChatViewController
                chatController?.otherUser = otherUser
                self.navigationController?.showViewController(chatController!, sender: self)
            } else {
                var alert = UIAlertController(title: "Oh No!", message: "That user doesn't exist!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetail" {
            let controller = segue.destinationViewController as? ChatViewController
            if let indexPath = tableView.indexPathForSelectedRow(){
                let message = conversations[indexPath.row]
                controller?.otherUser = message.otherUser()
            }
        }
    }
    
    //MARK: Parse SignUp
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser){
        self.dismissViewControllerAnimated(true, completion: nil)
        PFInstallation.currentInstallation()["user"] = user
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Parse Login
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool{
        self.dismissViewControllerAnimated(true, completion: nil)
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser){
        self.dismissViewControllerAnimated(true, completion: nil)
        parseController.getInforForIndexView([PFUser.currentUser()!], local: true, index: true)
        parseController.getInforForIndexView([PFUser.currentUser()!], local: false, index: true)
        self.tableView.reloadData()
        PFInstallation.currentInstallation()["user"] = user
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?){
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
