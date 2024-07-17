//
//  DropDownTree.swift
//  Cabinbook
//
//  Created by Dai Pham on 18/02/2024.
//  Copyright © 2024 Nam Phuong Digital. All rights reserved.
//

import UIKit

public protocol DropDownTreeItem {
    var content: String { get }
    var child: [DropDownTreeItem] { get set }
    var isExpand: Bool { get set }
}

public extension UIViewController {
    func presentDropDownTree<T: Hashable & DropDownTreeItem>(
        sourceView:Any?,
        current: T?,
        items: [T],
        canInteract: Bool = false,
        result:@escaping (_ T:T?)->()
    ) {
        guard !items.isEmpty else {return}
        let vc = DropDownTree(
            current: current,
            items: items,
            sourceView: sourceView,
            holdController: self,
            canInteract: canInteract,
            result: result
        )
        self.present(vc, animated: true)
        
    }
}

fileprivate class DropDownTree<T: Hashable & DropDownTreeItem>: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var sourceView:Any?
    private let items:[T]
    private var current:T?
    private var result:(_ T:T?)->()
    init(
        current: T?,
        items: [T],
        sourceView:Any?,
        holdController: UIViewController?,
        canInteract:Bool,
        result:@escaping (_ T:T?)->()
    ) {
        self.items = items
        self.current = current
        self.result = result
        super.init(nibName: "DropDownTree", bundle: .module)
        self.modalPresentationStyle = .popover
        if let pop = self.popoverPresentationController {
            pop.canOverlapSourceViewRect = true
            pop.popoverBackgroundViewClass = DropDownTreeBackground.self
            pop.delegate = self
//            if let view = sourceView as? UIView, canInteract {
//                pop.passthroughViews = [view] // view can interactive
//            }
            if let vc = holdController {
                pop.sourceView = vc.view
                if let sourceView = sourceView as? UIView,
                   let rect = sourceView.superview?.convert(sourceView.frame, to: vc.view)
                {
                    pop.sourceRect = rect
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _dataSource:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "DropdownSectionView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DropdownSectionView")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 13, *) {
            setupDataSource {
                .init(tableView: self.tableView) {[weak self] tableView, indexPath, itemIdentifier in guard let self else { return nil}
                    guard let item = itemIdentifier as? T else {
                        return nil
                    }
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                    if #available(iOS 14.0, *) {
                        var configure = UIListContentConfiguration.cell()
                        configure.text = item.content
                        configure.textProperties.numberOfLines = 3
                        cell?.contentConfiguration = configure
                    } else {
                        cell?.textLabel?.numberOfLines = 3
                        cell?.textLabel?.text = item.content
                    }
                    cell?.accessoryType = item == self.current ? .checkmark : .none
                    cell?.setBGColor(.clear)
                    return cell
                }
            }
        } else {
            tableView.dataSource = self
        }
        tableView.delegate = self
        
        let width = max(300, (popoverPresentationController?.sourceRect.width ?? 0) - 30)
        let max = UIScreen.bounceWindow.height * 0.8
        var height:CGFloat = CGFloat(items.count * 50)
        if let nv = self.navigationController {
            height += nv.navigationBar.frame.height
        }
        height = min(height,max)
        preferredContentSize = CGSize(width: width, height: height)
        reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        result(current) // involked result when dismissed
    }
    
    private func reloadData() {
        if #available(iOS 13, *) {
            updateDataSource()
        } else {
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: T? =
        if #available(iOS 13, *) {
            getItemIdentifier(indexPath)
        } else {
            if indexPath.row < items.count {
                items[indexPath.row]
            } else {
                nil
            }
        }
        guard let item else {return}
        self.current = item
        self.dismiss(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].child.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < items.count else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if #available(iOS 14.0, *) {
            var configure = UIListContentConfiguration.cell()
            configure.text = item.content
            configure.textProperties.numberOfLines = 3
            cell.contentConfiguration = configure
        } else {
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.text = item.content
        }
        cell.setBGColor(.clear)
        cell.accessoryType = item == self.current ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DropdownSectionView") as! DropdownSectionView
        view.show(item: items[section]) {[weak self] bool in
            self?.reloadData()
        } onSelect: {[weak self] item in guard let self else { return }
            self.current = item as? T
            self.dismiss(animated: true)
        }

        return view
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    @available(iOS 13.0, *)
    func getDatasource() -> UITableViewDiffableDataSource<Int,AnyHashable>? {
        return _dataSource as? UITableViewDiffableDataSource<Int,AnyHashable>
    }
    
    @available(iOS 13.0, *)
    @MainActor
    func reloadDataSource(section:Int, animated:Bool = true) {
//        dataSource?.defaultRowAnimation = .fade
        var snap = getDatasource()?.snapshot()
        if snap?.numberOfSections ?? 0 > 0 {
            snap?.reloadSections([section])
            if let snap = snap {
                getDatasource()?.apply(snap, animatingDifferences: animated)
            }
        }
    }
    
    @available (iOS 13,*)
    @MainActor
    func reloadAllSections(for tableView:UITableView,animated:Bool = true) {
        if let s = self.getDatasource()?.numberOfSections(in: tableView) {
            var sections:[Int] = []
            for i in 0..<s {
                sections.append(i)
            }
            if !sections.isEmpty {
                var snap = getDatasource()?.snapshot()
                snap?.reloadSections(sections)
                if let snap = snap {
                    getDatasource()?.apply(snap, animatingDifferences: animated)
                }
            }
        }
    }
    
    @available (iOS 13,*)
    @MainActor
    func reloadDataSource(rows:[AnyHashable], animated:Bool = true) {
        var snap = getDatasource()?.snapshot()
        snap?.reloadItems(rows)
        if let snap = snap {
            getDatasource()?.apply(snap,animatingDifferences: animated)
        }
    }
    
    @available (iOS 13,*)
    @MainActor
    func deleteTableRows(rows:[AnyHashable], animated:Bool = true) {
        var snap = getDatasource()?.snapshot()
        snap?.deleteItems(rows)
        if let snap = snap {
            getDatasource()?.apply(snap,animatingDifferences: animated)
        }
    }
    
    @available (iOS 13,*)
    func setupDataSource(_ dataSource:@escaping ()->UITableViewDiffableDataSource<Int,AnyHashable>) {
        _dataSource = dataSource()
    }
    
    @available (iOS 13,*)
    func getItemIdentifier(_ indexPath:IndexPath) -> T? {
        return getDatasource()?.itemIdentifier(for:indexPath) as? T
    }
    
    @available (iOS 13,*)
    @MainActor
    func updateDataSource(
        animation:UITableView.RowAnimation? = nil,
        showNodata:Bool = true,
        animated:Bool = true
    ) {
        guard let dataSource = getDatasource() else {return}
        if let animation = animation {
            dataSource.defaultRowAnimation = animation
        }
        var snapShot = NSDiffableDataSourceSnapshot<Int,AnyHashable>()
        let sections = items.enumerated().compactMap({ $0.offset })
        snapShot.appendSections(sections)
        items.enumerated().forEach { (offset: Int, item: DropDownTreeItem & Hashable) in
            let child: [T] = item.isExpand ? item.child as! [T] : []
            snapShot.appendItems(child, toSection:offset)
        }
        dataSource.apply(snapShot, animatingDifferences: animated)
    }

    @available (iOS 13,*)
    @MainActor
    func updateDataSoure(
        animated:Bool = true,
        with snapShot:@escaping ()->NSDiffableDataSourceSnapshot<Int,AnyHashable>
    ) {
        guard let dataSource = getDatasource() else {return}
//        dataSource.defaultRowAnimation = dataSource.snapshot().numberOfItems > 0 ? .fade : .top
        dataSource.apply(snapShot(), animatingDifferences: animated)
    }
}

fileprivate class DropDownTreeBackground: UIPopoverBackgroundView {
    
    private var offset = CGFloat(0)
    private var arrow = UIPopoverArrowDirection.any
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return .zero
    }
    
    override class func arrowHeight() -> CGFloat {
        return .zero
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return arrow
        }
        set {
            arrow = newValue
        }
    }
    override var arrowOffset: CGFloat {
        get {
            return offset
        }
        set {
            self.offset = newValue
        }
    }
    
    override class func arrowBase() -> CGFloat {
        .zero
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isHidden = true // hidden this background to remove default shadow
    }
}

fileprivate extension UIViewController {
    func getFirst() -> UIViewController? {
        if let parent = self.parent {
            return parent.getFirst()
        }
        return self
    }
}
