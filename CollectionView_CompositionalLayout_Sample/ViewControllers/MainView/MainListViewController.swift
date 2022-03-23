//
//  MainListViewController.swift
//  CollectionView_CompositionalLayout_Sample
//
//  Created by Nechaev Sergey  on 23.03.2022.
//

import UIKit

final class MainListViewController: UIViewController {

    private enum Section {
        case main
    }
    
    private struct Model: Hashable {
        let title: String
        let controller: UIViewController
        
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Model>! = nil
    private var collectionView: UICollectionView! = nil
    
    private let modelItemsList = [
        Model(title: "List View", controller: ListViewController()),
        Model(title: "Grid View", controller: GridViewController()),
        Model(title: "Grid+Badges Diffable View", controller: GridWithBadgesViewController()),
        Model(title: "Two Columns View", controller: TwoColumnsViewController()),
        Model(title: "HScroll Diffable View", controller: HScrollSectionsViewController()),
        Model(title: "Advanced Sections Diffable View", controller: AdvancedSectionsViewController())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Main List"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        // Create Diffable Data Source and connect it to Collection View
        dataSource = UICollectionViewDiffableDataSource<Section, Model>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, model: Model) -> UICollectionViewCell? in
            
            // A constructor that passes the collection view as input and returns cell view as output
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as? ListCollectionViewCell else { fatalError("Cant create cell") }
            cell.label.text = model.title
            
            return cell
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.main])
        snapshot.appendItems(modelItemsList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension MainListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = modelItemsList[indexPath.item]
        let viewController = selectedItem.controller
        navigationController?.pushViewController(viewController, animated: true)
    }
}
