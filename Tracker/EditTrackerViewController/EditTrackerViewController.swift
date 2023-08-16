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
    private var schedule: [WeekDay] = []
    
    var trackerType: TrackerType = .event
    
    let titleLabel = UILabel()
    let nameField = UITextField()
    let tableView = UITableView()
    let cancelButton = UIButton()
    let saveButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite
    
        setupTitleLabel()
        setupNameField()
        setupTableView()
        setupCancelButton()
        setupSaveButton()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .ypBlack
        titleLabel.text = trackerType == .event ? "Новое нерегулярное событие" : "Новая привычка"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 14)
        ])
    }
    
    private func setupNameField() {
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
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .ypBackground
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.separatorColor = .ypGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let height = trackerType == .event ? 75 : 150
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(height - 1))
        ])
    }
    
    private func setupCancelButton() {
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.backgroundColor = .ypWhite
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupSaveButton() {
        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.ypWhite, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.backgroundColor = .ypGray
        saveButton.layer.cornerRadius = 16
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
        repaintSaveButton()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        dismiss(animated: true)
        let name = nameField.text ?? ""
        delegate?.saveTracker(TrackerCategory(title: categoriesName[0],
                                              trackers: [.init(trackerType: self.trackerType, name: name, color: .ypColorSelection18, emoji: "🌺", schedule: self.schedule)]))
    }
    
    private func repaintSaveButton() {
        let isSchedule = (schedule.count > 0) || (trackerType == .event)
        let isName = !(nameField.text?.isEmpty ?? true)
        if isSchedule && isName {
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
    func saveSchedule(_ schedule: [WeekDay]) {
        self.schedule = schedule
        tableView.reloadData()
        repaintSaveButton()
    }
}
