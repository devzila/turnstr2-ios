//
//  StringExtensions.swift
//  HungryForJobs
//
//  Created by Sierra 3 on 10/04/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation

extension String {
    
    var url: URL? {
        return URL(string: self)
    }
    
    var length: Int {
        return self.characters.count
    }
    
    var isValidUsername: Bool {
        return isEmail || isPhoneNumber
    }
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = self.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var unwrapDouble: Double {
        guard let double = Double(self) else { return 0}
        return double
    }
    
    var urlWithThumb: String {
        if self.isEmpty == true {
            return ""
        }
        return self
    }
    
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func decode() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
}
