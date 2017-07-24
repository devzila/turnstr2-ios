//
//  PhotoDetailViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 17/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class PhotoDetailViewController: ParentViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var collViewPhotoDetail: UICollectionView!
    var objPhotos: [Photos]?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LoadNavBar()
        objNav.btnRightMenu.isHidden = true
        objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        guard let index = selectedIndex else { return }
        collViewPhotoDetail.setContentOffset(CGPoint(x: index * Int(collViewPhotoDetail.frame.size.width), y: 0), animated: false)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTappedLike(_ sender: Any) {
    }
    
    @IBAction func btnTappedComment(_ sender: Any) {
        //performSegue(withIdentifier: "commentViewSegue", sender: self)
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
                imgVwPic.sd_setImage(with: URL(string: (photos[indexPath.row].image_medium)!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
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

    }
}

