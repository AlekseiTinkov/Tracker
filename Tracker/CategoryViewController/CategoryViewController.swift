//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 05.09.2023.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(_ title: String?)
    func reloadCategory()
}

final class CategoryViewController: UIViewController {
    
    weak var delegate: CategoryViewControllerDelegate?
    
    private var categoryViewModel: CategoryViewModel
    private var selectedRow: Int?
    
    let cellIdentifier = "cell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .ypBlack
        label.text = NSLocalizedString("CategoryViewController.titleLabel", comment: "")
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("CategoryViewController.addCategoryButton", comment: ""), for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var placeholderView: UIStackView = {
        let placeholderView = UIStackView()
        
        let label = UILabel()
        label.text = NSLocalizedString("CategoryViewController.placeholderLabel", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")?.withRenderingMode(.alwaysOriginal)
        
        let placeholderSubView: UIStackView = UIStackView()
        placeholderSubView.axis = .vertical
        placeholderSubView.spacing = 8
        placeholderSubView.alignment = .center
        placeholderSubView.addArrangedSubview(imageView)
        placeholderSubView.addArrangedSubview(label)
        
        placeholderView.axis = .horizontal
        placeholderView.alignment = .center
        placeholderView.addArrangedSubview(placeholderSubView)
        return placeholderView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .ypWhite
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .ypGray
        tableView.register(CategoryCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupTitleLabel()
        setupAddCategoryButton()
        setupTableView()
        setupPlaceholder()
        setupKeyboardDismiss()
        
        reloadPlaceholder()
        
        categoryViewModel.$selectedCategoryTitle.bind { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didSelectCategory(self.categoryViewModel.selectedCategoryTitle)
            self.tableView.reloadData()
            self.reloadPlaceholder()
        }
        
        categoryViewModel.$categories.bind { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.reloadCategory()
            self.tableView.reloadData()
            self.reloadPlaceholder()
        }
        
    }
    
    init(categoryViewModel: CategoryViewModel) {
        self.categoryViewModel = categoryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addCategoryButtonTapped() {
        let editCategoryViewController = EditCategoryViewController()
        editCategoryViewController.delegate = self
        present(editCategoryViewController, animated: true)
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
    
    private func reloadPlaceholder() {
        placeholderView.isHidden = !categoryViewModel.categories.isEmpty
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        ])
    }
    
    private func setupAddCategoryButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        NSLayoutConstraint.activate([
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupPlaceholder() {
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderView)
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryViewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryCell else {
            assertionFailure("Error get cell")
            return .init()
        }
        cell.configure(title: categoryViewModel.categories[indexPath.row].title,
                       check: categoryViewModel.selectedCategoryTitle == categoryViewModel.categories[indexPath.row].title
        )
        
        if indexPath.row == categoryViewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        cell.layer.maskedCorners = []
        if indexPath.row == 0 && categoryViewModel.categories.count == 1 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == categoryViewModel.categories.count - 1 {
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        
        return cell
    }
    
}

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow =  indexPath.row
        categoryViewModel.selectCategory(categoryViewModel.categories[indexPath.row].title)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let category = categoryViewModel.categories[indexPath.row]
        
        return UIContextMenuConfiguration(actionProvider:  { _ in
            UIMenu(children: [
                UIAction(title: NSLocalizedString("CategoryViewController.tableView.actionEdit", comment: "")) { [weak self] _ in
                    let editCategoryViewController = EditCategoryViewController()
                    editCategoryViewController.delegate = self
                    editCategoryViewController.oldCategoryTitle = category.title
                    self?.present(editCategoryViewController, animated: true)
                },
                UIAction(title: NSLocalizedString("CategoryViewController.tableView.actionDelete", comment: ""), attributes: .destructive) { [weak self] _ in
                    self?.categoryViewModel.deleteCategory(title: category.title)
                }
            ])
        })
    }
}

extension CategoryViewController: EditCategoryViewControllerDelegate {
    func addCategory(title: String) {
        categoryViewModel.addCategory(title: title)
    }
    
    func renameCategory(oldTitle: String, newTitle: String) {
        categoryViewModel.renameCategory(oldTitle: oldTitle, newTitle: newTitle)
    }
    
    
}

