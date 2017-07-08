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
    
    func LoadMyStories() -> Void {
        
        /*let tabBarController = UITabBarController()
        
        let profileVC = MyStoriesViewController()
        
        let messageVC = MyStoriesViewController()
        
        let friendsVC = MyStoriesViewController()
        
        let moreVC = MyStoriesViewController()
        
        let moreVC5 = MyStoriesViewController()
        
        
        let firstImage = UIImage(named: "tab_feed")
        let secondImage = UIImage(named: "tab_forum")
        let thirdImage = UIImage(named: "tab_magazine")
        let fourthImage = UIImage(named: "tab_inbox")
        let fifthImage = UIImage(named: "tab_profile")
        
        
        UITabBar.appearance().tintColor = UIColor.black
        
        tabBarController.tabBar.layer.borderWidth = 0.50
        tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.clipsToBounds = true
        
        profileVC.tabBarItem = UITabBarItem(
            title: "FEED",
            image: firstImage,
            tag: 1)
        
        messageVC.tabBarItem = UITabBarItem(
            title: "FORUM",
            image: secondImage,
            tag:2)
        
        friendsVC.tabBarItem = UITabBarItem(
            title: "MEGAZINE",
            image: thirdImage,
            tag:3)
        
        moreVC.tabBarItem = UITabBarItem(
            title: "INBOX",
            image: fourthImage,
            tag:4)
        
        moreVC5.tabBarItem = UITabBarItem(
            title: "PROFILE",
            image: fifthImage,
            tag:5)
        
        
        
        
        let controllers = [profileVC, messageVC, friendsVC, moreVC, moreVC5]
        tabBarController.viewControllers = controllers
        self.navigationController!.pushViewController(tabBarController, animated: true)

        */
        let myVC = MyStoriesViewController()
        //let myVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
        self.navigationController?.pushViewController(myVC, animated: true)
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
