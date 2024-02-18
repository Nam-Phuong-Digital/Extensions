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
        if #available(iOS 13, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Resource.Color.onPrimary ?? .white]
    //        if let data = UserDefaults.backgroundImageData, let image = UIImage(data: data) {
            if #available(iOS 14, *) {
                if #available(iOS 15, *) {
                    navBarAppearance.backgroundColor = Resource.Color.primary
                } else {
                    navBarAppearance.configureWithTransparentBackground()
                    navBarAppearance.backgroundColor = Resource.Color.primary
                }
            } else {
                navBarAppearance.backgroundColor = Resource.Color.primary
            }
            UINavigationBar.appearance().standardAppearance = navBarAppearance
        } else {
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Resource.Color.onPrimary ?? .white]
            self.navigationBar.backgroundColor = Resource.Color.primary
            navigationBar.setBackgroundImage(Resource.Color.primary?.imageRepresentation, for: .default)
            navigationBar.shadowImage = UIImage()
            self.navigationBar.isTranslucent = false
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
