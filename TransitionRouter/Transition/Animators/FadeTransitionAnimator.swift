//
//  FadeTransitionAnimator.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 10/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

class FadeTransitionAnimator: NSObject, TransitionAnimator {
    
    var presenting = true
    var options: AnimationOptions = .default
}

extension FadeTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    private typealias AnimateTransitionHandler = (UIViewControllerContextTransitioning) -> ()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        return animateTransition(for: presenting)(transitionContext)
    }
    
    //MARK: - Private
    
    private func animateTransition(for presenting: Bool) -> AnimateTransitionHandler {
        return presenting ? show : dismiss
    }
    
    private func show(using transitionContext: UIViewControllerContextTransitioning) {
        let (_, toViewController) = configure(using: transitionContext)
        
        toViewController.view.alpha = 0
        
        UIView.animate(withDuration: duration, delay: 0, options: options.option, animations: {
            toViewController.view.alpha = 1
        }, completion: transitionContext.completion)
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        let (fromViewController, _) = configure(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: options.option, animations: {
            fromViewController.view.alpha = 0
        }, completion: transitionContext.completion)
    }
}

