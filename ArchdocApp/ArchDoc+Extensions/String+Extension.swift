//
//  String + Extension.swift
//  ArchdocApp
//
//  Created by tixomark on 2/17/23.
//

import Foundation

extension String {
    static let emailRegEx = try! NSRegularExpression(pattern: ##"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"##, options: .caseInsensitive)
    static let passwordRegEx = try! NSRegularExpression(pattern: ##"[a-zA-Z0-9!"#$%&'()*+,-./:;<=>?@\[\]^_`{|}~]{8,32}"##, options: .caseInsensitive)
    
    func isValidEmail() -> Bool {
        let range = NSRange(location: 0, length: count)
        return String.emailRegEx.firstMatch(in: self, options: [], range: range) != nil
    }
    
    func isValidPassword() -> Bool {
        let range = NSRange(location: 0, length: count)
        return String.passwordRegEx.firstMatch(in: self, options: [], range: range) != nil
    }
}
extension String? {
    func isNullOrNil() -> Bool {
        if self != "" && self != nil {
            return false
        }
        return true
    }
}


