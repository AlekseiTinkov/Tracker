//
//  WeekDay.swift
//  Tracker
//
//  Created by Алексей Тиньков on 16.08.2023.
//


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
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    
    // короткие названия
    var shortName: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}
