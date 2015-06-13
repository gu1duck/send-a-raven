//
//  Message.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-12.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit

class Message: NSObject {
    let content: String
    let timeStamp:NSDate
    let sender:String
    
    init(content:String, timeStamp:NSDate, sender:String){
        self.content = content
        self.timeStamp = timeStamp
        self.sender = sender
    }
}

