//
//  UserCell.swift
//  Turnstr
//
//  Created by Kamal on 02/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    let kCubeTag = 776
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
        
        createCube(user)
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
        }
        topCube?.backgroundColor = UIColor.white
        let urls = user.cubeUrls.map({ ($0.absoluteString) })
        
        topCube?.setup(withUrls: urls)

//        let objSing = Singleton.sharedInstance
//        topCube?.setup(withUrls: [objSing.strUserPic1.urlWithThumb, objSing.strUserPic2.urlWithThumb, objSing.strUserPic3.urlWithThumb, objSing.strUserPic4.urlWithThumb, objSing.strUserPic5.urlWithThumb, objSing.strUserPic6.urlWithThumb])
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 20, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
    }
    
}
