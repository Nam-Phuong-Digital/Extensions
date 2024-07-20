//
//  DropdownSectionView.swift
//  
//
//  Created by Dai Pham on 17/7/24.
//

import UIKit

class DropdownSectionView: UITableViewHeaderFooterView {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var selectButton: ContainerButton!
    @IBOutlet weak var action2Button: ContainerButton!
    
    var onTap:((Bool) -> Void)?
    var onSelect:((DropDownTreeItem) -> Void)?
    private var item: DropDownTreeItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actionButton.addTarget(self, action: #selector(self.didTap(_:)), for: .touchUpInside)
        action2Button.addTarget(self, action: #selector(self.didTap(_:)), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(self.didSelect(_:)), for: .touchUpInside)
        actionButton.setCheckBoxStyle(image: Resource.Icon.chevronRight, selectedImage: Resource.Icon.chevronDown)
    }

    @objc func didTap(_ sender: UIButton) {
        actionButton.isSelected = !actionButton.isSelected
        self.item?.isExpand = actionButton.isSelected
        self.onTap?(actionButton.isSelected)
    }
    @objc func didSelect(_ sender: Any) {
        guard let item else {
            self.onTap?(true)
            return
        }
        self.onSelect?(item)
    }
    
    func show(
        item: DropDownTreeItem,
        onTap:((Bool) -> Void)?,
        onSelect:((DropDownTreeItem) -> Void)?
    ) {
        self.item = item
        self.onTap = onTap
        self.onSelect = onSelect
        contentLabel.text = item.content
        actionButton.isSelected = item.isExpand
    }
}
