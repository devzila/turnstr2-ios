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
    @IBOutlet weak var shortStoryCollection: UICollectionView!
    
    var arrayUsers: [User] = []
    var arrStories: [StoryModel] = []
    var arrAllData: [Dictionary<String, Any>] = []
    var pageNumber: Int = 1
    var storiesAllPages: Int = 1
    var currentPage: Int = 1
    var totalPages: Int = 1
    var current_user_story_count: Int = 0
    
    
    var txtSearchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = kWidth
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: "UserStoryCell", bundle: nil)
        shortStoryCollection.register(nib, forCellWithReuseIdentifier: "UserStoryCell")
        
        let headerNib = UINib(nibName: "MyProfileReusableViewCollectionReusableView", bundle: nil)
        shortStoryCollection.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MyProfileReusableViewCollectionReusableView")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.searchStoryResults()
            self?.apiLoadStories()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
    //MARK:- Move cells delegates
    //MARK:- Action Methods
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        guard let index = sender?.view?.tag else {return}
        showPreviewView(index)
    }
    
    @IBAction func btnChatAction() {
        guard let vc = Storyboards.chatStoryboard.initialVC() else { return }
        present(vc, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (arrStories.count - 1) {
            if pageNumber < storiesAllPages {
                pageNumber += 1
                searchStoryResults()
            }
        }
    }
}

//MARK: ----- UICollectionViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ASMyFollowersStoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserStoryCell", for: indexPath) as? UserStoryCell else { fatalError("UserStoryCell is missing.")}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            cell.user = self.arrayUsers[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MyProfileReusableViewCollectionReusableView", for: indexPath) as? MyProfileReusableViewCollectionReusableView else { return UICollectionReusableView() }
        header.updateStory()
        header.current_user_story_count = current_user_story_count
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = arrayUsers[indexPath.item]
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShortStoryVC") as? ShortStoryVC else { return }
        vc.user = user
        topVC?.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (arrayUsers.count - 1) {
            if currentPage < totalPages {
                currentPage += 1
                apiLoadStories()
            }
        }
    }
    
}
extension ASMyFollowersStoryVC {
    func searchStoryResults() {
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        
        let strPostUrl = "stories?page=\(pageNumber)"//"search?keyword=a"
        let strParType = ""
        
        DispatchQueue.global().async {
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strPostUrl, parType: strParType)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        
                        let dictMapper = ["statusCode": statusCode, "stories": dictComments["stories"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[StoryModel]>(JSON: dictMapper)
                        if let stories = dictComments["stories"] as? [Dictionary<String, Any>] {
                            self.arrAllData.append(contentsOf: stories)
                        }
                        if let page = dictComments["current_page"] as? Int {
                            self.pageNumber = page
                        }
                        if let totalPages = dictComments["total_pages"] as? Int {
                            self.storiesAllPages = totalPages
                        }
                        if let storyArray = ksResponse?.response {
                            for object in storyArray {
                                self.arrStories.append(object)
                            }
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    kAppDelegate.hideLoadingIndicator()
                }
                self.tableView.reloadData()
                
            }
        }
    }
    
    func apiLoadStories() {
        let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: "user/user_stories?page=\(currentPage)", parType: "")
        if currentPage == 1 {
            arrayUsers = [User]()
        }
        DispatchQueue.main.async {
            if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                kAppDelegate.hideLoadingIndicator()
                
                if let data = dictResponse["data"]?["data"] as? [String: AnyObject] {
                    if let page = data["current_page"] as? Int {
                        self.currentPage = page
                    }
                    if let page = data["total_pages"] as? Int {
                        self.totalPages = page
                    }
                    if let objs = data["users"] as? [Any] {
                        for obj in objs {
                            let user = User(withStoryInfo: obj as? [String: Any])
                            self.arrayUsers.append(user)
                        }
                        self.shortStoryCollection.reloadData()
                    }
                    
                    if let story_count = data["current_user_story_count"] as? Int {
                        self.current_user_story_count = story_count
                    }
                }
            } else {
                kAppDelegate.hideLoadingIndicator()
            }
            self.shortStoryCollection.reloadData()
        }
    }
}
