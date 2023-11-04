//
//  FiltersCell.swift
//  Tracker
//
//  Created by Алексей Тиньков on 25.09.2023.
//

import UIKit

final class FiltersCell: UITableViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private var checkMarkImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkmark"))
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .ypBackground
        self.selectionStyle = .none
        
        setupTitleLabel()
        setupSelectImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        ])
    }
    
    private func setupSelectImageView() {
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkMarkImageView)
        NSLayoutConstraint.activate([
            checkMarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkMarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func configure(title : String, check : Bool) {
        titleLabel.text = title
        checkMarkImageView.isHidden = !check
    }
    
}
