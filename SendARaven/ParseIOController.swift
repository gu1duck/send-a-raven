//
//  ParseIOController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-19.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import Parse

protocol ParseIOControllerDelegate {
    func updateUIWithData([Message])
}

class ParseIOController: NSObject {

    var delegate: ParseIOControllerDelegate?
    var messageCount: Int
    
    override init() {
        messageCount = 0
    }
    
    func getInforForIndexView(targets: [PFUser], local: Bool, index: Bool){
        if let user = PFUser.currentUser(){
            let query = Message.query()!
            if local{
                query.fromLocalDatastore()
            }
            query.whereKey("postUsers", containsAllObjectsInArray: targets)
            query.countObjectsInBackgroundWithBlock({ (count:Int32, error:NSError?) -> Void in
                if Int(count) != self.messageCount{
                    
                    query.orderByDescending("timeStamp")
                    query.findObjectsInBackgroundWithBlock({ (results:[AnyObject]?, error:NSError?) -> Void in
                        if let messageResults = results as? [Message]{
                            
                            var filteredResults = self.filterUnreceivedMessages(messageResults, setTimer: !local)
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() in
                                if index {
                                    filteredResults = self.filterOneMessagePerPartner(filteredResults)
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), {() in
                                    if !local{
                                        Message.pinAllInBackground(messageResults)
                                    }
                                    self.delegate?.updateUIWithData(filteredResults)
                                })
                            })
                        }
                    })
                }
            })
        }
    }
    
    func filterUnreceivedMessages(messages:[Message], setTimer: Bool) -> [Message]{
        var filteredMessages = [Message]()
        for message in messages{
            if message.postUsers[0] == PFUser.currentUser() || message.arrivalTime.timeIntervalSinceNow <= 0{
                filteredMessages.append(message)
            } else if setTimer {
                let localNotification = UILocalNotification()
                localNotification.fireDate = message.arrivalTime
                localNotification.alertBody = "A raven has arrived at your rookery!"
                localNotification.soundName = "squack.mp3"
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            }
        }
        return filteredMessages
    }
    
    //This function potentially fetches a bunch of information.
    //BACKGROUND THREAD ONLY
    func filterOneMessagePerPartner(messages:[Message]) -> [Message]{
        var partners = Set([PFUser]())
        var filteredMessages = [Message]()
        for message in messages {
            let otherUser = message.otherUser()
            otherUser.fetchIfNeeded()
            if partners.contains(otherUser) == false{
                partners.insert(otherUser)
                filteredMessages.append(message)
            }
        }
        return filteredMessages
    }
}
