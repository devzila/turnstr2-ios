//
//  AllExtensions.swift
//  Turnstr
//
//  Created by Mr. X on 14/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import AVFoundation

extension URL {
    
    func getThumbnailOfURL() -> UIImage? {
        
        let asset = AVURLAsset.init(url: self)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            
            let uiImage = UIImage.init(cgImage: cgImage)
            
            return uiImage
            
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
        
    }
}

extension UIImageView {
    func getThumbnailOfURLWith(url: URL) {
        
        let asset = AVURLAsset.init(url: url)
        
        kBQ_getVideosThumb.async {
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            
            do {
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                
                let uiImage = UIImage.init(cgImage: cgImage)
                DispatchQueue.main.async(execute: {
                    self.image = uiImage
                })
                
                return
                
            } catch let error {
                print(error.localizedDescription)
                
            }
            DispatchQueue.main.async(execute: {
                self.image = nil
            })
        }
        
    }
}

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
}

extension CGFloat {
    func getDW(SP: CGFloat, S: CGFloat, F: CGFloat) -> CGFloat {
        
        if IS_IPHONE_6P {
            return SP
        }
        else if IS_IPHONE_6 {
            return S
        }
        else if IS_IPHONE_5 {
            return F
        }
        else{
            return F
        }
        
    }
}

extension UIImage {
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, completion:@escaping (_ data: Data?) ->()) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            completion(data)
        }
    }
    
    /// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
    public var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    func setMode(MODE: UIImageRenderingMode) -> UIImage {
        return self.withRenderingMode(MODE)
    }
}

extension UITableView {
    func scrollToBottom(){
        let nor = self.numberOfRows(inSection: 0)
        if nor > 0 {
            let indexPath = IndexPath(row: nor-1, section: 0)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
    
    func scrollTableToTop(){
        let nor = self.numberOfRows(inSection: 0)
        if nor > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
    }
    
}

//
//MARK:- String
//MARK:
extension String {
    
    func attributtedString(appendString: String, color1: UIColor, color2: UIColor, font1: UIFont, font2: UIFont, lineSpacing: CGFloat = 0, alignment: NSTextAlignment = .left) -> NSAttributedString {
        let strSubTitle = appendString
        let fullString = "\(self)\(strSubTitle)"
        
        let attString = NSMutableAttributedString.init(string: fullString)
        
        //Font
        attString.addAttribute(NSFontAttributeName, value: font1, range: NSMakeRange(0, (self.count)))
        attString.addAttribute(NSFontAttributeName, value:font2, range: NSMakeRange(fullString.count-strSubTitle.count, strSubTitle.count))
        
        //Color
        attString.addAttribute(NSForegroundColorAttributeName, value: color1, range: NSMakeRange(0, attString.length))
        attString.addAttribute(NSForegroundColorAttributeName, value: color2, range: NSMakeRange(attString.length - strSubTitle.count, strSubTitle.count))
        
        //Paragraph
        if lineSpacing > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = lineSpacing
            paragraphStyle.alignment = alignment
            attString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, (attString.length)))
            
        }
        
        return attString
    }
    
    
    func toDictionary() -> Dictionary<String, Any> {
        if let data = self.data(using: .utf8) {
            do {
                if let serverResponse = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: Any] {
                    return serverResponse
                }
            } catch {
                print(error.localizedDescription)
                return [:]
            }
        }
        return [:]
    }
    
    func intVal() -> Int {
        if self.isEmpty == true {
            return 0
        }
        return (self as NSString).integerValue
    }
    
    func UIntVal() -> UInt? {
        return UInt((self))
    }
    
    func floatVal() -> Float {
        return (self as NSString).floatValue
    }
    
    func doubleVal() -> Double {
        return (self as NSString).doubleValue
    }
}
