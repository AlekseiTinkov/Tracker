//
//  EditTrackerViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 15.08.2023.
//

import UIKit

protocol EditTrackerViewControllerDelegate: AnyObject {
    func saveTracker(_ trackerCategory: TrackerCategory)
}

final class EditTrackerViewController: UIViewController {
    
    weak var delegate: EditTrackerViewControllerDelegate?
    private var schedule: Set<WeekDay> = []
    
    var trackerType: TrackerType = .event
    var trackerName: String = ""
    var trackerEmojiIndex: Int?
    var trackerColorIndex: Int?
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .ypBlack
        titleLabel.text = self.trackerType == .event ? "Новое нерегулярное событие" : "Новая привычка"
        return titleLabel
    }()
    
    private lazy var nameField: UITextField = {
        let nameField = UITextField()
        nameField.delegate = self
        nameField.placeholder = "Введите название трекера"
        nameField.font = UIFont.systemFont(ofSize: 17)
        nameField.backgroundColor = .ypBackground
        nameField.layer.cornerRadius = 16
        let insertView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameField.leftView = insertView
        nameField.leftViewMode = .always
        nameField.rightView = insertView
        nameField.rightViewMode = .always
        nameField.clipsToBounds = true
        return nameField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .ypBackground
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.separatorColor = .ypGray
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.backgroundColor = .ypWhite
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.ypWhite, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.backgroundColor = .ypGray
        saveButton.layer.cornerRadius = 16
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return saveButton
    }()
    
    private lazy var emojiAndColorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.register(EmojiAndColorsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeadersEmojiAndColorView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        setupScrollView()
        setupTitleLabel()
        setupNameField()
        setupTableView()
        setupEmojiAndColorCollectionView()
        setupCancelButton()
        setupSaveButton()
        setupScrollViewContentSize()
        
        repaintSaveButton()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 1),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 1)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 14)
        ])
    }
    
    private func setupNameField() {
        nameField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(nameField)
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nameField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            nameField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tableView)
        let height = trackerType == .event ? 75 : 150
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            tableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(height - 1))
        ])
    }
    
    private func setupEmojiAndColorCollectionView() {
        emojiAndColorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(emojiAndColorCollectionView)
        NSLayoutConstraint.activate([
            emojiAndColorCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiAndColorCollectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            emojiAndColorCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            emojiAndColorCollectionView.heightAnchor.constraint(equalToConstant:  34 + 204 + 34 + 204)
        ])
    }
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func setupSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
    
    private func setupScrollViewContentSize() {
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            emojiAndColorCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        dismiss(animated: true)
        guard let trackerColorIndex = self.trackerColorIndex else { return }
        guard let trackerEmojiIndex = self.trackerEmojiIndex else { return }
        self.trackerName = nameField.text ?? ""
        delegate?.saveTracker(TrackerCategory(title: categoriesName[0],
                                              trackers: [.init(name: self.trackerName, color: colorsCollection[trackerColorIndex], emoji: emojisCollection[trackerEmojiIndex], schedule: self.schedule)]))
    }
    
    private func repaintSaveButton() {
        let isSchedule = (schedule.count > 0) || (trackerType == .event)
        let isName = !(nameField.text?.isEmpty ?? true)
        let isColor = trackerColorIndex != nil
        let isEmoji = trackerEmojiIndex != nil
        if isSchedule && isName && isColor && isEmoji {
            saveButton.backgroundColor = .ypBlack
            saveButton.isEnabled = true
        } else {
            saveButton.backgroundColor = .ypGray
            saveButton.isEnabled = false
        }
    }
}

extension EditTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerType == .event ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = .ypGray
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = categoriesName[0]
        case 1:
            cell.textLabel?.text = "Расписание"
            cell.detailTextLabel?.text = getScheduleString()
        default:
            break
        }
        return cell
    }
    
    private func getScheduleString() -> String {
        if schedule.count == WeekDay.allCases.count { return "Каждый день" }
        var string = ""
        schedule.sorted().forEach { day in
            if !string.isEmpty {string.append(", ")}
            string.append(day.shortName)
        }
        return string
    }
}

extension EditTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            let schedulerViewController = SchedulerViewController()
            schedulerViewController.delegate = self
            schedulerViewController.loadSchedule(schedule)
            present(schedulerViewController, animated: true)
            break
        default:
            break
        }
    }
}


extension EditTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        repaintSaveButton()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        repaintSaveButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        repaintSaveButton()
    }
}

extension EditTrackerViewController: SchedulerViewControllerDelegate {
    func saveSchedule(_ schedule: Set<WeekDay>) {
        self.schedule = schedule
        tableView.reloadData()
        repaintSaveButton()
    }
}

extension EditTrackerViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeadersEmojiAndColorView
        
        view.titleLabel.text = indexPath.section == 0 ? "Emoji" : "Цвет"
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            trackerEmojiIndex = indexPath.row
        } else {
            trackerColorIndex = indexPath.row
        }
        repaintSaveButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: false) })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.width - 5 * 5 - 2 * 18) / 6
            return CGSize(width: width, height: 52)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
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
        0
    }
}

extension EditTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmojiAndColorsCollectionViewCell
        cell.configure(section: indexPath.section, row: indexPath.row)
        return cell
    }

}


