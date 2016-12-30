//
//  TransitionAnimator.swift
//  VanHaren
//
//  Created by Artem Novichkov on 30/11/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public protocol TransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    /// If true, the animator will use presentation animation. Otherwise, dismissal logic
    var presenting: Bool { get set }
    /// Options for transition animation
    var options: AnimationOptions { get set }
}

public typealias Controllers = (fromViewController: UIViewController, toViewController: UIViewController)
public typealias AnimateTransitionHandler = (UIViewControllerContextTransitioning) -> ()

public extension TransitionAnimator {
    
    /// Adds toViewController on corrent context.
    ///
    /// - Parameter transitionContext: The context object containing information about the transition.
    /// - Returns: from and view controllers.
    func configure(using transitionContext: UIViewControllerContextTransitioning) -> Controllers {
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toViewController.view)
        
        return (fromViewController, toViewController)
    }
    
    /// Synax sugar for animation. Uses default completion for context.
    ///
    /// - Parameters:
    ///   - context: The context object containing information about the transition.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy.
    func animate(with context: UIViewControllerContextTransitioning, animations: @escaping () -> Void) {
        UIView.animate(withDuration: options.duration, delay: options.delay, options: options.option, animations: animations, completion: context.completion)
    }
}

public extension UIViewControllerContextTransitioning {
    
    /// Default completion with correct finish state.
    var completion: ((Bool) -> Void) {
        return { _ in
            self.completeTransition(!self.transitionWasCancelled)
        }
    }
}
