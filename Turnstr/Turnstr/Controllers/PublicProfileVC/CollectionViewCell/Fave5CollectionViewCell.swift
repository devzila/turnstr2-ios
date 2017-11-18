//
//  Fave5CollectionViewCell.swift
//  Turnstr
//
//  Created by Ketan Saini on 10/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

protocol Fave5CellDelegate {
    func cellTappedAtIndex(index: Int)
}

class Fave5CollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ServiceUtility, UIGestureRecognizerDelegate {
    @IBOutlet weak var collViewFave5: UICollectionView!
    
    var arrFave5: [UserModel]? //= [UserModel]()
    var arrStories: [StoryModel]?
    var delegateFave5: Fave5CellDelegate?
    
    func setupCollectionView() {
        collViewFave5.delegate = self
        collViewFave5.dataSource = self
        collViewFave5.reloadData()
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return arrFave5.count
        if arrFave5 == nil {
            return arrStories == nil ? 0 : arrStories!.count
        }
        return arrFave5!.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        let w: CGFloat = collectionView.frame.size.height
        let h: CGFloat = collectionView.frame.size.height
        var cube = cell.contentView.viewWithTag(indexPath.item) as? AITransformView
        
        
        if let arrFav = arrFave5 {
            if let lblName = cell.viewWithTag(1003) as? UILabel {
                lblName.text = arrFav[indexPath.row].username != nil ? arrFav[indexPath.row].username : ""
            }
        } else {
            if let lblName = cell.viewWithTag(1003) as? UILabel {
                lblName.text = self.arrStories?[indexPath.row].user?.username != nil ? self.arrStories?[indexPath.row].user?.username : ""
            }
        }
        
        
        if cube == nil {
            
            cube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: w/2)
            cube?.tag = indexPath.item
            cube?.backgroundColor = UIColor.clear
            cube?.isUserInteractionEnabled = true
            
            var arrFaces = [String]()
            if let arrFav = arrFave5 {
                arrFaces = [arrFav[indexPath.row].avatar_face1 ?? "", arrFav[indexPath.row].avatar_face2 ?? "", arrFav[indexPath.row].avatar_face3 ?? "", arrFav[indexPath.row].avatar_face4 ?? "", arrFav[indexPath.row].avatar_face5 ?? "", arrFav[indexPath.row].avatar_face6 ?? ""]
            } else {
                let arrFave = arrStories?[indexPath.row].media
                for url in arrFave! {
                    arrFaces.append(url.thumb_url ?? "")
                }
            }
//            let arrFave = arrFave5[indexPath.row]
//            let arrFaces = [arrFave.avatar_face1 ?? "", arrFave.avatar_face2 ?? "", arrFave.avatar_face3 ?? "", arrFave.avatar_face4 ?? "", arrFave.avatar_face5 ?? "", arrFave.avatar_face6 ?? ""]
            cube?.setup(withUrls: arrFaces)
            cell.contentView.addSubview(cube!)
            cube?.setScroll(CGPoint.init(x: 0, y: w/2), end: CGPoint.init(x: 5, y: w/2))//10
            cube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 1))
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
            tap.delegate = self
            tap.accessibilityElements = [indexPath]
            tap.numberOfTapsRequired = 1
            cube?.addGestureRecognizer(tap)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set collectionview cell size
        return CGSize(width: collectionView.frame.size.height - 10, height: collectionView.frame.size.height)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        
        if let indexPath = sender?.accessibilityElements![0] as? IndexPath {
            delegateFave5?.cellTappedAtIndex(index: indexPath.row)
        }
        
    }

}
