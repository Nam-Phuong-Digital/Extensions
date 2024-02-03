//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation

public extension Bundle {
    /// Application name shown under the application icon.
    var applicationName: String? {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
            object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
