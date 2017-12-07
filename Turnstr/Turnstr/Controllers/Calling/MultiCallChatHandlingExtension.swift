
//
//  MultiCallChatHandlingExtension.swift
//  Turnstr
//
//  Created by Kamal on 07/12/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit
import OpenTok

extension MultiCallViewController {
    
    @IBAction func btnSendCommentAction() {
        if txtCommentView?.text == "" {
            dismissAlert(title: "Alert!", message: "Enter comment to post")
            return
        }
        
        var err: OTError?
        session.signal(withType: "Chat", string: "hi", connection: session.connection, error: &err)
        if let err = err {
            KBLog.log(err.debugDescription)
        }
    }
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        if type == "Chat" {
            KBLog.log(message: "chat message", object: string)
            KBLog.log(message: "chat message", object: session.connection?.connectionId)
        }
    }
}

extension MultiCallViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "comment") else { return UITableViewCell() }
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.text = comments[indexPath.row]
        return cell
    }
}

extension MultiCallViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


extension MultiCallViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Write here" {
            textView.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            textView.text = "Write here"
        }
    }
}
