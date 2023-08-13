//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Алексей Тиньков on 31.07.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        //let viewController = MainTabBarController()
        //let tabBarController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = MainTabBarController()
        //self.window = window
        window?.makeKeyAndVisible()
        
//        guard let scene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: scene)
//        window?.makeKeyAndVisible()
//        window?.rootViewController = SplashViewController()
    }
}
