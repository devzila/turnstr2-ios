//
//  HomeViewController.swift
//  Turnstr
//
//  Created by Mr X on 09/05/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class HomeViewController: ParentViewController {
    
    var transformView: AITransformView?
    var topCube: AITransformView?
    
    var btnMyStory = UIButton()
    
    @IBOutlet weak var centerCubeTop: NSLayoutConstraint!
    @IBOutlet weak var uvCenterCubeUpper: view!
    @IBOutlet weak var btnDesc: UIButton!
    @IBOutlet weak var txtDescr: UITextView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPostLeft: UILabel!
    @IBOutlet weak var lblPostRight: UILabel!
    
    @IBOutlet weak var uvCenterCube: UIView!
    @IBOutlet weak var uvTopCube: UIView!
    @IBOutlet weak var imgVerified: UIImageView!
    
    
    override func viewDidLayoutSubviews() {
        MyStoryBUtton()
        if IS_IPHONEX {
            objUtil.setFrames(xCo: 0, yCo: 85, width: 0, height: 0, view: uvCenterCube)
        }
        uvCenterCube.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IS_IPHONEX {
            centerCubeTop.constant = 85
            uvCenterCube.layoutIfNeeded()
        } else if IS_IPHONE_6 {
            centerCubeTop.constant = 35
            uvCenterCube.layoutIfNeeded()
        } else if IS_IPHONE_6P {
            centerCubeTop.constant = 48
            uvCenterCube.layoutIfNeeded()
        }
        
        btnDesc.addTarget(self, action: #selector(DescriptionClicked(sender:)), for: .touchUpInside)
        btnMyStory.addTarget(self, action: #selector(MyStoryClicked(sender:)), for: .touchUpInside)
        
        
        lblPostLeft.numberOfLines = 0
        lblPostRight.numberOfLines = 0
        
        
        
        //transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 5, width: kWidth, height: uvCenterCube.frame.size.height-10))
        //uvCenterCube.addSubview(transformView!)
        //self.view = transformView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        objDataS.getUserProfileData { (received) in
            if received == true {
                self.FollowerCounts()
            }
        }
        //kAppDelegate.isTabChanges = true
        
        imgVerified.isHidden = !objSing.isVerified
        
        lblUserName.text = "@"+objSing.strUserName.lowercased()
        
        
        FollowerCounts()
        
        //
        // Bio INformation
        //
        
        let bio = objSing.strUserBio+"\n"+objSing.address+"\n"+objSing.strUserWebsite
        
        let postTitle: NSMutableAttributedString = NSMutableAttributedString.init(string: bio)
        postTitle.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, postTitle.length))
        postTitle.addAttribute(NSForegroundColorAttributeName, value: kBlueColor, range: NSMakeRange(postTitle.length-objSing.strUserWebsite.length, objSing.strUserWebsite.length))
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        postTitle.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postTitle.length))
        
        txtDescr.attributedText = postTitle
        
        //btnDesc.setTitle(objSing.strUserBio, for: .normal)
        //btnDesc.titleLabel?.textAlignment = .center
        
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
        topCube?.setup(withUrls: [objSing.strUserPic1.urlWithThumb, objSing.strUserPic2.urlWithThumb, objSing.strUserPic3.urlWithThumb, objSing.strUserPic4.urlWithThumb, objSing.strUserPic5.urlWithThumb, objSing.strUserPic6.urlWithThumb])
        uvTopCube.addSubview(topCube!)
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 10, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
        /*
         CGPoint location =  CGPointMake(0, self.center.y+90);
         location = CGPointMake(80, location.y);
         
         CGPoint location =  CGPointMake(self.center.x, 0);
         location = CGPointMake(self.center.x, 20);
         */
        
        //
        //Center cube view
        //
        transformView?.removeFromSuperview()
        transformView = nil
        
        w = kWidth
        h = w.getDW(SP: 270, S: 220, F: 220) // uvCenterCube.frame.size.height-10
        
        if transformView == nil {
            
            //transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 20, width: w, height: h), cube_size: w.getDW(SP: 230, S: 180, F: 180))
            transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: w.getDW(SP: 210, S: 150, F: 180))
        }
        transformView?.backgroundColor = UIColor.clear
        transformView?.setup(withUrls: [objSing.strUserPic1.urlWithThumb, objSing.strUserPic2.urlWithThumb, objSing.strUserPic3.urlWithThumb, objSing.strUserPic4.urlWithThumb, objSing.strUserPic5.urlWithThumb, objSing.strUserPic6.urlWithThumb])
        uvCenterCube.addSubview(transformView!)
        transformView?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: w.getDW(SP: 115, S: 85, F: 105), y: h/2))
        transformView?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
        uvCenterCubeUpper.layer.masksToBounds = true
        MyStoryBUtton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func FollowerCounts() {
        //
        // Family Count
        //
        let postTitle1: NSMutableAttributedString = NSMutableAttributedString.init(string: "posts\nfollowers\nfamily")
        postTitle1.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle1.length))
        postTitle1.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postTitle1.length))
        
        let style1 = NSMutableParagraphStyle()
        style1.alignment = .right
        postTitle1.addAttribute(NSParagraphStyleAttributeName, value: style1, range: NSMakeRange(0, postTitle1.length))
        
        lblPostLeft.attributedText = postTitle1
        
        
        let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(objSing.post_count)\n\(objSing.follower_count)\n\(objSing.family_count)")
        postDetail.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
        postDetail.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
        style1.alignment = .left
        
        postDetail.addAttribute(NSParagraphStyleAttributeName, value: style1, range: NSMakeRange(0, postDetail.length))
        
        lblPostRight.attributedText = postDetail
    }
    //MARK:- UI
    
    func MyStoryBUtton() {
        btnMyStory.frame = CGRect.init(x: uvTopCube.frame.midX-25, y: uvTopCube.frame.maxY-21, width: 50, height: 42)
        btnMyStory.setImage(#imageLiteral(resourceName: "mystory"), for: .normal)
        self.view.addSubview(btnMyStory)
    }
    
    //MARK:- Action Methods
    
    @IBAction func EditProfile(_ sender: Any) {
        let mvc = EditProfileViewController()
        mvc.showBack = .yes
        self.navigationController?.pushViewController(mvc, animated: true)
    }
    @IBAction func LogoutClicked(_ sender: UIButton) {
        
        
        LogoutClicked()
    }
    
    func MyStoryClicked(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: Storyboards.storyStoryboard.rawValue, bundle: nil)
        let homeVC: StoriesViewController = storyboard.instantiateViewController(withIdentifier: "StoriesViewController") as! StoriesViewController
        homeVC.screenType = .myStories
        topVC?.navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
    func DescriptionClicked(sender: UIButton) {
        
    }
    
    @IBAction func btnTappedMyPhotos(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "PhotoLibraryViewController") as? PhotoLibraryViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func actMyGoLive(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
        let homeVC: ASMyGoLiveVC = mainStoryboard.instantiateViewController(withIdentifier: "ASMyGoLiveVC") as! ASMyGoLiveVC
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
}
