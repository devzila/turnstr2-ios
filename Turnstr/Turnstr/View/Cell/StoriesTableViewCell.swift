//
//  StoriesTableViewCell.swift
//  Turnstr
//
//  Created by Mr X on 06/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class StoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var uvBG: UIView!
    @IBOutlet weak var uvCubeBg: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgImage: Image!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
