//
//  VideoPlayer.swift
//  Turnstr
//
//  Created by Mr. X on 14/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoPlayerDelegates {
    func VideoPlayerDone(videoUrl: URL)
    func VideoPlayerCancel()
}

class VideoPlayer: UIView {
    
    var delegate: VideoPlayerDelegates?
    
    @IBOutlet weak var uvNav: UIView!
    @IBOutlet weak var uvVideoView: UIView!

    var url: URL?
    
    var player:AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let uvNub: UIView = (Bundle.main.loadNibNamed("VideoPlayer", owner: self, options: nil)![0] as? UIView)!
        uvNub.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(uvNub)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Players
    
    func startPlayer(videoUrl: URL) {
        
        url = videoUrl
        
        if player == nil {
            player = AVPlayer.init(url: videoUrl)
        }
        
        if playerLayer == nil {
            playerLayer = AVPlayerLayer(player: player)
        }
        
        playerLayer?.frame = uvVideoView.bounds
        uvVideoView.layer.addSublayer(playerLayer!)
        player?.play()
        
    }
    
    func stopPlayer() {
        player?.pause()
    }

    //MARK:- Action Methods
    
    @IBAction func CancelClicked(_ sender: UIButton) {
        delegate?.VideoPlayerCancel()
        
        self.removeFromSuperview()
    }
    
    @IBAction func DoneClicked(_ sender: UIButton) {
        delegate?.VideoPlayerDone(videoUrl: url!)
        
        self.removeFromSuperview()
    }
    
}
