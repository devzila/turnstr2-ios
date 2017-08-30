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
    
    var dataSource: TableViewDataSources?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDataSource()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiListChatBuds()
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
        if let groupCell = cell as? ChannelCell {
            guard let channel = self.dataSource?.items[indexpath.row] as? SBDGroupChannel else { return }
            
            let index = indexpath.row < 7 ? CGFloat(indexpath.row) : CGFloat(indexpath.row % 7)
            groupCell.sepratorLine?.alpha = (1 - (index * 0.1))
            groupCell.updateBudCell(channel)
        }
    }
    
    func didSelectCellAt(_ indexPath: IndexPath) {
        guard let vc = Storyboards.chatStoryboard.initialVC(with: .chatVC) as? ChatVC else { return }
        vc.channel = self.dataSource?.items[indexPath.row] as? SBDGroupChannel
        topVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: ------ API Methods
    func apiListChatBuds()  {
        let query = SBDGroupChannel.createMyGroupChannelListQuery()
        query?.loadNextPage(completionHandler: {[weak self] (channels, error) in
            guard let cs = channels else {return}
            self?.dataSource?.items = cs
            self?.dataSource?.reloadData()
            
            var count = 0
            for bud in cs {
                count += Int(bud.unreadMessageCount)
            }
            UIApplication.shared.applicationIconBadgeNumber = count
        })
    }
    
    
    //MARK: ------ Action Methods
    @IBAction func newChat() {
        guard let vc = Storyboards.chatStoryboard.initialVC(with: .usersList) else { return }
        present(vc, animated: true, completion: nil)
    }
}
