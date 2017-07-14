//
//  LiveFeedsViewController.swift
//  Turnstr
//
//  Created by Mr X on 14/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class LiveFeedsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.red
        
        let transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: 300), cube_size: 100)
        
        transformView?.backgroundColor = UIColor.white
        
        transformView?.setup(withUrls: ["https://s3-us-west-2.amazonaws.com/turnstr2-staging/users/avatar_face1s/000/000/003/medium/user_avatar_face1_?1499875613", "https://s3-us-west-2.amazonaws.com/turnstr2-staging/stories/face1_media/000/000/007/thumb/img2.png?1499097845", "https://s3-us-west-2.amazonaws.com/turnstr2-staging/stories/face1_media/000/000/016/thumb/dairies.jpg?1499980195", "https://s3-us-west-2.amazonaws.com/turnstr2-staging/stories/face4_media/000/000/016/thumb/icecrm.jpeg?1499980196"])
        
        self.view.addSubview(transformView!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
