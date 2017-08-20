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
    
    @IBOutlet weak var cubeView: UIView?
    
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
    
    //MARK: ------- Custom Message
    
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
