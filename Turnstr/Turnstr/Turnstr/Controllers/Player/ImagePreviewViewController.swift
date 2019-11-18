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
    
    var cv: CubePageView?
    var arrPlayers: [AVPlayer?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        /*
         * Navigation Bar
         */
        setupPages()
        let btnBack = UIButton.init(frame: CGRect.init(x: 0, y: 20, width: 50, height: 40))
        btnBack.setImage(#imageLiteral(resourceName: "back_arrow"), for: .normal)
        btnBack.tintColor = .white
        self.view.addSubview(btnBack)
        btnBack.addTarget(self, action: #selector(DismissBack), for: .touchUpInside)
        objStory.ParseStoryData(dict: dictInfo)
        
        //setupScrollView()
        PagingButtons()
        
        
    }
    
    deinit {
        stopAllPlayers()
        remoAllPlayers()
    }
    
    @objc func DismissBack() {
        dismissVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Scroll VIew
    
    func setupScrollView() {
        scrScrollView.frame = CGRect.init(x: 0, y: kNavBarHeightNew, width: kWidth, height: kHeight-kNavBarHeightNew)
        scrScrollView.backgroundColor = UIColor.white
        scrScrollView.isPagingEnabled = true
        scrScrollView.delegate = self;
        self.view.addSubview(scrScrollView)
        scrScrollView.contentSize = CGSize.init(width: kWidth * CGFloat(objStory.media.count), height: kHeight)
        
    }
    
    func PagingButtons() {
        //        btnNext.frame = CGRect.init(x: kWidth-50, y: (kCenterH-25)+kNavBarHeight, width: 50, height: 50)
        btnNext.frame = CGRect.init(x: kWidth-100, y: kNavBarHeight, width: 100, height: kHeight-kNavBarHeight)
        //        btnNext.setImage(#imageLiteral(resourceName: "arrow_right"), for: .normal)
        btnNext.addTarget(self, action: #selector(NextClicked(sender:)), for: .touchUpInside)
        btnNext.backgroundColor = .clear
        self.view.addSubview(btnNext)
        
        //        btnPrev.frame = CGRect.init(x: 0, y: (kCenterH-25)+kNavBarHeight, width: 50, height: 50)
        btnPrev.frame = CGRect.init(x: 0, y: kNavBarHeight, width: 100, height: kHeight-kNavBarHeight)
        //        btnPrev.setImage(#imageLiteral(resourceName: "arrow_left"), for: .normal)
        btnPrev.addTarget(self, action: #selector(PrevClicked(sender:)), for: .touchUpInside)
        btnPrev.backgroundColor = .clear
        self.view.addSubview(btnPrev)
    }
    
    func setupPages() {
        
        var arrPages: [Any] = []
        let frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight)
        
        var j = 0
        
        for item in objStory.media {
            
            objStory.ParseMedia(media: item)
            
            print(objStory.media_type)
            if objStory.media_type == storyContentType.video.rawValue {
                
                let frame = CGRect.init(x: 0, y: 0, width: kWidth, height: frame.height)
                let imgView = UIView.init(frame: frame)
                imgView.backgroundColor = UIColor.black
                
                let url = URL.init(string: objStory.media_url)
                if url == nil {
                    return
                }
                
                let playerAV = AVPlayer.init(url: url!)
                let playerLayerAV = AVPlayerLayer(player: playerAV)
                
                playerLayerAV.videoGravity = AVLayerVideoGravity.resizeAspectFill
                
                playerAV.isMuted = true
                playerLayerAV.frame = frame
                imgView.layer.addSublayer(playerLayerAV)
                arrPages.append(imgView)
                if j == 0 { // if first item the start playing
                    playerAV.isMuted = false
                    playerAV.play()
                }
                arrPlayers.append(playerAV)
                
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerAV.currentItem, queue: .main) { (_) in
                    playerAV.seek(to: CMTime.zero)
                    playerAV.play()
                }
            }
            else if objStory.media_type.isEmpty == true {
                arrPlayers.append(nil)
            }
            else{
                arrPlayers.append(nil)
                
                let frame = CGRect.init(x: 0, y: 0, width: kWidth, height: frame.height)
                
                let imgView = UIImageView.init(frame: frame)//CGRect.init(x: kWidth*CGFloat(j), y: 0, width: kWidth, height: scrScrollView.frame.height)
                imgView.sd_setImage(with: URL.init(string: objStory.media_url), placeholderImage: #imageLiteral(resourceName: "thumb"))
                imgView.contentMode = .scaleAspectFit
                imgView.backgroundColor = UIColor.black
                
                //scrScrollView.addSubview(imgView)
                
                imgView.isUserInteractionEnabled = true
                
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
                //tap.delegate = self
                tap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(tap)
                
                arrPages.append(imgView)
            }
            
            j = j+1
        }
        
        
        cv = CubePageView.init(frame: frame)
        cv?.delegate = self
        cv?.setPages(arrPages)
        self.view.addSubview(cv!)
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
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        HideViews()
    }
    
    @objc func NextClicked(sender: UIButton) -> Void {
        if cv != nil {
            print(cv?.currentPage())
            let totalPage = cv!.numberPages()
            let currentPage = cv!.currentPage()
            let nextPage = currentPage+1
            if nextPage < totalPage {
                cv?.selectPage(nextPage, withAnim: true)
            } else{
                cv?.selectPage(0, withAnim: true)
            }
            
        }
        
        //print(scrScrollView.currentPage)
        //scrollToPage(page: scrScrollView.currentPage, animated: true)
    }
    
    @objc func PrevClicked(sender: UIButton) -> Void {
        if cv != nil {
            print(cv?.currentPage())
            let totalPage = cv!.numberPages()
            let currentPage = cv!.currentPage()
            let prePage = currentPage-1
            if prePage > -1 {
                cv?.selectPage(prePage, withAnim: true)
            } else{
                cv?.selectPage(totalPage-1, withAnim: true)
            }
            
        }
        //scrollToPage(page: scrScrollView.currentPage-2, animated: true)
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

extension ImagePreviewViewController: CubePageView_Delegate {
    func actMuteClicked(sender: UIButton)  {
        guard let accessEle = sender.accessibilityElements else {return}
        if accessEle.count > 0, let _ = accessEle.first as? AVPlayer {
            sender.isSelected = !sender.isSelected
        }
    }
    
    func cubePageView(_ pc: CubePageView!, newPage page: Int32) {
        print("Page : \(page)")
        
        stopAllPlayers()
        
        if arrPlayers.count > page {
            guard let player = self.arrPlayers[Int(page)] else {return}
            player.isMuted = false
            player.play()
        }
    }
    
    func stopAllPlayers() {
        ///Stop all previous players
        for player in arrPlayers{
            if player != nil {
                player!.isMuted = true
                player?.pause()
            }
        }
    }
    
    func remoAllPlayers() {
        for player in arrPlayers {
            var playerAv = player
            if playerAv != nil {
                playerAv!.isMuted = true
                playerAv = nil
            }
        }
    }
}
