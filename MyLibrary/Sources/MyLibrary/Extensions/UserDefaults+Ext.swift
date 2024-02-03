//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import Foundation

public extension UserDefaults {
    
    static let dataSuite = { () -> UserDefaults in
        guard let dataSuite = UserDefaults(suiteName: "group.cabin") else {
            return UserDefaults.standard
        }
        return dataSuite
    }()
}
