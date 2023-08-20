//
//  SchedulerViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 16.08.2023.
//

import UIKit

protocol SchedulerViewControllerDelegate: AnyObject {
    func saveSchedule(_ schedule: Set<WeekDay>)
}

final class SchedulerViewController: UIViewController {
    
    weak var delegate: SchedulerViewControllerDelegate?
    private var schedule: Set<WeekDay> = []
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = "Расписание"
        titleLabel.textColor = .ypBlack
        return titleLabel
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("Готово", for: .normal)
        saveButton.setTitleColor(.ypWhite, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.backgroundColor = .ypBlack
        saveButton.layer.cornerRadius = 16
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return saveButton
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .ypGray
        tableView.backgroundColor = .ypWhite
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        setupTitleLabel()
        setupTableView()
        setupSaveButton()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 14)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 524),
        ])
    }
    
    private func setupSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func saveButtonTapped() {
        self.delegate?.saveSchedule(self.schedule)
        dismiss(animated: true)
    }
    
    func loadSchedule(_ schedule: Set<WeekDay>) {
        self.schedule = schedule
    }
    
}

extension SchedulerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let swicher = UISwitch()
        swicher.onTintColor = .ypBlue
        swicher.tag = indexPath.row
        swicher.isOn = schedule.firstIndex(of: WeekDay.allCases[indexPath.row]) != nil
        swicher.addTarget(self, action: #selector(swichTaped), for: .valueChanged)
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBackground
        cell.textLabel?.text = WeekDay.allCases[indexPath.row].name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.accessoryView = swicher
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    @objc private func swichTaped(_ sender: UISwitch) {
        if sender.isOn {
            schedule.insert(WeekDay.allCases[sender.tag])
        } else {
            guard let index = schedule.firstIndex(of: WeekDay.allCases[sender.tag]) else { return }
            schedule.remove(at: index)
        }
    }
    
}

