//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation
import UIKit

public extension UINavigationController {
    func makeNavigationBarTransparent() {
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.barTintColor = nil
        self.navigationBar.isTranslucent = true
    }
    
    func resetNavigationBar() {
        self.navigationBar.barTintColor = UIColor("#166880")
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    func find(viewController:AnyClass) ->UIViewController? {
        for vc in viewControllers {
            if vc.isKind(of: viewController) {
                return vc
            }
        }
        return nil
    }
}
