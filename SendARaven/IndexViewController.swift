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

extension Array {
    func contains<T:Equatable>(query:T)->Bool{
        for object in self {
            if object as? T == query {
                return true
            }
        }
        return false
    }
}

class IndexViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var newChatField: UITextField!
    var conversations = [Message]()
    
    override func viewDidAppear(animated: Bool) {
        
        if let user = PFUser.currentUser(){
            if user["location"] == nil{
                if let pickLocation = self.storyboard?.instantiateViewControllerWithIdentifier("locationPicker") as? PickLocationViewController{
                    self.presentViewController(pickLocation, animated: true, completion: nil)
                }
            } else {
                self.updateTableViewLocallyAndRemotely()
            }
        } else {
            var logInController = PFLogInViewController()
            logInController.delegate = self
            logInController.signUpController?.delegate = self
            self.presentViewController(logInController, animated:true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newChatField.delegate  = self
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func updateTableViewLocallyAndRemotely(){
        if let user = PFUser.currentUser(){
            var localQuery = Message.query()
            localQuery?.fromLocalDatastore()
            localQuery?.whereKey("postUsers", containsAllObjectsInArray: [user])
            localQuery?.orderByDescending("timeStamp")
            localQuery?.findObjectsInBackgroundWithBlock({ (results:[AnyObject]?, error:NSError?) -> Void in
                if let messageResults = results as? [Message]{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() in
                        var partners = [PFUser]()
                        var updatedConversations = [Message]()
                        for message in messageResults {
                            let otherUser = message.otherUser()
                            otherUser.fetch()
                            if partners.contains(otherUser) == false{
                                partners.append(otherUser)
                                updatedConversations.append(message)
                            }
                        }
                        self.conversations = updatedConversations
                        dispatch_async(dispatch_get_main_queue(), {() in
                            self.tableView.reloadData()
                        })
                    })
                    self.updateTableViewWithOnlineQuery(messageResults.count)
                }
            })
        }
    }
    
    func updateTableViewWithOnlineQuery(offlineCount:Int){
        var onlineQuery = Message.query()
        onlineQuery?.whereKey("postUsers", containsAllObjectsInArray: [PFUser.currentUser()!])
        onlineQuery?.countObjectsInBackgroundWithBlock({ (count:Int32, error:NSError?) -> Void in
            if Int(count) != offlineCount{
                onlineQuery?.orderByDescending("timeStamp")
                onlineQuery?.findObjectsInBackgroundWithBlock({ (results:[AnyObject]?, error:NSError?) -> Void in
                    if let messageResults = results as? [Message]{
                        if let messageResults = results as? [Message]{
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() in
                                var partners = [PFUser]()
                                var updatedConversations = [Message]()
                                for message in messageResults {
                                    let otherUser = message.otherUser()
                                    otherUser.fetch()
                                    if partners.contains(otherUser) == false{
                                        partners.append(otherUser)
                                        updatedConversations.append(message)
                                    }
                                }
                                self.conversations = updatedConversations
                                PFObject.pinAllInBackground(updatedConversations)
                                dispatch_async(dispatch_get_main_queue(), {() in
                                    self.tableView.reloadData()
                                })
                            })
                        }
                    }
                })
            }
        })
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
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
