//
//  ChatParentVC.swift
//  Turnstr
//
//  Created by Kamal on 04/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import GrowingTextView
import SendBirdSDK
import MobileCoreServices

class ChatParentVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var inputBar: UIView?
    @IBOutlet weak var heightInputBarConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomConstraintTableView: NSLayoutConstraint?
    @IBOutlet weak var txvInput: GrowingTextView?
    @IBOutlet weak var btnSend: UIButton?
    @IBOutlet weak var widthConstraint: NSLayoutConstraint?
    
    var inputBarHeight: CGFloat = 60.0
    
    override var inputAccessoryView: UIView? {
        get {
            self.inputBar?.frame.size.height = inputBarHeight
            self.inputBar?.clipsToBounds = true
            return self.inputBar
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightInputBarConstraint?.constant = txvInput?.minHeight ?? 50
        automaticallyAdjustsScrollViewInsets = false
        txvInput?.borderDesign(cornerRadius: 8, borderWidth: 0.5, borderColor: .gray)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        inputBar?.backgroundColor = UIColor.clear
        view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        iqKeyboardManager(enable: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        iqKeyboardManager(enable: true)
    }
    
    //MARK: ------ Custom Methods
    func iqKeyboardManager(enable: Bool) {
        
        IQKeyboardManager.sharedManager().enable = enable
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = enable
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = enable
    }
    
    func sendTextMessage(_ message: String?) {}
    
    func sendFiledata(_ data: Data, fileName: String, fileType: String, msg: String?) {}
    
    func sendFile(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        sendFiledata(data, fileName: "iOS\(Date().timeStamp())", fileType: "image", msg: nil)
    }
    
    func sendVideo(_ url: URL) {
        var data: Data?
        do {
            data = try Data(contentsOf: url)
        }
        catch {
            KBLog.log(message: "video posting", object: error)
            dismissAlert(title: "Error", message: error.localizedDescription)
            return
        }
        guard let dataToPost = data else { return }
        sendFiledata(dataToPost, fileName: url.lastPathComponent, fileType: "video", msg: "video shared")
    }
    
    func openSource(_ option: UIImagePickerController.SourceType, type: String) {
        
        CameraImage.shared.openOptions(from: self, source: option, of: type) { (image, url) in
            if let image = image {
                self.sendFile(image)
            }
            else if let url = url {
                self.sendVideo(url)
            }
        }
    }
    func shareLocation() {
        
    }
    
    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            UIView.animate(withDuration: 0.35, animations: { [weak self] in
                self?.bottomConstraintTableView?.constant = height + (self?.inputBarHeight ?? 66)
            })
        }
    }
    
    //MARK: ------ Action Methods
    @IBAction func btnSendAction() {
        if txvInput?.text != "" {
            sendTextMessage(txvInput?.text)
        }
    }
    
    @IBAction func getFile() {
        
        let options = ["Capture Image", "Choose Image", "Record Video", "Choose Video"]
        
        let actionSheet = UIAlertController(title: L10n.selectSource.string, message: nil, preferredStyle: .actionSheet)
        for source in options {
            let action = UIAlertAction(title: source, style: .default, handler: { (action) in
                self.openCameraFor(index: options.firstIndex(of: source) ?? 10)
            })
            actionSheet.addAction(action)
        }
        let cancel = UIAlertAction(title: L10n.cancel.string, style: .cancel) { (action) in
        }
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCameraFor(index: Int) {
        switch index {
        case 0:
            self.openSource(.camera, type: kUTTypeImage as String)
        case 1:
            self.openSource(.photoLibrary, type:  kUTTypeImage as String)
        case 2:
            self.openSource(.camera, type: kUTTypeMovie as String)
        case 3:
            self.openSource(.photoLibrary, type: kUTTypeMovie as String)
            //        case 4:
        //            self.shareLocation()
        default: break
        }
    }
}

extension ChatParentVC: GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let expectedWidth = textView.text == "" ? 0 : 55
        UIView.animate(withDuration: 0.35) { [weak self] in
            self?.widthConstraint?.constant = CGFloat(expectedWidth)
        }
        
    }
}
