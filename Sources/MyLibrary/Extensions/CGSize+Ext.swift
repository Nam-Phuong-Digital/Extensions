//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation
import UIKit

public extension CGSize {
    static var getSizeNavigationBarIncludeStatus: CGSize {
        if let nv = UIApplication.shared.windows.last?.visibleViewController as? UINavigationController {
            return CGSize(width: nv.navigationBar.frame.width, height: nv.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
        }
        return UIApplication.shared.statusBarFrame.size
    }
    
    static var standardButtonBar:CGSize {
        CGSizeMake(20, 20)
    }
}
