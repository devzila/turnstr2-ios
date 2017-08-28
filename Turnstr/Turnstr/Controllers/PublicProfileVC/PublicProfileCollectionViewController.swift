//
//  PublicProfileCollectionViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 10/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class PublicProfileCollectionViewController: ParentViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ServiceUtility, Fave5CellDelegate, UISearchBarDelegate, UserStoryDelegate, TurntStoryDelegate {
    
    var transformView: AITransformView?
    var topCube: AITransformView?
    var profileDetail: UserModel?
    var profileDict = [[String:Any]]()
    var profileId: Int?
    
    @IBOutlet weak var collViewPublicProfile: UICollectionView!
    @IBOutlet weak var viewPreferences: UIView!
    
    @IBOutlet weak var lblPostLeft: UILabel!
    @IBOutlet weak var lblPostRight: UILabel!
    @IBOutlet weak var uvTopCube: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnFamily: button!
    @IBOutlet weak var btnFave5: button!
    @IBOutlet weak var constraintImgVwLogoX: NSLayoutConstraint!

    
    var isFave5LoadNext = false
    var pageNumberFave5 = 1
    var arrFav5 = [UserModel]()
    
    var isUserStoriesLoadNext = false
    var isFromFeeds = false
    var pageNumberUserStories = 1
    var arrUserStories = [StoryModel]()

    
    var pageSearchResult = 1
    var isSearching = false
    var isSearchingStoriesLoadNext = false
    
    var isMemberLoadNext = false
    var pageNumberMember = 1
    var arrMembers = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pageNumberFave5 = 1
        arrFav5.removeAll()
        pageNumberUserStories = 1
        arrUserStories.removeAll()
        profileDict.removeAll()
        
        setPullToRefreshOnCollView()
        
        searchBar.showsCancelButton = false
        
        
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSForegroundColorAttributeName: UIColor(hexString: "00C7FF")]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributeDict)
        }
        
        
        guard let userID = profileId else { return }
        
        viewPreferences.isHidden = isFromFeeds
        
        if getUserId() == userID {
            viewPreferences.isHidden = true
        } else {
            viewPreferences.isHidden = false
        }
        
        searchBar.isHidden = !isFromFeeds
        
//        uvTopCube.isHidden = isFromFeeds
        lblPostLeft.isHidden = isFromFeeds
        lblPostRight.isHidden = isFromFeeds
        
//        if isFromFeeds {
//            constraintImgVwLogoX.constant = (view.frame.size.width - 120)/2
//        }
        
        getMemberDetails(id: userID) { (response) in
            if let objModel = response?.response {
                self.profileDetail = objModel
                let postTitle: NSMutableAttributedString = NSMutableAttributedString.init(string: "posts\nfollowers\nfamily")
                postTitle.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle.length))
                postTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postTitle.length))
                
                let style = NSMutableParagraphStyle()
                style.alignment = .right
                postTitle.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postTitle.length))
                
                self.lblPostLeft.attributedText = postTitle
                
                
                let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(objModel.post_count ?? 0)\n\(objModel.follower_count ?? 0)\n\(objModel.family_count ?? 0)")
                postDetail.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
                postDetail.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
                style.alignment = .left
                
                postDetail.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postDetail.length))
                
                self.lblPostRight.attributedText = postDetail
                
                self.setUserCube(objModel: objModel)
                
                if objModel.favourite! {
                    self.btnFave5.backgroundColor = UIColor(hexString: "00C7FF")
                    self.btnFave5.setTitleColor(UIColor.white, for: .normal)
                    self.btnFave5.isSelected = true
                } else {
                    self.btnFave5.backgroundColor = UIColor.white
                    self.btnFave5.setTitleColor(UIColor(hexString: "00C7FF"), for: .normal)
                    self.btnFave5.isSelected = false
                }
                
                if objModel.following_me! {
                    self.btnFamily.isHidden = false
                } else {
                    self.btnFamily.isHidden = true
                }
                self.getFave5List(page: self.pageNumberFave5)
                self.getAllStories(page: self.pageNumberUserStories, isAllStories: self.isFromFeeds)
                if self.getUserId() == userID && !self.isFromFeeds {
                    self.getAllMembersData()
                }
            }
        }
    }
    
    deinit {
        self.collViewPublicProfile.dg_removePullToRefresh()
    }

    // MARK: Pull to refresh & Infinite scrolling
    func setPullToRefreshOnCollView() {
        /// Set the loading view's indicator color
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.gray
        /// Add handler
        collViewPublicProfile.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            if kAppDelegate.checkNetworkStatus() == false {
                self?.collViewPublicProfile.dg_stopLoading()
                return
            }
            if !(self?.isSearching)! {
                self?.pageNumberFave5 = 1
                self?.arrFav5.removeAll()
                self?.pageNumberUserStories = 1
                self?.arrUserStories.removeAll()
                self?.profileDict.removeAll()
                self?.arrMembers.removeAll()
                
                self?.getFave5List(page: (self?.pageNumberFave5)!)
                self?.getAllStories(page: (self?.pageNumberUserStories)!, isAllStories: (self?.isFromFeeds)!)
                guard let userID = self?.profileId else { return }
                if self?.getUserId() == userID && !(self?.isFromFeeds)! {
                    self?.getAllMembersData()
                }
            } else {
                self?.collViewPublicProfile.dg_stopLoading()
            }
            
            }, loadingView: loadingView)
        
        /// Set the background color of pull to refresh
        collViewPublicProfile.dg_setPullToRefreshFillColor(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.937254902, alpha: 1))
        collViewPublicProfile.dg_setPullToRefreshBackgroundColor(collViewPublicProfile.backgroundColor!)
    }

    
    func addDeleteFave(favType: FavouriteType) {
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        addDeleteFave5(id: (profileDetail?.id)!, type: favType) { (response) in
            self.updateUserData()
        }
    }
    
    func updateUserData() {
        guard let userID = profileId else { return }
        getMemberDetails(id: userID) { (response) in
            if let objModel = response?.response {
                self.profileDetail = objModel
                let postTitle: NSMutableAttributedString = NSMutableAttributedString.init(string: "posts\nfollowers\nfamily")
                postTitle.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle.length))
                postTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postTitle.length))
                
                let style = NSMutableParagraphStyle()
                style.alignment = .right
                postTitle.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postTitle.length))
                
                self.lblPostLeft.attributedText = postTitle
                
                
                let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(objModel.post_count ?? 0)\n\(objModel.follower_count ?? 0)\n\(objModel.family_count ?? 0)")
                postDetail.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
                postDetail.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
                style.alignment = .left
                
                postDetail.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, postDetail.length))
                
                self.lblPostRight.attributedText = postDetail
                
                if objModel.favourite! {
                    self.btnFave5.backgroundColor = UIColor(hexString: "00C7FF")
                    self.btnFave5.setTitleColor(UIColor.white, for: .normal)
                    self.btnFave5.isSelected = true
                } else {
                    self.btnFave5.backgroundColor = UIColor.white
                    self.btnFave5.setTitleColor(UIColor(hexString: "00C7FF"), for: .normal)
                    self.btnFave5.isSelected = false
                }
                
                if objModel.following_me! {
                    self.btnFamily.isHidden = false
                } else {
                    self.btnFamily.isHidden = true
                }
            }
        }
    }

    func setUserCube(objModel: UserModel) {
        
        //
        //Top Cube View
        //
        
        topCube?.removeFromSuperview()
        topCube = nil
        
        let w: CGFloat = 95
        let h: CGFloat = 80
        
        if topCube == nil {
            
            topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: h/2 + 10)
        }
        topCube?.backgroundColor = UIColor.clear
        let arrFaces = [objModel.avatar_face1 ?? "thumb", objModel.avatar_face2 ?? "thumb", objModel.avatar_face3 ?? "thumb", objModel.avatar_face4 ?? "thumb", objModel.avatar_face5 ?? "thumb", objModel.avatar_face6 ?? "thumb"]
        topCube?.setup(withUrls: arrFaces)
        
        uvTopCube.addSubview(topCube!)
        uvTopCube.isUserInteractionEnabled = false
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 20, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))

        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFave5", for: indexPath as IndexPath) as? Fave5CollectionViewCell
            if let lblName = cell?.viewWithTag(1001) as? UILabel {
                if let profile = self.profileDetail {
                    lblName.text = profile.username != nil ? (profile.username?.uppercased())! + " FAVE 5" : "FAVE 5"
                }
            }
            
            
//            if let view = cell?.viewWithTag(2001) {
//                view.isHidden = !isFromFeeds
//            }
//            if isFromFeeds {
//                if let view = cell?.viewWithTag(1001) {
//                    for constraint in view.constraints as [NSLayoutConstraint] {
//                        if constraint.identifier == "fave5lblWidthConstraint" {
//                            constraint.constant = 0
//                        }
//                    }
//                }
//            }
            
            cell?.arrFave5 = self.arrFav5
            cell?.delegateFave5 = self
            cell?.setupCollectionView()
            return cell!
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTurntStory", for: indexPath as IndexPath) as? TurntStoriesCollectionViewCell
            cell?.delegateTurntStory = self
            cell?.arrTurntStories = self.arrUserStories
            cell?.setupCollectionView()
            return cell!
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellUserStory", for: indexPath as IndexPath) as? UserStoryCollectionViewCell
            if let lblName = cell?.viewWithTag(1001) as? UILabel {
                if let profile = self.profileDetail {
                    if let userID = profileId {
                        if isFromFeeds {
                            lblName.text = "GENERAL"
                            cell?.arrStories = self.arrUserStories
                        } else if getUserId() == userID {
                            lblName.text = "GENERAL"
                            cell?.arrMembers = self.arrMembers
                        } else {
                            lblName.text = profile.username != nil ? (profile.username?.uppercased())! + " STORIES" : "STORIES"
                            cell?.arrStories = self.arrUserStories
                        }
                    }
                }
            }
            cell?.delegateUserStory = self
            
            cell?.setupCollectionView()
            return cell!
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set collectionview cell size
        switch indexPath.row {
        case 0:
            if !isSearching {
                return CGSize(width: kWidth, height: 130)
            }
            return CGSize(width: kWidth, height: 0)
        case 1:
            return CGSize(width: kWidth, height: 130)
        case 2:
            if let userID = self.profileId, userID == self.getUserId(), !isFromFeeds , self.arrMembers.count > 0 {
                if Float(self.arrMembers.count/3) < 1 {
                    return CGSize(width: kWidth, height: CGFloat(Double(PhotoSize().height) + 80.0))
                }
                return CGSize(width: kWidth, height: CGFloat(ceil((Float(self.arrMembers.count/3))) * Float(PhotoSize().height)) + 50)
            } else if self.arrUserStories.count > 0 {
                if Float(self.arrUserStories.count/3) < 1 {
                    return CGSize(width: kWidth, height: CGFloat(Double(PhotoSize().height) + 80.0))
                }
                return CGSize(width: kWidth, height: CGFloat(ceil((Float(self.arrUserStories.count/3))) * Float(PhotoSize().height)) + 50)
            }
            
            return CGSize(width: kWidth, height: 0)
            
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collViewPublicProfile.fixedPullToRefreshViewForDidScroll()
        
        if (scrollView.contentOffset.y >= (collViewPublicProfile.contentSize.height - scrollView.frame.size.height)) {
            if !isSearching {
                if isUserStoriesLoadNext {
                    pageNumberUserStories = pageNumberUserStories+1
                    self.getAllStories(page: self.pageNumberUserStories, isAllStories: self.isFromFeeds)
                } else if isMemberLoadNext {
                    pageNumberMember = pageNumberMember + 1
                    self.getAllMembersData()
                }
            } else {
                if isSearchingStoriesLoadNext {
                    pageSearchResult = pageSearchResult+1
                    searchStoryResults()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func PhotoSize() -> CGSize {
        let photoCellSize = (kWidth/3)
        return CGSize(width: photoCellSize, height: photoCellSize)
    }

    @IBAction func btnTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTappedFamily(_ sender: UIButton) {
        guard let userID = profileDetail?.id else {
            return
        }
        addUserAsFamily(id: userID) { (response) in
            self.updateUserData()
        }
    }

    @IBAction func btnTappedFave5(_ sender: UIButton) {
        if sender.isSelected {
            addDeleteFave(favType: .delete)
            self.btnFave5.backgroundColor = UIColor.white
            self.btnFave5.setTitleColor(UIColor(hexString: "00C7FF"), for: .normal)
            self.btnFave5.isSelected = false
        } else {
            addDeleteFave(favType: .post)
            self.btnFave5.backgroundColor = UIColor(hexString: "00C7FF")
            self.btnFave5.setTitleColor(UIColor.white, for: .normal)
            self.btnFave5.isSelected = true
        }
    }
    
    func getFave5List(page: Int) {
        guard let userID = profileDetail?.id else {
            return
        }
//        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        getFave5(id: userID, page: page) { (response, dict) in
            
            if let faveArray = response?.response {
                print(faveArray)
                for object in faveArray {
                    self.arrFav5.append(object)
                }
                if let _ = dict["next_page"] as? Int {
                    self.isFave5LoadNext = true
                } else {
                    self.isFave5LoadNext = false
                }
                self.collViewPublicProfile.dg_stopLoading()
                self.collViewPublicProfile.reloadItems(at: [IndexPath(row: 0, section: 0)])
            }
        }
    }
    
    func getAllStories(page: Int, isAllStories: Bool) {
        guard let userID = profileDetail?.id else {
            return
        }
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        getSpecificUserStories(id: userID, page: pageNumberUserStories, isAllStories: isAllStories) { (response, dict) in
            kAppDelegate.hideLoadingIndicator()

            if let storyArray = response?.response {
                print(storyArray)
                for object in storyArray {
                    self.arrUserStories.append(object)
                }
                if let arrStories = dict["stories"] as? Array<Dictionary<String, Any>> {
                    for object in arrStories {
                        self.profileDict.append(object)
                    }
                    
                }
                if let _ = dict["next_page"] as? Int {
                    self.isUserStoriesLoadNext = true
                } else {
                    self.isUserStoriesLoadNext = false

                }
                self.collViewPublicProfile.dg_stopLoading()
                self.collViewPublicProfile.reloadItems(at: [IndexPath(row: 1, section: 0)])
                self.collViewPublicProfile.reloadItems(at: [IndexPath(row: 2, section: 0)])
//                if let userID = self.profileId, userID == self.getUserId() {
//                    self.collViewPublicProfile.reloadItems(at: [IndexPath(row: 2, section: 0)])
//                }
            }
        }
    }
    
    func cellTappedAtIndex(index: Int) {
        let storyboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "PublicProfileCollectionViewController") as? PublicProfileCollectionViewController {
            profileVC.profileId = self.arrFav5[index].id ?? nil
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    
    func cellUserStoryTappedAtIndex(index: Int) {
        if let userID = profileId, userID == self.getUserId() {
            let mvc = StoryPreviewViewController()
            mvc.dictInfo = (self.profileDict[index])
            self.navigationController?.pushViewController(mvc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
            if let profileVC = storyboard.instantiateViewController(withIdentifier: "PublicProfileCollectionViewController") as? PublicProfileCollectionViewController {
                profileVC.profileId = self.arrMembers[index].id ?? nil
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        isSearching = true
        self.arrUserStories.removeAll()
        self.profileDict.removeAll()
        searchStoryResults()
        collViewPublicProfile.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        isSearching = false
        self.pageNumberUserStories = 1
        self.arrUserStories.removeAll()
        self.profileDict.removeAll()
        searchBar.text = ""
        self.getAllStories(page: self.pageNumberUserStories, isAllStories: self.isFromFeeds)
    }
    
    func searchStoryResults() {
        kAppDelegate.loadingIndicationCreationMSG(msg: "Searching...")
        searchStories(page: pageSearchResult, strSearch: searchBar.text!) { (response, dictResponse) in
            kAppDelegate.hideLoadingIndicator()
            
            if let storyArray = response?.response {
                print(storyArray)
                for object in storyArray {
                    self.arrUserStories.append(object)
                }
                if let arrStories = dictResponse["stories"] as? Array<Dictionary<String, Any>> {
                    for object in arrStories {
                        self.profileDict.append(object)
                    }
                    
                }
                if let _ = dictResponse["next_page"] as? Int {
                    self.isSearchingStoriesLoadNext = false
                } else {
                    self.isSearchingStoriesLoadNext = false
                    
                }
                self.collViewPublicProfile.reloadData()
            }
        }
    }
    
    func cellTurntStoryTappedAtIndex(index: Int) {
        
    }
    
    func getAllMembersData() {
        getAllMember(page: pageNumberMember) { (response, dict) in
            kAppDelegate.hideLoadingIndicator()
            
            if let memberArray = response?.response {
                print(memberArray)
                for object in memberArray {
                    self.arrMembers.append(object)
                }
                
                if let _ = dict["next_page"] as? Int {
                    self.isMemberLoadNext = true
                } else {
                    self.isMemberLoadNext = false
                    
                }
                self.collViewPublicProfile.dg_stopLoading()
                self.collViewPublicProfile.reloadItems(at: [IndexPath(row: 2, section: 0)])
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


