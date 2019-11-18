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
    
    var arrTurntStories: [UserStories] = []
    var delegateTurntStory: TurntStoryDelegate?
    
    func setupCollectionView() {
        collViewTurntStory.register(UINib(nibName: "TurntCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        
        collViewTurntStory.delegate = self
        collViewTurntStory.dataSource = self
        collViewTurntStory.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // COmmented on 8feb 18. I think now we have to show horizontal scroll in stories.
        //return arrTurntStories.count > 3 ? 3 : arrTurntStories.count
        return arrTurntStories.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        let cell : TurntCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! TurntCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.init("F3F3F3").cgColor
        
        let story = arrTurntStories[indexPath.item]
        
        cell.imgMain.image = #imageLiteral(resourceName: "placeholder")
        if story.media_url.isEmpty == false, story.content_type == storyContentType.video.rawValue {
            let videoUrl = URL.init(string: story.media_url)
            cell.imgMain.getThumbnailOfURLWith(url: videoUrl!)
            
        } else{
            cell.imgMain.sd_setImage(with: URL.init(string: story.media_url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateTurntStory?.cellTurntStoryTappedAtIndex(index: indexPath.item)
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

