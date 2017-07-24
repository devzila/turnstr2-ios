//
//  Photos.swift
//  Turnstr
//
//  Created by Ketan Saini on 15/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation

import ObjectMapper

struct Photos: Mappable {
    /// PhotoAlbum properties
    /** id */
    var id: Int?
    /** captured_date */
    var captured_date: String?
    /** image_medium */
    var image_medium: String?
    /** image_original */
    var image_original: String?
    /** image_thumb */
    var image_thumb: String?
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        captured_date <- map["captured_date"]
        image_medium <- map["image_medium"]
        image_original <- map["image_original"]
        image_thumb <- map["image_thumb"]
    }
    
    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}
