//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation

public extension BinaryFloatingPoint {
    func toPrice(showCurrency:Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.currencySymbol = showCurrency ? "VND" : ""
        formatter.positiveFormat = showCurrency ? "#,##0 ¤" : "#,##0"
        formatter.negativeFormat = showCurrency ? "-#,##0 ¤" : "-#,##0"
        formatter.numberStyle = .currency
        return formatter.string(for: self) ?? "\(self)"
    }
    
    func toPrice() -> String {
        if #available(iOS 15, *) {
            return self.formatted(.currency(code: "VND").locale(Locale(identifier: "vi")))
        } else {
            return self.toPrice(showCurrency: true)
        }
    }
}

public extension BinaryInteger {
    func toPrice(showCurrency:Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.currencySymbol = showCurrency ? "VND" : ""
        formatter.positiveFormat = showCurrency ? "#,##0 ¤" : "#,##0"
        formatter.negativeFormat = showCurrency ? "-#,##0 ¤" : "-#,##0"
        formatter.numberStyle = .currency
        return formatter.string(for: self) ?? "\(self)"
    }
}
