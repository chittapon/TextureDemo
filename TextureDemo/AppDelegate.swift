//
//  AppDelegate.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 15/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let provider = UseCaseProvider(environment: Environment())
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRootViewController()
        return true
    }
    
    private func setRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = MovieViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    static var provider: UseCaseProvider {
        return (UIApplication.shared.delegate as! AppDelegate).provider
    }
}
