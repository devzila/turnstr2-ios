//
//  MenuBar.swift
//  ConetBook
//
//  Created by softobiz on 6/6/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

class MenuBar: UIView {
    
    var btnBack: UIButton = UIButton()
    var btnRightMenu: UIButton = UIButton()
    var lblTitle: UILabel = UILabel()
    var uvBottomBorder: UIView = UIView()
    var imgBg: UIImageView = UIImageView()
    var imgLogoTitle:UIImageView = UIImageView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kNavBarHeight)
        //self.backgroundColor = UIColor.init(red: 73, green: 108, blue: 194)
        self.backgroundColor = kMenuBG
        self.addSubview(getBottomBorder(color: UIColor.gray))
        
    }
    
    init(frame: CGRect, logoTitle: Bool) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kNavBarHeightWithLogo))
        BackgroundIMage()
        self.addSubview(imgBg)
        self.layer.masksToBounds = true
        self.addSubview(LogoTitle())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func BackgroundIMage() -> Void {
        imgBg.frame = self.frame
        imgBg.image = #imageLiteral(resourceName: "bg_norm")
    }
    
    func LogoTitle() -> UIImageView {
        imgLogoTitle.frame = CGRect.init(x: kCenterW-34, y: self.frame.height-30, width: 68, height: 18)
        imgLogoTitle.image = #imageLiteral(resourceName: "logo_nav")
        imgLogoTitle.contentMode = .scaleAspectFit
        
        return imgLogoTitle
    }
    
    func ProfileIconButton() -> UIButton {
        btnRightMenu = Utility.sharedInstance.createButton(xCo: kWidth - 40, forY: self.frame.height-25, forW: 30, forH: 25, forText: "", textColor: UIColor.white, wifthFont: UIFont.systemFont(ofSize: 12), backColor: krgbClear)
        btnRightMenu.setImage(#imageLiteral(resourceName: "user_icon"), for: .normal)
        return btnRightMenu
    }
    func navTitle(title: String, inView: UIView) -> Void {
        lblTitle = UILabel.init(frame: CGRect.init(x: 50, y: 10, width: kWidth-100, height: kNavBarHeight-10))
        lblTitle.text = title
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.font = UIFont.init(name: kFontOpen3, size: kMenuTitleSize)
        inView.addSubview(lblTitle)
    }
    
    
    func backButonMenu() -> UIButton {
        btnBack = Utility.sharedInstance.createButton(xCo: 10, forY: 10, forW: 50, forH: kNavBarHeight-10, forText: "Back", textColor: UIColor.white, wifthFont: UIFont.systemFont(ofSize: 14), backColor: krgbClear)
        return btnBack
    }
    
    func backButonIcon() -> UIButton {
        btnBack = Utility.sharedInstance.createButton(xCo: 0, forY: 0, forW: 40, forH: kNavBarHeight, forText: "", textColor: UIColor.white, wifthFont: UIFont.systemFont(ofSize: 12), backColor: krgbClear)
        btnBack.setImage(UIImage(named: "back_arrow"), for: .normal)
        return btnBack
    }
    
    func RightButonIcon() -> UIButton {
        btnRightMenu = Utility.sharedInstance.createButton(xCo: kWidth - 45, forY: 0, forW: 40, forH: self.frame.height, forText: "", textColor: UIColor.white, wifthFont: UIFont.systemFont(ofSize: 12), backColor: krgbClear)
        btnRightMenu.setImage(#imageLiteral(resourceName: "user_icon"), for: .normal)
        btnRightMenu.backgroundColor = UIColor.red
        return btnRightMenu
    }
    
    func LeftMenuButonIcon() -> UIButton {
        btnBack = Utility.sharedInstance.createButton(xCo: 0, forY: 0, forW: 40, forH: kNavBarHeight, forText: "", textColor: UIColor.white, wifthFont: UIFont.systemFont(ofSize: 12), backColor:krgbClear)
        btnBack.setImage(UIImage(named: "toggle"), for: .normal)
        return btnBack
    }
    
    func rightMenuButton() -> UIButton {
        btnRightMenu = Utility.sharedInstance.createButton(xCo: kWidth - 50, forY: 0, forW: 40, forH: kNavBarHeight, forText: "", textColor: UIColor.white, wifthFont: UIFont.systemFont(ofSize: 12), backColor: krgbClear)
        btnRightMenu.setImage(UIImage.init(named: "toggle"), for: .normal)
        return btnRightMenu
    }
    
    func leftButton(title: String) -> UIButton {
        btnBack = Utility.sharedInstance.createButton(xCo: 0, forY: 0, forW: 60, forH: kNavBarHeight, forText: title, textColor: UIColor.white, wifthFont: UIFont.systemFont(ofSize: 14), backColor: krgbClear)
        
        return btnBack
    }
    
    func rightButton(title: String) -> UIButton {
        btnRightMenu = Utility.sharedInstance.createButton(xCo: kWidth - 70, forY: 10, forW: 60, forH: kNavBarHeight-10, forText: title, textColor: UIColor.white, wifthFont: UIFont.systemFont(ofSize: 14), backColor: krgbClear)
        
        return btnRightMenu
    }
    
    func rightPhotoButton() -> UIButton {
        btnRightMenu = Utility.sharedInstance.createButton(xCo: kWidth - 100, forY: 10, forW: 90, forH: kNavBarHeight, forText: "", textColor: UIColor.white, wifthFont: UIFont.boldSystemFont(ofSize: 13), backColor: krgbClear)
        return btnRightMenu
    }
    
    func getBottomBorder(color: UIColor) -> UIView {
        uvBottomBorder = Utility.sharedInstance.createView(xCo: 0, forY: kNavBarHeight-0.6, forW: kWidth, forH: 0.6, backColor: color)
        return uvBottomBorder
    }
    
    func setNavTitle(color: UIColor, font: UIFont, align: NSTextAlignment) -> Void {
        lblTitle.textColor = color
        lblTitle.textAlignment = align
        lblTitle.font = font
    }
}
