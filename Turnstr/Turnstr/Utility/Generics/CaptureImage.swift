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

class CameraImage: NSObject {
    
    static var shared = CameraImage()
    var fromVC: UIViewController?
    var complete:((_ image: UIImage?) -> Void)?
    
    
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
    
    func captureImage(from vc: UIViewController, captureOptions sources: [UIImagePickerControllerSourceType], allowEditting crop: Bool, fromView sender: UIButton?, callBack: ((_ image: UIImage?) -> Void)?) {
        
        if cameraNotPermitted() {
            return
        }
        
        self.fromVC = vc
        self.complete = callBack
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = crop
        
        if sources.count > 1 {
            openActionSheet(with: imagePicker, sources: sources, sender: sender)
        }
        else {
            let source = sources[0]
            if source == .camera && cameraExists {
                imagePicker.sourceType = source
            }
            vc.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openActionSheet(with imagePicker: UIImagePickerController, sources: [UIImagePickerControllerSourceType], sender: UIButton?) {
        
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
        if let btn = sender {
            actionSheet.popoverPresentationController?.barButtonItem = UIBarButtonItem(customView: btn)
            fromVC?.present(actionSheet, animated: true, completion: nil)
        }
        
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
        callBack(nil)
        fromVC?.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image: UIImage? = nil
        if let edittedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = edittedImage
        }
        else if let fullImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            image = fullImage
        }
        
        guard let callBack = complete else {
            fromVC?.dismiss(animated: true, completion: nil)
            return
        }
        callBack(image)
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
