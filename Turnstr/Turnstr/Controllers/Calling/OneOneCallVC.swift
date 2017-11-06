//
//  OneOneCallVC.swift
//  Turnstr
//
//  Created by Mr. X on 04/11/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import OpenTok



let kWidgetHeight = kCenterH
let kWidgetWidth = kWidth

class OneOneCallVC: ParentViewController {

    enum CallUserType {
        case caller
        case receiver
    }
    var userType: CallUserType = .caller
    var kToken = kPublisherToken
    var callsession = CallSession.sharedInstance.session
    var btnEndCall = UIButton()
    var recieverId = ""
    
    
    let customAudioDevice = DefaultAudioDevice.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        OTAudioDeviceManager.setAudioDevice(customAudioDevice)
        
        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        switch userType {
        case .caller:
            kToken = kPublisherToken
            callApi()
        case .receiver:
            kToken = kSubscriberToken
        }
        
        kAppDelegate.loadingIndicationCreationMSG(msg: "Calling...")
        doConnect()
        
        EndCallButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- View Settings
    
    func EndCallButton() {
        btnEndCall.frame = CGRect.init(x: kCenterW-50, y: kHeight-120, width: 100, height: 100)
        btnEndCall.addTarget(self, action: #selector(EndCall(sender:)), for: .touchUpInside)
        btnEndCall.setImage(#imageLiteral(resourceName: "end_call"), for: .normal)
        self.view.addSubview(btnEndCall)
    }
    
    //MARK:- Action Mthods
    
    func EndCall(sender: UIButton) {
        kAppDelegate.hideLoadingIndicator()
        self.goBack()
    }
    //MARK:
    //MARK: TokBox Settings
    //MARK:
    lazy var session: OTSession = {
        return OTSession(apiKey: kTokBoxApiKey, sessionId: kTokBoxSessionId, delegate: self)!
    }()
    
    lazy var publisher: OTPublisher = {
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        return OTPublisher(delegate: self, settings: settings)!
    }()
    
    var subscriber: OTSubscriber?
    
    // Change to `false` to subscribe to streams other than your own.
    var subscribeToSelf = false
    
    
    /**
     * Asynchronously begins the session connect process. Some time later, we will
     * expect a delegate method to call us back with the results of this action.
     */
    fileprivate func doConnect() {
        var error: OTError?
        defer {
            processError(error)
        }
        
        session.connect(withToken: kToken, error: &error)
        
        print("Connect error: \(String(describing: error?.localizedDescription))")
        
    }
    
    /**
     * Sets up an instance of OTPublisher to use with this session. OTPubilsher
     * binds to the device camera and microphone, and will provide A/V streams
     * to the OpenTok session.
     */
    fileprivate func doPublish() {
        var error: OTError?
        defer {
            processError(error)
        }
        
        session.publish(publisher, error: &error)
        
        if let pubView = publisher.view {
            pubView.frame = CGRect(x: 0, y: 0, width: kWidgetWidth, height: kWidgetHeight)
            view.addSubview(pubView)
        }
    }
    
    /**
     * Instantiates a subscriber for the given stream and asynchronously begins the
     * process to begin receiving A/V content for this stream. Unlike doPublish,
     * this method does not add the subscriber to the view hierarchy. Instead, we
     * add the subscriber only after it has connected and begins receiving data.
     */
    fileprivate func doSubscribe(_ stream: OTStream) {
        var error: OTError?
        defer {
            processError(error)
        }
        subscriber = OTSubscriber(stream: stream, delegate: self)
        
        session.subscribe(subscriber!, error: &error)
    }
    
    fileprivate func cleanupSubscriber() {
        subscriber?.view?.removeFromSuperview()
        subscriber = nil
    }
    
    fileprivate func processError(_ error: OTError?) {
        if let err = error {
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }

    //MARK:- APi
    
    func callApi() {
        print(self.recieverId)
        kBQ_startCall .async {
            let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: "members/\(self.recieverId)/invite", dictData: [:])
            //let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: "user/live_session", dictData: ["invitees[]":"\(self.recieverId)"])
            print(response)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - OTSession delegate callbacks
extension OneOneCallVC: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
        
        var error: OTError?
        
        if userType == .caller {
            //session.signal(withType: callType.OneOneCall.rawValue, string: Singleton.sharedInstance.strUserID, connection: session.connection, error: &error)
            //callsession.signal(withType: callType.OneOneCall.rawValue, string: Singleton.sharedInstance.strUserID, connection: session.connection, error: &error)
            //print("Signal Error: \(String(describing: error?.localizedDescription))")
            
        }
        
        doPublish()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        if subscriber == nil && !subscribeToSelf {
            doSubscribe(stream)
        }
        kAppDelegate.hideLoadingIndicator()
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
        kAppDelegate.hideLoadingIndicator()
    }
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        print("Signal received oneone")
        print(type ?? "No Type")
        print(string ?? "No String")
    }
}

// MARK: - OTPublisher delegate callbacks
extension OneOneCallVC: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        if subscriber == nil && subscribeToSelf {
            doSubscribe(stream)
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("Publisher failed: \(error.localizedDescription)")
    }
}

// MARK: - OTSubscriber delegate callbacks
extension OneOneCallVC: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        if let subsView = subscriber?.view {
            subsView.frame = CGRect(x: 0, y: kWidgetHeight, width: kWidgetWidth, height: kWidgetHeight)
            view.addSubview(subsView)
            btnEndCall.bringSubview(toFront: view)
        }
        
        kAppDelegate.hideLoadingIndicator()
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
}

