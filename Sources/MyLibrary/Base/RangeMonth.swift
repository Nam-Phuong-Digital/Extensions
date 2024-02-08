//
//  File.swift
//  
//
//  Created by Dai Pham on 05/02/2024.
//

import Foundation

open class RangeMonth {

    public init() {}
    
    /// example 11 month ago then should be: -11, should be an uninteger
    public var distanceOfMinMonthToCurrent:Int = -12
    
    /// example 1 month next then should be: 1 shoud ble an integer
    public var distanceOfMaxMonthToCurrent:Int = 1
}

public class DefaultRangeMonth: RangeMonth {
    
    public override init() {
        super.init()
        var max = 0
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let currenDate = calendar.component(.day, from: Date())
        if currenDate >= 20 {
            max = 1
        } else {
            max = 0
        }
        distanceOfMaxMonthToCurrent = max
        distanceOfMinMonthToCurrent = -12
    }
}
