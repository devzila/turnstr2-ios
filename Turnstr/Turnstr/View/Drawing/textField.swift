//
//  textField.swift
//  BoardingPass
//
//  Created by softobiz on 9/20/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

@IBDesignable class textField: UITextField {

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
            if bottomBorder > 0 && bottomBorderFULL == false {
                
                borderBottom.frame = CGRect(x: 0, y: frame.size.height - bottomBorder, width:  frame.size.width, height: bottomBorder)
                
                borderBottom.borderWidth = bottomBorder
                layer.addSublayer(borderBottom)
            }
        }
    }
    
    @IBInspectable var bottomBorderFULL: Bool = false {
        didSet {
            if bottomBorderFULL == true && bottomBorder > 0 {
                
                borderBottom.frame = CGRect(x: 0, y: frame.size.height - bottomBorder, width:  kWidth, height: bottomBorder)
                
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
    
    @IBInspectable var leftImage: String = "" {
        didSet {
            if leftImage != "" {
                leftViewMode = .always
                leftView = UIImageView.init(image: UIImage.init(named: leftImage))
            }
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            if leftPadding > 0 {
                let spacerView: UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: leftPadding, height: 10))
                leftViewMode = .always
                leftView = spacerView
            }
            
        }
    }
    
    @IBInspectable var rightImage: String = "" {
        didSet {
            rightViewMode = .always
            rightView = UIImageView.init(image: UIImage.init(named: rightImage))
        }
    }
    
    
    
    @IBInspectable var placeholderColor: UIColor = UIColor.black {
        didSet {
            attributedPlaceholder = NSAttributedString(string:" \(placeholder!)",
                attributes:[NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    

}
