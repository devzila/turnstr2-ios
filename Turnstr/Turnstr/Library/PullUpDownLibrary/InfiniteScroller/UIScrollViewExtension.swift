//
//  PullToRefreshConst.swift
//  PullToRefreshSwift
//
//  Created by Yuji Hato on 12/11/14.
//
import Foundation
import UIKit

public extension UIScrollView {

    fileprivate func refreshViewWithTag(_ tag: Int) -> PullToRefreshView? {
        let pullToRefreshView = viewWithTag(tag)
        return pullToRefreshView as? PullToRefreshView
    }

    /// Set has more data to stop infinite scroll

    public var hasMoreData: Bool {
        get {
            let refreshView = self.refreshViewWithTag(PullToRefreshConst.pushTag)
            return refreshView!.hasMoreData
        }
        set(newValue) {
           let refreshView = self.refreshViewWithTag(PullToRefreshConst.pushTag)
            refreshView?.hasMoreData = newValue
        }
    }

    // MARK : Add push and Pull Handlers

    // Add pull to refresh handler on table view

    public func addPullRefreshHandler(_ refreshCompletion: ((Void) -> Void)?) {
        self.addPullRefresh(refreshCompletion)
    }
    // Add push/ Infinite scroll handler on table view
    public func addPushRefreshHandler(_ refreshCompletion: ((Void) -> Void)?) {
        self.addPushRefresh(refreshCompletion)
    }

    // Add pull to refresh
    fileprivate func addPullRefresh(_ refreshCompletion: (((Void) -> Void)?), options: PullToRefreshOption = PullToRefreshOption()) {
        let refreshViewFrame = CGRect(x: 0, y: -PullToRefreshConst.height, width: self.frame.size.width, height: PullToRefreshConst.height)
        let refreshView = PullToRefreshView(options: options, frame: refreshViewFrame, refreshCompletion: refreshCompletion)
        refreshView.tag = PullToRefreshConst.pullTag
        addSubview(refreshView)
    }

    // Add push to refersh

    fileprivate func addPushRefresh(_ refreshCompletion: (((Void) -> Void)?), options: PullToRefreshOption = PullToRefreshOption()) {
        let refreshViewFrame = CGRect(x: 0, y: contentSize.height, width: self.frame.size.width, height: PullToRefreshConst.height)
        let refreshView = PullToRefreshView(options: options, frame: refreshViewFrame, refreshCompletion: refreshCompletion, down: false)
        refreshView.tag = PullToRefreshConst.pushTag
        addSubview(refreshView)
    }

    // MARK : Pull to refresh Function
    // Start pull to refresh to refresh the view
    public func startPullRefresh() {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pullTag)
        refreshView?.state = .refreshing
    }
    // Stop pull to refresh
    public func stopPullRefreshEver(_ ever: Bool = false) {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pullTag)
        if ever {
            refreshView?.state = .finish
        } else {
            refreshView?.state = .stop
        }
    }
    // Remove Pull to refresh in case of finish state
    public func removePullRefresh() {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pullTag)
        refreshView?.removeFromSuperview()
    }
    // MARK : Push to refresh Function
    // Start Push to refresh
    public func startPushRefresh() {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pushTag)
        refreshView?.state = .refreshing
    }
    // Stop push to refersh
    public func stopPushRefreshEver(_ ever: Bool = false) {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pushTag)
        if ever {
            refreshView?.state = .finish
        } else {
            refreshView?.state = .stop
        }
    }
    // Remove push to refresh in case of finish state

    public func removePushRefresh() {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pushTag)
        refreshView?.removeFromSuperview()
    }

    // If you want to PullToRefreshView fixed top potision, Please call this function in scrollViewDidScroll

    public func fixedPullToRefreshViewForDidScroll() {
        let pullToRefreshView = self.refreshViewWithTag(PullToRefreshConst.pullTag)
        if !PullToRefreshConst.fixedTop || pullToRefreshView == nil {
            return
        }
        var frame = pullToRefreshView!.frame
        if self.contentOffset.y < -PullToRefreshConst.height {
            frame.origin.y = self.contentOffset.y
            pullToRefreshView!.frame = frame
        } else {
            frame.origin.y = -PullToRefreshConst.height
            pullToRefreshView!.frame = frame
        }
    }
}
