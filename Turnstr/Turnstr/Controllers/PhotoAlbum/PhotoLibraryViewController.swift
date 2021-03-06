//
//  PhotoLibraryViewController.swift
//  TurnstrPhotoLib
//
//  Created by Ketan Saini on 11/07/17.
//  Copyright © 2017 Ketan Saini. All rights reserved.
//

import UIKit

class PhotoLibraryViewController: ParentViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ServiceUtility {
    //IBOutlet
    @IBOutlet weak var collViewPhotoAlbum: UICollectionView!
    
    var arrPhotoAlbum = [PhotoAlbum]()
    let photoAlbumIdentifier = "PhotoAlbum"
    
    var topCube: AITransformView?
    
    @IBOutlet weak var uvTopCube: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        self.photoAlbum { (response) in
            if let arrAlbums = response?.response {
                print(arrAlbums)
                self.arrPhotoAlbum = arrAlbums
                self.collViewPhotoAlbum.reloadData()
            }
        }
        
        //
        //Top Cube View
        //
        
        topCube?.removeFromSuperview()
        topCube = nil
        
        let w: CGFloat = 40
        let h: CGFloat = 33
        
        if topCube == nil {
            
            topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 28)
        }
        topCube?.backgroundColor = UIColor.clear
        topCube?.setup(withUrls: [objSing.strUserPic1.urlWithThumb, objSing.strUserPic2.urlWithThumb, objSing.strUserPic3.urlWithThumb, objSing.strUserPic4.urlWithThumb, objSing.strUserPic5.urlWithThumb, objSing.strUserPic6.urlWithThumb])
        uvTopCube.addSubview(topCube!)
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 5, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        goBack()
    }
    
    @IBAction func btnTappedPhotoLibrary(_ sender: UIButton) {
        CameraImage.shared.captureImage(from: self, captureOptions: [.camera, .photoLibrary], allowEditting: true, fileTypes: [.image]) {[weak self] (image, url) in
            if image != nil {
                kAppDelegate.loadingIndicationCreationMSG(msg: "Uploading...")
                self?.uploadPhotoToAlbum(arrImages: [image!])
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "photosViewSegue"{
            if let vc = segue.destination as? PhotosViewController, let index = sender as? IndexPath {
                vc.photoAlbum = arrPhotoAlbum[index.row]
                vc.isFromPublicPhoto = false
            }
        }
    }
}

extension PhotoLibraryViewController {
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPhotoAlbum.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoAlbumIdentifier, for: indexPath as IndexPath) as UICollectionViewCell
        if let imgView = cell.viewWithTag(1001) as? UIImageView {
            if let coverImage = self.arrPhotoAlbum[indexPath.row].cover_image_url {
                print(coverImage)
                imgView.sd_setImage(with: URL(string: coverImage), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            }
        }
        if let lblMonth = cell.viewWithTag(1002) as? UILabel {
            if let title = self.arrPhotoAlbum[indexPath.row].title {
                lblMonth.text = title
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "photosViewSegue", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set collectionview cell size
        let photoCellSize = (self.view.bounds.size.width - 2)/3
        return CGSize(width: photoCellSize, height: photoCellSize)
    }
}
