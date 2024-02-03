//
//  SlideUpTransitioner.swift
//  GlobeDr
//
//  Created by dai on 1/20/20.
//  Copyright © 2020 VNA. All rights reserved.
//

import UIKit

// MARK: -  SlideUpAnimateTransitiong
public class ScaleUpAnimateTransiting: NSObject,  UIViewControllerAnimatedTransitioning {
    
    var isPresentation = false
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = fromVC?.view
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = toVC?.view
        
        let containerView = transitionContext.containerView
        
        let isPresentation = self.isPresentation
        
        if isPresentation {
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC?.view
                
        animatingView?.frame = transitionContext.finalFrame(for: animatingVC!)
        
        let transformDimiss = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        let transFormInitial = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        let transformIdentify = CGAffineTransform.identity
        
        animatingView?.transform = isPresentation ? transFormInitial : transformIdentify
        let finalTransform = isPresentation ? transformIdentify : transformDimiss
        
        // Animate using the duration from -transitionDuration:
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [.beginFromCurrentState,.allowUserInteraction], animations: {
            animatingView?.transform = finalTransform
        }) { (finished) in
            if !self.isPresentation {
                           fromView?.removeFromSuperview()
                       }
                       
                       transitionContext.completeTransition(true)
        }
    }
}

// MARK: -  ScaleUpAnimateTransitionDelegate
public class ScaleUpAnimateTransitionDelegate:NSObject, UIViewControllerTransitioningDelegate {
    var shouldTapDimToClose = true
    
    init(shouldTapDimToClose:Bool = false) {
        super.init()
        self.shouldTapDimToClose = shouldTapDimToClose
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ScaleUpPresentationController(presentedViewController: presented, presenting: presenting, shouldTapDimToClose: shouldTapDimToClose)
    }
    
    func animationController(isPresentation:Bool) -> ScaleUpAnimateTransiting {
        let animationController = ScaleUpAnimateTransiting()
        animationController.isPresentation = isPresentation
        return animationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController(isPresentation: false)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController(isPresentation: true)
    }
}

// MARK: -  ScaleUpPresentationController
class ScaleUpPresentationController: UIPresentationController {
    var dimmingView:UIView = UIView()
    var shouldTapDimToClose = true
    private var hegightKeyboard:CGFloat = 0.0 {
        didSet {
            self.containerView?.setNeedsLayout()
        }
    }
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, shouldTapDimToClose:Bool) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.shouldTapDimToClose = shouldTapDimToClose
        prepareDimmingView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            hegightKeyboard = keyboardSize.height
        }
    }
    @objc func keyboardWillHideNotification(_ notification: Notification) {
        hegightKeyboard = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func prepareDimmingView() {
        dimmingView.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.1215686275, blue: 0.1254901961, alpha: 0.5151147959)
        dimmingView.alpha = 0
        
        if shouldTapDimToClose {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(gesture:)))
            dimmingView.addGestureRecognizer(tap)
        }
    }
    
    @objc func dimmingViewTapped(gesture:UIGestureRecognizer) {
        if gesture.state == .recognized {
            self.presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    override var adaptivePresentationStyle: UIModalPresentationStyle {
        // When we adapt to a compact width environment, we want to be over full screen
        return .overFullScreen
    }
    
    override func presentationTransitionWillBegin() {
         // Here, we'll set ourselves up for the presentation
        dimmingView.frame = self.containerView?.bounds ?? .zero
        dimmingView.alpha = 0
        
        // Insert the dimming view below everything else
        self.containerView?.insertSubview(self.dimmingView, at: 0)
        
        if presentedViewController.transitionCoordinator != nil {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 1
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if presentedViewController.transitionCoordinator != nil {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 0
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = self.containerView?.bounds ?? .zero
        self.presentedView?.setNeedsLayout()
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        presentedView?.center = self.containerView?.center ?? .zero
        presentedView?.center.y -= hegightKeyboard/2
        
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame:CGRect = .zero
        let containerBounds = self.containerView?.bounds ?? .zero

        presentedViewFrame.size =  self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerBounds.size)
        return presentedViewFrame
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        // We always want a size that's a third of our parent view width, and just as tall as our parent
//        let width:CGFloat = container.preferredContentSize.width// isIpad ? floor(parentSize.width*0.5) : floor(parentSize.width*0.8)
        return CGSize(width:parentSize.width - 30, height: container.preferredContentSize.height) //container.preferredContentSize
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        guard let containerView = self.containerView, let presentedView = self.presentedView else {return}
        self.presentedView?.frame.size = container.preferredContentSize
        presentedView.center = containerView.center
    }
}
