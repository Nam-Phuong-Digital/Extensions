//
//  File.swift
//  
//
//  Created by Dai Pham on 05/02/2024.
//

import Foundation
import UIKit

public protocol DataSourceProtocol {
    var _datasource:Any? {get set}
    
    @MainActor
    func reloadDataSource(section:Int, animated:Bool)
    
    @MainActor
    func reloadAllSections(for tableView:UITableView,animated:Bool)
    
    @MainActor
    func reloadDataSource(rows:[AnyHashable], animated:Bool)
    
    @MainActor
    func deleteTableRows(rows:[AnyHashable], animated:Bool)
    
    @available(iOS 13.0, *)
    func setupDataSource(_ dataSource:@escaping ()-> UITableViewDiffableDataSource<Int,AnyHashable>)
    
    func getItemIdentifier<T:Codable>(_ indexPath:IndexPath) -> T?
    
    func getItemIdentifier<T:Hashable>(_ indexPath:IndexPath) -> T?
    
    func getItemIdentifier(_ indexPath:IndexPath) -> AnyHashable?
    
    @MainActor
    func updateDataSource(
        items:[AnyHashable],
        section:Int,
        animation:UITableView.RowAnimation?,
        showNodata:Bool,
        animated:Bool
    )
    
    @available(iOS 13.0, *)
    @MainActor
    func updateDataSoure(
        animated:Bool,
        with snapShot:@escaping ()->NSDiffableDataSourceSnapshot<Int,AnyHashable>
    )
}
