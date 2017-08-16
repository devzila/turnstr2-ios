//
//  AppDelegate.swift
//  Turnstr
//
//  Created by Mr X on 09/05/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import FacebookCore
import SendBirdSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var hud = MBProgressHUD()


    static var shared: AppDelegate? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return delegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.sharedManager().enable = true
        //application.isStatusBarHidden = true
        
        
        /*
         * Internet Reachability
         */
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        // Facebook Initilization
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //SandBird Integration 
        SBDMain.initWithApplicationId(kSendBirdAppId)
        connectSendBirdSession()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        connectSendBirdSession()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        disconnect()
    }


    //MARK:- Loaders
    
    func loadingIndicationCreation() -> Void {
        hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.labelText = "Loading"
    }
    
    func loadingIndicationCreationMSG(msg: String) -> Void {
        hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.labelText = msg
    }
    
    func hideLoadingIndicator() -> Void {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.window, animated: true)
        }
    }
    
    //MARK:- Internet Reachability
    
    func networkStatusChanged(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        print(userInfo ?? "Internet reachability")
    }
    
    func checkNetworkStatus() -> Bool {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected")
            DispatchQueue.main.async {
                Utility.sharedInstance.showAlert(title: "", forMsg: "No Internet Connection")
            }
            return false
        case .online(.wwan):
            print("Connected via WWAN")
            return true
        case .online(.wiFi):
            print("Connected via WiFi")
            return true
        default:
            return false
        }
        
    }
    
    // MARK:- Open url callback
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId = SDKSettings.appId
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" { // facebook
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return false
    }
    

    //MARK:- Logout 
    
    func LogoutFromApp() -> Void {
        
        
        guard let navC = self.window?.rootViewController as? UINavigationController else { return }
        Utility.sharedInstance.removeUserDefaults(key: kUDLoginData)
        Utility.sharedInstance.removeUserDefaults(key: kUDSessionData)
        Singleton.sharedInstance.clearData()
        
        navC.popToRootViewController(animated: true)
        disconnect()
    }
}


extension AppDelegate {
    func connectSendBirdSession() {
        if isLoggedIn == true, let id = loginUser.id {
            SBDMain.connect(withUserId: id, completionHandler: {[weak self] (user, error) in
                if error == nil {
                    SBDMain.updateCurrentUserInfo(withNickname: self?.loginUser.name, profileUrl: self?.loginUser.cubeUrls.first?.absoluteString, completionHandler: { (error) in
                        if error != nil {
                            KBLog.log(message: "Error in saving user info ", object: error)
                        }
                    })
                }
                else {
                    KBLog.log(message: "Error in Send bird login user", object: user)
                }
            })
        }
    }
    
    func disconnect() {
        SBDMain.disconnect { 
            KBLog.log("Disconnected")
        }
    }
}
