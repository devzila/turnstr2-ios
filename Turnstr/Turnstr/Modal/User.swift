
//
//  User.swift
//  Turnstr
//
//  Created by Kamal on 27/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    
    var id: String?
    var email: String?
    var username: String?
    var firstname: String?
    var lastname: String?
    var name: String?
    var phone: String?
    var website: String?
    var bio: String?
    var contactMe: String?
    var online: Bool = false
    var isVerified: Bool = false
    lazy var cubeUrls: [URL] = [URL]()
    
    
    override init() {
        
        super.init()
        
        let sharedInstance = Utility.sharedInstance
        let data = sharedInstance.getDictFromDefaults(key: kUDLoginData)
        if data.count == 0 {
            return
        }
        
        if let objUser = data["user"] as? Dictionary<String, Any> {
            
            if let str = objUser["id"] as? Int {
                self.id = "\(str)"
            }
            
            if let str = objUser["email"] as? String {
                self.email = "\(str)"
            }
            
            if let str = objUser["username"] as? String {
                self.username = "\(str)"
            }
            
            if let str = objUser["first_name"] as? String {
                self.firstname = "\(str)".capitalized
            }
            
            if let str = objUser["last_name"] as? String {
                self.lastname = "\(str)".capitalized
            }
            
            name = self.firstname?.appendingFormat(" %@", self.lastname ?? "")
            
            if let str = objUser["phone"] as? Int {
                self.phone = "\(str)"
            }
            
            if let str = objUser["avatar_face1"] as? String {
                if let url = URL(string: str) {
                    self.cubeUrls.append(url)
                }
            }
            
            if let str = objUser["avatar_face2"] as? String {
                if let url = URL(string: str) {
                    self.cubeUrls.append(url)
                }
            }
            
            if let str = objUser["avatar_face3"] as? String {
                if let url = URL(string: str) {
                    self.cubeUrls.append(url)
                }
            }
            
            if let str = objUser["avatar_face4"] as? String {
                if let url = URL(string: str) {
                    self.cubeUrls.append(url)
                }
            }
            
            if let str = objUser["avatar_face5"] as? String {
                if let url = URL(string: str) {
                    self.cubeUrls.append(url)
                }
            }
            
            if let str = objUser["avatar_face6"] as? String {
                if let url = URL(string: str) {
                    self.cubeUrls.append(url)
                }
            }
            
            if let str = objUser["website"] as? String {
                self.website = str
            }
            
            if let str = objUser["bio"] as? String {
                self.bio = str
            }
            
            if let str = objUser["contact_me"] as? String {
                self.contactMe = str
            }
            
            if let str = objUser["online"] as? Bool {
                self.online  = str
            }
        }
    }
    
    init(withStoryInfo userStory: [String: Any]?) {
        super.init()
        self.cubeUrls = [URL]()
        if let str = userStory?["avatar_face1"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        if let str = userStory?["avatar_face2"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        if let str = userStory?["avatar_face3"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        if let str = userStory?["avatar_face4"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        if let str = userStory?["avatar_face5"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        if let str = userStory?["avatar_face6"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        
        if let id = userStory?["id"] as? Int {
            self.id = "\(id)"
        }
        if let str = userStory?["first_name"] as? String {
            self.firstname = "\(str)".capitalized
        }
        if let str = userStory?["last_name"] as? String {
            self.lastname = "\(str)".capitalized
        }
        if let isVerified = userStory?["is_verified"] as? Int {
            self.isVerified = isVerified == 1
        }
        if let online = userStory?["online"] as? Int {
            self.online = online == 1
        }
        if let username = userStory?["username"] as? String {
            self.username = username
        }
    }
}


extension User {
    
    convenience init(_ objUser: [String: Any]?) {
        
        self.init()
        
        if let str = objUser?["id"] as? Int {
            self.id = "\(str)"
        }
        else {
            self.id = nil
        }
        
        if let str = objUser?["email"] as? String {
            self.email = "\(str)"
        }
        else {
            self.email = nil
        }
        
        
        if let str = objUser?["username"] as? String {
            self.username = "\(str)"
        }
        else {
            self.username = nil
        }
        
        if let str = objUser?["first_name"] as? String {
            self.firstname = "\(str)".capitalized
        }
        else {
            self.firstname = nil
        }
        
        if let str = objUser?["last_name"] as? String {
            self.lastname = "\(str)".capitalized
        }
        else {
            self.lastname = nil
        }
        
        name = self.firstname?.appendingFormat(" %@", self.lastname ?? "")
        
        if let str = objUser?["phone"] as? Int {
            self.phone = "\(str)"
        }
        else {
            self.phone = nil
        }
        
        self.cubeUrls = [URL]()
        
        if let str = objUser?["avatar_face1"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        
        if let str = objUser?["avatar_face2"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        
        if let str = objUser?["avatar_face3"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        
        if let str = objUser?["avatar_face4"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        
        if let str = objUser?["avatar_face5"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        
        if let str = objUser?["avatar_face6"] as? String {
            if let url = URL(string: str) {
                self.cubeUrls.append(url)
            }
        }
        
        if let str = objUser?["website"] as? String {
            self.website = str
        }
        else {
            self.website = nil
        }
        
        if let str = objUser?["bio"] as? String {
            self.bio = str
        }
        else {
            self.bio = nil
        }
        
        if let str = objUser?["contact_me"] as? String {
            self.contactMe = str
        }
        else {
            self.contactMe = nil
        }
        
        if let str = objUser?["online"] as? Bool {
            self.online  = str
        }
        else {
            self.online = false
        }
    }
    
    
}
