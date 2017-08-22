//
//  PhotosViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 15/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class PhotosViewController: ParentViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ServiceUtility {
    @IBOutlet weak var collViewPhotos: UICollectionView!
    @IBOutlet weak var lblNoPhotos: UILabel!
    
    let photosIdentifier = "cellPhotos"
    let photoDetailSegue = "showPhotoDetailSegue"
    
    var arrPhotos = [Photos]()
    var photoAlbum: PhotoAlbum?
    var isFromPublicPhoto = true
    
    var isLoadNext = false
    var pageNumber = 1
    var selectedIndexPath: IndexPath?
    
    var isDelete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       // LoadNavBar()
        LoadPhotoLibNavBar() 
        if isFromPublicPhoto {
            objNav.btnBack.isHidden = true
            objNav.btnRightMenu.isHidden = true
        } else {
            objNav.btnBack.isHidden = false
            objNav.btnRightMenu.isHidden = false
            objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            
            objNav.btnRightMenu.setTitle("Select", for: .normal)
            objNav.btnRightMenu.setTitleColor(UIColor.white, for: .normal)
            objNav.btnRightMenu.addTarget(self, action: #selector(btnTappedDeletePhoto), for: .touchUpInside)
        }
        
        collViewPhotos.allowsMultipleSelection = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        if kAppDelegate.isTabChanges != true {
//            return
//        }
//        kAppDelegate.isTabChanges = false
        pageNumber = 1
        arrPhotos.removeAll()
        if isFromPublicPhoto {
            kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
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
        
        if objNav.btnRightMenu.isSelected {
            objNav.btnRightMenu.isSelected = false
            objNav.btnRightMenu.setTitle("Select", for: .normal)
            isDelete = false
            deletePhotoAPI()
        } else {
            isDelete = true
            objNav.btnRightMenu.isSelected = true
            objNav.btnRightMenu.setTitle("Delete", for: .normal)
        }
    }
    
    func deletePhotoAPI() {
        guard let index = selectedIndexPath else { return }
        kAppDelegate.loadingIndicationCreationMSG(msg: "Deleting...")
        deleteUserPhoto(albumId: (photoAlbum?.id)!, photoId: arrPhotos[index.row].id!) { (response) in
            self.picsOfUser()
            self.selectedIndexPath = nil
        }
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
            if let coverImage = self.arrPhotos[indexPath.row].image_thumb {
                imgView.sd_setImage(with: URL(string: coverImage), placeholderImage: #imageLiteral(resourceName: "placeholder"))
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
            if let vc = segue.destination as? PhotoDetailViewController, let index = sender as? IndexPath {
                vc.objPhotos = arrPhotos
                vc.selectedIndex = index.row
                vc.albumId = photoAlbum?.id
                vc.isFromPublicPhoto = isFromPublicPhoto
            }
        }
    }
}
