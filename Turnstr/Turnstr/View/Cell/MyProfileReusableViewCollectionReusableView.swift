//
//  MyProfileReusableViewCollectionReusableView.swift
//  Turnstr
//
//  Created by Kamal on 09/08/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class MyProfileReusableViewCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var cubeProfileView: AITransformView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var story: ShortStory?
    
    func updateStory() {
        let user = User.init()
        let urls = user.cubeUrls.map({ $0.absoluteString })
        cubeProfileView?.createCubewith(35)
        cubeProfileView?.setup(withUrls: urls)
        cubeProfileView?.backgroundColor = .white
        cubeProfileView?.setScrollFromNil(CGPoint.init(x: 0, y: 30), end: CGPoint.init(x: 5, y: 30))
        cubeProfileView?.setScroll(CGPoint.init(x: 30, y: 0), end: CGPoint.init(x: 30, y: 2))
        cubeProfileView?.isUserInteractionEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickOnStoryAction))
        cubeProfileView?.superview?.addGestureRecognizer(tapGesture)
    }
    
    func clickOnStoryAction() {
        
    }
    
    func createStory() {
        
    }
}
