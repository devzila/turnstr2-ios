//
//  HomeViewController.swift
//  Turnstr
//
//  Created by Mr X on 09/05/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class HomeViewController: ParentViewController {

    var transformView: AITransformView?
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var uvCenterCube: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblUserName.text = "@"+objSing.strUserName.lowercased()
        lblDescription.text = objSing.strUserBio
        //transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        //self.view = transformView
        
        transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 5, width: kWidth, height: uvCenterCube.frame.size.height-10))
        uvCenterCube.addSubview(transformView!)
        //self.view = transformView
        
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
