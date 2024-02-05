//
//  File.swift
//  
//
//  Created by Dai Pham on 05/02/2024.
//

import Foundation

public protocol RangeMonthProtocol {
    
    /// example 11 month ago then should be: -11, should be an uninteger
    var distanceOfMinMonthToCurrent:Int {get set}
    
    /// example 1 month next then should be: 1 shoud ble an integer
    var distanceOfMaxMonthToCurrent:Int {get set}
}

public struct DefaultRangeMonth: RangeMonthProtocol {
    
    public init() {
        
    }
    
    public var distanceOfMinMonthToCurrent: Int {
        get {
            return -12
        } set {}
    }
    
    public var distanceOfMaxMonthToCurrent: Int {
        get {
            var calendar = Calendar(identifier: .gregorian)
            calendar.firstWeekday = 2
            let currenDate = calendar.component(.day, from: Date())
            if currenDate >= 20 {
                return 1
            } else {
                return 0
            }
        } set {}
    }
}
