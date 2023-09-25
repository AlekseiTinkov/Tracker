//
//  Filters.swift
//  Tracker
//
//  Created by Алексей Тиньков on 26.09.2023.
//

import Foundation

enum Filters: Int, CaseIterable {
    case allTrackers, trackersForToday, completed, notCompleted
    
    var title: String {
        switch self {
        case .allTrackers:
            return NSLocalizedString("FiltersViewController.filters.allTrackers", comment: "")
        case .trackersForToday:
            return NSLocalizedString("FiltersViewController.filters.trackersForToday", comment: "")
        case .completed:
            return NSLocalizedString("FiltersViewController.filters.completed", comment: "")
        case .notCompleted:
            return NSLocalizedString("FiltersViewController.filters.notCompleted", comment: "")
        }
    }
}
