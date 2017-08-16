//
//  ParentChatCell.swift
//  Turnstr
//
//  Created by Kamal on 02/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import SendBirdSDK

class ParentChatCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    @IBOutlet weak var lblLastMessage: UILabel?
    @IBOutlet weak var lblUnreadCount: UILabel?
    @IBOutlet weak var lblMessage: UILabel?
    @IBOutlet weak var bubbleView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutIfNeeded()
        
        bubbleView?.borderDesign(cornerRadius: 8, borderWidth: nil, borderColor: nil)
        
        // Initialization code
    }

    func updateBudCell(_ channel: SBDGroupChannel) {
        
        if channel.memberCount > 2 {
            updateGroupChannel(channel)
        }
        else {
            updateOneToOneChannel(channel)
        }
    }
    
    func updateGroupChannel(_ channel: SBDGroupChannel) {
        KBLog.log(message: "channel ids", object: channel.members?.componentsJoined(by: "--"))
        lblName?.text = channel.name
        lblLastMessage?.text = channel.lastMessage?.channelUrl
        if channel.unreadMessageCount > 0 {
            lblUnreadCount?.text = "\(channel.unreadMessageCount)"
            lblUnreadCount?.isHidden = false
        }
        else {
            lblUnreadCount?.text = "0"
            lblUnreadCount?.isHidden = true
        }
    }
    
    func updateOneToOneChannel(_ channel: SBDGroupChannel) {
        guard let members = channel.members as? [SBDUser] else {
        
            lblName?.text = ""
            lblMessage?.text = ""
            return
        }
        var otherUser: SBDUser?
        for member in members {
            print(member.userId)
            print(loginUser.id ?? "No id")
            if member.userId != loginUser.id {
                lblName?.text = member.nickname
                otherUser = member
            }
        }
        let msg = channel.lastMessage as? SBDUserMessage
        var strMsg = msg?.message
        if otherUser == msg?.sender {
            strMsg = "You: " + (strMsg ?? "")
        }
        lblLastMessage?.text = strMsg
    }
    
    func updateChat(_ message: SBDUserMessage) {
        lblMessage?.text = message.message
        lblName?.text = message.sender?.nickname
        lblTime?.isHidden = true
    }
}
