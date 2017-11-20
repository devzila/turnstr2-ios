//
//  MultiCallViewController.swift
//  Turnstr
//
//  Created by Mr. X on 07/11/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import OpenTok

class MultiCallViewController: ParentViewController, UserListDelegate {

    // *** Fill the following variables using your own Project info  ***
    // ***            https://tokbox.com/account/#/                  ***
    
    
    // Replace with your generated session ID
    //let kTokBoxSessionId = "1_MX40NTkxMDM5Mn5-MTUxMDA1Mjk1MTA0NX5lM0JlQXZFdlpBMXZUWnlqa1kxVitFcjZ-fg"
    // Replace with your generated token
    //let kPublisherToken1 = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9NzlmODBmNGMzYmU5NDZjYWY1ODJkMGQwZDFmNTQ4MjBiZDIyMzMyMjpzZXNzaW9uX2lkPTFfTVg0ME5Ua3hNRE01TW41LU1UVXhNREExTWprMU1UQTBOWDVsTTBKbFFYWkZkbHBCTVhaVVdubHFhMWt4Vml0RmNqWi1mZyZjcmVhdGVfdGltZT0xNTEwMDUyOTc4Jm5vbmNlPTAuODAyMzkwNjI3NjEwMjk2MSZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTEyNjQ0OTc2JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9"
    
    //let kPublisherToken2 = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9MjgwOTVkZGM5NzQ3NmQ1MjEzM2Q5ZWUxZmI4YjhkYTgyNTc3ZjA5ZDpzZXNzaW9uX2lkPTFfTVg0ME5Ua3hNRE01TW41LU1UVXhNREExTWprMU1UQTBOWDVsTTBKbFFYWkZkbHBCTVhaVVdubHFhMWt4Vml0RmNqWi1mZyZjcmVhdGVfdGltZT0xNTEwMDUzMDI3Jm5vbmNlPTAuNjc0MjMwNDQwNDg0MzE0NyZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTEyNjQ1MDI1JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9"
    
    //let kPublisherToken3 = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9NTIxYzE2YjMzYTA2NGUxNzIxODgxZDBiNGU4OGIwZjc2ZWJhMDUxZTpzZXNzaW9uX2lkPTFfTVg0ME5Ua3hNRE01TW41LU1UVXhNREExTWprMU1UQTBOWDVsTTBKbFFYWkZkbHBCTVhaVVdubHFhMWt4Vml0RmNqWi1mZyZjcmVhdGVfdGltZT0xNTEwMTU3ODM1Jm5vbmNlPTAuMTc5NTU4MzcxNTQyNzgwNDMmcm9sZT1wdWJsaXNoZXImZXhwaXJlX3RpbWU9MTUxMjc0OTgzNCZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ=="
    
    //let kPublisherToken4 = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9MzUwNmQyOGNlMzc3Nzc2YmQ3N2JjMWI2Yzg5ZDcxZWU5MjZkOTIxZDpzZXNzaW9uX2lkPTFfTVg0ME5Ua3hNRE01TW41LU1UVXhNREExTWprMU1UQTBOWDVsTTBKbFFYWkZkbHBCTVhaVVdubHFhMWt4Vml0RmNqWi1mZyZjcmVhdGVfdGltZT0xNTEwMTU3ODY5Jm5vbmNlPTAuNTE0MzE1NjQwMjA5MzkzOCZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTEyNzQ5ODY3JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9"
    
    /*
     *-----------------------------------
     */
    
    var kTokBoxSessionID = ""
    var kPublisherToken = ""
    
    enum CallUserType {
        case caller
        case receiver
    }
    enum callType {
        case goLive
        case videoCall
    }
    
    var userType: CallUserType = .receiver
    var screenTYPE: callType = .videoCall
    var kToken = ""
    var recieverId = ""
    var publisherView = UIView()
    
    @IBOutlet var endCallButton: UIButton!
    @IBOutlet var swapCameraButton: UIButton!
    @IBOutlet var muteMicButton: UIButton!
    @IBOutlet var userName: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var btnAddUser: UIButton!
    
    var subscribers: [IndexPath: OTSubscriber] = [:]
    lazy var session: OTSession = {
        return OTSession(apiKey: kTokBoxApiKey, sessionId: self.kTokBoxSessionID, delegate: self)!
    }()
    lazy var publisher: OTPublisher = {
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        return OTPublisher(delegate: self, settings: settings)!
    }()
    var error: OTError?
    
    //MARK:-
    //MARK: View Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        endCallButton.isEnabled = true
        
        switch userType {
        case .caller:
            kAppDelegate.loadingIndicationCreationMSG(msg: "")
            
            callApi()
            break
        case .receiver:
            
            break
        }
        //kToken = kPublisherToken
        
        /*if Singleton.sharedInstance.strUserID == "106" {
            kToken = kPublisherToken1
            
        } else if Singleton.sharedInstance.strUserID == "108" {
            kToken = kPublisherToken2
            
        } else if Singleton.sharedInstance.strUserID == "104" {
            kToken = kPublisherToken3
            
        } else {
            kToken = kPublisherToken4
            
        }*/
        
        //session.connect(withToken: kToken, error: &error)
        
        startConnectingTokBox()
        userName.text = UIDevice.current.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true
        resetSubscriberViews()
    }
    
    func resetSubscriberViews() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if subscribers.count == 1 {
            layout.itemSize = CGSize(width: collectionView.bounds.size.width ,/// 2
                height: collectionView.bounds.size.height/2)
        }
        else {
            layout.itemSize = CGSize(width: collectionView.bounds.size.width/2 ,/// 2
                height: collectionView.bounds.size.height/2)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func swapCameraAction(_ sender: AnyObject) {
        if publisher.cameraPosition == .front {
            publisher.cameraPosition = .back
        } else {
            publisher.cameraPosition = .front
        }
    }
    
    @IBAction func tokboxButtonAction(_ sender: AnyObject) {
        
        UIApplication.shared.open(URL(string: "https://www.tokbox.com/developer/")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func muteMicAction(_ sender: AnyObject) {
        publisher.publishAudio = !publisher.publishAudio
        
        let buttonImage: UIImage  = {
            if !publisher.publishAudio {
                return #imageLiteral(resourceName: "mic_muted-24")
            } else {
                return #imageLiteral(resourceName: "mic-24")
            }
        }()
        
        muteMicButton.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func endCallAction(_ sender: AnyObject) {
        session.disconnect(&error)
        kAppDelegate.hideLoadingIndicator()
        self.goBack()
    }
    
    func reloadCollectionView() {
        resetSubscriberViews()
        collectionView.isHidden = subscribers.count == 0
        collectionView.reloadData()
    }
    @IBAction func AddUserInCall(_ sender: UIButton) {
        
        if screenTYPE == .videoCall {
            if subscribers.count == 3 {
                Utility.sharedInstance.showAlert(title: "Limit Reached", forMsg: "Maximum 4 users can join the call!!!")
                return
            }
        }
        
        
        guard let vc = Storyboards.chatStoryboard.initialVC(with: .usersList) else { return }
        let vcc = vc as! UsersListVC
        vcc.screenTYpe = .calling
        vcc.delegate = self
        present(vcc, animated: true, completion: nil)
    }
    
    func UserSelected(userId: String) {
        self.recieverId = userId
        kAppDelegate.loadingIndicationCreation()
        AddUserInCall()
    }
    
    //MARK:- APi
    
    func AddUserInCall() {
        
        print(self.recieverId)
        kBQ_startCall .async {
            let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: "user/live_session", dictData: ["invitees[]":"\(self.recieverId)"])
            print(response)
            if response.count > 0 {
                DispatchQueue.main.async {
                    kAppDelegate.hideLoadingIndicator()
                }
                
            }
        }
        
    }
    
    func callApi() {
        print(self.recieverId)
        kBQ_startCall .async {
            //let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: "members/\(self.recieverId)/invite", dictData: [:])
            let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: "user/live_session", dictData: ["invitees[]":"\(self.recieverId)"])
            print(response)
            if response.count > 0 {
                DispatchQueue.main.async {
                    if let session = response["session"] as? Dictionary<String, Any> {
                        let objSession = Session.init(session: session)
                        self.kPublisherToken = objSession.token
                        self.kTokBoxSessionID = objSession.session_id
                        
                        print(self.kPublisherToken)
                        print(self.kTokBoxSessionID)
                        
                        self.startConnectingTokBox()
                        kAppDelegate.hideLoadingIndicator()
                    }
                     kAppDelegate.hideLoadingIndicator()
                }
                
            }
        }
    }
    
    func startConnectingTokBox() {
        
        if kPublisherToken.isEmpty == true || kTokBoxSessionID.isEmpty == true {
            //Utility.sharedInstance.showAlert(title: "Error", forMsg: "Session not valid")
            return
        }
        
        kToken = kPublisherToken
        //kTokBoxSessionID = "2_MX40NTkxMDM5Mn5-MTUxMDA4MDA0MDc1OX5vYXNveWZzVVZwazk3L1ZUVVErZHEvUUh-fg"
        //kToken = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9ZGViOGZlYTQ1ZDUyNGZmNjA1ZmEyZjgyMmYxY2NmZDI3ZjcyNGU0Mzpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTJfTVg0ME5Ua3hNRE01TW41LU1UVXhNREE0TURBME1EYzFPWDV2WVhOdmVXWnpWVlp3YXprM0wxWlVWVkVyWkhFdlVVaC1mZyZjcmVhdGVfdGltZT0xNTEwMTQwMzc4Jm5vbmNlPTAuODc3MTIxOTU3NzU4NzgwMg=="
        
        print("TokenTok: \(kToken)")
        print("SessionTok: \(kTokBoxSessionID)")
        session.connect(withToken: kToken, error: &error)
    }
    
}

extension MultiCallViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resetPublisherView()
        return subscribers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriberCell", for: indexPath) as! SubscriberCollectionCell
        cell.subscriber = subscribers[indexPath]
        return cell
    }
}

extension MultiCallViewController: UICollectionViewDelegate {
}

// MARK: - Subscriber Cell
class SubscriberCollectionCell: UICollectionViewCell {
    @IBOutlet var muteButton: UIButton!
    
    var subscriber: OTSubscriber?
    
    @IBAction func muteSubscriberAction(_ sender: AnyObject) {
        subscriber?.subscribeToAudio = !(subscriber?.subscribeToAudio ?? true)
        
        let buttonImage: UIImage  = {
            if !(subscriber?.subscribeToAudio ?? true) {
                return #imageLiteral(resourceName: "Subscriber-Speaker-Mute-35")
            } else {
                return #imageLiteral(resourceName: "Subscriber-Speaker-35")
            }
        }()
        
        muteButton.setImage(buttonImage, for: .normal)
    }
    
    override func layoutSubviews() {
        if let sub = subscriber, let subView = sub.view {
            subView.frame = bounds
            contentView.insertSubview(subView, belowSubview: muteButton)
            
            muteButton.isEnabled = true
            muteButton.isHidden = false
        }
    }
}

// MARK: - OpenTok Methods
extension MultiCallViewController {
    func doPublish() {
        swapCameraButton.isEnabled = true
        muteMicButton.isEnabled = true
        endCallButton.isEnabled = true
        
        if let pubView = publisher.view {
            publisherView = pubView
            
            resetPublisherView()
            view.addSubview(publisherView)
            
        }
        
        session.publish(publisher, error: &error)
    }
    
    func resetPublisherView() {
        if subscribers.count == 0 {
            let publisherDimensions = CGSize(width: collectionView.bounds.size.width ,
                height: collectionView.bounds.size.height)
            publisherView.frame = CGRect(origin: CGPoint(x:collectionView.bounds.size.width - publisherDimensions.width,
                                                         y:collectionView.bounds.size.height - publisherDimensions.height + collectionView.frame.origin.y),
                                         size: publisherDimensions)
        }
        else if subscribers.count == 1 {
            let publisherDimensions = CGSize(width: collectionView.bounds.size.width ,
                                             height: collectionView.bounds.size.height/2)
            publisherView.frame = CGRect(origin: CGPoint(x:collectionView.bounds.size.width - publisherDimensions.width,
                                                         y:collectionView.bounds.size.height - publisherDimensions.height + collectionView.frame.origin.y),
                                         size: publisherDimensions)
        }
        else {
            let publisherDimensions = CGSize(width: collectionView.bounds.size.width/2 ,
                height: collectionView.bounds.size.height/2)
            publisherView.frame = CGRect(origin: CGPoint(x:collectionView.bounds.size.width - publisherDimensions.width,
                                                         y:collectionView.bounds.size.height - publisherDimensions.height + collectionView.frame.origin.y),
                                         size: publisherDimensions)
        }
    }
    
    func doSubscribe(to stream: OTStream) {
        if let subscriber = OTSubscriber(stream: stream, delegate: self) {
            let indexPath = IndexPath(item: subscribers.count, section: 0)
            subscribers[indexPath] = subscriber
            session.subscribe(subscriber, error: &error)
            
            reloadCollectionView()
        }
    }
    
    func findSubscriber(byStreamId id: String) -> (IndexPath, OTSubscriber)? {
        for (_, entry) in subscribers.enumerated() {
            if let stream = entry.value.stream, stream.streamId == id {
                return (entry.key, entry.value)
            }
        }
        return nil
    }
    
    func findSubscriberCell(byStreamId id: String) -> SubscriberCollectionCell? {
        for cell in collectionView.visibleCells {
            if let subscriberCell = cell as? SubscriberCollectionCell,
                let subscriberOfCell = subscriberCell.subscriber,
                (subscriberOfCell.stream?.streamId ?? "") == id
            {
                return subscriberCell
            }
        }
        
        return nil
    }
}

// MARK: - OTSession delegate callbacks
extension MultiCallViewController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
        doPublish()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
        subscribers.removeAll()
        reloadCollectionView()
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        if subscribers.count == 4 {
            print("Sorry this sample only supports up to 4 subscribers :)")
            return
        }
        doSubscribe(to: stream)
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        
        guard let (index, subscriber) = findSubscriber(byStreamId: stream.streamId) else {
            return
        }
        subscriber.view?.removeFromSuperview()
        subscribers.removeValue(forKey: index)
        reloadCollectionView()
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
}

// MARK: - OTPublisher delegate callbacks
extension MultiCallViewController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("Publisher failed: \(error.localizedDescription)")
    }
}

// MARK: - OTSubscriber delegate callbacks
extension MultiCallViewController: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        print("Subscriber connected")
        reloadCollectionView()
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
    
    func subscriberVideoDataReceived(_ subscriber: OTSubscriber) {
    }
}

struct Session {
    var session_id: String
    var token: String
    
    init(session: Dictionary<String, Any>) {
        
        self.session_id = ""
        self.token = ""
        
        if let session_id = session["session_id"] as? String {
            self.session_id = session_id
        } else {
            self.session_id = ""
        }
        
        if let token = session["token"] as? String {
            self.token = token
        } else {
            self.token = ""
        }
    }
    
}

