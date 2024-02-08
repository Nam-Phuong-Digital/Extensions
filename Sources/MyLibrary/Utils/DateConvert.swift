//
//  File.swift
//  
//
//  Created by Dai Pham on 08/02/2024.
//

import Foundation

public class DateConvert {
    
    public var date:Date?
    public var dateString:String?
    
    public func fromDateUTCoString(
        date:Date,
        format:String = "yyyy-MM-dd'T'HH:mm:ss"
    ) -> Self {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let locale = Locale(identifier: "en_US_POSIX")
        df.locale = locale
        let date = df.string(from: date)
        self.dateString = date
        return self
    }
    
    public func fromStringUTCToDate(
        dateString:String
    ) -> Self {
        let format = detectFormatString(dateString)
        let df = DateFormatter()
        df.dateFormat = format
        let locale = Locale(identifier: "en_US_POSIX")
        df.locale = locale
        df.timeZone = TimeZone(identifier:"UTC")
        let dateFromString = df.date(from: dateString)
        self.date = dateFromString
        return self
    }
    
    public func detectFormatString(_ dateString:String) -> String {
        let regex1 = "^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}$"
        let regex2 = "^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}$"
        
        if NSPredicate(format: "SELF MATCHES %@", regex2).evaluate(with: dateString.trimmingCharacters(in:.whitespacesAndNewlines)) {
            return "yyyy-MM-ddTHH:mm:ss.SSS"
        }
        return "yyyy-MM-ddTHH:mm:ss"
    }
}
