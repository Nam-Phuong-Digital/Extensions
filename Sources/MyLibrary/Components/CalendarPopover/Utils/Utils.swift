//
//  File.swift
//  
//
//  Created by Dai Pham on 7/4/24.
//

import Foundation
import UIKit

public extension UIView {
    func getScrollView(_ level:Int = 0) -> UIScrollView? {
        var max:Int = level
        if let parent = self.superview {
            if let parent = parent as? UIScrollView {
                return parent
            } else {
                if level == 10 {
                    return nil
                }
                max += 1
                return parent.getScrollView(max)
            }
        }
        return nil
    }
}

public extension String {
    static var formatLongMonthCalendar:String {
        "MMMM"
    }
    
    static var formatLongMonthYearCalendar:String {
        "MMMM yyyy"
    }
    
    static var formatMonthCalendar:String {
        Locale.isEn ? "MMM" : "MMMM"
    }
    
    static var formatMonthYearCalendar:String {
        Locale.isEn ? "MMM yyyy" : "MMMM yyyy"
    }
}

public extension Locale {
    static var app:Locale {Locale.current}
    static var isEn:Bool {!app.identifier.contains("vi")}
}

public extension UIImage {
    func resize(newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImage = newImage else {
            return self
        }
        return newImage
    }
    
    func tintImage(with color: UIColor) -> UIImage {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        UIGraphicsEndImageContext()
        return image
    }
}

fileprivate var cacheDate:[String:[Date]] = [:]
public extension Date {
    func get(
        _ components: Calendar.Component...,
        calendar: Calendar = Calendar.app
    ) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
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
    
    func getTaskMonths(range:RangeMonth = DefaultRangeMonth()) -> [Date]
    {
        var months = [Date]()

        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let currenDate = Date()
        let start = range.distanceOfMinMonthToCurrent
        let end = range.distanceOfMaxMonthToCurrent
        var day = calendar.date(byAdding: .month, value: start, to: currenDate) ?? currenDate
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
        guard let date = calendar.date(from:calendar.dateComponents([.year,.month], from: self)) else {
            return self
        }
        return calendar.startOfDay(for: date)
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
        var day = firstDayOfTheMonth()
        let key = day.toStringOriginal
        if let cache = cacheDate[key], !cache.isEmpty {
            return cache
        }
        var days = [Date]()

        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2

        let range = calendar.range(of: .day, in: .month, for: self)!

        for _ in 1...range.count
        {
            days.append(day)
            day.addDays(n: 1)
        }
        cacheDate[key] = days
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
}

public extension Date {
    func toMonthCalendar(isLongName:Bool = false) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let bool = calendar.isDate(self, equalTo: Date(), toGranularity: .year)
        let formatter = DateFormatter()
        formatter.locale = Locale.app
        formatter.dateFormat = bool ? (isLongName ? .formatLongMonthCalendar : .formatMonthCalendar) : (isLongName ? .formatLongMonthYearCalendar : .formatMonthYearCalendar)
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
}

public class IconCalendarImageView: UIImageView {
    
    // MARK: -  override
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
}
