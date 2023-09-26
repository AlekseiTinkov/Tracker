//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Алексей Тиньков on 26.09.2023.
//

import YandexMobileMetrica


struct AnalyticsService {
    static private let apiKey = "7b44c08d-b404-4466-83d5-150fddbd43ff"
    
    enum Event: String {
        case open = "open"
        case close = "close"
        case click = "click"
    }

    enum Screen: String {
        case main = "Main"
    }

    enum Item: String {
        case addTrack = "add_track"
        case track = "track"
        case filter = "filter"
        case edit = "edit"
        case delete = "delete"
    }
    
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey) else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: Event, screen: Screen, item: Item? = nil) {
        var params: [String: String]
        if event == .click && item != nil {
            params = ["screen": screen.rawValue, "item" : item?.rawValue ?? ""]
        } else {
            params = ["screen": screen.rawValue]
        }
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        print("Analytics Service Log: event - \(event), params - \(params)")
    }
}
