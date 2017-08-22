//
//  PhotoDetailViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 17/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import Kingfisher

let appThemeColor: UIColor = UIColor(red: 227.0 / 255.0, green: 100.0 / 255.0, blue: 32.0 / 255.0, alpha: 1.0)

class PhotoDetailViewController: ParentViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ServiceUtility, CommentsDelegate {
    
    @IBOutlet weak var collViewPhotoDetail: UICollectionView!
    var objPhotos: [Photos]?
    var photoDetail: Photos?
    var selectedIndex: Int?
    var albumId: Int?
    var isFromPublicPhoto: Bool?
    @IBOutlet weak var viewUserDetail: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        LoadNavBar()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        objNav.btnRightMenu.isHidden = true
        objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        if let isLib = isFromPublicPhoto, isLib == true {
            viewUserDetail.isHidden = false
        } else {
            viewUserDetail.isHidden = true
        }
        
        getUserDetailsAPI()
    }
    
    func getUserDetailsAPI() {
        if let photos = objPhotos {
            if selectedIndex != nil {
                //kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
                let photo = photos[(selectedIndex)!]
                if let isPublic = isFromPublicPhoto {
                    getPhotoDetail(idAlbum: albumId, idPhoto: photo.id!, isPublic: isPublic, withHandler: { (response) in
                        if let photoDetail = response?.response {
                            self.photoDetail = photoDetail
                            self.setupUserDetails()
                            self.lblLikeCount.text = (photoDetail.likes_count ?? 0) > 0 ? "\(photoDetail.likes_count ?? 0) Likes" : "\(photoDetail.likes_count ?? 0) Like"
                            self.lblCommentCount.text = (photoDetail.comments_count ?? 0) > 0 ? "\(photoDetail.comments_count ?? 0) Comments" : "\(photoDetail.comments_count ?? 0) Comment"
                            if let liked = photoDetail.has_liked, liked == 1 {
                                self.btnLike.setTitleColor(appThemeColor, for: .normal)
                            } else {
                                self.btnLike.setTitleColor(UIColor.white, for: .normal)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func setupUserDetails() {
        lblUserName.text = self.photoDetail?.user?.username == nil ? "@" + (self.photoDetail?.user?.first_name)! : "@" + (self.photoDetail?.user?.username)!
        let cube = AITransformView.init(frame: CGRect.init(x: (viewUserDetail.frame.size.height - 43)/2, y: (viewUserDetail.frame.size.height - 48)/2, width: 48, height: 48), cube_size: 30)
        cube?.backgroundColor = UIColor.clear
        cube?.isUserInteractionEnabled = false
        let arrFaces = [self.photoDetail?.user?.avatar_face1 ?? "thumb", self.photoDetail?.user?.avatar_face2 ?? "thumb", self.photoDetail?.user?.avatar_face3 ?? "thumb", self.photoDetail?.user?.avatar_face4 ?? "thumb", self.photoDetail?.user?.avatar_face5 ?? "thumb", self.photoDetail?.user?.avatar_face6 ?? "thumb"]
        cube?.setup(withUrls: arrFaces)
        viewUserDetail.addSubview(cube!)
        cube?.setScroll(CGPoint.init(x: 0, y: 30/2), end: CGPoint.init(x: 20, y: 30/2))
        cube?.setScroll(CGPoint.init(x: 30/2, y: 0), end: CGPoint.init(x: 30/2, y: 10))
    }
    
    override func viewDidLayoutSubviews() {
        //guard let index = selectedIndex else { return }
        //collViewPhotoDetail.setContentOffset(CGPoint(x: index * Int(collViewPhotoDetail.frame.size.width), y: 0), animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        guard let index = selectedIndex else { return }
        collViewPhotoDetail.setContentOffset(CGPoint(x: index * Int(collViewPhotoDetail.frame.size.width), y: Int(collViewPhotoDetail.contentOffset.y)), animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTappedLike(_ sender: Any) {
        if let photos = objPhotos {
            if self.collViewPhotoDetail.indexPathsForVisibleItems.last != nil {
                kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
                var photo = photos[(self.collViewPhotoDetail.indexPathsForVisibleItems.last?.row)!]
                self.likeUnlikePhoto(id: (photo.id)!, withHandler: { (response) in
                    if let likeDetail = response["message"] as? String, likeDetail == "Like created successfully" {
                        photo.has_liked = 1
                        photo.likes_count = (photo.likes_count ?? 0) + 1
                        self.objPhotos?[(self.collViewPhotoDetail.indexPathsForVisibleItems.last?.row)!] = photo
                        self.updateLikeCommentCount(photoDetail: photo)
                    } else {
                        photo.has_liked = 0
                        photo.likes_count = (photo.likes_count ?? 0) - 1
                        self.objPhotos?[(self.collViewPhotoDetail.indexPathsForVisibleItems.last?.row)!] = photo
                        self.updateLikeCommentCount(photoDetail: photo)
                    }
                })
            }
        }
    }
    @IBAction func publicProfileViewTapped(_ sender: UITapGestureRecognizer) {
        if photoDetail != nil {
            //performSegue(withIdentifier: "showProfile", sender: self)
            performSegue(withIdentifier: "showPublicProfile", sender: self)
        }
    }
    
    @IBAction func btnTappedComment(_ sender: Any) {
        if let photos = objPhotos {
            if self.collViewPhotoDetail.indexPathsForVisibleItems.last != nil {
                let photo = photos[(self.collViewPhotoDetail.indexPathsForVisibleItems.last?.row)!]
                performSegue(withIdentifier: "commentViewSegue", sender: photo)
            }
        }
    }
    
    @IBAction func btnTappedShare(_ sender: Any) {
        if let photos = objPhotos {
            if self.collViewPhotoDetail.indexPathsForVisibleItems.last != nil {
                SDWebImageManager.shared().downloadImage(with: URL(string: (photos[(self.collViewPhotoDetail.indexPathsForVisibleItems.last?.row)!].image_medium)!), options: .continueInBackground, progress: {
                    (receivedSize :Int, ExpectedSize :Int) in
                    print("ExpectedSize--\(ExpectedSize)")
                }, completed: {
                    (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                    let shareItems:Array = [image]
                    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                    activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, .assignToContact, .openInIBooks, .postToTencentWeibo]
                    self.present(activityViewController, animated: true, completion: nil)
                })
            }
            
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "commentViewSegue" {
            if let vc = segue.destination as? CommentsViewController {
                vc.objPhoto = self.photoDetail ?? nil//(sender as? Photos) ?? nil
                vc.delegate = self
            }
        }
        if segue.identifier == "showPublicProfile" {
            if let vc = segue.destination as? PublicProfileCollectionViewController {
                vc.profileDetail = photoDetail?.user ?? nil
                vc.profileId = photoDetail?.user?.id ?? nil
                vc.isFromFeeds = false
            }
        }
    }
    
}

extension PhotoDetailViewController {
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objPhotos != nil ? (objPhotos?.count)! : 0
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPreviewPhoto", for: indexPath as IndexPath)
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if let imgVwPic = cell.viewWithTag(1001) as? UIImageView {
            if let photos = objPhotos, photos.count > indexPath.row {
                let p = Bundle.main.path(forResource: "loaderImage", ofType: "gif")!
                let data = try! Data(contentsOf: URL(fileURLWithPath: p))
                imgVwPic.kf.indicatorType = .image(imageData: data)
                imgVwPic.kf.setImage(with: URL(string: (photos[indexPath.row].image_medium)!))
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for view in scrollView.subviews {
            if let imgVw = view as? UIImageView {
                return imgVw
            }
        }
        return nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let photos = objPhotos {
            if let indxPath = self.collViewPhotoDetail.indexPathsForVisibleItems.last, indxPath.row != selectedIndex {
                //kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
                self.selectedIndex = indxPath.row
                let photo = photos[indxPath.row]
                self.updateLikeCommentCount(photoDetail: photo)
                if let isPublic = isFromPublicPhoto {
                    getPhotoDetail(idAlbum: albumId, idPhoto: photo.id!, isPublic: isPublic, withHandler: { (response) in
                        if let photoDetail = response?.response {
                            self.photoDetail = photoDetail
                            self.setupUserDetails()
                            self.updateLikeCommentCount(photoDetail: photoDetail)
                        }
                    })
                }
            }
        }
    }
    
    func updateLikeCommentCount(photoDetail: Photos) {
        self.lblLikeCount.text = (photoDetail.likes_count ?? 0) > 1 ? "\(photoDetail.likes_count ?? 0) Likes" : "\(photoDetail.likes_count ?? 0) Like"
        self.lblCommentCount.text = (photoDetail.comments_count ?? 0) > 1 ? "\(photoDetail.comments_count ?? 0) Comments" : "\(photoDetail.comments_count ?? 0) Comment"
        if let liked = photoDetail.has_liked, liked == 1 {
            self.btnLike.setTitleColor(appThemeColor, for: .normal)
        } else {
            self.btnLike.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func btnCancelTapped() {
        getUserDetailsAPI()
    }
}

