//
//  StoryMedia.swift
//  Turnstr
//
//  Created by Kamal on 11/08/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import Foundation

struct StoryMedia {
    var id: Int?
    var mediaUrl: URL?
    var createdAt: String?
    var updatedAt: String?
    
    init(_ info: [String: Any]) {
        id = info["id"] as? Int
        createdAt = info["created_at"] as? String
        updatedAt = info["updated_at"] as? String
        if let strUrl = info["media_url"] as? String {
            mediaUrl = URL(string: strUrl)
        }
    }
}
