//
//  UsersListVC.swift
//  Turnstr
//
//  Created by Kamal on 01/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import SendBirdSDK

class UsersListVC: ParentViewController {

    var dataSource: TableViewDataSources?
    lazy var users: [User] = [User]()
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDataSource()
        apiListUsers()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: ------ Custom Methods
    func initDataSource() {
        dataSource = TableViewDataSources([], tableView, .userCell)
        tableView?.delegate = dataSource
        tableView?.dataSource = dataSource
        dataSource?.includeRefreshControl = true
        dataSource?.refreshControl?.addTarget(self, action: #selector(apiListUsers), for: .valueChanged)
        dataSource?.cellAtIndex = {[weak self] (_ cell: UITableViewCell, _ indexpath: IndexPath) in
            self?.updateCell(cell, indexpath)
        }
        dataSource?.selectAtIndex = { [weak self] (_ indexPath: IndexPath) in
            self?.didSelectCellAt(indexPath)
        }
    }
    
    func updateCell(_ cell: UITableViewCell, _ indexpath: IndexPath) {
        if let cell = cell as? UserCell {
            let user = self.users[indexpath.row]
            cell.updateUserInfo(user)
        }
    }
    
    func didSelectCellAt(_ indexPath: IndexPath) {
        
        guard let userId = users[indexPath.row].id else { return }
        SBDGroupChannel.createChannel(withUserIds: [userId], isDistinct: true) {[weak self] (channel, error) in
            if error != nil {
                KBLog.log(message: "Error in creatig chat channel", object: error)
                return
            }
            else {
                self?.dismiss(animated: false, completion: {
                    self?.pushToChat(channel)
                })
            }
        }
    }
    
    func pushToChat(_ channel: SBDGroupChannel?) {
        guard let vc = Storyboards.chatStoryboard.initialVC(with: .chatVC) as? ChatVC else { return }
        vc.channel = channel
        topVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: ------ API Methods
    func apiListUsers()  {
        let response = WebServices.sharedInstance.GetMethodServerData(strRequest: "members", GetURL: "", parType: "")
        let objData = objDataS.validateData(response: response)
        if let followers = objData["members"] as? [AnyObject] {
            for obj in followers {
                let user = User.init(obj as? [String: Any])
                users.append(user)
            }
            self.dataSource?.items = users
            self.dataSource?.reloadData()
        }
        self.dataSource?.refreshControl?.endRefreshing()
    }
}
