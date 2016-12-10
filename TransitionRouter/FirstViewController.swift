//
//  ViewController.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 06/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    private let topRouter = TransitionRouter(type: .top)
    private let leftRouter = TransitionRouter(type: .left)
    private let bottomRouter = TransitionRouter(type: .bottom)
    private let rightRouter = TransitionRouter(type: .right)
    
    private var selectedAnimator: TransitionRouter? {
        didSet {
            let vc = SecondViewController()
            vc.transitioningDelegate = selectedAnimator
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private let topButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Top", for: .normal)
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Left", for: .normal)
        return button
    }()
    
    private let bottomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Bottom", for: .normal)
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Right", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(topButton)
        topButton.addTarget(self, action: #selector(FirstViewController.selectTopRouter), for: .touchUpInside)
        view.addSubview(leftButton)
        leftButton.addTarget(self, action: #selector(FirstViewController.selectLeftRouter), for: .touchUpInside)
        view.addSubview(bottomButton)
        bottomButton.addTarget(self, action: #selector(FirstViewController.selectBottomRouter), for: .touchUpInside)
        view.addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(FirstViewController.selectRightRouter), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        let inset: CGFloat = 100
        topButton.center = CGPoint(x: view.center.x, y: view.center.y - inset)
        leftButton.center = CGPoint(x: view.center.x - inset, y: view.center.y)
        bottomButton.center = CGPoint(x: view.center.x, y: view.center.y + inset)
        rightButton.center = CGPoint(x: view.center.x + inset, y: view.center.y)
        
        let buttons = [topButton, leftButton, bottomButton, rightButton]
        
        for button in buttons {
            button.frame.size = CGSize(width: 100, height: 20)
        }
    }
    
    func selectTopRouter() {
        selectedAnimator = topRouter
    }
    
    func selectLeftRouter() {
        selectedAnimator = leftRouter
    }
    
    func selectBottomRouter() {
        selectedAnimator = bottomRouter
    }
    
    func selectRightRouter() {
        selectedAnimator = rightRouter
    }
}

