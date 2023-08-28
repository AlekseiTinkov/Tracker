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
}

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
                guard let record = try? makeTrackerRecord(from: i) else { return [] }
                recordsSet.insert(record)
            }
        }
        
        return recordsSet
    }
    
    func add(_ newRecord: TrackerRecord) throws {
        let trackerCoreData = try trackerStore.fetchTracker(with: newRecord.trackerId)
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerId = newRecord.trackerId
        trackerRecordCoreData.date = newRecord.date
        trackerRecordCoreData.tracker = trackerCoreData
        
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
    
    private func makeTrackerRecord(from coreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let id = coreData.trackerId,
            let date = coreData.date
        else { throw TrackerRecordStoreError.decodingErrorInvalidTracker }

        return TrackerRecord(trackerId: id, date: date)
    }
}
