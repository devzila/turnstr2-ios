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
    
    @IBOutlet weak var btnChangePhoto: UIButton!
    @IBOutlet weak var uvCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var arrImage: Array = [UIImage]()
    var arrImageUrls: Array = [String]()
    
    
    
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
        
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 75, height: 75)
        
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
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = UIColor.init("F3F3F3")
        
        let frame: CGRect = CGRect.init(x: 0, y: 0, width: 75, height: 75)
        
        
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
            imgSmallImage = UIImageView.init(frame: CGRect.init(x: 5, y: frame.height-30, width: 31, height: 21))
            imgSmallImage?.tag = -112
            imgSmallImage?.contentMode = .scaleAspectFit
        }
        imgSmallImage?.image = #imageLiteral(resourceName: "img_small")
        cell.contentView.addSubview(imgSmallImage!)
        
        
        if arrImage.count > indexPath.item {
            imgBigImage?.image = arrImage[indexPath.item]
        }
        
        if arrImage.count == 0 {
            print(arrImageUrls)
            if arrImageUrls.count > indexPath.item {
                
                print(arrImageUrls[indexPath.item])
                imgBigImage?.sd_setImage(with: URL.init(string: arrImageUrls[indexPath.item]), completed: { (imagec, errr, cachee, urll) in
                    
                })
                
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if arrImage.count > indexPath.item{
            delegateEditHeader?.UvCollectionViewDidSelectRow!(collectionView: collectionView, selectedINdex: indexPath.item)
        }
    }

}
