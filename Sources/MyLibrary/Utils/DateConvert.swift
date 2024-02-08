//
//  File.swift
//  
//
//  Created by Dai Pham on 08/02/2024.
//

import Foundation

public class DateConvert {
    
    private var date:Date?
    private var dateString:String?
    
    public init(
        date: Date? = nil,
        dateString: String? = nil,
        formatOutput:String = "yyyy-MM-dd'T'HH:mm:ss"
    ) {
        if let dateString {
            self.dateString = dateString
            fromStringToDate(dateString: dateString)
        }
        if let date {
            self.date = date
            fromDateToString(date: date, format: formatOutput)
        }
    }
    
    public func getDate() -> Date? {
        return date
    }
    
    public func getDateString() -> String? {
        return dateString
    }
    
    private func fromDateToString(
        date:Date,
        format:String = "yyyy-MM-dd'T'HH:mm:ss"
    ) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let locale = Locale(identifier: "en_US_POSIX")
        df.locale = locale
        let date = df.string(from: date)
        self.dateString = date
    }
    
    private func fromStringToDate(
        dateString:String
    ) {
        let df = DateFormatter()
        df.dateFormat = detectFormatString(dateString)
        let locale = Locale(identifier: "en_US_POSIX")
        df.locale = locale
        df.timeZone = TimeZone(identifier:"UTC")
        let dateFromString = df.date(from: dateString)
        self.date = dateFromString
    }
    
    public func detectFormatString(_ dateString:String) -> String {
        let regex1 = "^\\d{4}-\\d{2}-\\d{2}[']T[']\\d{2}:\\d{2}:\\d{2}$"
        let regex2 = "^\\d{4}-\\d{2}-\\d{2}[']T[']\\d{2}:\\d{2}:\\d{2}.\\d{3}$"
        
        if NSPredicate(format: "SELF MATCHES %@", regex2).evaluate(with: dateString) {
            return "yyyy-MM-dd'T'HH:mm:ss.SSS"
        }
        return "yyyy-MM-dd'T'HH:mm:ss"
    }
}
