//
//  UITextfieldExtension.swift
//  Copyrobo
//
//  Created by Tan Le on 8/22/17.
//  Copyright © 2017 HungLe-iMac. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UITextField {
    
    @IBInspectable var bottomBorderHeight: CGFloat {
        set {
            
            borderStyle = .none
            layer.backgroundColor = UIColor.white.cgColor
            
            layer.masksToBounds = false
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 0.0
            layer.shadowColor = UIColor.gray.cgColor
            
            layer.shadowOffset = CGSize(width: 0.0, height: newValue)

        }
        get {
            return layer.shadowOffset.height
        }
    }
    
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedStringKey: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
    
    
}
