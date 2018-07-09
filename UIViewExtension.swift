//
//  UIViewExtension.swift
//  Copyrobo
//
//  Created by Tan Le on 8/28/17.
//  Copyright © 2017 HungLe-iMac. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

@objc
extension UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    
    func addShadow(shadowColor: CGColor = UIColor.gray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        self.clipsToBounds = false
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = false
    }
    
    
    func addDashedLine(_ color: UIColor = UIColor.lightGray) {
        layer.sublayers?.filter({ $0.name == "DashedTopLine" }).forEach({ $0.removeFromSuperlayer() })
        self.backgroundColor = UIColor.clear
        let cgColor = color.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [3, 1]
        
        let path: CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
            
//        CGPathMoveToPoint(path, nil, 0, 0)
//        CGPathAddLineToPoint(path, nil, self.frame.width, 0)
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
    
    public func showAnimationTouch(_ completion:@escaping ()->Void){
        let timeAnimation: Int64 = 250000000
        self.layer.masksToBounds = true
        
        let color = UIColor(hexString: "#e5e5e5")
        // REMOVE ANIMATION LAYER IF NEED
        if( (self.layer.sublayers?.count)! > 0){
            for layer in self.layer.sublayers! {
                if(layer.zPosition == 10000){
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        let animationLayer = CAShapeLayer.init()
        animationLayer.frame = CGRect(x: self.frame.size.width / 2 - 1, y: self.frame.size.height / 2 - 1 , width: 2, height: 2)
        animationLayer.strokeEnd = 1.0
        animationLayer.lineWidth = 2.0
        //        animationLayer.fillColor = UIColor.redColor().CGColor//UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        
        animationLayer.strokeColor = color.cgColor
        animationLayer.backgroundColor = color.withAlphaComponent(0.3).cgColor
        
        animationLayer.cornerRadius = animationLayer.frame.size.width / 2
        self.layer.addSublayer(animationLayer)
        var scaleTime:CGFloat = 1.0
        if(self.frame.size.width > self.frame.size.height){
            scaleTime = self.frame.size.width / animationLayer.frame.size.width
            
        }else{
            scaleTime = self.frame.size.height / animationLayer.frame.size.height
        }
        
        let circleAnim:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")//CABasicAnimation(keyPath: "transform")
        
        circleAnim.fromValue = 1.0
        circleAnim.toValue = NSNumber.init(value: Float(scaleTime) as Float)
        circleAnim.duration = 0.4
        circleAnim.repeatCount = 1
//        circleAnim.delegate = self
        animationLayer.add(circleAnim, forKey: "transform.scale")
        animationLayer.zPosition = 10000
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(timeAnimation) / Double(NSEC_PER_SEC), execute: {
            completion()
        })
        
    }
    public func showAnimationTouch( _ color:UIColor?,completion:@escaping ()->Void){
        self.layer.masksToBounds = true
        let timeAnimation: Int64 = 250000000
        
        // REMOVE ANIMATION LAYER IF NEED
        if( (self.layer.sublayers?.count)! > 0){
            for layer in self.layer.sublayers! {
                if(layer.zPosition == 10000){
                    layer.removeFromSuperlayer()
                }
            }
        }
        let animationLayer = CAShapeLayer.init()
        
        animationLayer.frame = CGRect(x: self.frame.size.width / 2 - 1, y: self.frame.size.height / 2 - 1 , width: 2, height: 2)
        animationLayer.strokeEnd = 1.0
        animationLayer.lineWidth = 2.0
        //        animationLayer.fillColor = UIColor.redColor().CGColor//UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        if(color == nil){
            animationLayer.strokeColor = UIColor(hexString: "#e5e5e5").cgColor
            animationLayer.backgroundColor = UIColor(hexString: "#e5e5e5").withAlphaComponent(0.3).cgColor
        }else{
            animationLayer.strokeColor = color!.cgColor
            animationLayer.backgroundColor = color!.withAlphaComponent(0.3).cgColor
        }
        
        
        animationLayer.cornerRadius = animationLayer.frame.size.width / 2
        self.layer.addSublayer(animationLayer)
        var scaleTime:CGFloat = 1.0
        if(self.frame.size.width > self.frame.size.height){
            scaleTime = self.frame.size.width / animationLayer.frame.size.width
            
        }else{
            scaleTime = self.frame.size.height / animationLayer.frame.size.height
        }
        
        let circleAnim:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")//CABasicAnimation(keyPath: "transform")
        
        circleAnim.fromValue = 1.0
        circleAnim.toValue = NSNumber.init(value: Float(scaleTime) as Float)
        circleAnim.duration = 0.4
        circleAnim.repeatCount = 1
//        circleAnim.delegate = self
        animationLayer.add(circleAnim, forKey: "transform.scale")
        animationLayer.zPosition = 10000
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(timeAnimation) / Double(NSEC_PER_SEC), execute: {
            completion()
        })
        
    }
    
    /* Called when the animation begins its active duration. */
    
    
    public func animationDidStart(_ anim: CAAnimation){
        //        print(#function)
    }
    
    /* Called when the animation either completes its active duration or
     * is removed from the object it is attached to (i.e. the layer). 'flag'
     * is true if the animation reached the end of its active duration
     * without being removed. */
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        //        print(#function)
        for layer in self.layer.sublayers! {
            if(layer.zPosition == 10000){
                // layer.removeFromSuperlayer()
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
            MBProgressHUD.showAdded(to: self, animated: true)
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
            MBProgressHUD.hide(for: self, animated: true)
        }
    }
    
    //MARK: - Safe area
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }else {
            return self.leftAnchor
        }
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }else {
            return self.rightAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
}
