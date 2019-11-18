
//
//  Storyboards.swift
//  Turnstr
//
//  Created by Kamal on 12/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation


enum Storyboards: String {
    case profileStoryboard = "Profile"
    case chatStoryboard = "Chat"
    case liveStoryboard = "LiveFeed"
    case goLive         = "GoLive"
    case photoStoryboard = "PhotoAlbum"
    case storyStoryboard = "Stories"
    case loginStoryboard = "Login"
    
    func initialVC() -> UIViewController? {
        let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
        let initialVC = storyboard.instantiateInitialViewController()
        return initialVC
    }
    
    func initialVC(with storyboardId: StoryboardIds) -> UIViewController? {
        let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
        let initialVC = storyboard.instantiateViewController(withIdentifier: storyboardId.rawValue)
        return initialVC
    }
}

enum StoryboardIds: String {
    
    case usersList = "UsersListVC"
    case chatVC = "ChatVC"
    case feedScreen = "PublicProfileCollectionViewController"
    case searchVC = "ASSearchVC"
    
}
