//
//  TransitionRouter.swift
//  VanHaren
//
//  Created by Artem Novichkov on 30/11/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public enum AnimatorType {
    
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

public typealias RouterHandler = ((TransitionRouter) -> Void)
public typealias UpdateHandler = ((UIPanGestureRecognizer) -> CGFloat)

public class TransitionRouter: NSObject {
    
    fileprivate var animator: TransitionAnimator
    /// If true, an interactive animator will be use when presenting a view controller.
    var interactive: Bool
    /// Type of animator
    let type: AnimatorType
    
    //properties for interactive transitions
    fileprivate var interactiveAnimator: UIPercentDrivenInteractiveTransition?
    fileprivate var transitionHandler: RouterHandler?
    fileprivate var updateHandler: UpdateHandler?
    private var currentPercentage: CGFloat?
    
    /// Options for transition animation
    var options: AnimationOptions = .default {
        didSet {
            animator.options = options
        }
    }
    
    //MARK: - Lilecycle
    
    /// Returns an object initialized with type and interactive option.
    ///
    /// - Parameters:
    ///   - type: Type of animator
    ///   - interactive: If true, an interactive animator will be use when presenting a view controller. Default is false
    public init(type: AnimatorType, interactive: Bool = false) {
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
            guard let percentage = currentPercentage, percentage >= options.percentage else {
                interactiveAnimator?.cancel()
                return
            }
            interactiveAnimator?.finish()
        default: break
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension TransitionRouter: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator
    }
}

//MARK: - Recognizers
public extension TransitionRouter {
    
    /// Adds a target and an action to the router for interactive animation.
    ///
    /// - Parameter recognizer:
    /// - Returns: A router used as target of recognizer.
    @discardableResult
    func add(_ recognizer: UIPanGestureRecognizer) -> TransitionRouter {
        recognizer.addTarget(self, action: .handleGesture)
        return self
    }
    
    /// You must present or dismiss your view controller.
    ///
    /// - Parameter handler: You must use the router in handler parameter as `transitioningDelegate`
    /// - Returns: A router with transition handler.
    @discardableResult
    func transition(handler: @escaping RouterHandler) -> TransitionRouter {
        transitionHandler = handler
        return self
    }
    
    /// Passes handler for update of animation progress. If you didn't set it, the router will use default handler.
    ///
    /// - Parameter handler: You must return value showed progress of animation.
    /// - Returns: A router with update handler.
    @discardableResult
    func update(handler: @escaping UpdateHandler) -> TransitionRouter {
        updateHandler = handler
        return self
    }
    
    fileprivate func defaultUpdateHandler() -> UpdateHandler {
        return { [unowned self] recognizer -> CGFloat in
            let translation = recognizer.translation(in: recognizer.view!)
            
            struct Percentage {
                let translation: CGFloat
                let maxValue: CGFloat
                let coefficient: CGFloat
                
                var result: CGFloat {
                    return translation / maxValue * 0.5 * coefficient
                }
            }
            
            var percentage: Percentage!
            switch self.type {
            case .top:    percentage = Percentage(translation: translation.y, maxValue: recognizer.view!.bounds.height, coefficient: 1)
            case .left:   percentage = Percentage(translation: translation.x, maxValue: recognizer.view!.bounds.width, coefficient: 1)
            case .bottom: percentage = Percentage(translation: translation.y, maxValue: recognizer.view!.bounds.height, coefficient: -1)
            case .right:  percentage = Percentage(translation: translation.x, maxValue: recognizer.view!.bounds.width, coefficient: -1)
            case .custom: break //TODO: Add warning to add update handler
            }
            return percentage.result
        }
    }
}

//MARK: - Selector
fileprivate extension Selector {
    static let handleGesture = #selector(TransitionRouter.handleGesture)
}
