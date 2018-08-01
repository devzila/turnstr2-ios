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
    @IBOutlet weak var lblLikeCount: UILabel?
    @IBOutlet weak var lblCommentCount: UILabel?
    
    
    var storyInfo: Dictionary<String, Any>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateButtonState(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
        updateButtonState(sender)
        likeDislikeAPIRequest(sender)
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
//        lblCommentCount.text = "\(count) \(count > 1 ? "Comments" : "Comment")"
    }
}

//MARK: --- API Calls
extension StoryCubeCell {
    func likeDislikeAPIRequest(_ sender: UIButton) {
        guard let storyID = storyInfo?["id"] as? Int,
        let url = URL(string: (kBaseURL + "stories/\(storyID)/likes")) else {return}
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 20.0)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                self.updateButtonState(sender)
            }
        }.resume()
    }
}
