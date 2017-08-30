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

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    //MARK: - NSNotification Methods
    func registerForAPNS(_ application: UIApplication){
        
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            application.registerForRemoteNotifications()
//            
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
        
        let notificaitonSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificaitonSettings)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = NSString(format: "%@",deviceToken as CVarArg) as String
        token = token.trimmingCharacters(in: CharacterSet(charactersIn: "<>")) as String
        token = token.replacingOccurrences(of: " ", with: "")
        print("TOKEN = \(token)")
        UDKeys.deviceToken.save(value: deviceToken)
        
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
