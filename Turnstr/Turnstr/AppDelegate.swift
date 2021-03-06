//
//  AppDelegate.swift
//  Turnstr
//
//  Created by Mr X on 09/05/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import SendBirdSDK
import TwitterKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var hud = MBProgressHUD()
    
    var callManager = SpeakerboxCallManager()
    var providerDelegate: ProviderDelegate?
    var onGoingCall : SpeakerboxCall? = nil
    var caller: Caller?
    
    let objCustomAlert:CustomAlertView? = CustomAlertView()
    let lblText = UILabel()
    //var isTabChanges = false
    
    static var shared: AppDelegate? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return delegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.sharedManager().enable = true
        //application.isStatusBarHidden = true
        
        
        /*
         * Internet Reachability
         */
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        //SandBird Integration
        SBDMain.initWithApplicationId(kSendBirdAppId)
        connectSendBirdSession()
        
        //Register APNS
        registerForAPNS(application)
        
        registerVOIP()
        
        //Twitter
        TWTRTwitter.sharedInstance().start(withConsumerKey:"ooB5hkXlA5M2InA33KiLEkEww", consumerSecret:"EqyxL5K3egjBuYoghZ3FtTBFqrB4Il7F1b9hIrJM1PVbvE9uH3")

        //CallSession.sharedInstance.connectSession()
        
        
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
        SVProgressHUD.show()
        
    }
    
    func loadingIndicationCreationMSG(msg: String) -> Void {
        SVProgressHUD.show(withStatus: msg)
        //hud = MBProgressHUD.showAdded(to: window, animated: true)
        //hud.labelText = msg
    }
    
    func hideLoadingIndicator() -> Void {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            //MBProgressHUD.hide(for: self.window, animated: true)
        }
    }
    
    //MARK:- Internet Reachability
    
    @objc func networkStatusChanged(_ notification: Notification) {
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId = AccessToken.current?.appID
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" { // facebook
            return true
        }
        if TWTRTwitter.sharedInstance().application(app, open:url, options: options) {
            return true
        }
        return true
    }
    
    
    //MARK:- Logout
    
    func LogoutFromApp() -> Void {
        
        DataServiceModal.sharedInstance.deleteRequest(logout) { (data, error) -> Void? in
            KBLog.log(message: "delete response", object: "\(error) ==> \(data)")
        }
        
        guard let navC = self.window?.rootViewController as? UINavigationController else { return }
        Utility.sharedInstance.removeUserDefaults(key: kUDLoginData)
        Utility.sharedInstance.removeUserDefaults(key: kUDSessionData)
        Singleton.sharedInstance.clearData()
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        navC.popToRootViewController(animated: true)
        disconnect()
    }
}


extension AppDelegate {
    func connectSendBirdSession() {
        if isLoggedIn == true, let id = loginUser.id {
            SBDMain.connect(withUserId: id, completionHandler: {[weak self] (user, error) in
                if error == nil {
                    let strUrls = self?.loginUser.cubeUrls.map({ ($0.absoluteString) }).joined(separator: ",")
                    SBDMain.updateCurrentUserInfo(withNickname: self?.loginUser.name, profileUrl: strUrls, completionHandler: { (error) in
                        if error != nil {
                            KBLog.log(message: "Error in saving user info ", object: error)
                        }
                    })
                    
                    if let token = SBDMain.getPendingPushToken() {
                        SBDMain.registerDevicePushToken(token, unique: true, completionHandler: { (status, error) in
                            KBLog.log(message: "Error in saving device token ", object: error)
                        })
                    }
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
