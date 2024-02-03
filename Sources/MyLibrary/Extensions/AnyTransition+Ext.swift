//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import SwiftUI

@available (iOS 13,*)
public extension AnyTransition {
    static var appearFromTop: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
    
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    static var scaleup: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 1).combined(with: .opacity),
            removal: .scale(scale: 0.3).combined(with: .opacity)
        )
    }
}
