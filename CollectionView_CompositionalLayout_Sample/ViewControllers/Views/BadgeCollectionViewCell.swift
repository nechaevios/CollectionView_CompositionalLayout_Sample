//
//  BadgeCollectionViewCell.swift
//  CollectionView_CompositionalLayout_Sample
//
//  Created by Nechaev Sergey  on 22.03.2022.
//

import UIKit

class BadgeCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "badgeReuseIdentifier"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override var frame: CGRect {
        didSet {
            configureBorder()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            configureBorder()
        }
    }
}

extension BadgeCollectionViewCell {
    
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .black
        backgroundColor = .green
        configureBorder()
    }
    
    func configureBorder() {
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
}
