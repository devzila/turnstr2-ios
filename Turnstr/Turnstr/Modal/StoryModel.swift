//
//  StoryModel.swift
//  Turnstr
//
//  Created by Ketan Saini on 13/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation
import ObjectMapper

struct StoryModel: Mappable {
    /** id */
    var id: Int?
    var caption: String?
    var comments_count: Int?
    var likes_count: Int?
    var user: UserModel?
    var media: [MediaModel]?
    
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        caption <- map["caption"]
        comments_count <- map["comments_count"]
        likes_count <- map["likes_count"]
        user <- map["user"]
        media <- map["media"]
    }
    
    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}


struct VideoStory {
    
    var comments_count: Int
    var duration: Int
    var event: String
    var id: Int
    var likes_count: Int
    var url: String
    
    init(dict: Dictionary<String, Any>) {
        if let obj = dict["comments_count"] as? Int {
            self.comments_count = obj
        } else{
            self.comments_count = 0
        }
        
        if let obj = dict["duration"] as? Int {
            self.duration = obj
        } else{
            self.duration = 0
        }
        
        if let obj = dict["event"] as? String {
            self.event = obj
        } else{
            self.event = ""
        }
        
        if let obj = dict["id"] as? Int {
            self.id = obj
        } else{
            self.id = 0
        }
        
        if let obj = dict["likes_count"] as? Int {
            self.likes_count = obj
        } else{
            self.likes_count = 0
        }
        
        if let obj = dict["url"] as? String {
            self.url = obj
        } else{
            self.url = ""
        }
    }
}
