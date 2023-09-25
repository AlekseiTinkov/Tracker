//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Алексей Тиньков on 24.08.2023.
//

import UIKit
import CoreData

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidTracker
    case getTrackerCoreDataError
}

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
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
    
    var records: Set<TrackerRecord> {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        let objects = try? context.fetch(request)
        var recordsSet: Set<TrackerRecord> = []
        if let objects {
            for i in objects {
                guard let record = try? convertCoreDataToRecord(from: i) else { return [] }
                recordsSet.insert(record)
            }
        }
        return recordsSet
    }
    
    func add(_ newRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerId = newRecord.trackerId
        trackerRecordCoreData.date = newRecord.date
        try context.save()
    }
    
    func remove(_ record: TrackerRecord) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@",#keyPath(TrackerRecordCoreData.trackerId), record.trackerId.uuidString)
        let records = try context.fetch(request)
        guard let recordToRemove = records.first else { return }
        context.delete(recordToRemove)
        try context.save()
    }
    
    private func convertCoreDataToRecord(from coreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let id = coreData.trackerId,
            let date = coreData.date
        else { throw TrackerRecordStoreError.decodingErrorInvalidTracker }
        return TrackerRecord(trackerId: id, date: date)
    }
    
    func getCompletedTrackersCount() throws -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let recordsCoreData = try context.fetch(request)
//        let trackers = try recordsCoreData.compactMap( { try getTrackerCoreData(id: $0.trackerId) } )
//        return trackers.count
        return recordsCoreData.count
    }
    
    private func getTrackerCoreData(id: UUID?) throws -> TrackerCoreData {
        guard
            let id,
            let tracker = try? trackerStore.fetchTracker(trackerId: id)
        else { throw TrackerRecordStoreError.getTrackerCoreDataError}
        return tracker
    }
}
