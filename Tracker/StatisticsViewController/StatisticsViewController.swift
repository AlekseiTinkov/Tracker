//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 01.08.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    let cellIdentifier = "cell"
    
    let titles = [NSLocalizedString("StatisticsViewController.title0", comment: ""),
                  NSLocalizedString("StatisticsViewController.title1", comment: ""),
                  NSLocalizedString("StatisticsViewController.title2", comment: ""),
                  NSLocalizedString("StatisticsViewController.title3", comment: "")]
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("StatisticsViewController.titleLabel", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 34.0)
        label.textColor = .ypBlack
        return label
    }()
    
    private var placeholderView: UIStackView = {
        let placeholderView = UIStackView()
        
        let label = UILabel()
        label.text = NSLocalizedString("StatisticsViewController.placeholderLabel", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_statistic")?.withRenderingMode(.alwaysOriginal)
        
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
        tableView.register(StatisticViewControllerCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        setupTitleLabel()
        setupPlaceholderView()
        setupTableView()
        
        placeholderView.isHidden = true
    }

    
    private func setupTitleLabel() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupPlaceholderView() {
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderView)
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 53),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 53),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

extension StatisticsViewController: UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        102
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StatisticViewControllerCell else { return UITableViewCell() }
        cell.config(title: titles[indexPath.row], value: "valueLabel")
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

