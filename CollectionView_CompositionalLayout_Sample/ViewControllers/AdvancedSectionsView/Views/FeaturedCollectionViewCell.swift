//
//  FeaturedCollectionViewCell.swift
//  CollectionView_CompositionalLayout_Sample
//
//  Created by Nechaev Sergey  on 23.03.2022.
//

import UIKit

final class FeaturedCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "featuredCollectionViewCell"
    
    private let label = UILabel()
    
    func configure(with intValue: Int) {
        label.text = String(intValue)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FeaturedCollectionViewCell {
    
    private func configureUI() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        
        label.textColor = .white
        backgroundColor = .purple
        
        layer.cornerRadius = layer.bounds.width / 2
        clipsToBounds = true
        
        contentView.addSubview(label)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset)
        ])
    }
}
