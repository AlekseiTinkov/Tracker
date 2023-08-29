//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Алексей Тиньков on 30.08.2023.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    weak var delegate: EditTrackerViewControllerDelegate?
    
    private var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.boldSystemFont(ofSize: 32)
        return emojiLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupEmojiLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEmojiLabel() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    func configure(with emoji: String) {
        //colorView.backgroundColor = .clear
        layer.cornerRadius = 16
        emojiLabel.text = emoji
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.backgroundColor = isSelected ? UIColor.ypLightGray.cgColor : UIColor.clear.cgColor
        }
    }
    
}
