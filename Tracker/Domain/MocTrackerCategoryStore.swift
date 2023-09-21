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
    
    private var context: NSManagedObjectContext
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Get context error")
        }
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func setupTrackers() {
        let checkRequest = TrackerCategoryCoreData.fetchRequest()
        do {
            let result = try context.fetch(checkRequest)
            if result.count > 0 { return }
        } catch {
            print("Error fetching: \(error)")
        }
        
        let trackerCategoryCoreData1 = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData1.title = "Домашний уют"
        let _ = [Tracker(trackerId: UUID(),
                         name: "Поливать растения",
                         color: .ypColorSelection5,
                         emoji: "❤️",
                         schedule: [WeekDay.sunday],
                         isPinned: false)]
            .map { tracker in
                let trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.trackerId = tracker.trackerId
                trackerCoreData.name = tracker.name
                trackerCoreData.color = UIColorMarshalling.shared.hexString(from: tracker.color)
                trackerCoreData.emoji = tracker.emoji
                trackerCoreData.schedule = ScheduleMarshalling.shared.scheduleToInt(from: tracker.schedule)
                trackerCoreData.isPinned = tracker.isPinned
                trackerCategoryCoreData1.addToTrackers(trackerCoreData)
                return trackerCoreData
            }
        
        let trackerCategoryCoreData2 = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData2.title = "Радостные мелочи"
        let _ = [Tracker(trackerId: UUID(),
                         name: "Кошка заслонила камеру на созвоне",
                         color: .ypColorSelection2,
                         emoji: "😻",
                         schedule: [WeekDay.sunday, WeekDay.saturday],
                         isPinned: false),
                 Tracker(trackerId: UUID(),
                         name: "Бабушка прислала открытку в вотсапе",
                         color: .ypColorSelection1,
                         emoji: "🌺",
                         schedule: [WeekDay.sunday],
                         isPinned: false),
                 Tracker(trackerId: UUID(),
                         name: "Свидания в апреле",
                         color: .ypColorSelection3,
                         emoji: "❤️",
                         schedule: [],
                         isPinned: false)]
            .map { tracker in
                let trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.trackerId = tracker.trackerId
                trackerCoreData.name = tracker.name
                trackerCoreData.color = UIColorMarshalling.shared.hexString(from: tracker.color)
                trackerCoreData.emoji = tracker.emoji
                trackerCoreData.schedule = ScheduleMarshalling.shared.scheduleToInt(from: tracker.schedule)
                trackerCoreData.isPinned = tracker.isPinned
                trackerCategoryCoreData2.addToTrackers(trackerCoreData)
                return trackerCoreData
            }
        
                let trackerCategoryCoreData3 = TrackerCategoryCoreData(context: context)
                trackerCategoryCoreData3.title = "Пустая категория"
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    func fetchTrackersCategory() {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            let trackersCategory = try context.fetch(request)
            trackersCategory.forEach { category in
                print("> \(String(describing: category.title)) \(category.id)")
                fetchTrackers(id: category)
            }
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    func fetchTrackers(id: TrackerCategoryCoreData) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "category == %@", id)
        do {
            let trackers = try context.fetch(request)
            trackers.forEach { tracker in
                print("  - \(String(describing: tracker.name)) \(String(describing: tracker.category?.id))")
            }
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    func setupAndFetch() {
        print(">>> begin")
        setupTrackers()
        fetchTrackersCategory()
        print("<<< end")
    }
    
}
