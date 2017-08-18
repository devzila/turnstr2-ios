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
    @IBOutlet weak var btnChat: UIButton?
    @IBOutlet weak var btnPhotoAlbum: UIButton?
    
    var feeds: UIViewController?
    var profile: UIViewController?
    var story: UIViewController?
    var chat: UIViewController?
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
        
        if story == nil {
            if let feedVC = Storyboards.photoStoryboard.initialVC(with: StoryboardIds.feedScreen) as? PublicProfileCollectionViewController {
                feedVC.profileId = getUserId() ?? nil
                feedVC.isFromFeeds = true
                story = feedVC
            }
        }
        self.activeViewController = story
    }

    @IBAction func btnSelectAction(_ sender: UIButton) {
        
        if sender === btnLiveFeed {
            if feeds == nil {
                feeds = Storyboards.liveStoryboard.initialVC()
            }
            self.activeViewController = feeds
        }
        
        if sender === btnProfile {
            if profile == nil {
                profile = Storyboards.profileStoryboard.initialVC()
            }
            self.activeViewController = profile
        }
        
        if sender === btnStory {
            if story == nil {
                if let feedVC = Storyboards.photoStoryboard.initialVC(with: StoryboardIds.feedScreen) as? PublicProfileCollectionViewController {
                    feedVC.profileId = getUserId() ?? nil
                    feedVC.isFromFeeds = true
                    story = feedVC
                }
            }
            self.activeViewController = story
        }
        
        if sender === btnChat {
            if chat == nil {
                chat = Storyboards.chatStoryboard.initialVC()
            }
            self.activeViewController = chat
        }
        
        if sender === btnPhotoAlbum {
            if photos == nil {
                photos = Storyboards.photoStoryboard.initialVC()
            }
            self.activeViewController = photos
        }
    }
    

}
