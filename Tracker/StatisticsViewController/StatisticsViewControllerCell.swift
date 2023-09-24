//
//  StatisticsViewControllerCell.swift
//  Tracker
//
//  Created by Алексей Тиньков on 23.09.2023.
//

import UIKit

final class StatisticViewControllerCell: UITableViewCell {
    
    private let gradientView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let labelView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34)
        label.textColor = .ypBlack
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .ypBlack
        return label
    }()
    
    private var gradientLayer: CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [
            UIColor.ypGradientColor0.cgColor,
            UIColor.ypGradientColor1.cgColor,
            UIColor.ypGradientColor2.cgColor,
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        return gradientLayer
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupGradientView()
        setupLabelView()
        setupValueLabel()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientView.layer.insertSublayer(gradientLayer , at: 0)
    }
    
    private func setupGradientView() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(gradientView)
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupLabelView() {
        labelView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.addSubview(labelView)
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 1),
            labelView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 1),
            labelView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -1),
            labelView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -1)
        ])
    }
    
    private func setupValueLabel() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 12),
            valueLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 12)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -12)
        ])
    }
    
    func config(title: String, value: String) {
        self.selectionStyle = .none
        titleLabel.text = title
        valueLabel.text = value
    }
}
