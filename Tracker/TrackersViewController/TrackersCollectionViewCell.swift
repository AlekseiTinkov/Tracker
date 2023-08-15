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
    
    let colorView = UIView()
    let nameLabel = UILabel()
    let emojiLabel = UILabel()
    let daysCountLabel = UILabel()
    let button = UIButton()
    
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
    
    private func setupButton() {
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 34 / 2
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
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
        daysCountLabel.textColor = .ypBlack
        daysCountLabel.font = UIFont.systemFont(ofSize: 12)
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
        daysCountLabel.text = "\(completedDays) \(getDaysText(completedDays))"
    }
    
    private func getDaysText(_ daysCount: Int) -> String {
        var text: String
        switch daysCount % 10 {
        case 0:
            text = "дней"
        case 1:
            text = "день"
        case 2,3,4:
            text = "дня"
        default:
            text = "дней"
        }
        
        if (11...14).contains(daysCount % 100) {
            text = "дней"
        }
        
        return text
    }
    
    @objc private func plusButtonTapped() {
        delegate?.changeTrackerComplite(trackerId: trackerId, indexPath: self.indexPath)
    }
}
