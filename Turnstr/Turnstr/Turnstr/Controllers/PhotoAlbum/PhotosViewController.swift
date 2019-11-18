//
//  PhotosViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 15/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import FacebookShare

class PhotosViewController: ParentViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ServiceUtility {
    @IBOutlet weak var collViewPhotos: UICollectionView!
    @IBOutlet weak var lblNoPhotos: UILabel!
    @IBOutlet weak var lblPostLeft: UILabel!
    @IBOutlet weak var lblPostRight: UILabel!
    
    let photosIdentifier = "cellPhotos"
    let photoDetailSegue = "showPhotoDetailSegue"
    
    var arrPhotos = [Photos]()
    var photoAlbum: PhotoAlbum?
    var isFromPublicPhoto = true
    
    var isLoadNext = false
    var pageNumber = 1
    var selectedIndexPath: IndexPath?
    
    var isDelete = false
    @IBOutlet weak var btnBlueBack: UIButton!
    @IBOutlet weak var btnSelectDelete: button!
    @IBOutlet weak var constraintImgVwLogoX: NSLayoutConstraint!
    
    @IBOutlet weak var uvTopCube: UIView!
    var topCube: AITransformView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if isFromPublicPhoto {
            btnBlueBack.isHidden = true
            btnSelectDelete.isHidden = true
            
            lblPostRight.isHidden = true
            lblPostLeft.isHidden = true
            uvTopCube.isHidden = true
            constraintImgVwLogoX.constant = (view.frame.size.width - 120)/2

        } else {
            btnBlueBack.isHidden = false
            btnSelectDelete.isHidden = false
            lblPostRight.isHidden = false
            lblPostLeft.isHidden = false
            topCube?.isHidden = false
            
            btnSelectDelete.setTitle("Select", for: .normal)
            btnSelectDelete.setTitleColor(UIColor(hexString: "00C7FF"), for: .normal)
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

        
        collViewPhotos.allowsMultipleSelection = false
        
        lblPostLeft.numberOfLines = 0
        lblPostRight.numberOfLines = 0
        
        let postTitle: NSMutableAttributedString = NSMutableAttributedString.init(string: "posts\nfollowers\nfamily")
        postTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postTitle.length))
        postTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, postTitle.length))
        
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        postTitle.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, postTitle.length))
        
        lblPostLeft.attributedText = postTitle
        
        
        let postDetail: NSMutableAttributedString = NSMutableAttributedString.init(string: "\(objSing.post_count)\n\(objSing.follower_count)\n\(objSing.family_count)")
        postDetail.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, postDetail.length))
        postDetail.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, postDetail.length))
        style.alignment = .left
        
        postDetail.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, postDetail.length))
        
        lblPostRight.attributedText = postDetail
        
    }
    
    @IBAction func btnTappedSelectDelete(_ sender: UIButton) {
        btnTappedDeletePhoto()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        pageNumber = 1
        arrPhotos.removeAll()
        collViewPhotos.reloadData()
        if isFromPublicPhoto {
            getAllPhotos(page: pageNumber)
        } else {
            picsOfUser()
        }
    }
    
    func picsOfUser() {
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        getAlbumPhotos(id: (photoAlbum?.id)!) { (response) in
            if let photosArray = response?.response {
                print(photosArray)
                self.arrPhotos = photosArray
                self.lblNoPhotos.isHidden = self.arrPhotos.count > 0
                self.collViewPhotos.reloadData()
            }
        }
    }
    
    func getAllPhotos(page: Int) {
        getAllPublicPhotos(page: page) { (response, dict) in
            if let photosArray = response?.response {
                print(photosArray)
                
                for object in photosArray {
                    self.arrPhotos.append(object)
                }
                
                if let _ = dict["next_page"] as? Int {
                    self.isLoadNext = true
                } else {
                    self.isLoadNext = false
                }
                
                self.lblNoPhotos.isHidden = self.arrPhotos.count > 0
                self.collViewPhotos.reloadData()
            }
        }
    }
    
    func btnTappedDeletePhoto() {
        
        if btnSelectDelete.isSelected {
            btnSelectDelete.isSelected = false
            btnSelectDelete.setTitle("Select", for: .normal)
            isDelete = false
            deletePhotoAPI()
        } else {
            isDelete = true
            btnSelectDelete.isSelected = true
            btnSelectDelete.setTitle("Delete", for: .normal)
        }
    }
    
    func deletePhotoAPI() {
        guard let index = selectedIndexPath else { return }
        kAppDelegate.loadingIndicationCreationMSG(msg: "Deleting...")
        if self.arrPhotos.count > index.row {
            deleteUserPhoto(albumId: (photoAlbum?.id)!, photoId: arrPhotos[index.row].id!) { (response) in
                self.picsOfUser()
                self.selectedIndexPath = nil
            }
        }
        
    }
    
    @IBAction func btnTappedBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}




extension PhotosViewController {
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPhotos.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photosIdentifier, for: indexPath as IndexPath) as UICollectionViewCell
        if let imgView = cell.viewWithTag(1001) as? UIImageView {
            if self.arrPhotos.count > indexPath.row {
                if let coverImage = self.arrPhotos[indexPath.row].image_thumb {
                    imgView.sd_setImage(with: URL(string: coverImage), placeholderImage: #imageLiteral(resourceName: "placeholder"))
                }
            }
            
        }
        if selectedIndexPath != nil && indexPath == selectedIndexPath {
            cell.contentView.layer.borderColor = UIColor(hexString: "00C7FF").cgColor
            cell.contentView.layer.borderWidth = 3.0
        }else {
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 0.0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isDelete {
            performSegue(withIdentifier: photoDetailSegue, sender: indexPath)
        } else {
            let cell = collectionView.cellForItem(at: indexPath)!
            cell.isSelected = true
            cell.contentView.layer.borderColor = UIColor(hexString: "00C7FF").cgColor
            cell.contentView.layer.borderWidth = 3.0
            self.selectedIndexPath = indexPath
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set collectionview cell size
        let photoCellSize = (self.view.bounds.size.width - 3)/4
        return CGSize(width: photoCellSize, height: photoCellSize)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == arrPhotos.count - 1, isLoadNext {
            pageNumber = pageNumber+1
            self.getAllPhotos(page: pageNumber)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.borderWidth = 0.0
        selectedIndexPath = nil
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == photoDetailSegue {
            if let vc = segue.destination as? PhotoDetailNewViewController, let index = sender as? IndexPath {

                if self.arrPhotos.count > index.row {
                    vc.photoId = self.arrPhotos[index.row].id
                }
                
                vc.albumId = photoAlbum?.id
                vc.isFromPublicPhoto = isFromPublicPhoto
            }
        }
    }
}
