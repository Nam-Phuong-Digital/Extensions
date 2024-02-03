//
//  File.swift
//  
//
//  Created by Dai Pham on 29/01/2024.
//

import UIKit

public extension UIContextualAction {
    static func create(
        style: UIContextualAction.Style = .normal,
        title:String? = nil,
        image:UIImage? = nil,
        backgroundColor:UIColor? = nil,
        handler:@escaping UIContextualAction.Handler
    ) -> UIContextualAction {
        let action = UIContextualAction(style: style, title: title, handler: handler)
        action.image = image
        action.backgroundColor = backgroundColor
        return action
    }
}
