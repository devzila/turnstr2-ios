//
//  WebServices.swift
//  ConetBook
//
//  Created by softobiz on 5/23/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

var isDevelopmentMode: Bool {
    
    guard let enable = Bundle.main.infoDictionary?["Development Mode"] as? Bool else { return true}
    return enable
}

class WebServices: NSObject {
    
    static let sharedInstance: WebServices = {
        let instance = WebServices()
        
        return instance
    }()
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [:]
    }
    
    //MARK:- ------ POST DATA TO SERVER -------
    func PostDataToserver(JSONString:String, PostURL:String, parType: String) -> Dictionary<String,AnyObject>{
        
        let request = NSMutableURLRequest(url: URL.init(string: kBaseURL.appending(PostURL))!)
        
        print("\(request.url! as URL)")
        
        if parType == kAPIDELETEStory {
            request.httpMethod = "DELETE"
        }
        else{
            request.httpMethod = "POST"
        }
        
        request.httpBody = JSONString .data(using: String.Encoding.utf8)
        
        
        request.timeoutInterval = 60.0
        request .setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if Singleton.sharedInstance.strUserSessionId != "" {
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth-token")
        }
        
        
        let semaphore = DispatchSemaphore(value: 0)
        var ResponseData: NSData = NSData()
        var statusCode: Int = 403
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {  // check for fundamental networking error
                print("error=\(error)")
                DispatchQueue.main.async {
                    Utility.sharedInstance.showAlert(title: "Error", forMsg: "Server Error")
                    kAppDelegate.hideLoadingIndicator()
                    //Loader.sharedInstance.stop()
                    return
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {// check for http errors
                
                statusCode = httpStatus.statusCode
                print(statusCode)
                
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
            }
            
            ResponseData = data! as NSData
            semaphore.signal()
        }
        task.resume()
        
        semaphore.wait()
        
        let reply = String(data: ResponseData as Data, encoding: String.Encoding.utf8)
        
        
        var json:Dictionary = [String: AnyObject]()
        
        
        do {
            json = try JSONSerialization.jsonObject(with: ResponseData as Data, options: []) as! [String: AnyObject]
            //print(json)
            
        } catch let error as NSError {
            print(reply!)
            print("Failed to load: \(error.localizedDescription)")
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
            }
        }
        
        var jsonResponse:Dictionary = [String: AnyObject]()
        
        jsonResponse = [
            "data" : json as AnyObject,
            "statusCode" : statusCode as AnyObject
        ]
        return jsonResponse
        
    }
    
    //MARK:- Post Methods FormData
    
    func PostRequestWith(PostURL:String, dictData: Dictionary<String, Any>?, method: String = "POST") -> Dictionary<String,AnyObject> {
        
        print(kBaseURL)
        
        
        let boundaryConstant  = "----------V2y2HFg03eptjbaKO0j1"
        
        let requestUrl = NSURL(string:kBaseURL.appending(PostURL))
        
        let request = NSMutableURLRequest()
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies=false
        request.timeoutInterval = 60.0
        request.httpMethod = method
        
        let contentType = "multipart/form-data; boundary=\(boundaryConstant)"
        
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if Singleton.sharedInstance.strUserSessionId != "" {
            print(Singleton.sharedInstance.strUserSessionId)
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth-token")
        }
        
        
        let body = NSMutableData()
        
        
        
        if dictData != nil {
            
            for (key, value) in dictData! {
                
                // parameters
                body.append("--\(boundaryConstant)\r\n" .data(using: String.Encoding.utf8)! )
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" .data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n" .data(using: String.Encoding.utf8)!)
            }
            
        }
        body.append("--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody  = body as Data
        // let postLength = "\(body.length)"
        // request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.url = requestUrl as URL?
        
        let semaphore = DispatchSemaphore(value: 0)
        var ResponseData: NSData = NSData()
        var statusCode: Int = 403
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {  // check for fundamental networking error
                print("error=\(error)")
                DispatchQueue.main.async {
                    Utility.sharedInstance.showAlert(title: "Error", forMsg: "Server Error")
                    kAppDelegate.hideLoadingIndicator()
                    //Loader.sharedInstance.stop()
                    return
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {// check for http errors
                
                statusCode = httpStatus.statusCode
                print(statusCode)
                
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
            }
            
            ResponseData = data! as NSData
            semaphore.signal()
        }
        task.resume()
        
        semaphore.wait()
        
        let reply = String(data: ResponseData as Data, encoding: String.Encoding.utf8)
        
        
        var json:Dictionary = [String: AnyObject]()
        
        
        do {
            json = try JSONSerialization.jsonObject(with: ResponseData as Data, options: []) as! [String: AnyObject]
            //print(json)
            
        } catch let error as NSError {
            print(reply!)
            print("Failed to load: \(error.localizedDescription)")
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
            }
        }
        
        var jsonResponse:Dictionary = [String: AnyObject]()
        
        jsonResponse = [
            "data" : json as AnyObject,
            "statusCode" : statusCode as AnyObject
        ]
        return jsonResponse
    }
    
    //MARK:- ------ GET DATA FROM SERVER WITH GET METHOD -------
    
    func GetMethodServerData(strRequest:String, GetURL:String, parType: String) -> Dictionary<String,AnyObject>{
        
        print(Singleton.sharedInstance.strUserSessionId)
        print(Singleton.sharedInstance.strUserID)
        
        // Send HTTP GET Request
        // Define server side script URL
        let scriptUrl = String(format: "%@%@", kBaseURL, GetURL)
        
        // Add one parameter
        let format1 = "%@"
        let function1 = String(format: format1, strRequest) // "1 !=2"
        
        
        var urlWithParams = scriptUrl + function1
        urlWithParams = urlWithParams.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        print(urlWithParams)
        
        // Create NSURL Ibject
        let myUrl = NSURL(string: urlWithParams);
        
        
        // Create URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        if Singleton.sharedInstance.strUserSessionId != "" {
            request.setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth-token")
        }
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // If needed you could add Authorization header value
        // Add Basic Authorization
        
        
        /*let token = DataModel.sharedInstance.strToken
         let bearer = DataModel.sharedInstance.strBearer
         
         let loginString = NSString(format: "%@ %@", bearer!, token!)
         
         request.setValue(loginString as String, forHTTPHeaderField: "Authorization")*/
        let semaphore = DispatchSemaphore(value: 0)
        var ResponseData: NSData = NSData()
        var statusCode: Int = 403
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            guard error == nil && data != nil else {      // check for fundamental networking error
                print("error=\(error)")
                DispatchQueue.main.async {
                    Utility.sharedInstance.showAlert(title: "Error", forMsg: "Server Error")
                    kAppDelegate.hideLoadingIndicator()
                    //Loader.sharedInstance.stop()
                    return
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {// check for http errors
                
                statusCode = httpStatus.statusCode
                print(statusCode)
                
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
            }
            
            ResponseData = data! as NSData
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        
        let reply = String(data: ResponseData as Data, encoding: String.Encoding.utf8)
        //print(reply)
        
        var json:Dictionary = [String: AnyObject]()
        
        do {
            json = try JSONSerialization.jsonObject(with: ResponseData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
            
            //print(json)
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
            }
        }
        
        
        var jsonResponse:Dictionary = [String: AnyObject]()
        
        jsonResponse = [
            "data" : json as AnyObject,
            "statusCode" : statusCode as AnyObject
        ]
        return jsonResponse
        
    }
    
    //Upload Media
    func uploadMedia(PostURL:String, strData: Dictionary<String, String>, parType: String, arrImages:Array<UIImage>) -> Dictionary<String,AnyObject> {
        
        print(kBaseURL)
        
        
        let boundaryConstant  = "----------V2y2HFg03eptjbaKO0j1"
        
        let requestUrl = NSURL(string:kBaseURL.appending(PostURL))
        print(requestUrl!)
        let request = NSMutableURLRequest()
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies=false
        request.timeoutInterval = 60.0
        request.httpMethod = "POST"
        
        let contentType = "multipart/form-data; boundary=\(boundaryConstant)"
        
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if Singleton.sharedInstance.strUserSessionId != "" {
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "Authorization")
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth-token")
        }
        print(Singleton.sharedInstance.strUserSessionId)
        
        let body = NSMutableData()
        
        if strData["action"] == kAPIUpdateProfile {
            
            request.httpMethod = "PUT"
            
            var j = 1
            
            for image in arrImages {
                let contentType: String = "image/jpeg"
                //image begin
                body.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                
                body.append("Content-Disposition: form-data; name=\"user[avatar_face\(j as Int)]\"; filename=\"user[avatar_face\(j as Int)]\"\r\n".data(using: String.Encoding.utf8)!)
                
                
                body.append("Content-Type: \(contentType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(UIImageJPEGRepresentation(image , 0.3)!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                // image end
                
                j = j+1
            }
            
        }
        else if strData["action"] == kAPIPOSTStories {
            
            request.httpMethod = "POST"
            
            var j = 1
            
            for image in arrImages {
                let contentType: String = "image/jpeg"
                //image begin
                body.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                
                body.append("Content-Disposition: form-data; name=\"story[face\(j as Int)_media]\"; filename=\"user[avatar_face\(j as Int)]\"\r\n".data(using: String.Encoding.utf8)!)
                
                
                body.append("Content-Type: \(contentType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(UIImageJPEGRepresentation(image , 0.3)!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                // image end
                
                j = j+1
            }
            
        }
            
        else if strData["action"] == kAPIUserPhotoUpload {
            request.httpMethod = "POST"
            
            var j = 1
            
            for image in arrImages {
                let contentType: String = "image/jpeg"
                //image begin
                body.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                
                body.append("Content-Disposition: form-data; name=\"photo[image]\"; filename=\"photo\"\r\n".data(using: String.Encoding.utf8)!)
                
                
                body.append("Content-Type: \(contentType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(UIImageJPEGRepresentation(image , 0.3)!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                // image end
                
                j = j+1
            }
        }
            
        else if strData["action"] == kAPIMyStoryUpload {
            request.httpMethod = "POST"
            
            var j = 1
            
            for image in arrImages {
                let contentType: String = "image/jpeg"
                //image begin
                body.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                
                body.append("Content-Disposition: form-data; name=\"user_story[medias_attributes][][media]\"; filename=\"photo\"\r\n".data(using: String.Encoding.utf8)!)
                
                
                body.append("Content-Type: \(contentType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(UIImageJPEGRepresentation(image , 0.3)!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                // image end
                
                j = j+1
            }
        }
        
        for (key, value) in strData {
            
            if key == "action" {
                continue
            }
            
            print("\(key) : \(value)")
            // parameters
            body.append("--\(boundaryConstant)\r\n" .data(using: String.Encoding.utf8)! )
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" .data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n" .data(using: String.Encoding.utf8)!)
            
        }
        
        
        body.append("--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody  = body as Data
        // let postLength = "\(body.length)"
        // request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.url = requestUrl as URL?
        
        let semaphore = DispatchSemaphore(value: 0)
        var ResponseData: NSData = NSData()
        var statusCode: Int = 403
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            guard error == nil && data != nil else {  // check for fundamental networking error
                print("error=\(error)")
                DispatchQueue.main.async {
                    kAppDelegate.hideLoadingIndicator()
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {// check for http errors
                
                statusCode = httpStatus.statusCode
                print(statusCode)
                
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
            }
            
            let httpStatus = response as? HTTPURLResponse
            print(httpStatus?.allHeaderFields ?? "Error defaults")
            
            
            
            ResponseData = data! as NSData
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        let reply = String(data: ResponseData as Data, encoding: String.Encoding.utf8)
        //print(strData)
        print(reply)
        
        var json:Dictionary = [String: AnyObject]()
        
        do {
            json = try JSONSerialization.jsonObject(with: ResponseData as Data, options: []) as! [String: AnyObject]
            //print(json)
            
        } catch let error as NSError {
            
            print("Failed to load: \(error.localizedDescription)")
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
            }
            
        }
        
        var jsonResponse:Dictionary = [String: AnyObject]()
        
        jsonResponse = [
            "data" : json as AnyObject,
            "statusCode" : statusCode as AnyObject
        ]
        return jsonResponse
    }
    
    //Upload Media
    func putPostMultipartDataToServer(PutPostURL:String, type:String, strData: Dictionary<String, String>, parType: String) -> Dictionary<String,AnyObject> {
        
        print(kBaseURL)
        
        
        let boundaryConstant  = "----------V2y2HFg03eptjbaKO0j1"
        
        let requestUrl = NSURL(string:kBaseURL.appending(PutPostURL))
        print(requestUrl!)
        let request = NSMutableURLRequest()
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies=false
        request.timeoutInterval = 60.0
        request.httpMethod = type
        
        let contentType = "multipart/form-data; boundary=\(boundaryConstant)"
        
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if Singleton.sharedInstance.strUserSessionId != "" {
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "Authorization")
            //request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth_token")
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth-token")
        }
        print(Singleton.sharedInstance.strUserSessionId)
        
        let body = NSMutableData()
        
        for (key, value) in strData {
            
            if key == "action" {
                continue
            }
            
            print("\(key) : \(value)")
            // parameters
            body.append("--\(boundaryConstant)\r\n" .data(using: String.Encoding.utf8)! )
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" .data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n" .data(using: String.Encoding.utf8)!)
            
        }
        
        
        body.append("--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody  = body as Data
        // let postLength = "\(body.length)"
        // request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.url = requestUrl as URL?
        
        let semaphore = DispatchSemaphore(value: 0)
        var ResponseData: NSData = NSData()
        var statusCode: Int = 403
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            guard error == nil && data != nil else {  // check for fundamental networking error
                print("error=\(error)")
                DispatchQueue.main.async {
                    kAppDelegate.hideLoadingIndicator()
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {// check for http errors
                
                statusCode = httpStatus.statusCode
                print(statusCode)
                
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
            }
            
            let httpStatus = response as? HTTPURLResponse
            print(httpStatus?.allHeaderFields ?? "Error defaults")
            
            
            
            ResponseData = data! as NSData
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        let reply = String(data: ResponseData as Data, encoding: String.Encoding.utf8)
        //print(strData)
        print(reply)
        
        var json:Dictionary = [String: AnyObject]()
        
        do {
            json = try JSONSerialization.jsonObject(with: ResponseData as Data, options: []) as! [String: AnyObject]
            //print(json)
            
        } catch let error as NSError {
            
            print("Failed to load: \(error.localizedDescription)")
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
            }
            
        }
        
        var jsonResponse:Dictionary = [String: AnyObject]()
        
        jsonResponse = [
            "data" : json as AnyObject,
            "statusCode" : statusCode as AnyObject
        ]
        return jsonResponse
    }
    
    
    func putDataToserver(JSONString:String, PutURL:String, parType: String) -> Dictionary<String,AnyObject>{
        
        
        
        let request = NSMutableURLRequest(url: NSURL.init(string: kBaseURL.appending(PutURL)) as! URL)
        
        print("\(request.url! as URL)")
        
        
        request.httpMethod = "PUT"
        
        request.httpBody = JSONString .data(using: String.Encoding.utf8)
        
        
        request.timeoutInterval = 60.0
        request .setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if Singleton.sharedInstance.strUserSessionId != "" {
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth-token")
        }
        
        
        let semaphore = DispatchSemaphore(value: 0)
        var ResponseData: NSData = NSData()
        var statusCode: Int = 403
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {  // check for fundamental networking error
                print("error=\(error)")
                DispatchQueue.main.async {
                    Utility.sharedInstance.showAlert(title: "Error", forMsg: "Server Error")
                    kAppDelegate.hideLoadingIndicator()
                    //Loader.sharedInstance.stop()
                    return
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {// check for http errors
                
                statusCode = httpStatus.statusCode
                print(statusCode)
                
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
            }
            
            ResponseData = data! as NSData
            semaphore.signal()
        }
        task.resume()
        
        semaphore.wait()
        
        let reply = String(data: ResponseData as Data, encoding: String.Encoding.utf8)
        
        
        var json:Dictionary = [String: AnyObject]()
        
        
        do {
            json = try JSONSerialization.jsonObject(with: ResponseData as Data, options: []) as! [String: AnyObject]
            //print(json)
            
        } catch let error as NSError {
            print(reply!)
            print("Failed to load: \(error.localizedDescription)")
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
            }
        }
        
        var jsonResponse:Dictionary = [String: AnyObject]()
        
        jsonResponse = [
            "data" : json as AnyObject,
            "statusCode" : statusCode as AnyObject
        ]
        return jsonResponse
        
    }
    
    //MARK:- ---------------------------------------------------------------
    //MARK:---------------------- New Story creation -----------------------
    //MARK:-----------------------------------------------------------------
    
    
    func CreateNewStory(PostURL:String, strData: Dictionary<String, String>, arrImages: [NewStoryMedia]) -> Dictionary<String,AnyObject> {
        
        print(kBaseURL)
        
        
        let boundaryConstant  = "----------V2y2HFg03eptjbaKO0j1"
        
        let requestUrl = NSURL(string:kBaseURL.appending(PostURL))
        print(requestUrl!)
        let request = NSMutableURLRequest()
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies=false
        request.timeoutInterval = 60.0
        request.httpMethod = "POST"
        
        let contentType = "multipart/form-data; boundary=\(boundaryConstant)"
        
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if Singleton.sharedInstance.strUserSessionId != "" {
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "Authorization")
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth-token")
        }
        print(Singleton.sharedInstance.strUserSessionId)
        
        let body = NSMutableData()
        
        var j = 1
        var k = 1
        
        
        for dict in arrImages {
            
            let story = dict
            
            let contentType: String = "image/jpeg"
            
            
            if story.type == .image {
                
                let img = story.image
                
                if let image = UIImageJPEGRepresentation(img!, 0.3) {
                    
                    //image begin
                    body.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                    
                    if PostURL == kAPIMyStoryUpload {
                        let kdeposition = "Content-Disposition: form-data; name=\"user_story[media]\"; filename=\"face\(j as Int).jpeg\"\r\n"
                        
                        body.append(kdeposition.data(using: String.Encoding.utf8)!)
                        
                        
                    } else {
                        let kdeposition = "Content-Disposition: form-data; name=\"story[face\(j as Int)_media]\"; filename=\"face\(j as Int).jpeg\"\r\n"
                        
                        body.append(kdeposition.data(using: String.Encoding.utf8)!)
                        
                    }
                    
                    body.append("Content-Type: \(contentType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                    
                    body.append(image)
                    
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                    // image end
                    
                    j = j+1
                } else{
                    print("image not attached")
                }
                
            }
            else{
                
                let urlVideo = story.url
                
                do {
                    
                    let tempData = try Data.init(contentsOf: urlVideo!)
                    
                    //video begin
                    body.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                    
                    if PostURL == kAPIMyStoryUpload {
                        let kdeposition = "Content-Disposition: form-data; name=\"user_story[media]\"; filename=\"face\(j as Int)_video.mp4\"\r\n"
                        
                        body.append(kdeposition.data(using: String.Encoding.utf8)!)
                        
                        
                    } else {
                        let kdeposition = "Content-Disposition: form-data; name=\"story[face\(j as Int)_media]\"; filename=\"face\(j as Int)_video.mp4\"\r\n"
                        
                        body.append(kdeposition.data(using: String.Encoding.utf8)!)
                        
                    }
                    
                    body.append("Content-Type: video/mp4\r\n\r\n".data(using: String.Encoding.utf8)!)
                    
                    body.append(tempData)
                    
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                    // video end
                    
                    //
                    //thumb begin
                    //
                    let img = story.image
                    
                    if let image = UIImageJPEGRepresentation(img!, 0.3) {
                        
                        body.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                        
                        let kdepositionthumb = "Content-Disposition: form-data; name=\"story[face\(j as Int)_video_thumb]\"; filename=\"face_thumb\(j as Int).jpeg\"\r\n"
                        
                        body.append(kdepositionthumb.data(using: String.Encoding.utf8)!)
                        
                        body.append("Content-Type: \(contentType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                        
                        body.append(image)
                        
                        body.append("\r\n".data(using: String.Encoding.utf8)!)
                    }
                    
                    //
                    // thumb end
                    //
                    
                    j = j+1
                    
                    
                } catch let error as Error {
                    print(error.localizedDescription)
                }
                
            }
            
            
        }
        
        for (key, value) in strData {
            
            if key == "action" {
                continue
            }
            
            print("\(key) : \(value)")
            // parameters
            body.append("--\(boundaryConstant)\r\n" .data(using: String.Encoding.utf8)! )
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" .data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n" .data(using: String.Encoding.utf8)!)
            
        }
        
        
        body.append("--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody  = body as Data
        // let postLength = "\(body.length)"
        // request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.url = requestUrl as URL?
        
        let semaphore = DispatchSemaphore(value: 0)
        var ResponseData: NSData = NSData()
        var statusCode: Int = 403
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            guard error == nil && data != nil else {  // check for fundamental networking error
                print("error=\(error)")
                DispatchQueue.main.async {
                    kAppDelegate.hideLoadingIndicator()
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {// check for http errors
                
                statusCode = httpStatus.statusCode
                print(statusCode)
                
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
            }
            
            let httpStatus = response as? HTTPURLResponse
            print(httpStatus?.allHeaderFields ?? "Error defaults")
            
            
            
            ResponseData = data! as NSData
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        let reply = String(data: ResponseData as Data, encoding: String.Encoding.utf8)
        //print(strData)
        print(reply)
        
        var json:Dictionary = [String: AnyObject]()
        
        do {
            json = try JSONSerialization.jsonObject(with: ResponseData as Data, options: []) as! [String: AnyObject]
            //print(json)
            
        } catch let error as NSError {
            
            print("Failed to load: \(error.localizedDescription)")
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
            }
            
        }
        
        var jsonResponse:Dictionary = [String: AnyObject]()
        
        jsonResponse = [
            "data" : json as AnyObject,
            "statusCode" : statusCode as AnyObject
        ]
        
        
        return jsonResponse
    }
}
