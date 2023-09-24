//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 31.07.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let trackerStore: TrackerStore
    private let trackerRecordStore: TrackerRecordStore
    private let trackerCategoryStore: TrackerCategoryStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController(trackerStore: trackerStore, trackerCategoryStore: trackerCategoryStore, trackerRecordStore: trackerRecordStore))
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("MainTabBarController.trackers", comment: ""),
            image: UIImage(named: "tab_trackers"),
            selectedImage: nil
        )
        
        let statisticsViewModel = StatisticsViewModel(trackerRecordStore: trackerRecordStore)
        let statisticsViewController = StatisticsViewController(statisticsViewModel: statisticsViewModel)
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("MainTabBarController.statistics", comment: ""),
            image: UIImage(named: "tab_statistics"),
            selectedImage: nil
        )
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Get context error")
        }
        let context = appDelegate.persistentContainer.viewContext
        trackerCategoryStore = TrackerCategoryStore(context: context)
        trackerStore = TrackerStore(context: context)
        trackerRecordStore = TrackerRecordStore(context: context)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
