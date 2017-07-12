//
//  CustomAlertView.swift
//  SwifPro
//
//  Created by Ankit Saini on 4/6/16.
//  Copyright © 2016 Mr_X. All rights reserved.
//

import UIKit

protocol CustomAlertViewDelegate: class {
    func customAlertViewButtonTouchUpInside(alertView: CustomAlertView, buttonIndex: Int)
}

enum buttonDirection {
    case buttonDirectionHorizontal
    case buttonDirectionVertical
}

enum buttonStyle {
    case buttonStyleDefault
    case buttonStyleInnerView
}

enum onTouchDismiss {
    case touchDismissNO
    case touchDismissYES
}

class CustomAlertView: UIView {
    
    //MARK:- Properties
    var alertWidth: CGFloat = 300
    
    var buttonWIDTH: CGFloat = 0
    
    var buttonHeight: CGFloat = 50
    var buttonsDividerHeight: CGFloat = 1
    var cornerRadius: CGFloat = 7
    var buttonMargin: Int = 10
    
    var useMotionEffects: Bool = true
    var motionEffectExtent: Int = 10
    
    private var alertView: UIView!
    var containerView: UIView!
    
    var buttonTitles: [String]? = ["Close"]
    var buttonIcons: [String]?
    var showCloseButton:Bool?
    
    var buttonColor: UIColor?
    var buttonColorHighlighted: UIColor?
    var buttonBGColor: [String]? = []
    var alertBGColor: [String]? = ["#EFEEEC", "#EFEEEC", "#EFEEEC"]
    var showButtonRadius: Bool = false
    var alertButtonStyle = buttonStyle.buttonStyleDefault
    var alertDismiss = onTouchDismiss.touchDismissNO
    
    var btnDismiss: UIButton?
    
    
    var alertButtonDirection = buttonDirection.buttonDirectionHorizontal
    
    
    weak var delegate: CustomAlertViewDelegate?
    var onButtonTouchUpInside: ((_ alertView: CustomAlertView, _ buttonIndex: Int) -> Void)?
    
    //MARK:- Initialisation
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        setObservers()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setObservers()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setObservers()
        
    }
    
    //MARK:- Create the dialog view and animate its opening
    internal func show() {
        if showCloseButton == false {
            buttonTitles = []
        }
        addDismissTouch()
        show(completion: nil)
    }
    
    internal func show(completion: ((Bool) -> Void)?) {
        alertView = createAlertView()
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.addSubview(alertView)
        
        // Attach to the top most window
        switch (UIApplication.shared.statusBarOrientation) {
        case UIInterfaceOrientation.landscapeLeft:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 270 / 180))
            
        case UIInterfaceOrientation.landscapeRight:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 90 / 180))
            
        case UIInterfaceOrientation.portraitUpsideDown:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 180 / 180))
            
        default:
            break
        }
        
        self.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        //UIApplication.sharedApplication().windows.first?.addSubview(self)
        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.alertView.layer.opacity = 1
            self.alertView.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }, completion: completion)
    }
    
    //MARK:- Close the alertView, remove views
    
    internal func addDismissTouch() -> Void {
        if alertDismiss == onTouchDismiss.touchDismissYES {
            if btnDismiss == nil {
                btnDismiss = UIButton.init(frame: self.bounds)
                btnDismiss?.addTarget(self, action: #selector(dismissClicked(sender:)), for: .touchUpInside)
                self.insertSubview(btnDismiss!, at: 0)
            }
            
        }
    }
    
    func dismissClicked(sender: UIButton) -> Void {
        close()
    }
    
    internal func close() {
        close(completion: nil)
    }
    
    internal func close(completion: ((Bool) -> Void)?) {
        let currentTransform = alertView.layer.transform
        
        let startRotation = (alertView.value(forKeyPath: "layer.transform.rotation.z")! as AnyObject).floatValue
        let rotation = CATransform3DMakeRotation(CGFloat(-startRotation!) + CGFloat(M_PI * 270 / 180), 0, 0, 0)
        
        alertView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        alertView.layer.opacity = 1
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.alertView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
            self.alertView.layer.opacity = 0
            }, completion: { (finished: Bool) in
                for view in self.subviews as [UIView] {
                    view.removeFromSuperview()
                }
                
                self.removeFromSuperview()
                completion?(finished)
        })
    }
    
    // Enables or disables the specified button
    // Should be used after the alert view is displayed
    internal func setButtonEnabled(enabled: Bool, buttonName: String) {
        for subview in alertView.subviews as [UIView] {
            if subview is UIButton {
                let button = subview as! UIButton
                
                if button.currentTitle == buttonName {
                    button.isEnabled = enabled
                    break
                }
            }
        }
    }
    
    // Observe orientation and keyboard changes
    private func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomAlertView.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomAlertView.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Create the containerView
    private func createAlertView() -> UIView {
        if containerView == nil {
            //containerView = UIView(frame: CGRectMake(0, 0, 300, 150))
            containerView = UIView(frame: CGRect.init(x: 0, y: 0, width: alertWidth, height: 1))
        }
        
        let screenSize = self.calculateScreenSize()
        let dialogSize = self.calculateDialogSize()
        
        let view = UIView(frame: CGRect.init(x: (screenSize.width - dialogSize.width) / 2, y: (screenSize.height - dialogSize.height) / 2, width: dialogSize.width, height: dialogSize.height))
        
        // Style the alertView to match the iOS7 UIAlertView
        view.layer.insertSublayer(generateGradient(bounds: view.bounds), at: 0)
        view.layer.cornerRadius = cornerRadius
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha:1).cgColor
        
        view.layer.shadowRadius = cornerRadius + 5
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.init(width: 0 - (cornerRadius + 5) / 2, height: 0 - (cornerRadius + 5) / 2)
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        
        view.layer.opacity = 0.5
        view.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.masksToBounds = true
        
        // Apply motion effects
        if useMotionEffects {
            applyMotionEffects(view: view)
        }
        
        // Add subviews
        view.addSubview(generateButtonsDivider(bounds: view.bounds))
        view.addSubview(containerView)
        self.addButtonsToView(container: view)
        
        return view
    }
    
    // Generate the view for the buttons divider
    private func generateButtonsDivider(bounds: CGRect) -> UIView {
        
        switch alertButtonDirection {
        case .buttonDirectionHorizontal:
            let divider = UIView(frame: CGRect.init(x: 0, y: bounds.size.height - buttonHeight - buttonsDividerHeight, width: bounds.size.width, height: buttonsDividerHeight))
            
            divider.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
            
            return divider
            break
        default:
            break
        }
        
        return UIView()
    }
    
    // Generate the gradient layer of the alertView
    private func generateGradient(bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.cornerRadius = cornerRadius
        
        let arrColors: NSMutableArray = []
        
        for j in alertBGColor! {
            arrColors.add(UIColor.init(hexString:j).cgColor)
        }
        
        gradient.colors = arrColors as [AnyObject]
        //        gradient.colors = [
        //            UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha:1).CGColor,
        //            UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha:1).CGColor,
        //            UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha:1).CGColor
        //        ]
        
        return gradient
    }
    
    //MARK: Add the buttons to the containerView
    private func addButtonsToView(container: UIView) {
        if buttonTitles == nil || buttonTitles?.count == 0 {
            return
        }
        
        let buttonWidth = buttonWIDTH > 0 ? buttonWIDTH : container.bounds.size.width / CGFloat(buttonTitles!.count)
        
        //
        //create scroll view to add button in case button's height total is more than screen size
        //
        let scrScrollView: UIScrollView = UIScrollView.init()
        scrScrollView.frame = CGRect.init(x: 0, y: container.bounds.size.height - buttonHeight, width: container.frame.size.width, height: buttonHeight)
        
        var contentWidth:CGFloat = container.frame.size.width
        var contentHeight:CGFloat = buttonHeight
        
        //Define content size of scrollview
        switch alertButtonDirection {
        case .buttonDirectionVertical:
            //let total:CGFloat = (buttonHeight * CGFloat((buttonTitles?.count)!)) + (CGFloat(buttonMargin) * (CGFloat((buttonTitles?.count)!+1)))
            let scrollViewHeight = container.bounds.size.height - containerView.frame.size.height
            
            
            
            scrScrollView.frame = CGRect.init(x: 0, y: self.calculateDialogSize().height - scrollViewHeight, width: scrScrollView.frame.size.width, height: scrollViewHeight)
            //scrScrollView.backgroundColor = UIColor.redColor()
            break
        default:
            break
        }
        
        var startY:CGFloat = CGFloat(buttonMargin)
        
        
        for buttonIndex in 0...(buttonTitles!.count - 1) {
            //let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            let button = UIButton.init()
            
            switch alertButtonDirection {
            case .buttonDirectionHorizontal:
                
                let xCo = CGFloat(buttonIndex) * CGFloat(buttonWidth)
                
                if alertButtonStyle == buttonStyle.buttonStyleInnerView {
                    button.frame = CGRect.init(x: xCo+5, y: 5, width: buttonWidth-10, height: buttonHeight-10)
                }
                else {
                    button.frame = CGRect.init(x: xCo, y: 0, width: buttonWidth, height: buttonHeight)
                }
                
                contentWidth = buttonWidth * CGFloat((buttonTitles?.count)!) + buttonWidth/2 + 15.0
                break
            case .buttonDirectionVertical:
                
                button.frame = CGRect.init(x: 10, y: startY, width: container.bounds.size.width-20, height: buttonHeight)
                startY = startY + buttonHeight + CGFloat(buttonMargin)
                contentHeight = startY
                break
            }
            
            
            
            
            button.tag = buttonIndex
            button.addTarget(self, action: #selector(CustomAlertView.buttonTouchUpInside(sender:)), for: UIControlEvents.touchUpInside)
            
            let colorNormal = buttonColor != nil ? buttonColor : button.tintColor
            let colorHighlighted = buttonColorHighlighted != nil ? buttonColorHighlighted : colorNormal?.withAlphaComponent(0.5)
            
            button.setTitle(buttonTitles![buttonIndex], for: UIControlState.normal)
            button.setTitleColor(colorNormal, for: UIControlState.normal)
            button.setTitleColor(colorHighlighted, for: UIControlState.highlighted)
            button.setTitleColor(colorHighlighted, for: UIControlState.disabled)
            
            if showButtonRadius {
                button.layer.cornerRadius = cornerRadius
            }
            
            if (buttonBGColor?.count)!>0 {
                button.backgroundColor = buttonIndex >= (buttonBGColor?.count)! ? UIColor.clear : UIColor.init(hexString: buttonBGColor![buttonIndex])
            }
            
            if buttonIcons != nil {
                if (buttonIcons?.count)! > 0 {
                    if buttonIndex < (buttonIcons?.count)! {
                        button.setImage(UIImage(named:buttonIcons![buttonIndex] ), for: .normal)
                    }
                    button.contentHorizontalAlignment = .left
                    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
                }
            }
            //container.addSubview(button)
            scrScrollView.addSubview(button)
            container.addSubview(scrScrollView)
            
            // Show a divider between buttons
            if buttonIndex > 0  {
                switch alertButtonDirection {
                case .buttonDirectionHorizontal:
                    if alertButtonStyle == buttonStyle.buttonStyleDefault {
                        
                        let verticalLineView = UIView(frame: CGRect.init(x:  button.bounds.size.width * CGFloat(buttonIndex), y: 0, width: buttonsDividerHeight, height: buttonHeight))
                        //container.bounds.size.width / CGFloat(buttonTitles!.count) * CGFloat(buttonIndex)
                        verticalLineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
                        
                        scrScrollView.addSubview(verticalLineView)
                        //container.addSubview(verticalLineView)
                    }
                    
                    break
                default:
                    break
                }
                
            }
        }
        
        //Define content size of scrollview
        
        scrScrollView.contentSize = CGSize.init(width: contentWidth, height: contentHeight)
    }
    
    // Calculate the size of the dialog
    private func calculateDialogSize() -> CGSize {
        switch alertButtonDirection {
        case .buttonDirectionHorizontal:
            return CGSize.init(width:  containerView.frame.size.width, height: containerView.frame.size.height + buttonHeight + buttonsDividerHeight)
        case .buttonDirectionVertical:
            var height = (buttonHeight * CGFloat((buttonTitles?.count)!))+(CGFloat(((buttonTitles?.count)! - 1)) * CGFloat(buttonMargin))
            height = containerView.frame.size.height + height + CGFloat(buttonMargin*2)
            height = height>self.calculateScreenSize().height ? self.calculateScreenSize().height : height
            return CGSize.init(width: containerView.frame.size.width, height: height)
        }
        
    }
    
    // Calculate the size of the screen
    private func calculateScreenSize() -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        if orientationIsLandscape() {
            return CGSize.init(width: height, height: width)
        } else {
            return CGSize.init(width: width, height: height)
        }
    }
    
    // Add motion effects
    private func applyMotionEffects(view: UIView)  {
        let horizontalEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = -motionEffectExtent
        horizontalEffect.maximumRelativeValue = +motionEffectExtent
        
        let verticalEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = -motionEffectExtent
        verticalEffect.maximumRelativeValue = +motionEffectExtent
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalEffect, verticalEffect]
        
        view.addMotionEffect(motionEffectGroup)
    }
    
    // Whether the UI is in landscape mode
    private func orientationIsLandscape() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
    }
    
    // Call the delegates
    internal func buttonTouchUpInside(sender: UIButton!) {
        delegate?.customAlertViewButtonTouchUpInside(alertView: self, buttonIndex: sender.tag)
        onButtonTouchUpInside?(self, sender.tag)
    }
    
    // Handle device orientation changes
    internal func deviceOrientationDidChange(notification: NSNotification) {
        let interfaceOrientation = UIApplication.shared.statusBarOrientation
        let startRotation = (self.value(forKeyPath: "layer.transform.rotation.z")! as AnyObject).floatValue
        
        var rotation: CGAffineTransform
        
        switch (interfaceOrientation) {
        case UIInterfaceOrientation.landscapeLeft:
            rotation = CGAffineTransform(rotationAngle: CGFloat(-startRotation!) + CGFloat(M_PI * 270 / 180))
            break
            
        case UIInterfaceOrientation.landscapeRight:
            rotation = CGAffineTransform(rotationAngle: CGFloat(-startRotation!) + CGFloat(M_PI * 90 / 180))
            break
            
        case UIInterfaceOrientation.portraitUpsideDown:
            rotation = CGAffineTransform(rotationAngle: CGFloat(-startRotation!) + CGFloat(M_PI * 180 / 180))
            break
            
        default:
            rotation = CGAffineTransform(rotationAngle: CGFloat(-startRotation!) + 0)
            break
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.alertView.transform = rotation
            }, completion: nil)
        
        // Fix errors caused by being rotated one too many times
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(5)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            let endInterfaceOrientation = UIApplication.shared.statusBarOrientation
            if interfaceOrientation != endInterfaceOrientation {
                // TODO: user moved phone again before than animation ended: rotation animation can introduce errors here
            }
        }
        
    }
    
    // Handle keyboard show changes
    internal func keyboardWillShow(notification: NSNotification) {
        let screenSize = self.calculateScreenSize()
        let dialogSize = self.calculateDialogSize()
        
        var keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        
        if orientationIsLandscape() {
            keyboardSize = CGSize(width: keyboardSize.height, height: keyboardSize.width)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.alertView.frame = CGRect.init(x: (screenSize.width - dialogSize.width) / 2, y: (screenSize.height - keyboardSize.height - dialogSize.height) / 2, width: dialogSize.width, height: dialogSize.height)
            }, completion: nil)
    }
    
    // Handle keyboard hide changes
    internal func keyboardWillHide(notification: NSNotification) {
        let screenSize = self.calculateScreenSize()
        let dialogSize = self.calculateDialogSize()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.alertView.frame = CGRect.init(x:  (screenSize.width - dialogSize.width) / 2, y: (screenSize.height - dialogSize.height) / 2, width: dialogSize.width, height: dialogSize.height)
                
            }, completion: nil)
    }
    
    
    //MARK:- Deallocate
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
}


extension UIColor {
    convenience init(hexString:String) {
        let hexString:NSString = hexString.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}


