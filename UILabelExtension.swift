//
//  UILabelExtension.swift
//  Copyrobo
//
//  Created by imac on 7/9/18.
//  Copyright © 2018 CopyRobo. All rights reserved.
//

import UIKit
extension UILabel {
    
    func boldSubString(searchText: String) {
        
        guard let labelText = self.text  else {
            return
        }
        
        // bold attribute
        let boldAttr = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: self.font.pointSize)]
        
        // check if label text contains search text
        if let matchRange: Range = labelText.lowercased().range(of: searchText.lowercased()) {
            
            // get range start/length because NSMutableAttributedString.setAttributes() needs NSRange not Range<String.Index>
            let matchRangeStart: Int = labelText.distance(from: labelText.startIndex, to: matchRange.lowerBound)
            let matchRangeEnd: Int = labelText.distance(from: labelText.startIndex, to: matchRange.upperBound)
            let matchRangeLength: Int = matchRangeEnd - matchRangeStart
            
            // create mutable attributed string & bold matching part
            let newLabelText = NSMutableAttributedString(string: labelText)
            newLabelText.setAttributes(boldAttr, range: NSMakeRange(matchRangeStart, matchRangeLength))
            
            // set label attributed text
            self.attributedText = newLabelText
        }
    }
}
