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
        
        
        objStory.ParseStoryData(dict: dictInfo)
        
        var arrMedia: [String] = []
        
        for item in objStory.media {
            
            objStory.ParseMedia(media: item)
            arrMedia.append(objStory.thumb_url)
        }
        
        let w: CGFloat = kWidth
        let h: CGFloat = kHeight-kNavBarHeight // uvCenterCube.frame.size.height-10
        
        let transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 220)//w > h ?h-100:w-100
        
        transformView?.backgroundColor = UIColor.clear
        transformView?.setup(withUrls: arrMedia)
        self.view.addSubview(transformView!)
        transformView?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 85, y: h/2))
        transformView?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
        

        /*
         * Navigation Bar
         */
        LoadNavBar()
        objNav.btnRightMenu.isHidden = true
        objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func cubePageView(_ pc: CubePageView!, newPage page: Int32) {
    }

}
