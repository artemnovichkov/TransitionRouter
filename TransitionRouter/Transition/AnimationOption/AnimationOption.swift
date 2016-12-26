//
//  AnimationOption.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 10/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

struct AnimationOptions {
    
    let duration: TimeInterval
    let option: UIViewAnimationOptions
    let delay: TimeInterval
    
    static var `default`: AnimationOptions {
        return AnimationOptions(duration: 0.5, option: .curveEaseOut, delay: 0)
    }
}

extension UIView {
    
    static func animate(with animator: TransitionAnimator, animations: @escaping () -> Swift.Void, completion: @escaping ((Bool) -> Swift.Void)) {
        UIView.animate(withDuration: animator.duration, delay: animator.options.delay, options: animator.options.option, animations: animations, completion: completion)
    }
}
