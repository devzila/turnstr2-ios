//
//  ImagePreviewViewController.swift
//  Turnstr
//
//  Created by Mr. X on 15/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ImagePreviewViewController: ParentViewController, UIScrollViewDelegate {
    
    var currentIndex: Int = 0
    let playerController = AVPlayerViewController()
    
    var dictInfo: Dictionary<String, Any> = [:]
    
    let objStory = Story.sharedInstance
    
    let scrScrollView = UIScrollView()
    
    let btnNext = UIButton()
    let btnPrev = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        /*
         * Navigation Bar
         */
        LoadNavBar()
        objNav.btnRightMenu.isHidden = true
        objNav.btnBack.addTarget(self, action: #selector(DismissBack), for: .touchUpInside)
        objNav.btnBack.tintColor = UIColor.white
        
        objStory.ParseStoryData(dict: dictInfo)
        
        
        setupScrollView()
        PagingButtons()
        
        setupPages()
    }
    
    func DismissBack() {
        dismissVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Scroll VIew
    
    func setupScrollView() {
        scrScrollView.frame = CGRect.init(x: 0, y: kNavBarHeight, width: kWidth, height: kHeight)
        scrScrollView.backgroundColor = UIColor.black
        scrScrollView.isPagingEnabled = true
        scrScrollView.delegate = self;
        self.view.addSubview(scrScrollView)
        scrScrollView.contentSize = CGSize.init(width: kWidth * CGFloat(objStory.media.count), height: kHeight)
        
    }
    
    func PagingButtons() {
        btnNext.frame = CGRect.init(x: kWidth-50, y: (kCenterH-25)+kNavBarHeight, width: 50, height: 50)
        btnNext.setImage(#imageLiteral(resourceName: "arrow_right"), for: .normal)
        btnNext.addTarget(self, action: #selector(NextClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(btnNext)
        
        btnPrev.frame = CGRect.init(x: 0, y: (kCenterH-25)+kNavBarHeight, width: 50, height: 50)
        btnPrev.setImage(#imageLiteral(resourceName: "arrow_left"), for: .normal)
        btnPrev.addTarget(self, action: #selector(PrevClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(btnPrev)
    }
    
    func setupPages() {
        
        var j = 0
        
        for item in objStory.media {
            
            objStory.ParseMedia(media: item)
            
            print(objStory.media_type)
            if objStory.media_type == storyContentType.video.rawValue {
                
                let frame = CGRect.init(x: kWidth*CGFloat(j), y: 0, width: kWidth, height: scrScrollView.frame.height)
                
                let imgView = UIImageView.init(frame: frame)
                imgView.sd_setImage(with: URL.init(string: objStory.thumb_url), placeholderImage: #imageLiteral(resourceName: "thumb"))
                imgView.contentMode = .scaleAspectFit
                imgView.isUserInteractionEnabled = true
                scrScrollView.addSubview(imgView)
                
                //CGRect.init(x: imgView.frame.midX-25, y: imgView.frame.midY-25, width: 50, height: 50)
                let btnPlay = UIButton.init(frame: CGRect.init(x: frame.midX-25, y: frame.midY-25, width: 50, height: 50))
                btnPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                btnPlay.backgroundColor = UIColor.darkGray
                btnPlay.layer.cornerRadius = 5.0
                btnPlay.layer.masksToBounds = true
                btnPlay.accessibilityElements = [objStory.media_url]
                btnPlay.addTarget(self, action: #selector(PlayVideo(sender:)), for: .touchUpInside)
                scrScrollView.addSubview(btnPlay)
                
                
            }
            else{
                let imgView = UIImageView.init(frame: CGRect.init(x: kWidth*CGFloat(j), y: 0, width: kWidth, height: scrScrollView.frame.height))
                imgView.sd_setImage(with: URL.init(string: objStory.media_url), placeholderImage: #imageLiteral(resourceName: "thumb"))
                imgView.contentMode = .scaleAspectFit
                scrScrollView.addSubview(imgView)
                
                imgView.isUserInteractionEnabled = true
                
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
                //tap.delegate = self
                tap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(tap)
                
            }
            
            j = j+1
        }
        
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        self.scrScrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    
    //MARK:- Action Methods
    
    func HideViews() {
        uvNavBar?.isHidden = !(uvNavBar?.isHidden)!
        btnNext.isHidden = !btnNext.isHidden
        btnPrev.isHidden = !btnPrev.isHidden
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        HideViews()
    }
    
    func NextClicked(sender: UIButton) -> Void {
        print(scrScrollView.currentPage)
        scrollToPage(page: scrScrollView.currentPage, animated: true)
    }
    
    func PrevClicked(sender: UIButton) -> Void {
        scrollToPage(page: scrScrollView.currentPage-2, animated: true)
    }
    
    
    func PlayVideo(sender: UIButton) {
        
        if let accessEle = sender.accessibilityElements {
            if accessEle.count > 0 {
                
                let urlString: String = (accessEle[0] as? String)!
                
                let url = URL.init(string: urlString)
                
                let player = AVPlayer(url: url!)
                playerController.player = player
                self.present(playerController, animated: true) {
                    player.play()
                }
                
            }
        }
    }
    
}
