//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 01.08.2023.
//

import UIKit

var categoriesName: [String] = ["Важное"]

final class TrackersViewController: UIViewController {
    
    private var categories: [TrackerCategory] = []
    private var filtredCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    
    private let datePicker = UIDatePicker()
    private let titleLabel = UILabel()
    private let searchField = UISearchTextField()
    private let placeholderView = UIStackView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite
        
        setupMoc()
        
        setupNavBar()
        setupTitile()
        setupSearchField()
        setupCollectionView()
        setupPlaceholder()
        
        updateFiltredCategories()
    }
    
    func setupMoc() {
        categories = [TrackerCategory.init(title: "Домашний уют",
                                           trackers: [Tracker.init(trackerType: .habit, name: "Поливать растения",
                                                                   color: .green,
                                                                   emoji: "❤️",
                                                                   schedule: [WeekDay.sunday])]),
                      TrackerCategory.init(title: "Радостные мелочи",
                                           trackers: [Tracker.init(trackerType: .habit, name: "Кошка заслонила камеру на созвоне",
                                                                                 color: .orange,
                                                                                 emoji: "😻",
                                                                                 schedule: [WeekDay.sunday, WeekDay.saturday]),
                                                      Tracker.init(trackerType: .habit, name: "Бабушка прислала открытку в вотсапе",
                                                                                 color: .red,
                                                                                            emoji: "🌺",
                                                                                            schedule: [WeekDay.sunday]),
                                                      Tracker.init(trackerType: .event, name: "Свидания в вапреле",
                                                                                            color: .blue,
                                                                                            emoji: "❤️",
                                                                                 schedule: [])
                                                         ])
        ]
    }
    
    @objc
    private func addTracker() {
        let newTrackerTypeSelectViewController = NewTrackerTypeSelectViewController()
        newTrackerTypeSelectViewController.delegate = self
        present(newTrackerTypeSelectViewController, animated: true)
    }
    
    @objc private func changeDatePicker() {
        currentDate = datePicker.date
        self.dismiss(animated: false)
        
        updateFiltredCategories()
    }
    
    private func updateFiltredCategories() {
        let filterWeekdey = Calendar.current.component(.weekday, from: currentDate)
        let filterText = (searchField.text ?? "").lowercased()
        
        filtredCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay.number == filterWeekdey
                } == true
                
                let textCondition = tracker.name.lowercased().contains(filterText) || filterText.isEmpty
                
                return (dateCondition || tracker.trackerType == .event) && textCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(title: category.title,
                                   trackers: trackers)
        }
        
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
        placeholderView.isHidden = !filtredCategories.isEmpty
    }
    
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            let imageButton = UIImage(named: "button_plus")?.withRenderingMode(.alwaysOriginal)
            let leftItem = UIBarButtonItem(image: imageButton, style: .plain, target: self, action: #selector(addTracker))
            navBar.topItem?.setLeftBarButton(leftItem, animated: false)
            
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "ru_RU")
            datePicker.calendar.firstWeekday = 2

            datePicker.addTarget(self, action: #selector(changeDatePicker), for: .valueChanged)
            
            let rightItem = UIBarButtonItem(customView: datePicker)
            navBar.topItem?.setRightBarButton(rightItem, animated: false)
        }
    }
    
    private func setupTitile() {
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSearchField() {
        searchField.placeholder = "Поиск"
        self.searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        searchField.delegate = self
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

        collectionView.dataSource = self
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collectionView.delegate = self
    }
    
    private func setupPlaceholder() {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center

        let imageView = UIImageView()
        imageView.image = UIImage(named: "TrackersPlaceholder")?.withRenderingMode(.alwaysOriginal)
        
        let placeholderSubView: UIStackView = UIStackView()
        placeholderSubView.axis = .vertical
        placeholderSubView.spacing = 8
        placeholderSubView.alignment = .center
        placeholderSubView.addArrangedSubview(imageView)
        placeholderSubView.addArrangedSubview(label)

        placeholderView.axis = .horizontal
        placeholderView.alignment = .center

        placeholderView.addArrangedSubview(placeholderSubView)

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
        textField.resignFirstResponder()
        updateFiltredCategories()
        return true
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filtredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackersCollectionViewCell
        
        cell.delegate = self
        
        let tracker = filtredCategories[indexPath.section].trackers[indexPath.row]
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
        return filtredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
        
        view.titleLabel.text = filtredCategories[indexPath.section].title
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
                        _ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 9 - 2 * 16) / 2
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
            completedTrackers.remove(at: indexToRemove)
        } else {
            let trackerRecord = TrackerRecord(trackerId: trackerId, date: currentDate)
            completedTrackers.insert(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    private func showDateAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "Это время еще не пришло...",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension TrackersViewController: NewTrackerTypeSelectViewControllerDelegate {
    func saveTracker(_ trackerCategory: TrackerCategory) {
        if let indexOfCategorie = categories.firstIndex(where: {$0.title == trackerCategory.title}) {
            let newCategirie = TrackerCategory(title: trackerCategory.title, trackers: categories[indexOfCategorie].trackers + trackerCategory.trackers)
            categories[indexOfCategorie] = newCategirie
        } else {
            categories.append(trackerCategory)
        }
        updateFiltredCategories()
    }
}



