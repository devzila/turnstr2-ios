//
//  PublicProfileViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 02/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class PublicProfileViewController: ParentViewController, ServiceUtility {

    var transformView: AITransformView?
    var topCube: AITransformView?
    var profileId: Int?
    var profileDetail: UserModel?
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPostLeft: UILabel!
    @IBOutlet weak var lblPostRight: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var uvCenterCube: UIView!
    @IBOutlet weak var uvTopCube: UIView!
    @IBOutlet weak var btnFollow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let userID = profileId else { return }
        
        
        getMemberDetails(id: userID) { (response) in
            if let objModel = response?.response {
                self.profileDetail = objModel
                let postTitle: NSMutableAttributedString = NSMutableAttributedString.init(string: "posts\nfollowers\nfamily")
                postTitle.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle.length))
                postTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postTitle.length))
                
                let style = NSMutableParagraphStyle()
                style.alignment = .right
                postTitle.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postTitle.length))
                
                self.lblPostLeft.attributedText = postTitle
                
                
                let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(self.profileDetail!.post_count ?? 0)\n\(self.profileDetail!.follower_count ?? 0)\n\(self.profileDetail!.family_count ?? 0)")
                postDetail.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
                postDetail.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
                style.alignment = .left
                
                postDetail.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postDetail.length))
                
                self.lblPostRight.attributedText = postDetail
                
                if objModel.following! {
                    self.btnFollow.isSelected = false
                    self.btnFollow.setTitle("Unfollow", for: .normal)
                } else {
                    self.btnFollow.isSelected = true
                    self.btnFollow.setTitle("Follow", for: .normal)
                }
                
                self.setUserCube(objModel: objModel)
            }
        }
        
        
    }
    
    func setUserCube(objModel: UserModel) {
        lblUserName.text = objModel.username == nil ? "@" + (objModel.first_name?.lowercased())! : "@" + (objModel.username?.lowercased())! //"@"+objModel.user?.username.lowercased()
        lblBio.text = objModel.bio
        lblWebsite.text = objModel.website
        lblAddress.text = objModel.city
        
        //
        //Top Cube View
        //
        
        topCube?.removeFromSuperview()
        topCube = nil
        
        var w: CGFloat = 95
        var h: CGFloat = 80
        
        if topCube == nil {
            
            topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 65)
        }
        topCube?.backgroundColor = UIColor.clear
        let arrFaces = [objModel.avatar_face1 ?? "thumb", objModel.avatar_face2 ?? "thumb", objModel.avatar_face3 ?? "thumb", objModel.avatar_face4 ?? "thumb", objModel.avatar_face5 ?? "thumb", objModel.avatar_face6 ?? "thumb"]
        topCube?.setup(withUrls: arrFaces)
        
        uvTopCube.addSubview(topCube!)
        uvTopCube.isUserInteractionEnabled = false
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 20, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))

        
        //
        //Center cube view
        //
        transformView?.removeFromSuperview()
        transformView = nil
        
        w = kWidth
        h = 220 // uvCenterCube.frame.size.height-10
        
        if transformView == nil {
            
            transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 20, width: w, height: h), cube_size: 180)//w > h ?h-100:w-100
        }
        transformView?.backgroundColor = UIColor.clear
        transformView?.setup(withUrls: arrFaces)
        uvCenterCube.addSubview(transformView!)
        transformView?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 85, y: h/2))
        transformView?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func btnTappedFollowUnfollow(_ sender: UIButton) {
        guard let objModel = profileDetail else { return }
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        var strType = "follow"
        if sender.isSelected {
            strType = "follow"
            self.followUnFollowUser(id: objModel.id!, type: strType) { (response) in
                sender.isSelected = false
                 sender.setTitle("Unfollow", for: .normal)
            }
        } else {
            strType = "unfollow"
            self.followUnFollowUser(id: objModel.id!, type: strType) { (response) in
                sender.isSelected = true
                sender.setTitle("Follow", for: .normal)
            }
        }
    }
    
    @IBAction func btnTappedBack(_ sender: button) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTappedMyStory(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
