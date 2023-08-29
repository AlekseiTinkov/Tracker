//
//  EmojiAndColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Алексей Тиньков on 20.08.2023.
//

import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell {
    weak var delegate: EditTrackerViewControllerDelegate?
    
    private var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 8
        return colorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupColorView()
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
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
        layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
        layer.cornerRadius = 8
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 3 : 0
        }
    }
    
}
