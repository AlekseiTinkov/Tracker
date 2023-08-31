//
//  Tracker.swift
//  Tracker
//
//  Created by Алексей Тиньков on 20.08.2023.
//

import UIKit

// структура трекеров
struct Tracker {
    // идентификатор
    let trackerId: UUID
    // название
    let name: String
    // цвет
    let color: UIColor
    // эмоджи
    let emoji: String
    // расписание
    let schedule: Set<WeekDay>
}

