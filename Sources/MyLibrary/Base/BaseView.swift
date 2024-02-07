//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import UIKit
#if canImport(Combine)
import Combine
#endif

@available (iOS 13,*)
open class BaseObservableView: UIView {
    
    lazy public var cancellables = Set<AnyCancellable>()
}
