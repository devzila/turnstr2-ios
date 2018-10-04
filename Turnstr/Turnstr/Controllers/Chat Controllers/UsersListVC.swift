//
//  UsersListVC.swift
//  Turnstr
//
//  Created by Kamal on 01/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import SendBirdSDK

@objc protocol UserListDelegate {
    @objc optional func UserSelected(userId: String)
}

class UsersListVC: ParentViewController {
    
    enum screenType {
        case normal
        case calling
        case goLive
    }
    
    var dataSource: TableViewDataSources?
    lazy var users: [User] = [User]()
    var screenTYpe: screenType = .normal
    var delegate:UserListDelegate?
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var lblPosts: UILabel?
    @IBOutlet weak var lblFollowing: UILabel?
    @IBOutlet weak var lblFamily: UILabel?
    @IBOutlet weak var cubeView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDataSource()
        apiListUsers()
        
        initUserInfo()
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
        
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 120))
        footerView.backgroundColor = .clear
        let imgView = UIImageView(frame: footerView.bounds)
        imgView.contentMode = .center
        imgView.image = #imageLiteral(resourceName: "cube")
        footerView.addSubview(imgView)
        tableView?.tableFooterView = footerView
    }
    
    func initUserInfo() {
        let obj = Singleton.sharedInstance
        lblPosts?.text = "\(obj.post_count)"
        lblFamily?.text = "\(obj.family_count)"
        lblFollowing?.text = "\(obj.follower_count)"
        
        let w: CGFloat = cubeView?.frame.size.width ?? 80.0
        let h: CGFloat = cubeView?.frame.size.height ?? 80.0
        
        
        let topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 60)
        cubeView?.backgroundColor = .clear
        cubeView?.addSubview(topCube!)
        let objSing = Singleton.sharedInstance
        topCube?.setup(withUrls: [objSing.strUserPic1.urlWithThumb, objSing.strUserPic2.urlWithThumb, objSing.strUserPic3.urlWithThumb, objSing.strUserPic4.urlWithThumb, objSing.strUserPic5.urlWithThumb, objSing.strUserPic6.urlWithThumb])
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 5, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
    }
    
    func updateCell(_ cell: UITableViewCell, _ indexpath: IndexPath) {
        if let cell = cell as? UserCell {
            let user = self.users[indexpath.row]
            cell.updateUserInfo(user)
        }
    }
    
    func didSelectCellAt(_ indexPath: IndexPath) {
        
        guard let userId = users[indexPath.row].id else { return }
        
        if self.screenTYpe == .calling || self.screenTYpe == .goLive {
            delegate?.UserSelected!(userId: userId)
            self.dismiss(animated: false, completion: {
            })
            return
        }
        
        SBDGroupChannel.createChannel(withUserIds: [userId], isDistinct: true) {[weak self] (channel, error) in
            if error != nil {
                self?.dismissAlert(title: "Error", message: error?.description)
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
        var response: Dictionary<String,AnyObject> = [:]
        
        if screenTYpe == .goLive {
            response = WebServices.sharedInstance.GetMethodServerData(strRequest: kAPIFollowUnfollowUser + "/\(loginUser.id ?? "")/family", GetURL: "", parType: "")
        }
        else{
            response = WebServices.sharedInstance.GetMethodServerData(strRequest: "user/followers", GetURL: "", parType: "")
        }
        
        let objData = objDataS.validateData(response: response)
        
        
        
        if screenTYpe == .goLive {
            if let followers = objData["family"] as? [AnyObject] {
                users = [User]()
                for obj in followers {
                    let user = User.init(obj as? [String: Any])
                    users.append(user)
                }
                //            self.registerUsers(users)
                self.dataSource?.items = users
                self.dataSource?.reloadData()
            }
        }
        else{
            if let followers = objData["followers"] as? [AnyObject] {
                users = [User]()
                for obj in followers {
                    let user = User.init(obj as? [String: Any])
                    users.append(user)
                }
                //            self.registerUsers(users)
                self.dataSource?.items = users
                self.dataSource?.reloadData()
            }
        }
        
        self.dataSource?.refreshControl?.endRefreshing()
    }
    
//    
//    func registerUsers(_ users: [User]) {
//        
//        for u in users {
//        
//            SBDMain.connect(withUserId: u.id ?? "", completionHandler: { (user, error) in
//                if error == nil {
//                    let strUrls = u.cubeUrls.map({ ($0.absoluteString) }).joined(separator: ",")
//                    SBDMain.updateCurrentUserInfo(withNickname: u.name, profileUrl: strUrls, completionHandler: { (error) in
//                        if error != nil {
//                            KBLog.log(message: "Error in saving user info ", object: error)
//                        }
//                    })
//                }
//                else {
//                    KBLog.log(message: "Error in Send bird login user", object: user)
//                }
//            })
//        }
//        
//    }
}
