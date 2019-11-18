
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
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        self.imageView?.contentMode = .center
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}
