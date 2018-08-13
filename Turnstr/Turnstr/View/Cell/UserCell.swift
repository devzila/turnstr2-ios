//
//  UserCell.swift
//  Turnstr
//
//  Created by Kamal on 02/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

let kCubeTag = 776

class UserCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblSubTitle: UILabel?
    @IBOutlet weak var cubeView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUserInfo(_ user: User) {
        lblName?.text = user.name
        lblSubTitle?.text = user.email
        
        cubeView?.backgroundColor = .clear
        lblName?.textColor = .white
        lblName?.font = UIFont.boldSystemFont(ofSize: 14.0)
        lblSubTitle?.textColor = .white
        lblSubTitle?.font = UIFont.systemFont(ofSize: 14.0)
        backgroundColor = .clear
    }
    
    
    func createCube(_ user: User) {
        let w: CGFloat = cubeView?.frame.size.width ?? 48.0
        let h: CGFloat = cubeView?.frame.size.height ?? 48.0
        
        
        var topCube = cubeView?.viewWithTag(kCubeTag) as? AITransformView
        topCube?.removeFromSuperview()
        if topCube == nil {
            topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 30)
            topCube?.tag = kCubeTag
            cubeView?.addSubview(topCube!)
            cubeView?.backgroundColor = .clear
        }
        let urls = user.cubeUrls.map({ ($0.absoluteString) })
        
        topCube?.setup(withUrls: urls)
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 5, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
    }
    
}
