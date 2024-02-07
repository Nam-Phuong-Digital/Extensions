//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import UIKit
#if canImport(Combine)
import Combine
#endif

@available (iOS 13,*)
open class BaseObservableView: BaseView {
    
    lazy public var cancellables = Set<AnyCancellable>()
}


open class BaseView: UIView {
    // MARK: -  override
    open func setupTexts() {
        // override
    }
    
    open func config() {
        setupTexts()
    }
    
    // MARK: -  private
    private func loadNIb(bundle:Bundle?) {
        if let name = NSStringFromClass(type(of: self)).components(separatedBy: ".").last {
            if let bundle {
                bundle.loadNibNamed(name, owner: self)
            } else {
                Bundle.module.loadNibNamed(name, owner: self, options: nil)
            }
        }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
   
    // MARK: - init
    override public  init(frame: CGRect) {
        super.init(frame: frame)
        loadNIb(bundle: .main)
        config()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNIb(bundle: .main)
        config()
    }
    
    public init(bundle:Bundle?) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 350, height: 440)))
        loadNIb(bundle: bundle)
        config()
    }
    
    // MARK: - outlet
    @IBOutlet weak public var view: UIView!
}

