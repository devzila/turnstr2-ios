//
//  scroll.swift
//  BariatricPal
//
//  Created by softobiz on 1/13/17.
//  Copyright © 2017 Ankit_Saini. All rights reserved.
//

import UIKit

class scroll: UIScrollView {

    let borderBottom = CALayer()
    let borderTop = CALayer()
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            borderTop.borderColor = borderColor.cgColor
            borderBottom.borderColor = borderColor.cgColor
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
            if cornerRadius > 0 {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = true
            }
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
    
    @IBInspectable var contentHeight: CGFloat = 0 {
        didSet {
            if contentHeight > 0 {
                self.contentSize = CGSize.init(width: self.frame.width, height: contentHeight)
            }
        }
    }

}
