//
//  EditProfileHeader.swift
//  Turnstr
//
//  Created by Mr X on 27/06/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

@objc protocol EditProfileHeaderDelegate {
    @objc optional func UvCollectionViewDidSelectRow(collectionView: UICollectionView, selectedINdex: Int) -> Void
}

class EditProfileHeader: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegateEditHeader: EditProfileHeaderDelegate?
    
    @IBOutlet weak var imgCube: UIImageView!
    @IBOutlet weak var uvCube: UIView!
    @IBOutlet weak var btnChangePhoto: UIButton!
    @IBOutlet weak var uvCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var arrImage: Array = [UIImage]()
    var arrImageUrls: [String] = []
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let uvNub: UIView = (Bundle.main.loadNibNamed("EditProfileHeader", owner: self, options: nil)![0] as? UIView)!
        uvNub.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(uvNub)
        
        CollectionViewSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- CollectionView
    
    func CollectionViewSetting() -> Void {
        
        
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.minimumLineSpacing = 2
        
        //flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        flowLayout.itemSize = PhotoSize()
        
        flowLayout.scrollDirection = .horizontal
        uvCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func PhotoSize() -> CGSize {
        let photoCellSize = (kWidth/6)
        return CGSize(width: photoCellSize, height: photoCellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = UIColor.init("F3F3F3")
        
        
        
        let frame: CGRect = CGRect.init(x: 0, y: 0, width: PhotoSize().width, height: PhotoSize().height)
        
        
        var imgBigImage = cell.contentView.viewWithTag(-111) as? UIImageView
        if imgBigImage == nil {
            imgBigImage = UIImageView.init(frame: frame)
            imgBigImage?.tag = -111
            imgBigImage?.contentMode = .scaleToFill
            
        }
        imgBigImage?.image = nil
        cell.contentView.addSubview(imgBigImage!)
        
        
        var imgSmallImage = cell.contentView.viewWithTag(-112) as? UIImageView
        if imgSmallImage == nil {
            imgSmallImage = UIImageView.init(frame: CGRect.init(x: 5, y: frame.height-26, width: 31, height: 21))
            imgSmallImage?.tag = -112
            
        }
        imgSmallImage?.contentMode = .scaleAspectFit
        imgSmallImage?.image = #imageLiteral(resourceName: "img_small")
        cell.contentView.addSubview(imgSmallImage!)
        
        
        if arrImage.count > indexPath.item {
            imgBigImage?.image = arrImage[indexPath.item]
        }
        else if arrImageUrls.count > 0 {
            print(arrImageUrls[0])
            imgBigImage?.sd_setImage(with: URL.init(string: arrImageUrls[0]), completed: { (imagec, errr, cachee, urll) in
                if imagec != nil {
                    self.arrImage.append(imagec!)
                }
                
            })
            arrImageUrls.remove(at: 0)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateEditHeader?.UvCollectionViewDidSelectRow!(collectionView: collectionView, selectedINdex: indexPath.item)
        //if arrImage.count > indexPath.item{
        //}
    }
    
}
