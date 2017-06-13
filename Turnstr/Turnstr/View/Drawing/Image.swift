//
//  Image.swift
//  ConetBook
//
//  Created by softobiz on 8/4/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

@IBDesignable class Image: UIImageView {
    
    let borderBottom = CALayer()
    let borderTop = CALayer()
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            borderTop.borderColor = borderColor.cgColor
            borderBottom.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var bottomBorder: CGFloat = 0 {
        didSet {
            if bottomBorder > 0 {
                
                borderBottom.frame = CGRect(x: 0, y: frame.size.height - bottomBorder, width:  frame.size.width, height: bottomBorder)
                
                borderBottom.borderWidth = bottomBorder
                layer.addSublayer(borderBottom)
            }
        }
    }
    
    @IBInspectable var TopBorder: CGFloat = 0 {
        didSet {
            if TopBorder > 0 {
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
