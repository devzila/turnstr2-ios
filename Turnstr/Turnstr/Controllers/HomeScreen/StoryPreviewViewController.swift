//
//  StoryPreviewViewController.swift
//  Turnstr
//
//  Created by Mr X on 07/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit


class StoryPreviewViewController: ParentViewController, UIGestureRecognizerDelegate, StoryCommentsDelegate {
    
    var transformView: AITransformView?
    
    var btnUserName = UIButton()
    
    
    let objStory = Story.sharedInstance
    var objCommentFooter: LikeCommetFooter?
    var userTYpe: enumScreenType = .normal
    //var shareImgUrl = ""
    var shareStoryId = ""
    
    var dictInfo: Dictionary<String, Any> = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dictInfo)
        self.view.backgroundColor = UIColor.white
        
        
        objStory.ParseStoryData(dict: dictInfo)
        
        var arrMedia: [String] = []
        
        for item in objStory.media {
            
            objStory.ParseMedia(media: item)
            arrMedia.append(objStory.thumb_url)
            
            shareStoryId = "\(objStory.storyID)"
            //            if objStory.media_url.isEmpty == false && shareImgUrl.isEmpty == true {
            //                shareImgUrl = objStory.media_url
            //            }
        }
        
        let uvCube = objUtil.createView(xCo: 0, forY: 112, forW: kWidth, forH: kHeight-112, backColor: UIColor.clear)
        self.view.addSubview(uvCube)
        
        let w: CGFloat = kWidth
        let h: CGFloat = uvCube.frame.height // uvCenterCube.frame.size.height-10
        
        transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 250)//w > h ?h-100:w-100
        
        transformView?.backgroundColor = UIColor.white
        transformView?.setup(withUrls: arrMedia)
        uvCube.addSubview(transformView!)
        transformView?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: IS_IPHONE_6 ? 20 : 85, y: h/2))
        transformView?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: kNavBarHeight + w.getDW(SP: 20, S: 35, F: 10)))//(IS_IPHONE_6P ? 45 :28)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        transformView?.addGestureRecognizer(tap)
        
        
        /*
         * Navigation Bar
         */
        createNavBar()
        if IS_IPHONEX == true {
            objUtil.setFrames(xCo: 0, yCo: 20, width: 0, height: 0, view: navBar!)
            //navBar
        }
        
        //        LoadNavBar()
        //        objNav.btnRightMenu.isHidden = true
        //        objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        //        objNav.btnBack.tintColor = UIColor.white
        //
        if userTYpe == .myStories {
            if objStory.strUserID == objSing.strUserID {
                uvNavBar?.addSubview(objNav.RightButonIcon())
                objNav.btnRightMenu.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
                objNav.btnRightMenu.tintColor = UIColor.white
                objNav.btnRightMenu.addTarget(self, action: #selector(DeleteStory), for: .touchUpInside)
            }
        }
        
        SetupUserHeader()
        SetupFooter()
        
        kAppDelegate.loadingIndicationCreation()
        APIRequest(sType: kAPIGetSpecificStory, data: [:])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Setup UserHeader
    
    func SetupUserHeader() {
        //
        //Top Cube View
        //
        
        
        let w: CGFloat = 50
        let h: CGFloat = 50
        
        let uvCube = objUtil.createView(xCo: 10, forY: (navBar?.frame.maxY)!+10, forW: w, forH: h, backColor: UIColor.clear)
        self.view.addSubview(uvCube)
        
        let topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 35)
        topCube?.backgroundColor = UIColor.clear
        
        let urls = [objStory.strUserPic1.urlWithThumb, objStory.strUserPic2.urlWithThumb, objStory.strUserPic3.urlWithThumb, objStory.strUserPic4.urlWithThumb, objStory.strUserPic5.urlWithThumb, objStory.strUserPic6.urlWithThumb]
        print(urls)
        topCube?.setup(withUrls: urls)
        uvCube.addSubview(topCube!)
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 3, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 2))
        topCube?.isUserInteractionEnabled = false
        
        btnUserName.frame = CGRect.init(x: uvCube.frame.maxX+8, y: uvCube.frame.minY, width: kWidth-uvCube.frame.maxX-8, height: h)
        btnUserName.setTitleColor(UIColor.black, for: .normal)
        btnUserName.titleLabel?.font = UIFont.init(name: kFontOpen3, size: 14.0)
        btnUserName.contentHorizontalAlignment = .left
        btnUserName.addTarget(self, action: #selector(OpenProfile(sender:)), for: .touchUpInside)
        self.view.addSubview(btnUserName)
    }
    //MARK:- SetUP Footer
    
    func SetupFooter() -> Void {
        if objCommentFooter == nil {
            objCommentFooter = LikeCommetFooter.init(frame: CGRect.init(x: 0, y: kHeight+kTabBarHeight-140, width: kWidth, height: 140))
        }
        objCommentFooter?.btnLike.addTarget(self, action: #selector(LikeClicked(sender:)), for: .touchUpInside)
        objCommentFooter?.btnComment.addTarget(self, action: #selector(CommentClicked(sender:)), for: .touchUpInside)
        objCommentFooter?.btnTotalComment.addTarget(self, action: #selector(CommentClicked(sender:)), for: .touchUpInside)
        objCommentFooter?.btnShare.addTarget(self, action: #selector(ShareClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(objCommentFooter!)
        
        PrefillData()
    }
    
    func PrefillData() -> Void {
        
        btnUserName.setTitle(objStory.strUserFname.capitalized+" "+objStory.strUserLName.capitalized, for: .normal)
        
        if objCommentFooter != nil {
            objCommentFooter?.lblCaption.text = objStory.strCaption.capitalized
            //objCommentFooter?.btnTotalLike.setTitle("Liked by \(objStory.likes_count) people", for: .normal)
            objCommentFooter?.btnTotalLike.setTitle("\(objStory.strCaption.capitalized)", for: .normal)
            //objCommentFooter?.btnTotalComment.setTitle("\(objStory.comments_count) comments", for: .normal)
            
            objCommentFooter?.btnLike.isSelected = objStory.has_liked
            
        }
    }
    
    //MARK:- Action Methods
    
    func OpenProfile(sender: UIButton) {
        
        if let feedVC = Storyboards.photoStoryboard.initialVC(with: StoryboardIds.feedScreen) as? PublicProfileCollectionViewController {
            feedVC.profileId = Int(objStory.strUserID) ?? nil
            self.navigationController?.pushViewController(feedVC, animated: true)
        }
        
        
    }
    func LikeClicked(sender: UIButton) -> Void {
        
        
        if objStory.has_liked == true {
            dictInfo["likes_count"] = objStory.likes_count-1
            objStory.likes_count = objStory.likes_count-1
            objCommentFooter?.btnTotalLike.setTitle("Liked by \(objStory.likes_count) people", for: .normal)
            objStory.has_liked = false
            dictInfo["has_liked"] = false
        }
        else{
            dictInfo["likes_count"] = objStory.likes_count+1
            objStory.likes_count = objStory.likes_count+1
            objCommentFooter?.btnTotalLike.setTitle("Liked by \(objStory.likes_count) people", for: .normal)
            objStory.has_liked = true
            dictInfo["has_liked"] = true
            
        }
        kAppDelegate.loadingIndicationCreation()
        APIRequest(sType: kAPILikeStory, data: [:])
        
    }
    
    func CommentClicked(sender: UIButton) -> Void {
        //let storyboard = UIStoryboard(name: Storyboards.photoStoryboard.rawValue, bundle: nil)
        //let homeVC: CommentsViewController = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        let homeVC = StoryCommentVC.init(nibName: "StoryCommentVC", bundle: nil)
        homeVC.dictInfo = self.dictInfo
        homeVC.delegate = self
        self.present(homeVC, animated: true, completion: nil)
        
    }
    
    func ShareClicked(sender: UIButton) -> Void {
        
        DispatchQueue.main.async {
            let objectsToShare = ["\(kShareUrl)\(self.shareStoryId)"]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.present(activityVC, animated: true, completion: {
                print("shared")
            })
        }
        
        //        var img = UIImage()
        //        img.downloadImage(url: URL.init(string: shareImgUrl)!) { (data) in
        //            if data != nil {
        //                img = UIImage.init(data: data!)!
        //
        //            }
        //        }
        
        //let fileURL = URL.init(string: "https://www.google.co.in/url?sa=i&rct=j&q=&esrc=s&source=imgres&cd=&cad=rja&uact=8&ved=0ahUKEwi7o6DYkPbXAhUcSY8KHUnkAz8QjRwIBw&url=https%3A%2F%2Fwww.planwallpaper.com%2Fimages&psig=AOvVaw0Xe9lJ06VPsSPjahBOqgty&ust=1512675281008184") //URL.init(fileURLWithPath: "")
        
        
    }
    
    func DeleteStory() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            kAppDelegate.loadingIndicationCreationMSG(msg: "Deleting")
            self.APIRequest(sType: kAPIDELETEStory, data: [:])
        }
        actionSheetController.addAction(yesAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        
        let mvc = ImagePreviewViewController()
        mvc.dictInfo = self.dictInfo
        self.navigationController?.present(mvc, animated: true, completion: nil)
    }
    
    //MARK:- Comments delegate
    
    func CommentCountChanged(count: Int) {
        objCommentFooter?.btnTotalComment.setTitle("\(count) Comments", for: .normal)
    }
    
    //MARK:- APIS Handling
    
    func APIRequest(sType: String, data: Dictionary<String, Any>) -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        DispatchQueue.global().async {
            
            if sType == kAPIGetSpecificStory {
                
                self.objStory.ParseStoryData(dict: self.dictInfo)
                
                let dictAction: NSDictionary = [
                    "action": kAPIGetSpecificStory,
                    "id": self.objStory.storyID
                ]
                
                let arrResponse = self.objDataS.GetRequestToServer(dictAction: dictAction)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        if let story = arrResponse["story"] as? Dictionary<String, Any> {
                            self.dictInfo = story
                            self.objStory.ParseStoryData(dict: self.dictInfo)
                            self.PrefillData()
                        }
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            else if sType == kAPILikeStory {
                
                self.objStory.ParseStoryData(dict: self.dictInfo)
                
                let dictAction: NSDictionary = [
                    "action": kAPILikeStory,
                    "id": self.objStory.storyID
                ]
                
                let arrResponse = self.objDataS.PostRequestToServer(dictAction: dictAction)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        self.objCommentFooter?.btnLike.isSelected = !(self.objCommentFooter?.btnLike.isSelected)!
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            else if sType == kAPIDELETEStory {
                
                self.objStory.ParseStoryData(dict: self.dictInfo)
                
                let dictAction: NSDictionary = [
                    "action": kAPIDELETEStory,
                    "id": self.objStory.storyID
                ]
                
                let arrResponse = self.objDataS.PostRequestToServer(dictAction: dictAction)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        kAppDelegate.hideLoadingIndicator()
                        self.goBack()
                    }
                }
            }
            
            
        }
    }
    
}
