//
//  NewTrackerTypeSelectViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 15.08.2023.
//

import UIKit

protocol NewTrackerTypeSelectViewControllerDelegate: AnyObject {
    func saveTracker(_ trackerCategory: TrackerCategory)
}

final class NewTrackerTypeSelectViewController: UIViewController {
    
    weak var delegate: NewTrackerTypeSelectViewControllerDelegate?
    
    private let titleLabel = UILabel()
    private let buttonStackViewH = UIStackView()
    private let buttonStackViewV = UIStackView()
    private let habitButton = UIButton()
    private let eventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite
    
        setupTitleLabel()
        setupButtonStackView()
        setupHabitButton()
        setupEventButton()
    }
    
    private func setupTitleLabel()  {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .ypBlack
        titleLabel.text = "Создание трекера"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 14)
        ])
    }
    
    private func setupButtonStackView() {
        buttonStackViewH.axis = .horizontal
        buttonStackViewH.alignment = .center
        buttonStackViewH.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackViewH)
        NSLayoutConstraint.activate([
            buttonStackViewH.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            buttonStackViewH.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackViewH.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackViewH.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        buttonStackViewV.axis = .vertical
        buttonStackViewV.spacing = 16
        buttonStackViewH.addArrangedSubview(buttonStackViewV)
    }
    
    private func setupHabitButton() {
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(.ypWhite, for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habitButton.backgroundColor = .ypBlack
        habitButton.layer.cornerRadius = 16
        habitButton.clipsToBounds = true
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackViewV.addArrangedSubview(habitButton)
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
    }
    
    private func setupEventButton() {
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.setTitleColor(.ypWhite, for: .normal)
        eventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        eventButton.backgroundColor = .ypBlack
        eventButton.layer.cornerRadius = 16
        eventButton.clipsToBounds = true
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackViewV.addArrangedSubview(eventButton)
        NSLayoutConstraint.activate([
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
    }
    
    @objc private func habitButtonTapped() {
        let editTrackerViewController = EditTrackerViewController()
        editTrackerViewController.delegate = self
        editTrackerViewController.trackerType = .habit
        present(editTrackerViewController, animated: true)
    }
    
    @objc private func eventButtonTapped() {
        let editTrackerViewController = EditTrackerViewController()
        editTrackerViewController.delegate = self
        editTrackerViewController.trackerType = .event
        present(editTrackerViewController, animated: true)
    }
}

extension NewTrackerTypeSelectViewController: EditTrackerViewControllerDelegate {
    func saveTracker(_ trackerCategory: TrackerCategory) {
        dismiss(animated: true)
        delegate?.saveTracker(trackerCategory)
    }
}
