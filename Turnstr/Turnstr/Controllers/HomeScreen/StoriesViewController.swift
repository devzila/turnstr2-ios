//
//  StoriesViewController.swift
//  Turnstr
//
//  Created by Mr X on 23/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class StoriesViewController: ParentViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    var screenType: enumScreenType = .normal
    
    
    var topCube: AITransformView?
    
    var uvCollectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout?
    
    let objStory = Story.sharedInstance
    
    var arrList: NSMutableArray = NSMutableArray()
    var current_page: Int = 0
    var isLoading: Bool = true
    
    @IBOutlet weak var lblPostLeft: UILabel!
    @IBOutlet weak var lblPostRight: UILabel!
    
    @IBOutlet weak var uvTopCube: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if screenType == .myStories {
            self.view.addSubview(btnNavBack)
            btnNavBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        lblPostLeft.numberOfLines = 0
        lblPostRight.numberOfLines = 0
        
        let postTitle: NSMutableAttributedString = NSMutableAttributedString.init(string: "posts\nfollowers\nfamily")
        postTitle.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle.length))
        postTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postTitle.length))
        
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        postTitle.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postTitle.length))
        
        lblPostLeft.attributedText = postTitle
        
        
        let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(objSing.post_count)\n\(objSing.follower_count)\n\(objSing.family_count)")
        postDetail.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
        postDetail.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
        style.alignment = .left
        
        postDetail.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postDetail.length))
        
        lblPostRight.attributedText = postDetail
        
        
        createCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        defer {
            current_page = 0
            kAppDelegate.loadingIndicationCreation()
            APIRequest(sType: kAPIGetAllStories, data: [:])
        }
        
        //
        //Top Cube View
        //
        
        topCube?.removeFromSuperview()
        topCube = nil
        
        let w: CGFloat = 95
        let h: CGFloat = 80
        
        if topCube == nil {
            
            topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 65)
        }
        topCube?.backgroundColor = UIColor.clear
        topCube?.setup(withUrls: [objSing.strUserPic1.urlWithThumb, objSing.strUserPic2.urlWithThumb, objSing.strUserPic3.urlWithThumb, objSing.strUserPic4.urlWithThumb, objSing.strUserPic5.urlWithThumb, objSing.strUserPic6.urlWithThumb])
        uvTopCube.addSubview(topCube!)
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 20, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
        
        
        
        self.arrList.removeAllObjects()
        uvCollectionView?.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Collection Grid for Story Setup
    
    func createCollectionView() -> Void {
        
        if flowLayout == nil {
            flowLayout = UICollectionViewFlowLayout.init()
            flowLayout?.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            flowLayout?.itemSize = PhotoSize()
            
        }
        
        if uvCollectionView == nil {
            uvCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: uvTopCube.frame.maxY+10, width: kWidth, height: kHeight-120), collectionViewLayout: flowLayout!)
            uvCollectionView?.dataSource = self
            uvCollectionView?.delegate = self
            uvCollectionView?.backgroundColor = UIColor.white
            self.view.addSubview(uvCollectionView!)
            uvCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        }
        
    }
    
    func PhotoSize() -> CGSize {
        let photoCellSize = (kWidth/3)-10
        return CGSize(width: photoCellSize, height: photoCellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        objStory.ParseStoryData(dict: arrList[indexPath.row] as! Dictionary<String, Any>)
        
        
        let w: CGFloat = PhotoSize().width
        let h: CGFloat = PhotoSize().height
        var cube = cell.contentView.viewWithTag(indexPath.item) as? AITransformView
        
        if cube == nil {
            cube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 65)
            cube?.backgroundColor = UIColor.white
            cube?.tag = indexPath.item
            
            cell.contentView.addSubview(cube!)
            
            
            var arrMedia: [String] = []
            
            for item in objStory.media {
                objStory.ParseMedia(media: item)
                arrMedia.append(objStory.thumb_url)
            }
            
            
            cube?.setup(withUrls: arrMedia)
            
            
            cube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 20, y: h/2))
            cube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
            
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        tap.accessibilityElements = [indexPath]
        tap.numberOfTapsRequired = 1
        cube?.addGestureRecognizer(tap)
        
        cube?.isExclusiveTouch = true
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.init("F3F3F3").cgColor
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mvc = StoryPreviewViewController()
        mvc.dictInfo = arrList[indexPath.row] as! Dictionary<String, Any>
        self.navigationController?.pushViewController(mvc, animated: true)
        
    }
    
    //MARK:- Action Methods
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        
        let indexPath: IndexPath = (sender?.accessibilityElements![0] as? IndexPath)!
        
        let mvc = StoryPreviewViewController()
        mvc.dictInfo = arrList[indexPath.item] as! Dictionary<String, Any>
        mvc.userTYpe = screenType
        self.navigationController?.pushViewController(mvc, animated: true)
        
        
    }
    
    @IBAction func NewStoryClicked(_ sender: UIButton) {
        let camVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
        self.navigationController?.pushViewController(camVC, animated: true)
        
    }
    
    //MARK:- APIS Handling
    
    func APIRequest(sType: String, data: Dictionary<String, Any>) -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        DispatchQueue.global().async {
            
            if sType == kAPIGetAllStories {
                
                let dictAction: NSDictionary
                
                if self.screenType == .myStories {
                    dictAction = [
                        "action": kAPIGetStories,
                        "page": self.current_page+1
                    ]
                }
                else{
                    dictAction = [
                        "action": kAPIGetAllStories,
                        "page": self.current_page+1
                    ]
                }
                
                
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
                                    
                                    let indexPath:IndexPath = IndexPath(row:i, section:0)
                                    self.uvCollectionView?.insertItems(at: [indexPath])
                                    
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
