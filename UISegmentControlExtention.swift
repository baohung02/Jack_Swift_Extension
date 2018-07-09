//
//  UISegmentControlExtention.swift
//  Copyrobo
//
//  Created by imac on 10/16/17.
//  Copyright © 2017 CopyRobo. All rights reserved.
//

@objc
extension UISegmentedControl {
    
    func customizeAppearance() {
        
        setTitleTextAttributes([NSAttributedStringKey.font:UIFont(name:TRFontDefine.kTextFontOpensanSemiBold, size:12.0)!,NSAttributedStringKey.foregroundColor:UIColor.init(hexString: TRColorDefine.kColor17)], for:.normal)
        setTitleTextAttributes([NSAttributedStringKey.font:UIFont(name:TRFontDefine.kTextFontOpensanSemiBold, size:12.0)!,NSAttributedStringKey.foregroundColor:UIColor.init(hexString: TRColorDefine.kColorPrivatePrimary)], for:.selected)
        setDividerImage(UIImage().colored(with: .clear, size: CGSize(width: 1, height: self.frame.height)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        setBackgroundImage(UIImage().colored(with: .clear, size: CGSize(width: 1, height: self.frame.height)), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage().colored(with: .clear, size: CGSize(width: 1,height:self.frame.height)), for: .selected, barMetrics: .default);
        
        for  borderview in subviews {
            let upperBorder: CALayer = CALayer()
            upperBorder.backgroundColor = UIColor.clear.cgColor
            upperBorder.frame = CGRect(x: 0, y: borderview.frame.size.height, width: borderview.frame.size.width, height: 0)
            borderview.layer.addSublayer(upperBorder)
        }
        
    }
}
