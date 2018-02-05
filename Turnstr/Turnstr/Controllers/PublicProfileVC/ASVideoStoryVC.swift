//
//  ASVideoStoryVC.swift
//  Turnstr
//
//  Created by Mr. X on 28/12/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import AVFoundation

class ASVideoStoryVC: ParentViewController {

    var objCommentFooter: LikeCommetFooter?
    var videoStory : VideoStory!
    
    let uvCenterView = UIView()
    
    var playerAV: AVPlayer?
    var playerLayerAV: AVPlayerLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        /*
         * Navigation Bar
         */
        createNavBar()
        
        centerVideoView()
        
        startVideo()
        SetupFooter()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if playerAV != nil {
            playerAV?.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if playerAV != nil {
            playerAV?.pause()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerVideoView() {
        uvCenterView.frame = CGRect.init(x: 0, y: (navBar?.frame.maxY)!, width: kWidth, height: kHeight-(navBar?.frame.maxY)!)
        self.view.addSubview(uvCenterView)
    }
    
    func startVideo() {
        
        let url = URL.init(string: videoStory.url)
        if url == nil {
            return
        }
        
        if  playerAV == nil {
            playerAV = AVPlayer.init(url: url!)
        }
        
        playerAV?.isMuted = false
        if playerLayerAV == nil {
            playerLayerAV = AVPlayerLayer(player: playerAV)
            
        } else {
            playerLayerAV?.player = playerAV
        }
        
        playerLayerAV?.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: uvCenterView.frame.height)
        uvCenterView.layer.addSublayer(playerLayerAV!)
        playerAV?.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerAV?.currentItem, queue: .main) { (_) in
            self.playerAV?.seek(to: kCMTimeZero)
            self.playerAV?.play()
        }
        
    }

    //MARK:- SetUP Footer
    
    func SetupFooter() -> Void {
        if objCommentFooter == nil {
            objCommentFooter = LikeCommetFooter.init(frame: CGRect.init(x: 0, y: kHeight+kTabBarHeight-120, width: kWidth, height: 120))
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
            //objCommentFooter?.lblCaption.text = objStory.strCaption.capitalized
            //objCommentFooter?.btnTotalLike.setTitle("Liked by \(objStory.likes_count) people", for: .normal)
            //objCommentFooter?.btnTotalComment.setTitle("\(objStory.comments_count) comments", for: .normal)
            
            ///objCommentFooter?.btnLike.isSelected = objStory.has_liked
            
        }
    }
    
    func LikeClicked(sender: UIButton) -> Void {
        sender.isSelected = !sender.isSelected
        
//        videoStory.likes_count
//        if objStory.has_liked == true {
//
//            dictInfo["likes_count"] = objStory.likes_count-1
//            objStory.likes_count = objStory.likes_count-1
//            objCommentFooter?.btnTotalLike.setTitle("Liked by \(objStory.likes_count) people", for: .normal)
//            objStory.has_liked = false
//            dictInfo["has_liked"] = false
//        }
//        else{
//            dictInfo["likes_count"] = objStory.likes_count+1
//            objStory.likes_count = objStory.likes_count+1
//            objCommentFooter?.btnTotalLike.setTitle("Liked by \(objStory.likes_count) people", for: .normal)
//            objStory.has_liked = true
//            dictInfo["has_liked"] = true
//
//        }
//        kAppDelegate.loadingIndicationCreation()
//        APIRequest(sType: kAPILikeStory, data: [:])
        
    }
    
    func CommentClicked(sender: UIButton) -> Void {
        let homeVC = StoryCommentVC.init(nibName: "StoryCommentVC", bundle: nil)
        homeVC.screen = .videoStory
        homeVC.storyId = videoStory.id
        //homeVC.delegate = self
        self.present(homeVC, animated: true, completion: nil)
        
    }
    
    func ShareClicked(sender: UIButton) -> Void {
        
        var img = videoStory.url
        let objectsToShare = [img]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: {
            print("shared")
        })
        
    }
    
    override func goBack() -> Void {
        playerAV?.isMuted = true
        playerAV?.pause()
        playerAV = nil
        playerLayerAV?.removeFromSuperlayer()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
