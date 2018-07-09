//
//  DateExtension.swift
//  Copyrobo
//
//  Created by imac on 10/25/17.
//  Copyright © 2017 CopyRobo. All rights reserved.
//

import Foundation

extension Date {
    
    func getStartTimeOfDate() -> String {
        
        let gregorian = Calendar.current
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.timeZone = TimeZone.current
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let date = gregorian.date(from: components)!
        
        return String(date.timeIntervalSince1970 * 1000)
    }
    
    func getEndTimeOfDate() -> String {
        
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        
        components.timeZone = TimeZone.current
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        let date = gregorian.date(from: components)!
        
        return String(date.timeIntervalSince1970 * 1000)
    }
}
