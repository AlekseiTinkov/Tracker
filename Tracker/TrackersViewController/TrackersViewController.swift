//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 01.08.2023.
//

import UIKit

enum WeekDay: Int {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
}

struct Tracker {
    let trackerId = UUID()
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDay>?
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

struct TrackerRecord: Hashable {
    let trackerId: UUID
    let date: Date
}

final class TrackersViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    private let datePicker = UIDatePicker()
    private let titleLabel = UILabel()
    private let searchField = UISearchTextField()
    private let placeholderView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupMoc()
        
        setupNavBar()
        setupTitile()
        setupSearchField()
        setupCollectionView()
        //setupTrackersPlaceholder()
    }
    
    func setupMoc() {
        categories = [TrackerCategory.init(title: "Домашний уют",
                                           trackers: [Tracker.init(name: "Поливать растения",
                                                                   color: .green,
                                                                   emoji: "❤️",
                                                                   schedule: [WeekDay.sunday])]),
                      TrackerCategory.init(title: "Радостные мелочи",
                                                         trackers: [Tracker.init(name: "Кошка заслонила камеру на созвоне",
                                                                                 color: .orange,
                                                                                 emoji: "😻",
                                                                                 schedule: [WeekDay.sunday]),
                                                                    Tracker.init(name: "бабушка прислала открытку в вотсапе",
                                                                                 color: .red,
                                                                                            emoji: "🌺",
                                                                                            schedule: [WeekDay.sunday]),
                                                                    Tracker.init(name: "Свидания в вапреле",
                                                                                            color: .blue,
                                                                                            emoji: "❤️",
                                                                                            schedule: [WeekDay.sunday])
                                                         ])
        ]
    }
    
    @objc
    private func addTracker() {
        print(">>>")
    }
    
    @objc private func changeDatePicker() {
        print(">>> \(currentDate)")
        currentDate = datePicker.date
        print(">>> \(currentDate)")
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
    
    private func setupTrackersPlaceholder() {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center

        let imageView = UIImageView()
        imageView.image = UIImage(named: "TrackersPlaceholder")?.withRenderingMode(.alwaysOriginal)
        
        let placeholderSubView: UIStackView = UIStackView()
        placeholderSubView.axis = .vertical
        placeholderSubView.spacing = 0
        placeholderSubView.alignment = .center
        placeholderSubView.addArrangedSubview(imageView)
        placeholderSubView.addArrangedSubview(label)

        placeholderView.axis = .horizontal
        placeholderView.spacing = 8
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
        
        placeholderSubView.alpha = 1
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackersCollectionViewCell
        
        cell.delegate = self
        
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        cell.nameLabel.text = tracker.name
        cell.colorView.backgroundColor = tracker.color
        cell.plusButton.backgroundColor = tracker.color
        cell.emojiLabel.text = tracker.emoji
        let daysCount = completedTrackers.filter{$0.trackerId == tracker.trackerId}.count
        let daysText = getDaysText(daysCount)
        cell.daysCountLabel.text = "\(daysCount) \(daysText)"
        return cell
    }
}

func getDaysText(_ daysCount: Int) -> String {
    var text: String
    switch daysCount % 10 {
    case 0:
        text = "дней"
    case 1:
        text = "день"
    case 2,3,4:
        text = "дня"
    default:
        text = "дней"
    }
    
    if (11...14).contains(daysCount % 100) {
        text = "дней"
    }
    
    return text
}

extension TrackersViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
        
        view.titleLabel.text = categories[indexPath.section].title
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
    func plusButtonTapped(cell: TrackersCollectionViewCell) {
        print(">>><<<")
    }
}



