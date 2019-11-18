//
//  Extension.swift
//  PullUpDownLibrary

import Foundation
import UIKit

extension UITableView {
        // Remove Pull to refresh loader
    func stopPullToRefreshLoader() {
        self.dg_stopLoading()

    }
     // Remove  infinite scroll view loader
    func stopInfiniteScrollLoader() {
          self.stopPushRefreshEver()

    }
}
