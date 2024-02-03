//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import Foundation

public extension Locale {
    static var app:Locale {Locale.current}
    static var isEn:Bool {!app.identifier.contains("vi")}
}
