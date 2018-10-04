//
//  button.swift
//  BoardingPass
//
//  Created by softobiz on 9/20/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

@IBDesignable class button: UIButton {

    let borderBottom = CALayer()
    let borderTop = CALayer()
    let borderRight = CALayer()
    
    @IBInspectable var borderColor: UIColor = UIColor.clear  {
        didSet {
            layer.borderColor = borderColor.cgColor
            borderTop.borderColor = borderColor.cgColor
            borderBottom.borderColor = borderColor.cgColor
            borderRight.borderColor  = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            if borderWidth > 0 {
                layer.borderWidth = borderWidth
            }
            
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
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
    
    @IBInspectable var rightBorder: CGFloat = 0 {
        didSet {
            if rightBorder > 0 {
                borderRight.frame = CGRect(x: frame.size.width - rightBorder, y: 0, width:  rightBorder, height: frame.size.height)
                borderRight.borderWidth = rightBorder
                layer.addSublayer(borderRight)
            }
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
