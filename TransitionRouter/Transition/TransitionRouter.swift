//
//  TransitionRouter.swift
//  VanHaren
//
//  Created by Artem Novichkov on 30/11/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

enum AnimatorType {
    
    case top, left, bottom, right
    case custom(animator: TransitionAnimator)
    
    fileprivate var animator: TransitionAnimator {
        switch self {
        case .top: return SlideTransitionAnimator(direction: .top)
        case .left: return SlideTransitionAnimator(direction: .left)
        case .bottom: return SlideTransitionAnimator(direction: .bottom)
        case .right: return SlideTransitionAnimator(direction: .right)
        case let .custom(animator): return animator
        }
    }
}

typealias RouterHandler = ((TransitionRouter) -> Swift.Void)
typealias UpdateHandler = ((UIPanGestureRecognizer) -> CGFloat)

final class TransitionRouter: NSObject {
    
    fileprivate var animator: TransitionAnimator
    fileprivate var interactiveAnimator: UIPercentDrivenInteractiveTransition?
    var interactive: Bool
    fileprivate var presentHandler: RouterHandler?
    fileprivate var updateHandler: UpdateHandler?
    
    var options: AnimationOptions = .default {
        willSet {
            animator.options = newValue
        }
    }
    
    init(type: AnimatorType, interactive: Bool = true) {
        let animator = type.animator
        self.interactive = interactive
        if interactive {
            interactiveAnimator = UIPercentDrivenInteractiveTransition()
        }
        self.animator = animator
    }
    
    @objc fileprivate func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            presentHandler?(self)
        case .changed:
            var percentage: CGFloat = 0
            if let updateHandler = updateHandler {
                percentage = updateHandler(gestureRecognizer)
            }
            interactiveAnimator?.update(percentage)
        case .cancelled, .ended:
            interactiveAnimator?.finish()
        default: break
        }
    }
}

extension TransitionRouter: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator
    }
}

extension TransitionRouter: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {}
}

//MARK: - Recognizers
extension TransitionRouter {
    
    func add(_ recognizer: UIPanGestureRecognizer, presentHandler: @escaping RouterHandler, updateHandler: @escaping UpdateHandler) {
        self.presentHandler = presentHandler
        self.updateHandler = updateHandler
        recognizer.addTarget(self, action: .handleGesture)
    }
}

fileprivate extension Selector {
    static let handleGesture = #selector(TransitionRouter.handleGesture)
}
