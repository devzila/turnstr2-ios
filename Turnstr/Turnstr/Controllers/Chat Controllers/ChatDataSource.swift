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

    var messages: [SBDUserMessage] = [SBDUserMessage]()
    var tableView: UITableView?
    
    init(with tableView: UITableView?, items: [SBDUserMessage]) {
        
        self.tableView = tableView
        for nibName in ["ReceiverCell", "SenderCell"] {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView?.register(nib, forCellReuseIdentifier: nibName)
        }
        tableView?.separatorStyle = .none
        tableView?.transform = CGAffineTransform(rotationAngle: .pi)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 44.0
    }
    
    func add(_ message: SBDUserMessage) {
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
        let message = messages[indexPath.row]
        if message.sender?.userId == loginUser.id {
            cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as? SenderCell
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as? ReceiverCell
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
        cell.updateChat(messages[indexPath.row])
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        return cell
    }
}

extension ChatDataSource:UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }
}
