//
//  TabbarController.swift
//  Turnstr
//
//  Created by Kamal on 12/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class TabbarController: ParentViewController {

    @IBOutlet var contentView: UIView?
    @IBOutlet weak var btnLiveFeed: UIButton?
    @IBOutlet weak var btnProfile: UIButton?
    @IBOutlet weak var btnStory: UIButton?
    @IBOutlet weak var btnSearch: UIButton?
    @IBOutlet weak var btnGoLive: UIButton?
    
    var feeds: UIViewController?
    var goLive: UIViewController?
    var profile: UIViewController?
    var story: UIViewController?
    var search: ASSearchVC?
    var photos: UIViewController?
    
    
    fileprivate var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    fileprivate func updateActiveViewController() {
        if let activeVC = activeViewController {
            addChild(activeVC)
            
            activeVC.view.frame = contentView?.bounds ?? .zero
            contentView?.addSubview(activeVC.view)
            
            activeVC.didMove(toParent: self)
        }
    }
    
    fileprivate func removeInactiveViewController(_ inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            inActiveVC.willMove(toParent: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            inActiveVC.removeFromParent()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(launchHomeScreen), name: NSNotification.Name.init("LaunchHomeScreen"), object: nil)
        // Do any additional setup after loading the view.
        
        btnSelectAction(btnLiveFeed!)
    }
    
    @objc func launchHomeScreen() {
        btnSelectAction(btnLiveFeed!)
    }

    @IBAction func btnSelectAction(_ sender: UIButton) {
        
        if sender === btnLiveFeed {
            if feeds == nil {
                feeds = Storyboards.liveStoryboard.initialVC()
            }
            self.activeViewController = feeds
        }
        
        if sender === btnGoLive {
            if goLive == nil {
                goLive = Storyboards.goLive.initialVC()
            }
            self.activeViewController = goLive
        }
        
        if sender === btnProfile {
            if profile == nil {
                profile = Storyboards.profileStoryboard.initialVC()
            }
            self.activeViewController = profile
        }
        
        if sender === btnStory {
            let camVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
            topVC?.navigationController?.pushViewController(camVC, animated: true)
        }
        
        if sender === btnSearch {
            if search == nil {
                search = Storyboards.photoStoryboard.initialVC(with: .searchVC) as? ASSearchVC
//                search?.screenType = .myStories
            }
            self.activeViewController = search
        }
    }
    

}
