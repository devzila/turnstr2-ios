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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.red
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("go live screen")
        setupVideoView()
        
        if showAlert == true {
            goLIveAlert()
        }
        
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
        uvVideo?.StartSession()
    }
    
    func goLIveAlert() {
        let alertView = UIAlertController(title: "", message: "Do you want to Go-Live?", preferredStyle: .alert)
        let action = UIAlertAction(title: "YES", style: .default, handler: { (alert) in
            self.uvVideo?.StopSession()
            self.showAlert = false
            self.AddUserInCall()
        })
        alertView.addAction(action)
        
        let cancel = UIAlertAction(title: "NO", style: .destructive, handler: { (alert) in
            
        })
        alertView.addAction(cancel)
        self.present(alertView, animated: true, completion: nil)
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
