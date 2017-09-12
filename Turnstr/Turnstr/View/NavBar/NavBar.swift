//
//  NavBar.swift
//  Turnstr
//
//  Created by Mr. X on 12/09/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class NavBar: UIView {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLogo: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let uvNub: UIView = (Bundle.main.loadNibNamed("NavBar", owner: self, options: nil)![0] as? UIView)!
        uvNub.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(uvNub)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
