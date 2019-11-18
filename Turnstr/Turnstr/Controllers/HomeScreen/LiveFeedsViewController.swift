//
//  LiveFeedsViewController.swift
//  Turnstr
//
//  Created by Mr X on 14/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class LiveFeedsViewController: UIViewController, UserListDelegate {
    
    var uvVideo: VideoView?
    var showAlert: Bool = true
    var btnGolive = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        setupVideoView()
        
        if IS_IPHONEX {
            btnGolive.frame = CGRect.init(x: 20, y: kHeight-160, width: kWidth - 40, height: 40)
        } else {
            btnGolive.frame = CGRect.init(x: 20, y: kHeight-110, width: kWidth - 40, height: 40)
        }
        
        btnGolive.setTitle("Start public video", for: .normal)
        btnGolive.backgroundColor = kOrangeColor
        btnGolive.setTitleColor(UIColor.white, for: .normal)
        btnGolive.layer.cornerRadius = 5.0
        btnGolive.layer.masksToBounds = true
        btnGolive.layer.borderWidth = 1.0
        btnGolive.layer.borderColor = kBlueColor.cgColor
        btnGolive.addTarget(self, action: #selector(goLIveAlert), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("go live screen")
        
        uvVideo?.StartSession()
        
        self.view.addSubview(btnGolive)
        
        
        //        if showAlert == true {
        //            goLIveAlert()
        //        }
        //
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        uvVideo?.StopSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //MARK: Video View
    //MARK:
    
    func setupVideoView() {
        if uvVideo == nil {
            uvVideo = VideoView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
            //uvVideo?.delegate = self
            uvVideo?.progressView.isHidden = true
            uvVideo?.btnVideoCap.isHidden = true
            uvVideo?.btnSelfiCap.isHidden = true
            uvVideo?.SelfyCaptureClicked(sender:(uvVideo?.btnSelfiCap)!)
        }
        self.view.addSubview(uvVideo!)
        
    }
    
    @objc func goLIveAlert() {
        self.uvVideo?.StopSession()
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let vc: MultiCallViewController = storyboard.instantiateViewController(withIdentifier: "MultiCallViewController") as! MultiCallViewController
        vc.userType = .caller
        vc.screenTYPE = .goLive
        self.topVC?.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func AddUserInCall() {
        guard let vc = Storyboards.chatStoryboard.initialVC(with: .usersList) else { return }
        let vcc = vc as! UsersListVC
        vcc.screenTYpe = .calling
        vcc.delegate = self
        present(vcc, animated: true, completion: nil)
    }
    
    func UserSelected(userId: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showAlert = true
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let vc: MultiCallViewController = storyboard.instantiateViewController(withIdentifier: "MultiCallViewController") as! MultiCallViewController
            vc.userType = .caller
            vc.recieverId = userId
            self.topVC?.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
