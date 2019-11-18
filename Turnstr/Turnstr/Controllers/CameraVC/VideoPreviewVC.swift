//
//  VideoPreviewVC.swift
//  Turnstr
//
//  Created by Kamal on 17/09/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class VideoPreviewVC: UIViewController {

    @IBOutlet weak var videoView: UIView?
    var callbackAction:((_ status: Bool) -> Void)?
    var player:AVPlayer?
    var url: URL? {
        didSet {
            startVideo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func startVideo() {
        guard let videoURL = url else { return }
        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVPlayer(playerItem: playerItem)
        let layer = AVPlayerLayer(player: player)
        layer.frame = videoView?.bounds ?? .zero
        videoView?.layer.addSublayer(layer)
        player.play()
    }
    
    func stopPlayer() {
        player?.pause()
    }
    
    @IBAction func btnCancelAction() {
        callbackAction?(false)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnDoneAction() {
        callbackAction?(true)
        dismiss(animated: false, completion: nil)
    }
}
