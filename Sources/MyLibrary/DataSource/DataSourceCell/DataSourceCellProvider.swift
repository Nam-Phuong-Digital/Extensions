//
//  File.swift
//  
//
//  Created by Dai Pham on 22/4/24.
//

import Foundation
import UIKit

/// Provider a func setup content for cell
public protocol DataSourceCellProvider where Self: UITableViewCell, ContentType: Hashable {
    associatedtype ContentType
    
    func show(item: ContentType, indexPath: IndexPath) -> Self
}

/// Provider a func setup content for Header, Footer view
public protocol DataSourceHeaderFooterProvider where Self: UITableViewHeaderFooterView, ContentType: Hashable {
    associatedtype ContentType
    
    func show(item: ContentType, section: Int) -> Self
}
