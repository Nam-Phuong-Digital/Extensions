//
//  Struct+Protocol.swift
//  MyLibrary
//
//  Created by Dai Pham on 24/8/24.
//

import Foundation

protocol Mutable {
}

extension Mutable {
    func mutateOne<T>(transform: (inout Self) -> T) -> Self {
        var newSelf = self
        _ = transform(&newSelf)
        return newSelf
    }

    func mutate(transform: (inout Self) -> Void) -> Self {
        var newSelf = self
        transform(&newSelf)
        return newSelf
    }

    func mutate(transform: (inout Self) throws -> Void) rethrows -> Self {
        var newSelf = self
        try transform(&newSelf)
        return newSelf
    }
}
