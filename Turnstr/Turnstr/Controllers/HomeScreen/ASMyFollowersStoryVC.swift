//
//  ASMyFollowersStoryVC.swift
//  Turnstr
//
//  Created by Mr. X on 10/04/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class ASMyFollowersStoryVC: ParentViewController {

    var delegates: ASSearchDelegate?
    
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var uvCollection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
//    var arrMembers: [UserModel] = []
    var arrStories: [StoryModel] = []
    var arrAllData: [Dictionary<String, Any>] = []
    var pageNumber: Int = 1
    
    
    
    var txtSearchText: String = ""
    //var uvCollectionView: UICollectionView?
    //var flowLayout: UICollectionViewFlowLayout?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = kWidth
        tableView.rowHeight = UITableViewAutomaticDimension
        searchStoryResults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func PhotoSize() -> CGSize {
        let photoCellSize = (kWidth)
        return CGSize(width: photoCellSize, height: photoCellSize)
    }
    
    func showPreviewView(_ index: Int) {
        let mvc = StoryPreviewViewController()
        if arrAllData.count > index {
            mvc.dictInfo = arrAllData[index]
        }
        topVC?.navigationController?.pushViewController(mvc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (tableView.contentOffset.y >= (tableView.contentSize.height - scrollView.frame.size.height)) {
            pageNumber = pageNumber+1
            searchStoryResults()
        }
    }
    
    //MARK:- Move cells delegates
    //MARK:- Action Methods
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tapped")
        guard let index = sender?.view?.tag else {return}
        showPreviewView(index)
    }
    
    @IBAction func btnChatAction() {
        guard let vc = Storyboards.chatStoryboard.initialVC() else { return }
        present(vc, animated: true, completion: nil)
    }
    
}

//MARK: ----- UITableViewDelegate, UITableViewDataSource
extension ASMyFollowersStoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCubeCell") as? StoryCubeCell else { fatalError("Cell with id StoryCubeCell is not exists.")}
        cell.cubeView?.createCubewith(kWidth * 1/2)
        cell.cubeView?.backgroundColor = .white
        cell.cubeView?.tag = indexPath.row
        let story  = arrStories[indexPath.row]
        var arrMedia: [String] = []
        for media in story.media! {
            arrMedia.append(media.thumb_url ?? "")
        }
        cell.cubeView?.setup(withUrls: arrMedia)
        cell.cubeView?.setScrollFromNil(CGPoint.init(x: 0, y: kWidth/2), end: CGPoint.init(x: 5, y: kWidth/2))
        cell.cubeView?.setScroll(CGPoint.init(x: kWidth/2, y: 0), end: CGPoint.init(x: kWidth/2, y: 2))
        cell.cubeView?.isUserInteractionEnabled = true
        cell.selectionStyle = .none
        if arrAllData.count > indexPath.row {
            cell.storyInfo = arrAllData[indexPath.row]
        }
        cell.updateOnLikeStatusChanged = { (dict) in
            if let dict = dict {
                self.arrAllData[indexPath.row] = dict
            }
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        cell.cubeView?.addGestureRecognizer(tapGesture)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPreviewView(indexPath.row)
    }
}

extension ASMyFollowersStoryVC {
    func searchStoryResults() {
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        
        //http://18.218.6.149/v1/stories
        
        let strPostUrl = "stories?page=\(pageNumber)"//"search?keyword=a"
        let strParType = ""
        
        DispatchQueue.global().async {
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strPostUrl, parType: strParType)
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        
                        let dictMapper = ["statusCode": statusCode, "stories": dictComments["stories"] ?? ""] as [String : Any]
                        let ksResponse = KSResponse<[StoryModel]>(JSON: dictMapper)
                        if let stories = dictComments["stories"] as? [Dictionary<String, Any>] {
                            self.arrAllData.append(contentsOf: stories)
                        }
                        if let storyArray = ksResponse?.response {
                            var j = self.arrStories.count
                            
                            for object in storyArray {
                                self.arrStories.append(object)
//                                let indexPath = IndexPath.init(row: j, section: 1)
//                                self.uvCollection.insertItems(at: [indexPath])
//                                j = j+1
                            }
                        }
                    }
                } else {
                    kAppDelegate.hideLoadingIndicator()
                }
                self.tableView.reloadData()
                //self.uvCollection.reloadData()
                
            }
        }
    }
}
