//
//  Models.swift
//  Tracker
//
//  Created by Алексей Тиньков on 16.08.2023.
//

import UIKit

enum TrackerType {
    case habit
    case event
}

struct Tracker {
    let trackerId = UUID()
    let trackerType: TrackerType
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDay>
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

struct TrackerRecord: Hashable {
    let trackerId: UUID
    let date: Date
}
