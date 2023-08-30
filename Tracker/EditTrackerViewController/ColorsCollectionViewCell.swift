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
        layer.cornerRadius = 8
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
        layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 3 : 0
        }
    }
    
}
