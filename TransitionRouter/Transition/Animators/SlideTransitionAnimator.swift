//
//  SlideTransitionAnimator.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 06/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

enum AnimationDirection {
    case top, left, bottom, right
}

final class SlideTransitionAnimator: NSObject, TransitionAnimator {
    
    var presenting = true
    var options: AnimationOptions = .default
    
    fileprivate let direction: AnimationDirection
    
    init(direction: AnimationDirection) {
        self.direction = direction
    }
}

extension SlideTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    typealias AnimateTransitionHandler = (UIViewControllerContextTransitioning) -> ()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        return animateTransition(for: presenting)(transitionContext)
    }
    
    func animateTransition(for presenting: Bool) -> AnimateTransitionHandler {
        return presenting ? show : dismiss
    }
    
    private func show(using transitionContext: UIViewControllerContextTransitioning) {
        let (fromViewController, toViewController) = configure(using: transitionContext)
        
        switch direction {
        case .top:
            toViewController.top()
        case .left:
            toViewController.left()
        case .bottom:
            toViewController.bottom()
        case .right:
            toViewController.right()
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: options.option, animations: {
            switch self.direction {
            case .top:
                fromViewController.bottom()
            case .left:
                fromViewController.right()
            case .bottom:
                fromViewController.top()
            case .right:
                fromViewController.left()
            }
            toViewController.center()
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        let (fromViewController, toViewController) = configure(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: options.option, animations: {
            switch self.direction {
            case .top:
                fromViewController.top()
            case .left:
                fromViewController.left()
            case .bottom:
                fromViewController.bottom()
            case .right:
                fromViewController.right()
            }
            toViewController.center()
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}

fileprivate extension UIViewController {
    
    func center() {
        view.frame.origin = .zero
    }
    
    func top() {
        view.frame.origin.y -= view.frame.size.height
    }
    
    func left() {
        view.frame.origin.x -= view.frame.size.width
    }
    
    func bottom() {
        view.frame.origin.y += view.frame.size.height
    }
    
    func right() {
        view.frame.origin.x += view.frame.size.width
    }
}
