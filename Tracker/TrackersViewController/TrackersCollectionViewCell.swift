//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Алексей Тиньков on 01.08.2023.
//

import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func changeTrackerComplite(trackerId: UUID, indexPath: IndexPath)
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    private var isCompletedToday: Bool = false
    private var trackerId: UUID = UUID()
    private var indexPath: IndexPath = IndexPath()
    
    private var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 16
        return colorView
    }()
    
    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.numberOfLines = 2
        return nameLabel
    }()
    
    private var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 14)
        emojiLabel.backgroundColor = .init(white: 1, alpha: 0.3)
        emojiLabel.textAlignment = .center
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.clipsToBounds = true
        return emojiLabel
    }()
    
    private var daysCountLabel: UILabel = {
        let daysCountLabel = UILabel()
        daysCountLabel.textColor = .ypBlack
        daysCountLabel.font = UIFont.systemFont(ofSize: 12)
        return daysCountLabel
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 34 / 2
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupColorView()
        setupNameLabel()
        setupEmojiLabel()
        setupButton()
        setupDayCountLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupColorView() {
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
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupEmojiLabel() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            button.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            button.heightAnchor.constraint(equalToConstant: 34),
            button.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func setupDayCountLabel() {
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(daysCountLabel)
        NSLayoutConstraint.activate([
            daysCountLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }
    
    func configure(tracker: Tracker, isCompletedToday: Bool, completedDays: Int, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.isCompletedToday = isCompletedToday
        self.trackerId = tracker.trackerId
        nameLabel.text = tracker.name
        colorView.backgroundColor = tracker.color
        button.backgroundColor = tracker.color.withAlphaComponent(isCompletedToday ? 0.3 : 1.0)
        button.setImage(UIImage(named: isCompletedToday ? "cell_done" : "cell_plus"), for: .normal)
        emojiLabel.text = tracker.emoji
        daysCountLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of remaining tasks"), completedDays)
    }
    
    @objc private func plusButtonTapped() {
        delegate?.changeTrackerComplite(trackerId: trackerId, indexPath: self.indexPath)
    }
}
