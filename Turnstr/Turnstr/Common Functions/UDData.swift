
//
//  UDData.swift
//  Workcocoon
//
//  Created by Sierra 3 on 30/05/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import UIKit

enum UDKeys: String {
    case deviceToken = "Device Token"
    case user = "user"
    case theme = "Current Theme"
    case fcm = "fcm token"
    case voip = "voip Token"
    
    func save(value: Any?) {
        guard let value = value else {
            UserDefaults.standard.set(nil, forKey:  self.rawValue)
            return
        }
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: self.rawValue)
    }
    
    func fetch() -> Any? {
        guard let data = UserDefaults.standard.data(forKey: self.rawValue), let value = NSKeyedUnarchiver.unarchiveObject(with: data)
            else { return nil }
        return value
    }
    
    func remove() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}


extension UserDefaults {
    
    func setUser(value: Any?, forKey: String) {
        guard let value = value else {
            set(nil, forKey:  forKey)
            return
        }
        set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: forKey)
    }
    
    func userForKey(key: String) -> Any? {
        guard let data = data(forKey: key), let user = NSKeyedUnarchiver.unarchiveObject(with: data)
            else { return nil }
        return user
    }
}
