//
//  TurntStoriesCollectionViewCell.swift
//  Turnstr
//
//  Created by Ketan Saini on 10/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class TurntStoriesCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collViewTurntStory: UICollectionView!
    
    
    func setupCollectionView() {
        collViewTurntStory.delegate = self
        collViewTurntStory.dataSource = self
        collViewTurntStory.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.init("F3F3F3").cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set collectionview cell size
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }

}
