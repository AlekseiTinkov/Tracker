//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Алексей Тиньков on 01.08.2023.
//

import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func plusButtonTapped(cell: TrackersCollectionViewCell)
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    let colorView = UIView()
    let nameLabel = UILabel()
    let emojiLabel = UILabel()
    let daysCountLabel = UILabel()
    let plusButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        contentView.addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//        ])
        
        setupColorView()
        setupNameLabel()
        setupEmojiLabel()
        setupPlusButton()
        setupDayCountLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupColorView() {
        colorView.layer.cornerRadius = 16
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -42)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupEmojiLabel() {
        emojiLabel.font = UIFont.systemFont(ofSize: 14)
        emojiLabel.backgroundColor = .init(white: 1, alpha: 0.3)
        emojiLabel.textAlignment = .center
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.clipsToBounds = true
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupPlusButton() {
        //plusButton.setTitle("+", for: .normal)
        plusButton.setImage(UIImage(named: "cell_plus"), for: .normal)
        plusButton.setTitleColor(.white, for: .normal)
        plusButton.layer.cornerRadius = 34 / 2
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(plusButton)
        NSLayoutConstraint.activate([
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func setupDayCountLabel() {
        daysCountLabel.textColor = .ypBlack
        daysCountLabel.font = UIFont.systemFont(ofSize: 12)
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(daysCountLabel)
        NSLayoutConstraint.activate([
            daysCountLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }
    
    @objc private func plusButtonTapped() {
        delegate?.plusButtonTapped(cell: self)
    }
}
