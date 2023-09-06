//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Алексей Тиньков on 06.09.2023.
//

import UIKit


final class CategoryViewModel {
    
    @Observable
    private(set) var categories: [TrackerCategory] = []
    
    private var categoryStore: TrackerCategoryStore
    
    
    convenience init() {
        let trackerCategoryStore = try! TrackerCategoryStore(
            context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        )
        self.init(trackerCategoryStore: trackerCategoryStore)
    }

    init(trackerCategoryStore: TrackerCategoryStore) {
        self.categoryStore = trackerCategoryStore
        trackerCategoryStore.delegate = self
        categories = categoryStore.categories
    }

}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore) {
        categories = categoryStore.categories
    }
}
