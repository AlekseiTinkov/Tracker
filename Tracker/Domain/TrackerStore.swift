//
//  TrackerStore.swift
//  Tracker
//
//  Created by Алексей Тиньков on 24.08.2023.
//

import UIKit
import CoreData

struct TrackerStoreMove: Hashable {
    let oldIndex: Int
    let newIndex: Int
}

enum TrackerStoreError: Error {
    case decodingErrorInvalidTracker
    case pinedError
    case deleteError
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreMove>?
    
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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    func convertTrackerToCoreData(from tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerId = tracker.trackerId
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = UIColorMarshalling.shared.hexString(from: tracker.color)
        trackerCoreData.schedule = ScheduleMarshalling.shared.scheduleToInt(from: tracker.schedule)
        trackerCoreData.isPinned = tracker.isPinned
        return trackerCoreData
    }
    
    func fetchTracker(trackerId: UUID) throws -> TrackerCoreData? {
        let request = fetchedResultsController.fetchRequest
        request.predicate = NSPredicate(format: "%K == %@", "trackerId", trackerId.uuidString)
        
        do {
            let record = try context.fetch(request).first
            return record
        } catch {
            throw TrackerStoreError.decodingErrorInvalidTracker
        }
    }
    
    func togglePin(tracker: Tracker) throws {
        guard let tracker = try fetchTracker(trackerId: tracker.trackerId) else { throw TrackerStoreError.pinedError }
        tracker.isPinned.toggle()
        try context.save()
    }
    
    func deleteTracker(tracker: Tracker) throws {
        guard let tracker = try fetchTracker(trackerId: tracker.trackerId) else { throw TrackerStoreError.deleteError }
        context.delete(tracker)
        try context.save()
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
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
}


