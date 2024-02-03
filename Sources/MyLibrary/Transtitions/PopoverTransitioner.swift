//
//  SlideUpTransitioner.swift
//  GlobeDr
//
//  Created by dai on 1/20/20.
//  Copyright © 2020 GlobeDr. All rights reserved.
//

import UIKit

// MARK: -  SlideUpAnimateTransiting
public class PopoverAnimateTransiting: NSObject,  UIViewControllerAnimatedTransitioning {
    
    var isPresentation = false
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
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
        animatingView?.alpha = isPresentation ? 0 : 1
//        animatingView?.frame = CGRect(origin: animatingView?.frame.origin ?? .zero, size: CGSize(width: animatingView?.frame.width ?? 0, height: isPresentation ? 0 : (animatingView?.frame.height ?? 0)))
        
        // Animate using the duration from -transitionDuration:
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [.beginFromCurrentState,.allowUserInteraction], animations: {
//            animatingView?.frame = CGRect(origin: animatingView?.frame.origin ?? .zero, size: CGSize(width: animatingView?.frame.width ?? 0, height: isPresentation ? (animatingView?.frame.height ?? 0) : 0))
            animatingView?.alpha = isPresentation ? 1 : 0
            
        }) { (finished) in
            if !self.isPresentation {
                fromView?.removeFromSuperview()
            }
            
            transitionContext.completeTransition(true)
        }
    }
}

// MARK: -  PopoverAnimateTransitionDelegate
class PopoverAnimateTransitionDelegate:NSObject, UIViewControllerTransitioningDelegate {
    
    var sourceView:UIView?
    
    init(sourceView:UIView?) {
        super.init()
        self.sourceView = sourceView
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopoverPresentationController(sourceView: sourceView, presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(isPresentation:Bool) -> PopoverAnimateTransiting {
        let animationController = PopoverAnimateTransiting()
        animationController.isPresentation = isPresentation
        return animationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController(isPresentation: false)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController(isPresentation: true)
    }
}

// MARK: -  PopoverPresentationController
class PopoverPresentationController: UIPresentationController {
    var sourceView:UIView?
    var dimmingView:UIView = UIView()
    var shouldTapDimToClose = true
    init(sourceView:UIView?, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.sourceView = sourceView
        prepareDimmingView()
    }
    
    func prepareDimmingView() {
        
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimmingView.alpha = 0
        
        if shouldTapDimToClose {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(gesture:)))
            tap.cancelsTouchesInView = true
            dimmingView.addGestureRecognizer(tap)
        }
    }
    
    @objc func dimmingViewTapped(gesture:UIGestureRecognizer) {
        if gesture.state == .recognized {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    //    override var adaptivePresentationStyle: UIModalPresentationStyle {
    //        // When we adapt to a compact width environment, we want to be over full screen
    //        return .overFullScreen
    //    }
    
    override func presentationTransitionWillBegin() {
        // Here, we'll set ourselves up for the presentation
        dimmingView.frame = self.containerView?.bounds ?? .zero
        dimmingView.alpha = 0
        
        // Insert the dimming view below everything else
        self.containerView?.insertSubview(self.dimmingView, at: 0)
        
        if presentedViewController.transitionCoordinator != nil {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
                self.self.presentedView?.alpha = 1
                self.dimmingView.alpha = 1
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 1
            self.self.presentedView?.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if presentedViewController.transitionCoordinator != nil {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 0
                self.self.presentedView?.alpha = 0
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 0
            self.self.presentedView?.alpha = 0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = self.containerView?.bounds ?? .zero
//        self.popoverCoverView.layoutIfNeeded()
        let frame = self.frameOfPresentedViewInContainerView
        self.presentedView?.frame = frame
        if let sourceView = sourceView {
            if isSourceBelow(sourceView: sourceView) {
                self.presentedView?.frame.origin = getOriginFromSourceView(sourceView: sourceView, size: frame.size)
                self.presentedView?.frame.size = getSizeFromSourceView(sourceView: sourceView, size: frame.size)
            } else {
                self.presentedView?.frame.size = getSizeFromSourceView(sourceView: sourceView, size: frame.size)
                self.presentedView?.frame.origin = getOriginFromSourceView(sourceView: sourceView, size: self.presentedView?.frame.size ?? .zero)
                
            }
        } else {
            self.presentedView?.center = self.containerView?.center ?? .zero
        }
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
        #if DEBUG
        print("\(container.preferredContentSize) \(#function)")
        #endif
        return container.preferredContentSize
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        #if DEBUG
        print("\(container.preferredContentSize) \(#function)")
        #endif
        guard let containerView = self.containerView else {return}
        self.presentedView?.frame.size = container.preferredContentSize
        if let sourceView = sourceView {
            if isSourceBelow(sourceView: sourceView) {
                self.presentedView?.frame.origin = getOriginFromSourceView(sourceView: sourceView, size: container.preferredContentSize)
                self.presentedView?.frame.size = getSizeFromSourceView(sourceView: sourceView, size: container.preferredContentSize)
            } else {
                self.presentedView?.frame.size = getSizeFromSourceView(sourceView: sourceView, size: container.preferredContentSize)
                self.presentedView?.frame.origin = getOriginFromSourceView(sourceView: sourceView, size: self.presentedView?.frame.size ?? .zero)
            }
        } else {
            self.presentedView?.center = containerView.center
        }
    }
    
    func isSourceBelow(sourceView:UIView) -> Bool {
        guard let containerView = containerView,
              let rect = sourceView.superview?.convert(sourceView.frame, to: nil) else {return true}
        return rect.origin.y < containerView.frame.height/2
    }
    
    func getOriginFromSourceView(sourceView:UIView, size:CGSize) -> CGPoint {
        guard let containerView = containerView,
              let rect = sourceView.superview?.convert(sourceView.frame, to: nil) else {return .zero}
        
        let center = CGPoint(x: rect.maxX - rect.width/2 , y: rect.maxY - rect.height/2)
        var arrowRect = CGRect(origin: .zero, size: CGSize(width: 20, height: 10))
        
        // calculator position presented view
        var origin = CGPoint.zero
        let onBelow = isSourceBelow(sourceView: sourceView)
        let margin:CGFloat = 10
        let paddingSide:CGFloat = 10 // shadow with = 2
        let maxSide = containerView.frame.width - paddingSide
        let minSide = paddingSide

        if onBelow {
            origin.y = center.y + margin + arrowRect.height
        } else {
            origin.y = center.y - margin - size.height - arrowRect.height
        }
        var originX = center.x - size.width/2
        if originX + size.width > maxSide {
            originX = maxSide - size.width
        } else if originX < minSide {
            originX = minSide
        }
        origin.x = originX
        arrowRect.origin.x = center.x - originX - arrowRect.width/2
        (self.presentedView as? PopoverCoverView)?.isUp = onBelow
        (self.presentedView as? PopoverCoverView)?.arrowRect = arrowRect
        return origin
    }
    
    func getSizeFromSourceView(sourceView:UIView, size:CGSize) -> CGSize {
        guard let containerView = containerView,
              let rect = sourceView.superview?.convert(sourceView.frame, to: nil) else {return .zero}
        let center = CGPoint(x: rect.maxX - rect.width/2 , y: rect.maxY - rect.height/2)
        let arrowRect = CGRect(origin: .zero, size: CGSize(width: 20, height: 10))
        
        // calculator position presented view
        var sizeCal = size
        var origin = CGPoint.zero
        let onBelow = isSourceBelow(sourceView: sourceView)
        let margin:CGFloat = 10
        let maxSide = containerView.frame.height - 44

        if onBelow {
            origin.y = center.y + margin + arrowRect.height
            // set height dont out of screen
            if size.height > maxSide - origin.y {
                sizeCal.height = maxSide - origin.y
            }
        } else {
            if size.height > rect.minY - margin - 50 {
                sizeCal.height = rect.minY - margin - 50
            }
            origin.y = center.y - margin - sizeCal.height - arrowRect.height
        }
        
        return sizeCal
    }
}
