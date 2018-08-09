//
//  VideoView.swift
//  Turnstr
//
//  Created by Mr X on 12/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoDelegate {
    func VideoPicked(url: URL)
    func CameraImageClicked(image: UIImage)
}

class VideoView: UIView, AVCaptureFileOutputRecordingDelegate, VideoPlayerDelegates {
    
    var videoPathNum: Int = 1
    
    var delegate: VideoDelegate?
    
    var btnVideoCap = UIButton()
    var btnSelfiCap = UIButton()
    var btnGallery = UIButton()
    var btnMyStoriesIcon = UIButton()
    
    var timer: Timer? = nil
    let lengthAccepted = 5.0 as Float
    let maximumLength = 15.0 as Float
    
    ///for video
    var cameraDevice : AVCaptureDevice?
    var captureAudio :AVCaptureDevice?
    var cameraPreviewlayer : AVCaptureVideoPreviewLayer?
    var cameraSession : AVCaptureSession?
    var videoFileOutput : AVCaptureMovieFileOutput?
    
    //For photo
    var stillImageOutput : AVCaptureStillImageOutput?
    
    
    
    var progressView = UISlider()
    
    
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
        cameraSession?.sessionPreset = AVCaptureSessionPresetHigh//AVCaptureSessionPresetMedium
        
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
        
        
        
        //for photo
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        cameraSession?.addOutput(stillImageOutput)
        
        //Start camera
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
        
        
        if progressView.value < maximumLength{
            progressView.value = progressView.value+1.0
        }
        else{
            videoFileOutput?.stopRecording()
            
        }
    }
    
    
    //MARK:- Buttons
    func CameraScreenButtons() -> Void {
        
        
        //btnSelfiCap.frame = CGRect.init(x: kWidth-55, y: self.frame.height-60, width: 50, height: 40)
        btnSelfiCap.frame = CGRect.init(x: kWidth-55, y: 10, width: 50, height: 40)
        btnSelfiCap.setImage(UIImage.init(named: "selfi"), for: .normal)
        self.addSubview(btnSelfiCap)
        btnSelfiCap.addTarget(self, action: #selector(SelfyCaptureClicked(sender:)), for: .touchUpInside)
        
        
        btnVideoCap.frame = CGRect.init(x: kCenterW-30, y: self.frame.height-70, width: 60, height: 60)
        btnVideoCap.setImage(#imageLiteral(resourceName: "nw_record"), for: .normal)
        self.addSubview(btnVideoCap)
        //btnVideoCap.addTarget(self, action: #selector(touchRelease(sender:)), for: .touchUpInside);
        //btnVideoCap.addTarget(self, action: #selector(touchStart(sender:)), for: .touchDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        btnVideoCap.addGestureRecognizer(tap)
        
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress))
        self.btnVideoCap.addGestureRecognizer(longPressGesture);
        
        
        
        progressView.frame = CGRect.init(x: 10, y: btnVideoCap.frame.minY-10, width: kWidth-20, height: 5)
        progressView.minimumValue = 0.0
        progressView.maximumValue = maximumLength
        progressView.isUserInteractionEnabled = false
        progressView.isHidden = true
        self.addSubview(progressView)
        
        //
        //Gallery
        //
        btnGallery.frame = CGRect.init(x: 10, y: self.frame.height-70, width: 60, height: 60)
        btnGallery.setImage(#imageLiteral(resourceName: "gallery"), for: .normal)
        self.addSubview(btnGallery)
        
        //
        //VideoIcon
        //
        
        btnMyStoriesIcon.frame = CGRect.init(x: kWidth-70, y: self.frame.height-70, width: 60, height: 60)
        btnMyStoriesIcon.setImage(#imageLiteral(resourceName: "nw_cube"), for: .normal)
        self.addSubview(btnMyStoriesIcon)
    }
    
    func StopSession() -> Void {
        cameraSession?.stopRunning()
    }
    
    func StartSession() -> Void {
        cameraSession?.startRunning()
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            debugPrint("long press started")
            touchStart(sender: btnVideoCap)
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.ended {
            debugPrint("longpress ended")
            touchRelease(sender: btnVideoCap)
        }
    }
    
    func touchRelease(sender: UIButton) -> Void {
        print("Touch released")
        progressView.isHidden = true
        let image = UIImage.init(named: "nw_record")?.setMode(MODE: .alwaysTemplate)
        btnVideoCap.setImage(image, for: .normal)
        btnVideoCap.tintColor = UIColor.white
        videoFileOutput!.stopRecording()
    }
    
    func touchStart(sender: UIButton) -> Void {
        print("Touch start")
        progressView.isHidden = false
        progressView.value = 0.0
        let image = UIImage.init(named: "nw_record")?.setMode(MODE: .alwaysTemplate)
        btnVideoCap.setImage(image, for: .normal)
        btnVideoCap.tintColor = UIColor.red
        
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
        let strPath = self.documentPath.appendingFormat("/output\(videoPathNum).mov") as String
        if FileManager.default.fileExists(atPath: strPath){
            do {
                try FileManager.default.removeItem(atPath: strPath)
            }
            catch let error as NSError{
                print("Ooops! Something went wrong: \(error)")
            }
        }
        let filePath = URL(fileURLWithPath:strPath)
        videoFileOutput!.startRecording(toOutputFileURL: filePath, recordingDelegate: recordingDelegate)
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        CameraCaptureClicked(sender: btnVideoCap)
    }
    
    func CameraCaptureClicked(sender: UIButton) -> Void {
        progressView.isHidden = true
        
        self.captureStillImage { (image) -> Void in
            if image != nil{
                self.delegate?.CameraImageClicked(image: image!)
            }
        }
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
    
    
    //MARK:- Video PLayer delegtes
    
    func resetRecording() {
        progressView.value  = 0
    }
    
    func VideoPlayerDone(videoUrl: URL) {
        
        delegate?.VideoPicked(url: videoUrl)
        resetRecording()
    }
    
    func VideoPlayerCancel() {
        resetRecording()
    }
    
    //MARK:- AVCaptureFileOutputRecordingDelegate Methods
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(videoRecordingLength), userInfo: nil, repeats: true)
        
    }
    
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        
        print("output URL")
        print(outputFileURL)
        
        timer?.invalidate()
        
        self.exportVideo(outputUrl: outputFileURL as NSURL, ofDuration: captureOutput.recordedDuration)
        
        videoPathNum = videoPathNum+1
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
        
        let exportPath: NSString = documentsPath.appendingFormat("/%i-xvideo.mov", videoPathNum)
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
                let expOutputURL: URL? = (exporter?.outputURL as URL?)
                if expOutputURL != nil{
                    
                    
                    let videoPlayer = VideoPlayer.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: self.frame.height+78))
                    videoPlayer.delegate = self
                    self.addSubview(videoPlayer)
                    videoPlayer.startPlayer(videoUrl: expOutputURL!)
                    
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
    
    
    //MARK:- Photo capturing
    
    func captureStillImage(completed: @escaping (_ image: UIImage?) -> Void){
        
        if let imageOutput = self.stillImageOutput {
            
            DispatchQueue.main.async {
                var videoConnection: AVCaptureConnection?
                for connection in imageOutput.connections {
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
                
                if videoConnection != nil {
                    imageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageSampleBuffer, error) in
                        if imageSampleBuffer != nil {
                            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
                            let image: UIImage? = UIImage(data: imageData!)!
                            
                            //let square = image!.size.width < image!.size.height ? CGSize(width: image!.size.width, height: image!.size.width) : CGSize(width: image!.size.height, height: image!.size.height)
                            let square = CGSize.init(width: kWidth*2, height: kHeight*2)
                            //let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: square.width/2, height: square.height/2))
                            let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: square.width, height: square.height))
                            imageView.contentMode = .scaleToFill
                            imageView.image = image
                            UIGraphicsBeginImageContext(imageView.bounds.size)
                            imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
                            let result = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
                            UIGraphicsEndImageContext();
                            
                            DispatchQueue.main.async {
                                completed(result)
                            }
                        }
                        else{
                            
                        }
                    })
                    
                } else {
                    DispatchQueue.main.async {
                        completed(nil)
                    }
                }
            }
        } else {
            completed(nil)
        }
    }
    
    
}
