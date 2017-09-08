//
//  String+MD5.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 08/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

// MARK: - String MD5 extension
extension String {
    
    var md5: (String?) {
        let stringData = self.data(using: .utf8)
        
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            stringData?.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG((stringData?.count)!), digestBytes)
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
