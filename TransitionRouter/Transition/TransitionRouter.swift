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

typealias EmptyHandler = (() -> Swift.Void)

final class TransitionRouter: NSObject {
    
    fileprivate var animator: TransitionAnimator
    fileprivate var interactiveAnimator: UIPercentDrivenInteractiveTransition?
    var interactive: Bool
    fileprivate var presentHandler: EmptyHandler?
    
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
    
    func update(with percentage: CGFloat) {
        interactiveAnimator?.update(percentage)
    }
    
    func finish() {
        interactiveAnimator?.finish()
    }
    
    func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            presentHandler?()
        case .changed:
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
            let d = translation.x / gestureRecognizer.view!.bounds.width * 0.5
            update(with: d)
        case .cancelled, .ended:
            finish()
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
extension UIGestureRecognizer {
    
    func add(_ router: TransitionRouter, presentHandler: @escaping EmptyHandler) {
        router.presentHandler = presentHandler
        addTarget(router, action: #selector(TransitionRouter.handleGesture))
    }
}
