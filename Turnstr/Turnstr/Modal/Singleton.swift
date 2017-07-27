//
//  Singleton.swift
//  SwifPro
//
//  Created by softobiz on 4/6/16.
//  Copyright © 2016 softobiz. All rights reserved.
//

import UIKit

class Singleton: NSObject {
    //MARK:- Common variables
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
    
    var follower_count: Int = 0
    var post_count: Int = 0
    var family_count: Int = 0
    
    
    
    var strDeviceToken = String()
    
    var strIsLogin: String = "no"
    
    var strUserSessionId: String = ""
    
    //MARK:- Static Instance
    static let sharedInstance: Singleton = {
        let instance = Singleton()
        
        return instance
    }()
    
    
    func clearData() -> Void {
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
        
        follower_count = 0
        post_count = 0
        family_count = 0
        
        strIsLogin = "no"
        
        strUserSessionId = ""
    }
}
