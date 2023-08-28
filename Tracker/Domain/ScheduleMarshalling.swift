//
//  ScheduleMarshalling.swift
//  Tracker
//
//  Created by Алексей Тиньков on 24.08.2023.
//

import Foundation

final class ScheduleMarshalling {
    static let shared = ScheduleMarshalling()
    
    func scheduleToInt(from schedule: Set<WeekDay>) -> Int16 {
        var intSchedule: Int16 = 0
        schedule.forEach { day in
            setBit(intValue: &intSchedule, bitPosition: day.rawValue)
        }
        return intSchedule
    }
    
    func intToSchedule(from byte: Int16) -> Set<WeekDay> {
        var schedule: Set<WeekDay> = []
        for bit in 1...7 {
            if getBit(intValue: byte, bitPosition: bit) {
                schedule.insert(WeekDay(rawValue: bit) ?? .monday)
            }
        }
        return schedule
    }
    
    private func setBit(intValue: inout Int16, bitPosition: Int) {
        intValue |= (1 << bitPosition)
    }
    
    private func getBit(intValue: Int16, bitPosition: Int) -> Bool {
        return (intValue & (1 << bitPosition)) != 0
    }
    
}

