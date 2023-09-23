//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 01.08.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    private var currentDate: Date = Date()
    
    let cellIdentifier = "cell"
    let headerIdentifier = "header"
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.firstWeekday = 2
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: Date())
        
        var dateComponents = DateComponents()
        dateComponents.year = components.year
        dateComponents.month = components.month
        dateComponents.day = components.day
        datePicker.date = calendar.date(from: dateComponents) ?? Date()
        
        datePicker.addTarget(self, action: #selector(changeDatePicker), for: .valueChanged)
        return datePicker
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("TrackersViewController.titleLabel", comment: "")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)
        return titleLabel
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = NSLocalizedString("TrackersViewController.searchField", comment: "")
        searchField.delegate = self
        return searchField
    }()
    
    private var placeholderView: UIStackView = {
        let placeholderView = UIStackView()
        
        let label = UILabel()
        label.text = NSLocalizedString("TrackersViewController.placeholderLabel", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")?.withRenderingMode(.alwaysOriginal)
        
        let placeholderSubView: UIStackView = UIStackView()
        placeholderSubView.axis = .vertical
        placeholderSubView.spacing = 8
        placeholderSubView.alignment = .center
        placeholderSubView.addArrangedSubview(imageView)
        placeholderSubView.addArrangedSubview(label)
        
        placeholderView.axis = .horizontal
        placeholderView.alignment = .center
        placeholderView.addArrangedSubview(placeholderSubView)
        return placeholderView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(HeaderTrackersView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.delegate = self
        collectionView.backgroundColor = .ypWhite
        return collectionView
    }()
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Get context error")
        }
        let context = appDelegate.persistentContainer.viewContext
        trackerCategoryStore = TrackerCategoryStore(context: context)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        MocTrackerCategoryStore.shared.setupTrackers()
        categories = trackerCategoryStore.categories
        completedTrackers = trackerRecordStore.records
        
        setupNavBar()
        setupTitile()
        setupSearchField()
        setupCollectionView()
        setupPlaceholder()
        
        setupKeyboardDismiss()
        
        updateVisibleCategories()
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc
    private func addTracker() {
        let newTrackerTypeSelectViewController = NewTrackerTypeSelectViewController(trackerCategoryStore: trackerCategoryStore)
        newTrackerTypeSelectViewController.delegate = self
        present(newTrackerTypeSelectViewController, animated: true)
    }
    
    @objc private func changeDatePicker() {
        currentDate = datePicker.date
        self.dismiss(animated: false)
        
        updateVisibleCategories()
    }
    
    private func updateVisibleCategories() {
        let filterWeekdey = Calendar.current.component(.weekday, from: currentDate)
        let filterText = (searchField.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay.number == filterWeekdey
                } == true
                
                let isEvent = ( tracker.schedule.count == 0 )
                
                let textCondition = tracker.name.lowercased().contains(filterText) || filterText.isEmpty
                
                return ( dateCondition || isEvent ) && textCondition && !tracker.isPinned
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(title: category.title,
                                   trackers: trackers)
        }
        
        let pinnedTrackers = categories.map{ $0.trackers }.joined().filter { tracker in
            tracker.isPinned
        }
        if !pinnedTrackers.isEmpty {
            visibleCategories.insert(TrackerCategory(title: NSLocalizedString("TrackersViewController.collectionView.pinnedCategory", comment: ""), trackers: pinnedTrackers), at: 0)
        }
        
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func togglePin(tracker: Tracker) {
        try? trackerStore.togglePin(tracker: tracker)
        categories = trackerCategoryStore.categories
        updateVisibleCategories()
    }
    
    private func deleteTracker(tracker: Tracker) {
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("TrackersViewController.collectionView.deleteAlert", comment: ""),
                                      preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: NSLocalizedString("TrackersViewController.collectionView.buttonCancel", comment: ""), style: .cancel)
        let deleteAction = UIAlertAction(title: NSLocalizedString("TrackersViewController.collectionView.buttonDelete", comment: ""), style: .destructive) { [weak self] _ in
            guard let self else { return }
            try? self.trackerStore.deleteTracker(tracker: tracker)
            categories = trackerCategoryStore.categories
            updateVisibleCategories()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    private func editTracker(tracker: Tracker) {
        let categoryTitle = categories.first(where: { $0.trackers.contains(where: { $0.trackerId == tracker.trackerId})
        })?.title
        let completedDays = completedTrackers.filter { $0.trackerId == tracker.trackerId }.count
        let editTrackerViewController = EditTrackerViewController(trackerCategoryStore: trackerCategoryStore)
        editTrackerViewController.editingTracker = tracker
        editTrackerViewController.trackerType = tracker.schedule.isEmpty ? .event : .habit
        editTrackerViewController.categoryTitle = categoryTitle
        editTrackerViewController.completedDays = completedDays
        editTrackerViewController.delegate = self
        editTrackerViewController.modalPresentationStyle = .pageSheet
        present(editTrackerViewController, animated: true)
    }
    
    private func reloadPlaceholder() {
        placeholderView.isHidden = !visibleCategories.isEmpty
    }
    
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            let imageButton = UIImage(named: "button_plus")?.withRenderingMode(.alwaysTemplate)
            
            let leftItem = UIBarButtonItem(image: imageButton, style: .plain, target: self, action: #selector(addTracker))
            leftItem.tintColor = .ypBlack
            navBar.topItem?.setLeftBarButton(leftItem, animated: false)
            
            let rightItem = UIBarButtonItem(customView: datePicker)
            navBar.topItem?.setRightBarButton(rightItem, animated: false)
        }
    }
    
    private func setupTitile() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSearchField() {
        self.searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupPlaceholder() {
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderView)
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateVisibleCategories()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateVisibleCategories()
        textField.becomeFirstResponder()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackersCollectionViewCell else {
            assertionFailure("Error get cell")
            return .init()
        }
        
        cell.delegate = self
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let completedDays = completedTrackers.filter { $0.trackerId == tracker.trackerId }.count
        cell.configure(tracker: tracker, isCompletedToday: isTrackerCompletedToday(tracker.trackerId), completedDays: completedDays, indexPath: indexPath)
        
        return cell
    }
    
    private func isTrackerCompletedToday(_ trackerId: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            trackerRecord.trackerId == trackerId && Calendar.current.isDate(trackerRecord.date, inSameDayAs: currentDate)
        }
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? HeaderTrackersView else {
            assertionFailure("Error get view")
            return .init()
        }
        
        view.titleLabel.text = visibleCategories[indexPath.section].title
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPaths.isEmpty { return nil }
        let tracker = visibleCategories[indexPaths[0].section].trackers[indexPaths[0].row]
        let pinnedTitle = tracker.isPinned ? NSLocalizedString("TrackersViewController.collectionView.actionUnPin", comment: "") : NSLocalizedString("TrackersViewController.collectionView.actionPin", comment: "")
        
        return UIContextMenuConfiguration(actionProvider:  { _ in
            UIMenu(children: [
                UIAction(title: pinnedTitle) { [weak self] _ in
                    self?.togglePin(tracker: tracker)
                },
                UIAction(title: NSLocalizedString("TrackersViewController.collectionView.actionEdit", comment: "")) { [weak self] _ in
                    self?.editTracker(tracker: tracker)
                },
                UIAction(title: NSLocalizedString("TrackersViewController.collectionView.actionDelete", comment: ""), attributes: .destructive) { [weak self] _ in
                    self?.deleteTracker(tracker: tracker)
                }
            ])
        })
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellCols = Double(2)
            let cellMargins = 16.0
            let sideMargins = 16.0
            let width = (collectionView.frame.width - cellMargins - 2 * sideMargins) / cellCols
            return CGSize(width: width, height: 148)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 9
        }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func changeTrackerComplite(trackerId: UUID, indexPath: IndexPath) {
        if currentDate > Date() {
            showDateAlert()
            return
        }
        if isTrackerCompletedToday(trackerId) {
            guard let indexToRemove = completedTrackers.firstIndex(where: {$0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: currentDate)}) else { return }
            try? trackerRecordStore.remove(completedTrackers[indexToRemove])
            completedTrackers.remove(at: indexToRemove)
        } else {
            let trackerRecord = TrackerRecord(trackerId: trackerId, date: currentDate)
            try? trackerRecordStore.add(trackerRecord)
            completedTrackers.insert(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    private func showDateAlert() {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("TrackersViewController.dateAlert.message", comment: ""),
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: NSLocalizedString("TrackersViewController.dateAlert.button", comment: ""), style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension TrackersViewController: NewTrackerTypeSelectViewControllerDelegate, EditTrackerViewControllerDelegate {
    func reloadCategory() {
        categories = trackerCategoryStore.categories
        updateVisibleCategories()
    }
    
    func saveTracker(_ trackerCategory: TrackerCategory) {
        try? trackerStore.deleteTracker(tracker: trackerCategory.trackers[0])
        try? trackerCategoryStore.saveTracker(tracker: trackerCategory.trackers[0], to: trackerCategory.title)
        categories = trackerCategoryStore.categories
        updateVisibleCategories()
    }
}



