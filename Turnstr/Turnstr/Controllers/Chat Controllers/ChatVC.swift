//
//  ChatVC.swift
//  Turnstr
//
//  Created by Kamal on 03/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatVC: ChatParentVC  {
    
    var channel: SBDGroupChannel?
    var dataSource: ChatDataSource?
    
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var cubeView: UIView?
    @IBOutlet weak var VideoCallClick: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SBDMain.add(self, identifier: "channel")
        
        dataSource = ChatDataSource(with: tableView, items: [])
        dataSource?.channel = channel
        tableView?.delegate = dataSource
        tableView?.dataSource = dataSource
        loadChatHistory()
        
        initUserInfo()
    }
    
    //MARK: ------- Chat Messages
    override func sendTextMessage(_ message: String?) {
        
        channel?.sendUserMessage(message, completionHandler: {[weak self] (message, error) in
            if let msg = message {
                self?.dataSource?.add(msg)
                self?.txvInput?.text = ""
                self?.txvInput?.resignFirstResponder()
            }
            else {
                self?.dismissAlert(title: "Error", message: error?.localizedDescription)
            }
        })
    }
    
    override func sendFiledata(_ data: Data, fileName: String, fileType: String, msg: String?) {
        
        DispatchQueue.main.async {
            kAppDelegate.loadingIndicationCreation()
        }
        channel?.sendFileMessage(withBinaryData: data, filename: fileName, type: fileType, size: UInt(data.count), data: msg, completionHandler: {[weak self] (message, error) in
            kAppDelegate.hideLoadingIndicator()
            if let msg = message {
                self?.dataSource?.add(msg)
            }
            else {
                self?.dismissAlert(title: "Error", message: error?.localizedDescription)
            }
        })
    }
    
    //MARK:
    //MARK:- ActionMethods
    //MARK:
    
    @IBAction func VideoCallClick(_ sender: UIButton) {
        
        guard let members = channel?.members as? [SBDUser] else {
            return
        }
        for member in members {
            if member.userId != loginUser.id {
                let vc = OneOneCallVC()
                vc.userType = .caller
                vc.recieverId = member.userId
                self.navigationController?.pushViewController(vc, animated: true)
                break
            }
        }
    }
    
    //MARK: ------- Custom Message
    
    
    func loadChatHistory() {
        guard  let channel = channel else { return }
        let query = SBDPreviousMessageListQuery(channel: channel)
        query?.loadPreviousMessages(withLimit: 50, reverse: true, completionHandler: {[weak self] (messages, error) in
            if error == nil {
                self?.dataSource?.messages = messages as! [SBDUserMessage]
                self?.dataSource?.tableView?.reloadData()
            }
            else {
                self?.dismissAlert(title: "Error in loading history", message: error?.localizedDescription)
            }
        })
    }
}

extension ChatVC: SBDChannelDelegate {
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        dataSource?.add(message as! SBDUserMessage)
    }
}
