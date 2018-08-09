//
//  HomeViewController.swift
//  Turnstr
//
//  Created by Mr X on 09/05/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class HomeViewController: ParentViewController {
    
    var transformView: AITransformView?
    var topCube: AITransformView?
    
    var btnMyStory = UIButton()
    
    @IBOutlet weak var centerCubeTop: NSLayoutConstraint!
    @IBOutlet weak var uvCenterCubeUpper: view!
    @IBOutlet weak var btnDesc: UIButton!
    @IBOutlet weak var btnDescHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPostLeft: UILabel!
    @IBOutlet weak var lblPostRight: UILabel!
    
    @IBOutlet weak var uvCenterCube: UIView!
    @IBOutlet weak var uvTopCube: UIView!
    
    @IBOutlet weak var btnFullName: UIButton!
    @IBOutlet weak var btnDescription: UIButton!
    @IBOutlet weak var uvFav5: UIView!
    
    @IBOutlet weak var uvFav5Grid: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var arrFav5: [UserModel] = []
    
    
    //MARK:- Views
    override func viewDidLayoutSubviews() {
        MyStoryBUtton()
        //        if IS_IPHONEX {
        //            objUtil.setFrames(xCo: 0, yCo: 85, width: 0, height: 0, view: uvCenterCube)
        //        }
        uvCenterCube.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if IS_IPHONEX {
        //            centerCubeTop.constant = 85
        //            uvCenterCube.layoutIfNeeded()
        //        } else if IS_IPHONE_6 {
        //            centerCubeTop.constant = 35
        //            uvCenterCube.layoutIfNeeded()
        //        } else if IS_IPHONE_6P {
        //            centerCubeTop.constant = 48
        //            uvCenterCube.layoutIfNeeded()
        //        }
        
        //        btnDesc.addTarget(self, action: #selector(DescriptionClicked(sender:)), for: .touchUpInside)
        btnMyStory.addTarget(self, action: #selector(MyStoryClicked(sender:)), for: .touchUpInside)
        
        
        lblPostLeft.numberOfLines = 0
        lblPostRight.numberOfLines = 0
        
        
        
        //transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 5, width: kWidth, height: uvCenterCube.frame.size.height-10))
        //uvCenterCube.addSubview(transformView!)
        //self.view = transformView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        objDataS.getUserProfileData { (received) in
            if received == true {
                DispatchQueue.main.async {
                    
                    self.FollowerCounts()
                    self.lblUserName.text = "@"+self.objSing.strUserName.lowercased()
                    
                    //Setup Name & Bio
                    if self.objSing.isVerified == true {
                        self.btnFullName.setImage(#imageLiteral(resourceName: "nw_star"), for: .normal)
                    } else{
                        self.btnFullName.setImage(nil, for: .normal)
                    }
                    self.btnFullName.setTitle("\(self.objSing.strUserFname.uppercased()) \(self.objSing.strUserLName.uppercased()) ", for: .normal)
                    
                    let strBio = self.objSing.strUserBio
                    let str2 = strBio.isEmpty == false ? "\n" : ""
                    let attStr = strBio.attributtedString(appendString: "\(str2)\(self.objSing.strUserWebsite)", color1: .black, color2: kBlueColor, font1: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightRegular), font2: UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular), lineSpacing: 1, alignment: .center)
                    
                    self.btnDesc.setAttributedTitle(attStr, for: .normal)
                    if strBio.isEmpty == true {
                        self.btnDescHeight.constant = 25
                        self.btnDesc.layoutIfNeeded()
                    } else{
                        self.btnDescHeight.constant = 55
                        self.btnDesc.layoutIfNeeded()
                    }
                    
                    
                    //
                    //Top Cube View
                    //
                    
                    self.topCube?.removeFromSuperview()
                    self.topCube = nil
                    
                    var w: CGFloat = 95
                    var h: CGFloat = 80
                    
                    if self.topCube == nil {
                        
                        self.topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 65)
                    }
                    self.topCube?.backgroundColor = UIColor.clear
                    self.topCube?.setup(withUrls: [self.objSing.strUserPic1.urlWithThumb, self.objSing.strUserPic2.urlWithThumb, self.objSing.strUserPic3.urlWithThumb, self.objSing.strUserPic4.urlWithThumb, self.objSing.strUserPic5.urlWithThumb, self.objSing.strUserPic6.urlWithThumb])
                    self.uvTopCube.addSubview(self.topCube!)
                    
                    self.topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 10, y: h/2))
                    self.topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
                    /*
                     CGPoint location =  CGPointMake(0, self.center.y+90);
                     location = CGPointMake(80, location.y);
                     
                     CGPoint location =  CGPointMake(self.center.x, 0);
                     location = CGPointMake(self.center.x, 20);
                     */
                    
                    //
                    //Center cube view
                    //
                    self.transformView?.removeFromSuperview()
                    self.transformView = nil
                    
                    w = kWidth
                    h = w.getDW(SP: 270, S: 220, F: 220) // uvCenterCube.frame.size.height-10
                    
                    if self.transformView == nil {
                        
                        //transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 20, width: w, height: h), cube_size: w.getDW(SP: 230, S: 180, F: 180))
                        self.transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: w.getDW(SP: 210, S: 150, F: 180))
                    }
                    self.transformView?.backgroundColor = UIColor.clear
                    self.transformView?.setup(withUrls: [self.objSing.strUserPic1.urlWithThumb, self.objSing.strUserPic2.urlWithThumb, self.objSing.strUserPic3.urlWithThumb, self.objSing.strUserPic4.urlWithThumb, self.objSing.strUserPic5.urlWithThumb, self.objSing.strUserPic6.urlWithThumb])
                    self.uvCenterCube.addSubview(self.transformView!)
                    self.transformView?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: w.getDW(SP: 115, S: 85, F: 105), y: h/2))
                    self.transformView?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
                    self.uvCenterCubeUpper.layer.masksToBounds = true
                    
                    
                }
                
            }
        }
        //kAppDelegate.isTabChanges = true
        
        MyStoryBUtton()
        
        //
        //GET FAv 5
        //
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading")
        self.getFave5(id: objSing.strUserID, page: 1) { (response, dict) in
            
            if let faveArray = response?.response {
                print(faveArray)
                self.arrFav5.removeAll()
                for object in faveArray {
                    self.arrFav5.append(object)
                }
                DispatchQueue.main.async {
                    self.uvFav5Grid.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func FollowerCounts() {
        //
        // Family Count
        //
        let postTitle1: NSMutableAttributedString = NSMutableAttributedString.init(string: "posts\nfollowers\nfollowing")
        postTitle1.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle1.length))
        postTitle1.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postTitle1.length))
        
        let style1 = NSMutableParagraphStyle()
        style1.alignment = .right
        postTitle1.addAttribute(NSParagraphStyleAttributeName, value: style1, range: NSMakeRange(0, postTitle1.length))
        
        lblPostLeft.attributedText = postTitle1
        
        
        let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(objSing.post_count)\n\(objSing.follower_count)\n\(objSing.family_count)")
        postDetail.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
        postDetail.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
        style1.alignment = .left
        
        postDetail.addAttribute(NSParagraphStyleAttributeName, value: style1, range: NSMakeRange(0, postDetail.length))
        
        lblPostRight.attributedText = postDetail
    }
    //MARK:- UI
    
    func MyStoryBUtton() {
        btnMyStory.frame = CGRect.init(x: uvTopCube.frame.midX-25, y: uvTopCube.frame.maxY-40, width: 50, height: 42)
        btnMyStory.setImage(#imageLiteral(resourceName: "mystory"), for: .normal)
        self.view.addSubview(btnMyStory)
    }
    
    //MARK:- Action Methods
    
    @IBAction func EditProfile(_ sender: Any) {
        let mvc = EditProfileViewController()
        mvc.showBack = .yes
        self.navigationController?.pushViewController(mvc, animated: true)
    }
    @IBAction func LogoutClicked(_ sender: UIButton) {
        
        
        LogoutClicked()
    }
    
    func MyStoryClicked(sender: UIButton) {
        ///Open Camera
        let camVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
        topVC?.navigationController?.pushViewController(camVC, animated: true)
        
        //        Open My stories
        //        let storyboard = UIStoryboard(name: Storyboards.storyStoryboard.rawValue, bundle: nil)
        //        let homeVC: StoriesViewController = storyboard.instantiateViewController(withIdentifier: "StoriesViewController") as! StoriesViewController
        //        homeVC.screenType = .myStories
        //        topVC?.navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
    func DescriptionClicked(sender: UIButton) {
        
    }
    
    @IBAction func btnTappedMyPhotos(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "PhotoLibraryViewController") as? PhotoLibraryViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func actMyGoLive(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
        let homeVC: ASMyGoLiveVC = mainStoryboard.instantiateViewController(withIdentifier: "ASMyGoLiveVC") as! ASMyGoLiveVC
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
}

//
//MARK:- Collectionview Data Source
//
extension HomeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrFav5.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize.init(width: 75, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ASFav5Cell! = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ASFav5Cell
        
        let user = arrFav5[indexPath.item]
        
        cell.lblName.text = "\(user.username ?? "")"
        cell.lblName.textAlignment = .center
        let w: CGFloat = 75
        let h: CGFloat = 50
        var cube = cell.contentView.viewWithTag(indexPath.item) as? AITransformView
        
        if cube == nil {
            
            cube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 40)
            
            cube?.tag = indexPath.item
            cube?.backgroundColor = UIColor.white
            cube?.isUserInteractionEnabled = false
            
            cell.uvCell.addSubview(cube!)
        }
        
        var arrFaces = [String]()
        arrFaces = [user.avatar_face1 ?? "", user.avatar_face2 ?? "", user.avatar_face3 ?? "", user.avatar_face4 ?? "", user.avatar_face5 ?? "",  user.avatar_face6 ?? ""]
        
        cube?.setup(withUrls: arrFaces)
        cube?.setScroll(CGPoint.init(x: 60, y: h/2), end: CGPoint.init(x: 15, y: h/2))//20
        cube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
        
        return cell
    }
}
//
//MARK:- Collection view Delegates
//
extension HomeViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }
    
    // Layout: Set Edges
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
        // top, left, bottom, right
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let user = arrFav5[indexPath.item]
        
        let storyboard = UIStoryboard(name: "PhotoAlbum", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "PublicProfileCollectionViewController") as? PublicProfileCollectionViewController {
            profileVC.profileId = user.id
            topVC?.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

//MARK:- FAV 5 API
extension HomeViewController {
    func getFave5(id: String, page: Int, withHandler handler: @escaping (_ response: KSResponse<[UserModel]>?, _ dict: Dictionary<String, Any>) -> Void) {
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        
        
        kBQ_getUserData.async {
            
            let strPostUrl = "user/favourites"  //kAPIFollowUnfollowUser + "/\(id)/favourites"
            let strParType = ""
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                kAppDelegate.hideLoadingIndicator()
                
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        let dictMapper = ["statusCode": statusCode, "user": dictComments["favourites"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[UserModel]>(JSON: dictMapper)
                        handler(ksResponse, dictComments)
                    }
                } else {
                    print("Invalid response")
                }
            }
        }
    }
}

// MARK:-
// MARK: CollectionView Cell
// MARK:

/**
 * @Author : Ankit Saini on 27/12/2017 v1.0
 *
 * Class name: ASUploadPreviewCell
 *
 * @description:  This class is used for the cell created over storyboard in ASUploadPreview class.
 *
 */
class ASFav5Cell: UICollectionViewCell {
    @IBOutlet weak var uvCell: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
