//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import Foundation

public extension Date {
    
    var toLocalddMMyyyy: String? {
        get {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US")
            df.dateFormat = "dd/MM/yyyy"
            df.timeZone = TimeZone.current
            let stringFromDate = df.string(from: self)
            return stringFromDate
            
        }
    }
    
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
