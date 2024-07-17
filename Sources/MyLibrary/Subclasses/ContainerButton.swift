//
//  File.swift
//  
//
//  Created by Dai Pham on 17/7/24.
//

import UIKit
#if canImport(RxSwift)
import RxSwift
import RxCocoa

extension Reactive where Base: ContainerButton {
    
    /// Reactive wrapper for `TouchUpInside` control event.
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}
#endif

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
