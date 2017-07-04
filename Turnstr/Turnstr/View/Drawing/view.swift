//
//  view.swift
//  ConetBook
//
//  Created by softobiz on 8/11/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class view: UIView {
    
    let borderBottom = CALayer()
    let borderTop = CALayer()
    
    override func layoutSubviews() {
        self.setBorderFullWidth()
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            borderTop.borderColor = borderColor.cgColor
            borderBottom.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var bottomBorder: CGFloat = 0 {
        didSet {
            if bottomBorder > 0 && BorderFULL == false {
                
                borderBottom.frame = CGRect(x: 0, y: frame.size.height - bottomBorder, width:  frame.size.width, height: bottomBorder)
                
                borderBottom.borderWidth = bottomBorder
                layer.addSublayer(borderBottom)
            }
        }
    }
    
    @IBInspectable var BorderFULL: Bool = false {
        didSet {
            self.setBorderFullWidth()
        }
    }
    
    func setBorderFullWidth() -> Void {
        if BorderFULL == true && bottomBorder > 0 {
            
            borderBottom.frame = CGRect(x: 0, y: frame.size.height - bottomBorder, width:  kWidth, height: bottomBorder)
            
            borderBottom.borderWidth = bottomBorder
            layer.addSublayer(borderBottom)
        }
        
        if BorderFULL == true && TopBorder > 0 {
            
            borderTop.frame = CGRect(x: 0, y: 0, width:  kWidth, height: TopBorder)
            borderTop.borderWidth = TopBorder
            layer.addSublayer(borderTop)
        }
    }
    
    @IBInspectable var TopBorder: CGFloat = 0 {
        didSet {
            if TopBorder > 0 && BorderFULL == false {
                borderTop.frame = CGRect(x: 0, y: 0, width:  frame.size.width, height: TopBorder)
                borderTop.borderWidth = TopBorder
                layer.addSublayer(borderTop)
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
