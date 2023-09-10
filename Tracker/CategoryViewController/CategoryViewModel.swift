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
    
    @Observable
    private(set) var selectedCategoryTitle: String?
    
    private var categoryStore: TrackerCategoryStore
    
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Get context error")
        }
        let trackerCategoryStore = TrackerCategoryStore(context: appDelegate.persistentContainer.viewContext)
        self.init(trackerCategoryStore: trackerCategoryStore)
    }
    
    init(trackerCategoryStore: TrackerCategoryStore) {
        self.categoryStore = trackerCategoryStore
        trackerCategoryStore.delegate = self
        categories = categoryStore.categories
    }
    
    func selectCategory(_ title: String) {
        selectedCategoryTitle = title
    }
    
    func deleteCategory(title: String) {
        try? categoryStore.deleteCategory(title: title)
    }
    
    func addCategory(title: String) {
        try? categoryStore.addCategory(title: title)
    }
    
    func renameCategory(oldTitle: String, newTitle: String) {
        try? categoryStore.renameCategory(oldTitle: oldTitle, newTitle: newTitle)
    }
    
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore) {
        categories = categoryStore.categories
    }
}
