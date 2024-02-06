//
//  CEVMonth.swift
//  Cabinbook
//
//  Created by Dai Pham on 04/02/2024.
//  Copyright © 2024 Nam Phuong Digital. All rights reserved.
//

import Foundation

public class CEVMonth:Identifiable, Hashable {
    public static func == (lhs: CEVMonth, rhs: CEVMonth) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public var id: String {identifier}
    let identifier:String = .generateIdentifier
    let date:Date
    var days:[CEVDate]
    init(date: Date, days: [CEVDate]) {
        self.date = date
        self.days = days
    }
    func isEqual(_ date:Date?) -> Bool {
        guard let date = date else {return false}
        let compoNew = date.get(.month,.year)
        let compoown = self.date.get(.month,.year)
        return compoNew.month == compoown.month && compoNew.year == compoown.year
    }
}

public class CEVDate:Identifiable, Hashable {
    public static func == (lhs: CEVDate, rhs: CEVDate) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public var id: String {identifier}
    let identifier:String = .generateIdentifier
    let text:String
    let date:Date
    let disabled:Bool
    let isBelongCurrentMonth:Bool
    
    init(
        text: String,
        date: Date,
        disabled:Bool = false,
        isBelongCurrentMonth:Bool = true
    ) {
        self.text = text
        self.date = date
        self.disabled = disabled
        self.isBelongCurrentMonth = isBelongCurrentMonth
    }
    
    var isDisabled:Bool {
        if disabled {
            return disabled
        }
        let calendar = Calendar.app
        return calendar.startOfDay(for: date).timeIntervalSince1970 < calendar.startOfDay(for: Date()).timeIntervalSince1970
    }
    
    func isEqual(_ date:Date?) -> Bool {
        guard let date = date else {return false}
        let calendar = Calendar.app
        return calendar.startOfDay(for: date).timeIntervalSince1970 == calendar.startOfDay(for: self.date).timeIntervalSince1970
    }
    
    var keyEvent:(String,Int?,Int?){
        let calendar = Calendar.app
        let coms = calendar.dateComponents([.month,.year], from: date)
        guard let month = coms.month, let year = coms.year else {return ("",coms.month,coms.year)}
        return ("\(month)-\(year)",month,year)
    }
    var textNumber:String {
        if let number = Int(text) {
            if number < 10 {
                return " \(number) "
            }
            return "\(number)"
        }
        return text
    }
    var shouldHidden:Bool{
        disabled
    }
}

enum WeekDay:Int {
    case sun = 1
    case mon = 2
    case tue = 3
    case web = 4
    case thu = 5
    case fri = 6
    case sat = 7
    
    static var allCases:[WeekDay] {
        [.mon,.tue,.web,.thu,.fri,.sat,.sun]
    }
    
    var toString:String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .app
        let days = calendar.shortWeekdaySymbols
        if days.count == WeekDay.allCases.count {
            return days[self.rawValue - 1]
        } else {
            switch self {
            case .sun:
                return "CN"
            case .mon:
                return "T.2"
            case .tue:
                return "T.3"
            case .web:
                return "T.4"
            case .thu:
                return "T.5"
            case .fri:
                return "T.6"
            case .sat:
                return "T.7"
            }
        }
    }
}
