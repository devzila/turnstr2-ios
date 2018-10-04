//
//  StoriesViewController.swift
//  Turnstr
//
//  Created by Mr X on 23/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

protocol StoriesVCDelegate {
    func StoriesVCBackClicked()
}
class StoriesViewController: ParentViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    var delegate: StoriesVCDelegate?
    
    var screenType: enumScreenType = .normal
    
    var isNewStoryLaunched: Bool = false
    
    
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
            btnNavBack.addTarget(self, action: #selector(actGoBack), for: .touchUpInside)
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
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 10, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
        
        
        
        
        self.arrList.removeAllObjects()
        uvCollectionView?.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Collection Grid for Story Setup
    
    func reloadGrid() {
        defer {
            current_page = 0
            objLoader.start(inView: self.view)
            APIRequest(sType: kAPIGetAllStories, data: [:])
        }
        
        self.arrList.removeAllObjects()
        uvCollectionView?.reloadData()
    }
    func createCollectionView() -> Void {
        
        if flowLayout == nil {
            flowLayout = UICollectionViewFlowLayout.init()
            flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            flowLayout?.itemSize = PhotoSize()
            flowLayout?.minimumInteritemSpacing = 0
            flowLayout?.minimumLineSpacing = 0
        }
        
        if uvCollectionView == nil {
            uvCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: uvTopCube.frame.maxY+10, width: kWidth, height: kHeight-(uvTopCube.frame.maxY+10)), collectionViewLayout: flowLayout!)
            uvCollectionView?.dataSource = self
            uvCollectionView?.delegate = self
            uvCollectionView?.backgroundColor = UIColor.white
            self.view.addSubview(uvCollectionView!)
            uvCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        }
        
        if self.screenType == .myStories {
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
            uvCollectionView?.addGestureRecognizer(longPressGesture)
            
        }
        
    }
    
    
    
    func PhotoSize() -> CGSize {
        let photoCellSize = (kWidth/3)
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
            cube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 85)
            cube?.backgroundColor = UIColor.white
            cube?.tag = indexPath.item
            
            cell.contentView.addSubview(cube!)
            
            
            var arrMedia: [String] = []
            
            for item in objStory.media {
                //print(item)
                objStory.ParseMedia(media: item)
                if objStory.media_type.isEmpty == false {
                    arrMedia.append(objStory.thumb_url)
                }
            }
            
            
            cube?.setup(withUrls: arrMedia)
            
            
            cube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 5, y: h/2))
            cube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 2))
            
        }
        cube?.isUserInteractionEnabled = false
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == arrList.count - 1, isLoading == false {
            //current_page = current_page+1
            isLoading = true
            kAppDelegate.loadingIndicationCreation()
            APIRequest(sType: kAPIGetAllStories, data: [:])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        GotoDetailScreen(indexPath: indexPath)
    }
    
    //MARK:- Move cells delegates
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(sourceIndexPath.item)
        print(destinationIndexPath.item)
        swapCellIds(source: sourceIndexPath.item, destination: destinationIndexPath.item)
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = uvCollectionView?.indexPathForItem(at: gesture.location(in: uvCollectionView)) else {
                break
            }
            uvCollectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            uvCollectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            uvCollectionView?.endInteractiveMovement()
        default:
            uvCollectionView?.cancelInteractiveMovement()
        }
        
    }
    
    func swapCellIds(source: Int, destination: Int) {
        let ids = arrList.value(forKey: "id") as? NSArray ?? []
        let arrNewIds = NSMutableArray.init(array: ids)
        
        print(arrNewIds)
        swap(&arrNewIds[source], &arrNewIds[destination])
        
        print(arrNewIds)
        
        kAppDelegate.loadingIndicationCreationMSG(msg: "Updating")
        APIUpdateCellPosition(arrIds: arrNewIds)
    }
    //MARK:- Action Methods
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        
        let indexPath: IndexPath = (sender?.accessibilityElements![0] as? IndexPath)!
        
        GotoDetailScreen(indexPath: indexPath)
    }
    
    func GotoDetailScreen(indexPath: IndexPath) {
        let mvc = StoryPreviewViewController()
        mvc.dictInfo = arrList[indexPath.item] as! Dictionary<String, Any>
        mvc.userTYpe = screenType
        topVC?.navigationController?.pushViewController(mvc, animated: true)
    }
    
    @IBAction func NewStoryClicked(_ sender: UIButton) {
        let camVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
        self.navigationController?.pushViewController(camVC, animated: true)
    }
    
    func actGoBack() {
        delegate?.StoriesVCBackClicked()
        self.goBack()
    }
    
    //MARK:- APIS Handling
    
    func APIRequest(sType: String, data: Dictionary<String, Any>) -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        kBQ_MyStoryQueue.async {
            
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
                            kAppDelegate.hideLoadingIndicator()
                            //self.arrList = NSMutableArray.init(array: stories)
                        }
                        self.isLoading = false
                        //self.tblMainTable?.reloadData()
                        kAppDelegate.hideLoadingIndicator()
                        self.objLoader.stop()
                        if self.screenType == .myStories {
                            if self.arrList.count == 0 {
                                //                                if self.isNewStoryLaunched == false{
                                //                                    self.NewStoryClicked(UIButton())
                                //                                    self.isNewStoryLaunched = true
                                //                                } else{
                                //                                    self.goBack()
                                //                                }
                            }
                        }
                    }
                }
                else {
                    kAppDelegate.hideLoadingIndicator()
                    self.objLoader.stop()
                }
            }
            
        }
    }
    
    
    //MARK:- Move cells API
    
    func APIUpdateCellPosition(arrIds: NSMutableArray) {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        kBQ_UpdatePosition.async {
            let dictAction: NSDictionary
            
            if self.screenType == .myStories {
                dictAction = [
                    "action": kAPIArrangeStory,
                    "ids": arrIds.componentsJoined(by: ",")
                ]
                
                let arrResponse = self.objDataS.PostRequestToServer(dictAction: dictAction)
                
                if (arrResponse.count) > 0 {
                    kAppDelegate.hideLoadingIndicator()
                    DispatchQueue.main.async {
                        self.reloadGrid()
                    }
                }
                else {
                    kAppDelegate.hideLoadingIndicator()
                    DispatchQueue.main.async {
                        self.reloadGrid()
                    }
                }
            }
        }
    }
}
