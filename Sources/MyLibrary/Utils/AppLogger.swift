//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation

import OSLog

@available (iOS 14,*)
public class AppLogger {
    static let shared:AppLogger = {AppLogger()}()
    let loggerAPI = Logger(subsystem: "\(Bundle.main.applicationName ?? "")", category: "API")
    let loggerApp = Logger(subsystem: "\(Bundle.main.applicationName ?? "")", category: "App")
}

public extension Dictionary {
    func toString() -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch{}
        return nil
    }
}
