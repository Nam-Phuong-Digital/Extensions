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
    
    private var _storedItems: [T]
    
    public var id: String
    public var title:String
    public var items: [T] {
        _isExpand ? _storedItems : []
    }
    public var object: Any?
    public init(id: String, title: String, items: [T], isExpand: Bool = true, object: Any? = nil) {
        self.id = id
        self.title = title
        self.object = object
        _storedItems = items
        _isExpand = isExpand
    }
    
    public func updateItems(_ items: [T]) {
        _storedItems = items
    }
    
    public func removeItem(_ index: Int) {
        _storedItems.remove(at: index)
    }
    
    public func removeItem(_ item: T) {
        _storedItems.removeAll(where: { $0 == item })
    }
    
    public func appendItems(_ items: [T]) {
        _storedItems.append(contentsOf: items)
    }
    
    public func getItems() -> [T] {
        _storedItems
    }
}
