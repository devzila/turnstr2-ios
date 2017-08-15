//
//  StoryPreviewViewController.swift
//  Turnstr
//
//  Created by Mr X on 07/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class StoryPreviewViewController: ParentViewController, UIGestureRecognizerDelegate {
    
    var transformView: AITransformView?
    
    let objStory = Story.sharedInstance
    var objCommentFooter: LikeCommetFooter?
    
    
    var dictInfo: Dictionary<String, Any> = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dictInfo)
        self.view.backgroundColor = UIColor.black
        
        
        objStory.ParseStoryData(dict: dictInfo)
        
        var arrMedia: [String] = []
        
        for item in objStory.media {
            
            objStory.ParseMedia(media: item)
            arrMedia.append(objStory.thumb_url)
        }
        
        let w: CGFloat = kWidth
        let h: CGFloat = kHeight-kNavBarHeight // uvCenterCube.frame.size.height-10
        
        transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 250)//w > h ?h-100:w-100
        
        transformView?.backgroundColor = UIColor.clear
        transformView?.setup(withUrls: arrMedia)
        self.view.addSubview(transformView!)
        transformView?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 85, y: h/2))
        transformView?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: kNavBarHeight+30))
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        transformView?.addGestureRecognizer(tap)
        
        
        /*
         * Navigation Bar
         */
        LoadNavBar()
        objNav.btnRightMenu.isHidden = true
        objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        objNav.btnBack.tintColor = UIColor.white
        
        SetupFooter()
        
        kAppDelegate.loadingIndicationCreation()
        APIRequest(sType: kAPIGetSpecificStory, data: [:])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SetUP Footer
    
    func SetupFooter() -> Void {
        if objCommentFooter == nil {
            objCommentFooter = LikeCommetFooter.init(frame: CGRect.init(x: 0, y: kHeight-120, width: kWidth, height: 120))
        }
        objCommentFooter?.btnLike.addTarget(self, action: #selector(LikeClicked(sender:)), for: .touchUpInside)
        objCommentFooter?.btnComment.addTarget(self, action: #selector(CommentClicked(sender:)), for: .touchUpInside)
        objCommentFooter?.btnTotalComment.addTarget(self, action: #selector(CommentClicked(sender:)), for: .touchUpInside)
        objCommentFooter?.btnShare.addTarget(self, action: #selector(ShareClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(objCommentFooter!)
        
        PrefillData()
    }
    
    func PrefillData() -> Void {
        
        if objCommentFooter != nil {
            objCommentFooter?.lblCaption.text = objStory.strCaption.capitalized
            objCommentFooter?.btnTotalLike.setTitle("\(objStory.likes_count) likes", for: .normal)
            objCommentFooter?.btnTotalComment.setTitle("\(objStory.comments_count) comments", for: .normal)
            
            objCommentFooter?.btnLike.isSelected = objStory.has_liked
            
        }
    }
    
    //MARK:- Action Methods
    func LikeClicked(sender: UIButton) -> Void {
        
        kAppDelegate.loadingIndicationCreation()
        APIRequest(sType: kAPILikeStory, data: [:])
        
    }
    
    func CommentClicked(sender: UIButton) -> Void {
        //let storyboard = UIStoryboard(name: Storyboards.photoStoryboard.rawValue, bundle: nil)
        //let homeVC: CommentsViewController = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        let homeVC = StoryCommentVC.init(nibName: "StoryCommentVC", bundle: nil)
        homeVC.dictInfo = self.dictInfo
        self.present(homeVC, animated: true, completion: nil)
        
    }
    
    func ShareClicked(sender: UIButton) -> Void {
        
    }
    
    
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        
        let mvc = ImagePreviewViewController()
        mvc.dictInfo = self.dictInfo
        self.navigationController?.present(mvc, animated: true, completion: nil)
        
        
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
            
            
        }
    }
    
}
