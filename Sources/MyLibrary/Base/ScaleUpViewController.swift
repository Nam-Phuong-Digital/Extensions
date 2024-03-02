//
//  ScaleUpController.swift
//  FindGo
//
//  Created by Dai Pham on 07/03/2023.
//

import UIKit
import SwiftUI
import Combine

@available (iOS 13,*)
public class ScaleUpViewController<Content>: UIViewController where Content: View {

    typealias Content = View
    
    public let selfResize:Bool
    
    public var onDismiss:(()->Void)?
    public var rootView:Content?
    let store = Store()
    
    lazy var cancellables = Set<AnyCancellable>()
    public var customTransitionDelegate:UIViewControllerTransitioningDelegate?

    lazy public var isPresented:Binding<Bool> = Binding {[weak self] in guard let `self` = self else { return false}
        return self.store.isPresented
    } set: {[weak self] in guard let `self` = self else { return}
        if !$0 {
            self.onDismiss?()
        }
        self.store.isPresented = $0
    }

    
    @MainActor
    class Store:BaseObservableObject {
        @Published var isPresented:Bool = true
    }
    
    private var shouldTapDimToClose = false
    
    public init(
        selfResize:Bool = false,
        shouldTapDimToClose:Bool = false,
        onDismiss:(()->Void)? = nil
    ) {
        self.selfResize = selfResize
        self.shouldTapDimToClose = shouldTapDimToClose
        self.onDismiss = onDismiss
        super.init(nibName: String(describing: "ScaleUpViewController"), bundle: .module)
        self.modalPresentationStyle = .custom
        customTransitionDelegate = ScaleUpAnimateTransitionDelegate(shouldTapDimToClose: shouldTapDimToClose)
        transitioningDelegate = customTransitionDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        
        if let rootView {
            let host = UIHostingController(rootView: rootView)
            addChild(host)
            host.view.backgroundColor = .clear
            view.addSubview(host.view)
            host.view.boundInside(view)
            host.didMove(toParent: self)
        }
        
        store.$isPresented
            .filter({!$0})
            .sink {[weak self] new in guard let `self` = self else { return }
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateSize()
    }
    
    func updateSize() {
        children.forEach({$0.view.invalidateIntrinsicContentSize()})
        if self.selfResize {
            preferredContentSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        } else {
            let width = self.presentationController?.containerView?.frame.width ?? 320
            let height = self.view.systemLayoutSizeFitting(CGSize(width: width - 20, height: .infinity)).height
            preferredContentSize = CGSize(width: width - 20, height: height)
        }
    }
    
    deinit {
        if #available(iOS 14, *) {
            AppLogger.shared.loggerApp.log("\("\(type(of: self)) \(#function)")")
        }
    }
}
