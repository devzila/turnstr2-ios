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
    
    var arrFave5 = [UserModel]()
    var delegateFave5: Fave5CellDelegate?
    
    func setupCollectionView() {
        collViewFave5.delegate = self
        collViewFave5.dataSource = self
        collViewFave5.reloadData()
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFave5.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        let w: CGFloat = collectionView.frame.size.height
        let h: CGFloat = collectionView.frame.size.height
        var cube = cell.contentView.viewWithTag(indexPath.item) as? AITransformView
        
        if cube == nil {
            
            cube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: w/2)
            cube?.tag = indexPath.item
            cube?.backgroundColor = UIColor.clear
            cube?.isUserInteractionEnabled = true
            let arrFave = arrFave5[indexPath.row]
            let arrFaces = [arrFave.avatar_face1 ?? "thumb", arrFave.avatar_face2 ?? "thumb", arrFave.avatar_face3 ?? "thumb", arrFave.avatar_face4 ?? "thumb", arrFave.avatar_face5 ?? "thumb", arrFave.avatar_face6 ?? "thumb"]
            cube?.setup(withUrls: arrFaces)
            cell.contentView.addSubview(cube!)
            cube?.setScroll(CGPoint.init(x: 0, y: w/2/2), end: CGPoint.init(x: 20, y: w/2/2))
            
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
        if indexPath.row == arrFave5.count - 1 {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set collectionview cell size
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        
        if let indexPath = sender?.accessibilityElements![0] as? IndexPath {
            delegateFave5?.cellTappedAtIndex(index: indexPath.row)
        }
        
    }

}
