//
//  ParentViewController.swift
//  Turnstr
//
//  Created by Mr X on 26/06/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController, PickerDelegate {

    var objUtil:Utility = Utility.sharedInstance
    var objDataS: DataServiceModal = DataServiceModal.sharedInstance
    var objSing: Singleton = Singleton.sharedInstance
    
    let objNav: MenuBar = MenuBar()
    var pickerView: PickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Load PickerView
    
    func LoadPickerView() -> Void {
        if pickerView == nil {
            pickerView = PickerView.init(frame: CGRect.init(x: 0, y: kHeight-150, width: kWidth, height: 150))
            pickerView.delegatePicker = self
            pickerView.backgroundColor = kLightGray
            pickerView.addDoneAndCancelButton(inView: self.view, yCo: kHeight-150-44)
            self.view.addSubview(pickerView)
        }
        
    }
    
    func MyPIckerViewdidselectRow(controller: PickerView, selectedINdex: Int) {
        pickerView = nil
    }
    
    //MARK:- Navigation Methods
    
    func goBack() -> Void {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func LoadEditProfile() -> Void {
        
        let mvc = EditProfileViewController()
        self.navigationController?.pushViewController(mvc, animated: true)
    }
    
    func LoadHomeScreen() -> Void {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let homeVC: HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
    func IQKeyboardDismiss() -> Void {
        IQKeyboardManager.sharedManager().resignFirstResponder()
    }
    

}
