//
//  StringExtension.swift
//  Copyrobo
//
//  Created by imac on 10/18/17.
//  Copyright © 2017 CopyRobo. All rights reserved.
//

import Foundation

 extension String {
    var ns: NSString {
        return self as NSString
    }
    var pathExtension: String {
        return ns.pathExtension
    }
    var lastPathComponent: String {
        return ns.lastPathComponent
    }
    
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func md5() -> String {
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        let md5Hex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex

    }
    
    func haveSpecialCharacter() -> Bool {
        let letters = CharacterSet.init(charactersIn: "\\/:*\"?<>|;!@#$%^&(){}[]_")
        let range = self.rangeOfCharacter(from: letters)
        if let _ = range {
            return true
        }
        return false
    }
    
    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData,
                                                          options: attributedOptions,
                                                          documentAttributes: nil)
            self = attributedString.string
        } catch {
            print("Error: \(error.localizedDescription)")
            self = htmlEncodedString
        }
    }
    
    func hasSpecialCharacter() -> Bool {
        
        var isExisted: Bool = false
        
        let characterSet:CharacterSet = CharacterSet(charactersIn: "abcdefABCDEF0123456789")
        
        if self.rangeOfCharacter(from: characterSet.inverted) != nil {
            
            isExisted = true
        }else {
            
            isExisted = false
        }
        
        return isExisted
    }
    
    func isAllDigits() -> Bool {
        
        let characterSet: CharacterSet = CharacterSet(charactersIn: "!~`@#$%^&*-+();:=_{}[],.<>?\\/|\"\'0123456789")
        
        let filtered = self.components(separatedBy: characterSet).joined(separator: "")
        
        return (self == filtered)
    }
    
    func isEmail() -> Bool {
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let filtered = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return filtered.evaluate(with: self)
    }
    
    func checkIsNumberString() -> Bool {
        
        guard let _ = self.rangeOfCharacter(from: .letters),
            let _ = self.rangeOfCharacter(from: .decimalDigits)
            else {
                return false
        }
        return true
    }
    
    var lastWord: String {
        let aryOfWord = self.split(separator: " ")
        
        if aryOfWord.count > 0 {
            return String(aryOfWord.last!)
        }
        
        return self
    }
    
}

@objc extension NSString {
    func md5() -> String {
        let temp = self as String
        return temp.md5()
    }
}
