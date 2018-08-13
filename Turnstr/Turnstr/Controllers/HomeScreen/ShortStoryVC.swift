//
//  ShortStoryVC.swift
//  Turnstr
//
//  Created by Kamal on 11/08/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class ShortStoryVC: UIViewController {

    @IBOutlet weak var lblUsername: UILabel?
    @IBOutlet weak var cubeProfileView: AITransformView?
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var btnPeopleWhoViewed: UIButton?
    
    var user: User?
    var storyId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUsername?.text = user?.username
        
        let userUrls = user?.cubeUrls.map({$0.absoluteString})
        cubeProfileView?.createCubewith(35)
        cubeProfileView?.setup(withUrls: userUrls)
        cubeProfileView?.backgroundColor = .white
        cubeProfileView?.setScrollFromNil(CGPoint.init(x: 0, y: 30), end: CGPoint.init(x: 5, y: 30))
        cubeProfileView?.setScroll(CGPoint.init(x: 30, y: 0), end: CGPoint.init(x: 30, y: 2))
        cubeProfileView?.isUserInteractionEnabled = false
        
        apiCallStoryDetail()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: --- Action Methods
    @IBAction func btnCancelAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUserWhoHasViewedTheStory() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ListStoryViewersVC") as? ListStoryViewersVC else { return }
        vc.storyId = storyId
        present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: --- API Calls
extension ShortStoryVC {
    func apiCallStoryDetail() {
        guard let id = user?.id else { return }
        kAppDelegate.loadingIndicationCreation()
        let strEndPoint = "user/user_stories/\(id)"
        let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strEndPoint, parType: "")
        DispatchQueue.main.async {
            if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                kAppDelegate.hideLoadingIndicator()
                
                if let data = dictResponse["data"]?["data"] as? [String: Any],
                    let stories = data["user_stories"] as? [Any],
                    let story = stories.first as? [String: Any] {
                    
                    if let viewCount = story["view_count"] as? Int {
                        self.btnPeopleWhoViewed?.setTitle("\(viewCount)", for: .normal)
                        self.btnPeopleWhoViewed?.isEnabled = viewCount > 0
                    }
                    if let id = story["id"] as? Int {
                        self.storyId = "\(id)"
                    }
                    if let objs = story["medias"] as? [Any] {
                        if let obj = objs.first as? [String: Any] {
                            let media = StoryMedia(obj)
                            if let url = media.mediaUrl {
                                kAppDelegate.loadingIndicationCreation()
                                self.imgView?.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (img, error, cache, url) in
                                    self.imgView?.image = img
                                    kAppDelegate.hideLoadingIndicator()
                                })
                            }
                        }
                    }
                }
            } else {
                kAppDelegate.hideLoadingIndicator()
            }
            
        }
    }
}
