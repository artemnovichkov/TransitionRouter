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
    /// Max value for interactive transition finish
    let percentage: CGFloat
    
    static var `default`: AnimationOptions {
        return AnimationOptions(duration: 0.3, option: .curveEaseOut, delay: 0, percentage: 0.3)
    }
}
