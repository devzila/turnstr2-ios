//
//  CellIdentifiers.swift
//  Workcocoon
//
//  Created by Sierra 3 on 05/06/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import UIKit


enum CellIdentifiers: String{
    case channels = "ChannelCell"
    case userCell = "UserCell"
}

extension CellIdentifiers {
    
    func registerCell(_ tableView: UITableView?) {
        let nib = UINib(nibName: self.rawValue, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: self.rawValue)
    }
    
    func dequeCell(_ tableView: UITableView) -> UITableViewCell? {
        return tableView.dequeueReusableCell(withIdentifier: self.rawValue)
    }
}
