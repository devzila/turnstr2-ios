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

// *** Fill the following variables using your own Project info  ***
// ***            https://tokbox.com/account/#/                  ***
// Replace with your OpenTok API key
let kTokBoxApiKey = "45910392"
// Replace with your generated session ID
let kTokBoxSessionId = "1_MX40NTkxMDM5Mn5-MTUxMDA1Mjk1MTA0NX5lM0JlQXZFdlpBMXZUWnlqa1kxVitFcjZ-fg"
// Replace with your generated token
let kPublisherToken1 = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9NzlmODBmNGMzYmU5NDZjYWY1ODJkMGQwZDFmNTQ4MjBiZDIyMzMyMjpzZXNzaW9uX2lkPTFfTVg0ME5Ua3hNRE01TW41LU1UVXhNREExTWprMU1UQTBOWDVsTTBKbFFYWkZkbHBCTVhaVVdubHFhMWt4Vml0RmNqWi1mZyZjcmVhdGVfdGltZT0xNTEwMDUyOTc4Jm5vbmNlPTAuODAyMzkwNjI3NjEwMjk2MSZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTEyNjQ0OTc2JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9"

let kPublisherToken2 = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9MjgwOTVkZGM5NzQ3NmQ1MjEzM2Q5ZWUxZmI4YjhkYTgyNTc3ZjA5ZDpzZXNzaW9uX2lkPTFfTVg0ME5Ua3hNRE01TW41LU1UVXhNREExTWprMU1UQTBOWDVsTTBKbFFYWkZkbHBCTVhaVVdubHFhMWt4Vml0RmNqWi1mZyZjcmVhdGVfdGltZT0xNTEwMDUzMDI3Jm5vbmNlPTAuNjc0MjMwNDQwNDg0MzE0NyZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTEyNjQ1MDI1JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9"

let kPublisherToken3 = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9NTIxYzE2YjMzYTA2NGUxNzIxODgxZDBiNGU4OGIwZjc2ZWJhMDUxZTpzZXNzaW9uX2lkPTFfTVg0ME5Ua3hNRE01TW41LU1UVXhNREExTWprMU1UQTBOWDVsTTBKbFFYWkZkbHBCTVhaVVdubHFhMWt4Vml0RmNqWi1mZyZjcmVhdGVfdGltZT0xNTEwMTU3ODM1Jm5vbmNlPTAuMTc5NTU4MzcxNTQyNzgwNDMmcm9sZT1wdWJsaXNoZXImZXhwaXJlX3RpbWU9MTUxMjc0OTgzNCZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ=="

let kPublisherToken4 = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9MzUwNmQyOGNlMzc3Nzc2YmQ3N2JjMWI2Yzg5ZDcxZWU5MjZkOTIxZDpzZXNzaW9uX2lkPTFfTVg0ME5Ua3hNRE01TW41LU1UVXhNREExTWprMU1UQTBOWDVsTTBKbFFYWkZkbHBCTVhaVVdubHFhMWt4Vml0RmNqWi1mZyZjcmVhdGVfdGltZT0xNTEwMTU3ODY5Jm5vbmNlPTAuNTE0MzE1NjQwMjA5MzkzOCZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTEyNzQ5ODY3JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9"
/*
 *-----------------------------------
 */



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
let kAPIArrangeStory = "user/stories/arrange"
let kSaveTokenToServer = "user/devices"


let kAPIDELETEStory = "DELETE user/stories/<story-id>"
let kAPILikeStory = "stories/<story-id>/likes"
let kAPIGetStoriesComments = "stories/<story-id>/comments"




/*
 Background queues
 */
let kBQ_UpdatePosition = DispatchQueue(label: "queue_arrange_position", attributes: .concurrent)
let kBQ_MyStoryQueue = DispatchQueue(label: "queue_my_story", attributes: .concurrent)
let kBQ_FCMTokenUpdate = DispatchQueue(label: "queue_fcm_update", attributes: .concurrent)
let kBQ_startCall = DispatchQueue(label: "queue_start_call", attributes: .concurrent)






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
let kHeight = UIScreen.main.bounds.size.height
let kCenterW = kWidth/2
let kCenterH = kHeight/2


let kNavBarHeight: CGFloat = 60
let kNavBarHeightNew: CGFloat = 112


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



