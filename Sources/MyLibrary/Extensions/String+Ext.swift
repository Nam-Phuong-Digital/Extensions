//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation
import UIKit

public extension String {
    
    var na: String {
        if self.isEmpty {
            return "N/A"
        }
        return self
    }
    
    /**
     Convert argb string to rgba string.
     */
    func argb2rgba() -> String? {
        guard self.hasPrefix("#") else {
            return nil
        }
        
        let hexString: String = String(self[index(startIndex,offsetBy: 1)...])
        switch (hexString.count) {
        case 4:
            return "#"
                + String(hexString[index(startIndex,offsetBy: 1)...])
            + String(hexString[..<index(startIndex,offsetBy: 1)])
        case 8:
            return "#"
            + String(hexString[index(startIndex,offsetBy: 2)...])
        + String(hexString[..<index(startIndex,offsetBy: 2)])
        default:
            return nil
        }
    }
    
    func highlightKeyword(keyword:String?, color:UIColor = .black) -> NSAttributedString {
        let name = self
        let attri = NSMutableAttributedString(string: name)
        if let keyword {
            if #available(iOS 16, *) {
                let ranges = name.lowercased().ranges(of: keyword.lowercased())
                ranges.forEach { range in
                    let convertedRange = NSRange(range, in: name)
                    attri.addAttributes([
                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                        NSAttributedString.Key.foregroundColor:color
                    ], range: convertedRange)
                }
                
            } else {
                if let range = name.lowercased().range(of: keyword.lowercased()) {
                    let convertedRange = NSRange(range, in: name)
                    attri.addAttributes([
                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                        NSAttributedString.Key.foregroundColor:color
                    ], range: convertedRange)
                }
            }
        }
        return attri
    }
    
    var unicode: String {
        if let charCode = Int(String(self.split(separator: "U").map({$0})[1]), radix: 16),
           let unicode = UnicodeScalar(charCode) {
            let str = String(unicode)
            return str
        }
        return self
    }
    
    func flag() -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        if s.isEmpty {
            return "●"
        }
        return String(s)
    }
    
    static var generateIdentifier: String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let first = String((0..<48).map{ _ in letters.randomElement()! })
        let seconds = String((0..<48).map{ _ in letters.randomElement()! })
        return "\(first)_\(seconds)"
    }
    
    static let keyEnableFaceID = "keyEnableFaceID"
    
    func toAttributed(font: UIFont?, foregroundColor:UIColor?) -> NSAttributedString {
        var attributes:[NSAttributedString.Key:Any] = [:]
        if let v = foregroundColor {
            attributes[NSAttributedString.Key.foregroundColor] = v
        }
        if let v = font {
            attributes[NSAttributedString.Key.font] = v
        }
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self.trimmingCharacters(in:.whitespacesAndNewlines))
    }
    
    static func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func UTCToLocal(format:String = "yyyy-MM-dd'T'HH:mm:ss.SSS") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: self)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = format
        dateFormatter1.timeZone = TimeZone.current
        
        if let d = dt {
            let t = dateFormatter1.string(from: d)
            return t
        }
        
        return ""
        
    }
    
    static var formatddMMMMyyyy:String {
        Locale.isEn ? "MMMM dd, yyyy" : "dd MMMM, yyyy"
    }
    
    static var formatddMMMM:String {
        Locale.isEn ? "MMM dd" : "dd MMMM"
    }
    
    static var formatShortddMM:String {
        Locale.isEn ? "MMM dd" : "dd/MM"
    }
    
    static var formatShortddMMyyyy:String {
        Locale.isEn ? "MMM dd, yyyy" : "dd/MM/yyyy"
    }
    
    static var formatddMMyyyyhhmma:String {
        Locale.isEn ? "MMM dd, yyyy, HH:mm" : "dd MMMM yyyy • HH:mm"
    }
    
    static var formatddMMyyyyHHmm:String {
        Locale.isEn ? "MMM dd, yyyy, HH:mm" : "dd/MM/yyyy HH:mm"
    }
    
    static var formatddMMHHmm:String {
        Locale.isEn ? "MMM dd, hh:mm a" : "HH:mm dd/MM"
    }
    
    static var formatddMMyyyy: String {
        Locale.isEn ?  "MMM dd, yyyy" :  "dd/MM/yyyy"
    }
    
    static var formatddMMyyyyVN: String {
        "dd/MM/yyyy"
    }
    
    static var formatddMMVN: String {
        "dd MMMM"
    }
    
    static var formatPickerDate: String {
        Locale.isEn ?  "MMM dd, yyyy" :  "dd MMM yyyy"
    }
    
    static func formatPersonalFlights(haveYear:Bool) -> String {
        return haveYear ? "MM.yyyy" : "MMMM"
    }
    
    func toShortDateTime(isCheckYear:Bool = true) -> String {
        let start:Date? =
        if let start = self.stringToDateYYYYMMddSSS {
            start
        } else if let start = self.stringToDateYYYYMMdd {
            start
        } else {
            nil
        }
        guard let start = start else {return self}
        let calendar = Calendar.app
        let notSameYear = isCheckYear && !calendar.isDate(start, equalTo: Date(), toGranularity: .year)
        let formatStart:String = !notSameYear ? .formatddMMHHmm : .formatddMMyyyyHHmm
        let formatter = DateFormatter()
        formatter.locale = Locale.app
        formatter.dateFormat = formatStart
        return formatter.string(from: start)
    }
    
    func toFlightDate() -> String {
        if let start = self.stringToDateYYYYMMdd {
            let formatStart:String = "dd/MM/yyyy"
            let formatter = DateFormatter()
            formatter.locale = Locale.app
            formatter.dateFormat = formatStart
            return formatter.string(from: start)
        }
        return self
    }
    
    func toCNVTaskDate() -> String {
        var start = self.stringToDateYYYYMMdd
        if start == nil {
            start = self.stringToDateYYYYMMddSSS
        }
        if let start {
            let formatStart:String = "dd/MM/yyyy"
            let formatter = DateFormatter()
            formatter.locale = Locale.app
            formatter.dateFormat = formatStart
            return formatter.string(from: start)
        }
        return self
    }
    
    var stringToDateYYYYMMdd: Date? {
        get {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let locale = Locale(identifier: "en_US_POSIX")
            df.locale = locale
            let dateFromString = df.date(from: self)
            return dateFromString
            
        }
    }
    
    var stringToDateYYYYMMddSSS: Date? {
        get {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let locale = Locale(identifier: "en_US_POSIX")
            df.locale = locale
            let dateFromString = df.date(from: self)
            return dateFromString
            
        }
    }
    
    var stringToDate: Date? {
        get {
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            let dateFromString = df.date(from: self)
            return dateFromString
            
        }
    }
    
    func localizedString() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func toInt(defaultValue: Int = 0) -> Int {
        Int(self) ?? defaultValue
    }
}
