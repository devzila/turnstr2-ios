//
//  KSResponse.swift
//  Turnstr
//
//  Created by Ketan Saini on 13/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation
import ObjectMapper

struct KSResponse<T>: Mappable {
    var status: Int
    var message: String
    var response: T?
    init?(map: Map) {
        status = -1
        message = "default message"
    }
    mutating func mapping(map: Map) {
        status <- map["statusCode"]
        message <- map["message"]
        switch T.self {
            
        case is PhotoAlbum.Type: response = Mapper<PhotoAlbum>().map(JSONObject: map["albums"].currentValue) as? T
        case is Array<PhotoAlbum>.Type: response = Mapper<PhotoAlbum>().mapArray(JSONObject: map["albums"].currentValue) as? T
            
        case is Photos.Type: response = Mapper<Photos>().map(JSONObject: map["photos"].currentValue) as? T
        case is Array<Photos>.Type: response = Mapper<Photos>().mapArray(JSONObject: map["photos"].currentValue) as? T
            
        default: response <- map["data"]
        }
    }
}
