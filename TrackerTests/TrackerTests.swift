//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Алексей Тиньков on 26.09.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testMainScreenLight() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Get context error")
        }
        let context = appDelegate.persistentContainer.viewContext
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        let trackerStore = TrackerStore(context: context)
        let trackerRecordStore = TrackerRecordStore(context: context)
        let trackersViewController = TrackersViewController(trackerStore: trackerStore,
                                        trackerCategoryStore: trackerCategoryStore,
                                        trackerRecordStore: trackerRecordStore)
        assertSnapshot(matching: trackersViewController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testMainScreenDark() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Get context error")
        }
        let context = appDelegate.persistentContainer.viewContext
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        let trackerStore = TrackerStore(context: context)
        let trackerRecordStore = TrackerRecordStore(context: context)
        let trackersViewController = TrackersViewController(trackerStore: trackerStore,
                                        trackerCategoryStore: trackerCategoryStore,
                                        trackerRecordStore: trackerRecordStore)
        assertSnapshot(matching: trackersViewController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
