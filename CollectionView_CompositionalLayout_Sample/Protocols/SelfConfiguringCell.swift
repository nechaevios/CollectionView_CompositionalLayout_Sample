//
//  SelfConfiguringCell.swift
//  CollectionView_CompositionalLayout_Sample
//
//  Created by Nechaev Sergey  on 23.03.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure(with intValue: Int)
}
