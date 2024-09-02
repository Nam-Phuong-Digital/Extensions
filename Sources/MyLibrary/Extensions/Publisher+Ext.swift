//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import Combine

@available(iOS 13,*)
public extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}
