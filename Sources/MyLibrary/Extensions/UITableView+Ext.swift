//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation
import UIKit

private var PullRefreshEvent = "PullRefreshEvent"
private var RefreshControl:String = "PullRefreshControl"
public extension UITableView {
    
    func pullResfresh(_ event:@escaping (()->Void)) {
        
        if objc_getAssociatedObject(self, &RefreshControl) == nil {
            let refreshControl = UIRefreshControl()
            objc_setAssociatedObject(self, &RefreshControl, refreshControl, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            refreshControl.attributedTitle = nil//NSAttributedString(string: "pull_to_refresh".localized())
            refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControl.Event.valueChanged)
            self.addSubview(refreshControl)
        }
        
        objc_setAssociatedObject(self, &PullRefreshEvent, event, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func endPullResfresh() {
        if let refreshControl = objc_getAssociatedObject(self, &RefreshControl) as? UIRefreshControl {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        // override it
        if let event = objc_getAssociatedObject(self, &PullRefreshEvent) as? (()->Void) {
            event()
        }
    }
}
