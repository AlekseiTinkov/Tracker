//
//  TrackerStore.swift
//  Tracker
//
//  Created by Алексей Тиньков on 24.08.2023.
//

import UIKit
import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    
}

