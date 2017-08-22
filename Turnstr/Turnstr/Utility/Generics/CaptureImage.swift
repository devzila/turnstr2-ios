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
            return kUTTypeVideo as String
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
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
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
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                } else {
                    //TODO: -- Add open Settings for lower versions
                }
            }
        }
    }
    
    func captureImage(from vc: UIViewController, captureOptions sources: [UIImagePickerControllerSourceType], allowEditting crop: Bool, fileTypes: [MediaType], callBack: ((_ image: UIImage?, _ url: URL?) -> Void)?) {
        
        if cameraNotPermitted() {
            return
        }
        
        self.fromVC = vc
        self.complete = callBack
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = fileTypes.map( { ($0.string) } )
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
    
    func openActionSheet(with imagePicker: UIImagePickerController, sources: [UIImagePickerControllerSourceType]) {
        
        let actionSheet = UIAlertController(title: L10n.selectSource.string, message: nil, preferredStyle: .actionSheet)
        for source in sources {
            let action = UIAlertAction(title: source.name, style: .default, handler: { (action) in
                imagePicker.sourceType = source
                self.fromVC?.present(imagePicker, animated: true, completion: nil)
            })
            if source == .camera {
                if cameraExists{  actionSheet.addAction(action) }
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image: UIImage? = nil
        var url: URL? = nil
        
        defer {
            if let complete = complete {
                complete(image, url)
            }
        }
        
        //Get file by checking its file type
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else { return }
        if mediaType == MediaType.image.string {
            if let edittedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                image = edittedImage
            }
            else if let fullImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
                image = fullImage
            }
        }
        else if mediaType == MediaType.video.string {
            if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
                getUrlFromVideoFile(url: videoURL)
            }
        }
        
        guard let callBack = complete else {
            return
        }
        callBack(image, nil)
        fromVC?.dismiss(animated: true, completion: nil)
    }
}

extension UIImagePickerControllerSourceType {
    
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
        exportSession?.outputFileType = AVFileTypeQuickTimeMovie
        exportSession?.exportAsynchronously(completionHandler: {
            completionHandler(exportSession!)
        })
    }
    
    
    func getUrlFromVideoFile(url: URL) {
        
        let documentPath = self.dictionaryPath.appendingFormat("/%@", "video.mp4")
        let url = URL(fileURLWithPath: documentPath)
        
        compressVideoFromInputUrl(url, toUrl: url) { (session) in
            
        }
    }
    
}
