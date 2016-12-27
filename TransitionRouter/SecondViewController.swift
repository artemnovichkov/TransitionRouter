//
//  SecondViewController.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 06/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    private let button: UIButton = .custom(with: "Dismiss")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    func buttonAction() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        button.center = view.center
        button.frame.size = CGSize(width: 100, height: 20)
    }
}
