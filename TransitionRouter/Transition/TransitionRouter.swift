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
    var interactive: Bool
    
    //properties for interactive transitions
    fileprivate var interactiveAnimator: UIPercentDrivenInteractiveTransition?
    fileprivate var transitionHandler: RouterHandler?
    fileprivate var updateHandler: UpdateHandler?
    private var currentPercentage: CGFloat?
    
    var options: AnimationOptions = .default {
        didSet {
            animator.options = options
        }
    }
    
    //MARK: - Filecycle
    
    init(type: AnimatorType, interactive: Bool = false) {
        let animator = type.animator
        self.interactive = interactive
        if interactive {
            interactiveAnimator = UIPercentDrivenInteractiveTransition()
        }
        self.animator = animator
    }
    
    //MARK: - Actions
    
    @objc fileprivate func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            transitionHandler?(self)
        case .changed:
            var percentage: CGFloat = 0
            if let updateHandler = updateHandler {
                percentage = updateHandler(gestureRecognizer)
            }
            currentPercentage = percentage
            interactiveAnimator?.update(percentage)
        case .cancelled, .ended:
            guard let percentage = currentPercentage else {
                interactiveAnimator?.cancel()
                return
            }
            if percentage >= options.percentage {
                interactiveAnimator?.finish()
            }
            else {
                interactiveAnimator?.cancel()
            }
        default: break
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
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

//MARK: - Recognizers
extension TransitionRouter {
    
    @discardableResult
    func add(_ recognizer: UIPanGestureRecognizer) -> TransitionRouter {
        recognizer.addTarget(self, action: .handleGesture)
        return self
    }
    
    @discardableResult
    func transition(handler: @escaping RouterHandler) -> TransitionRouter {
        self.transitionHandler = handler
        return self
    }
    
    @discardableResult
    func update(handler: @escaping UpdateHandler) -> TransitionRouter {
        self.updateHandler = handler
        return self
    }
}

//MARK: - Selector
fileprivate extension Selector {
    static let handleGesture = #selector(TransitionRouter.handleGesture)
}
