//
//  ShortStoryVC.swift
//  Turnstr
//
//  Created by Kamal on 11/08/18.
//  Copyright © 2018 Ankit Saini. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ShortStoryVC: UIViewController {
    
    @IBOutlet weak var lblUsername: UILabel?
    @IBOutlet weak var cubeProfileView: AITransformView?
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var btnPeopleWhoViewed: UIButton?
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNewStory: UIButton!
    
    let btnNext = UIButton()
    let btnPrev = UIButton()
    
    var user: User?
    
    var arrStories: [UserStories] = []
    var cv: CubePageView?
    var arrPlayers: [AVPlayer?] = []
    var currentIndex: Int = 0
    
    @IBOutlet weak var uvStories: UIView!
    
    //MARK:- View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUsername?.text = user?.username
        print(Singleton.sharedInstance.strUserID)
        
        btnNewStory.layer.cornerRadius = 5.0
        btnNewStory.layer.borderWidth = 1.0
        btnNewStory.layer.borderColor = kBlueColor.cgColor
        
        
        let userUrls = user?.cubeUrls.map({$0.absoluteString})
        cubeProfileView?.createCubewith(35)
        cubeProfileView?.setup(withUrls: userUrls)
        cubeProfileView?.backgroundColor = .clear
        cubeProfileView?.setScrollFromNil(CGPoint.init(x: 0, y: 30), end: CGPoint.init(x: 5, y: 30))
        cubeProfileView?.setScroll(CGPoint.init(x: 30, y: 0), end: CGPoint.init(x: 30, y: 2))
        cubeProfileView?.isUserInteractionEnabled = false
        
        btnBack.setImage(UIImage.init(named: "cross")?.setMode(MODE: .alwaysTemplate), for: .normal)
        btnBack.imageView?.tintColor = .white
        
        btnPeopleWhoViewed?.setImage(UIImage.init(named: "eye")?.setMode(MODE: .alwaysTemplate), for: .normal)
        btnPeopleWhoViewed?.imageView?.tintColor = .white
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if cv != nil{
            cv?.removeFromSuperview()
            cv = nil
        }
        
        self.arrPlayers.removeAll()
        self.arrStories.removeAll()
        self.currentIndex = 0
        self.apiCallStoryDetail()
    }
    
    //MARK: --- Action Methods
    
    @IBAction func actNewStory(_ sender: UIButton) {
        stopAllPlayers()
        kMainQueue.asyncAfter(deadline: .now()) {
            ///Open Camera
            let camVC = CameraViewController(nibName: "CameraViewController", bundle: nil)
            camVC.kScreenType = .newStory
            self.topVC?.navigationController?.pushViewController(camVC, animated: true)
        }
    }
    
    @IBAction func btnCancelAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUserWhoHasViewedTheStory() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ListStoryViewersVC") as? ListStoryViewersVC else { return }
        vc.storyId = "\(arrStories[currentIndex].id)"
        present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- ACTION Method
    @objc func NextClicked(sender: UIButton) -> Void {
        if cv != nil {
            print(cv?.currentPage())
            let totalPage = cv!.numberPages()
            let currentPage = cv!.currentPage()
            let nextPage = currentPage+1
            if nextPage < totalPage {
                cv?.selectPage(nextPage, withAnim: true)
            } else{
                cv?.selectPage(0, withAnim: true)
            }
        }
    }
    
    @objc func PrevClicked(sender: UIButton) -> Void {
        if cv != nil {
            print(cv?.currentPage())
            let totalPage = cv!.numberPages()
            let currentPage = cv!.currentPage()
            let prePage = currentPage-1
            if prePage > -1 {
                cv?.selectPage(prePage, withAnim: true)
            } else{
                cv?.selectPage(totalPage-1, withAnim: true)
            }
        }
    }
    
    //MARK:- STORY VIEW
    
    func PagingButtons() {
        btnNext.frame = CGRect.init(x: kWidth-100, y: 0, width: 100, height: uvStories.frame.height)
        btnNext.addTarget(self, action: #selector(NextClicked(sender:)), for: .touchUpInside)
        btnNext.backgroundColor = .clear
        uvStories.addSubview(btnNext)
        
        btnPrev.frame = CGRect.init(x: 0, y: 0, width: 100, height: uvStories.frame.height)
        btnPrev.addTarget(self, action: #selector(PrevClicked(sender:)), for: .touchUpInside)
        btnPrev.backgroundColor = .clear
        uvStories.addSubview(btnPrev)
    }
    
    func setupPages() {
        
        var arrPages: [Any] = []
        let frame = CGRect.init(x: 0, y: 0, width: kWidth, height: uvStories.frame.height)
        
        for (index, item) in arrStories.enumerated() {
            
            if index == 0 {
                self.btnPeopleWhoViewed?.setTitle("\(item.view_count)", for: .normal)
                self.btnPeopleWhoViewed?.isEnabled = false
                self.apiIncreaseCount()
            }
            
            print(item.content_type)
            if item.content_type == storyContentType.video.rawValue {
                
                let frame = CGRect.init(x: 0, y: 0, width: kWidth, height: frame.height)
                let imgView = UIView.init(frame: frame)
                imgView.backgroundColor = UIColor.black
                
                let url = URL.init(string: item.media_url)
                if url == nil {
                    return
                }
                
                let playerAV = AVPlayer.init(url: url!)
                let playerLayerAV = AVPlayerLayer(player: playerAV)
                
                playerLayerAV.videoGravity = AVLayerVideoGravity.resizeAspectFill
                
                playerAV.isMuted = true
                playerLayerAV.frame = frame
                imgView.layer.addSublayer(playerLayerAV)
                arrPages.append(imgView)
                if index == 0 { // if first item the start playing
                    playerAV.isMuted = false
                    playerAV.play()
                }
                arrPlayers.append(playerAV)
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerAV.currentItem, queue: .main) { (_) in
                    playerAV.seek(to: CMTime.zero)
                    playerAV.play()
                }
                
            }
            else if item.content_type.isEmpty == true {
                arrPlayers.append(nil)
            }
            else{
                arrPlayers.append(nil)
                
                let imgView = UIImageView.init(frame: frame)//CGRect.init(x: kWidth*CGFloat(j), y: 0, width: kWidth, height: scrScrollView.frame.height)
                imgView.sd_setImage(with: URL.init(string: item.media_url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
                imgView.contentMode = .scaleAspectFit
                imgView.backgroundColor = UIColor.black
                
                imgView.isUserInteractionEnabled = true
                
                //                let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
                //                //tap.delegate = self
                //                tap.numberOfTapsRequired = 1
                //                imgView.addGestureRecognizer(tap)
                
                arrPages.append(imgView)
            }
        }
        
        
        cv = CubePageView.init(frame: frame)
        cv?.delegate = self
        cv?.setPages(arrPages)
        uvStories.addSubview(cv!)
        
        PagingButtons()
    }
    
    deinit {
        stopAllPlayers()
        remoAllPlayers()
    }
    
}
extension ShortStoryVC: CubePageView_Delegate {
    func actMuteClicked(sender: UIButton)  {
        guard let accessEle = sender.accessibilityElements else {return}
        if accessEle.count > 0, let _ = accessEle.first as? AVPlayer {
            sender.isSelected = !sender.isSelected
        }
    }
    
    func cubePageView(_ pc: CubePageView!, newPage page: Int32) {
        print("Page : \(page)")
        currentIndex = Int(page)
        
        self.btnPeopleWhoViewed?.setTitle("\(arrStories[currentIndex].view_count)", for: .normal)
        self.btnPeopleWhoViewed?.isEnabled = false
        self.apiIncreaseCount()
        
        stopAllPlayers()
        
        if arrPlayers.count > page {
            guard let player = self.arrPlayers[Int(page)] else {return}
            player.isMuted = false
            player.play()
        }
    }
    
    func stopAllPlayers() {
        ///Stop all previous players
        for player in arrPlayers{
            if player != nil {
                player!.isMuted = true
                player?.pause()
            }
        }
    }
    
    func remoAllPlayers() {
        for player in arrPlayers {
            var playerAv = player
            if playerAv != nil {
                playerAv!.isMuted = true
                playerAv = nil
            }
        }
    }
}


//MARK: --- API Calls
extension ShortStoryVC {
    func apiCallStoryDetail() {
        guard let id = user?.id else { return }
        if id == Singleton.sharedInstance.strUserID {
            self.btnNewStory.isHidden = false
            kAppDelegate.loadingIndicationCreation()
            self.getAllMyStories(userId: id)
            return
        }
        
        kAppDelegate.loadingIndicationCreation()
        let strEndPoint = "user/user_stories/\(id)"
        //let strEndPoint = "user/my_user_stories"
        let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strEndPoint, parType: "")
        DispatchQueue.main.async {
            if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                kAppDelegate.hideLoadingIndicator()
                
                if let data = dictResponse["data"]?["data"] as? [String: Any],let stories = data["user_stories"] as? [Dictionary<String, Any>]{
                    for item in stories {
                        let obj = UserStories.init(dict: item)
                        self.arrStories.append(obj)
                    }
                    self.setupPages()
                }
            } else {
                kAppDelegate.hideLoadingIndicator()
            }
            
        }
    }
    
    func getAllMyStories(userId: String = "0") {
        var strRequest = ""
        strRequest = "members/\(userId)"
        let strPostUrl = "\(strRequest)/\(kAPIGetVideos)"
        
        
        kBQ_getVideos.async {
            
            let dictResponse = WebServices.sharedInstance.GetMethodServerData(strRequest: "", GetURL: strPostUrl, parType: "")
            print(dictResponse)
            DispatchQueue.main.async {
                if let statusCode = dictResponse["statusCode"] as? Int, statusCode == 200 {
                    kAppDelegate.hideLoadingIndicator()
                    
                    if let dictComments = dictResponse["data"]?["data"] as? [String: AnyObject] {
                        if let stories = dictComments["my_user_stories"] as? [Dictionary<String, Any>] {
                            for dict in stories {
                                let storyVideo = UserStories.init(dict: dict)
                                self.arrStories.append(storyVideo)
                            }
                            self.setupPages()
                        }
                    }
                    
                } else {
                    kAppDelegate.hideLoadingIndicator()
                }
            }
        }
    }
    
    func apiIncreaseCount() {
        guard let id = user?.id else { return }
        if id == Singleton.sharedInstance.strUserID {
            //If this user is logged in user
            return
        }
        
        let storyId = "\(arrStories[currentIndex].id)"
        let strEndPoint = "user/user_stories/\(storyId)"
        print(strEndPoint)
        kBQ_LogViewCountData.async{
            let dictResponse = WebServices.sharedInstance.putDataToserver(JSONString: "", PutURL: strEndPoint, parType: "")
            print(dictResponse)
            kMainQueue.async{
                kAppDelegate.hideLoadingIndicator()
            }
        }
    }
}

struct UserStories {
    var id: Int
    var media_url: String
    var content_type: String
    var view_count: Int
    
    init(dict: Dictionary<String, Any>) {
        if let obj = dict["id"] as? Int {
            self.id = obj
        } else{
            self.id = 0
        }
        
        if let obj = dict["media_url"] as? String {
            self.media_url = obj
        } else{
            self.media_url = ""
        }
        
        if let obj = dict["content_type"] as? String {
            self.content_type = obj
        } else{
            self.content_type = ""
        }
        
        if let obj = dict["view_count"] as? Int {
            self.view_count = obj
        } else{
            self.view_count = 0
        }
        
        
    }
}
