//
//  LoginTextView.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {

    override func awakeFromNib() {
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup (){
        self.layer.masksToBounds = false
        layer.shadowColor = UIColor.whiteColor().CGColor
        layer.shadowOffset = CGSizeZero
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 8, 8)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
