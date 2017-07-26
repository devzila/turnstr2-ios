//
//  ParentViewController.swift
//  Turnstr
//
//  Created by Mr X on 26/06/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController, PickerDelegate, CustomAlertViewDelegate {
    
    var objUtil:Utility = Utility.sharedInstance
    var objDataS: DataServiceModal = DataServiceModal.sharedInstance
    var objSing: Singleton = Singleton.sharedInstance
    var objLoader = Loader.sharedInstance
    
    
    let objNav: MenuBar = MenuBar()
    var uvNavBar: MenuBar?
    
    var pickerView: PickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Navigation Bar
    
    func LoadNavBar() -> Void {
        /*
         * Navigation Bar
         */
        uvNavBar = MenuBar.init(frame: self.view.frame, logoTitle: true)
        self.view.addSubview(uvNavBar!)
        uvNavBar?.addSubview(objNav.backButonIcon())
        Utility.sharedInstance.setFrames(xCo: 0, yCo: 10, width: 0, height: kNavBarHeightWithLogo, view: objNav.btnBack)
        uvNavBar?.addSubview(objNav.ProfileIconButton())
    }
    
    func LoadPhotoLibNavBar() -> Void {
        /*
         * Navigation Bar
         */
        uvNavBar = MenuBar.init(frame: self.view.frame, logoTitle: true)
        self.view.addSubview(uvNavBar!)
        uvNavBar?.addSubview(objNav.backButonIcon())
        Utility.sharedInstance.setFrames(xCo: 0, yCo: 10, width: 0, height: kNavBarHeightWithLogo, view: objNav.btnBack)
        uvNavBar?.addSubview(objNav.rightPhotoButton())
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
    
    func LogoutClicked() -> Void {
        kAppDelegate.LogoutFromApp()
        /*objUtil.removeUserDefaults(key: kUDLoginData)
        objUtil.removeUserDefaults(key: kUDSessionData)
        objSing.clearData()
        */
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    func goBack() -> Void {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func LoadEditProfile() -> Void {
        
        let mvc = EditProfileViewController()
        self.navigationController?.pushViewController(mvc, animated: true)
    }
    
    func LoadProfile() -> Void {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let homeVC: HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
    func LoadMyStories() -> Void {
        
        
        /*let tabBarController = UITabBarController()
         
         let homeVC = MyStoriesViewController()
         
         let searchVC = MyStoriesViewController()
         
         let camVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
         
         let favVC = MyStoriesViewController()
         
         let profileVC = MyStoriesViewController()
         
         
         let firstImage = UIImage(named: "tab_home")
         let secondImage = UIImage(named: "tab_search")
         let thirdImage = UIImage(named: "tab_cam")
         let fourthImage = UIImage(named: "tab_fav")
         let fifthImage = UIImage(named: "tab_profile")
         
         
         //UITabBar.appearance().tintColor = UIColor.black
         //tabBarController.tabBar.backgroundColor = UIColor.white
         tabBarController.tabBar.backgroundImage = #imageLiteral(resourceName: "navBg")
         //tabBarController.tabBar.layer.borderWidth = 0.50
         //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
         tabBarController.tabBar.clipsToBounds = true
         
         homeVC.tabBarItem = UITabBarItem.init(title: nil, image: firstImage, selectedImage: #imageLiteral(resourceName: "tab_home_sel"))
         searchVC.tabBarItem = UITabBarItem.init(title: nil, image: secondImage, selectedImage: #imageLiteral(resourceName: "tab_search_sel"))
         camVC.tabBarItem = UITabBarItem.init(title: nil, image: thirdImage, selectedImage: #imageLiteral(resourceName: "tab_cam_sel"))
         favVC.tabBarItem = UITabBarItem.init(title: nil, image: fourthImage, selectedImage: #imageLiteral(resourceName: "tab_fav_sel"))
         profileVC.tabBarItem = UITabBarItem.init(title: nil, image: fifthImage, selectedImage: #imageLiteral(resourceName: "tab_profile_sel"))
         
         
         
         
         let controllers = [homeVC, searchVC, camVC, favVC, profileVC]
         tabBarController.viewControllers = controllers
         self.navigationController!.pushViewController(tabBarController, animated: true)*/
        
        
        let myVC = MyStoriesViewController()
        //let myVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    func LoadHomeScreen() -> Void {
        //let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        //let homeVC: HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC: TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        
        self.navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
    func IQKeyboardDismiss() -> Void {
        IQKeyboardManager.sharedManager().resignFirstResponder()
    }
    
    //MARK:- Create Custom AlertView
    
    func showCustomAlertView(type:enumPopUPType, uvContainer:UIView!, dictData:NSDictionary) -> Void {
        // Create a new AlertView instance
        let objCustomAlert:CustomAlertView? = CustomAlertView()
        
        // Set a custom container view
        if uvContainer != nil {
            objCustomAlert!.containerView = uvContainer
        }
        // Set self as the delegate
        objCustomAlert!.delegate = self
        
        // Or, use a closure
        //alertView.onButtonTouchUpInside = { (alertView: CustomAlertView, buttonIndex: Int) -> Void in
        //}
        objCustomAlert!.alertBGColor = ["#FFFFFF", "#FFFFFF"]
        objCustomAlert!.alertDismiss = onTouchDismiss.touchDismissYES
        
        objCustomAlert?.tag = type.rawValue
        
        if type == .newStory {
            objCustomAlert?.showCloseButton = false
        }
        
        
        
        objCustomAlert!.show()
    }
    
    //MARK:- Delegate Methods
    
    // Handle CustomAlertView button touches
    func customAlertViewButtonTouchUpInside(alertView alertView1: CustomAlertView, buttonIndex: Int) {
        
        alertView1.close()
    }
    
}
