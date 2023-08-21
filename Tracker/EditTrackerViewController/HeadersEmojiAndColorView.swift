//
//  HeadersView.swift
//  Tracker
//
//  Created by Алексей Тиньков on 20.08.2023.
//

import UIKit

final class HeadersEmojiAndColorView: UICollectionReusableView {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font =  UIFont.boldSystemFont(ofSize: 19)
        titleLabel.textColor = .ypBlack
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
