//
//  EmojiAndColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Алексей Тиньков on 20.08.2023.
//

import UIKit

final class EmojiAndColorsCollectionViewCell: UICollectionViewCell {
    weak var delegate: EditTrackerViewControllerDelegate?
    
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                                   "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                                   "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private var colors: [UIColor] = {
        var colors: [UIColor] = []
        for i in 1...18 {
            colors.append(UIColor(named: "YP Color selection \(i)") ?? .clear)
        }
        return colors
    }()
    
    private var isCompletedToday: Bool = false
    private var trackerId: UUID = UUID()
    private var indexPath: IndexPath = IndexPath()
    
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
    
//    override var isSelected: Bool {
//        didSet{
//            if indexPath.section == 0 {
//                if self.isSelected {
//                    self.colorView.backgroundColor = .ypLightGray
//                }
//                else {
//                    self.colorView.backgroundColor = .clear
//                }
//            } else {
//
//            }
//        }
//    }
    
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
    
    func configure(section: Int, row: Int, selected: Bool) {
        if section == 0 {
            colorView.backgroundColor = .clear
            emojiLabel.text = emoji[row]
            layer.cornerRadius = 16
            self.layer.backgroundColor = selected ? UIColor.ypLightGray.cgColor : UIColor.clear.cgColor
        } else {
            colorView.backgroundColor = colors[row]
            emojiLabel.text = nil
            layer.cornerRadius = 8
            self.layer.borderColor = self.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
            self.layer.borderWidth = selected ? 3 : 0
        }
    }
    
    func selected(_ selected: Bool) {
        self.layer.borderColor = self.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = selected ? 3 : 0
    }
    
}
