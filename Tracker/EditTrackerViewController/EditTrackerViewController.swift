//
//  EditTrackerViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 15.08.2023.
//

import UIKit

protocol EditTrackerViewControllerDelegate: AnyObject {
    func saveTracker()
}

final class EditTrackerViewController: UIViewController {
    
    weak var delegate: EditTrackerViewControllerDelegate?
    
    var trackerType: TrackerType?
    
    let titleLabel = UILabel()
    let nameField = UITextField()
    let cancelButton = UIButton()
    let saveButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite
    
        setupTitleLabel()
        setupNameField()
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
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 150)
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
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        dismiss(animated: true)
        delegate?.saveTracker()
    }
}
