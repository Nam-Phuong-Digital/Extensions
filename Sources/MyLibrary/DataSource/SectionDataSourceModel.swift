//
//  SectionDataSource.swift
//  LearnRXSwift
//
//  Created by Dai Pham on 19/4/24.
//

import Foundation

public var TEST_OLD_VERSION = false

public class SectionDataSourceModel<T: Hashable>: Hashable {
    public static func == (lhs: SectionDataSourceModel, rhs: SectionDataSourceModel) -> Bool {
        rhs.id == lhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var _isExpand: Bool = true
    
    public var id: String
    public var title:String
    public var items: [T]
    public var object: Any?
    public init(id: String, title: String, items: [T], object: Any? = nil) {
        self.id = id
        self.title = title
        self.items = items
        self.object = object
    }
}
