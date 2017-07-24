//
//  UserModel.swift
//  Turnstr
//
//  Created by Ketan Saini on 20/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommentModel: Mappable {
    /// PhotoAlbum properties
    /** id */
    var id: Int?
    var body: String?
    var created_at: String?
    var user: UserModel?
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        body <- map["body"]
        created_at <- map["created_at"]
        user <- map["user"]
    }
    
    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}
