//
//  MainCollectionViewCell.swift
//  CollectionView_CompositionalLayout_Sample
//
//  Created by Nechaev Sergey  on 23.03.2022.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "mainCollectionViewCell"
    
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


extension MainCollectionViewCell {
    
    private func configureUI() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        
//        tintColor = .white
        label.textColor = .white
        backgroundColor = .systemBlue
        
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
