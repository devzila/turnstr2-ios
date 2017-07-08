//
//  WebServices.swift
//  ConetBook
//
//  Created by softobiz on 5/23/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

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
    
    //MARK: ------ POST DATA TO SERVER -------
    func PostDataToserver(JSONString:String, PostURL:String, parType: String) -> Dictionary<String,AnyObject>{
        
        
        
        let request = NSMutableURLRequest(url: NSURL.init(string: kBaseURL.appending(PostURL)) as! URL)
        
        print("\(request.url! as URL)")
        
        
        request.httpMethod = "POST"
        
        request.httpBody = JSONString .data(using: String.Encoding.utf8)
        
        
        request.timeoutInterval = 60.0
        request .setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if Singleton.sharedInstance.strUserSessionId != "" {
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth_token")
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
    
    //MARK: ------ GET DATA FROM SERVER WITH GET METHOD -------
    func GetMethodServerData(strRequest:String, GetURL:String, parType: String) -> Dictionary<String,AnyObject>{
        
        print(kBaseURL)
        
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
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth_token")
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
        
        var requestUrl = NSURL(string:kBaseURL.appending(PostURL))
        
        let request = NSMutableURLRequest()
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies=false
        request.timeoutInterval = 60.0
        request.httpMethod = "POST"
        
        let contentType = "multipart/form-data; boundary=\(boundaryConstant)"
        
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if Singleton.sharedInstance.strUserSessionId != "" {
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "Authorization")
            request .setValue(Singleton.sharedInstance.strUserSessionId, forHTTPHeaderField: "auth_token")
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
        
        for (key, value) in strData {
            
            if key == "action" {
                continue
            }
            
            print("\(key) : \(value)")
            // parameters
            body.append("--\(boundaryConstant)\r\n" .data(using: String.Encoding.utf8)! )
            body.append("Content-Disposition: form-data; name=\"user[\(key)]\"\r\n\r\n" .data(using: String.Encoding.utf8)!)
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
