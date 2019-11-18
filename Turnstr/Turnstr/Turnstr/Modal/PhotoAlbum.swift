//
//  PhotoAlbum.swift
//  Turnstr
//
//  Created by Ketan Saini on 13/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation
import ObjectMapper

struct PhotoAlbum: Mappable {
    /// PhotoAlbum properties
    /** id */
    var id: Int?
    /** cover_image_ur. */
    var cover_image_url: String?
    /** mont. */
    var month: Int?
    /** title */
    var title: String?
    /** year */
    var year: Int?
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        cover_image_url <- map["cover_image_url"]
        month <- map["month"]
        title <- map["title"]
        year <- map["year"]
    }
    
    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}
