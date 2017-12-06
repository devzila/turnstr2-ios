//
//  LoginViewController.swift
//  Turnstr
//
//  Created by Mr X on 20/06/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: ParentViewController {
    @IBOutlet weak var txtUsername: KBTextField!
    @IBOutlet weak var txtPassword: KBTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         * CHeck if user already logged in
         */
        if objDataS.isLoginData() == true {
            LoadHomeScreen()
            return
        }
        
        txtUsername.text = "bb@bb.bb"
        txtPassword.text = "12345678"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Action Methods
    
    @IBAction func LoginClicked(_ sender: Any) {
        //LoadHomeScreen()
        return
        IQKeyboardDismiss()
        
        let (status, field) = objUtil.validationsWithField(fields: [txtUsername, txtPassword])
        
        if status == false {
            dismissAlert(title: L10n.error.string, message: "Please enter "+field)
            return
        }
        
        //self.LoadMyStories()
        
        kAppDelegate.loadingIndicationCreationMSG(msg: "Login")
        APIRequest(sType: kAPILogin, data: [:])
        
        //LoadEditProfile()
    }
    
    @IBAction func ForgotPwd(_ sender: Any) {
    }
    
    @IBAction func FbLogin(_ sender: Any) {
        
        return
        // Facebook login **Ketan**
        let loginManager = LoginManager()
        loginManager.loginBehavior = .native
        if AccessToken.current != nil {
            kAppDelegate.loadingIndicationCreationMSG(msg: "Login")
            self.APIRequest(sType: kAPIFacebookLogin, data: ["user_id":AccessToken.current?.userId ?? "", "access_token":AccessToken.current?.authenticationToken ?? ""])
            return
        }
        loginManager.logIn([ .publicProfile, .userFriends, .email ], viewController: self) { (LoginResult) in
            print("LoginResult---\(LoginResult)")
            if let currentUser = AccessToken.current {
                kAppDelegate.loadingIndicationCreationMSG(msg: "Login")
                self.APIRequest(sType: kAPIFacebookLogin, data: ["user_id":currentUser.userId ?? "", "access_token":currentUser.authenticationToken ])
            }
        }
    }
    
    @IBAction func GoogleLogin(_ sender: Any) {
        
        
    }
    
    
    //MARK:- APIS Handling
    
    func APIRequest(sType: String, data: Dictionary<String, Any>) -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        DispatchQueue.global().async {
            
            if sType == kAPILogin {
                let dictAction: NSDictionary = [
                    "action": kAPILogin,
                    "login": self.txtUsername.text!,
                    "password": self.txtPassword.text!,
                    ]
                
                let arrResponse = self.objDataS.PostRequestToServer(dictAction: dictAction)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        if self.objDataS.saveLoginSession(data: arrResponse) == true {
                            
                            self.objDataS.saveLoginData(data: arrResponse)
                            if self.objDataS.isLoginData() == true {
                                self.LoadHomeScreen()
                                //self.LoadMyStories()
                            }
                            
                            kAppDelegate.connectSendBirdSession()
                            kAppDelegate.updateFcm()
                        }
                        
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            } else if sType == kAPIFacebookLogin {
                let dictAction: NSDictionary = [
                    "action": kAPIFacebookLogin,
                    "user_id": data["user_id"] ?? "",
                    "access_token": data["access_token"] ?? "",
                    ]
                
                let arrResponse = self.objDataS.PostRequestToServer(dictAction: dictAction)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        if self.objDataS.saveLoginSession(data: arrResponse) == true {
                            
                            self.objDataS.saveLoginData(data: arrResponse)
                            if self.objDataS.isLoginData() == true {
                                //self.LoadEditProfile()
                                self.LoadHomeScreen()
                            }
                            
                            kAppDelegate.connectSendBirdSession()
                            kAppDelegate.updateFcm()
                        }
                        
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            AppDelegate.shared?.connectSendBirdSession()
            AppDelegate.shared?.updateFcm()
        }
    }
    
}
