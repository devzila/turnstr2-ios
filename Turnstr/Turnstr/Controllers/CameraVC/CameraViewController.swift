//
//  CameraViewController.swift
//  Turnstr
//
//  Created by Mr X on 08/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import AssetsLibrary

class CameraViewController: ParentViewController {

    var uvContent = UIView()
    var selectedTab: Int = 1
    
    
    @IBOutlet weak var btnLibrary: UIButton!
    @IBOutlet weak var btnPhotos: UIButton!
    @IBOutlet weak var btnVideos: UIButton!
    
    let library : ALAssetsLibrary = ALAssetsLibrary()
    var photoArray : NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         * Navigation Bar
         */
        LoadNavBar()
        objNav.btnBack.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        objNav.btnRightMenu.setImage(nil, for: .normal)
        objNav.btnRightMenu.setTitle("NEXT", for: .normal)
        objUtil.setFrames(xCo: kWidth-50, yCo: kNavBarHeightWithLogo-40, width: 45, height: 40, view: objNav.btnRightMenu)
        
        //
        //Content View Center
        //
        uvContent.frame = CGRect.init(x: 0, y: kNavBarHeightWithLogo, width: kWidth, height: kHeight-kNavBarHeightWithLogo-60)
        uvContent.backgroundColor = UIColor.gray
        self.view.addSubview(uvContent)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Action Methods

    @IBAction func LibraryClicked(_ sender: UIButton) {
        selectedTab = 1
        TabHandling()
    }
    @IBAction func PhotosClicked(_ sender: UIButton) {
        selectedTab = 2
        TabHandling()
    }
    @IBAction func VideosClicked(_ sender: UIButton) {
        selectedTab = 3
        TabHandling()
    }
    
    func TabHandling() {
        
        let arrButtons: [UIButton] = [btnLibrary, btnPhotos, btnVideos]
        
        for var i in 0..<3 {
            let btn = arrButtons[i]
            if i == selectedTab-1 {
                btn.isSelected = true
            }
            else{
                btn.isSelected = false
            }
        }
    }
    
    //MARK:- Library Setup
    
    func loadImagesFromLibrary(){
        
    }

}
