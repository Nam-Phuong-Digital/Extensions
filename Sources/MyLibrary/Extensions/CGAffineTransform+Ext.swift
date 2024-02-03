//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation

public extension CGAffineTransform {
    static func flip() -> CGAffineTransform {
        CGAffineTransform.identity.rotated(by: CGFloat(Double.pi)).concatenating(CGAffineTransform(scaleX: -1, y: 1))
    }
}
