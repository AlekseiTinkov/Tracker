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
        
        return 0
    }

    func intToSchedule(from byte: UInt16) -> Set<WeekDay> {
        let schedule: Set<WeekDay> = []
        return schedule
    }
    
    private func setBit(intValue: Int16, bitPosition: Int) -> Int16 {
        return intValue | (1 << bitPosition)
    }
    
    private func resetBit(intValue: Int16, bitPosition: Int) -> Int16 {
        return intValue & ~(1 << bitPosition)
    }
    
    private func getBit(intValue: Int16, bitPosition: Int) -> Bool {
        return (intValue & (1 << bitPosition)) != 0
    }
    
}

