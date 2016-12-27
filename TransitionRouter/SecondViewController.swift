//
//  SecondViewController.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 06/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    let label: UILabel = {
        let label = UILabel()
        label.text = "Second View Controller"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        label.sizeToFit()
        label.center = view.center
    }
}
