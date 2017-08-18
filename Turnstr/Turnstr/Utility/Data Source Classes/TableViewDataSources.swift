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
    typealias CellSelectForRowAtIndexPath = (_ IndexPath: IndexPath) -> ()
    lazy var items: [Any] = [Any]()
    var tableView: UITableView?
    var identifier: CellIdentifiers?
    var cellAtIndex: CellForRowAtIndexPath?
    var selectAtIndex: CellSelectForRowAtIndexPath?
    var refreshControl: UIRefreshControl?
    var includeRefreshControl: Bool = false {
        didSet {
            if includeRefreshControl == true {
                refreshControl = UIRefreshControl()
                refreshControl?.tintColor = .orange
                if let control = refreshControl {
                    tableView?.addSubview(control)
                }
            }
        }
    }
    
    init(_ objects: [Any], _ tableView: UITableView?, _ cellIdentifier: CellIdentifiers) {
        
        super.init()
        self.items = objects
        self.tableView = tableView
        identifier = cellIdentifier
        
        cellIdentifier.registerCell(tableView)
    }
    
    func reloadData() {
        self.tableView?.reloadData()
        self.refreshControl?.endRefreshing()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectCell = selectAtIndex {
            selectCell(indexPath)
        }
    }
}
