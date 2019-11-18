//
//  SenderCell.swift
//  Turnstr
//
//  Created by Kamal on 02/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class SenderCell: ParentChatCell {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: imgView) ?? .zero
        mediaTapped(point: point)
    }
}
