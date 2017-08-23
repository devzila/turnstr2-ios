//
//  ParentChatCell.swift
//  Turnstr
//
//  Created by Kamal on 02/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import SendBirdSDK
import KSPhotoBrowser

class ParentChatCell: UITableViewCell {

    @IBOutlet weak var cubeView: UIView?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    @IBOutlet weak var lblLastMessage: UILabel?
    @IBOutlet weak var lblUnreadCount: UILabel?
    @IBOutlet weak var lblMessage: UILabel?
    @IBOutlet weak var bubbleView: UIView?
    @IBOutlet weak var imgView: UIImageView?
    
    var currentMessage: SBDBaseMessage?
    
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
        for member in members {
            if member.userId != loginUser.id {
                lblName?.text = member.nickname
                createCube(member)
            }
        }
        
        let msg = channel.lastMessage as? SBDUserMessage
        var strMsg = msg?.message
        if let fileMsg = channel.lastMessage as? SBDFileMessage {
            strMsg = fileMsg.type
        }
        lblLastMessage?.text = strMsg
    }
    
    func updateChat(_ message: SBDBaseMessage, _ channel: SBDGroupChannel?) {
        currentMessage = message
        if let message = message as? SBDUserMessage {
            imgView?.isHidden = true
            lblMessage?.isHidden = false
            lblMessage?.text = message.message
            lblName?.text = message.sender?.nickname
            lblTime?.isHidden = true
            createCube(message.sender)
        }
        else if let message = message as? SBDFileMessage {
            imgView?.isHidden = false
            lblMessage?.isHidden = true
            if let url = URL(string: message.url) {
                imgView?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            }
            lblName?.text = message.sender?.nickname
            lblTime?.isHidden = true
            createCube(message.sender)
        }
    }
    
    
    func createCube(_ user: SBDUser?) {
        
        guard let urls = user?.profileUrl?.components(separatedBy: ",") else {
            return
        }
        let w: CGFloat = cubeView?.frame.size.width ?? 48.0
        let h: CGFloat = cubeView?.frame.size.height ?? 48.0
        
        cubeView?.backgroundColor = .clear
        var topCube = cubeView?.viewWithTag(kCubeTag) as? AITransformView
        if topCube != nil {
            topCube = nil
        }
        topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 30)
        topCube?.tag = kCubeTag
        cubeView?.addSubview(topCube!)
        cubeView?.backgroundColor = .clear
        
        topCube?.setup(withUrls: urls)
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 20, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
    }
    
    
    func mediaTapped(point: CGPoint) {
        if imgView?.frame.contains(point) ?? false {
            
            guard let msg = currentMessage as? SBDFileMessage,
                let imageView = imgView,
                let vc = topVC,
                let url = URL(string: msg.url)
                else { return }
            
            let item = KSPhotoItem(sourceView: imageView, imageUrl: url)
            let browser = KSPhotoBrowser(photoItems: [item], selectedIndex: 0)
            browser.show(from: vc)
        }
    }
}
