
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
        let message = "\(loginUser.name ?? ""):  \(txtCommentView?.text ?? "")"
        var err: OTError?
        session.signal(withType: "Chat", string: message, connection: nil, error: &err)
        if let err = err {
            KBLog.log(err.debugDescription)
        }
        txtCommentView?.text = ""
    }
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        print("Signal received. \(type ?? "")")
        if type == "Chat" {
            if let comment = string, let tbl = tblView {
                comments.insert(comment, at: 0)
                view.bringSubview(toFront: tbl)
            }
            tblView?.reloadData()
            tblView?.scrollToBottom()
        }
        else {
            if let manager = AppDelegate.shared?.callManager, let call = AppDelegate.shared?.onGoingCall {
                manager.end(call: call)
            }
            if type == kDisconnectGoLive {
                if string != objSing.strUserID {
                    self.endCallAction(endCallButton)
                }
            }
            else if type == kDisconnectVideoCall {
                if subscribers.count <= 1 {
                    if string != objSing.strUserID {
                        self.endCallAction(endCallButton)
                    }
                }
            }
        }
    }
}

extension MultiCallViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "comment") else { return UITableViewCell() }
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.text = comments[indexPath.row]
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        return cell
    }
}

extension MultiCallViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


extension MultiCallViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Write here" {
            textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            textView.text = "Write here"
        }
        return true
    }
}

//MARK: --- Keyboard notifications
extension MultiCallViewController {
    func keyboardWillShow(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            if let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                UIView.animate(withDuration: 0.1, animations: { [weak self] in
                    self?.bottomConstraintCommentView?.constant = -keyboardSize.height
                    self?.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        
        UIView.animate(withDuration: 0.20) { [weak self] in
            self?.bottomConstraintCommentView?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
}
