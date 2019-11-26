//
//  PublicProfileCollectionViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 10/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import AVKit
import KSPhotoBrowser

class PublicProfileCollectionViewController: ParentViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ServiceUtility, Fave5CellDelegate, UISearchBarDelegate, UserStoryDelegate, TurntStoryDelegate {
    
    let nonGridCellHeight: CGFloat = 400
    
    var transformView: AITransformView?
    var topCube: AITransformView?
    var profileDetail: UserModel?
    var profileDict = [[String:Any]]()
    var profileId: Int?
    
    var isGridOn: Bool = true
    
    
    @IBOutlet weak var collViewPublicProfile: UICollectionView!
    @IBOutlet weak var viewPreferences: UIView!
    
    @IBOutlet weak var lblPostLeft: UILabel!
    @IBOutlet weak var lblPostRight: UILabel!
    @IBOutlet weak var bgImageView: UIImageView?
    @IBOutlet weak var uvTopCube: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnFamily: button!
    @IBOutlet weak var btnFave5: button!
    @IBOutlet weak var constraintImgVwLogoX: NSLayoutConstraint!
    
    @IBOutlet weak var lblTopUserName: UILabel!
    @IBOutlet weak var btnNameVerified: UIButton!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var btnNameVerifiedHeight: NSLayoutConstraint!
    @IBOutlet weak var lblBioHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var btnNoGrid: UIButton!
    
    var isFave5LoadNext = false
    var pageNumberFave5 = 1
    var arrFav5 = [UserModel]()
    var arrMyStories: [UserStories] = []
    
    
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
        
        objDataS.getUserProfileData { (received) in
            
        }
        
        
        // Do any additional setup after loading the view.
        pageNumberFave5 = 1
        arrFav5.removeAll()
        pageNumberUserStories = 1
        arrUserStories.removeAll()
        profileDict.removeAll()
        
        setPullToRefreshOnCollView()
        
        searchBar.showsCancelButton = false
        
        
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor(hexString: "E8E8E8")
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "00C7FF")]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributeDict)
        }
        
        
        guard let userID = profileId else { return }
        
        viewPreferences.isHidden = isFromFeeds
        
        if isFromFeeds {
            constraintImgVwLogoX.constant = (view.frame.size.width - 120)/2
            
            btnNameVerifiedHeight.constant = 0
            lblBioHeight.constant = 0
            
        }
        
        btnNameVerified.isHidden = isFromFeeds
        lblBio.isHidden = isFromFeeds
        lblTopUserName.isHidden = isFromFeeds
        
        lblPostLeft.isHidden = isFromFeeds
        lblPostRight.isHidden = isFromFeeds
        
        if getUserId() == userID {
            viewPreferences.isHidden = true
            uvTopCube.isHidden = true
            lblPostLeft.isHidden = true
            lblPostRight.isHidden = true
            
        } else {
            viewPreferences.isHidden = false
            uvTopCube.isHidden = false
            
        }
        
        searchBar.isHidden = !isFromFeeds
        
        
        getMemberDetails(id: userID) { (response) in
            if let objModel = response?.response {
                self.profileDetail = objModel
                
                //Setup Name & Bio
                self.btnNameVerified.setTitle("\(objModel.first_name?.uppercased() ?? "") \(objModel.last_name?.uppercased() ?? "") ", for: .normal)
                self.lblTopUserName.text = "@\(objModel.username?.lowercased() ?? "")"
                
                let strBio = "\(objModel.bio ?? "")"
                self.lblBio.attributedText = strBio.attributtedString(appendString: "\n\(objModel.website ?? "")", color1: .black, color2: kBlueColor, font1: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular), font2: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular))
                if objModel.website == nil || objModel.website?.isEmpty == true {
                    self.lblBioHeight.constant = 30
                    self.lblBio.layoutIfNeeded()
                }
                if let bgImage = objModel.bgImage, let url = bgImage.url {
                    self.bgImageView?.sd_setImage(with: url)
                }
                
                ///Setup "posts followers following"
                let postTitle: NSMutableAttributedString = NSMutableAttributedString.init(string: "posts\nfollowers\nfollowing")
                postTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle.length))
                postTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, postTitle.length))
                
                let style = NSMutableParagraphStyle()
                style.alignment = .right
                postTitle.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, postTitle.length))
                
                self.lblPostLeft.attributedText = postTitle
                
                
                let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(objModel.post_count ?? 0)\n\(objModel.follower_count ?? 0)\n\(objModel.family_count ?? 0)")
                postDetail.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
                postDetail.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
                style.alignment = .left
                
                postDetail.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, postDetail.length))
                
                self.lblPostRight.attributedText = postDetail
                
                self.setUserCube(objModel: objModel)
                
                if objModel.is_verified == 0 {
                    self.btnNameVerified.setImage(nil, for: .normal)
                } else {
                    self.btnNameVerified.setImage(#imageLiteral(resourceName: "nw_star"), for: .normal)
                }
                if self.getUserId() == userID {
                    self.btnNameVerified.setImage(nil, for: .normal)
                }
                
                
                if objModel.favourite! {
                    self.btnFave5.backgroundColor = UIColor(hexString: "00C7FF")
                    self.btnFave5.setTitleColor(UIColor.white, for: .normal)
                    self.btnFave5.isSelected = true
                } else {
                    self.btnFave5.backgroundColor = UIColor.white
                    self.btnFave5.setTitleColor(UIColor(hexString: "00C7FF"), for: .normal)
                    self.btnFave5.isSelected = false
                }
                self.btnFamily.isHidden = "\(objModel.id!)" == self.objSing.strUserID ? true : false
                if objModel.following == true {
                    self.btnFamily.isSelected = true
                    //self.btnFamily.isHidden = false
                } else {
                    self.btnFamily.isSelected = false
                    //self.btnFamily.isHidden = true
                }
                
                
                if self.objSing.strUserID == "\(userID)" {
                    self.getPopularList(page: 0)
                    self.getAllMyStoriesHomePage(userId: userID)
                } else{
                    self.getFave5List(page: self.pageNumberFave5)
                    self.getAllMyStoriesHomePage(userId: userID)
                }
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
                
                //self?.getFave5List(page: (self?.pageNumberFave5)!)
                self?.getAllStories(page: (self?.pageNumberUserStories)!, isAllStories: (self?.isFromFeeds)!)
                guard let userID = self?.profileId else { return }
                
                if self?.objSing.strUserID == "\(userID)" {
                    self?.getPopularList(page: 0)
                } else{
                    self?.getFave5List(page: (self?.pageNumberFave5)!)
                }
                
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
                postTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle.length))
                postTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, postTitle.length))
                
                let style = NSMutableParagraphStyle()
                style.alignment = .right
                postTitle.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, postTitle.length))
                
                self.lblPostLeft.attributedText = postTitle
                
                
                let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(objModel.post_count ?? 0)\n\(objModel.follower_count ?? 0)\n\(objModel.family_count ?? 0)")
                postDetail.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
                postDetail.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
                style.alignment = .left
                
                postDetail.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, postDetail.length))
                
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
        let arrFaces = [objModel.avatar_face1 ?? "", objModel.avatar_face2 ?? "", objModel.avatar_face3 ?? "", objModel.avatar_face4 ?? "", objModel.avatar_face5 ?? "", objModel.avatar_face6 ?? ""]
        
        topCube?.setup(withUrls: arrFaces)
        
        uvTopCube.addSubview(topCube!)
        //uvTopCube.isUserInteractionEnabled = false
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 20, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
        
        
    }
    
    //MARK: => Custom Methods
    private func followOrUnfollow() {
        guard let userID = self.profileDetail?.id else {
            return
        }
        kAppDelegate.loadingIndicationCreation()
        let isFollowing = (self.profileDetail?.following == true)
        if isFollowing { //user already followed now unfollow him
            self.profileDetail?.following = false
            self.unFollowUser(id: userID)

        } else { // user not followed , follow him
            self.profileDetail?.following = true
            self.followUser(id: userID)
        }
    }
    
    private func pushToFollowingFollowersList(for following: Bool) {
        guard let vc = Storyboards.photoStoryboard.initialVC(with: .listFollowingFollowersVC) as? ListFollowingFollowersVC,
            let userId = self.profileDetail?.id else { return }
        vc.isForFollowing = following
        vc.userId = userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:-
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
            
            if let view = cell?.viewWithTag(2001) {
                view.isHidden = true
                //view.isHidden = false //!isFromFeeds
            }
            if isFromFeeds {
                if let view = cell?.viewWithTag(1001) {
                    for constraint in view.constraints as [NSLayoutConstraint] {
                        if constraint.identifier == "fave5lblWidthConstraint" {
                            constraint.constant = 0
                        }
                    }
                }
            }
            
            if let lblName = cell?.viewWithTag(1001) as? UILabel {
                //if let lblName = cell?.viewWithTag(2022) as? UILabel {
                if isFromFeeds {
                    lblName.text = "POPULAR"
                } else {
                    if let profile = self.profileDetail {
                        lblName.text = profile.username != nil ? (profile.username?.uppercased())! + " FAVE 5" : "FAVE 5"
                    }
                }
            }
            cell?.arrFave5 = self.arrFav5
            cell?.delegateFave5 = self
            cell?.setupCollectionView()
            return cell!
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTurntStory", for: indexPath as IndexPath) as? TurntStoriesCollectionViewCell
            cell?.delegateTurntStory = self
            cell?.arrTurntStories = self.arrMyStories
            cell?.setupCollectionView()
            return cell!
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellUserStory", for: indexPath as IndexPath) as? UserStoryCollectionViewCell
            if isGridOn == false {
                cell?.photoCellSizeWidth = kWidth
                cell?.photoCellSizeHeight = nonGridCellHeight
                cell?.cube_size = 250
            } else {
                cell?.photoCellSizeWidth = (kWidth/3)-10
                cell?.photoCellSizeHeight = (kWidth/3)-10
                cell?.cube_size = 0
            }
            
            cell?.collViewUserStory.reloadData()
            
            if let lblName = cell?.viewWithTag(1001) as? UILabel {
                if let profile = self.profileDetail {
                    if let userID = profileId {
                        if isFromFeeds {
                            lblName.text = isSearching ? "SEARCH" : "GENERAL"
                            if isSearching == true {
                                //print(self.arrMembers.count)
                                //print(self.arrMembers)
                                cell?.arrMembers = self.arrMembers
                            } else {
                                cell?.arrStories = self.arrUserStories
                            }
                            
                        } else if getUserId() == userID {
                            lblName.text = "GENERAL"
                            cell?.arrMembers = self.arrMembers
                        } else {
                            lblName.text = "GENERAL"
                            //lblName.text = profile.username != nil ? (profile.username?.uppercased())! + " STORIES" : "STORIES"
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
            if !isSearching {
                return CGSize(width: kWidth, height: (kWidth/3)+30)
            }
            return CGSize(width: kWidth, height: 0)
        case 2:
            if let userID = self.profileId, userID == self.getUserId(), !isFromFeeds , self.arrMembers.count > 0 {
                if Float(self.arrMembers.count/3) < 1 {
                    return CGSize(width: kWidth, height: CGFloat(Double(PhotoSize().height) + 80.0))
                }
                return CGSize(width: kWidth, height: CGFloat(ceil(Float(self.arrMembers.count)/3) * Float(PhotoSize().height)) + 30)
            } else if self.arrUserStories.count > 0 {
                if Float(self.arrUserStories.count/3) < 1 {
                    return CGSize(width: kWidth, height: CGFloat(Double(PhotoSize().height) + 80.0))
                }
                
                if isGridOn == true {
                    return CGSize(width: kWidth, height: CGFloat(ceil(Float(self.arrUserStories.count)/3) * Float(PhotoSize().height)) + 50)
                } else {
                    let h = CGFloat(self.arrUserStories.count) * nonGridCellHeight
                    
                    return CGSize(width: kWidth, height: h)
                }
                
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
    
    //
    //MARK:- Grid Buttons Action Methods
    //
    
    @IBAction func actGrid(_ sender: UIButton) {
        print("Grid clicked")
        isGridOn = true
        
        collViewPublicProfile.reloadData()
    }
    
    @IBAction func actNoGrid(_ sender: UIButton) {
        print("Plain clicked")
        isGridOn = false
        collViewPublicProfile.reloadData()
    }
    
    //
    //MARK:- Action Methods
    //
    @IBAction func btnTappedBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTappedFamily(_ sender: UIButton) {
        
        let followinString = (self.profileDetail?.following == true) ? "Turn off" : "Turn on"
        let following = "Following"
        let followers = "Followers"
        Utility.sharedInstance.kbActionSheet(options: [followinString, following, followers]) { (response) in
            switch response {
            case followinString:
                self.followOrUnfollow()
                
            case following, followers:
                self.pushToFollowingFollowersList(for: (response == following))
           
            default: break
            }
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
    
    func getPopularList(page: Int) {
        guard let userID = profileDetail?.id else {
            return
        }
        //        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        getPopular(id: userID, page: page) { (response, dict) in
            
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
                //print(storyArray)
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
                //self.collViewPublicProfile.reloadItems(at: [IndexPath(row: 1, section: 0)])
                self.collViewPublicProfile.reloadItems(at: [IndexPath(row: 2, section: 0)])
                
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
        if let userID = profileId, userID == self.getUserId() && !self.isFromFeeds {
            let storyboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
            if let profileVC = storyboard.instantiateViewController(withIdentifier: "PublicProfileCollectionViewController") as? PublicProfileCollectionViewController {
                profileVC.profileId = self.arrMembers[index].id ?? nil
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        } else {
            let mvc = StoryPreviewViewController()
            mvc.dictInfo = (self.profileDict[index])
            self.navigationController?.pushViewController(mvc, animated: true)
        }
        
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        //isSearching = true
        //self.arrUserStories.removeAll()
        //self.profileDict.removeAll()
        //searchStoryResults()
        //collViewPublicProfile.reloadData()
        
        let storyboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "ASSearchVC") as! ASSearchVC
        
        if let txt = self.searchBar.text {
            homeVC.txtSearchText = txt
        }
        homeVC.delegates = self
        self.navigationController?.pushViewController(homeVC, animated: false)
        //self.present(homeVC, animated: false, completion: nil)
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
        searchHomeStories(page: pageSearchResult, strSearch: searchBar.text!) { (responseMember, response, dictResponse) in
            kAppDelegate.hideLoadingIndicator()
            
            if let memberArray = responseMember?.response {
                
                for object in memberArray {
                    self.arrMembers.append(object)
                }
                
                if let _ = dictResponse["next_page"] as? Int {
                    self.isMemberLoadNext = true
                } else {
                    self.isMemberLoadNext = false
                    
                }
                
                //print(self.arrMembers)
                self.collViewPublicProfile.dg_stopLoading()
                self.collViewPublicProfile.reloadItems(at: [IndexPath(row: 2, section: 0)])
                //self.collViewPublicProfile.reloadData()
                
            }
            
            if let storyArray = response?.response {
                KBLog.log(message: "stories", object: storyArray)
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
        /*searchStories(page: pageSearchResult, strSearch: searchBar.text!) { (response, dictResponse) in
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
         }*/
    }
    
    func cellTurntStoryTappedAtIndex(index: Int) {
        //arrUserStories
        /*
         var id: Int?
         var caption: String?
         var comments_count: Int?
         var likes_count: Int?
         var user: UserModel?
         var media: [MediaModel]?
         */
        
        let story = arrMyStories[index]
        print("MY STORY TAPPED")
        /*if story.content_type == storyContentType.video.rawValue {
            guard let url = URL.init(string: story.media_url) else {return}
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        } else{
            guard let url = URL.init(string: story.media_url) else {return}
            
            let item = KSPhotoItem(sourceView: UIImageView(), imageUrl: url)
            let browser = KSPhotoBrowser(photoItems: [item], selectedIndex: 0)
            browser.show(from: self)
        }*/
        
        let mvc = ASStoryPreviewVC()
        mvc.arrStories = arrMyStories
        mvc.currentIndex = index
        topVC?.navigationController?.present(mvc, animated: true, completion: nil)
    }
    
    func getAllMembersData() {
        getAllMember(page: pageNumberMember) { (response, dict) in
            kAppDelegate.hideLoadingIndicator()
            
            if let memberArray = response?.response {
                //print(memberArray)
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
extension PublicProfileCollectionViewController {
    func followUser(id: Int) {
        kBQ_FCMTokenUpdate.async {
            
            let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: "members/\(id)/follow", dictData: [:])
            //print("API Response:: \(response)")
            if response.count > 0 {
                DispatchQueue.main.async {
                    if let success = response["success"] as? Bool {
                        self.profileDetail?.following = success
                    }
                    kAppDelegate.hideLoadingIndicator()
                }
                
            }
            
        }
    }
    
    func unFollowUser(id: Int) {
        kBQ_FCMTokenUpdate.async {
            
            let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: "members/\(id)/unfollow", dictData: [:])
            //print("API Response:: \(response)")
            if response.count > 0 {
                DispatchQueue.main.async {
                    if let success = response["success"] as? Bool {
                        self.btnFamily.isSelected = !success
                    }
                    kAppDelegate.hideLoadingIndicator()
                }
                
            }
            
        }
    }
}
extension PublicProfileCollectionViewController: ASSearchDelegate {
    func ASSEarchCanceled () {
        searchBarCancelButtonClicked(searchBar)
    }
}

//MARK:- Videos data for a user
extension PublicProfileCollectionViewController {
    func getAllMyStoriesHomePage(userId: Int = 0) {
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        
        var strRequest = ""
        if userId > 0 {
            strRequest = "members/\(userId)"
        }
        let strPostUrl = "\(strRequest)/\(kAPIGetVideos)"
        
        
        kBQ_getVideos.async {
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strPostUrl, parType: "")
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        if let stories = dictComments["my_user_stories"] as? [Dictionary<String, Any>] {
                            for dict in stories {
                                let storyVideo = UserStories.init(dict: dict)
                                self.arrMyStories.append(storyVideo)
                            }
                        }
                    }
                    self.collViewPublicProfile.reloadItems(at: [IndexPath(row: 1, section: 0)])
                    
                } else {
                    kAppDelegate.hideLoadingIndicator()
                }
            }
        }
    }
}

