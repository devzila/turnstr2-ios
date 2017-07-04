//
//  Enums.swift
//  ConetBook
//
//  Created by softobiz on 7/1/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

//MARK:- DropDown TOP RIght Menu
enum showMsgs: String {
    case msgAttention = "Attention!!!"
    case msgNoUser = "No user is available"
}



enum enumPopUPType: Int {
    case date  = -121
    case time  = -122
    case Pwd  = -123
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


class Enums: NSObject {

}
