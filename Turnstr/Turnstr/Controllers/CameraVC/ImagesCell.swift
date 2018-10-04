//
//  ImagesCell.swift
//  Turnstr
//
//  Created by Mr. X on 16/02/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class ImagesCell: UICollectionViewCell {

    var representedAssetIdentifier: String!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
