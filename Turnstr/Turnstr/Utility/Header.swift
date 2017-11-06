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
let kTokBoxSessionId = "2_MX40NTkxMDM5Mn5-MTUwOTc1ODQ1OTI5M35ZcS9RY2ZNNXpwU1AwNWtIREZGMTh3bGd-fg"
// Replace with your generated token
let kPublisherToken = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9NGFmZmY2Yzg5ZTA0ZTI5NjQyMTQ3MDg5Y2EzZTE3MGE2YmU3NmNlNTpzZXNzaW9uX2lkPTJfTVg0ME5Ua3hNRE01TW41LU1UVXdPVGMxT0RRMU9USTVNMzVaY1M5UlkyWk5OWHB3VTFBd05XdElSRVpHTVRoM2JHZC1mZyZjcmVhdGVfdGltZT0xNTA5NzU4NTU5Jm5vbmNlPTAuMDkyMjMzMDgyNDI5MzUxMzUmcm9sZT1wdWJsaXNoZXImZXhwaXJlX3RpbWU9MTUxMjM1MDU1OCZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ=="

let kSubscriberToken = "T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9YzM1NDEyZmYyODYzZGJiY2I2NmYwZGE4ZTcxYmY0YmE1YjRhODU3ZTpzZXNzaW9uX2lkPTJfTVg0ME5Ua3hNRE01TW41LU1UVXdPVGMxT0RRMU9USTVNMzVaY1M5UlkyWk5OWHB3VTFBd05XdElSRVpHTVRoM2JHZC1mZyZjcmVhdGVfdGltZT0xNTEwMDA1NjQ4Jm5vbmNlPTAuNTAxMTYzMTE0Nzg0MjcyMSZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTEyNTk3NjQ3JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9"
//"T1==cGFydG5lcl9pZD00NTkxMDM5MiZzaWc9M2I4MWE3NzFlZmQ0YmY4Nzc0ZjZiYzI2NWQ1NzdjOTZkMWJkZWI1ZjpzZXNzaW9uX2lkPTJfTVg0ME5Ua3hNRE01TW41LU1UVXdPVGMxT0RRMU9USTVNMzVaY1M5UlkyWk5OWHB3VTFBd05XdElSRVpHTVRoM2JHZC1mZyZjcmVhdGVfdGltZT0xNTA5NzU4NjIyJm5vbmNlPTAuMTMxNDAzNjMyNjE5NjU4ODImcm9sZT1zdWJzY3JpYmVyJmV4cGlyZV90aW1lPTE1MTIzNTA2MjEmaW5pdGlhbF9sYXlvdXRfY2xhc3NfbGlzdD0="

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



