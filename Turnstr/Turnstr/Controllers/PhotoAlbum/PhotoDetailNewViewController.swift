//
//  PhotoDetailNewViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 03/09/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoDetailNewViewController: ParentViewController, UITextViewDelegate, ServiceUtility {

    
    @IBOutlet weak var tblViewPhotoDetail: UITableView!
    
    var arrComments = [CommentModel]()
    var isLoadNext = false
    var pageNumber = 0
    
    var albumId: Int?
    var photoId: Int?
    var isFromPublicPhoto: Bool?
    
    var photoDetail: Photos?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        LoadNavBar()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        objNav.btnRightMenu.isHidden = true
        objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        
        tblViewPhotoDetail.rowHeight = UITableViewAutomaticDimension
        tblViewPhotoDetail.estimatedRowHeight = 40
        self.tblViewPhotoDetail.tableFooterView = UIView(frame: CGRect.zero)
        
        
        getUserDetailsAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        arrComments.removeAll()
        isLoadNext = false
        pageNumber = 0
        getComments(page: pageNumber)
    }
    
    func getUserDetailsAPI() {
        
        if let isPublic = isFromPublicPhoto {
            kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
            getPhotoDetail(idAlbum: albumId, idPhoto: photoId ?? 0, isPublic: isPublic, withHandler: { (response) in
                kAppDelegate.hideLoadingIndicator()
                if let photoDetail = response?.response {
                    self.photoDetail = photoDetail
                    self.tblViewPhotoDetail.reloadData()
//                    let indexPath = IndexPath(item: 0, section: 0)
//                    self.tblViewPhotoDetail.reloadRows(at: [indexPath], with: .top)
                }
            })
        }
    }
    
    func getComments(page: Int) {
//        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        getPhotoComment(id: photoId ?? 0, page: page) { (response, dict) in
            if let commentsArray = response?.response {
                print(commentsArray)
                for object in commentsArray {
                    self.arrComments.append(object)
                }
//                let indexPath = IndexPath(item: 1, section: 0)
//                self.tblViewPhotoDetail.reloadRows(at: [indexPath], with: .top)
                self.tblViewPhotoDetail.reloadData()
                
                if let _ = dict["next_page"] as? Int {
                    self.isLoadNext = true
                } else {
                    self.isLoadNext = false
                }
            }
        }
    }
    
    
    @IBAction func btnTappedShare(_ sender: UIButton) {
        guard let photo = photoDetail else { return }
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        SDWebImageManager.shared().downloadImage(with: URL(string: photo.image_medium!), options: .continueInBackground, progress: {
            (receivedSize :Int, ExpectedSize :Int) in
            print("ExpectedSize--\(ExpectedSize)")
        }, completed: {
            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
            kAppDelegate.hideLoadingIndicator()
            if image != nil {
                self.performSegue(withIdentifier: "SharePhoto", sender: image)
            }
            
            //                    let shareItems:Array = [image]
            //                    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            //                    activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, .assignToContact, .openInIBooks, .postToTencentWeibo]
            //                    self.present(activityViewController, animated: true, completion: nil)
        })
    }
    
    @IBAction func btnTappedComment(_ sender: UIButton) {
        performSegue(withIdentifier: "commentViewSegue", sender: self)
    }
    
    @IBAction func btnTappedProfileDetail(_ sender: UIButton) {
        performSegue(withIdentifier: "showPublicProfile", sender: self)
    }
    
    @IBAction func btnTappedLike(_ sender: UIButton) {
        guard photoDetail != nil else { return }
        self.likeUnlikePhoto(id: photoId ?? 0, withHandler: { (response) in
            
            if let likeDetail = response["message"] as? String, likeDetail == "Like created successfully" {
                self.photoDetail?.has_liked = 1
                self.photoDetail?.likes_count = (self.photoDetail?.likes_count ?? 0) + 1
            } else {
                self.photoDetail?.has_liked = 0
                self.photoDetail?.likes_count = (self.photoDetail?.likes_count ?? 0) - 1
            }
            self.tblViewPhotoDetail.reloadData()
        })
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "commentViewSegue" {
            if let vc = segue.destination as? CommentsViewController {
                vc.objPhoto = self.photoDetail ?? nil//(sender as? Photos) ?? nil
            }
        }
        
        if segue.identifier == "SharePhoto", let image = sender as? UIImage {
            if let vc = segue.destination as? SharePhotoViewController {
                vc.imageToShare = image
            }
        }
        
        if segue.identifier == "showPublicProfile" {
            if let vc = segue.destination as? PublicProfileCollectionViewController {
                vc.profileDetail = self.photoDetail?.user ?? nil
                vc.profileId = self.photoDetail?.user?.id ?? nil
                vc.isFromFeeds = false
            }
        }
    }
    

}

extension PhotoDetailNewViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - UITableView Delegate/Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Check whether to show settings section or not.
        if photoDetail != nil {
            return arrComments.count + 1
        }
        return 0
    }
    // TableView cell for row at index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhotoDetail", for: indexPath)
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            if let lblName = cell.viewWithTag(1001) as? UILabel {
                if photoDetail != nil {
                    lblName.text = photoDetail?.user?.username ?? ""
                }
            }
            
            if let imgPic = cell.viewWithTag(1002) as? UIImageView {
                if photoDetail != nil {
                    let p = Bundle.main.path(forResource: "loaderImage", ofType: "gif")!
                    let data = try! Data(contentsOf: URL(fileURLWithPath: p))
                    imgPic.kf.indicatorType = .image(imageData: data)
                    imgPic.kf.setImage(with: URL(string: photoDetail?.image_original ?? ""))
                }
            }
            
            if let imgLike = cell.viewWithTag(1003) as? UIImageView {
                if let det = photoDetail, det.has_liked != nil {
                    if det.has_liked! != 0 {
                        imgLike.image = UIImage(named: "likeSelected")
                    } else {
                        imgLike.image = UIImage(named: "likePhoto")
                    }
                }
            }
            
            if let lblLikeComment = cell.viewWithTag(1004) as? UILabel {
                if let det = photoDetail {
                    lblLikeComment.text = "Liked by \(det.likes_count ?? 0) people"
                }
            }
            
            var cube = cell.contentView.viewWithTag(indexPath.item) as? AITransformView
            if cube == nil {
                if let det = photoDetail {
                    cube = AITransformView.init(frame: CGRect.init(x: 8, y: 5, width: 50, height: 50), cube_size: 30)
                    cube?.tag = indexPath.item
                    cube?.backgroundColor = UIColor.clear
                    cube?.isUserInteractionEnabled = false
                    let arrFaces = [det.user?.avatar_face1 ?? "thumb", det.user?.avatar_face2 ?? "thumb", det.user?.avatar_face3 ?? "thumb", det.user?.avatar_face4 ?? "thumb", det.user?.avatar_face5 ?? "thumb", det.user?.avatar_face6 ?? "thumb"]
                    cube?.setup(withUrls: arrFaces)
                    cell.contentView.addSubview(cube!)
                    cube?.setScroll(CGPoint.init(x: 0, y: 50/2), end: CGPoint.init(x: 7, y: 50/2))
                    cube?.setScroll(CGPoint.init(x: 50/2, y: 0), end: CGPoint.init(x: 50/2, y: 1))
                }
                
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellComments", for: indexPath)
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            if let lblName = cell.viewWithTag(1001) as? UILabel {
                lblName.text = arrComments[indexPath.row - 1].user?.username
            }
            
            if let lblComment = cell.viewWithTag(1002) as? UILabel {
                lblComment.text = arrComments[indexPath.row - 1].body
            }
            
            if let lblTime = cell.viewWithTag(1003) as? UILabel {
                lblTime.text = self.convertStringToDate(dateString: arrComments[indexPath.row - 1].created_at!)?.timeAgoDisplay()
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrComments.count - 2, isLoadNext {
            pageNumber = pageNumber+1
            self.getComments(page: pageNumber)
        }
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
}

