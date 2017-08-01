//
//  UserCell.swift
//  Turnstr
//
//  Created by Kamal on 02/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblSubTitle: UILabel?
    @IBOutlet weak var imgView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUserInfo(_ user: User) {
        lblName?.text = user.name
        lblSubTitle?.text = user.email
        imgView?.image = #imageLiteral(resourceName: "placeholder_1")
    }
    
}
