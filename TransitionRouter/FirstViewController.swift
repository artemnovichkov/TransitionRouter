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
    
    private let topInteractiveRouter = TransitionRouter(type: .top, interactive: true)
    private let leftInteractiveRouter = TransitionRouter(type: .left, interactive: true)
    private let bottomInteractiveRouter = TransitionRouter(type: .bottom, interactive: true)
    private let rightInteractiveRouter = TransitionRouter(type: .right, interactive: true)
    
    private var selectedRouter: TransitionRouter? {
        didSet {
            let vc = SecondViewController()
            vc.transitioningDelegate = selectedRouter
            present(vc, animated: true)
        }
    }
    
    private let topButton: UIButton = .custom(with: "Top")
    private let leftButton: UIButton = .custom(with: "Left")
    private let bottomButton: UIButton = .custom(with: "Bottom")
    private let rightButton: UIButton = .custom(with: "Right")
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        topButton.addTarget(self, action: #selector(topAction), for: .touchUpInside)
        view.addSubview(topButton)
        leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        view.addSubview(leftButton)
        bottomButton.addTarget(self, action: #selector(bottomAction), for: .touchUpInside)
        view.addSubview(bottomButton)
        rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        view.addSubview(rightButton)
        
        configureTopInteractiveRouter()
        configureLeftInteractiveRouter()
        configureBottomInteractiveRouter()
        configureRightInteractiveRouter()
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Configuration
    
    func configureLeftInteractiveRouter() {
        let leftRecognizer = UIScreenEdgePanGestureRecognizer()
        leftRecognizer.edges = .left
        leftInteractiveRouter
            .add(leftRecognizer)
            .transition { [unowned self] router in
                let vc = SecondViewController()
                vc.transitioningDelegate = router
                self.present(vc, animated: true)
        }
        view.addGestureRecognizer(leftRecognizer)
    }
    
    func configureTopInteractiveRouter() {
        let topRecognizer = UIPanGestureRecognizer()
        topInteractiveRouter
            .add(topRecognizer)
            .transition { [unowned self] router in
                let vc = SecondViewController()
                vc.transitioningDelegate = router
                self.present(vc, animated: true)
        }
        view.addGestureRecognizer(topRecognizer)
    }
    
    func configureBottomInteractiveRouter() {
        let bottomRecognizer = UIPanGestureRecognizer()
        bottomInteractiveRouter
            .add(bottomRecognizer)
            .transition { [unowned self] router in
                let vc = SecondViewController()
                vc.transitioningDelegate = router
                self.present(vc, animated: true)
        }
        view.addGestureRecognizer(bottomRecognizer)
    }
    
    func configureRightInteractiveRouter() {
        let rightRecognizer = UIScreenEdgePanGestureRecognizer()
        rightRecognizer.edges = .right
        rightInteractiveRouter
            .add(rightRecognizer)
            .transition { [unowned self] router in
                let vc = SecondViewController()
                vc.transitioningDelegate = router
                self.present(vc, animated: true)
        }
        view.addGestureRecognizer(rightRecognizer)
    }
    
    //MARK: - Actions
    
    func topAction() {
        selectedRouter = TransitionRouter(type: .top)
    }
    
    func leftAction() {
        selectedRouter = TransitionRouter(type: .left)
    }
    
    func bottomAction() {
        selectedRouter = TransitionRouter(type: .bottom)
    }
    
    func rightAction() {
        selectedRouter = TransitionRouter(type: .right)
    }
}

