//
//  ASMyGoLiveVC.swift
//  Turnstr
//
//  Created by Mr. X on 08/02/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ASMyGoLiveVC: ParentViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var uvCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let playerController = AVPlayerViewController()
    
    var arrVideoStories: [VideoStory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        /*
         * Navigation Bar
         */
        createNavBar()
        
        getAllVideosforHomePage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrVideoStories.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AsMyGoLiveCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.init("F3F3F3").cgColor
        cell.layer.masksToBounds = true
        
        let story = arrVideoStories[indexPath.item]

        if story.url.isEmpty == false {
            let videoUrl = URL.init(string: story.url)
            cell.imgThumb.getThumbnailOfURLWith(url: videoUrl!)

        } else{
            cell.imgThumb.image = #imageLiteral(resourceName: "placeholder")
        }

        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let photoCellSize = (kWidth-40)/3
        
        return CGSize.init(width: photoCellSize, height: photoCellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }
    
    // Layout: Set Edges
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
        // top, left, bottom, right
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let story = arrVideoStories[indexPath.item]
        
        let urlString = story.url
        
        if urlString.isEmpty == false {
            let url = URL.init(string: urlString)
            let player = AVPlayer(url: url!)
            playerController.player = player
            self.present(playerController, animated: true) {
                player.play()
            }
        }
        
        
    }

}

//MARK:- Videos data for a user
extension ASMyGoLiveVC {
    func getAllVideosforHomePage(page: Int = 1) {
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        
        let strPostUrl = "user/videos?page=\(page)"
        
        
        kBQ_getVideos.async {
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strPostUrl, parType: "")
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        if let stories = dictComments["stories"] as? [Dictionary<String, Any>] {
                            for dict in stories {
                                let storyVideo = VideoStory.init(dict: dict)
                                self.arrVideoStories.append(storyVideo)
                            }
                        }
                    }
                    self.uvCollectionView.reloadData()
                    
                } else {
                    kAppDelegate.hideLoadingIndicator()
                }
            }
        }
    }
}


class AsMyGoLiveCell: UICollectionViewCell {
    
    @IBOutlet weak var imgThumb: UIImageView!
    
    
}
