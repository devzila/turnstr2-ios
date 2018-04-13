//
//  ASMyFollowersStoryVC.swift
//  Turnstr
//
//  Created by Mr. X on 10/04/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class ASMyFollowersStoryVC: ParentViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var delegates: ASSearchDelegate?
    
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var uvCollection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var arrMembers: [UserModel] = []
    var arrStories: [StoryModel] = []
    var arrAllData: [Dictionary<String, Any>] = []
    var pageNumber: Int = 1
    
    
    
    var txtSearchText: String = ""
    //var uvCollectionView: UICollectionView?
    //var flowLayout: UICollectionViewFlowLayout?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createCollectionView()
        
        searchStoryResults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createCollectionView() -> Void {
        
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        flowLayout?.itemSize = PhotoSize()
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.minimumLineSpacing = 0
        
        
        uvCollection?.dataSource = self
        uvCollection?.delegate = self
        uvCollection?.backgroundColor = UIColor.white
        uvCollection?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
    }
    
    
    func PhotoSize() -> CGSize {
        let photoCellSize = (kWidth/3)
        return CGSize(width: photoCellSize, height: photoCellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0 {
            return arrMembers.count
        }
        return arrStories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionElementKindSectionFooter {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myClass", for: indexPath)
            
            headerView.backgroundColor = kBlueColor
            return headerView
        }
        return FooterCollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //objStory.ParseStoryData(dict: arrList[indexPath.row] as! Dictionary<String, Any>)
        
        
        let w: CGFloat = PhotoSize().width
        let h: CGFloat = PhotoSize().height
        var cube = cell.contentView.viewWithTag(indexPath.item) as? AITransformView
        
        if cube == nil {
            cube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 85)
            cube?.backgroundColor = UIColor.white
            cube?.tag = indexPath.item
            
            cell.contentView.addSubview(cube!)
            
            
            var arrMedia: [String] = []
            
            if indexPath.section == 0 {
                let member  = arrMembers[indexPath.item]
                arrMedia.append(member.avatar_face1 ?? "")
                arrMedia.append(member.avatar_face2 ?? "")
                arrMedia.append(member.avatar_face3 ?? "")
                arrMedia.append(member.avatar_face4 ?? "")
                arrMedia.append(member.avatar_face5 ?? "")
                arrMedia.append(member.avatar_face6 ?? "")
                
            } else {
                let story  = arrStories[indexPath.item]
                for media in story.media! {
                    arrMedia.append(media.thumb_url ?? "")
                }
            }
            
            
            
            cube?.setup(withUrls: arrMedia)
            
            
            cube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 5, y: h/2))
            cube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 2))
            
        }
        cube?.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
        //tap.delegate = self
        tap.accessibilityElements = [indexPath]
        tap.numberOfTapsRequired = 1
        cube?.addGestureRecognizer(tap)
        
        cube?.isExclusiveTouch = true
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.init("F3F3F3").cgColor
        
        
        if pageNumber == 1, indexPath.section == 1, indexPath.item == arrStories.count-1 {
            pageNumber = pageNumber+1
            searchStoryResults()
        }
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        
        
        
        if indexPath.section == 0 {
            
            let member = arrMembers[indexPath.item]
            let storyboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
            if let profileVC = storyboard.instantiateViewController(withIdentifier: "PublicProfileCollectionViewController") as? PublicProfileCollectionViewController {
                profileVC.profileId = member.id
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
            
            
        } else {
            let mvc = StoryPreviewViewController()
            if arrAllData.count > indexPath.item {
                mvc.dictInfo = arrAllData[indexPath.item]
            }
            
            topVC?.navigationController?.pushViewController(mvc, animated: true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= (uvCollection.contentSize.height - scrollView.frame.size.height)) {
            pageNumber = pageNumber+1
            searchStoryResults()
        }
    }
    
    //MARK:- Move cells delegates
    //MARK:- Action Methods
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        
        //let indexPath: IndexPath = (sender?.accessibilityElements![0] as? IndexPath)!
        
        //GotoDetailScreen(indexPath: indexPath)
    }
    
}
extension ASMyFollowersStoryVC {
    func searchStoryResults() {
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        
        //http://18.218.6.149/v1/stories
        
        let strPostUrl = "stories?page=\(pageNumber)"//"search?keyword=a"
        let strParType = ""
        
        DispatchQueue.global().async {
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        
                        if let stories = dictComments["stories"] as? [Dictionary<String, Any>] {
                            self.arrAllData.append(contentsOf: stories)
                        }
                        //self.arrAllData = dictComments
                        
                        let dictMapper1 = ["statusCode": statusCode, "user": dictComments["members"] ?? ""] as [String : Any]
                        let ksResponse1 = KSResponse<[UserModel]>(JSON: dictMapper1)
                        
                        
                        let dictMapper = ["statusCode": statusCode, "stories": dictComments["stories"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[StoryModel]>(JSON: dictMapper)
                        
                        if let memberArray = ksResponse1?.response {
                            var j = self.arrMembers.count
                            for object in memberArray {
                                self.arrMembers.append(object)
                                
                                let indexPath = IndexPath.init(row: j, section: 0)
                                self.uvCollection.insertItems(at: [indexPath])
                                j = j+1
                            }
                            
                        }
                        
                        if let storyArray = ksResponse?.response {
                            
                            var j = self.arrStories.count
                            
                            for object in storyArray {
                                self.arrStories.append(object)
                                let indexPath = IndexPath.init(row: j, section: 1)
                                self.uvCollection.insertItems(at: [indexPath])
                                j = j+1
                            }
                        }
                    }
                } else {
                    kAppDelegate.hideLoadingIndicator()
                }
                
                //self.uvCollection.reloadData()
                
            }
        }
    }
}
