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
        let bestPeriod = 0
        
        // Идеальные дни
        let idealDays = 0
        
        // Трекеров завершено
        let trackersCompleted = (try? trackerRecordStore.getCompletedTrackersCount()) ?? 0
        
        // Среднее значение
        let averageValue = 0
        
        statsticsValues = [bestPeriod, idealDays, trackersCompleted, averageValue]
    }
}
