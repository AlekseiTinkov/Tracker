//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Алексей Тиньков on 24.08.2023.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidCategory
    case decodingErrorInvalidTrackers
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate(_ store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Get context error")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.fetchCategories(from: $0) })
        else { return [] }
        
        return categories
    }
    
    private func fetchCategories(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        guard let trackers = trackerCategoryCoreData.trackers else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        
        return TrackerCategory(
            title: title,
            trackers: trackers.allObjects.compactMap { convertCoreDataToTracker($0 as? TrackerCoreData) }.sorted(by: { $0.name < $1.name })
        )
    }
    
    private func convertCoreDataToTracker(_ tracker: TrackerCoreData?) -> Tracker? {
        guard let tracker = tracker,
              let trackerId = tracker.trackerId,
              let name = tracker.name,
              let color = tracker.color,
              let emoji = tracker.emoji
        else { return nil }
        
        return Tracker(trackerId: trackerId,
                       name: name,
                       color: UIColorMarshalling.shared.color(from: color),
                       emoji: emoji,
                       schedule: ScheduleMarshalling.shared.intToSchedule(from: tracker.schedule)
        )
    }
    
    private func fetchCategory(with name: String) throws -> TrackerCategoryCoreData? {
        let request = fetchedResultsController.fetchRequest
        request.predicate = NSPredicate(format: "%K == %@", argumentArray: ["title", name])
        
        do {
            let category = try context.fetch(request).first
            return category
        } catch {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategory
        }
    }
    
    func saveTracker(tracker: Tracker, to categoryName: String) throws {
        let trackerCoreData = try trackerStore.convertTrackerToCoreData(from: tracker)
        if let existingCategory = try? fetchCategory(with: categoryName) {
            var newCoreDataTrackers = existingCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
            newCoreDataTrackers.append(trackerCoreData)
            existingCategory.trackers = NSSet(array: newCoreDataTrackers)
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = categoryName
            newCategory.trackers = NSSet(array: [trackerCoreData])
        }
        try context.save()   
    }
    
    func deleteCategory(_ category: TrackerCategory) throws {
        if let category = try fetchCategory(with: category.title) {
            context.delete(category)
            try context.save()
        }

    }
    
    func addCategory(_ title: String) throws {
//        let trackerCoreData = try trackerStore.convertTrackerToCoreData(from: Tracker(trackerId: UUID(), name: "1", color: .ypColorSelection1, emoji: "P", schedule: []))
//        let categoryCoreData = TrackerCategoryCoreData(context: context)
//        categoryCoreData.title = title
//        categoryCoreData.trackers = NSSet(array: [trackerCoreData])
//        try context.save()
        try saveTracker(tracker: .init(trackerId: UUID(), name: "1", color: .ypColorSelection1, emoji: "P", schedule: []), to: title)

    }
    
    func renameCategory(oldTitle: String, newTitle: String) throws {
        print(">>> \(oldTitle) -> \(newTitle)")
        guard let category = try? fetchCategory(with: oldTitle) else { return }
        category.title = newTitle
        try context.save()
//        guard let existingCategoryCD = try? fetchCategory(with: oldTitle) else { return }
//        try addCategory(newTitle)
//        guard let updatedCategoryCD = try? fetchCategory(with: newTitle) else { return }
//
//        updatedCategoryCD.trackers = existingCategoryCD.trackers
//        try context.save()
//
//        guard let category = try? fetchCategories(from: existingCategoryCD) else { return }
//        try deleteCategory(category)
        
    }
    
    
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            guard let indexPath = newIndexPath else { fatalError() }
//            insertedIndexes?.insert(indexPath.item)
//        case .delete:
//            guard let indexPath = indexPath else { fatalError() }
//            deletedIndexes?.insert(indexPath.item)
//        case .update:
//            guard let indexPath = indexPath else { fatalError() }
//            updatedIndexes?.insert(indexPath.item)
//        case .move:
//            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
//            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
//        @unknown default:
//            fatalError()
//        }
//    }
}

extension TrackerCategoryStore {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate(self)
        print(">>> UP")
    }
}
