//
//  AppDelegateExtension.swift
//  Menu Venue
//
//  Created by Kamal on 8/26/16.
//  Copyright © 2016 Kamal. All rights reserved.
//

import Foundation
import SendBirdSDK
import UserNotifications
import PushKit
import Firebase

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    //MARK: - NSNotification Methods
    func registerForAPNS(_ application: UIApplication){
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) {  (granted, error) in
            if error == nil{
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func registerVOIP() {
        
        providerDelegate = ProviderDelegate(callManager: callManager)
        
        let mainQueue = DispatchQueue.main
        // Create a push registry object
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        
        // Set the registry's delegate to self
        voipRegistry.delegate = self
        
        // Set the push type to VoIP
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        registerVOIP()
        
        var token = NSString(format: "%@",deviceToken as CVarArg) as String
        token = token.trimmingCharacters(in: CharacterSet(charactersIn: "<>")) as String
        token = token.replacingOccurrences(of: " ", with: "")
        KBLog.log(message: "device token", object: token)
        UDKeys.deviceToken.save(value: deviceToken)
        
        
        Messaging.messaging().apnsToken = deviceToken
        
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        KBLog.log(message: "fcm token", object: fcmToken)
        UDKeys.fcm.save(value: fcmToken)
        updateFcm()
        
        SBDMain.registerDevicePushToken(deviceToken, unique: true) { (status, error) in
            if error == nil {
                if status == .pending {
                    KBLog.log("Registration Pending")
                }
                else {
                    KBLog.log("Registration Successful")
                }
            }
            else {
                KBLog.log(message: "Registration fail", object: error)
            }
        }
    }
    
    func  application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Register notification Error = \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Remote notification user info = \(userInfo)")
        redirectApns(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Remote notification user info = \(userInfo)")
        redirectApns(userInfo)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive response: \(response.notification.request.content.userInfo)")
        redirectApns(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent notification: \(notification.request.content.userInfo)")
        redirectApns(notification.request.content.userInfo)
        //completionHandler([.alert, .sound])
    }
    
    func redirectApns(_ userInfo: [AnyHashable: Any]){
        
        if userInfo.count > 0 {
            let info = userInfo
            KBLog.log(message: "Receive Push redirectApns: ", object: info)
            guard let aps = info["aps"] as? [String: Any],
                let alert = aps["alert"] as? [String: Any],
                let name = alert["body"] as? String
                else {return}
            var caller = Caller(name: name)
            caller.sessionId = "\(info["caller_tokbox_session_id"] ?? "")"
            caller.token = "\(info["token"] ?? "")"
            caller.udid = "\(info["udid"] ?? "")"
            caller.isCalling = false
            
            let callType = "\(info["call_type"] ?? "")"
            
            if callType == "go_live_subscription" {
                AppDelegate.shared?.caller = caller
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    
                    self.lblText.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: 150)
                    self.lblText.text = "\(name)"
                    self.lblText.textAlignment = .center
                    self.lblText.textColor = UIColor.white
                    self.lblText.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    
                    self.objCustomAlert!.containerView = self.lblText
                    
                    self.objCustomAlert!.alertBGColor = ["#181818", "#181818"]
                    self.objCustomAlert!.alertDismiss = onTouchDismiss.touchDismissNO
                    self.objCustomAlert?.buttonTitles = ["YES", "NO"]
                    self.objCustomAlert?.buttonColor = UIColor.white
                    
                    self.objCustomAlert?.onButtonTouchUpInside = { (alertView: CustomAlertView, buttonIndex: Int) -> Void in
                        if buttonIndex == 0 {
                            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
                            let vc: MultiCallViewController = storyboard.instantiateViewController(withIdentifier: "MultiCallViewController") as! MultiCallViewController
                            vc.userType = .receiver
                            vc.screenTYPE = .goLive
                            vc.kPublisherToken = caller.token ?? ""
                            vc.kTokBoxSessionID = caller.sessionId ?? ""
                            self.topVC?.navigationController?.pushViewController(vc, animated: false)
                            
                        } else {
                            
                        }
                        alertView.close()
                    }
                    
                    self.objCustomAlert!.show()
                    
                    
                    /*let alertView = UIAlertController(title: "\(name)", message: "Do you want to join?", preferredStyle: .alert)
                    let action = UIAlertAction(title: "YES", style: .default, handler: { (alert) in
                        
                        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
                        let vc: MultiCallViewController = storyboard.instantiateViewController(withIdentifier: "MultiCallViewController") as! MultiCallViewController
                        vc.userType = .receiver
                        vc.screenTYPE = .goLive
                        vc.kPublisherToken = caller.token ?? ""
                        vc.kTokBoxSessionID = caller.sessionId ?? ""
                        self.topVC?.navigationController?.pushViewController(vc, animated: false)
                        
                    })
                    alertView.addAction(action)
                    
                    let cancel = UIAlertAction(title: "NO", style: .destructive, handler: { (alert) in
                        
                    })
                    alertView.addAction(cancel)
                    self.topVC?.navigationController?.present(alertView, animated: true, completion: nil)*/
                    
                }
                
                
                return
            }
        }
        
    }
}

extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let token = credentials.token
        var pushToken = ""
        for i in 0..<token.count {
            pushToken = pushToken + String(format: "%02.2hhx", arguments: [token[i]])
        }
        UDKeys.voip.save(value: pushToken)
        updateFcm()
    }
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        let info = payload.dictionaryPayload
        KBLog.log(message: "Receive Push", object: info)
        guard let aps = info["aps"] as? [String: Any],
            let name = aps["alert"] as? String
            else {return}
        var caller = Caller(name: name)
        caller.sessionId = "\(info["caller_tokbox_session_id"] ?? "")"
        caller.token = "\(info["token"] ?? "")"
        caller.udid = "\(info["udid"] ?? "")"
        caller.isCalling = false
        
        if let call = info["call_type"] as? String {
            print(call)
        }
        
        let callType = "\(info["call_type"] ?? "")"
        caller.callType = callType
        
        if callType == "CALLING" {
            caller.isVideo = false
        }
        else if callType == "go_live_subscription" {
            
            let alertView = UIAlertController(title: "\(name)", message: "Do you want to join?", preferredStyle: .alert)
            let action = UIAlertAction(title: "YES", style: .default, handler: { (alert) in
                
                let storyboard = UIStoryboard(name: "Chat", bundle: nil)
                let vc: MultiCallViewController = storyboard.instantiateViewController(withIdentifier: "MultiCallViewController") as! MultiCallViewController
                vc.userType = .receiver
                vc.screenTYPE = .goLive
                vc.kPublisherToken = caller.token ?? ""
                vc.kTokBoxSessionID = caller.sessionId ?? ""
                self.topVC?.navigationController?.pushViewController(vc, animated: false)
                
            })
            alertView.addAction(action)
            
            let cancel = UIAlertAction(title: "NO", style: .destructive, handler: { (alert) in
                
            })
            alertView.addAction(cancel)
            self.topVC?.navigationController?.present(alertView, animated: true, completion: nil)
            
            
            return
        }
        else {
            caller.isVideo = true
        }
        
        AppDelegate.shared?.caller = caller
        AppDelegate.shared?.callManager = callManager
        displayIncomingCall(uuid: UUID(), handle: name, hasVideo: caller.isVideo)
    }
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("Invalid token")
    }
    
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = true, completion: ((NSError?) -> Void)? = nil) {
        
        providerDelegate?.reportIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo, completion: completion)
    }
}

//MARK: ------ Firebase
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String){
        
        KBLog.log(message: "fcm token ", object: fcmToken)
        UDKeys.fcm.save(value: fcmToken)
        updateFcm()
    }
    
    func updateFcm() {
        if isLoggedIn {
            kBQ_FCMTokenUpdate.async {
                let dict = ["device[device_udid]" : Device.udid.value,
                "device[device_push_token]" : Device.deviceToken.value,
                "device[device_name]" : Device.name.value,
                "device[device_ios]" : Device.version.value,
                "device[voip_token]": Device.voip.value
                ]
                KBLog.log(message: "dict param", object: dict)
                let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: kSaveTokenToServer, dictData: dict)
                print(response)
            }
            
        }
    }
}
