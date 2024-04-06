//
//  TipViewController.swift
//  LearnRXSwift
//
//  Created by Dai Pham on 1/4/24.
//

import UIKit

extension UIViewController {
    func showToast(
        message: String,
        icon: UIImage? = UIImage(named: "checkmark.seal.fill"),
        config: ToastMessageViewConfig = .default
    ) {
        let vc = ToastMessageView(
            message: message,
            icon: icon,
            holdController: self,
            config: config
        )
        self.present(vc, animated: true)
    }
}

struct ToastMessageViewConfig {
    let preferredMaxWidth: CGFloat
    let dismissInterval: TimeInterval
    
    static var `default`: ToastMessageViewConfig {
        // current width follow to Figma
        .init(preferredMaxWidth: 222, dismissInterval: 2)
    }
}

fileprivate class ToastMessageView: UIViewController {
    
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
        config: ToastMessageViewConfig
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
                if let parent = vc.presentingViewController {
                    pop.passthroughViews = [parent.view] // view can interactive
                    pop.sourceView = parent.view
                    pop.sourceRect = parent.view.frame
                } else {
                    pop.passthroughViews = [vc.view] // view can interactive
                    pop.sourceView = vc.view
                    pop.sourceRect = vc.view.frame
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
        self.dismiss(animated: true)
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
        let additionHeight: CGFloat =
        if let holdVC = holdController, let nv = holdVC.navigationController {
            nv.navigationBar.frame.height
        } else {
            0
        }
        if let containerView = self.popoverPresentationController?.containerView {
            let y = containerView.frame.height/2 + self.preferredContentSize.height/2 - additionHeight
            let x = containerView.frame.width/2 - self.preferredContentSize.width/2
            self.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
        }
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
