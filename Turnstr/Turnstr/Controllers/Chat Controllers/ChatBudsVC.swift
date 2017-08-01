//
//  ChatBudsVC.swift
//  Turnstr
//
//  Created by Kamal on 01/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatBudsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    
    lazy var chatbuds = [SBDGroupChannel]()
    var dataSource: TableViewDataSources?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        apiListChatBuds()
        initDataSource()
        // Do any additional setup after loading the view.
    }

    
    //MARK: ------ Custom Methods
    func initDataSource() {
        dataSource = TableViewDataSources([], tableView, .channels)
        tableView?.delegate = dataSource
        tableView?.dataSource = dataSource
        dataSource?.includeRefreshControl = true
        dataSource?.refreshControl?.addTarget(self, action: #selector(apiListChatBuds), for: .valueChanged)
        dataSource?.cellAtIndex = {[weak self] (_ cell: UITableViewCell, _ indexpath: IndexPath) in
            self?.updateCell(cell, indexpath)
        }
        dataSource?.selectAtIndex = { [weak self] (_ indexPath: IndexPath) in
            self?.didSelectCellAt(indexPath)
        }
    }
    
    func updateCell(_ cell: UITableViewCell, _ indexpath: IndexPath) {
        if let groupCell = cell as? ParentChatCell {
            let channel = self.chatbuds[indexpath.row]
            groupCell.updateBudCell(channel)
        }
    }
    
    func didSelectCellAt(_ indexPath: IndexPath) {
        KBLog.log(message: "chat bud -- > ", object: chatbuds[indexPath.row])
    }
    
    //MARK: ------ API Methods
    func apiListChatBuds()  {
        let query = SBDGroupChannel.createMyGroupChannelListQuery()
        query?.loadNextPage(completionHandler: {[weak self] (channels, error) in
            guard let cs = channels else {return}
            for obj in cs {
                self?.chatbuds.append(obj)
            }
            self?.dataSource?.items = self?.chatbuds ?? []
            self?.dataSource?.reloadData()
        })
    }
    
    
    //MARK: ------ Action Methods
    @IBAction func newChat() {
        guard let vc = Storyboards.chatStoryboard.initialVC(with: .usersList) else { return }
        present(vc, animated: true, completion: nil)
    }
}
