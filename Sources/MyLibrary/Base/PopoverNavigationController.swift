//
//  PopoverNavigationController.swift
//  
//
//  Created by Dai Pham on 18/02/2024.
//

import UIKit

class PopoverNavigationController: UINavigationController {

    init(root: UIViewController) {
        super.init(nibName: "PopoverNavigationController", bundle: .module)
        self.modalPresentationStyle = .popover
        self.viewControllers = [root]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
