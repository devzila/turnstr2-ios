//
//  VCExtensions.swift
//  HungryForJobs
//
//  Created by Sierra 3 on 10/04/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func selectDeselect(_ sender: UIButton?) {
        if let superView = sender?.superview {
            for subView in superView.subviews {
                if let btn = subView as? UIButton {
                    btn.isSelected = (btn == sender)
                    btn.backgroundColor = btn.isSelected ? .white : .clear
                }
            }
        }
    }
    
    @IBAction func btnBackAction() {
        popVC()
    }
    
    func popVC() {
        if isModal {
            dismiss(animated: true, completion: nil)
        }
        else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    var isModal: Bool {
        
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                return false
            }
        }
        if self.presentingViewController != nil {
            return true
        }
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }

}
