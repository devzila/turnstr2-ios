//
//  Loader.swift
//  BoardingPass
//
//  Created by softobiz on 10/13/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

class Loader: UIActivityIndicatorView {

    
    static let sharedInstance: Loader = {
        let instance = Loader()
        
        return instance
    }()
    
    func start(inView: UIView) -> Void {
        self.center = inView.center
        self.style = .gray
        inView.addSubview(self)
        self.startAnimating()
    }
    
    func stop() -> Void {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
        
    }
    
}
