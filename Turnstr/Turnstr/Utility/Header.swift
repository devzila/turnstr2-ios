//
//  Header.swift
//  Swift3
//
//  Created by softobiz on 11/28/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import Foundation
import UIKit



let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0

/*
 * API Urls
 */

let kBaseURL = "https://fathomless-retreat-45620.herokuapp.com/v1/"
let kImageBaseUrl = ""


let kAPILogin = "sessions"
let kAPISignUp = "signup"
let kAPIUpdateProfile = "user/profile"
let kAPIGetStories = "user/stories"
let kAPIGetAllStories = "stories"
let kAPIPOSTStories = "user/stories"
let kAPIFacebookLogin = "facebook/login"
let kAPIPhotoAlbum = "user/albums"
let kAPIUserPhotoUpload = "user/photos"
let kAPIPhotoDetail = "photos"
let kAPIGetAllPhotos = "photos"
let kAPIGetSpecificStory = "stories/"
let kAPIFollowUnfollowUser = "members"

let kAPIDELETEStory = "DELETE user/stories/<story-id>"
let kAPILikeStory = "stories/<story-id>/likes"
let kAPIGetStoriesComments = "stories/<story-id>/comments"













/*
 * User Defaults Entries
 */

let kUDLoginData = "ud_LoginData"
let kUDSessionData = "ud_LoginSession"



/*
 * Notification Requests
 */

let kNotiSessionExpired = "noti_SessionExpired"




/*
 * General Methods
 */
let kTabBarHeight: CGFloat = 60

let kWidth = UIScreen.main.bounds.size.width
let kHeight = UIScreen.main.bounds.size.height-kTabBarHeight
let kCenterW = kWidth/2
let kCenterH = kHeight/2


let kNavBarHeight: CGFloat = 60


let kNavBarHeightWithLogo: CGFloat = 60



let kAppDelegate = (UIApplication.shared.delegate as! AppDelegate)

let krgbClear = UIColor.clear


let kFontOpen1 = "OpenSans"
let kFontOpen2 = "OpenSans-Light"
let kFontOpen3 = "OpenSans-Semibold"
let kFontOpen4 = "OpenSans-Bold"
let kFontOpen5 = "OpenSansLight-Italic"

let kMenuTitleSize: CGFloat = 14.0

let kLightGray = UIColor.init("FAFAFA")
let kSeperatorColor = UIColor.init("F3F3F3")

let kMenuBG = kLightGray
let kBlueColor  = UIColor.init("5da1fb")
let kOrangeColor = UIColor.init("FF9B00")

let kShareFontColor = UIColor.init("1E1E1E")



