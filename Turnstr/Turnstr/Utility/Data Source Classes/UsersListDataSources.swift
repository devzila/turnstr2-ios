//
//  UsersListDataSources.swift
//  Turnstr
//
//  Created by Kamal on 01/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class UsersListDataSources: NSObject {

    typealias CellForRowAtIndexPath = (_ cell: UITableViewCell, _ IndexPath: IndexPath) -> ()
    typealias CellSelectForRowAtIndexPath = (_ IndexPath: IndexPath) -> ()
    lazy var items: [Friends] = [Friends]()
    var tableView: UITableView?
    var identifier: CellIdentifiers?
    var cellAtIndex: CellForRowAtIndexPath?
    var selectAtIndex: CellSelectForRowAtIndexPath?
    
    init(_ objects: [Friends], _ tableView: UITableView?, _ cellIdentifier: CellIdentifiers) {
        
        super.init()
        self.items = objects
        self.tableView = tableView
        
        cellIdentifier.registerCell(tableView)
    }
}

extension UsersListDataSources: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = identifier?.dequeCell(tableView) else { return UITableViewCell() }
        if let cellAtIndex = cellAtIndex {
            cellAtIndex(cell, indexPath)
        }
        return cell
    }
}

extension UsersListDataSources: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectCell = selectAtIndex {
            selectCell(indexPath)
        }
    }
}
