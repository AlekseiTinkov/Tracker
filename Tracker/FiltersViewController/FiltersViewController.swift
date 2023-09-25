//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 25.09.2023.
//

import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: Filters)
}

final class FiltersViewController: UIViewController {
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var selectedFilter: Filters
    
    let cellIdentifier = "cell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .ypBlack
        label.text = NSLocalizedString("FiltersViewController.title", comment: "")
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .ypWhite
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .ypGray
        tableView.register(FiltersCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
    
    init(selectedFilter: Filters) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupTitleLabel()
        setupTableView()
        
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
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Filters.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FiltersCell else {
            assertionFailure("Error get cell")
            return .init()
        }
        cell.configure(title: Filters.allCases[indexPath.row].title,
                       check: self.selectedFilter == Filters.allCases[indexPath.row]
        )
        
        if indexPath.row == Filters.allCases.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        cell.layer.maskedCorners = []
        if indexPath.row == 0 && Filters.allCases.count == 1 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == Filters.allCases.count - 1 {
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        
        return cell
    }
    
}

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFilter = Filters.allCases[indexPath.row]
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.delegate?.didSelectFilter(self.selectedFilter)
            self.dismiss(animated: true)
        }
    }
}

