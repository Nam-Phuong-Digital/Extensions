//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import Foundation

public extension Date {
    
    var dateTimeToString: String? {
        get {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
    var dateTimeToddMMyyyy: String? {
        get {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US")
            df.dateFormat = "dd/MM/yyyy"
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    var dateTimeToTimeHHmm: String? {
        get {
            let df = DateFormatter()
            df.dateFormat = "HH:mm"
            df.locale = Locale(identifier: "en_US")
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
    var dateTimeToDateTimeHHmm: String? {
        get {
            let df = DateFormatter()
            df.dateFormat = "ddMMM HH:mm"
            df.locale = Locale(identifier: "en_US")
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
    var dateTimeToHHmmddMMyyyy: String? {
        get {
            let df = DateFormatter()
            df.dateFormat = "HH:mm dd/MM/yyyy"
            df.locale = Locale(identifier: "en_US")
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
    var dateTimeToddMMM: String {
        get {
            let df = DateFormatter()
            df.dateFormat = "dd\nMMM"
            df.locale = Locale(identifier: "en_US")
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
    var dateTimeTodMMM: String {
        get {
            let df = DateFormatter()
            df.dateFormat = "d MMM yyyy"
            df.locale = Locale(identifier: "en_US")
            let stringFromDate = df.string(from: self)
            return stringFromDate.replacingOccurrences(of: " ", with: "")
            
        }
    }
    
    var toCalendarTaskddMMM: String {
        get {
            let df = DateFormatter()
            df.dateFormat = "dd-MMM"
            df.locale = Locale(identifier: "en_US")
            let stringFromDate = df.string(from: self)
            return stringFromDate.replacingOccurrences(of: " ", with: "")
        }
    }
    
    
    /**
     "yyyy-MM-dd"
    */
    var dateTimeToYYYYMMdd: String {
        get {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            df.locale = Locale(identifier: "en_US")
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
    var dateTimeToArticle: String {
        get {
            let df = DateFormatter()
            df.dateFormat = "EEE, dd MMM HH:mm"
            df.locale = Locale(identifier: "en_US")
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
    var dateTimeToServer: String {
        get {
            let df = DateFormatter()
            df.timeZone = TimeZone(identifier: "UTC")
            df.locale = Locale(identifier: "en_US")
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
    var toStringOriginal: String {
        get {
            let df = DateFormatter()
            df.timeZone = TimeZone(identifier: "UTC")
            df.locale = Locale(identifier: "en_US")
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
    var toStringyyyyMMddHHmmssSSS: String {
        get {
            let df = DateFormatter()
            df.timeZone = TimeZone(identifier: "UTC")
            df.locale = Locale(identifier: "en_US")
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
}

// MARK: -  Calendar
public extension Date {
    func toMonthCalendar() -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let bool = calendar.isDate(self, equalTo: Date(), toGranularity: .year)
        let formatter = DateFormatter()
        formatter.locale = Locale.app
        formatter.dateFormat = bool ? .formatMonthCalendar : .formatMonthYearCalendar
        return formatter.string(from: self)
    }
    
    func toMonthPersonalFlights() -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let bool = calendar.isDate(self, equalTo: Date(), toGranularity: .year)
        let formatter = DateFormatter()
        formatter.locale = Locale.app
        formatter.dateFormat = String.formatPersonalFlights(haveYear: !bool)
        return formatter.string(from: self)
    }
    
    func getTaskMonths(range:RangeMonthProtocol) -> [Date]
    {
        var months = [Date]()

        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let currenDate = calendar.component(.day, from: self)
        let start = range.distanceOfMinMonthToCurrent
        let end = range.distanceOfMaxMonthToCurrent
        var day = calendar.date(byAdding: .month, value: start, to: Date()) ?? Date()
        for _ in start...end {
            months.append(day)
            day.addMonths(n: 1)
        }
        
        return months
    }
    
    func getNext12Months() -> [Date]
    {
        var months = [Date]()

        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2

        var day = self
        for _ in 0..<12 {
            months.append(day)
            day.addMonths(n: 1)
        }
        
        return months
    }
    
    mutating func addDays(n: Int)
    {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        self = calendar.date(byAdding: .day, value: n, to: self)!
    }
    
    mutating func addMonths(n: Int)
    {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        self = calendar.date(byAdding: .month, value: n, to: self)!
    }
    
    func firstDayOfTheMonth() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar.date(from:calendar.dateComponents([.year,.month], from: self))!
    }
    
    func endDayOfTheMonth() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let range = calendar.range(of: .day, in: .month, for: self)!
        var day = firstDayOfTheMonth()
        day.addDays(n: range.count)
        return day
    }
    
    func getAllDays() -> [Date]
    {
        var days = [Date]()

        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2

        let range = calendar.range(of: .day, in: .month, for: self)!

        var day = firstDayOfTheMonth()

        for _ in 1...range.count
        {
            days.append(day)
            day.addDays(n: 1)
        }

        return days
    }
    
    func weekDay() -> Int {
        var calendar = Calendar(identifier: .gregorian)
        if #available(iOS 13.0, *) {
            calendar.firstWeekday = 2
        } else {
            
        }
        return calendar.component(.weekday, from: self)
    }
    
    func weekMonth() -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar.component(.weekOfMonth, from: self)
    }
    
    func toString(format: String = "dd MMMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.app
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func get(
        _ components: Calendar.Component...,
        calendar: Calendar = Calendar.app
    ) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
}
