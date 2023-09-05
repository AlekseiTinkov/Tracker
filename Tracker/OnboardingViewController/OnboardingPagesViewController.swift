//
//  File.swift
//  Tracker
//
//  Created by Алексей Тиньков on 05.09.2023.
//

import UIKit

let onboardingPagesTitle = ["Отслеживайте только\nто, что хотите",
                           "Даже если это\nне литры воды и йога"]

final class OnboardingPagesViewController: UIViewController {
    
    private (set) var pageIndex: Int
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "onboarding_\(pageIndex)")
        imageView.image = image
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = onboardingPagesTitle[pageIndex]
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    init(with pageIndex: Int) {
        self.pageIndex = pageIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupLabel()
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 26),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
