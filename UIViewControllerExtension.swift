//
//  UIViewControllerExtension.swift
//  Copyrobo
//
//  Created by imac on 9/11/17.
//  Copyright © 2017 CopyRobo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MBProgressHUD
import Crashlytics

enum swizzledType {
    case willAppear
    case willDisAppear
    case didLoad
}

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    let originalMethod = class_getInstanceMethod(forClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}

private func swizzle(_ v: UIViewController.Type) {
    
    var originalSelector = #selector(v.viewWillAppear(_:))
    var swizzledSelector = #selector(v.ourViewWillAppear(_:))
    swizzling(UIViewController.self, originalSelector, swizzledSelector)
    
    // viewWillDisAppear
    originalSelector = #selector(v.viewWillDisappear(_:))
    swizzledSelector = #selector(v.ourViewWillDisAppear(_:))
    swizzling(UIViewController.self, originalSelector, swizzledSelector)
    
    
    // viewDidAppear
    originalSelector = #selector(v.viewDidAppear(_:))
    swizzledSelector = #selector(v.ourViewDidAppear(_:))
    swizzling(UIViewController.self, originalSelector, swizzledSelector)
}


let loadingViewTag = 123987
private var hasSwizzled = false

@objc
extension UIViewController {
    final public class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        swizzle(self)
    }
    
    fileprivate struct AssociatedKeys {
        static var descriptiveName = "ourDescriptiveName"
    }
    
    // MARK: - Method Swizzling
    
    @objc func ourViewWillAppear(_ animated: Bool) {
        self.ourViewWillAppear(animated)
        if let name = self.descriptiveName {
            Analytics.setScreenName(name, screenClass: name)
            print("viewWillAppear: \(name)")
            
            Crashlytics.sharedInstance().setObjectValue(name, forKey: "ViewWillAppear")
            CLSLogv("ViewWillAppear: %@", getVaList([name]))
        } else {
            print("viewWillAppear: \(self.className)")
            Analytics.setScreenName(self.className, screenClass: self.className)
            
            Crashlytics.sharedInstance().setObjectValue(self.className, forKey: "ViewWillAppear")
            CLSLogv("ViewWillAppear: %@", getVaList([self.className]))
        }
        
        // Update status bar color
        if let statusbar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusbar.backgroundColor = TRColorDefine.primaryDarkColor()
        }
    }
    
    @objc func ourViewWillDisAppear(_ animated: Bool) {
        self.ourViewWillDisAppear(animated)
        
        /*
        if let name = self.descriptiveName {
            print("viewWillDisAppear: \(name)")
        } else {
            print("viewWillDisAppear: \(self.className)")
        }*/
    }
    
    
    @objc func ourViewDidAppear(_ animated: Bool) {
        self.ourViewDidAppear(animated)
        
        /*
        if let name = self.descriptiveName {
            print("viewDidAppear: \(name)")
        } else {
            print("viewDidAppear: \(self.className)")
        }*/
//        for child in self.childViewControllers {
//            child.endAppearanceTransition()
//        }
    }
    
    var descriptiveName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.descriptiveName) as? String
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.descriptiveName,
                    newValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    
    @objc func showLoading() {
        
        if let window = UIApplication.shared.keyWindow {
            if let loadingView = window.viewWithTag(loadingViewTag){
                if loadingView.isHidden {
                    window.bringSubview(toFront: loadingView)
                    loadingView.isHidden = false
                    MBProgressHUD.showAdded(to: loadingView, animated: true)
                }
            }
            else {
                let loadingView = UIView(frame: window.bounds)
                loadingView.backgroundColor = .clear
                loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                loadingView.tag = loadingViewTag
                window.addSubview(loadingView)
                MBProgressHUD.showAdded(to: loadingView, animated: true)
            }
        }
        else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    @objc func hideLoading() {
        if let window = UIApplication.shared.keyWindow {
            if let loadingView = window.viewWithTag(loadingViewTag){
                loadingView.isHidden = true
                MBProgressHUD.hide(for: loadingView, animated: true)
            }
        }
        else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
