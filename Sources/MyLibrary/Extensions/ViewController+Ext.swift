//
//  File.swift
//  
//
//  Created by Dai Pham on 23/4/24.
//

import UIKit

public extension UIViewController {
    func presentSafely(nextProcessing:@escaping ()-> Void) {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) {[weak self] timer in
                timer.invalidate()
                if self?.presentedViewController != nil {
                    self?.presentSafely(nextProcessing: nextProcessing)
                    return
                }
                nextProcessing()
            }
        }
    }
}
