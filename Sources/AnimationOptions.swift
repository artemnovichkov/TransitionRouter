//
//  AnimationOption.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 10/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

public struct AnimationOptions {
    
    public let duration: TimeInterval
    public let option: UIViewAnimationOptions
    public let delay: TimeInterval
    /// Max value for interactive transition finishing
    public let percentage: CGFloat
    
    public init(duration: TimeInterval = 0.3,
                option: UIViewAnimationOptions = .curveEaseOut,
                delay: TimeInterval = 0,
                percentage: CGFloat = 0.3) {
        self.duration = duration
        self.option = option
        self.delay = delay
        self.percentage = percentage
    }
}
