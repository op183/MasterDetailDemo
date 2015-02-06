//
//  SplitViewSupport.swift
//  MasterDetailDemo
//
//  Created by Ivo Vacek on 28/01/15.
//  Copyright (c) 2015 Ivo Vacek. All rights reserved.
//

import UIKit

// MARK: - iPad ios7support
class CustomView: UIView {
    
    let imgView = UIImageView()
    let label = UILabel()
    
    init(from: UIBarButtonItem?) {
        
        // chevron
        imgView.image = UISplitViewController.ios7Support.img?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imgView.sizeToFit()
        imgView.frame.offset(dx: 0, dy: 1)
        
        // label
        label.text = "    "
        if let title = from?.title {
            label.text! += title
        }
        label.sizeToFit()
        label.frame.offset(dx: 0, dy: 1)
        
        // init with proper size
        super.init(frame: label.bounds)
        
        // set colors
        label.textColor = tintColor
        
        // compose
        addSubview(imgView)
        addSubview(label)
        
        // functionality
        let action: Selector = from?.action ?? Selector()
        
        // tap animation
        let tap = UITapGestureRecognizer(target: self, action: Selector("tapAction"))
        
        // UIBarButtonItem current functionality
        if let target = from?.target as? UISplitViewController {
            tap.addTarget(target, action: action)
        }
        addGestureRecognizer(tap)
    }
    
    func tapAction() {
        // experimental, I am not able to get 'system default value'
        label.alpha = 0.2
        
        UIView.animateWithDuration(0.3) {
            [unowned self] in
            self.label.alpha = 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tintColorDidChange() {
        label.textColor = tintColor
        super.tintColorDidChange()
    }
}

class ModeButtonItem: UIBarButtonItem {
    
    init(from: UIBarButtonItem?) {
        super.init(customView: CustomView(from: from))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
}

extension UISplitViewController: UISplitViewControllerDelegate {
    
    
    struct ios7Support {
        static var modeButtonItem: UIBarButtonItem?
        static var img = UIImage(named: "img.png")
    }
    
    var backBarButtonItem: UIBarButtonItem? {
        get {
            if respondsToSelector(Selector("displayModeButtonItem")) == true {
                let button: UIBarButtonItem = displayModeButtonItem()
                return button
            } else {
                return ios7Support.modeButtonItem
            }
        }
        set {
            if let button = newValue {
                ios7Support.modeButtonItem = ModeButtonItem(from: newValue)
                //ios7Support.modeButtonItem = newValue
            } else {
                ios7Support.modeButtonItem = nil
            }
        }
    }
    
    func displayModeButtonItem(_: Bool = true)->UIBarButtonItem? {
        return backBarButtonItem
    }
    
    // MARK: - ios7 ipad support, deprecated on ios8
    
    public func splitViewController(svc: UISplitViewController, willHideViewController aViewController: UIViewController, withBarButtonItem barButtonItem: UIBarButtonItem, forPopoverController pc: UIPopoverController) {
        if (!svc.respondsToSelector(Selector("displayModeButtonItem"))) {
            if let detailView = svc.viewControllers[svc.viewControllers.count-1] as? UINavigationController {
                svc.backBarButtonItem = barButtonItem
                detailView.topViewController.navigationItem.leftBarButtonItem = svc.backBarButtonItem
                detailView.topViewController.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    public func splitViewController(svc: UISplitViewController!, willShowViewController aViewController: UIViewController!, invalidatingBarButtonItem barButtonItem: UIBarButtonItem!) {
        if (!svc.respondsToSelector(Selector("displayModeButtonItem"))) {
            if let detailView = svc.viewControllers[svc.viewControllers.count-1] as? UINavigationController {
                svc.backBarButtonItem = nil
                detailView.topViewController.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    // MARK: - ios8 delegate
    // will never be running on ios7 devices
    
    public func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
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
    
 
}
