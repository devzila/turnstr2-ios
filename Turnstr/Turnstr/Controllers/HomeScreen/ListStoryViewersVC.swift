
//
//  ListStoryViewersVC.swift
//  Turnstr
//
//  Created by Kamal on 12/08/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit

class ListStoryViewersVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView?
    var storyId: String?
    var currentPage: Int = 1
    var totalPages: Int = 1
    lazy var arrayUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "UserStoryCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "UserStoryCell")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCallToListAllViewers()
    }
    
    //MARK: --- Action Methods
    @IBAction func btnCancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//MARK: --- API Calls
extension ListStoryViewersVC {
    
    func apiCallToListAllViewers() {
        guard let id = storyId else { return }
        kAppDelegate.loadingIndicationCreation()
        let strEndPoint = "user/user_stories/\(id)/views"
        print(strEndPoint)
        let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strEndPoint, parType: "")
        DispatchQueue.main.async {
            if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                kAppDelegate.hideLoadingIndicator()
                if self.currentPage == 1 {
                    self.arrayUsers = [User]()
                }
                if let data = dictResponse["data"]?["data"] as? [String: Any] {
                    
                    if let page = data["current_page"] as? Int {
                        self.currentPage = page
                    }
                    if let page = data["total_pages"] as? Int {
                        self.totalPages = page
                    }
                    if let objs = data["views"] as? [Any] {
                        for obj in objs {
                            let user = User(withStoryInfo: obj as? [String: Any])
                            self.arrayUsers.append(user)
                        }
                    }
                }
            } else {
                kAppDelegate.hideLoadingIndicator()
            }
            self.collectionView?.reloadData()
        }
    }
}



//MARK: ----- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ListStoryViewersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserStoryCell", for: indexPath) as? UserStoryCell else { fatalError("UserStoryCell is missing.")}
        cell.size = kWidth/3 * 1/2
        cell.user = arrayUsers[indexPath.item]
        cell.cubeProfileView?.isUserInteractionEnabled = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = kWidth/3
        return CGSize(width: side, height: side)
    }
    
}
