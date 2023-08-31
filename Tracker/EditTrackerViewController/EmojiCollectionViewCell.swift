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
        emojiLabel.textAlignment = .center
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
        layer.cornerRadius = 16
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.heightAnchor.constraint(equalToConstant: 40),
            emojiLabel.widthAnchor.constraint(equalToConstant: 40),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.backgroundColor = isSelected ? UIColor.ypLightGray.cgColor : UIColor.clear.cgColor
        }
    }
    
}
