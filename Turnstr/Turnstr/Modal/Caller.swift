
//
//  Caller.swift
//  Workcocoon
//
//  Created by Sierra 3 on 29/06/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation



struct Caller {
    
    var name: String?
    var sessionId: String?
    var token: String?
    var udid: String?
    var isVideo: Bool = false
    var isCalling: Bool = true
    
    init(name: String) {
        self.name = name
    }
}
