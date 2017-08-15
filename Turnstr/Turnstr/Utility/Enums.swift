//
//  Enums.swift
//  ConetBook
//
//  Created by softobiz on 7/1/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

enum enumScreenType {
    case myStories
    case normal
}

//MARK:- DropDown TOP RIght Menu
enum showMsgs: String {
    case msgAttention = "Attention!!!"
    case msgNoUser = "No user is available"
}

enum enumMediaType: String {
    case image
    case video
}

enum storyContentType: String {
    case image = "image/jpeg"
    case video = "video/mp4"
}

enum enumPopUPType: Int {
    case date
    case time
    case pwd
    case newStory
}

enum enumDropDownType: Int {
    case gender = -221
    case search = -222
    case surgeryType = -223
}

enum enumPickerType: Int {
    case image = -301
}

enum enumViewType: String {
    case popUP = "popUP"
    case controller = "controller"
}

enum storyboardType: String {
    case main = "Main"
    case login = "Login"
}

enum showBack {
    case yes
    case no
}

class Enums: NSObject {
    
}
