
//
//  KBLog.swift
//  
//
//  Created by Sierra 3 on 29/05/17.
//
//

import Foundation

class KBLog {
    
    class func log(message: String? object: Any) {
        #if DEBUG
        print("\(object)")
        #endif
    }
    
    class func errorMessage(error: Error?) {
        #if DEBUG
        print(error?.localizedDescription  ?? "no error")
        #endif
    }
    
    class func log(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        
        #if DEBUG
        var filename = file
        if let match = filename.range(of: "[^/]*$", options: .regularExpression) {
        filename = filename.substring(with: match)
        }
        print("\(Date().string(.dd_MMM_YYYY_hh_mm_a)):\(filename):Line\(line):\(function) \"\(message)\"")
        #endif
    }
    
}
