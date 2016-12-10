//
//  AppDelegate.swift
//  TransitionRouter
//
//  Created by Artem Novichkov on 06/12/2016.
//  Copyright © 2016 Artem Novichkov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let firstViewController = FirstViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = firstViewController
        window!.makeKeyAndVisible()
        return true
    }
}

