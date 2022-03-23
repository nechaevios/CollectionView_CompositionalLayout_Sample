//
//  GridWithBadgesViewController.swift
//  CollectionView_CompositionalLayout_Sample
//
//  Created by Nechaev Sergey  on 22.03.2022.
//

import UIKit

class GridWithBadgesViewController: UIViewController {
    
    static let badgeElementKind = "badgeElementKind"
    enum Section {
        case main
    }
    
    // Diffable data source model items need to be hashable
    struct Model: Hashable {
        let title: String
        let badgeCount: Int
        
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Model>! = nil
    var collectionView: UICollectionView! = nil
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateDiffableView))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        navigationItem.title = "Grid Badges View"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = addBarButtonItem
        
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.reuseIdentifier)
        collectionView.register(BadgeCollectionViewCell.self, forSupplementaryViewOfKind: GridWithBadgesViewController.badgeElementKind, withReuseIdentifier: BadgeCollectionViewCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: GridWithBadgesViewController.badgeElementKind, containerAnchor: badgeAnchor)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // heightDimension uses fractionalWidth
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        // Create Diffable Data Source and connect it to Collection View
        dataSource = UICollectionViewDiffableDataSource<Section, Model>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, model: Model) -> UICollectionViewCell? in
            
            // A constructor that passes the collection view as input and returns cell view as output
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.reuseIdentifier, for: indexPath) as? GridCollectionViewCell else { fatalError("Cant create cell") }
            
            cell.label.text = model.title
            cell.backgroundColor = .systemBlue
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = {
            [weak self] (
                collectionView: UICollectionView,
                kind: String,
                indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let self = self, let model = self.dataSource.itemIdentifier(for: indexPath) else { return  nil }
            let hasBadgeCount = model.badgeCount > 0
            
            // Get a supplementary view of the desired kind.
            if let badgeView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BadgeCollectionViewCell.reuseIdentifier,
                for: indexPath) as? BadgeCollectionViewCell {
                
                // Set the badge count as its label (and hide the view if the badge count is zero).
                badgeView.label.text = "\(model.badgeCount)"
                badgeView.isHidden = !hasBadgeCount
                
                // Return the view.
                return badgeView
            } else {
                fatalError("Cannot create new supplementary")
            }
            
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.main])
        let models = (0..<100).map { Model(title: "\($0)", badgeCount: Int.random(in: 0..<3)) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func updateDiffableView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.main])
        let models = (0..<Int.random(in: 0..<100)).map { Model(title: "\($0)", badgeCount: Int.random(in: 0..<3)) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

