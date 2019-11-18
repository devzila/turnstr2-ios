//
//  ColorExtension.swift
//  HungryForJobs
//
//  Created by Sierra 3 on 19/04/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(_ hexCode: String) {
        
        var cString:String = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            return
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) {
        
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
}
