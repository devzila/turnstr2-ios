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
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: ------- Custom Message
    override func sendTextMessage(_ message: String?) {
        
        channel?.sendUserMessage(message, completionHandler: { (message, error) in
            if error == nil {
                
            }
            else {
                
            }
        })
    }
    
    
}
