//
//  NewTrackerTypeSelectViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 15.08.2023.
//

import UIKit

final class NewTrackerTypeSelectViewController: UIViewController {
    
    let titleLabel = UILabel()
    let buttonStackView = UIStackView()
    let habitButton = UIButton()
    let eventButton = UIButton()
    
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
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 49)
        ])
    }
    
    private func setupButtonStackView() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 16
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHabitButton() {
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(.ypWhite, for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habitButton.backgroundColor = .ypBlack
        habitButton.layer.cornerRadius = 16
        habitButton.clipsToBounds = true
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(habitButton)
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor),
            habitButton.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor),
        ])
    }
    
    private func setupEventButton() {
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.setTitleColor(.ypWhite, for: .normal)
        eventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        eventButton.backgroundColor = .ypBlack
        eventButton.layer.cornerRadius = 16
        eventButton.clipsToBounds = true
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(eventButton)
        NSLayoutConstraint.activate([
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor),
        ])
    }
}
