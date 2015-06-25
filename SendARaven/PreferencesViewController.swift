//
//  PreferencesViewController.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-24.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit

class PreferencesViewController: UITableViewController, UITableViewDelegate {

    @IBOutlet var headerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerSize = CGSizeMake(view.frame.size.width, view.frame.size.width * 2/3)
        headerImage.frame.size = headerSize
        
        let cancelButton = UIButton(frame: CGRectZero)
        headerImage.addSubview(cancelButton)
        let cancelRect = CGRectMake(8, headerImage.frame.size.height-58, 50, 50)
        cancelButton.frame = cancelRect
        cancelButton.setImage(UIImage(named: "x"), forState: UIControlState.Normal)
        cancelButton.backgroundColor = UIColor.ravenRed()
        cancelButton.layer.cornerRadius = cancelButton.frame.size.width/2
        
        let confirmButton = UIButton(frame: CGRectZero)
        headerImage.addSubview(confirmButton)
        let confirmRect = CGRectMake(headerImage.frame.size.width-58, headerImage.frame.size.height-58, 50, 50)
        confirmButton.frame = confirmRect
        confirmButton.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        confirmButton.backgroundColor = UIColor.ravenGreen()
        confirmButton.layer.cornerRadius = cancelButton.frame.size.width/2

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
