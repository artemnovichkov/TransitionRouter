//
//  ViewController.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 06/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

extension UIButton {
    
    static func custom(with text: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        return button
    }
}

class FirstViewController: UIViewController {

    private let topRouter = TransitionRouter(type: .top)
    private let leftRouter = TransitionRouter(type: .left)
    private let leftInteractiveRouter = TransitionRouter(type: .left)
    private let bottomRouter = TransitionRouter(type: .bottom)
    private let rightRouter = TransitionRouter(type: .right)
    private let fadeRouter = TransitionRouter(type: .custom(animator: FadeTransitionAnimator()))
    
    private var selectedRouter: TransitionRouter? {
        didSet {
            let vc = SecondViewController()
            vc.transitioningDelegate = selectedRouter
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private let topButton: UIButton = .custom(with: "Top")
    private let leftButton: UIButton = .custom(with: "Left")
    private let bottomButton: UIButton = .custom(with: "Bottom")
    private let rightButton: UIButton = .custom(with: "Right")
    
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
        
        let recognizer = UIScreenEdgePanGestureRecognizer()
        recognizer.edges = .left
        recognizer.add(leftInteractiveRouter) { 
            let vc = SecondViewController()
            vc.transitioningDelegate = self.leftInteractiveRouter
            self.present(vc, animated: true, completion: nil)
        }
        view.addGestureRecognizer(recognizer)
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
        selectedRouter = topRouter
    }
    
    func selectLeftRouter() {
        selectedRouter = leftRouter
    }
    
    func selectBottomRouter() {
        selectedRouter = bottomRouter
    }
    
    func selectRightRouter() {
        selectedRouter = rightRouter
    }
}

