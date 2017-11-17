//
//  TurntStoriesCollectionViewCell.swift
//  Turnstr
//
//  Created by Ketan Saini on 10/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

protocol TurntStoryDelegate {
    func cellTurntStoryTappedAtIndex(index: Int)
}

class TurntStoriesCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    @IBOutlet weak var collViewTurntStory: UICollectionView!
    
    var arrTurntStories = [StoryModel]()
    var delegateTurntStory: TurntStoryDelegate?
    
    func setupCollectionView() {
        collViewTurntStory.delegate = self
        collViewTurntStory.dataSource = self
        collViewTurntStory.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTurntStories.count > 3 ? 3 : arrTurntStories.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.init("F3F3F3").cgColor
        
        let w: CGFloat = PhotoSize().width
        let h: CGFloat = PhotoSize().width
        var cube = cell.contentView.viewWithTag(indexPath.item) as? AITransformView
        
        if cube == nil {
            
            cube = AITransformView.init(frame: CGRect.init(x: 0, y: (cell.frame.size.height-h)/2, width: w, height: h), cube_size: w/2)
            cube?.tag = indexPath.item
            cube?.backgroundColor = UIColor.clear
            cube?.isUserInteractionEnabled = true
            let arrFave = arrTurntStories[indexPath.row].media
            var arrFaces = [String]()
            for url in arrFave! {
                arrFaces.append(url.thumb_url ?? "thumb")
            }
            cube?.setup(withUrls: arrFaces)
            cell.contentView.addSubview(cube!)
            cube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 5, y: h/2))//20
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set collectionview cell size
        return PhotoSize()
    }
    
    func PhotoSize() -> CGSize {
        let photoCellSize = (kWidth/3)-10
        return CGSize(width: photoCellSize, height: self.collViewTurntStory.frame.size.height)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        
        if let indexPath = sender?.accessibilityElements![0] as? IndexPath {
            delegateTurntStory?.cellTurntStoryTappedAtIndex(index: indexPath.row)
        }
        
    }

}
