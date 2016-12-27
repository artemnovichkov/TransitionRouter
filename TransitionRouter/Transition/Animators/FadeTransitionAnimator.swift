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
        return options.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        return animateTransition(for: presenting)(transitionContext)
    }
    
    //MARK: - Private
    
    private func animateTransition(for presenting: Bool) -> AnimateTransitionHandler {
        return presenting ? show : dismiss
    }
    
    private func show(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = configure(using: transitionContext).toViewController
        
        toViewController.view.alpha = 0
        
        animate(with: transitionContext) {
            toViewController.view.alpha = 1
        }
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = configure(using: transitionContext).fromViewController
        
        animate(with: transitionContext) {
            fromViewController.view.alpha = 0
        }
    }
}

