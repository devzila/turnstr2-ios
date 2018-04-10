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
    @IBOutlet weak var cubeView: UIView?
    
    var dataSource: TableViewDataSources?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDataSource()
        
        initUserInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiListChatBuds()
    }
    
    
    //MARK: ------ Custom Methods
    
    func initUserInfo() {
        
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
    
    @IBAction func btnSearch() {
        guard let vc = Storyboards.chatStoryboard.initialVC(with: .usersList) else { return }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func actMyGoLive(_ sender: UIButton) {
        let camVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
        topVC?.navigationController?.pushViewController(camVC, animated: true)
        
        
    }
}
