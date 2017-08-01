//
//  TableViewDataSources.swift
//  Turnstr
//
//  Created by Kamal on 01/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class TableViewDataSources: NSObject {

    typealias CellForRowAtIndexPath = (_ cell: UITableViewCell, _ IndexPath: IndexPath) -> ()
    typealias CellSelectForRowAtIndexPath = (_ cell: UITableViewCell, _ IndexPath: IndexPath) -> ()
    lazy var items: [Any] = [Any]()
    var tableView: UITableView?
    var identifier: CellIdentifiers?
    var cellAtIndex: CellForRowAtIndexPath?
    var selectAtIndex: CellSelectForRowAtIndexPath?
    
    init(_ objects: [Any], _ tableView: UITableView?, _ cellIdentifier: CellIdentifiers) {
        
        super.init()
        self.items = objects
        self.tableView = tableView
        
        cellIdentifier.registerCell(tableView)
    }
}

extension TableViewDataSources: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = identifier?.dequeCell(tableView) else { return UITableViewCell() }
        if let cellAtIndex = cellAtIndex {
            cellAtIndex(cell, indexPath)
        }
        return cell
    }
}

extension TableViewDataSources: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectCell = selectAtIndex {
            
        }
    }
}
