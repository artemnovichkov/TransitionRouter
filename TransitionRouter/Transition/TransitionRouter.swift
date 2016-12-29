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

typealias RouterHandler = ((TransitionRouter) -> Void)
typealias UpdateHandler = ((UIPanGestureRecognizer) -> CGFloat)

final class TransitionRouter: NSObject {
    
    fileprivate var animator: TransitionAnimator
    var interactive: Bool
    let type: AnimatorType
    
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
        self.type = type
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
            let updateHandler = self.updateHandler ?? defaultUpdateHandler()
            percentage = updateHandler(gestureRecognizer)
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
        transitionHandler = handler
        return self
    }
    
    @discardableResult
    func update(handler: @escaping UpdateHandler) -> TransitionRouter {
        updateHandler = handler
        return self
    }
    
    fileprivate func defaultUpdateHandler() -> UpdateHandler {
        return { [unowned self] recognizer -> CGFloat in
            let translation = recognizer.translation(in: recognizer.view!)
            
            struct Percent {
                let translation: CGFloat
                let maxValue: CGFloat
                let coefficient: CGFloat
                
                var result: CGFloat {
                    return translation / maxValue * 0.5 * coefficient
                }
            }
            
            var test: Percent!
            switch self.type {
            case .top: test = Percent(translation: translation.y, maxValue: recognizer.view!.bounds.height, coefficient: 1)
            case .left: test = Percent(translation: translation.x, maxValue: recognizer.view!.bounds.width, coefficient: 1)
            case .bottom: test = Percent(translation: translation.y, maxValue: recognizer.view!.bounds.height, coefficient: -1)
            case .right: test = Percent(translation: translation.x, maxValue: recognizer.view!.bounds.width, coefficient: -1)
            case .custom: break //TODO: Add warning to add update handler
            }
            return test.result
        }
    }
}

//MARK: - Selector
fileprivate extension Selector {
    static let handleGesture = #selector(TransitionRouter.handleGesture)
}
