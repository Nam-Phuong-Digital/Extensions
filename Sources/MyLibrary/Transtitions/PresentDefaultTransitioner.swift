//
//  SlideUpTransitioner.swift
//  GlobeDr
//
//  Created by dai on 1/20/20.
//  Copyright © 2020 GlobeDr. All rights reserved.
//

import UIKit

// MARK: -  SlideUpAnimateTransitiong
public class PresentDefaultTransiting: NSObject,  UIViewControllerAnimatedTransitioning {
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
        
        
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC?.view
        
        let appearedFrame = transitionContext.finalFrame(for: animatingVC!)
        // Our dismissed frame is the same as our appeared frame, but off the right edge of the container
        var dismissedFrame = appearedFrame
        dismissedFrame.origin.y += dismissedFrame.size.height
        
        let initialFrame = isPresentation ? dismissedFrame : appearedFrame
        let finalFrame = isPresentation ? appearedFrame : dismissedFrame
        
        animatingView?.frame = initialFrame
        
        if isPresentation {
            containerView.addSubview(toView!)
        } else {
//            containerView.insertSubview(toView!, at: 0)
        }
        
        // Animate using the duration from -transitionDuration:
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            animatingView?.frame = finalFrame
        } completion: { finished in
            if !transitionContext.transitionWasCancelled {
                if !isPresentation {
                    fromView?.removeFromSuperview()
                }
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

// MARK: -  PresentFromHomeAnimateTransitionDelegate
public class PresentDefaultAnimateTransitionDelegate:NSObject, UIViewControllerTransitioningDelegate {
    
    weak var interactionController: UIPercentDrivenInteractiveTransition?
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentDefaultPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(isPresentation:Bool) -> PresentDefaultTransiting {
        let animationController = PresentDefaultTransiting()
        animationController.isPresentation = isPresentation
        return animationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController(isPresentation: false)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController(isPresentation: true)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

// MARK: -  PresentFromHomePresentationController
class PresentDefaultPresentationController: UIPresentationController {
    
    var dimmingView:UIView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        prepareDimmingView()
    }
    
    func prepareDimmingView() {
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)// UIColor(white: 0.0, alpha: 0.4)
        dimmingView.alpha = 1
    }
    
    override var adaptivePresentationStyle: UIModalPresentationStyle {
        // When we adapt to a compact width environment, we want to be over full screen
        return .overFullScreen
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = self.containerView?.bounds ?? .zero
        dimmingView.alpha = 1
        
        // Insert the dimming view below everything else
        self.containerView?.insertSubview(self.dimmingView, at: 0)
        
        if presentedViewController.transitionCoordinator != nil {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
                self.presentedViewController.view.alpha = 1
                //                self.dimmingView.alpha = 1
            }, completion: nil)
        } else {
            self.presentedViewController.view.alpha = 1
            self.dimmingView.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if presentedViewController.transitionCoordinator != nil {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
                //                self.presentedViewController.view.alpha = 0
                self.dimmingView.alpha = 0
            }, completion: nil)
        } else {
            //            self.presentedViewController.view.alpha = 0
            self.dimmingView.alpha = 0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        var presentedViewFrame:CGRect = .zero
        let containerBounds = self.containerView?.bounds ?? .zero
        presentedViewFrame.size = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerBounds.size)
        
//        presentedViewFrame.origin.y = containerBounds.size.height - presentedViewFrame.size.height
        
        return presentedViewFrame
    }
    
    /*
     override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
     // We always want a size that's a third of our parent view width, and just as tall as our parent
     return CGSize(width: CGFloat(floorf(Float(parentSize.width))), height: parentSize.height)
     }
     */
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
}
