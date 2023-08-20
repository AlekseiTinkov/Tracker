//
//  File.swift
//  Tracker
//
//  Created by Алексей Тиньков on 20.08.2023.
//

import Foundation

// выполнение трекеров
struct TrackerRecord: Hashable {
    // идентификатор
    let trackerId: UUID
    // дата выполнения
    let date: Date
}
