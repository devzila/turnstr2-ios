//
//  Comment.swift
//  Turnstr
//
//  Created by Mr X on 03/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class Comment: NSObject {

    var body: String = ""
    var created_at: String = ""
    var id: Int = 0
    //
    // User Object
    //
    var strUserID: String = ""
    var strUserEmail: String = ""
    var strUserName: String = ""
    var strUserFname: String = ""
    var strUserLName: String = ""
    var strUserPhone: String = ""
    var strUserWebsite: String = ""
    var strUserBio: String = ""
    var strUserContactMe: String = ""
    var strUserOnline: Bool = false
    
    var strUserPic1: String = ""
    var strUserPic2: String = ""
    var strUserPic3: String = ""
    var strUserPic4: String = ""
    var strUserPic5: String = ""
    var strUserPic6: String = ""
    
    
    //MARK:- Static Instance
    static let sharedInstance: Comment = {
        let instance = Comment()
        
        return instance
    }()
    
    
    func ParseCommentData(dict: Dictionary<String, Any>) {
        
        clearData()
        if let obj = dict["id"] as? Int {
            id = obj
        }
        
        if let obj = dict["body"] as? String {
            body = obj
        }
        
        if let obj = dict["created_at"] as? String {
            created_at = obj
        }
        
        
        ParseUser(data: dict)
    }
    
    
    func ParseUser(data: Dictionary<String, Any>) -> Void {
        
        if let objUser = data["user"] as? Dictionary<String, Any> {
            
            if let str = objUser["id"] as? Int {
                strUserID = "\(str)"
            }
            
            if let str = objUser["email"] as? String {
                strUserEmail = "\(str)"
            }
            
            if let str = objUser["username"] as? String {
                strUserName = "\(str)"
            }
            
            if let str = objUser["first_name"] as? String {
                strUserFname = "\(str)"
            }
            
            if let str = objUser["last_name"] as? String {
                strUserLName = "\(str)"
            }
            
            if let str = objUser["phone"] as? Int {
                strUserPhone = "\(str)"
            }
            
            if let str = objUser["avatar_face1"] as? String {
                strUserPic1 = kImageBaseUrl+"\(str)"
            }
            
            if let str = objUser["avatar_face2"] as? String {
                strUserPic2 = kImageBaseUrl+"\(str)"
            }
            
            if let str = objUser["avatar_face3"] as? String {
                strUserPic3 = kImageBaseUrl+"\(str)"
            }
            
            if let str = objUser["avatar_face4"] as? String {
                strUserPic4 = kImageBaseUrl+"\(str)"
            }
            
            if let str = objUser["avatar_face5"] as? String {
                strUserPic5 = kImageBaseUrl+"\(str)"
            }
            
            if let str = objUser["avatar_face6"] as? String {
                strUserPic6 = kImageBaseUrl+"\(str)"
            }
            
            if let str = objUser["website"] as? String {
                strUserWebsite = "\(str)"
            }
            
            if let str = objUser["bio"] as? String {
                strUserBio = "\(str)"
            }
            
            if let str = objUser["contact_me"] as? String {
                strUserContactMe = "\(str)"
            }
            
            if let str = objUser["online"] as? Bool {
                strUserOnline = str
            }
            
        }
    }
    
    func clearData() -> Void {
        id = 0
        body = ""
        created_at = ""
        
        
        //
        // User Object
        //
        strUserID = ""
        strUserEmail = ""
        strUserName = ""
        strUserFname = ""
        strUserLName = ""
        strUserPhone = ""
        strUserWebsite = ""
        strUserBio = ""
        strUserContactMe = ""
        strUserOnline = false
        
        strUserPic1 = ""
        strUserPic2 = ""
        strUserPic3 = ""
        strUserPic4 = ""
        strUserPic5 = ""
        strUserPic6 = ""
    }

}
