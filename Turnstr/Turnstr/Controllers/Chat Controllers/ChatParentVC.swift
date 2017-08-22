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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        inputBar?.backgroundColor = UIColor.clear
        view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
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
        guard let data = UIImageJPEGRepresentation(image, 0.5) else { return }
        sendFiledata(data, fileName: "iOS\(Date().timeStamp())", fileType: "image", msg: nil)
    }
    
    //MARK: NotificationCenter handlers
    func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
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
        CameraImage.shared.captureImage(from: self, captureOptions: [.camera, .photoLibrary], allowEditting: true, fileTypes: [.image, .video]) {[weak self] (image, url) in
            
            if let image = image {
                self?.sendFile(image)
            }
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
