//
//  ChatViewController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-12.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var textEntryBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonRightMargin: NSLayoutConstraint!
    
    @IBOutlet weak var textHeight: NSLayoutConstraint!
    var textViewIsEmpty = true
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let kTextInputHeight = 56.0
    
    var messages = [Message]()
    
    var otherUser: PFUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(CGFloat(kTextInputHeight), 0.0, 0.0, 0.0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGFloat(kTextInputHeight), 0.0, 0.0, 0.0)
        
        var query = PFUser.query()
        query?.whereKey("username", equalTo: "user1")
        query?.findObjectsInBackgroundWithBlock({ (results:[AnyObject]?, error:NSError?) -> Void in
            if let queryUser = results!.first as? PFUser{
                self.otherUser = queryUser
                self.updateTableViewLocallyAndRemotely()
                
                /*
                var messageQuery = Message.query()
                messageQuery?.fromLocalDatastore()
                messageQuery?.whereKey("postUsers", containsAllObjectsInArray: [PFUser.currentUser()!, self.otherUser!])
                messageQuery?.orderByDescending("timeStamp")
                messageQuery?.findObjectsInBackgroundWithBlock({ (results:[AnyObject]?, error:NSError?) -> Void in
                    if let messageResults = results as? [Message]{
                        PFObject.pinAllInBackground(messageResults)
                        self.messages = messageResults
                        self.tableView.reloadData()
                
                    }
                })
                */
            }
        })
       
        //Text input setup
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 0.5
        submitButton.layer.cornerRadius = submitButton.frame.size.width/2

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        
        cell.setupWithMessage(message)
        
        return cell

    }
    
    //MARK TextView Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textField.text == "Send a message"{
            textField.text = ""
            textField.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textField.text == "" {
            textField.text = "Send a message"
            textField.textColor = UIColor.lightGrayColor()
        }
    }

    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textHeight.constant < 86{
            textField.scrollEnabled = false
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if textField.text != "" && textViewIsEmpty == true{
            textViewIsEmpty = false
            buttonRightMargin.constant = 8
            UIView.animateWithDuration(
                0.2,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {self.view.layoutIfNeeded()},
                completion: nil)
        }
        
        if textField.text == "" && textViewIsEmpty == false{
            textViewIsEmpty = true
            buttonRightMargin.constant = -33
            UIView.animateWithDuration(
                0.2,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {self.view.layoutIfNeeded()},
                completion: nil)
        }
        
        let sizeBefore = textField.frame.size.height
        var sizeThatShouldFitTheContent: CGSize = textField.sizeThatFits(textField.frame.size)
        let desiredHeight = Float(sizeThatShouldFitTheContent.height)
        if (desiredHeight < 109){
            textHeight.constant = sizeThatShouldFitTheContent.height
            var fixedWidth: CGFloat = textField.frame.size.width
            var size:CGSize = CGSize(width: fixedWidth,height: CGFloat.max)
            var newSize: CGSize = textField.sizeThatFits(CGSizeMake(fixedWidth, CGFloat.max))
            var newFrame: CGRect = textField.frame
            newFrame.size = CGSizeMake(CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), newSize.height)
            textField.frame = newFrame
        }
        textField.scrollEnabled = true
        
    }
    
    //MARK: Keyboard notification methods

    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        self.textEntryBottomMargin.constant = keyboardHeight
        let offset = tableView.contentOffset
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.tableView.contentInset = UIEdgeInsetsMake(CGFloat(self.kTextInputHeight)+keyboardHeight, 0.0, 0.0, 0.0)
                self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGFloat(self.kTextInputHeight)+keyboardHeight, 0.0, 0.0, 0.0)
                self.view.layoutIfNeeded()
                self.tableView.contentOffset.y = offset.y - keyboardHeight
                
            },
            completion: nil)
    }
    

    func keyboardWillHide(notification:NSNotification){
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        self.textEntryBottomMargin.constant = 0
        let offset = tableView.contentOffset
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.tableView.contentInset = UIEdgeInsetsMake(CGFloat(self.kTextInputHeight), 0.0, 0.0, 0.0)
                self.view.layoutIfNeeded()
                self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGFloat(self.kTextInputHeight), 0.0, 0.0, 0.0)
                self.tableView.contentOffset.y = offset.y + keyboardHeight
            },
            completion: nil)
    }
    
    @IBAction func submitMessage(sender: AnyObject) {
        textField.editable = false
        submitButton.enabled = false
        let message = Message()
        message.postContent = textField.text
        message.timeStamp = NSDate()
        message.postUsers = [PFUser.currentUser()!, self.otherUser!]
        message.pin()
        message.saveEventually()
        messages = [message] + messages
        tableView.reloadData()
        self.textField.resignFirstResponder()
        self.textField.text = ""
        textField.editable = true
        submitButton.enabled = true
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    func updateTableViewLocallyAndRemotely(){
        var localQuery = Message.query()
        localQuery?.fromLocalDatastore()
        localQuery?.whereKey("postUsers", containsAllObjectsInArray: [PFUser.currentUser()!, self.otherUser!])
        localQuery?.orderByDescending("timeStamp")
        localQuery?.findObjectsInBackgroundWithBlock({ (results:[AnyObject]?, error:NSError?) -> Void in
            if let messageResults = results as? [Message]{
                self.messages = messageResults
                self.tableView.reloadData()
                self.updateTableViewWithOnlineQuery()
            }
        })
    }
    
    func updateTableViewWithOnlineQuery(){
        var onlineQuery = Message.query()
        onlineQuery?.whereKey("postUsers", containsAllObjectsInArray: [PFUser.currentUser()!, self.otherUser!])
        onlineQuery?.countObjectsInBackgroundWithBlock({ (count:Int32, error:NSError?) -> Void in
            if Int(count) != self.messages.count{
                onlineQuery?.orderByDescending("timeStamp")
                onlineQuery?.findObjectsInBackgroundWithBlock({ (results:[AnyObject]?, error:NSError?) -> Void in
                    if let messageResults = results as? [Message]{
                        self.messages = messageResults
                        self.tableView.reloadData()
                        PFObject.pinAllInBackground(messageResults)
                    }
                })
            }
        })
    }
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    

