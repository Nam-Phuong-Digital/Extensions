//
//  PopoverContainerController.swift
//  Cabinbook
//
//  Created by Dai Pham on 18/02/2024.
//  Copyright © 2024 Nam Phuong Digital. All rights reserved.
//

import UIKit

public final class PopoverContainerController: UIViewController {

    private var sourceView:Any?
    private var scrollView:UIScrollView?
    private var contentController:UIViewController?
    public init(
        sourceView:Any?,
        contentController:UIViewController?
    ) {
        self.sourceView = sourceView
        self.contentController = contentController
        super.init(nibName: "PopoverContainerController", bundle: .module)
        modalPresentationStyle = .popover
        if let pop = self.popoverPresentationController {
            pop.delegate = self
            if let sourceView = sourceView as? UIView {
                scrollView = sourceView.getScrollView()
                scrollToFitSpace(sourceView: sourceView)
            } else if let sourceView = sourceView as? UIBarButtonItem {
                if #available(iOS 16, *) {
                    pop.sourceItem = sourceView
                } else {
                    pop.barButtonItem = sourceView
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let contentController = self.contentController {
            addChild(contentController)
            view.addSubview(contentController.view)
            contentController.didMove(toParent: self)
            contentController.view.boundInside(view)
        }
        // Do any additional setup after loading the view.
    }
    
    public override var preferredContentSize: CGSize {
        didSet {
            if let sourceView = sourceView as? UIView {
                scrollToFitSpace(sourceView: sourceView)
            }
        }
    }
    
    private func scrollToFitSpace(sourceView:UIView?) {
        guard let sourceView, let scrollView else {
            return
        }
        
        if let rect = sourceView.superview?.convert(sourceView.frame, to: nil) {
            let height:CGFloat = self.preferredContentSize.height // height
            let heightScreen:CGFloat = sourceView.window?.frame.height ?? scrollView.frame.height
            let centerSourceViewY:CGFloat = (rect.origin.y + rect.size.height/2) - (heightScreen - scrollView.frame.height)
            var y:CGFloat?
            // check out of safe area
            if scrollView.frame.height - centerSourceViewY < height && centerSourceViewY < scrollView.frame.height/2 { // check with bottom and should be at half top side
                if centerSourceViewY < height {
                    y = height - (scrollView.frame.height - centerSourceViewY)
                }
            } else if centerSourceViewY < height && centerSourceViewY > scrollView.frame.height/2 {// check with top
                if height - centerSourceViewY < height {
                    y = -(height - centerSourceViewY)
                }
            }
            if let y {
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y + y), animated: true)
            }
        }
    }
}

extension PopoverContainerController: UIPopoverPresentationControllerDelegate {

    public func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let sourceView = sourceView as? UIView {
            popoverPresentationController.sourceView = sourceView
        } else if let sourceView = sourceView as? UIBarButtonItem {
            if #available(iOS 16, *) {
                popoverPresentationController.sourceItem = sourceView
            } else {
                popoverPresentationController.barButtonItem = sourceView
            }
        }
    }
    
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        true
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return .none
        }
}
