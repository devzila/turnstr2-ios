//
//  NSObjectExtensions.swift
//  HungryForJobs
//
//  Created by Sierra 3 on 10/04/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RMMapper

extension NSObject {
    
    var screenWidth: CGFloat {
        return Screen.width.value
    }
    
    var screenHeight: CGFloat {
        return Screen.height.value
    }
    
    var isLoggedIn: Bool {
        guard let _ = UDKeys.user.fetch() else { return false }
        return true
    }
    
    var developmentMode: Bool {
        guard let enabled = Bundle.main.infoDictionary?["Development Mode"] as? Bool else {
            return false
        }
        return enabled
    }
    
    
    
    func openAlert(title: String?, message strMessage: String?, with options: String?..., didSelect:@escaping(_ index: Int?) -> Void){
        let alert = UIAlertController(title: title, message: strMessage, preferredStyle: .alert)
        for (i,option) in options.enumerated() {
            let action = UIAlertAction(title: option, style: .default, handler: { (action) in
                didSelect(i)
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: L10n.cancel.string, style: .cancel) { (action) in
        }
        alert.addAction(cancel)
        AppDelegate.shared?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func dismissAlert(title: String?, message strMessage: String?) {
        let alert = UIAlertController(title: title, message: strMessage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: L10n.dismiss.string, style: .cancel) { (action) in
            
        }
        alert.addAction(cancel)
        AppDelegate.shared?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func getJson(_ array:Array<Any>?) -> String {
        let paramsJSON = JSON(array ?? [])
        let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: .prettyPrinted)
        let removeString = paramsString?.replacingOccurrences(of: "\n", with: "")
        guard  let strToReturn = removeString else {
            return ""
        }
        return strToReturn
    }
}

extension UIView {
    func borderDesign(cornerRadius : CGFloat?, borderWidth : CGFloat? , borderColor : UIColor?) {
        self.layer.cornerRadius = cornerRadius ?? 0
        self.layer.borderWidth = borderWidth ?? 0
        self.layer.borderColor = borderColor?.cgColor
        self.clipsToBounds = true
    }
    
    func wobbleAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 0.05
        animation.repeatCount = Float(CGFloat.infinity)
        animation.autoreverses = true
        animation.fromValue = -(CGFloat.pi / 192)
        animation.toValue = (CGFloat.pi / 192)
        self.layer.add(animation, forKey: "transform.rotation")
    }
    
}


protocol StringType { var get: String { get } }

extension String: StringType { var get: String { return self } }

extension Optional where Wrapped: StringType {
    func unwrap() -> String {
        return self?.get ?? ""
    }
}
