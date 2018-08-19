//
//  ASStoryPreviewVC.swift
//  Turnstr
//
//  Created by Mr. X on 20/08/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ASStoryPreviewVC: ParentViewController {

    var currentIndex: Int = 0
    let playerController = AVPlayerViewController()
    
    var arrStories: [UserStories] = []
    
    
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
        PagingButtons()
        
        let btnBack = UIButton.init(frame: CGRect.init(x: 0, y: 20, width: 50, height: kNavBarHeight))
        btnBack.setImage(#imageLiteral(resourceName: "back_arrow"), for: .normal)
        btnBack.tintColor = .white
        self.view.addSubview(btnBack)
        btnBack.addTarget(self, action: #selector(DismissBack), for: .touchUpInside)
        
        
        kMainQueue.asyncAfter(deadline: .now()+0.1) {
            self.gotoCurrentPage()
        }
    }
    
    func gotoCurrentPage() {
        if cv != nil {
            print(cv?.currentPage())
            let totalPage = cv!.numberPages()
            if currentIndex < totalPage {
                cv?.selectPage(Int32(currentIndex), withAnim: false)
            } else{
                cv?.selectPage(0, withAnim: true)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit {
        stopAllPlayers()
        remoAllPlayers()
    }
    
    func DismissBack() {
        stopAllPlayers()
        remoAllPlayers()
        
        dismissVC()
    }

    func PagingButtons() {
        
        btnNext.frame = CGRect.init(x: kWidth-100, y: kNavBarHeight, width: 100, height: kHeight-kNavBarHeight)
        btnNext.addTarget(self, action: #selector(NextClicked(sender:)), for: .touchUpInside)
        btnNext.backgroundColor = .clear
        self.view.addSubview(btnNext)
        
        btnPrev.frame = CGRect.init(x: 0, y: kNavBarHeight, width: 100, height: kHeight-kNavBarHeight)
        btnPrev.addTarget(self, action: #selector(PrevClicked(sender:)), for: .touchUpInside)
        btnPrev.backgroundColor = .clear
        self.view.addSubview(btnPrev)
    }
    
    func setupPages() {
        
        var arrPages: [Any] = []
        let frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight)
        
        for (index, item) in arrStories.enumerated() {
            print(item.content_type)
            if item.content_type == storyContentType.video.rawValue {
                
                let frame = CGRect.init(x: 0, y: 0, width: kWidth, height: frame.height)
                let imgView = UIView.init(frame: frame)
                imgView.backgroundColor = UIColor.black
                
                let url = URL.init(string: item.media_url)
                if url == nil {
                    return
                }
                
                let playerAV = AVPlayer.init(url: url!)
                let playerLayerAV = AVPlayerLayer(player: playerAV)
                
                playerLayerAV.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                playerAV.isMuted = true
                playerLayerAV.frame = frame
                imgView.layer.addSublayer(playerLayerAV)
                arrPages.append(imgView)
                if index == currentIndex { // if currentIndex item the start playing
                    playerAV.isMuted = false
                    playerAV.play()
                }
                arrPlayers.append(playerAV)
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerAV.currentItem, queue: .main) { (_) in
                    playerAV.seek(to: kCMTimeZero)
                    playerAV.play()
                }
                
            }
            else if item.content_type.isEmpty == true {
                arrPlayers.append(nil)
            }
            else{
                arrPlayers.append(nil)
                
                let imgView = UIImageView.init(frame: frame)
                imgView.sd_setImage(with: URL.init(string: item.media_url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
                imgView.contentMode = .scaleAspectFit
                imgView.backgroundColor = UIColor.black
                
                imgView.isUserInteractionEnabled = true
                
                arrPages.append(imgView)
            }
        }
        
        
        cv = CubePageView.init(frame: frame)
        cv?.delegate = self
        cv?.setPages(arrPages)
        self.view.addSubview(cv!)
    }
    
    //MARK:- Action Methods
    
    func NextClicked(sender: UIButton) -> Void {
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
    
    func PrevClicked(sender: UIButton) -> Void {
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

extension ASStoryPreviewVC: CubePageView_Delegate {
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
