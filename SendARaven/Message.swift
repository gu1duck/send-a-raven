//
//  Message.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-12.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import Foundation
import Parse




class Message: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Message"
    }
    
    @NSManaged var postContent: String
    @NSManaged var timeStamp: NSDate
    @NSManaged var postUsers: [PFUser]
 
    func otherUser () -> PFUser{
        if let user = PFUser.currentUser(){
            if self.postUsers[0] == user{
                return postUsers[1]
            }
        }
        return postUsers[0]
    }
}

