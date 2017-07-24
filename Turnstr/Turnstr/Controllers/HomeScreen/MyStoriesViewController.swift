//
//  MyStoriesViewController.swift
//  Turnstr
//
//  Created by Mr X on 05/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class MyStoriesViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate, CubePageView_Delegate {
    
    let objStory = Story.sharedInstance
    
    var tblMainTable: UITableView?
    var arrList: NSMutableArray = NSMutableArray()
    var current_page: Int = 0
    var isLoading: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        /*
         * Navigation Bar
         */
        LoadNavBar()
        objNav.btnBack.isHidden = true
        //objNav.btnRightMenu.isHidden = true
        objNav.btnRightMenu.addTarget(self, action: #selector(LoadEProfile), for: .touchUpInside)
        createTableView()
        
        kAppDelegate.loadingIndicationCreation()
        APIRequest(sType: kAPIGetStories, data: [:])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Navigation Methods
    
    func LoadEProfile() -> Void {
        let mvc = EditProfileViewController()
        mvc.showBack = .yes
        self.navigationController?.pushViewController(mvc, animated: true)
    }
    
    //MARK:- Table View
    
    func createTableView() -> Void {
        
        tblMainTable = UITableView.init(frame: CGRect.init(x: 0, y: kNavBarHeightWithLogo, width: kWidth, height: kHeight-kNavBarHeightWithLogo), style: .plain)
        tblMainTable?.delegate = self
        tblMainTable?.dataSource = self
        tblMainTable?.backgroundColor = UIColor.white
        tblMainTable?.separatorColor = krgbClear
        self.view.addSubview(tblMainTable!)
        
    }
    
    //MARK:**********************************************************************************
    //MARK: TableView Data Source
    //MARK:**********************************************************************************
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return arrList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return rowHeight(indexPath: indexPath)
    }
    
    func rowHeight(indexPath: IndexPath) -> CGFloat {
        return 300//kWidth+70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let identifier = "Cell\(indexPath.row+1)"
        var cell: StoriesTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? StoriesTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "StoriesTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? StoriesTableViewCell
        }
        
        objStory.ParseStoryData(dict: arrList[indexPath.row] as! Dictionary<String, Any>)
        
        let arrMedia = objStory.media
        
        var arrImages: [UIImageView] = []
        
        for item in arrMedia {
            objStory.ParseMedia(media: item as! [String : String])
            let imgImage: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: cell.uvCubeBg.frame.height))
            imgImage.sd_setImage(with: URL.init(string: objStory.thumb_url), placeholderImage: #imageLiteral(resourceName: "thumb"))
            imgImage.contentMode = .scaleAspectFill
            arrImages.append(imgImage)
        }
        
        var cube = cell.uvCubeBg.viewWithTag(indexPath.row+1) as? CubePageView
        
        if cube == nil {
            cube = CubePageView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: cell.uvCubeBg.frame.height))
            cube?.tag = indexPath.row+1
            cube?.delegate = self
        }
        
        cube?.backgroundColor = UIColor.white
        cell.uvCubeBg.addSubview(cube!)
        cube?.setPages(arrImages)
        //cube?.accessibilityElements = [arrMedia]
        cube?.selectPage((cube?.currentPage())!, withAnim: false)
        
        
        cell.imgImage.sd_setImage(with: URL.init(string: objStory.strUserPic1), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        cell.lblName.text = objStory.strUserName
        cell.lblTime.text = ""
        cell.lblCaption.text = objStory.strCaption.capitalized
        cell.uvCubeBg.layer.masksToBounds = true
        
        
        cell.selectionStyle = .none
        return cell!
        
    }
    
    //MARK:- Header Footer of Table
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        return UIView()
    }
    
    //MARK:- TableView Delegate Methods
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let mvc = StoryPreviewViewController()
        mvc.dictInfo = arrList[indexPath.row] as! Dictionary<String, Any>
        self.navigationController?.pushViewController(mvc, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if isLoading == false {
                isLoading = true
                APIRequest(sType: kAPIGetStories, data: [:])
            }
            
        }
    }
    
    //MARK:- Cube Delegates
    
    func cubePageView(_ pc: CubePageView!, newPage page: Int32) {
        print(page)
        
        //let arrMedia = pc?.accessibilityElements?[0] as? [String]
        //print(arrMedia!)
        //let imgImage: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: pc.frame.height))
        //imgImage.sd_setImage(with: URL.init(string: arrMedia[page]))
        //pc.addSubview(imgImage)
    }
    
    //MARK:- APIS Handling
    
    func APIRequest(sType: String, data: Dictionary<String, Any>) -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        DispatchQueue.global().async {
            
            if sType == kAPIGetStories {
                let dictAction: NSDictionary = [
                    "action": kAPIGetStories,
                    "page": self.current_page+1
                ]
                
                let arrResponse = self.objDataS.GetRequestToServer(dictAction: dictAction)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        if let stories = arrResponse["stories"] as? NSArray {
                            
                            if stories.count > 0 {
                                if let currentpage = arrResponse["current_page"] as? Int {
                                    self.current_page = currentpage
                                }
                                
                                let j = self.arrList.count
                                var k = 0
                                for var i in (j..<j+stories.count) {
                                    self.arrList.add(stories[k])
                                    k = k+1
                                    
                                    self.tblMainTable?.beginUpdates()
                                    
                                    let indexPath:IndexPath = IndexPath(row:i, section:0)
                                    
                                    self.tblMainTable?.insertRows(at: [indexPath], with: .bottom)
                                    
                                    self.tblMainTable?.endUpdates()
                                    
                                }
                            }
                            
                            //self.arrList = NSMutableArray.init(array: stories)
                        }
                        self.isLoading = false
                        //self.tblMainTable?.reloadData()
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            
        }
    }
    
}
