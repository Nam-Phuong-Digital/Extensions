//
//  PopoverNavigationController.swift
//  
//
//  Created by Dai Pham on 18/02/2024.
//

import UIKit

public class PopoverNavigationController: UINavigationController {

    private var root: UIViewController!
    
    public init(root: UIViewController, sourceView:Any?) {
        self.root = root
        super.init(nibName: "PopoverNavigationController", bundle: .module)
        self.modalPresentationStyle = .popover
        if let pop = self.popoverPresentationController {
            pop.delegate = self
            if let sourceView = sourceView as? UIView {
                pop.sourceView = sourceView
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [root]
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
