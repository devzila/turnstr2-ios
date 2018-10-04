
//
//  UIButtonExtension.swift
//  Workcocoon
//
//  Created by Sierra 3 on 07/06/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func adjustImageAndTitleOffsetsForButton(_ spacing: CGFloat) {
        
        guard let imageSize = self.imageView?.frame.size, let titleSize = self.titleLabel?.frame.size else { return }
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(imageSize.height + spacing), 0)
        self.imageView?.contentMode = .center
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
    }
}
