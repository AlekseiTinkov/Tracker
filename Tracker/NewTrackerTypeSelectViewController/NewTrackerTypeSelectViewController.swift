//
//  NewTrackerTypeSelectViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 15.08.2023.
//

import UIKit

protocol NewTrackerTypeSelectViewControllerDelegate: AnyObject {
    func saveTracker(_ trackerCategory: TrackerCategory)
    func reloadCategory()
}

final class NewTrackerTypeSelectViewController: UIViewController {
    
    weak var delegate: NewTrackerTypeSelectViewControllerDelegate?
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .ypBlack
        titleLabel.text = "Создание трекера"
        return titleLabel
    }()
    
    private var buttonStackViewH: UIStackView = {
        let buttonStackViewH = UIStackView()
        buttonStackViewH.axis = .horizontal
        buttonStackViewH.alignment = .center
        return buttonStackViewH
    }()
    private var buttonStackViewV: UIStackView = {
        let buttonStackViewV = UIStackView()
        buttonStackViewV.axis = .vertical
        buttonStackViewV.spacing = 16
        return buttonStackViewV
    }()
    
    private lazy var habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(.ypWhite, for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habitButton.backgroundColor = .ypBlack
        habitButton.layer.cornerRadius = 16
        habitButton.clipsToBounds = true
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return habitButton
    }()
    
    private lazy var eventButton: UIButton = {
        let eventButton = UIButton()
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.setTitleColor(.ypWhite, for: .normal)
        eventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        eventButton.backgroundColor = .ypBlack
        eventButton.layer.cornerRadius = 16
        eventButton.clipsToBounds = true
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
        return eventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        setupTitleLabel()
        setupButtonStackView()
        setupHabitButton()
        setupEventButton()
    }
    
    private func setupTitleLabel()  {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 14)
        ])
    }
    
    private func setupButtonStackView() {
        buttonStackViewH.translatesAutoresizingMaskIntoConstraints = false
        buttonStackViewH.addArrangedSubview(buttonStackViewV)
        view.addSubview(buttonStackViewH)
        NSLayoutConstraint.activate([
            buttonStackViewH.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            buttonStackViewH.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackViewH.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackViewH.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHabitButton() {
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackViewV.addArrangedSubview(habitButton)
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupEventButton() {
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackViewV.addArrangedSubview(eventButton)
        NSLayoutConstraint.activate([
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
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
    func reloadCategory() {
        delegate?.reloadCategory()
    }
    
    func saveTracker(_ trackerCategory: TrackerCategory) {
        dismiss(animated: true)
        delegate?.saveTracker(trackerCategory)
    }
}
