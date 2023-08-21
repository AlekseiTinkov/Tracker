//
//  EmojiAndColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Алексей Тиньков on 20.08.2023.
//

import UIKit

final class EmojiAndColorsCollectionViewCell: UICollectionViewCell {
    weak var delegate: EditTrackerViewControllerDelegate?
    
    private var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 8
        return colorView
    }()
    
    private var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.boldSystemFont(ofSize: 32)
        return emojiLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupColorView()
        setupEmojiLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupColorView() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
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
    
    func configure(section: Int, row: Int) {
        if section == 0 {
            colorView.backgroundColor = .clear
            layer.cornerRadius = 16
            emojiLabel.text = emojisCollection[row]
        } else {
            colorView.backgroundColor = colorsCollection[row]
            layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
            layer.cornerRadius = 8
            emojiLabel.text = nil
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.emojiLabel.text != nil {
                self.layer.backgroundColor = isSelected ? UIColor.ypLightGray.cgColor : UIColor.clear.cgColor
            } else {
                self.layer.borderWidth = isSelected ? 3 : 0
            }
        }
    }
    
}
