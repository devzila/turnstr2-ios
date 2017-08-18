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
