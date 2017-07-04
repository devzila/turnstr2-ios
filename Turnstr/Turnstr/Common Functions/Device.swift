//
//  Device.swift
//  HungryForJobs
//
//  Created by Sierra 3 on 18/04/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import UIKit

enum Device {
    
    case os
    case version
    case name
    case appVersion
    case udid
    case deviceToken
}


extension Device {
    
    var value: String {
        
        switch self {
        case .os:
            return "IOS"
            
        case .version:
            return ProcessInfo.processInfo.operatingSystemVersionString
            
        case .name:
            return UIDevice.current.name
            
        case .appVersion:
            guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                return ""
            }
            return version
            
        case .udid:
            return UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        case .deviceToken:
            guard let token = UserDefaults.standard.value(forKey: "deviceToken") as? String else { return "12345"}
            return token
        }
        
    }
}

enum Screen {
    case width
    case height
}

extension Screen {
    
    var value: CGFloat {
        
        switch self {
            
        case .width:
            return UIScreen.main.bounds.size.width
            
        case .height:
            return UIScreen.main.bounds.size.height

        }
    }
}
