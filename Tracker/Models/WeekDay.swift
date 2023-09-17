//
//  WeekDay.swift
//  Tracker
//
//  Created by Алексей Тиньков on 16.08.2023.
//

import Foundation

// дни недели
enum WeekDay: Int, Comparable, CaseIterable {
    static func < (lhs: WeekDay, rhs: WeekDay) -> Bool {
        return (lhs.number == 1 ? 8 : lhs.number) < (rhs.number == 1 ? 8 : rhs.number)
    }
    
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var number: Int {
        switch self {
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        case .sunday:
            return 1
        }
    }
    
    // полные названия
    var name: String {
        switch self {
        case .monday:
            return NSLocalizedString("WeekDay.monday", comment: "")
        case .tuesday:
            return NSLocalizedString("WeekDay.tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("WeekDay.wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("WeekDay.thursday", comment: "")
        case .friday:
            return NSLocalizedString("WeekDay.friday", comment: "")
        case .saturday:
            return NSLocalizedString("WeekDay.saturday", comment: "")
        case .sunday:
            return NSLocalizedString("WeekDay.sunday", comment: "")
        }
    }
    
    // короткие названия
    var shortName: String {
        switch self {
        case .monday:
            return NSLocalizedString("WeekDay.mo", comment: "")
        case .tuesday:
            return NSLocalizedString("WeekDay.tu", comment: "")
        case .wednesday:
            return NSLocalizedString("WeekDay.we", comment: "")
        case .thursday:
            return NSLocalizedString("WeekDay.th", comment: "")
        case .friday:
            return NSLocalizedString("WeekDay.fr", comment: "")
        case .saturday:
            return NSLocalizedString("WeekDay.sa", comment: "")
        case .sunday:
            return NSLocalizedString("WeekDay.su", comment: "")
        }
    }
}
