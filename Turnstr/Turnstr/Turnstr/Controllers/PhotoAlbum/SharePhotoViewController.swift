//
//  SharePhotoViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 31/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import FacebookShare
import FacebookCore
import FacebookLogin
import MessageUI
import TwitterKit
import Social

class SharePhotoViewController: ParentViewController, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnFlickr: UIButton!
    @IBOutlet weak var btnTumblr: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var sharePhoto: UIImageView!
    
    @IBOutlet weak var viewFbShare: UIView!
    
    @IBOutlet weak var uvTopCube: UIView!
    var topCube: AITransformView?
    
    var imageToShare: UIImage?
    
    var documentController : UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        btnFacebook.layer.borderColor = kShareFontColor.cgColor
//        btnTumblr.layer.borderColor = kShareFontColor.cgColor
//        btnTwitter.layer.borderColor = kShareFontColor.cgColor
//        btnFlickr.layer.borderColor = kShareFontColor.cgColor
//        btnFacebook.layer.borderColor = kShareFontColor.cgColor
        btnEmail.layer.borderColor = kShareFontColor.cgColor
        viewFbShare.layer.borderColor = kShareFontColor.cgColor
        
        
        if let img = imageToShare {
            sharePhoto.image = img
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
        
    @IBAction func btnShareTapped(_ sender: UIButton) {
    }
    
    @IBAction func btnTappedEmail(_ sender: UIButton) {
        if let img = imageToShare {
            if MFMailComposeViewController.canSendMail() {
                
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                
                //Set the subject and message of the email
                mailComposer.setSubject("")
                mailComposer.setMessageBody("", isHTML: false)
                
                if let fileData = img.pngData() {
                    mailComposer.addAttachmentData(fileData, mimeType: "image/png", fileName: "photo")
                }
                self.present(mailComposer, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func btnTappedFacebook(_ sender: UIButton) {
        if let img = imageToShare {
            
            if let accToken = AccessToken.current,
                accToken.hasGranted(permission: "publish_actions") {
                shareOnFB(img: img)
            }
            else {
                let loginManager = LoginManager()
                loginManager.logIn(permissions: ["publish_actions"], from: self) { [weak self] (loginResult, error) in
                    if let error = error {
                        debugPrint("Error in publish - \(error.localizedDescription)")
                        return
                    }
                    else {
                        self?.shareOnFB(img: img)
                    }
                }
                
            }
        }
        
    }
    
    
    func shareOnFB(img: UIImage) {
        let photo = SharePhoto(image: img, userGenerated: true)
        let content = SharePhotoContent()
        content.photos = [photo]
        let showDialog = ShareDialog(fromViewController: self, content: content, delegate: self)
        if (showDialog.canShow) {
            showDialog.show()
        } else {
            print("It looks like you don't have the Facebook mobile app on your phone.")
        }
    }
    
    @IBAction func btnTappedTwitter(_ sender: UIButton) {
        if let img = imageToShare {
            let composer = TWTRComposer()
            
//            composer.setText("")
            composer.setImage(img)
            
            
            composer.show(from: self) { (result) in
                if (result == .done) {
                    print("Successfully composed Tweet")
                } else {
                    print("Cancelled composing")
                }
            }
        }
        
    }
    @IBAction func btnTappedInstagram(_ sender: UIButton) {
        guard let img = imageToShare else { return }
        DispatchQueue.main.async {
            
            //Share To Instagrma:
            
            let instagramURL = URL(string: "instagram://app")
            
            if UIApplication.shared.canOpenURL(instagramURL!) {
                
                let imageData = img.jpegData(compressionQuality: 1)
                
                let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
                
                do {
                    try imageData?.write(to: URL(fileURLWithPath: writePath), options: .atomic)
                    
                } catch {
                    
                    print(error)
                }
                
                let fileURL = URL(fileURLWithPath: writePath)
                
                self.documentController = UIDocumentInteractionController(url: fileURL)
                
                self.documentController?.delegate = self
                
                self.documentController?.uti = "com.instagram.exlusivegram"
                
                self.documentController?.presentOpenInMenu(from: self.view.bounds, in: self.view, animated: true)
                
            } else {
                
                print(" Instagram is not installed ")
            }
        }

    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
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


extension SharePhotoViewController: SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print(results)
    }
    func sharerDidCancel(_ sharer: Sharing) {
        print("Cancelled")
    }
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Error in sharing image on facebook - \(error.localizedDescription)")
    }
}
