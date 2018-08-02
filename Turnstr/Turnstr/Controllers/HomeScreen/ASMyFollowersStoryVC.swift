//
//  ASMyFollowersStoryVC.swift
//  Turnstr
//
//  Created by Mr. X on 10/04/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class ASMyFollowersStoryVC: ParentViewController {

    var delegates: ASSearchDelegate?
    
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var uvCollection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
//    var arrMembers: [UserModel] = []
    var arrStories: [StoryModel] = []
    var arrAllData: [Dictionary<String, Any>] = []
    var pageNumber: Int = 1
    
    
    
    var txtSearchText: String = ""
    //var uvCollectionView: UICollectionView?
    //var flowLayout: UICollectionViewFlowLayout?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        createCollectionView()
        
        tableView.estimatedRowHeight = kWidth
        tableView.rowHeight = UITableViewAutomaticDimension
        searchStoryResults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func createCollectionView() -> Void {
//
//        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//        flowLayout?.itemSize = PhotoSize()
//        flowLayout?.minimumInteritemSpacing = 0
//        flowLayout?.minimumLineSpacing = 0
//
//        uvCollection?.backgroundColor = UIColor.white
//        uvCollection?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//
//    }
    
    
    func PhotoSize() -> CGSize {
        let photoCellSize = (kWidth)
        return CGSize(width: photoCellSize, height: photoCellSize)
    }
    
    func showPreviewView(_ index: Int) {
        let mvc = StoryPreviewViewController()
        if arrAllData.count > index {
            mvc.dictInfo = arrAllData[index]
        }
        topVC?.navigationController?.pushViewController(mvc, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
////        if section == 0 {
////            return arrMembers.count
////        }
//        return arrStories.count
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        if kind == UICollectionElementKindSectionFooter {
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myClass", for: indexPath)
//
//            headerView.backgroundColor = kBlueColor
//            return headerView
//        }
//        return FooterCollectionReusableView()
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//
//        //objStory.ParseStoryData(dict: arrList[indexPath.row] as! Dictionary<String, Any>)
//
//        var cube = cell.contentView.viewWithTag(indexPath.item) as? AITransformView
//
//        if cube == nil {
//            cube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kWidth), cube_size: kWidth * 2/3)
//            cube?.createCubewith(kWidth * 2/3)
//            cube?.backgroundColor = UIColor.white
//            cube?.tag = indexPath.item
//
//            cell.contentView.addSubview(cube!)
//
//
//            var arrMedia: [String] = []
//
////            if indexPath.section == 0 {
////                let member  = arrMembers[indexPath.item]
////                arrMedia.append(member.avatar_face1 ?? "")
////                arrMedia.append(member.avatar_face2 ?? "")
////                arrMedia.append(member.avatar_face3 ?? "")
////                arrMedia.append(member.avatar_face4 ?? "")
////                arrMedia.append(member.avatar_face5 ?? "")
////                arrMedia.append(member.avatar_face6 ?? "")
////
////            } else {
////                let story  = arrStories[indexPath.item]
////                for media in story.media! {
////                    arrMedia.append(media.thumb_url ?? "")
////                }
////            }
//            let story  = arrStories[indexPath.item]
//            for media in story.media! {
//                arrMedia.append(media.thumb_url ?? "")
//            }
//
//            cube?.setup(withUrls: arrMedia)
//
//
//            cube?.setScroll(CGPoint.init(x: 0, y: kWidth/2), end: CGPoint.init(x: 5, y: kWidth/2))
//            cube?.setScroll(CGPoint.init(x: kWidth/2, y: 0), end: CGPoint.init(x: kWidth/2, y: 2))
//
//        }
//        cube?.isUserInteractionEnabled = false
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
//        //tap.delegate = self
//        tap.accessibilityElements = [indexPath]
//        tap.numberOfTapsRequired = 1
//        cube?.addGestureRecognizer(tap)
//
//        cube?.isExclusiveTouch = true
//
//        cell.layer.masksToBounds = true
//        cell.layer.borderWidth = 1.0
//        cell.layer.borderColor = UIColor.init("F3F3F3").cgColor
//
//
//        if pageNumber == 1, indexPath.item == arrStories.count-1 {
//            pageNumber = pageNumber+1
//            searchStoryResults()
//        }
//        return cell
//    }
    
    
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("selected")
//
//        let mvc = StoryPreviewViewController()
//        if arrAllData.count > indexPath.item {
//            mvc.dictInfo = arrAllData[indexPath.item]
//        }
//
//        topVC?.navigationController?.pushViewController(mvc, animated: true)
//
////        if indexPath.section == 0 {
////
////            let member = arrMembers[indexPath.item]
////            let storyboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
////            if let profileVC = storyboard.instantiateViewController(withIdentifier: "PublicProfileCollectionViewController") as? PublicProfileCollectionViewController {
////                profileVC.profileId = member.id
////                self.navigationController?.pushViewController(profileVC, animated: true)
////            }
////
////
////        } else {
////            let mvc = StoryPreviewViewController()
////            if arrAllData.count > indexPath.item {
////                mvc.dictInfo = arrAllData[indexPath.item]
////            }
////
////            topVC?.navigationController?.pushViewController(mvc, animated: true)
////        }
//
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (tableView.contentOffset.y >= (tableView.contentSize.height - scrollView.frame.size.height)) {
            pageNumber = pageNumber+1
            searchStoryResults()
        }
    }
    
    //MARK:- Move cells delegates
    //MARK:- Action Methods
    
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        guard let index = sender?.view?.tag else {return}
        showPreviewView(index)
    }
    
}

//MARK: ----- UITableViewDelegate, UITableViewDataSource
extension ASMyFollowersStoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCubeCell") as? StoryCubeCell else { fatalError("Cell with id StoryCubeCell is not exists.")}
        cell.cubeView?.createCubewith(kWidth * 1/2)
        cell.cubeView?.backgroundColor = .white
        cell.cubeView?.tag = indexPath.row
        let story  = arrStories[indexPath.row]
        var arrMedia: [String] = []
        for media in story.media! {
            arrMedia.append(media.thumb_url ?? "")
        }
        cell.cubeView?.setup(withUrls: arrMedia)
        cell.cubeView?.setScrollFromNil(CGPoint.init(x: 0, y: kWidth/2), end: CGPoint.init(x: 5, y: kWidth/2))
        cell.cubeView?.setScroll(CGPoint.init(x: kWidth/2, y: 0), end: CGPoint.init(x: kWidth/2, y: 2))
        cell.cubeView?.isUserInteractionEnabled = true
        cell.selectionStyle = .none
        if arrAllData.count > indexPath.row {
            cell.storyInfo = arrAllData[indexPath.row]
        }
        cell.updateOnLikeStatusChanged = { (dict) in
            if let dict = dict {
                self.arrAllData[indexPath.row] = dict
            }
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        cell.cubeView?.addGestureRecognizer(tapGesture)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPreviewView(indexPath.row)
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
                        
                        let dictMapper = ["statusCode": statusCode, "stories": dictComments["stories"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[StoryModel]>(JSON: dictMapper)
                        if let stories = dictComments["stories"] as? [Dictionary<String, Any>] {
                            self.arrAllData.append(contentsOf: stories)
                        }
                        if let storyArray = ksResponse?.response {
                            var j = self.arrStories.count
                            
                            for object in storyArray {
                                self.arrStories.append(object)
//                                let indexPath = IndexPath.init(row: j, section: 1)
//                                self.uvCollection.insertItems(at: [indexPath])
//                                j = j+1
                            }
                        }
                    }
                } else {
                    kAppDelegate.hideLoadingIndicator()
                }
                self.tableView.reloadData()
                //self.uvCollection.reloadData()
                
            }
        }
    }
}
