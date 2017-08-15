//
//  LikeCommetFooter.swift
//  Turnstr
//
//  Created by Mr X on 27/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class LikeCommetFooter: UIView {

    @IBOutlet weak var btnTotalLike: UIButton!
    @IBOutlet weak var btnTotalComment: UIButton!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblCaption: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let uvNub: UIView = (Bundle.main.loadNibNamed("LikeCommetFooter", owner: self, options: nil)![0] as? UIView)!
        uvNub.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(uvNub)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
