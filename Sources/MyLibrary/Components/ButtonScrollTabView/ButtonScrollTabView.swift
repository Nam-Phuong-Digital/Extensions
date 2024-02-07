//
//  ButtonScrollTabView.swift
//  GlobeDr
//
//  Created by dai on 2/18/20.
//  Copyright © 2020 GlobeDr. All rights reserved.
//

import UIKit
import MyLibrary

protocol ButtonScrollTabViewDelegate:AnyObject {
    func selectTab(identifier:String?,buttonTab:ButtonTab?)
    func shouldSelectTab(identifier:String?,buttonTab:ButtonTab?) -> Bool
}

extension ButtonScrollTabViewDelegate {
    func selectTab(identifier:String?,buttonTab:ButtonTab?) {}
    func shouldSelectTab(identifier:String?,buttonTab:ButtonTab?) -> Bool {return true}
}

class ButtonTab: NSObject {
    let title:String
    let identifider:String
    let isSelected:Bool
    
    init(title:String,
         identifier:String,
         isSelected:Bool) {
        self.title = title
        self.identifider = identifier
        self.isSelected = isSelected
        super.init()
    }
}

class ButtonScrollTabView: BaseView {
    
    var maxHeight:CGFloat = 100 + CGSize.getSizeNavigationBarIncludeStatus.height
    weak var delegate:ButtonScrollTabViewDelegate?
    var buttonTabs:[ButtonTab] = []
    var contentInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var stackButton: UIStackView!
    @IBOutlet weak var underLine: UIView!
    
    var onScrollDidChange:((UIScrollView)-> Void)?
    var onScrollDidEnd:((UIScrollView)-> Void)?
    
    func dissmiss() {
        transform = CGAffineTransform.identity.translatedBy(x: 0, y: -maxHeight)
    }
    
    func scrollToSelectIndex() {
        if selectIndex >= buttonTabs.count {return}
        self.scrollView.setContentOffset(CGPoint(x: self.stackButton.arrangedSubviews[selectIndex].frame.origin.x - self.view.frame.width/2, y: 0), animated: true)
    }
    
    func disabledNormalMenu() {
        scrollView.isScrollEnabled = false
        stackButton.arrangedSubviews.enumerated().forEach { (i,view) in
            if let button = view as? UIButton, i != selectIndex {
                CATransaction.begin()
                UIView.transition(with: button, duration: 0.3, options: [.allowUserInteraction], animations: {
                    button.isEnabled = false
                    button.alpha = 0.2
                }) { (bool) in
                }
                CATransaction.commit()
            }
        }
    }
    
    func enabledNormalMenu() {
        scrollView.isScrollEnabled = true
        stackButton.arrangedSubviews.enumerated().forEach { (i,view) in
            if let button = view as? UIButton, i != selectIndex {
                CATransaction.begin()
                UIView.transition(with: button, duration: 0.3, options: [.allowUserInteraction], animations: {
                    button.isEnabled = true
                    button.alpha = 1
                }) { (bool) in
                }
                CATransaction.commit()
            }
        }
    }
    
    var objectSelected:ButtonTab? {
        get {
            if buttonTabs.count == 0, selectIndex > buttonTabs.count - 1 {return nil}
            return buttonTabs[selectIndex]
        }
    }
    
    var selectIndex:Int = 0 {
        didSet {
            stackButton.arrangedSubviews.enumerated().forEach { (i,view) in
                if let button = view as? UIButton {
                    let selected = i == selectIndex
                    CATransaction.begin()
                    UIView.transition(with: button, duration: 0.3, options: [.allowUserInteraction], animations: {
                        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
                        button.setTitleColor(selected ? UIColor.mainColor : #colorLiteral(red: 0.6156862745, green: 0.6196078431, blue: 0.6980392157, alpha: 1), for: UIControl.State())
                    }) {[weak self] (bool) in guard let `self` = self else { return }
                        
                        if selected {
                            let f:CGRect = self.stackButton.convert(self.stackButton.arrangedSubviews[self.selectIndex].frame, to: self.scrollView)
                            self.scrollView.scrollRectToVisible(f, animated: true)
                        }
                    }
                    CATransaction.commit()
                }
            }
            reFrameUnderLine()
        }
    }
    
    func setSelectIndex(index:Int) {
        selectIndex = index
    }
    
    @objc func action(_ sender:UIButton) {
        let newIndex = stackButton.arrangedSubviews.firstIndex(where: {$0.isEqual(sender)}) ?? 0
        if selectIndex == newIndex {return}
        if self.delegate?.shouldSelectTab(identifier: buttonTabs[newIndex].identifider, buttonTab: buttonTabs[newIndex]) == true {
            selectIndex = newIndex
            self.delegate?.selectTab(identifier: buttonTabs[selectIndex].identifider, buttonTab: buttonTabs[selectIndex])
        }
    }
    
    func setButtons(titles:[ButtonTab]) {
        buttonTabs = titles
        stackButton.arrangedSubviews.forEach{$0.removeFromSuperview()}
        titles.enumerated().forEach({ i,tab in
            let button = UIButton()
            button.backgroundColor = .clear
            button.setTitle(tab.title.uppercased(), for: UIControl.State())
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.setTitleColor(tab.isSelected ? UIColor.mainColor : #colorLiteral(red: 0.6156862745, green: 0.6196078431, blue: 0.6980392157, alpha: 1), for: UIControl.State())
            button.accessibilityIdentifier = tab.identifider
            button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
            button.titleLabel?.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
            stackButton.addArrangedSubview(button)
        })
        reFrameUnderLine()
    }
    
    func reFrameUnderLine() {
        self.layoutIfNeeded()
        if selectIndex >= stackButton.arrangedSubviews.count || stackButton.arrangedSubviews.count == 0 {return}
        
        let f:CGRect = stackButton.convert(stackButton.arrangedSubviews[selectIndex].frame, to: scrollView)
        
        leading.constant = f.origin.x
        underLine.getWidthConstraint()?.constant = f.size.width
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    func setSpaceWithSafeAreaTop() {
        let size = self.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        if let height = getHeightConstraint() {
            height.constant = size.height + CGSize.getSizeNavigationBarIncludeStatus.height
        } else {
            self.heightAnchor.constraint(equalToConstant: size.height + CGSize.getSizeNavigationBarIncludeStatus.height).isActive = true
        }
    }
    
    func removeSpaceWithSafeAreaTop() {
        if let height = getHeightConstraint() {
            self.removeConstraint(height)
        }
    }
    
    func setBackground(color:UIColor){
        view.backgroundColor = color
    }
    
    // MARK: -  override
    override func awakeFromNib() {
        super.awakeFromNib()
        view.backgroundColor = .white
        underLine.backgroundColor = .mainColor
        scrollView.contentInset = contentInset
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reFrameUnderLine()
        scrollView.contentInset = contentInset
    }
    
    override func config() {
        scrollView.delegate = self
    }
}

extension ButtonScrollTabView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.onScrollDidChange?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.onScrollDidChange?(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.onScrollDidChange?(scrollView)
        }
    }
}
