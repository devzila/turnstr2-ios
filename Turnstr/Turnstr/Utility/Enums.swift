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

enum enumFilterType {
    case standard
    case rightMenu
}

enum enumSearchCategories: Int {
    case countries  = -11
    case state      = -12
    case city       = -13
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

enum enumSounds: Int {
    case MailReceived   = 1000
    case MailSent       = 1001
    case SMSSent        = 1004
    case LowPower       = 1006
    case USSDAlert      = 1050
    case PINKeyPressed  = 1057
    case AudioToneError = 1073
    case KeyPressed     = 1103
    case KeyPressed2    = 1104
    case KeyPressed3    = 1105
    case CameraShutter  = 1108
    case JBL_Confirm    = 1111
    case JBL_Cancel     = 1112
    case JBL_NoMatch    = 1116
    case TouchTone      = 1200
    case TouchTone2     = 1202
}


class Enums: NSObject {

}
