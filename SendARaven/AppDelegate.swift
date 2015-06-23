//
//  AppDelegate.swift
//  SendARaven
//
//  Created by Jeremy Petter on 2015-06-12.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

import UIKit

import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let parseController = ParseIOController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // Enable local Parse datastore
        Parse.enableLocalDatastore()
        Message.registerSubclass()
        
        //Retrieve hidden API keys
        var keys:NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("parseKeys", ofType: "plist"){
            keys = NSDictionary(contentsOfFile:path)
        }
        
        if let dict = keys {
            let applicationId = keys?["applicationID"] as? String
            let clientKey = keys?["clientKey"] as? String
            
            // Initialize Parse.
            Parse.setApplicationId(applicationId!,
                clientKey:clientKey!)
        }
        
        let navigationBarAppearance = UINavigationBar.appearance();
        navigationBarAppearance.barTintColor = UIColor.raven()
        navigationBarAppearance.tintColor = UIColor.whiteColor()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 16)!];
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            println("PUSH RECEIVED!!")
        if let user = PFUser.currentUser(){
            parseController.getInforForIndexView([PFUser.currentUser()!], local: true, index: true)
            parseController.getInforForIndexView([PFUser.currentUser()!], local: false, index: true)
        }
        
        //Success
        completionHandler(UIBackgroundFetchResult.NewData);
    }
    
    
}


