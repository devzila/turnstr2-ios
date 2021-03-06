//
//  ListFollowingFollowersVC.swift
//  Turnstr
//
//  Created by Kamal on 24/11/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

class ListFollowingFollowersVC: ParentViewController {

    @IBOutlet weak var tableView: UITableView?
    
    // Parameters isForFollowing - true for following, false for followers
    var isForFollowing: Bool = true
    var userId: Int!
    var currentPage: Int = 1
    var totalPages: Int = 1
    var items: [User] = [User]()
    var tableDataSource: TableViewDataSources? {
        didSet {
            tableView?.delegate = tableDataSource
            tableView?.dataSource = tableDataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        requestAPI()
    }
    
    //MARK: => Configure Table Data Source
    private func configureTableView() {
        tableDataSource = TableViewDataSources(items, tableView, .userCell)
        tableDataSource?.cellAtIndex = { (_ cell: UITableViewCell, _ indexPath: IndexPath) in
            let user = self.items[indexPath.row]
            (cell as? UserCell)?.configureFollowingFollowerCell(user)
        }
        tableDataSource?.selectAtIndex = {(_ indexPath: IndexPath) in
            let user = self.items[indexPath.row]
            user.pushToProfileDetail()
        }
        tableDataSource?.reachedLastCell = { [unowned self] in
//            self.currentPage < self.totalPages {
//                self.currentPage += 1
//                self.requestAPI()
//            }
        }
    }
    
    private func add(users: [User]) {
        for user in users {
            self.items.append(user)
        }
        tableDataSource?.items = items
        tableDataSource?.tableView?.reloadData()
    }
}

//MARK: => API Calls
extension ListFollowingFollowersVC {
    private func requestAPI() {
        guard let _userId = self.userId else { return }
        let apiEndPoint = isForFollowing ? "members/\(_userId)/following" : "members/\(_userId)/followers"
        let keyword = isForFollowing ? "following" : "followers"
        let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: apiEndPoint, parType: "")
        
        DispatchQueue.main.async {
            if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                kAppDelegate.hideLoadingIndicator()
                
                if let data = dictResponse["data"]?["data"] as? [String: AnyObject] {
                    print(data)
                    var users = [User]()
                    if let objs = data[keyword] as? [Any] {
                        for obj in objs {
                            let user = User(withStoryInfo: obj as? [String: Any])
                            users.append(user)
                        }
                    }
                    self.add(users: users)
                    if let currentPage = data["current_page"] as? Int {
                        self.currentPage = currentPage
                    }
                    if let totalPages = data["total_pages"] as? Int {
                        self.totalPages = totalPages
                    }
                }
            } else {
                kAppDelegate.hideLoadingIndicator()
            }
        }
    }
}
