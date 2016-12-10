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

extension TransitionAnimator {
    
    typealias Controllers = (fromViewController: UIViewController, toViewController: UIViewController)
    
    var duration: TimeInterval {
        return 0.5
    }
    
    //TODO: Maybe move to UIViewControllerContextTransitioning?
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
