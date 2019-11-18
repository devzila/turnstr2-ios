//
//  AppFont.swift
//  Workcocoon
//
//  Created by Sierra 3 on 30/05/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import UIKit

enum Gotham: String {
    case black = "Gotham-Black"
    case blackItalic = "Gotham-BlackItalic"
    case bold = "Gotham-Bold"
    case boldItalic = "Gotham-BoldItalic"
    case book = "Gotham-Book"
    case bookItalic = "Gotham-BookItalic"
    case light = "Gotham-Light"
    case lightItalic = "Gotham-LightItalic"
    case medium = "Gotham-Medium"
    case mediumItalic = "Gotham-MediumItalic"
    case thin = "Gotham-Thin"
    case thinItalic = "Gotham-ThinItalic"
    case ultra = "Gotham-Ultra"
    case ultraItalic = "Gotham-UltraItalic"
    case xlight = "Gotham-ExtraLight"
    case xlightItalic = "Gotham-ExtraLightItalic"
}

extension Gotham {
    
    func size(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: self.rawValue, size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
}





