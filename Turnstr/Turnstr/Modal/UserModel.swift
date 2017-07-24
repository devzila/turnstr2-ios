//
//  UserModel.swift
//  Turnstr
//
//  Created by Ketan Saini on 20/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserModel: Mappable {
    /// PhotoAlbum properties
    /** id */
    var id: Int?
    /** cover_image_ur. */
    var address: String?
    var avatar_face1: String?
    var avatar_face2: String?
    var avatar_face3: String?
    var avatar_face4: String?
    var avatar_face5: String?
    var avatar_face6: String?
    var bio: String?
    var city: String?
    var contact_me: String?
    var email: String?
    var first_name: String?
    var gender: String?
    var info: String?
    var last_name: String?
    var state: String?
    var username: String?
    var website: String?
    /** family_count. */
    var family_count: Int?
    var follower_count: Int?
    var following_count: Int?
    var is_verified: Int?
    var online: Int?
    var post_count: Int?
    var phone: Int?

    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
    }
    
    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}
