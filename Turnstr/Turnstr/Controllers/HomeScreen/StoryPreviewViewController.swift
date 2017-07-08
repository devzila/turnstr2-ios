//
//  StoryPreviewViewController.swift
//  Turnstr
//
//  Created by Mr X on 07/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class StoryPreviewViewController: ParentViewController, CubePageView_Delegate {

    let objStory = Story.sharedInstance
    
    var dictInfo: Dictionary<String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        /*
         * Navigation Bar
         */
        LoadNavBar()
        objNav.btnRightMenu.isHidden = true
        objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        objStory.ParseStoryData(dict: dictInfo)
        
        let arrMedia = objStory.media
        
        var arrImages: [UIImageView] = []
        
        for item in arrMedia {
            
            objStory.ParseMedia(media: item)
            
            let imgImage: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 60, width: kWidth, height: 280))
            imgImage.sd_setImage(with: URL.init(string: objStory.thumb_url))
            imgImage.contentMode = .scaleAspectFill
            imgImage.layer.masksToBounds = true
            arrImages.append(imgImage)
        }
        
        let cube: CubePageView = CubePageView.init(frame: CGRect.init(x: 0, y: 60, width: kWidth, height: 280))
        cube.delegate = self
        
        self.view.addSubview(cube)
        cube.setPages(arrImages)
        cube.accessibilityElements = [arrMedia]
        cube.selectPage((cube.currentPage()), withAnim: false)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func cubePageView(_ pc: CubePageView!, newPage page: Int32) {
    }

}
