//
//  TransitionAnimator.swift
//  VanHaren
//
//  Created by Artem Novichkov on 30/11/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

protocol TransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval { get }
    var presenting: Bool { get set }
    var options: AnimationOptions { get set }
}

//MARK: - Defaults
extension TransitionAnimator {
    typealias Controllers = (fromViewController: UIViewController, toViewController: UIViewController)
    
    var duration: TimeInterval {
        return options.duration
    }
    
    var interactive: Bool {
        return false
    }
    
    func configure(using transitionContext: UIViewControllerContextTransitioning) -> Controllers {
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        if presenting {
            containerView.addSubview(fromViewController.view)
            containerView.addSubview(toViewController.view)
        }
        else {
            containerView.addSubview(toViewController.view)
            containerView.addSubview(fromViewController.view)
        }
        
        
        return (fromViewController, toViewController)
    }
}

//MARK: - Animations
extension TransitionAnimator {
    
    func animate(with context: UIViewControllerContextTransitioning, animations: @escaping () -> Swift.Void) {
        UIView.animate(withDuration: duration, delay: options.delay, options: options.option, animations: animations, completion: context.completion)
    }
}

extension UIViewControllerContextTransitioning {
    
    var completion: ((Bool) -> Swift.Void) {
        return { _ in
            self.completeTransition(!self.transitionWasCancelled)
        }
    }
}
