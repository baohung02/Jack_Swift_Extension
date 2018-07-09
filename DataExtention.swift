//
//  DataExtention.swift
//  Copyrobo
//
//  Created by imac on 10/18/17.
//  Copyright © 2017 CopyRobo. All rights reserved.
//

import Foundation
extension Data {
    func sizeString(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = units
        bcf.countStyle = .file
        
        return bcf.string(fromByteCount: Int64(count))
    }
    
    func sizeMB() -> Float {
        
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = .useMB
        bcf.countStyle = .file
        bcf.includesUnit = false
        
        let size = bcf.string(fromByteCount: Int64(count))
        
        
        return Float(size) ?? 0
    }
    
    func md5() -> String {
        
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            self.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(self.count), digestBytes)
            }
        }
        let md5Hex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
        
    }
    
    func sha256() -> String {
        
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            self.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(self.count), digestBytes)
            }
        }
        let md5Hex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
        
    }
}
