//
//  StoryCommentVC.swift
//  Turnstr
//
//  Created by Mr X on 02/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

protocol StoryCommentsDelegate {
    func CommentCountChanged(count: Int)
}

class StoryCommentVC: ParentViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var txtComment: UITextField!
    
    let objStory = Story.sharedInstance
    let objCom = Comment.sharedInstance
    
    var delegate: StoryCommentsDelegate?
    
    
    var tblMainTable: UITableView?
    //var arrComments: NSMutableArray = NSMutableArray()
    var arrComments: NSMutableArray = NSMutableArray()
    var dictInfo: Dictionary<String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         * Navigation Bar
         */
        let uvNavBar = MenuBar.init(frame: self.view.frame)
        self.view.addSubview(uvNavBar)
        objNav.navTitle(title: "Comments", inView: uvNavBar)
        objNav.lblTitle.textColor = UIColor.black
        uvNavBar.addSubview(objNav.rightButton(title: "Done"))
        objNav.btnRightMenu.setTitleColor(UIColor.black, for: .normal)
        
        objNav.btnRightMenu.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        createTableView()
        
        objLoader.start(inView: self.view)
        APIRequest(sType: kAPIGetStoriesComments, data: [:])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Action Methods
    @IBAction func PostComment(_ sender: Any) {
        IQKeyboardManager.sharedManager().resignFirstResponder()
        
        if txtComment.text?.isEmpty == true {
            return
        }
        APIPostCommentRequest()
    }
    
    
    //MARK:- Table View
    func createTableView() -> Void {
        
        tblMainTable = UITableView.init(frame: CGRect.init(x: 0, y: kNavBarHeight, width: kWidth, height: kHeight-kNavBarHeight-50), style: .plain)
        tblMainTable?.delegate = self
        tblMainTable?.dataSource = self
        tblMainTable?.backgroundColor = UIColor.white
        tblMainTable?.separatorColor = krgbClear
        self.view.addSubview(tblMainTable!)
        
        tblMainTable?.estimatedRowHeight = 50
        tblMainTable?.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    //MARK:**********************************************************************************
    //MARK: TableView Data Source
    //MARK:**********************************************************************************
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        delegate?.CommentCountChanged(count: arrComments.count)
        return arrComments.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableViewAutomaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let identifier = "Cell"
        var cell: CommentCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? CommentCell
        if cell == nil {
            tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CommentCell
        }
        
        objCom.ParseCommentData(dict: arrComments[indexPath.row] as! Dictionary<String, Any>)
        
        cell.lblName.text = objCom.strUserFname+" "+objCom.strUserLName
        cell.lblMsg.text = objCom.body.decode()
        cell.lblTime.text = self.convertStringToDate(dateString: objCom.created_at)?.timeAgoDisplay()
        
        var cube = cell.uvImage.viewWithTag(indexPath.item) as? AITransformView
        if cube == nil {
            
            cube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60), cube_size: 40)
            cube?.tag = indexPath.item
            cube?.backgroundColor = UIColor.clear
            cube?.isUserInteractionEnabled = false
            let arrFaces = [objCom.strUserPic1, objCom.strUserPic2, objCom.strUserPic3, objCom.strUserPic4, objCom.strUserPic5, objCom.strUserPic6]
            cube?.setup(withUrls: arrFaces)
            cell.uvImage.addSubview(cube!)
            cube?.setScroll(CGPoint.init(x: 0, y: 30), end: CGPoint.init(x: 3, y: 30))
            cube?.setScroll(CGPoint.init(x: 30, y: 0), end: CGPoint.init(x: 30, y: 1))
        }
        
        
        return cell
    }
    
    func convertStringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter() //2017-07-10T05:39:31.000Z
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        
        if let dateObj = dateFormatter.date(from: dateString) {
            return dateObj
        }
        return nil
    }
    
    //MARK:- Header Footer of Table
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        return UIView()
    }
    
    
    //MARK:- TableView Delegate Methods
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func APIRequest(sType: String, data: Dictionary<String, Any>) -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        DispatchQueue.global().async {
            
            if sType == kAPIGetStoriesComments {
                
                self.objStory.ParseStoryData(dict: self.dictInfo)
                
                let dictAction: NSDictionary = [
                    "action": kAPIGetStoriesComments,
                    "id": self.objStory.storyID
                ]
                
                let arrResponse = self.objDataS.GetRequestToServer(dictAction: dictAction)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        if let arComs = arrResponse["comments"] as? NSArray {
                            self.arrComments = arComs.mutableCopy() as! NSMutableArray
                        }
                        
                        
                        self.tblMainTable?.reloadData()
                        self.objLoader.stop()
                        kAppDelegate.hideLoadingIndicator()
                        self.tblMainTable?.scrollToBottom()
                    }
                }
            }
            
            
        }
    }
    
    func APIPostCommentRequest() -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        self.objStory.ParseStoryData(dict: self.dictInfo)
        
        let txtMsg = self.txtComment.text ?? ""
        
        let dictAction: NSDictionary = [
            "action": kAPIGetStoriesComments,
            "id": "\(self.objStory.storyID)",
            "comment[body]" : txtMsg.encode() //"\(self.txtComment.text!)"
        ]
        
        DispatchQueue.global().async {
            
            let arrResponse = self.objDataS.uploadFilesToServer(dictAction: dictAction, arrImages: [])
            
            if (arrResponse.count) > 0 {
                DispatchQueue.main.async {
                    self.txtComment.text = ""
                    if let com = arrResponse["comment"] as? Dictionary<String, Any> {
                        self.arrComments.add(com)
                    }
                    self.tblMainTable?.reloadData()
                    self.tblMainTable?.scrollToBottom()
                }
                
            }
        }
    }
    
    
    
    
}
