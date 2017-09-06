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
