//
//  ChatVCExtension.swift
//  Turnstr
//
//  Created by Kamal on 20/08/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import Foundation
import SendBirdSDK

extension ChatVC {
    
    func initUserInfo() {
        
        if (channel?.members?.count ?? 0) > 2 {
            createGroupCube()
        }
        else {
            createOppoentCube()
        }
    }
    
    func createOppoentCube() {
        guard let members = channel?.members as? [SBDUser] else {
            return
        }
        for member in members {
            if member.userId != loginUser.id {
                guard let urls = member.profileUrl?.components(separatedBy: ",") else {
                    return
                }
                createCubeWithUrls(urls)
            }
        }
    }
    
    func createGroupCube() {
        
    }
    
    func createCubeWithUrls(_ urls: [String]?) {
        
        guard let urls = urls else {
            return
        }
        let w: CGFloat = cubeView?.frame.size.width ?? 75.0
        let h: CGFloat = cubeView?.frame.size.height ?? 75.0
        
        cubeView?.backgroundColor = .clear
        var topCube = cubeView?.viewWithTag(kCubeTag) as? AITransformView
        topCube?.removeFromSuperview()
        if topCube == nil {
            topCube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: w, height: h), cube_size: 60)
            topCube?.tag = kCubeTag
            cubeView?.addSubview(topCube!)
            cubeView?.backgroundColor = .clear
        }
        
        topCube?.setup(withUrls: urls)
        
        topCube?.setScroll(CGPoint.init(x: 0, y: h/2), end: CGPoint.init(x: 20, y: h/2))
        topCube?.setScroll(CGPoint.init(x: w/2, y: 0), end: CGPoint.init(x: w/2, y: 10))
    }
}
