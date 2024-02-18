//
//  PopoverNavigationController.swift
//  
//
//  Created by Dai Pham on 18/02/2024.
//

import UIKit

class PopoverNavigationController: UINavigationController {

    init(root: UIViewController, sourceView:Any?) {
        super.init(nibName: "PopoverNavigationController", bundle: .module)
        self.modalPresentationStyle = .popover
        self.viewControllers = [root]
        if let pop = self.popoverPresentationController {
//            pop.popoverBackgroundViewClass = PopoverBackgroundView.self
            pop.delegate = self
            if let sourceView = sourceView as? UIView {
                pop.sourceView = sourceView
//                scrollView = sourceView.getScrollView()
//                scrollToFitSpace(sourceView: sourceView)
            } else if let sourceView = sourceView as? UIBarButtonItem {
                if #available(iOS 16, *) {
                    pop.sourceItem = sourceView
                } else {
                    pop.barButtonItem = sourceView
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension PopoverNavigationController: UIPopoverPresentationControllerDelegate {
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        true
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return .none
        }
}
