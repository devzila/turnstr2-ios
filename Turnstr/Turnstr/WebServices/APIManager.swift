//
//  APIManager.swift
//  Turnstr
//
//  Created by Mr X on 27/06/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {

    static let sharedInstance: APIManager = {
        let instance = APIManager()
        
        return instance
    }()
}
