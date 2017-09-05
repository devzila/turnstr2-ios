/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	CallKit provider delegate class, which conforms to CXProviderDelegate protocol
*/

import Foundation
import UIKit
import CallKit

final class ProviderDelegate: NSObject, CXProviderDelegate {

    let callManager: SpeakerboxCallManager
    private let provider: CXProvider

    init(callManager: SpeakerboxCallManager) {
        self.callManager = callManager
        provider = CXProvider(configuration: type(of: self).providerConfiguration)

        super.init()

        provider.setDelegate(self, queue: nil)
    }

    /// The app's provider configuration, representing its CallKit capabilities
    static var providerConfiguration: CXProviderConfiguration {
        let localizedName = NSLocalizedString("Workcocoon", comment: "Provider")
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)

        providerConfiguration.supportsVideo = true

        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.maximumCallGroups = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        if let iconMaskImage = UIImage(named: "IconMask")
        {
            
            providerConfiguration.iconTemplateImageData = UIImagePNGRepresentation(iconMaskImage)
            
        }

        providerConfiguration.ringtoneSound = "preeti.mp3"

        return providerConfiguration
    }

    // MARK: Incoming Calls
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let handle = url.startCallHandle else {
            print("Could not determine start call handle from URL: \(url)")
            return false
        }
        
        callManager.startCall(handle: handle)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let handle = userActivity.startCallHandle else {
            print("Could not determine start call handle from user activity: \(userActivity)")
            return false
        }
        
        guard let video = userActivity.video else {
            print("Could not determine video from user activity: \(userActivity)")
            return false
        }
        
        callManager.startCall(handle: handle, video: video)
        
        
        return true
    }

    
    /// Use CXProvider to report the incoming call to the system
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = true, completion: ((NSError?) -> Void)? = nil) {
        // Construct a CXCallUpdate describing the incoming call, including the caller.
        
        
        let update = CXCallUpdate()
        update.supportsHolding = false
        update.supportsGrouping = false
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        update.hasVideo = hasVideo
        
               // Report the incoming call to the system
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            /*
                Only add incoming call to the app's list of calls if the call was allowed (i.e. there was no error)
                since calls may be "denied" for various legitimate reasons. See CXErrorCodeIncomingCallError.
             */
            if error == nil {
                let call = SpeakerboxCall(uuid: uuid)
                call.handle = handle

                print("accept call Presssed")
                self.callManager.addCall(call)
                AppDelegate.shared?.onGoingCall = call
            }
            
            completion?(error as NSError?)
        }
    }

    // MARK: CXProviderDelegate

    func providerDidReset(_ provider: CXProvider) {
        print("Provider did reset")

        stopAudio()

        /*
            End any ongoing calls if the provider resets, and remove them from the app's list of calls,
            since they are no longer valid.
         */
        for call in callManager.calls {
            call.endSpeakerboxCall()
        }

        // Remove all calls from the app's list of calls.
        callManager.removeAllCalls()
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        // Create & configure an instance of SpeakerboxCall, the app's model class representing the new outgoing call.
        let call = SpeakerboxCall(uuid: action.callUUID, isOutgoing: true)
        call.handle = action.handle.value

        /*
            Configure the audio session, but do not start call audio here, since it must be done once
            the audio session has been activated by the system after having its priority elevated.
         */
        configureAudioSession()

        /*
            Set callback blocks for significant events in the call's lifecycle, so that the CXProvider may be updated
            to reflect the updated state.
         */
        call.hasStartedConnectingDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: call.connectingDate)
        }
        call.hasConnectedDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, connectedAt: call.connectDate)
        }

        // Trigger the call to be started via the underlying network service.
        call.startSpeakerboxCall { success in
            if success {
                // Signal to the system that the action has been successfully performed.
                action.fulfill()

                // Add the new outgoing call to the app's list of calls.
                self.callManager.addCall(call)
            } else {
                // Signal to the system that the action was unable to be performed.
                action.fail()
            }
        }
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
       AppDelegate.shared?.onGoingCall = call
        /*
            Configure the audio session, but do not start call audio here, since it must be done once
            the audio session has been activated by the system after having its priority elevated.
         */
        configureAudioSession()

        // Trigger the call to be answered via the underlying network service.
        call.answerSpeakerboxCall()

        // Signal to the system that the action has been successfully performed.
        action.fulfill()
        
        AppDelegate.shared?.onGoingCall = call
        AppDelegate.shared?.callManager = callManager
        
//        
//        guard let vc = StoryboardScene.Camera.callVCScene.viewController() as? CallVC,
//            let topVC = AppDelegate.shared?.window?.topViewController(),
//        let caller = AppDelegate.shared?.caller
//        else {
//            self.callManager.end(call: call)
//            return
//        }
//        vc.caller = caller
//        topVC.present(vc, animated: true, completion: nil)
        
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }

        // Stop call audio whenever ending the call.
        stopAudio()

        // Trigger the call to be ended via the underlying network service.
        call.endSpeakerboxCall()

        // Signal to the system that the action has been successfully performed.
        action.fulfill()

        // Remove the ended call from the app's list of calls.
        callManager.removeCall(call)
        
//        guard let sessionId = AppDelegate.shared?.caller?.sessionId else { return }
//        let router = ColleagueEndPoints.endCall(sessionId: sessionId, type: kVideo)
//        APIManager.shared.request(with: router) {(response) in
        
//            let notification = UILocalNotification()
//            notification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
//            notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
//            notification.alertAction = "be awesome!"
//            notification.userInfo = ["CustomField1": "w00t"]
//            UIApplication.shared.scheduleLocalNotification(notification)
//        KBLog.log(message: "response", object: response)
//        }
    }
    

    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }

        // Update the SpeakerboxCall's underlying hold state.
        call.isOnHold = action.isOnHold

        // Stop or start audio in response to holding or unholding the call.
        if call.isOnHold {
            stopAudio()
        } else {
            startAudio()
        }
        // Signal to the system that the action has been successfully performed.
        
        action.fulfill()
    }

    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        print("Timed out \(#function)")
        // React to the action timeout if necessary, such as showing an error UI.
        
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("Received \(#function)")

        
        //Maninder call started
        // Start call audio media, now that the audio session has been activated after having its priority boosted.
        startAudio()
        
       // app().enableSoundDevice()
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("Received \(#function)")
        /*
             Restart any non-call related audio now that the app's audio session has been
             de-activated after having its priority restored to normal.
         */
        
    }
    
    func removeCallforcefully() {
        
    }

}
