//
//  TransitionAnimator.swift
//  VanHaren
//
//  Created by Artem Novichkov on 30/11/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

protocol TransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool { get set }
    var options: AnimationOptions { get set }
}

typealias Controllers = (fromViewController: UIViewController, toViewController: UIViewController)
typealias AnimateTransitionHandler = (UIViewControllerContextTransitioning) -> ()

extension TransitionAnimator {
    
    func configure(using transitionContext: UIViewControllerContextTransitioning) -> Controllers {
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        if presenting {
            containerView.addSubview(toViewController.view)
        }
        
        return (fromViewController, toViewController)
    }
    
    func animate(with context: UIViewControllerContextTransitioning, animations: @escaping () -> Swift.Void) {
        UIView.animate(withDuration: options.duration, delay: options.delay, options: options.option, animations: animations, completion: context.completion)
    }
}

extension UIViewControllerContextTransitioning {
    
    var completion: ((Bool) -> Swift.Void) {
        return { _ in
            self.completeTransition(!self.transitionWasCancelled)
        }
    }
}
