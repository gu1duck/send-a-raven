//
//  MessageCell.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-12.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentCenterConstraint: NSLayoutConstraint!
    
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

        
        let dateFormatter = NSDateFormatter()
        //timeStampLabel.text = dateFormatter.stringFromDate(message.timeStamp)
        contentLabel.text = message.content
        contentContainer.layer.cornerRadius = 15
        
        contentView.addConstraint(NSLayoutConstraint(
            item: contentContainer,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.LessThanOrEqual,
            toItem: contentView,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.6,
            constant: 0.0))
        contentView.removeConstraint(contentCenterConstraint)
        
        if message.sender == "me"{
            contentContainer.backgroundColor = UIColor.purpleColor()
            
            contentView.addConstraint(NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: contentView,
                attribute: NSLayoutAttribute.RightMargin,
                multiplier: 1.0,
                constant: 0.0))
            
        } else {
            contentContainer.backgroundColor = UIColor.lightGrayColor()
            
            contentView.addConstraint(NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: contentView,
                attribute: NSLayoutAttribute.LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        }
        contentView.updateConstraints()
    }
    
}
