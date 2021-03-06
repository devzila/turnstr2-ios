//
//  CaptureImage.swift
//  HungryForJobs
//
//  Created by Sierra 3 on 19/04/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import MobileCoreServices


enum MediaType {
    case image
    case video
    
    var string: String {
        switch self {
        case .image:
            return kUTTypeImage as String
            
        case .video:
            return kUTTypeMovie as String
        }
    }
}



class CameraImage: NSObject {
    
    static var shared = CameraImage()
    var fromVC: UIViewController?
    var complete:((_ image: UIImage?, _ url: URL?) -> Void)?
    
    var dictionaryPath: String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        return documentsDirectory
    }
    
    func cameraNotPermitted() -> Bool{
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
        case .authorized:
            return false
        case .denied, .restricted:
            openSettings()
        case .notDetermined:
            return false
        }
        return true
    }
    
    fileprivate func openSettings() {
        
        openAlert(title: L10n.workCocoon.string, message: L10n.youHaveDeniedThePermissionToAccessCameraAndGallery.string, with: L10n.settings.string) { (index) in
            
            if index == 0 {//Press setting option.
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    //TODO: -- Add open Settings for lower versions
                }
            }
        }
    }
    
    func captureImage(from vc: UIViewController, captureOptions sources: [UIImagePickerController.SourceType], allowEditting crop: Bool, fileTypes: [MediaType], callBack: ((_ image: UIImage?, _ url: URL?) -> Void)?) {
        
        if cameraNotPermitted() {
            return
        }
        
        self.fromVC = vc
        self.complete = callBack
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let mediaTypes = fileTypes.map({ ($0.string) })
        imagePicker.mediaTypes = mediaTypes
        imagePicker.allowsEditing = crop
        
        if sources.count > 1 {
            openActionSheet(with: imagePicker, sources: sources)
        }
        else {
            let source = sources[0]
            if source == .camera && cameraExists {
                imagePicker.sourceType = source
            }
            vc.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openActionSheet(with imagePicker: UIImagePickerController, sources: [UIImagePickerController.SourceType]) {
        
        let actionSheet = UIAlertController(title: L10n.selectSource.string, message: nil, preferredStyle: .actionSheet)
        for source in sources {
            let action = UIAlertAction(title: source.name, style: .default, handler: { (action) in
                imagePicker.sourceType = source
                self.fromVC?.present(imagePicker, animated: true, completion: nil)
            })
            if source == .camera {
                if cameraExists { actionSheet.addAction(action) }
            }
            else {
                actionSheet.addAction(action)
            }
        }
        let cancel = UIAlertAction(title: L10n.cancel.string, style: .cancel) { (action) in
        }
        actionSheet.addAction(cancel)
        fromVC?.present(actionSheet, animated: true, completion: nil)
    }
}




extension CameraImage {
    
    func openOptions(from: UIViewController, source: UIImagePickerController.SourceType, of mediaType: String, callBack: ((_ image: UIImage?, _ url: URL?) -> Void)?) {
        
        let imagePicker = UIImagePickerController()
        if source == .camera {
            if cameraExists { imagePicker.sourceType = source }
        }
        else {
            imagePicker.sourceType = source
        }
        imagePicker.delegate = self
        imagePicker.mediaTypes = [mediaType]
        self.complete = callBack
        self.fromVC = from
        fromVC?.present(imagePicker, animated: true, completion: nil)
    }
}


extension CameraImage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var cameraExists: Bool {
        let front = UIImagePickerController.isCameraDeviceAvailable(.front)
        let rear = UIImagePickerController.isCameraDeviceAvailable(.rear)
        return front || rear
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard let callBack = complete else {
            fromVC?.dismiss(animated: true, completion: nil)
            return
        }
        callBack(nil, nil)
        fromVC?.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage? = nil
        let url: URL? = nil
        
        //Get file by checking its file type
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }
        if mediaType == MediaType.image.string {
            if let edittedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                image = edittedImage
            }
            else if let fullImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                image = fullImage
            }
            
            if let complete = complete {
                complete(image, url)
            }
        }
        else if mediaType == MediaType.video.string {
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                getUrlFromVideoFile(url: videoURL)
            }
        }
        fromVC?.dismiss(animated: true, completion: nil)
    }
}

extension UIImagePickerController.SourceType {
    
    var name: String {
        
        switch self {
        case .camera:
            return L10n.camera.string
            
        case .photoLibrary:
            return L10n.photoLibrary.string
            
        case .savedPhotosAlbum:
            return L10n.savedPhotoAlbum.string
            
        }
    }
}

extension CameraImage {
    
    func compressVideoFromInputUrl(_ fromUrl: URL, toUrl url: URL, completionHandler:@escaping ((_ exportSession: AVAssetExportSession) -> Void)){
        
        do {
            try FileManager.default.removeItem(at: url)
        }
        catch{
            print("error in removing file at path \(url)")
        }
        let asset: AVURLAsset = AVURLAsset(url: fromUrl)
        let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exportSession?.outputURL = url
        exportSession?.outputFileType = AVFileType.mov
        exportSession?.exportAsynchronously(completionHandler: {
            completionHandler(exportSession!)
        })
    }
    
    
    func getUrlFromVideoFile(url: URL) {
        
        let documentPath = self.dictionaryPath.appendingFormat("/%@", "video.mp4")
        let toUrl = URL(fileURLWithPath: documentPath)
        
        compressVideoFromInputUrl(url, toUrl: toUrl) { (session) in
            if let complete = self.complete {
                KBLog.log(message: "data", object: toUrl)
                complete(nil, toUrl)
            }
        }
    }
    
}
