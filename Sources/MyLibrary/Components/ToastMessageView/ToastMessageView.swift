//
//  TipViewController.swift
//  LearnRXSwift
//
//  Created by Dai Pham on 1/4/24.
//

import UIKit

public extension UIViewController {
    
    /// show toast message view
    /// - Parameters:
    ///   - message: content string to present
    ///   - icon: ``UIImage`` represent, default is `checkmark.seal.fill`
    ///   - config: ``ToastMessageViewConfig`` to change dismiss timerinterval and preferred width
    ///   - isSourceDismissImmediately: if show toast on a viewcontroller and dismiss immediately, so turn `true` . default is `false`
    ///   - canInteract: When a Toast is active, interactions with sourceView is normally disabled until the Toast is dismissed. to enabled this behaviour so turn `true` interactions with sourceView is enabled 
    func showToast(
        message: String,
        icon: UIImage? = UIImage(named: "checkmark.seal.fill"),
        config: ToastMessageViewConfig = .default,
        isSourceDismissImmediately: Bool = false,
        canInteract: Bool = false
    ) {
        if isSourceDismissImmediately, let presentingViewController {
            presentingViewController.display(
                getToastView(message: message, icon: icon, config: config, holdController: presentingViewController, canInteract: canInteract)
            )
            return
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let splitViewController {
                splitViewController.display(
                    getToastView(message: message, icon: icon, config: config, holdController: splitViewController, canInteract: canInteract)
                )
                return
            }
        }
        if let navigationController {
            navigationController.display(
                getToastView(message: message, icon: icon, config: config, holdController: navigationController, canInteract: canInteract)
            )
        } else {
            self.display(
                getToastView(message: message, icon: icon, config: config, holdController: self, canInteract: canInteract)
            )
        }
    }
    
    @objc private func display(_ vc: ToastMessageView) {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) {[weak self] timer in
                timer.invalidate()
                if self?.presentedViewController == nil {
                    self?.present(vc, animated: true)
                } else {
                    // if different message then show
                    if self?.presentedViewController?.isEqual(vc) == false {
                        self?.display(vc)
                    }
                }
            }
        }
    }
    
    private func getToastView(
        message: String,
        icon: UIImage? = UIImage(named: "checkmark.seal.fill"),
        config: ToastMessageViewConfig = .default,
        holdController: UIViewController?,
        canInteract: Bool
    ) -> ToastMessageView {
        ToastMessageView(
            message: message,
            icon: icon,
            holdController: holdController,
            config: config,
            canInteract: canInteract
        )
    }
}

public struct ToastMessageViewConfig {
    let preferredMaxWidth: CGFloat
    let dismissInterval: TimeInterval
    
    public init(preferredMaxWidth: CGFloat, dismissInterval: TimeInterval) {
        self.preferredMaxWidth = preferredMaxWidth
        self.dismissInterval = dismissInterval
    }
    
    public static var `default`: ToastMessageViewConfig {
        // current width follow to Figma
        .init(preferredMaxWidth: 222, dismissInterval: 2)
    }
}

fileprivate class ToastMessageView: UIViewController {
    
    // override this function to check Toast is same
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? ToastMessageView {
            return message == object.message
        }
        return super.isEqual(object)
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private let icon: UIImage?
    private let message: String
    private var dismissTimer: Timer?
    private var tapGestureDismiss: UITapGestureRecognizer?
    
    private weak var holdController: UIViewController?
    
    private let config: ToastMessageViewConfig
    
    /// init Tip popover view
    /// - Parameters:
    ///   - message: message string
    ///   - icon: icon display
    ///   - holdController: controller using to present this tip, purpose to set sourceRect for tip view
    fileprivate init(
        message: String,
        icon: UIImage?,
        holdController: UIViewController?,
        config: ToastMessageViewConfig,
        canInteract: Bool
    ) {
        self.message = message
        self.icon = icon
        self.holdController = holdController
        self.config = config
        
        super.init(nibName: "ToastMessageView", bundle: .module)
        self.modalPresentationStyle = .popover
        
        if let pop = self.popoverPresentationController {
            pop.canOverlapSourceViewRect = true
            pop.popoverBackgroundViewClass = TipBackground.self
            pop.delegate = self
            if let vc = holdController {
                if canInteract {
                    pop.passthroughViews = [vc.view] // view can interactive
                }
                if let vcFirst = vc.getFirst(), (vcFirst.modalPresentationStyle != .fullScreen && vcFirst.modalPresentationStyle != .overFullScreen), let parent = vc.presentingViewController  {
                    pop.sourceView = parent.view
                    pop.sourceRect = CGRect(origin: parent.view.center, size: CGSize(width: 0, height: 0))
                } else {
                    pop.sourceView = vc.view
                    pop.sourceRect = CGRect(origin: vc.view.center, size: CGSize(width: 0, height: 0))
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconImageView.image = icon
        messageLabel.font = .systemFont(ofSize: 14)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        style.lineSpacing = 5
        style.alignment = .center
        messageLabel.attributedText = NSAttributedString(string: message, attributes: [.paragraphStyle: style])
        
        tapGestureDismiss = UITapGestureRecognizer(target: self, action: #selector(self.dismissTip(_:)))
        tapGestureDismiss?.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureDismiss!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdownToDismiss()
    }
    
    private func countdownToDismiss() {
        self.dismissTimer = Timer.scheduledTimer(timeInterval: config.dismissInterval, target: self, selector: #selector(self.dismissTip(_:)), userInfo: nil, repeats: false)
    }
    
    @objc func dismissTip(_ sender: Timer) {
        self.dismiss(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissTimer?.invalidate()
        if let tapGestureDismiss {
            view.removeGestureRecognizer(tapGestureDismiss)
        }
    }
    
    private func updateSize() {
        let width: CGFloat = config.preferredMaxWidth
        let height: CGFloat = self.view.systemLayoutSizeFitting(CGSize(width: width, height: CGFLOAT_MAX)).height
        self.preferredContentSize = CGSize(width: width, height: height)
        self.popoverPresentationController?.containerView?.setNeedsLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSize()
        self.view.layer.cornerRadius = 12
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = CGSize(width: -2, height: 5)
    }
}

extension ToastMessageView: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

fileprivate class TipBackground: UIPopoverBackgroundView {
    
    private var offset = CGFloat(0)
    private var arrow = UIPopoverArrowDirection.any
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return .zero
    }
    
    override class func arrowHeight() -> CGFloat {
        return .zero
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return arrow
        }
        set {
            arrow = newValue
        }
    }
    override var arrowOffset: CGFloat {
        get {
            return offset
        }
        set {
            self.offset = newValue
        }
    }
    
    override class func arrowBase() -> CGFloat {
        .zero
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isHidden = true // hidden this background to remove default shadow
    }
}

fileprivate extension UIViewController {
    func getFirst() -> UIViewController? {
        if let parent = self.parent {
            return parent.getFirst()
        }
        return self
    }
}
