//
//  MessageCell.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-12.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit
import Parse

class MessageCell: UITableViewCell {

    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentCenterConstraint: NSLayoutConstraint!
    
    var extraConstraint: NSLayoutConstraint?
    
    var dateFormatter:NSDateFormatter?
    var dateComponentsFormatter:NSDateComponentsFormatter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithMessage(message: Message){
        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        
        
        
        
        contentLabel.text = message.postContent
        contentContainer.layer.cornerRadius = 15
        if self.dateFormatter == nil{
            dateFormatter = NSDateFormatter()
            dateFormatter!.timeStyle = NSDateFormatterStyle.NoStyle
            dateFormatter!.dateFormat = "MMM d, h:mm a"
        }
        
        if message.arrivalTime.timeIntervalSinceNow > 0.0 {
            let arrivalString = self.dateFormatter!.stringFromDate(message.arrivalTime)
            timeStampLabel.text = "Will be delivered around \(arrivalString)"
            self.contentContainer.alpha = 0.5
        } else {
            
            timeStampLabel.text = self.dateFormatter!.stringFromDate(message.timeStamp)
            self.contentContainer.alpha = 1.0
        }
            
        
        contentView.addConstraint(NSLayoutConstraint(
            item: contentContainer,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.LessThanOrEqual,
            toItem: contentView,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.6,
            constant: 0.0))
        
        if (contentCenterConstraint != nil){
            contentView.removeConstraint(contentCenterConstraint)
        }
        
        if message.postUsers.first == PFUser.currentUser(){
            contentContainer.backgroundColor = UIColor.raven()
            
            let rightConstraint = NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: contentView,
                attribute: NSLayoutAttribute.RightMargin,
                multiplier: 1.0,
                constant: 0.0)
            
            contentView.addConstraint(rightConstraint)
            extraConstraint = rightConstraint
            
        } else {
            
            contentContainer.backgroundColor = UIColor.lightGrayColor()
            
            let leftConstraint = NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: contentView,
                attribute: NSLayoutAttribute.LeftMargin,
                multiplier: 1.0,
                constant: 0.0)
            contentView.addConstraint(leftConstraint)
            extraConstraint = leftConstraint
        }
        contentView.updateConstraints()
        //contentView.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        if extraConstraint != nil {
            contentView.removeConstraint(extraConstraint!)
        }
    }
    
}
