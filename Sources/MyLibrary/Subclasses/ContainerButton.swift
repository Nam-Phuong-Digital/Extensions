//
//  File.swift
//  
//
//  Created by Dai Pham on 17/7/24.
//

import UIKit

class ContainerButton: UIControl {
    
    public var disabledSubviews: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach({ $0.isUserInteractionEnabled = !disabledSubviews })
    }
}
