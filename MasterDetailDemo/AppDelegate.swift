//
//  AppDelegate.swift
//  MasterDetailDemo
//
//  Created by Ivo Vacek on 26/01/15.
//  Copyright (c) 2015 Ivo Vacek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: - support for all devices ios8 and iPad ios7
        
        if let splitViewController = self.window!.rootViewController  as? UISplitViewController {
            splitViewController.delegate = self
            
            // MARK: - on ios7 displayModeButon() is not imlemented, we should inplement workaround in splitview delegate
            
            if (splitViewController.respondsToSelector(Selector("displayModeButtonItem")) == true) {
                let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as UINavigationController
                navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
            }
        }
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
    
    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        println("splitview")
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }

    // MARK: - support for ios7 on iPad, mimic displayModeButtonItem(), static UIButtonItem required 
    
    func splitViewController(svc: UISplitViewController, willHideViewController aViewController: UIViewController, withBarButtonItem barButtonItem: UIBarButtonItem, forPopoverController pc: UIPopoverController) {
        if (!svc.respondsToSelector(Selector("displayModeButtonItem"))) {
            if let detailView = svc.viewControllers[svc.viewControllers.count-1] as? UINavigationController {
                DetailViewController.Static.backButton = barButtonItem
                detailView.topViewController.navigationItem.leftBarButtonItem = barButtonItem
            }
        }
    }
    
    
    func splitViewController(svc: UISplitViewController!, willShowViewController aViewController: UIViewController!, invalidatingBarButtonItem barButtonItem: UIBarButtonItem!) {
        if (!svc.respondsToSelector(Selector("displayModeButtonItem"))) {
            if let detailView = svc.viewControllers[svc.viewControllers.count-1] as? UINavigationController {
                DetailViewController.Static.backButton = nil
                detailView.topViewController.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
}

