//
//  CallSession.swift
//  Turnstr
//
//  Created by Mr. X on 04/11/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import OpenTok

class CallSession: NSObject, OTSessionDelegate {

    static let sharedInstance: CallSession = {
        let instance = CallSession()
        
        return instance
    }()
    
    //MARK:
    //MARK: TokBox Settings
    //MARK:
    
    func connectSession() {
        var error: OTError?
        _ = session
        session.connect(withToken: kSubscriberToken, error: &error)
        
        print("Connect error: \(String(describing: error?.localizedDescription))")
        
    }
    
    lazy var session: OTSession = {
        return OTSession(apiKey: kTokBoxApiKey, sessionId: kTokBoxSessionId, delegate: self)!
    }()
    
    // MARK: - OTSession delegate callbacks
    
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
        
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        print("Signal received call session")
        print(type ?? "No Type")
        print(string ?? "No String")
        if type == callType.OneOneCall.rawValue && string != Singleton.sharedInstance.strUserID {
            let toast = UIAlertController(title: "Call Received", message: "Do you want to answer?", preferredStyle: .alert)
            let OKAction: UIAlertAction = UIAlertAction(title: "YES", style: .default) { action -> Void in
                //Just dismiss the action sheet
                let vc = OneOneCallVC()
                vc.userType = .receiver
                if let navigation = kAppDelegate.window?.rootViewController as? UINavigationController {
                    navigation.pushViewController(vc, animated: true)
                }
                
            }
            let cancelAction: UIAlertAction = UIAlertAction(title: "NO", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            toast.addAction(OKAction)
            toast.addAction(cancelAction)
            kAppDelegate.window?.rootViewController?.present(toast, animated: true, completion: nil)
        }
    }
}
