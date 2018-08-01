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
    var search: UIViewController?
    var photos: UIViewController?
    
    
    fileprivate var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    fileprivate func updateActiveViewController() {
        if let activeVC = activeViewController {
            addChildViewController(activeVC)
            
            activeVC.view.frame = contentView?.bounds ?? .zero
            contentView?.addSubview(activeVC.view)
            
            activeVC.didMove(toParentViewController: self)
        }
    }
    
    fileprivate func removeInactiveViewController(_ inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            inActiveVC.willMove(toParentViewController: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            inActiveVC.removeFromParentViewController()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
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
            let storyboard = UIStoryboard(name: Storyboards.storyStoryboard.rawValue, bundle: nil)
            let homeVC: StoriesViewController = storyboard.instantiateViewController(withIdentifier: "StoriesViewController") as! StoriesViewController
            homeVC.screenType = .myStories
            topVC?.navigationController?.pushViewController(homeVC, animated: true)
        }
        
        if sender === btnSearch {
            if search == nil {
                search = Storyboards.chatStoryboard.initialVC()
            }
            self.activeViewController = search
        }
    }
    

}
