//
//  NSObjectExtension.swift
//  Copyrobo
//
//  Created by imac on 8/28/17.
//  Copyright © 2017 HungLe-iMac. All rights reserved.
//

import Foundation

extension NSObject {
    
    var className : String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
}
