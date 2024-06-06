//
//  CollectionDataSource.swift
//  LearnRXSwift
//
//  Created by Dai Pham on 17/4/24.
//

import Foundation
import UIKit
public extension UICollectionView {
    func dequeue<T: UICollectionViewCell>(_ cellType: T.Type, indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: cellType.self), for: indexPath) as! T
    }
    
    func dequeue<T: UICollectionReusableView>(_ headerFooterType: T.Type, indexPath: IndexPath, kind: String) -> T? {
        dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: headerFooterType.self), for: indexPath) as? T
    }
    
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(UINib(nibName: String(describing: cellType.self), bundle: nil), forCellWithReuseIdentifier: String(describing: cellType.self))
    }
    
    /// register header footer for the collection view
    /// - Parameters:
    ///   - headerFooterType: HeaderFooter Type
    ///   - kind: ``UICollectionView.elementKindSectionFooter`` ||  ``UICollectionView.elementKindSectionHeader``
    func register<T: UICollectionReusableView>(_ headerFooterType: T.Type, kind: String) {
        register(UINib(nibName: String(describing: headerFooterType.self), bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: headerFooterType.self))
    }
}

/// An Object control a collection view datasource with T is Item and Cell is cell will be showed
public class CollectionDataSource<T: Hashable, CELL: UICollectionViewCell>:NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var _dataSource: Any?
    let collectionView: UICollectionView
    var sections:[SectionDataSourceModel<T>] = []
    
    private let loadMoreIndicator: DataSourceScrollViewConfiguration.LoadMoreActivityIndicator
    private var selectingItem:SELECTED_ITEM<T>
    private var configCell:((_ item:T,_ indexPath: IndexPath, _ cell: CELL) ->Void)
    public var scrollViewDelegating:((DataSourceScrollViewConfiguration) -> Void)?
    
    public init(
        for collectionView: UICollectionView,
        configCell: @escaping ((_ item:T,_ indexPath: IndexPath, _ cell: CELL) ->Void),
        configHeaderFooter: ((_ section: Int,_ collectionView: UICollectionView, _ kind: String) -> UICollectionReusableView?)? = nil,
        itemSelected: SELECTED_ITEM<T> = nil,
        layout: UICollectionViewLayout? = nil
    ) {
        self.collectionView = collectionView
        self.configCell = configCell
        loadMoreIndicator = DataSourceScrollViewConfiguration.LoadMoreActivityIndicator(scrollView: self.collectionView)
        self.selectingItem = itemSelected
        super.init()
        if #available(iOS 13, *), !TEST_OLD_VERSION {
            self.setUpDataSource(configCell: configCell)
        } else {
            self.collectionView.dataSource = self
        }
        self.register(for: CELL.self)
        self.collectionView.delegate = self
        if let layout {
            if #available(iOS 13, *) {
                self.collectionView.collectionViewLayout = layout
            }
        }
    }
   
    public func updateItems(_ items: [T], to section: Int = 0) {
        if self.sections.isEmpty && !(self is CollectionSectionsDataSource) {
            self.sections = [SectionDataSourceModel(id: "", title: "", items: [])]
        }
        guard section < self.sections.count else {return}
        self.sections[section].items = items
        reloadData()
    }
    
    public func appendItems(items: [T], to section: Int = 0) {
        if self.sections.isEmpty && !(self is CollectionSectionsDataSource) {
            self.sections = [SectionDataSourceModel(id: "", title: "", items: [])]
        }
        guard section < self.sections.count else {return}
        self.sections[section].items.append(contentsOf: items)
        reloadData()
    }
    
    public func updateSections(items: [SectionDataSourceModel<T>]) {
        self.sections = items
        reloadData()
    }
    
    public func appendSections(items: [SectionDataSourceModel<T>]) {
        self.sections.append(contentsOf: items)
        reloadData()
    }
    
    public func removeSections(_ sections: [SectionDataSourceModel<T>]) {
        self.sections.removeAll(where: { section in sections.contains(section) })
        if #available(iOS 13, *), !TEST_OLD_VERSION {
            // reload sections
            let sections = self.sections.enumerated().compactMap({ (offset, section) in
                if sections.contains(section) {
                    return offset
                }
                return nil
            })
            if !sections.isEmpty {
                var snap = getDataSource().snapshot()
                snap.reloadSections(sections)
                getDataSource().apply(snap)
            }
        }
        reloadData()
    }
    
    public func removeItems(items: [T]) {
        for item in items {
            if #available(iOS 13, *), !TEST_OLD_VERSION {
                if let indexPath = getDataSource().indexPath(for: item) {
                    // remove item at section
                    self.sections[indexPath.section].items.remove(at: indexPath.item)
                    if self.sections[indexPath.section].items.isEmpty {
                        // remove section if items  is empty
                        self.sections.remove(at: indexPath.section)
                        // reload section purpose for delete section's empty items
                        var snap = getDataSource().snapshot()
                        snap.reloadSections([indexPath.section])
                        getDataSource().apply(snap)
                    }
                }
            } else {
                let temp = self.sections
                for (offset,section) in temp.enumerated() {
                    if section.items.contains(item) {
                        self.sections[offset].items.removeAll(where: { $0 == item})
                    }
                }
            }
        }
        reloadData()
    }
    
    func reloadData() {
        if #available(iOS 13, *), !TEST_OLD_VERSION {
            var snap = NSDiffableDataSourceSnapshot<Int, T>()
            snap.appendSections(self.sections.enumerated().map{$0.0})
            self.sections.enumerated().forEach { (offset,section) in
                snap.appendItems(section.items, toSection: offset)
            }
            self.getDataSource().apply(snap)
        } else {
            self.collectionView.reloadData()
        }
    }
    
    func finishLoadMore() {
        loadMoreIndicator.stop()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: T? =
        if #available(iOS 13, *), !TEST_OLD_VERSION {
            getDataSource().itemIdentifier(for: indexPath)
        } else {
            if indexPath.section < sections.count, indexPath.item < sections[indexPath.section].items.count {
                sections[indexPath.section].items[indexPath.item]
            } else { nil }
        }
        guard let item else {return}
        selectingItem?(item)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegating?(.didScroll(scrollView: scrollView))
        loadingMore {
            self.scrollViewDelegating?(.loadMore)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegating?(.didEndDecelerating(scrollView: scrollView))
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDelegating?(.didEndDragging(scrollView: scrollView))
    }
    
    private func loadingMore(closure: (() -> Void)?) {
        loadMoreIndicator.start (closure: closure)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section >= sections.count {return 0}
        return sections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section < sections.count, indexPath.item < sections[indexPath.section].items.count else {return UICollectionViewCell()}
        let item = sections[indexPath.section].items[indexPath.item]
        let cell = collectionView.dequeue(CELL.self, indexPath: indexPath)
        configCell(item, indexPath, cell)
        return cell
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView(frame: .zero)
    }
}

extension CollectionDataSource {
    func register(for cell: CELL.Type) {
        self.collectionView.register(cell.self)
    }
    
    func register(for cell: UICollectionReusableView.Type, kind: String) {
        self.collectionView.register(cell.self, kind: kind)
    }
}

@available (iOS 13,*)
extension CollectionDataSource {
    
    func getDataSource() -> UICollectionViewDiffableDataSource<Int,T> {
        return self._dataSource as! UICollectionViewDiffableDataSource<Int, T>
    }
    
    func setUpDataSource(configCell:@escaping ((_ item:T,_ indexPath: IndexPath, _ cell: CELL) ->Void?)) {
        self._dataSource = UICollectionViewDiffableDataSource<Int, T>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeue(CELL.self, indexPath: indexPath)
            configCell(itemIdentifier, indexPath, cell)
            return cell
        })
    }
}
