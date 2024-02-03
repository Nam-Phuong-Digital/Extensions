//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation

#if canImport(Combine)
import Combine
#endif

@available(iOS 13.0, *)
open class BaseObservableObject:ObservableObject {
    
    @Published public var isRequest:Bool = false
    @Published public var error:String?
    lazy public var cancellables = Set<AnyCancellable>()
    
    /// super init involke code observer error puslisher
    public init() {
        
    }
}
