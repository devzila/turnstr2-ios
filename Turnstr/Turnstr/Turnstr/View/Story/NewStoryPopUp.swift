//
//  NewStoryPopUp.swift
//  Turnstr
//
//  Created by Mr X on 11/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class NewStoryPopUp: UIView {
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var uvCube: UIView!
    @IBOutlet weak var ttxtCaption: IQTextView!
    
    var arrMedia = [NewStoryMedia]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let uvNub: UIView = (Bundle.main.loadNibNamed("NewStoryPopUp", owner: self, options: nil)![0] as? UIView)!
        uvNub.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(uvNub)
        
    }
    
    func setCube() -> Void {
        var arrImages: [UIImageView] = []
        let cube = CubePageView.init(frame: CGRect.init(x: uvCube.frame.midX-50, y: 0, width: 100, height: 90))
        
        for item in arrMedia {
            
            let story = item
            
            
            let imgImage: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: cube!.frame.width, height: cube!.frame.height))
            
            if story.type == .image {
                imgImage.image = story.image
            }else {
                
                imgImage.image = story.image
            }
            
            imgImage.contentMode = .scaleAspectFill
            arrImages.append(imgImage)
        }
        
        cube?.backgroundColor = UIColor.white
        cube?.layer.masksToBounds = true
        uvCube.addSubview(cube!)
        cube?.setPages(arrImages)
        cube?.selectPage((cube?.currentPage())!, withAnim: false)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
