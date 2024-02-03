//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import Foundation

public extension Dictionary where Key == String, Value == Optional<Any> {
    func discardNil() -> [Key: Any] {
        return self.compactMapValues({ $0 })
    }
}
