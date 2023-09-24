//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Алексей Тиньков on 24.09.2023.
//

import Foundation

final class StatisticsViewModel {
    
    let statisticTitles = [NSLocalizedString("StatisticsViewController.title0", comment: ""),
                  NSLocalizedString("StatisticsViewController.title1", comment: ""),
                  NSLocalizedString("StatisticsViewController.title2", comment: ""),
                  NSLocalizedString("StatisticsViewController.title3", comment: "")]
    
    private var trackerRecordStore: TrackerRecordStore
    
    
    @Observable
    private (set) var statsticsValues: [Int] = [0, 0, 0, 0]
    
    init(trackerRecordStore: TrackerRecordStore) {
        self.trackerRecordStore = trackerRecordStore
    }
    
    func getStatistics() {
        // Лучший период
        statsticsValues[0] = 0
        
        // Идеальные дни
        statsticsValues[1] = 0
        
        // Трекеров завершено
        let completedTrackersCount = try? trackerRecordStore.getCompletedTrackersCount()
        self.statsticsValues[2] = completedTrackersCount ?? 0
        
        // Среднее значение
        statsticsValues[3] = 0
    
    }
}
