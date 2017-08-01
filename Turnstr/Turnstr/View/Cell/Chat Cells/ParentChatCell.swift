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
    @IBOutlet weak var txtMessage: UITextView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateBudCell(_ channel: SBDGroupChannel) {
        
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
    
    func updateChat(_ message: SBDBaseMessage) {
        
    }
}
