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
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPostLeft: UILabel!
    @IBOutlet weak var lblPostRight: UILabel!
    
    @IBOutlet weak var uvCenterCube: UIView!
    @IBOutlet weak var uvTopCube: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblPostLeft.numberOfLines = 0
        lblPostRight.numberOfLines = 0
        
        let postTitle: NSMutableAttributedString = NSMutableAttributedString.init(string: "posts\nfollowers\nfamily")
        postTitle.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle.length))
        postTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postTitle.length))
        
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        postTitle.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postTitle.length))
        
        lblPostLeft.attributedText = postTitle
        
        
        let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(objSing.post_count)\n\(objSing.follower_count)\n\(objSing.family_count)")
        postDetail.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
        postDetail.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
        style.alignment = .left
        
        postDetail.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postDetail.length))
        
        lblPostRight.attributedText = postDetail
        
        //transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 5, width: kWidth, height: uvCenterCube.frame.size.height-10))
        //uvCenterCube.addSubview(transformView!)
        //self.view = transformView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblUserName.text = "@"+objSing.strUserName.lowercased()
        lblDescription.text = objSing.strUserBio
        
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
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 20, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
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
        h = 220 // uvCenterCube.frame.size.height-10
        
        if transformView == nil {
            
            transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 20, width: w, height: h), cube_size: 180)//w > h ?h-100:w-100
        }
        transformView?.backgroundColor = UIColor.clear
        transformView?.setup(withUrls: [objSing.strUserPic1.urlWithThumb, objSing.strUserPic2.urlWithThumb, objSing.strUserPic3.urlWithThumb, objSing.strUserPic4.urlWithThumb, objSing.strUserPic5.urlWithThumb, objSing.strUserPic6.urlWithThumb])
        uvCenterCube.addSubview(transformView!)
        transformView?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 85, y: h/2))
        transformView?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EditProfile(_ sender: Any) {
        let mvc = EditProfileViewController()
        mvc.showBack = .yes
        self.navigationController?.pushViewController(mvc, animated: true)
    }
    @IBAction func LogoutClicked(_ sender: UIButton) {
        LogoutClicked()
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
