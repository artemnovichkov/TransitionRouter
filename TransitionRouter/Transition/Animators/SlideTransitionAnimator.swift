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
        let (fromViewController, toViewController) = configure(using: transitionContext)
        
        toViewController.updateFrame(with: direction)
        
        UIView.animate(withDuration: duration, delay: 0, options: options.option, animations: {
            fromViewController.updateFrame(with: self.direction, reverse: true)
            toViewController.center()
        }, completion: transitionContext.completion)
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        let (fromViewController, toViewController) = configure(using: transitionContext)
        
        
        UIView.animate(withDuration: duration, delay: 0, options: options.option, animations: {
            fromViewController.updateFrame(with: self.direction)
            toViewController.center()
        }, completion: transitionContext.completion)
    }
}

fileprivate extension UIViewController {
    
    func updateFrame(with direction: AnimationDirection, reverse: Bool = false) {
        switch direction {
        case .top:    reverse ? bottom() : top()
        case .left:   reverse ? right()  : left()
        case .bottom: reverse ? top()    : bottom()
        case .right:  reverse ? left()   : right()
        }
    }
    
    func center() {
        view.frame.origin = .zero
    }
    
    private func top() {
        view.frame.origin.y -= view.frame.size.height
    }
    
    private func left() {
        view.frame.origin.x -= view.frame.size.width
    }
    
    private func bottom() {
        view.frame.origin.y += view.frame.size.height
    }
    
    private func right() {
        view.frame.origin.x += view.frame.size.width
    }
}

//TODO: Move to another file
extension UIViewControllerContextTransitioning {
    
    var completion: ((Bool) -> Swift.Void) {
        return { _ in
            self.completeTransition(true)
        }
    }
}