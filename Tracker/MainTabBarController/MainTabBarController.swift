//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 31.07.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        
        trackersViewController.tabBarItem = UITabBarItem(
                    title: "Трекеры",
                    image: UIImage(named: "tab_trackers"),
                    selectedImage: nil
                )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
                    title: "Статистика",
                    image: UIImage(named: "tab_statistics"),
                    selectedImage: nil
                )
        self.viewControllers = [trackersViewController, statisticsViewController]
    }

}
