//
//  SignUpViewController.swift
//  Turnstr
//
//  Created by Mr X on 26/06/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class SignUpViewController: ParentViewController {
    
    @IBOutlet weak var txtFirstName: KBTextField!
    @IBOutlet weak var txtLastName: KBTextField!
    @IBOutlet weak var txtEmail: KBTextField!
    @IBOutlet weak var txtUsername: KBTextField!
    @IBOutlet weak var txtPwd: KBTextField!
    @IBOutlet weak var txtConfirmPwd: KBTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Action Methods
    
    @IBAction func BackToLogin(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func NextClicked(_ sender: UIButton) {
        
        IQKeyboardDismiss()
        
        let (status, field) = objUtil.validationsWithField(fields: [txtFirstName, txtLastName, txtEmail, txtUsername, txtPwd, txtConfirmPwd])
        
        if status == false {
            objUtil.showToast(strMsg: "Please enter "+field)
            //dismissAlert(title: L10n.error.string, message: "Please enter "+field)
            return
        }
        
        if txtEmail.text?.isEmail == false {
            objUtil.showToast(strMsg: "Please enter a valid email")
            return
        }
        
        if (txtPwd.text?.length)! < 8 {
            objUtil.showToast(strMsg: "Password is too short (minimum is 8 characters).")
            return
        }
        
        if txtPwd.text != txtConfirmPwd.text {
            objUtil.showToast(strMsg: "Password and confirm pssword not matched.")
            return
        }
        
        
        kAppDelegate.loadingIndicationCreationMSG(msg: "SignUp")
        APIRequest(sType: kAPISignUp, data: [:])
    }
    
    @IBAction func SignUpClicked(_ sender: Any) {
        
    }
    
    
    //MARK:- APIS Handling
    
    func APIRequest(sType: String, data: Dictionary<String, Any>) -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        DispatchQueue.global().async {
            
            if sType == kAPISignUp {
                let dictAction: NSDictionary = [
                    "action": kAPISignUp,
                    "first_name": self.txtFirstName.text!,
                    "last_name": self.txtLastName.text!,
                    "username" : self.txtUsername.text!,
                    "email" : self.txtEmail.text!,
                    "password" : self.txtPwd.text!
                ]
                
                let arrResponse = self.objDataS.PostRequestToServer(dictAction: dictAction)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        if self.objDataS.saveLoginSession(data: arrResponse) == true {
                            
                            self.objDataS.saveLoginData(data: arrResponse)
                            if self.objDataS.isLoginData() == true {
                                self.LoadHomeScreen()
                                //self.LoadEditProfile()
                                //self.LoadMyStories()
                            }
                        }
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            
        }
        
        
    }
    
}
