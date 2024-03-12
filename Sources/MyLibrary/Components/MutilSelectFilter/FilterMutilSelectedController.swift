//
//  FilterMutilSelectedController.swift
//  Cabinbook
//
//  Created by Dai Pham on 18/02/2024.
//  Copyright © 2024 Nam Phuong Digital. All rights reserved.
//

import UIKit

public extension UIViewController {
    func selectMutilFilter(
        title:String? = nil,
        sourceView:Any?,
        current: [FilterSingleSelectedObject],
        items: [FilterSingleSelectedObject],
        maxSelect:Int? = nil,
        onMaximumSelected:(()->String)? = nil,
        result:@escaping (_ T:[FilterSingleSelectedObject])->()
    ) {
        let vc = FilterMutilSelectedController(
            current: current,
            items: items,
            maxSelect: maxSelect,
            onMaximumSelected: onMaximumSelected,
            result: result
        )
        if let title {
            vc.title = title
            let nv = PopoverNavigationController(root: vc, sourceView: sourceView)
            let popVC = PopoverContainerController(
                sourceView: sourceView,
                contentController: nv
            )
            self.present(popVC, animated: true)
        } else {
            let popVC = PopoverContainerController(
                sourceView: sourceView,
                contentController: vc
            )
            self.present(popVC, animated: true)
        }
    }
}

class FilterMutilSelectedController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var maxSelect:Int?
    private let items:[FilterSingleSelectedObject]
    private var current:[FilterSingleSelectedObject]
    private var result:(_ T:[FilterSingleSelectedObject])->()
    private var onMaximumSelected:(()->String)?
    init(
        current: [FilterSingleSelectedObject],
        items: [FilterSingleSelectedObject],
        maxSelect:Int?,
        onMaximumSelected:(()->String)?,
        result:@escaping (_ T:[FilterSingleSelectedObject])->()
    ) {
        self.items = items
        self.current = current
        self.result = result
        self.maxSelect = maxSelect
        self.onMaximumSelected = onMaximumSelected
        super.init(nibName: "FilterMutilSelectedController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _dataSource:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let doneButton = UIBarButtonItem(image: Resource.Icon.checkMark, style: .done, target: self, action: #selector(self.selectorDone(_:)))
        doneButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = doneButton
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 13, *) {
            setupDataSource {
                .init(tableView: self.tableView) {[weak self] tableView, indexPath, itemIdentifier in guard let self else { return nil}
                    guard let item = itemIdentifier as? FilterSingleSelectedObject else {
                        return nil
                    }
                    
                    return config(tableView: tableView, item: item)
                }
            }
        } else {
            tableView.dataSource = self
        }
        tableView.delegate = self
        
        let max = UIScreen.bounceWindow.height * 0.8
        var height:CGFloat = CGFloat(items.count * 50)
        if let nv = self.navigationController {
            height += nv.navigationBar.frame.height
        }
        height = min(height,max)
        preferredContentSize = CGSize(width: 300, height: height)
        if let nv = self.navigationController {
            nv.preferredContentSize = preferredContentSize
            nv.parent?.preferredContentSize = preferredContentSize
        } else {
            self.parent?.preferredContentSize = preferredContentSize
        }
        
        reloadData()
    }
    
    @objc func selectorDone(_ sender: Any) {
        self.dismiss(animated: true)
        self.result(self.current)
    }
    
    private func reloadData() {
        if #available(iOS 13, *) {
            updateDataSource(items: items, section: 0)
        } else {
            tableView.reloadData()
        }
    }
    
    private func config(tableView:UITableView, item:FilterSingleSelectedObject) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if #available(iOS 14.0, *) {
            var configure = UIListContentConfiguration.cell()
            configure.text = item.title
            configure.textProperties.numberOfLines = 3
            cell?.contentConfiguration = configure
        } else {
            cell?.textLabel?.numberOfLines = 3
            cell?.textLabel?.text = item.title
        }
        cell?.accessoryType = self.current.contains(item) ? .checkmark : .none
        cell?.setBGColor(.clear)
        return cell ?? UITableViewCell()
    }
}

extension FilterMutilSelectedController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: FilterSingleSelectedObject? =
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
        if self.current.contains(item) {
            self.current.removeAll(where: {$0.id == item.id})
        } else {
            if let maxSelect, self.current.count == maxSelect, let message = self.onMaximumSelected?() {
                let vc = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                vc.addAction(.init(title: "OK", style: .cancel))
                self.present(vc, animated: true)
                return
            }
            self.current.append(item)
        }
        if #available(iOS 13, *) {
            reloadDataSource(rows: [item])
        } else {
            tableView.performBatchUpdates {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < items.count else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        return config(tableView: tableView, item: item)
    }
}

@available (iOS 13,*)
extension FilterMutilSelectedController {
    
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
    func getItemIdentifier<T:Codable>(_ indexPath:IndexPath) -> T? {
        return getDatasource()?.itemIdentifier(for:indexPath) as? T
    }
    
    @available (iOS 13,*)
    func getItemIdentifier<T:Hashable>(_ indexPath:IndexPath) -> T? {
        return getDatasource()?.itemIdentifier(for:indexPath) as? T
    }
    
    @available (iOS 13,*)
    func getItemIdentifier(_ indexPath:IndexPath) -> AnyHashable? {
        return getDatasource()?.itemIdentifier(for: indexPath)
    }
    
    @available (iOS 13,*)
    @MainActor
    func updateDataSource(
        items:[AnyHashable],
        section:Int,
        animation:UITableView.RowAnimation? = nil,
        showNodata:Bool = true,
        animated:Bool = true
    ) {
        guard let dataSource = getDatasource() else {return}
        if let animation = animation {
            dataSource.defaultRowAnimation = animation
        }
        var snapShot = NSDiffableDataSourceSnapshot<Int,AnyHashable>()
        snapShot.appendSections([section])
        if showNodata, items.isEmpty {
            snapShot.appendItems([""])
        } else {
            snapShot.appendItems(items)
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
