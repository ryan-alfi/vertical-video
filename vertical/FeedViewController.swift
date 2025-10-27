//
//  FeedViewController.swift
//  vertical
//
//  Created by Ari Fajrianda Alfi on 27/10/25.
//

import UIKit

class FeedViewController: UIViewController {

    // Define the section enum
    enum Section {
        case main
    }
    // Define the item struct
    struct Item: Hashable {
        let id: Int
        let title: String
    }
    
    // Create the collection view
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // Create the compositional layout
    private lazy var layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // 1. change the group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        // 2. change the group direction to scroll vertically
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        group.contentInsets = .init(top: 4, leading: 5, bottom: 5, trailing: 5)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    
    // Create the diffable data source
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item -> FeedCollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FeedCollectionViewCell else {
            return nil
        }
        let color: UIColor = indexPath.row % 2 == 0 ? .yellow : .blue
        cell.backgroundColor = color
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the collection view to the view controller's view
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        view.addSubview(collectionView)
        // Configure the collection view constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // Load the initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([Item(id: 1, title: "Item 1"), Item(id: 2, title: "Item 2"), Item(id: 3, title: "Item 3")])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension FeedViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    // TODO: have to check attribute frame
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the percentage of visible cells
        guard let collectionView = scrollView as? UICollectionView else {
            return
        }
        
        for cell in collectionView.visibleCells.compactMap({$0 as? FeedCollectionViewCell}) {
            let f = cell.frame
            let w = self.view.window!
            let rect = w.convert(f, from: cell.superview!)
            let inter = rect.intersection(w.bounds)
            let ratio = (inter.width * inter.height) / (f.width * f.height)
            let rep = (String(Int(ratio * 100)) + "%")
            
            cell.topLabel.text = rep
            cell.bottomLabel.text = rep
        }
    }
}
