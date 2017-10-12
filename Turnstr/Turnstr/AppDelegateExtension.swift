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
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) {  (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func registerVOIP() {
        
        let mainQueue = DispatchQueue.main
        // Create a push registry object
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        
        // Set the registry's delegate to self
        voipRegistry.delegate = self
        
        // Set the push type to VoIP
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = NSString(format: "%@",deviceToken as CVarArg) as String
        token = token.trimmingCharacters(in: CharacterSet(charactersIn: "<>")) as String
        token = token.replacingOccurrences(of: " ", with: "")
        KBLog.log(message: "device token", object: token)
        UDKeys.deviceToken.save(value: deviceToken)
        
        
        Messaging.messaging().apnsToken = deviceToken
        
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        KBLog.log(message: "fcm token", object: fcmToken)
        
        updateFcm(fcmToken)
        
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
    
    @objc(application:didRegisterUserNotificationSettings:) func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none{
            application.registerForRemoteNotifications()
        }
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
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func redirectApns(_ userInfo: [AnyHashable: Any]){
        
    }
}

extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
        let token = credentials.token
        var pushToken = ""
        for i in 0..<token.count {
            pushToken = pushToken + String(format: "%02.2hhx", arguments: [token[i]])
        }
    }
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        let info = payload.dictionaryPayload
        KBLog.log(message: "Receive Push", object: info)
        guard let aps = info["aps"] as? [String: Any],
            let name = aps["alert"] as? String
            else {return}
        var caller = Caller(name: name)
        caller.sessionId = "\(info["sessionId"] ?? "")"
        caller.token = "\(info["token"] ?? "")"
        caller.udid = "\(info["udid"] ?? "")"
        caller.isCalling = false
        let callType = "\(info["callType"] ?? "")"
        if callType == "CALLING" {
            caller.isVideo = false
        }
        else {
            caller.isVideo = true
        }
        displayIncomingCall(uuid: UUID(), handle: name, hasVideo: caller.isVideo)
    }
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenForType type: PKPushType) {
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
        updateFcm(fcmToken)
    }
    
    func updateFcm(_ token: String) {
        if isLoggedIn {
            kBQ_FCMTokenUpdate.async {
                let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: kSaveTokenToServer, dictData: [
                    "device[device_udid]" : Device.udid.value,
                    "device[device_push_token]" : token,
                    "device[device_name]" : Device.name.value,
                    "device[device_ios]" : Device.version.value
                    ])
                print(response)
            }
            
        }
    }
}
