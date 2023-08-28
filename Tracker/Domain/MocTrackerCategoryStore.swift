//
//  MocTracker.swift
//  Tracker
//
//  Created by Алексей Тиньков on 26.08.2023.
//

import UIKit
import CoreData

class MocTrackerCategoryStore {
    static let shared = MocTrackerCategoryStore()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func setupTrackers() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let checkRequest = TrackerCategoryCoreData.fetchRequest()
        let result = try! context.fetch(checkRequest)
        if result.count > 0 { return }

        let trackerCategoryCoreData1 = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData1.title = "Домашний уют"
        let _ = [Tracker(trackerId: UUID(),
                         name: "Поливать растения",
                         color: .ypColorSelection5,
                         emoji: "❤️",
                         schedule: [WeekDay.sunday])]
            .map { tracker in
                let trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.trackerId = tracker.trackerId
                trackerCoreData.name = tracker.name
                trackerCoreData.color = UIColorMarshalling.shared.hexString(from: tracker.color)
                trackerCoreData.emoji = tracker.emoji
                trackerCoreData.schedule = ScheduleMarshalling.shared.scheduleToInt(from: tracker.schedule)
                trackerCategoryCoreData1.addToTrackers(trackerCoreData)
                return trackerCoreData
            }

        let trackerCategoryCoreData2 = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData2.title = "Радостные мелочи"
        let _ = [Tracker(trackerId: UUID(),
                         name: "Кошка заслонила камеру на созвоне",
                         color: .ypColorSelection2,
                         emoji: "😻",
                         schedule: [WeekDay.sunday, WeekDay.saturday]),
                 Tracker(trackerId: UUID(),
                         name: "Бабушка прислала открытку в вотсапе",
                         color: .ypColorSelection1,
                         emoji: "🌺",
                         schedule: [WeekDay.sunday]),
                 Tracker(trackerId: UUID(),
                         name: "Свидания в вапреле",
                         color: .ypColorSelection3,
                         emoji: "❤️",
                         schedule: [])]
            .map { tracker in
                let trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.trackerId = tracker.trackerId
                trackerCoreData.name = tracker.name
                trackerCoreData.color = UIColorMarshalling.shared.hexString(from: tracker.color)
                trackerCoreData.emoji = tracker.emoji
                trackerCoreData.schedule = ScheduleMarshalling.shared.scheduleToInt(from: tracker.schedule)
                trackerCategoryCoreData2.addToTrackers(trackerCoreData)
                return trackerCoreData
            }

        try! context.save()
    }
    
    func fetchTrackersCategory() {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let trackersCategory = try! context.fetch(request)
        trackersCategory.forEach { category in
            print("> \(String(describing: category.title)) \(category.id)")
            fetchTrackers(id: category)
        }
        
    }
    
    func fetchTrackers(id: TrackerCategoryCoreData) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "category == %@", id)
        let trackers = try! context.fetch(request)
        trackers.forEach { tracker in
            print("  - \(String(describing: tracker.name)) \(String(describing: tracker.category?.id))")
        }
    }

    func setupAndFetch() {
        print(">>> begin")
        setupTrackers()
        fetchTrackersCategory()
        print("<<< end")
    }
    
}
