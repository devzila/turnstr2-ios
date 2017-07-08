//
//  DataServiceModal.swift
//  SwifPro
//
//  Created by softobiz on 4/6/16.
//  Copyright © 2016 softobiz. All rights reserved.
//

import UIKit

class DataServiceModal: NSObject {
    var objUtil:Utility?
    var objSingl:Singleton?
    
    static let sharedInstance: DataServiceModal = {
        let instance = DataServiceModal()
        
        return instance
    }()
    
    
    //MARK:- HIT WebService
    
    func PostRequestToServer(dictAction:NSDictionary) -> Dictionary<String,AnyObject>  {
        self.allSharedInstance()
        
        if kAppDelegate.checkNetworkStatus() == false {
            
            return [String: AnyObject]()
        }
        
        
        var strRequest: String = "";
        var strPostUrl = ""
        var strParType = ""
        
        let action: String = dictAction["action"] as! String
        
        if action == kAPILogin {
            
            strRequest = String(format: "{\"login\":\"%@\", \"password\":\"%@\"}", dictAction["login"] as! String, dictAction["password"] as! String )
            strPostUrl = kAPILogin
            strParType = ""
        }
        else if action == kAPISignUp {
            
            strRequest = String(format: "{\"email\":\"%@\", \"password\":\"%@\", \"first_name\":\"%@\", \"last_name\":\"%@\", \"username\":\"%@\"}", dictAction["email"] as! String, dictAction["password"] as! String, dictAction["first_name"] as! String, dictAction["last_name"] as! String, dictAction["username"] as! String )
            strPostUrl = kAPISignUp
        }
        
        
        print("API Request")
        print(strRequest)
        
        let dictResponse = WebServices.sharedInstance.PostDataToserver(JSONString: strRequest, PostURL: strPostUrl, parType: strParType)
        print(dictResponse)
        
        return self.validateData(response: dictResponse)
        
    }
    
    //MARK:- GET METHODS
    
    func GetRequestToServer(dictAction:NSDictionary) -> Dictionary<String,AnyObject>  {
        self.allSharedInstance()
        
        
        
        var strRequest: String = "";
        var strPostUrl = ""
        var strParType = ""
        
        let action: String = dictAction["action"] as! String
        
        if action == kAPIGetStories {
            
            strRequest = String(format: "?page=%d", dictAction["page"] as! Int)
            strPostUrl = kAPIGetStories
            strParType = ""
        }
        
        print("API Request")
        print(strRequest)
        
        let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
        print(dictResponse)
        
        return self.validateData(response: dictResponse)
    }
    
    //MARK:- Upload files
    
    func uploadFilesToServer(dictAction:NSDictionary, arrImages: Array<UIImage>) -> Dictionary<String,AnyObject>  {
        self.allSharedInstance()
        
        
        
        var dictRequest: Dictionary = [String: String]()
        var strPostUrl = ""
        var strParType = ""
        
        let action: String = dictAction["action"] as! String
        
        if action == kAPIUpdateProfile {
            dictRequest = dictAction as! [String : String]
            strPostUrl = kAPIUpdateProfile
            
        }
        
        
        let dictResponse = WebServices.sharedInstance.uploadMedia(PostURL: strPostUrl, strData: dictRequest, parType: strParType, arrImages: arrImages)
        print(dictResponse)
        
        return self.validateData(response: dictResponse)
    }

    
    //MARK:- Shared Instance
    
    func allSharedInstance() -> Void {
        objUtil = Utility.sharedInstance
        objSingl = Singleton.sharedInstance
    }
    
    //MARK:- Validation Of response
    
    
    func validateData(response: Dictionary<String,AnyObject>!) -> Dictionary<String,AnyObject> {
        
        allSharedInstance()
        
        var data:Dictionary = [String: AnyObject]()
        
        if response == nil {
            DispatchQueue.main.async {
                self.objUtil?.showToast(strMsg: "No response from server!!!")
                kAppDelegate.hideLoadingIndicator()
            }
            return data
        }
        else if response["statusCode"] as! Int == 200 {
            
            if let dataData = response["data"] {
                
                if let dataVal = dataData["data"] as? Dictionary<String, Any> {
                    
                    if objUtil?.isStrEmpty(str: String.init(format: "%@", dataVal as CVarArg)) == false {
                        
                        if dataVal.count > 0 {
                            data = dataVal as [String : AnyObject]
                            
                            return data
                        }
                        else{
                            DispatchQueue.main.async {
                                kAppDelegate.hideLoadingIndicator()
                            }
                        }
                    }
                    else {
                        //
                        // Create a delegate method for those services which only return empty array
                        // And return that delegate method from here for notify to controllers
                        //
                        DispatchQueue.main.async {
                            kAppDelegate.hideLoadingIndicator()
                        }
                    }
                }
                
            }
            return data
        }
        else if response["statusCode"] as! Int == 400 || response["statusCode"] as! Int == 401 || response["statusCode"] as! Int == 404 || response["statusCode"] as! Int == 500 || response["statusCode"] as! Int == 422 {
            
            if let dataVal = response["data"] {
                
                if objUtil?.isStrEmpty(str: String.init(format: "%@", dataVal as! CVarArg)) == false {
                    //
                    // error message received in data
                    //
                    if dataVal.count > 0 {
                        if let descMsg = dataVal["error"] {
                            
                            DispatchQueue.main.async {
                                self.objUtil?.showToast(strMsg: descMsg as! String)
                                kAppDelegate.hideLoadingIndicator()
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.objUtil?.showToast(strMsg: "Response Code: \(response["statusCode"] as! Int)")
                            kAppDelegate.hideLoadingIndicator()
                        }
                    }
                }
                else {
                    //
                    // No data received
                    //
                    DispatchQueue.main.async {
                        self.objUtil?.showToast(strMsg: "Response Code: \(response["statusCode"] as! Int)")
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            
            return data
        }
        else if response["statusCode"] as! Int == 403 {
            
            if let dataVal = response["data"] {
                
                if dataVal.count > 0, let descMsg = dataVal["error"] {
                    
                    DispatchQueue.main.async {
                        self.objUtil?.showToast(strMsg: "\(descMsg as! String)")
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            
            return data
        }
        else {
            DispatchQueue.main.async {
                self.objUtil?.showToast(strMsg: "Data format not correct. Response Code: \(response["statusCode"] as! Int)")
                kAppDelegate.hideLoadingIndicator()
            }
        }
        
        return data
    }
    
    
    //MARK:- ------------------------------------------------------
    //MARK:-SAVE Login Data
    
    func saveLoginData(data: Dictionary<String,AnyObject>) -> Void {
        allSharedInstance()
        
        objUtil?.saveDictToDefaults(placesArray: data, key: kUDLoginData)
    }
    
    func saveLoginSession(data: Dictionary<String,AnyObject>) -> Bool {
        allSharedInstance()
        
        if let sessionId = data["auth_token"] as? String {
            _ = objUtil?.saveStringForKey(strData: sessionId, forKey: kUDSessionData)
            return true
        }
        return false
    }
    
    func isLoginData() -> Bool {
        
        allSharedInstance()
        
        let session = objUtil?.getUserStringFOrKey(key: kUDSessionData)
        
        if session?.isEmpty == false {
            let data = objUtil?.getDictFromDefaults(key: kUDLoginData)
            
            if (data?.count)! > 0 {
//                if let sessionId = data?["auth_token"] {
                    objSingl?.strUserSessionId = "\(session!)"
                    print(objSingl?.strUserSessionId ?? "")
//                    
//                }
                
                if let objUser = data?["user"] as? Dictionary<String, Any> {
                    
                    if let str = objUser["id"] as? Int {
                        objSingl?.strUserID = "\(str)"
                    }
                    
                    if let str = objUser["email"] as? String {
                        objSingl?.strUserEmail = "\(str)"
                    }
                    
                    if let str = objUser["username"] as? String {
                        objSingl?.strUserName = "\(str)"
                    }
                    
                    if let str = objUser["first_name"] as? String {
                        objSingl?.strUserFname = "\(str)"
                    }
                    
                    if let str = objUser["last_name"] as? String {
                        objSingl?.strUserLName = "\(str)"
                    }
                    
                    if let str = objUser["phone"] as? Int {
                        objSingl?.strUserPhone = "\(str)"
                    }
                    
                    if let str = objUser["avatar_face1"] as? String {
                        objSingl?.strUserPic1 = kImageBaseUrl+"\(str)"
                    }
                    
                    if let str = objUser["avatar_face2"] as? String {
                        objSingl?.strUserPic2 = kImageBaseUrl+"\(str)"
                    }
                    
                    if let str = objUser["avatar_face3"] as? String {
                        objSingl?.strUserPic3 = kImageBaseUrl+"\(str)"
                    }
                    
                    if let str = objUser["avatar_face4"] as? String {
                        objSingl?.strUserPic4 = kImageBaseUrl+"\(str)"
                    }
                    
                    if let str = objUser["avatar_face5"] as? String {
                        objSingl?.strUserPic5 = kImageBaseUrl+"\(str)"
                    }
                    
                    if let str = objUser["avatar_face6"] as? String {
                        objSingl?.strUserPic6 = kImageBaseUrl+"\(str)"
                    }
                    
                    if let str = objUser["website"] as? String {
                        objSingl?.strUserWebsite = "\(str)"
                    }
                    
                    if let str = objUser["bio"] as? String {
                        objSingl?.strUserBio = "\(str)"
                    }
                    
                    if let str = objUser["contact_me"] as? String {
                        objSingl?.strUserContactMe = "\(str)"
                    }
                    
                    if let str = objUser["online"] as? Bool {
                        objSingl?.strUserOnline = str
                    }
                    
                }
                
                return true
            }
        }
        
        
        
        return false
    }
    //MARK:-------------------------------------------------------
}

