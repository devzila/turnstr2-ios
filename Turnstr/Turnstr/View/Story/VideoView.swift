//
//  VideoView.swift
//  Turnstr
//
//  Created by Mr X on 12/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import AVFoundation



class VideoView: UIView, AVCaptureFileOutputRecordingDelegate {

    var btnVideoCap = UIButton()
    var btnSelfiCap = UIButton()
    
    var timer: Timer? = nil
    let lengthAccepted = 5.0 as Float
    var cameraDevice : AVCaptureDevice?
    var captureAudio :AVCaptureDevice?
    var cameraPreviewlayer : AVCaptureVideoPreviewLayer?
    var cameraSession : AVCaptureSession?
    var videoFileOutput : AVCaptureMovieFileOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        
        //videoLength.hidden = true
        
        do {
            let documentsUrl = NSURL(string: documentPath)
            let directoryUrls = try  FileManager.default.contentsOfDirectory(at: documentsUrl! as URL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            print(directoryUrls)
            let movFiles = directoryUrls.filter{ $0.pathExtension == "mov" }.map{ $0.lastPathComponent }
            for strPath in movFiles{
                self.deleteFileAtPath(strPath: strPath)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        self.cameraSetup()
        //videoLength.value = 0.0
        
        
        
        CameraScreenButtons()
    }
    
    var documentPath : String{
        let paths : NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true) as NSArray
        return paths.object(at: 0) as! String
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Custom Methods
    func cameraSetup(){
        cameraSession = AVCaptureSession()
        cameraSession?.sessionPreset = AVCaptureSessionPresetMedium
        
        cameraPreviewlayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        cameraPreviewlayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewlayer?.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.layer.addSublayer(cameraPreviewlayer!)
        
        let devices: NSArray = AVCaptureDevice.devices(withMediaType: AVMediaTypeAudio) as NSArray
        for device in devices{
            if((device as AnyObject).hasMediaType(AVMediaTypeAudio)){
                captureAudio = device as? AVCaptureDevice //initialize audio
            }
        }
        self.initSessionWithCamera(cameraType: .RearCamera)
        
        videoFileOutput = AVCaptureMovieFileOutput()
        self.cameraSession?.addOutput(videoFileOutput)
        
        cameraSession?.startRunning()
    }
    
    func initSessionWithCamera(cameraType: Camera){
        
        let device = self.deviceWithMediaTypeWithPosition(mediaType: AVMediaTypeVideo as NSString, cameraType: cameraType)
        do {
            let inputCamera = try AVCaptureDeviceInput(device: device)
            if self.cameraSession!.canAddInput(inputCamera) {
                self.cameraSession!.addInput(inputCamera)
                self.cameraDevice = device
            }
        } catch {
            print(error)
        }
        
        do{
            let audioInput = try AVCaptureDeviceInput(device: captureAudio)
            if self.cameraSession!.canAddInput(audioInput){
                self.cameraSession?.addInput(audioInput)
            }
        }
        catch{
            print(error)
        }
    }
    
    func deviceWithMediaTypeWithPosition(mediaType: NSString, cameraType: Camera) -> AVCaptureDevice {
        let devices: NSArray = AVCaptureDevice.devices(withMediaType: mediaType as String) as NSArray
        var captureDevice: AVCaptureDevice = devices.firstObject as! AVCaptureDevice
        
        for device in devices {
            if cameraType == .RearCamera{
                if (device as AnyObject).position == AVCaptureDevicePosition.back{
                    captureDevice = (device as! AVCaptureDevice)
                }
            }
            else{
                if cameraType == .FrontCamera{
                    if (device as AnyObject).position == AVCaptureDevicePosition.front{
                        captureDevice = (device as! AVCaptureDevice)
                    }
                }
            }
        }
        
        return captureDevice
    }
    
    
    //MARK: Observer
    @objc func videoRecordingLength(){
        
//        if videoLength.value < videoLength.maximumValue{
//            videoLength.value += 1.0
//        }
//        else{
//            videoFileOutput?.stopRecording()
//        }
    }
    
    
    //MARK:- Buttons
    func CameraScreenButtons() -> Void {
        
        btnSelfiCap.frame = CGRect.init(x: kWidth-55, y: self.frame.height-60, width: 50, height: 40)
        btnSelfiCap.setImage(UIImage.init(named: "selfi"), for: .normal)
        self.addSubview(btnSelfiCap)
        btnSelfiCap.addTarget(self, action: #selector(SelfyCaptureClicked(sender:)), for: .touchUpInside)
        
        
        btnVideoCap.frame = CGRect.init(x: kCenterW-30, y: self.frame.height-70, width: 60, height: 60)
        btnVideoCap.setImage(#imageLiteral(resourceName: "video"), for: .normal)
        self.addSubview(btnVideoCap)
        btnVideoCap.addTarget(self, action: #selector(VideoCaptureClicked(sender:)), for: .touchUpInside)
        
    }
    
    func StopSession() -> Void {
        cameraSession?.stopRunning()
    }
    
    func StartSession() -> Void {
        cameraSession?.startRunning()
    }
    
    
    func VideoCaptureClicked(sender: UIButton) -> Void {
        
        var videoConnection: AVCaptureConnection?
        for connection in (videoFileOutput?.connections)! {
            let c = connection as! AVCaptureConnection
            
            for port in c.inputPorts {
                let p = port as! AVCaptureInputPort
                if p.mediaType == AVMediaTypeVideo {
                    videoConnection = c;
                    break
                }
            }
            
            if videoConnection != nil {
                break
            }
        }
        
        
        let recordingDelegate : AVCaptureFileOutputRecordingDelegate? = self
        let strPath = self.documentPath.appendingFormat("/output.mov") as String
        if FileManager.default.fileExists(atPath: strPath){
            do {
                try FileManager.default.removeItem(atPath: strPath)
            }
            catch let error as NSError{
                print("Ooops! Something went wrong: \(error)")
            }
        }
        let filePath = NSURL(fileURLWithPath:strPath)
        videoFileOutput!.startRecording(toOutputFileURL: filePath as URL!, recordingDelegate: recordingDelegate)
    }
    
    func btnReleased(btnCapture: UIButton){
        
        videoFileOutput!.stopRecording()
    }
    
    func SelfyCaptureClicked(sender: UIButton) -> Void {
        let animation = CATransition()
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = "oglFlip"
        let currentCameraInput = cameraPreviewlayer?.session.inputs[0] as! AVCaptureInput
        cameraPreviewlayer?.session.removeInput(currentCameraInput)
        if cameraDevice!.position == .back{
            animation.subtype = kCATransitionFromRight
            self.initSessionWithCamera(cameraType: .FrontCamera)
        }
        else{
            if cameraDevice!.position == .front{
                animation.subtype = kCATransitionFromLeft
                self.initSessionWithCamera(cameraType: .RearCamera)
            }
        }
        cameraPreviewlayer?.add(animation, forKey: nil)
    }
    
    //MARK: AVCaptureFileOutputRecordingDelegate Methods
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(videoRecordingLength), userInfo: nil, repeats: true)
        
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        
        print(outputFileURL)
        
        timer?.invalidate()
        
        self.exportVideo(outputUrl: outputFileURL as NSURL, ofDuration: captureOutput.recordedDuration)
    }
    
    
    func exportVideo(outputUrl: NSURL, ofDuration duration: CMTime){
        
        //load our movie Asset
        let asset = AVAsset(url: outputUrl as URL)
        
        if asset.tracks(withMediaType: AVMediaTypeVideo).isEmpty{
            Utility.sharedInstance.showToast(strMsg: "Please record again.")
            return
        }
        //create an avassetrack with our asset
        let clipVideoTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        let videoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTimeMake(1, 60)
        videoComposition.renderSize = CGSize.init(width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.height)
        
        let instruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        
        let transformer: AVMutableVideoCompositionLayerInstruction =
            AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        
        let t1: CGAffineTransform = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: 0)
        let t2: CGAffineTransform = t1.rotated(by: CGFloat(M_PI_2))
        
        let finalTransform: CGAffineTransform = t2
        
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        
        instruction.layerInstructions = NSArray(object: transformer) as! [AVVideoCompositionLayerInstruction]
        videoComposition.instructions = NSArray(object: instruction) as! [AVVideoCompositionInstructionProtocol]
        
        let documentsPath: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        
        let exportPath: NSString = documentsPath.appendingFormat("/%i-xvideo.mov", 1)
        let exportUrl: NSURL = NSURL.fileURL(withPath: exportPath as String) as NSURL
        
        
        //Remove any prevouis videos at that path
        self.deleteFileAtPath(strPath: exportPath as String)
        
        //Export
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exporter!.videoComposition = videoComposition;
        exporter!.outputURL = exportUrl as URL;
        exporter!.outputFileType = AVFileTypeQuickTimeMovie;
        
        exporter?.exportAsynchronously(completionHandler: {
            DispatchQueue.main.async {
                let expOutputURL:NSURL? = (exporter?.outputURL as NSURL?)
                if expOutputURL != nil{
                    /*let videoPlayer = VideoPlayerView(frame: self.view.bounds)
                    let duration = CGFloat(CMTimeGetSeconds(duration))
                    if duration < 1.0{
                        self.videoLength.value = 0.0
                        return;
                    }
                    videoPlayer.addControls(duration)
                    videoPlayer.initPlayer(expOutputURL)
                    videoPlayer.play()
                    videoPlayer.delegate = self
                    self.view.addSubview(videoPlayer)*/
                }
            }
        })
    }

    func deleteFileAtPath(strPath: String?){
        let fileManager = FileManager.default
        let filePath = self.documentPath.appendingFormat("/%@", strPath!)
        if fileManager.fileExists(atPath: filePath){
            do{
                try fileManager.removeItem(atPath: filePath)
            }
            catch{
                print("Unable to remove file")
            }
        }
    }
    
}
