//
//  AnimationOption.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 10/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

struct AnimationOptions {
    
    let option: UIViewAnimationOptions
    
    static var `default`: AnimationOptions {
        return AnimationOptions(option: .curveEaseOut)
    }
}
