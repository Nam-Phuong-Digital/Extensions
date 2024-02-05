//
//  File.swift
//  
//
//  Created by Dai Pham on 05/02/2024.
//

import Foundation
import UIKit

public protocol ControllerCustomTransitionProtocol {
    func setTransitionDelegate(_ t:UIViewControllerTransitioningDelegate?)
    func getTransitionDelegate() -> UIViewControllerTransitioningDelegate?
}
