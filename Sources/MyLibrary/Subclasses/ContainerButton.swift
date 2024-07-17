//
//  File.swift
//  
//
//  Created by Dai Pham on 17/7/24.
//

import UIKit

public class ContainerButton: UIControl {
    
    public var disabledSubviews: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach({ $0.isUserInteractionEnabled = !disabledSubviews })
    }
}
