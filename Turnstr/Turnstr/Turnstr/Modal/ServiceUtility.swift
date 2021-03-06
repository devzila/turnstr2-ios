//
//  ServiceUtility.swift
//  Turnstr
//
//  Created by Ketan Saini on 13/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation

protocol ServiceUtility {
    
}

enum FavouriteType: String {
    case delete = "DELETE"
    case post = "POST"
}

extension ServiceUtility {
    
    func photoAlbum(withHandler handler: @escaping (_ response: KSResponse<[PhotoAlbum]>?) -> Void) {
        checkNetworkConnection()
        DispatchQueue.main.async {
            let strRequest = ""
            let strPostUrl = kAPIPhotoAlbum
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictAlbum = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "albums": dictAlbum["albums"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[PhotoAlbum]>(JSON: dictMapper)
                        handler(ksResponse)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    
    func uploadPhotoToAlbum(arrImages: [UIImage]) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = ["action":kAPIUserPhotoUpload]
            let strPostUrl = kAPIUserPhotoUpload
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.uploadMedia(PostURL: strPostUrl, strData: strRequest, parType: strParType, arrImages: arrImages)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    Utility.sharedInstance.showToast(strMsg: "Image uploaded sucessfully")
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
        
    }
    
    func getAlbumPhotos(id: Int, withHandler handler: @escaping (_ response: KSResponse<[Photos]>?) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = ""
            let strPostUrl = kAPIPhotoAlbum + "/\(id)/photos"
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictPhoto = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "photos": dictPhoto["photos"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[Photos]>(JSON: dictMapper)
                        handler(ksResponse)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
            
        }
    }
    
    func getAllPublicPhotos(page: Int, withHandler handler: @escaping (_ response: KSResponse<[Photos]>?, _ dict: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = String(format: "?page=%d", page)
            let strPostUrl = kAPIGetAllPhotos
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    
                    if let dictPhoto = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "photos": dictPhoto["photos"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[Photos]>(JSON: dictMapper)
                        handler(ksResponse, dictPhoto)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
            
        }
    }
    
    func getPhotoDetail(idAlbum: Int?, idPhoto: Int, isPublic: Bool, withHandler handler: @escaping (_ response: KSResponse<Photos>?) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = ""
            var strPostUrl = ""
            if isPublic {
                strPostUrl = kAPIGetAllPhotos + "/\(idPhoto)"
            } else {
                strPostUrl = kAPIPhotoAlbum + "/\(idAlbum!)/photos/\(idPhoto)"
            }
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictPhoto = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "photos": dictPhoto["photo"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<Photos>(JSON: dictMapper)
                        handler(ksResponse)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
            
        }
    }
    
    func postPhotoComment(id: Int, comment: String, withHandler handler: @escaping (_ response: KSResponse<CommentModel>?) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strPostUrl = kAPIPhotoDetail + "/\(id)/comments"
            let strParType = ""
            let dictAction: NSDictionary = [
                "action": kAPIPhotoDetail,
                "comment[body]": comment
            ]
            
            let dictResponse = WebServices.sharedInstance.uploadMedia(PostURL: strPostUrl, strData: dictAction as! Dictionary<String, String>, parType: strParType, arrImages: [])
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictComment = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "comment": dictComment["comment"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<CommentModel>(JSON: dictMapper)
                        handler(ksResponse)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func getPhotoComment(id: Int, page: Int, withHandler handler: @escaping (_ response: KSResponse<[CommentModel]>?, _ dict: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = String(format: "?page=%d", page)
            let strPostUrl = kAPIPhotoDetail + "/\(id)/comments"
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "comment": dictComments["comments"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[CommentModel]>(JSON: dictMapper)
                        handler(ksResponse, dictComments)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func likeUnlikePhoto(id: Int, withHandler handler: @escaping (_ response: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strPutUrl = kAPIPhotoDetail + "/\(id)/likes"
            
            let dictResponse = WebServices.sharedInstance.putPostMultipartDataToServer(PutPostURL: strPutUrl, type: "POST", strData: ["":""], parType: "")
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictlike = dictResponse["data"] as? [String: Any] {
                        handler(dictlike)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func followUnFollowUser(id: Int, type: String, withHandler handler: @escaping (_ response: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strPutUrl = kAPIFollowUnfollowUser + "/\(id)/\(type)"
            
            let dictResponse = WebServices.sharedInstance.putPostMultipartDataToServer(PutPostURL: strPutUrl, type: "POST", strData: ["":""], parType: "")
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictlike = dictResponse["data"] as? [String: Any] {
                        handler(dictlike)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func getMemberDetails(id: Int, withHandler handler: @escaping (_ response: KSResponse<UserModel>?) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = ""
            let strPostUrl = kAPIFollowUnfollowUser + "/\(id)"
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictPhoto = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "user": dictPhoto["member"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<UserModel>(JSON: dictMapper)
                        handler(ksResponse)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
            
        }
    }
    
    func getAllMember(page: Int, withHandler handler: @escaping (_ response: KSResponse<[UserModel]>?, _ dict: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = String(format: "?page=%d", page)
            let strPostUrl = kAPIFollowUnfollowUser
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictPhoto = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "user": dictPhoto["members"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[UserModel]>(JSON: dictMapper)
                        handler(ksResponse, dictPhoto)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
            
        }
    }
    
    func getFave5(id: Int, page: Int, withHandler handler: @escaping (_ response: KSResponse<[UserModel]>?, _ dict: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = String(format: "?page=%d", page)
            let strPostUrl = kAPIFollowUnfollowUser + "/\(id)/favourites"
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "user": dictComments["favourites"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[UserModel]>(JSON: dictMapper)
                        handler(ksResponse, dictComments)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func getPopular(id: Int, page: Int, withHandler handler: @escaping (_ response: KSResponse<[UserModel]>?, _ dict: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = String(format: "?page=%d", page)
            let strPostUrl = "/populars"
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "user": dictComments["members"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[UserModel]>(JSON: dictMapper)
                        handler(ksResponse, dictComments)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func addDeleteFave5(id: Int, type: FavouriteType, withHandler handler: @escaping (_ response: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strPutUrl = kAPIFollowUnfollowUser + "/\(id)/favourites"
            
            let dictResponse = WebServices.sharedInstance.putPostMultipartDataToServer(PutPostURL: strPutUrl, type: type.rawValue, strData: ["":""], parType: "")
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictlike = dictResponse["data"] as? [String: Any] {
                        handler(dictlike)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func deleteUserPhoto(albumId: Int, photoId: Int, withHandler handler: @escaping (_ response: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strPutUrl = kAPIPhotoAlbum + "/\(albumId)/photos/\(photoId)"
            
            let dictResponse = WebServices.sharedInstance.putPostMultipartDataToServer(PutPostURL: strPutUrl, type: "DELETE", strData: ["":""], parType: "")
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictlike = dictResponse["data"] as? [String: Any] {
                        handler(dictlike)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func addUserAsFamily(id: Int, withHandler handler: @escaping (_ response: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strPutUrl = kAPIFollowUnfollowUser + "/\(id)/family"
            
            let dictResponse = WebServices.sharedInstance.putPostMultipartDataToServer(PutPostURL: strPutUrl, type: "POST", strData: ["":""], parType: "")
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictlike = dictResponse["data"] as? [String: Any] {
                        handler(dictlike)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func getSpecificUserStories(id: Int, page: Int, isAllStories: Bool, withHandler handler: @escaping (_ response: KSResponse<[StoryModel]>?, _ dict: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = String(format: "?page=%d", page)
            let strPostUrl = isAllStories ? kAPIGetAllStories :kAPIFollowUnfollowUser + "/\(id)/stories"
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "stories": dictComments["stories"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[StoryModel]>(JSON: dictMapper)
                        handler(ksResponse, dictComments)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    func searchStories(page: Int, strSearch: String, withHandler handler: @escaping (_ response: KSResponse<[StoryModel]>?, _ dict: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = String(format: "&page=%d", page)
            let strPostUrl = "search?keyword=\(strSearch)" //kAPIGetAllStories + "?search=\(strSearch)"
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        
                        let dictMapper = ["statusCode": statusCode, "stories": dictComments["stories"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[StoryModel]>(JSON: dictMapper)
                        handler(ksResponse, dictComments)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }
    
    //
    //MARK:- Search home screen
    //
    func searchHomeStories(page: Int, strSearch: String, withHandler handler: @escaping (_ responseMembers: KSResponse<[UserModel]>?, _ response: KSResponse<[StoryModel]>?, _ dict: Dictionary<String, Any>) -> Void) {
        checkNetworkConnection()
        DispatchQueue.global().async {
            let strRequest = String(format: "&page=%d", page)
            let strPostUrl = "search?keyword=\(strSearch)" //kAPIGetAllStories + "?search=\(strSearch)"
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: strRequest, GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        
                        let dictMapper1 = ["statusCode": statusCode, "user": dictComments["members"] ?? ""] as [String : Any]
                        let ksResponse1 = KSResponse<[UserModel]>(JSON: dictMapper1)
                        
                        
                        let dictMapper = ["statusCode": statusCode, "stories": dictComments["stories"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[StoryModel]>(JSON: dictMapper)
                        handler(ksResponse1, ksResponse, dictComments)
                    }
                } else {
                    self.validateResponseData(response: dictResponse)
                }
            }
        }
    }

    
    // MARK: - Validate service response
    func validateResponseData(response: [String: AnyObject]) {
        if let dataVal = response["data"] {
            if Utility.sharedInstance.isStrEmpty(str: String.init(format: "%@", dataVal as! CVarArg)) == false {
                //
                // error message received in data
                //
                if dataVal.count > 0 {
                    if let descMsg = dataVal["error"] {
                        
                        DispatchQueue.main.async {
                            Utility.sharedInstance.showToast(strMsg: descMsg as! String)
                            kAppDelegate.hideLoadingIndicator()
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Utility.sharedInstance.showToast(strMsg: "Response Code: \(response["statusCode"] as! Int)")
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            else {
                //
                // No data received
                //
                DispatchQueue.main.async {
                    Utility.sharedInstance.showToast(strMsg: "Response Code: \(response["statusCode"] as! Int)")
                    kAppDelegate.hideLoadingIndicator()
                }
            }
        }
    }
    
    func checkNetworkConnection() {
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
    }
}
