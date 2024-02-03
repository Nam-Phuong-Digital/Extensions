//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import UIKit

public extension UITableViewHeaderFooterView {
    func setBGColor(_ color:UIColor) {
        let bgV = UIView()
        if #available(iOS 14, *) {
            var cg = UIBackgroundConfiguration.clear()
            cg.customView = bgV
            backgroundConfiguration = cg
        } else {
            backgroundView = bgV
        }
        bgV.backgroundColor = color
    }
}

public extension UICollectionViewCell {
    func setBGColor(_ color:UIColor) {
        let bgV = UIView()
        if #available(iOS 14, *) {
            var cg = UIBackgroundConfiguration.clear()
            cg.customView = bgV
            backgroundConfiguration = cg
        } else {
            backgroundView = bgV
        }
        bgV.backgroundColor = color
    }
}

public extension UITableViewCell {
    func setBGColor(_ color:UIColor) {
        let bgV = UIView()
        if #available(iOS 14, *) {
            var cg = UIBackgroundConfiguration.clear()
            cg.customView = bgV
            backgroundConfiguration = cg
        } else {
            backgroundView = bgV
        }
        bgV.backgroundColor = color
    }
}
