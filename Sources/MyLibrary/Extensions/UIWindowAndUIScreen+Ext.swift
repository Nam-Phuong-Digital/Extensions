//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation
import UIKit

public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    var visibleTabbarOrNavigationBarController: UIViewController? {
        return UIWindow.getVisibleTabbarOrNavigationControllerFrom(self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            if nc.viewControllers.count == 0 {
                return nc
            }
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
    
    static func getVisibleTabbarOrNavigationControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return nc
        } else if let tc = vc as? UITabBarController {
            return tc
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleTabbarOrNavigationControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

public extension UIScreen {
    static var bounceWindow:CGRect {
        get {
            return UIApplication.shared.keyWindow?.frame ?? UIScreen.main.bounds
        }
    }
    
    static func getMinimumContentSafeAreaBottomView() -> CGFloat {
        if let nv = UIApplication.shared.keyWindow?.visibleViewController?.navigationController,
            let vc = nv.viewControllers.first {
            if #available(iOS 11.0, *) {
                if vc.view.safeAreaInsets.bottom == 0 {
                    return 10
                }
                return vc.view.safeAreaInsets.bottom
            } else {
                return 10
            }
        }
        return 10
    }
}

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
