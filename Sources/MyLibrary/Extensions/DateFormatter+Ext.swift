//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation

public extension DateFormatter {
    convenience init(format:String = "") {
        self.init()
        calendar = .app
    }
}
