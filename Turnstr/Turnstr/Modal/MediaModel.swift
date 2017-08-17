//
//  MediaModel.swift
//  Turnstr
//
//  Created by Ketan Saini on 13/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation
import ObjectMapper

struct MediaModel: Mappable {
    var media_url: String?
    var thumb_url: String?
    var media_type: String?
    
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        media_url <- map["media_url"]
        thumb_url <- map["thumb_url"]
        media_type <- map["media_type"]
    }
    
    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}
