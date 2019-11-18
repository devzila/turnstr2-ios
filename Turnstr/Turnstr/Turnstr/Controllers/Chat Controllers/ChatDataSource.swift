//
//  ChatDataSource.swift
//  Turnstr
//
//  Created by Kamal on 10/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatDataSource: NSObject {

    var messages: [SBDBaseMessage] = [SBDBaseMessage]()
    var tableView: UITableView?
    var channel: SBDGroupChannel?
    
    init(with tableView: UITableView?, items: [SBDUserMessage]) {
        
        self.tableView = tableView
        for nibName in ["ReceiverCell", "SenderCell"] {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView?.register(nib, forCellReuseIdentifier: nibName)
        }
        tableView?.separatorStyle = .none
        tableView?.transform = CGAffineTransform(rotationAngle: .pi)
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 44.0
    }
    
    func add(_ message: SBDBaseMessage) {
        messages.insert(message, at: 0)
        tableView?.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView?.insertRows(at: [indexPath], with: .right)
        tableView?.endUpdates()
    }

    func insert(_ items: [SBDUserMessage]) {
        for item in items {
            add(item)
        }
    }
    
    func configureCell(tableView: UITableView, indexPath: IndexPath) -> ParentChatCell{
        
        var cell: ParentChatCell?
        KBLog.log(message: "message", object: messages[indexPath.row])
        let message = messages[indexPath.row]
        
        if let msg = message as? SBDUserMessage {
            if msg.sender?.userId == loginUser.id {
                cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as? SenderCell
            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as? ReceiverCell
            }
        }
        else if let msg = message as? SBDFileMessage {
            if msg.sender?.userId == loginUser.id {
                cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as? SenderCell
            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as? ReceiverCell
            }
        }
        return cell ?? ParentChatCell()
    }
}

extension ChatDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView: tableView, indexPath: indexPath)
        cell.updateChat(messages[indexPath.row], channel)
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        return cell
    }
}

extension ChatDataSource:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if messages[indexPath.row] is SBDUserMessage {
            return UITableView.automaticDimension
        }
        else if messages[indexPath.row] is SBDFileMessage {
            return screenWidth * 0.5
        }
        return 0.0
    }
}
