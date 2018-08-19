//
//  MyProfileReusableViewCollectionReusableView.swift
//  Turnstr
//
//  Created by Kamal on 09/08/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class MyProfileReusableViewCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var cubeProfileView: AITransformView?
    var current_user_story_count: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateStory() {
        let user = User.init()
        let urls = user.cubeUrls.map({ $0.absoluteString })
        cubeProfileView?.createCubewith(35)
        cubeProfileView?.setup(withUrls: urls)
        cubeProfileView?.backgroundColor = .white
        let edge = 35 - 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.cubeProfileView?.setScrollFromNil(CGPoint.init(x: 0, y: edge), end: CGPoint.init(x: 5, y: edge))
            self.cubeProfileView?.setScroll(CGPoint.init(x: edge, y: 0), end: CGPoint.init(x: edge, y: 5))
        }
        cubeProfileView?.isUserInteractionEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickOnStoryAction))
        cubeProfileView?.superview?.addGestureRecognizer(tapGesture)
    }
    
    func clickOnStoryAction() {
        
        if self.current_user_story_count > 0 {
            ///Open StoryPage
            
            let user = User()
            let storyboard = UIStoryboard.init(name: "LiveFeed", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "ShortStoryVC") as? ShortStoryVC else { return }
            vc.user = user
            topVC?.navigationController?.pushViewController(vc, animated: true)
            
        } else{
            ///Open Camera
            let camVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
            camVC.kScreenType = .newStory
            topVC?.navigationController?.pushViewController(camVC, animated: true)
        }
    }
    
    func createStory() {
        
    }
}

extension MyProfileReusableViewCollectionReusableView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openImagePicker(_ controller: UIImagePickerController) {
        controller.videoMaximumDuration = 20.0
        topVC?.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerMediaType] as? String == "public.image" {
            if let image = info[UIImagePickerControllerOriginalImage] {
                uploadStory(image)
            }
        }
        else {
            if let fileUrl = info[UIImagePickerControllerMediaURL] as? URL {
                getCompressedFile(fileUrl)
            }
        }
        topVC?.dismiss(animated: true, completion: nil)
    }
    
    func getCompressedFile(_ fileUrl: URL) {
        uploadStory(fileUrl)
    }
}

extension MyProfileReusableViewCollectionReusableView {
    
    func uploadStory(_ mediaFile: Any) {
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        guard let image = mediaFile as? UIImage else {
            dismissAlert(title: "Work in progress", message: "App do not support video file upload for now. Please try with image.")
            return
        }
        DispatchQueue.global().async {
            let strRequest = ["action":kAPIMyStoryUpload]
            let strPostUrl = kAPIMyStoryUpload
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.uploadMedia(PostURL: strPostUrl, strData: strRequest, parType: strParType, arrImages: [image])
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    Utility.sharedInstance.showToast(strMsg: "User story created successfully")
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    func validateResponseData(response: [String: AnyObject]) {
        if let dataVal = response["data"] {
            if Utility.sharedInstance.isStrEmpty(str: String.init(format: "%@", dataVal as! CVarArg)) == false {
                //
                // error message received in data
                //
                if dataVal.count > 0 {
                    if let descMsg = dataVal["error"] {
                        
                        DispatchQueue.main.async {
                            Utility.sharedInstance.showToast(strMsg: descMsg as! String)
                            kAppDelegate.hideLoadingIndicator()
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Utility.sharedInstance.showToast(strMsg: "Response Code: \(response["statusCode"] as! Int)")
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            else {
                //
                // No data received
                //
                DispatchQueue.main.async {
                    Utility.sharedInstance.showToast(strMsg: "Response Code: \(response["statusCode"] as! Int)")
                    kAppDelegate.hideLoadingIndicator()
                }
            }
        }
    }
}
