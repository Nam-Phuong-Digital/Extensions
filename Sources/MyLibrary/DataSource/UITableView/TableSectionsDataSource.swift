//
//  CollectionDataSource.swift
//  LearnRXSwift
//
//  Created by Dai Pham on 17/4/24.
//

import Foundation
import UIKit

/// An Object control a collection view datasource with T is Item and Cell is cell will be showed
/// ```swift
///        var dataSectionsSource: TableSectionsDataSource<ItemModel, TableViewCell, TableFooterView, TableFooterView>!
///
///        dataSectionsSource = TableSectionsDataSource(
///            for: self.tableView,
///            // config content for registered cell
///            configCell: {
///                item, indexPath, cell in
///                cell.show(item)
///            },
///            // config content for header and footer
///            configSupplementary: {
///                sectionList, indexPath, sup in
///                switch sup {
///                case .header(let header):
///                    header?.show(sectionList.title + "_header")
///                case .footer(let footer):
///                    footer?.show(sectionList.title + "_footer")
///                }
///            },
///            // handling item selected
///            itemSelected: {[weak self] item in
///                if let section = self?.dataSectionsSource.sections[0] {
///                    self?.dataSectionsSource.removeSections([section])
///                }
///            }
///        )
/// ```
public final class TableSectionsDataSource<
    T: Hashable,
    CELL: UITableViewCell,
    HEADER: UITableViewHeaderFooterView,
    FOOTER: UITableViewHeaderFooterView
>:  TableDataSource<T, CELL> {
    
    public enum SupplementaryType {
        case header(HEADER?)
        case footer(FOOTER?)
    }
    
    private var configSupplementary:((_ section:SectionDataSourceModel<T>,_ section: Int,_ sup: SupplementaryType) ->Void)
    
    /// declare a datasource with have header, footer to table view
    /// - Parameters:
    ///   - tableView: ``UITableView`` to handle.
    ///   - NoDataCell: ``UITableViewCell`` will be showed when have `no data`. set `nil` to `ignore`.
    ///   - configCell: config  content for `CELL.self`
    ///   - configSupplementary: config content for supplementary kind
    ///   - itemSelected: closure call back selected ``T`` object
    ///   - configuration: Set up some advanced features for the tableView data source.
    public init(
        for tableView: UITableView,
        configCell:@escaping ((_ item:T,_ indexPath: IndexPath, _ cell: CELL) ->Void),
        configSupplementary:@escaping ((_ section:SectionDataSourceModel<T>,_ section: Int,_ sup: SupplementaryType) ->Void),
        itemSelected:((T) -> Void)? = nil,
        configuration: TableDataSource<T, CELL>.Configuration = .default
    ) {
        self.configSupplementary = configSupplementary
        super.init(
            for: tableView,
            configCell: configCell,
            itemSelected: itemSelected,
            configuration: configuration
        )
        let shouldRegisterHeader = !HEADER.isEqual(UITableViewHeaderFooterView.self)
        let shouldRegisterFooter = !FOOTER.isEqual(UITableViewHeaderFooterView.self)
        // If it's a UITableViewHeaderFooterView, don't register it, intended for cases where only the footer or header is desired.
        if shouldRegisterHeader {
            self.tableView.register(HEADER.self)
        }
        if shouldRegisterFooter {
            self.tableView.register(FOOTER.self)
        }
        
        if shouldRegisterFooter || shouldRegisterHeader {
            self.tableView.estimatedSectionHeaderHeight = 30
        }
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < self.sections.count else {return nil}
        if let sup = tableView.dequeue(HEADER.self) {
            configSupplementary(self.sections[section], section, .header(sup))
            return sup
        } else {
            return nil
        }
    }
    
    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section < self.sections.count else {return nil}
        if let sup = tableView.dequeue(FOOTER.self) {
            configSupplementary(self.sections[section], section, .footer(sup))
            return sup
        } else {
            return nil
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !HEADER.isEqual(UITableViewHeaderFooterView.self) {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if !FOOTER.isEqual(UITableViewHeaderFooterView.self) {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        scrollViewDelegating?(.willDisplayHeader(section: section))
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        scrollViewDelegating?(.willDisplayFooter(section: section))
    }
}
