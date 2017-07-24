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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LoadNavBar()
        objNav.btnRightMenu.isHidden = true
        objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: photoDetailSegue, sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set collectionview cell size
        let photoCellSize = (self.view.bounds.size.width - 3)/4
        return CGSize(width: photoCellSize, height: photoCellSize)
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
            }
        }
    }
}
