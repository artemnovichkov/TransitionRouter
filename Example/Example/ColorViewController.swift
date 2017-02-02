//
//  ColorViewController.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 06/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    private let button: UIButton = .custom(with: "Dismiss")
    private let color: UIColor
    
    // MARK: - Lifecycle
    
    init(color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        button.center = view.center
        button.frame.size = CGSize(width: 100, height: 20)
    }
    
    //Just for top and bottom edge gesture recognizers
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Actions
    
    func buttonAction() {
        self.dismiss(animated: true)
    }
}
