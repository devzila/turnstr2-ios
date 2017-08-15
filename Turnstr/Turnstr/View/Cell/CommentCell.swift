//
//  CommentCell.swift
//  Turnstr
//
//  Created by Mr X on 02/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var uvImage: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
