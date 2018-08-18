//
//  UserStoryCell.swift
//  Turnstr
//
//  Created by Kamal on 09/08/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class UserStoryCell: UICollectionViewCell {
    
    @IBOutlet weak var cubeProfileView: AITransformView?
    @IBOutlet weak var lblUserName: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        // Initialization code
    }
    
    var size: CGFloat = 35
    var user: User? {
        didSet {
            lblUserName?.text = user?.username
            let userUrls = user?.cubeUrls.map({$0.absoluteString})
            cubeProfileView?.createCubewith(size)
            cubeProfileView?.setup(withUrls: userUrls)
            cubeProfileView?.backgroundColor = .white
            let edge = size - 5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if IS_IPHONE_6 {
                    self.cubeProfileView?.setScroll(CGPoint.init(x: 0, y: edge/2), end: CGPoint.init(x: 10, y: edge/2))
                    self.cubeProfileView?.setScroll(CGPoint.init(x: edge/2, y: 0), end: CGPoint.init(x: edge/2, y: 5))
                } else{
                    self.cubeProfileView?.setScrollFromNil(CGPoint.init(x: 0, y: edge), end: CGPoint.init(x: 5, y: edge))
                    self.cubeProfileView?.setScroll(CGPoint.init(x: edge, y: 0), end: CGPoint.init(x: edge, y: 5))
                }
                
            }
            
            cubeProfileView?.isUserInteractionEnabled = false
            
        }
    }
    
}
