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
