//
//  AppDelegate.swift
//  Tracker
//
//  Created by Алексей Тиньков on 31.07.2023.
//

import UIKit
import CoreData

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let secondLaunchKey = "secondLaunch"
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AnalyticsService.activate()
        
        window = UIWindow()
        if !UserDefaults.standard.bool(forKey: secondLaunchKey) {
            UserDefaults.standard.set(true, forKey: secondLaunchKey)
            window?.rootViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        } else {
            window?.rootViewController = MainTabBarController()
        }
        window?.makeKeyAndVisible()
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
