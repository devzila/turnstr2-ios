//
//  CameraView.swift
//  Turnstr
//
//  Created by Mr X on 12/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

enum Camera{
    case FrontCamera
    case RearCamera
}

protocol CameraViewDelegates {
    func CameraImageClicked(view: UIView, image: UIImage)
}
class CameraView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var delegate: CameraViewDelegates?
    
    //var captureDevice : AVCaptureDevice?
    //var stillImageOutput : AVCaptureStillImageOutput?
    
    var cameraDevice : AVCaptureDevice?
    var cameraPreviewlayer : AVCaptureVideoPreviewLayer?
    var cameraSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    
    
    
    var btnCameraCap = UIButton()
    var btnSelfiCap = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        
        cameraSetup()
        
        CameraScreenButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cameraSetup(){
        cameraSession = AVCaptureSession()
        cameraSession?.sessionPreset = AVCaptureSessionPresetPhoto
        
        cameraPreviewlayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        cameraPreviewlayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewlayer?.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.layer.addSublayer(cameraPreviewlayer!)
        
        self.initSessionWithCamera(cameraType: .RearCamera)
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        cameraSession?.addOutput(stillImageOutput)
        
        cameraSession?.startRunning()
    }
    
    func initSessionWithCamera(cameraType: Camera){
        
        let device = self.deviceWithMediaTypeWithPosition(mediaType: AVMediaTypeVideo as NSString, cameraType: cameraType)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if self.cameraSession!.canAddInput(input) {
                self.cameraSession!.addInput(input)
                self.cameraDevice = device
            }
        } catch {
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
                            
                            let square = image!.size.width < image!.size.height ? CGSize(width: image!.size.width, height: image!.size.width) : CGSize(width: image!.size.height, height: image!.size.height)
                            let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: square.width/2, height: square.height/2))
                            imageView.contentMode = .scaleAspectFill
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
    
    /*lazy var cameraSession: AVCaptureSession = {
     let s = AVCaptureSession()
     s.sessionPreset = AVCaptureSessionPresetMedium
     return s
     }()
     
     lazy var previewLayer: AVCaptureVideoPreviewLayer = {
     let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
     preview?.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
     preview?.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
     preview?.videoGravity = AVLayerVideoGravityResize
     return preview!
     }()
     
     func setupCameraSession() {
     captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
     
     do {
     let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
     
     cameraSession.beginConfiguration()
     
     if (cameraSession.canAddInput(deviceInput) == true) {
     cameraSession.addInput(deviceInput)
     }
     
     let dataOutput = AVCaptureVideoDataOutput()
     dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
     dataOutput.alwaysDiscardsLateVideoFrames = true
     
     if (cameraSession.canAddOutput(dataOutput) == true) {
     cameraSession.addOutput(dataOutput)
     }
     
     cameraSession.commitConfiguration()
     
     let queue = DispatchQueue(label: "com.invasivecode.videoQueue")
     dataOutput.setSampleBufferDelegate(self, queue: queue)
     
     }
     catch let error as NSError {
     NSLog("\(error), \(error.localizedDescription)")
     }
     }
     
     func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
     // Here you collect each frame and process it
     }
     
     func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
     // Here you can count how many frames are dopped
     }*/
    
    //MARK:- Buttons
    func CameraScreenButtons() -> Void {
        btnCameraCap.frame = CGRect.init(x: kCenterW-30, y: self.frame.height-70, width: 60, height: 60)
        btnCameraCap.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        self.addSubview(btnCameraCap)
        btnCameraCap.addTarget(self, action: #selector(CameraCaptureClicked(sender:)), for: .touchUpInside)
        
        
        btnSelfiCap.frame = CGRect.init(x: kWidth-55, y: self.frame.height-60, width: 50, height: 40)
        btnSelfiCap.setImage(UIImage.init(named: "selfi"), for: .normal)
        self.addSubview(btnSelfiCap)
        btnSelfiCap.addTarget(self, action: #selector(SelfyCaptureClicked(sender:)), for: .touchUpInside)
        
        
    }
    
    func StopSession() -> Void {
        cameraSession?.stopRunning()
    }
    
    func StartSession() -> Void {
        cameraSession?.startRunning()
    }
    
    func CameraCaptureClicked(sender: UIButton) -> Void {
        
        self.captureStillImage { (image) -> Void in
            if image != nil{
                self.delegate?.CameraImageClicked(view: self, image: image!)
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
    
}
