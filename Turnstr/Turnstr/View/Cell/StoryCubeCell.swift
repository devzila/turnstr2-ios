//
//  StoryCubeCell.swift
//  Turnstr
//
//  Created by Kamal on 01/08/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class StoryCubeCell: UITableViewCell {
    
    @IBOutlet weak var cubeView: AITransformView?
    @IBOutlet weak var cubeProfileView: AITransformView?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblCaption: UILabel?
    @IBOutlet weak var lblLikes: UILabel?
    @IBOutlet weak var lblComments: UILabel?
    @IBOutlet weak var btnLike: UIButton?
    @IBOutlet weak var btnComment: UIButton?
    var updateOnLikeStatusChanged:((_ storyInfo: Dictionary<String, Any>?) -> Void)?
    
    var storyInfo: Dictionary<String, Any>? {
        didSet {
            if let count = storyInfo?["likes_count"] as? Int {
                let strCount = count > 1 ? " \(count) Likes" : " \(count) Like"
                lblLikes?.text = strCount
            }
            lblComments?.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(btnCommentAction))
            lblComments?.addGestureRecognizer(gesture)
            if let count = storyInfo?["comments_count"] as? Int {
                let strCount = count > 1 ? " \(count) Comments" : " \(count) Comment"
                lblComments?.text = "View all \(strCount)"
            }
            lblCaption?.text = storyInfo?["caption"] as? String
            lblCaption?.numberOfLines = 0
            if let isLiked = storyInfo?["has_liked"] as? Bool {
                btnLike?.isSelected = isLiked
            }
            var userUrls = [String]()
            if let user = storyInfo?["user"] as? [String: Any] {
                lblName?.text = (user["first_name"] as? String)
                if let av1 = user["avatar_face1"] as? String {
                    userUrls.append(av1)
                }
                if let av2 = user["avatar_face2"] as? String {
                    userUrls.append(av2)
                }
                if let av3 = user["avatar_face3"] as? String {
                    userUrls.append(av3)
                }
                if let av4 = user["avatar_face4"] as? String {
                    userUrls.append(av4)
                }
                if let av5 = user["avatar_face5"] as? String {
                    userUrls.append(av5)
                }
                if let av6 = user["avatar_face6"] as? String {
                    userUrls.append(av6)
                }
                cubeProfileView?.createCubewith(35)
                cubeProfileView?.setup(withUrls: userUrls)
                cubeProfileView?.backgroundColor = .white
                cubeProfileView?.setScrollFromNil(CGPoint.init(x: 0, y: 30), end: CGPoint.init(x: 5, y: 30))
                cubeProfileView?.setScroll(CGPoint.init(x: 30, y: 0), end: CGPoint.init(x: 30, y: 2))
                cubeProfileView?.isUserInteractionEnabled = false
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openUserProfile))
                cubeProfileView?.superview?.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateButtonState() {
        guard let sender = btnLike else {return}
        sender.isSelected = !sender.isSelected
        
        let likeCount = lblLikes?.text?.intVal() ?? 0
        
        let count = sender.isSelected == true ? likeCount + 1 : likeCount - 1
        
        storyInfo?["has_liked"] = sender.isSelected
        storyInfo?["likes_count"] = count
        updateOnLikeStatusChanged?(storyInfo)
    }
    
    @objc func openUserProfile() {
        guard let feedVC = Storyboards.photoStoryboard.initialVC(with: StoryboardIds.feedScreen) as? PublicProfileCollectionViewController, let user = storyInfo?["user"] as? [String: Any], let userId = user["id"] as? Int else { return }
        feedVC.profileId = userId
        topVC?.navigationController?.pushViewController(feedVC, animated: true)
    }
    
    @IBAction func btnCommentAction(){
        let homeVC = StoryCommentVC.init(nibName: "StoryCommentVC", bundle: nil)
        if let dictInfo = storyInfo {
            homeVC.dictInfo = dictInfo
        }
        homeVC.delegate = self
        self.topVC?.present(homeVC, animated: true, completion: nil)
    }
    
    @IBAction func btnLikeAcion(_ sender: UIButton) {
        updateButtonState()
        likeDislikeAPIRequest()
    }
    
    @IBAction func btnShareAction() {
        guard let storyID = storyInfo?["id"] as? Int else {return}
        DispatchQueue.main.async {
            let objectsToShare = ["\(kShareUrl)\(storyID)"]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.topVC?.present(activityVC, animated: true, completion: {
                print("shared")
            })
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension StoryCubeCell: StoryCommentsDelegate {
    func CommentCountChanged(count: Int) {
        let strCount = count > 1 ? " \(count) Comments" : " \(count) Comment"
        lblComments?.text = "View all \(strCount)"
    }
}

//MARK: --- API Calls
extension StoryCubeCell {
    func likeDislikeAPIRequest() {
        guard let storyID = storyInfo?["id"] as? Int else {return}
        let url = ("stories/\(storyID)/likes")
        
        let response = DataServiceModal.sharedInstance.ApiPostRequest(PostURL: url, dictData: [:])
        print(response)
    }
}
