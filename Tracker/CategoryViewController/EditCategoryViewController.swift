//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 07.09.2023.
//

import UIKit

protocol EditCategoryViewControllerDelegate: AnyObject {
    func addCategory(title: String)
    func renameCategory(oldTitle: String, newTitle: String)
}

final class EditCategoryViewController: UIViewController {
    
    weak var delegate: EditCategoryViewControllerDelegate?
    var oldCategoryTitle: String? {
        didSet {
            repaintSaveButton()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .ypBlack
        label.text = oldCategoryTitle == nil ? NSLocalizedString("EditCategoryViewController.titleLabel.new", comment: "") : NSLocalizedString("EditCategoryViewController.titleLabel.edit", comment: "")
        return label
    }()
    
    private lazy var nameField: UITextField = {
        let nameField = UITextField()
        nameField.delegate = self
        nameField.placeholder = NSLocalizedString("EditCategoryViewController.nameField", comment: "")
        nameField.font = UIFont.systemFont(ofSize: 17)
        nameField.text = oldCategoryTitle
        nameField.backgroundColor = .ypBackground
        nameField.layer.cornerRadius = 16
        let insertView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameField.leftView = insertView
        nameField.leftViewMode = .always
        nameField.clipsToBounds = true
        nameField.clearButtonMode = .whileEditing
        return nameField
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle(NSLocalizedString("EditCategoryViewController.saveButton", comment: ""), for: .normal)
        saveButton.setTitleColor(.ypWhite, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.backgroundColor = .ypGray
        saveButton.layer.cornerRadius = 16
        saveButton.clipsToBounds = true
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return saveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupTitleLabel()
        setupNameField()
        setupSaveButton()
        setupKeyboardDismiss()
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
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        ])
    }
    
    private func setupNameField() {
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            nameField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
    }
    
    @objc private func saveButtonTapped() {
        guard let newTitle = nameField.text else { return }
        if oldCategoryTitle == nil {
            delegate?.addCategory(title: newTitle)
        } else {
            let oldTitle = oldCategoryTitle ?? ""
            delegate?.renameCategory(oldTitle: oldTitle, newTitle: newTitle)
        }
        dismiss(animated: true)
    }
    
    
    private func showSaveAlert() {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("EditCategoryViewController.saveAlert.message", comment: ""),
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: NSLocalizedString("EditCategoryViewController.saveAlert.button", comment: ""), style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func repaintSaveButton() {
        let isName = !(nameField.text?.isEmpty ?? true)
        if isName {
            saveButton.backgroundColor = .ypBlack
            saveButton.isEnabled = true
        } else {
            saveButton.backgroundColor = .ypGray
            saveButton.isEnabled = false
        }
    }
    
}

extension EditCategoryViewController: UITextFieldDelegate {
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
