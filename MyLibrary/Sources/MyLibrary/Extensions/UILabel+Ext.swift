//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import UIKit

public extension UILabel {
    
    typealias ELEMENT_ATTRIBUTE = (text:String,color:UIColor?,font:UIFont?)
    
    /// set attribute text
    /// - Parameter elements: element include: 0: text, 1: forgroundColro, 2: UIFont
    func setAttribute(elements:[ELEMENT_ATTRIBUTE]) {
        
        let mutable = NSMutableAttributedString(string: "")
        
        elements.forEach {
            mutable.append($0.text.toAttributed(font: $0.font, foregroundColor: $0.color))
        }
        attributedText = mutable
    }
}

extension UILabel: XIBLocalizable {
    @IBInspectable public var locKey: String? {
        get { return nil }
        set(key) {
            text = key?.localizedString()
        }
   }
}
