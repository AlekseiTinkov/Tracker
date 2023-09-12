//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Алексей Тиньков on 24.08.2023.
//

import CoreData


protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate(_ store: TrackerCategoryStore)
}

struct TrackerCategoryStoreMove: Hashable {
    let oldIndex: Int
    let newIndex: Int
}

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidCategory
    case decodingErrorInvalidTrackers
}

final class TrackerCategoryStore: NSObject {
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerCategoryStoreMove>?
    private let trackerStore = TrackerStore()
    
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
    
    func deleteCategory(title: String) throws {
        if let category = try fetchCategory(with: title) {
            context.delete(category)
            try context.save()
        }
    }
    
    func addCategory(title: String) throws {
        if (try fetchCategory(with: title)) != nil { return }
        let trackerCategory = TrackerCategory(title: title, trackers: [])
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = trackerCategory.title
        trackerCategoryCoreData.trackers = NSSet(array: trackerCategory.trackers)
        try context.save()
    }
    
    func renameCategory(oldTitle: String, newTitle: String) throws {
        guard let oldCategoryCoreData = try? fetchCategory(with: oldTitle) else { return }
        try addCategory(title: newTitle)
        guard let newCategoryCoreData = try? fetchCategory(with: newTitle) else { return }
        newCategoryCoreData.trackers = oldCategoryCoreData.trackers
        try context.save()
        try deleteCategory(title: oldTitle)
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate(self)
    }
    
}
