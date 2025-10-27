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
    
    // Create the collection view
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TiktokStyleViewCell.self, forCellWithReuseIdentifier: TiktokStyleViewCell.reuseIdentifier)
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
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item -> TiktokStyleViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TiktokStyleViewCell.reuseIdentifier, for: indexPath) as? TiktokStyleViewCell else {
            return nil
        }
        cell.configure(with: item)
        
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
        if let url = Bundle.main.url(forResource: "dummy", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode(ItemList.self, from: data) {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections([.main])
            snapshot.appendItems(decoded.items)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

}

extension FeedViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TiktokStyleViewCell else { return }
        cell.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TiktokStyleViewCell else { return }
        cell.pause()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1
        let cells = collectionView.visibleCells
        // cell are empty no need to do anything
        // 2
        guard cells.isEmpty == false else {
            return
        }
        // 3
        guard let window = self.view.window else {
            return
        }
        // 4
        for cell in cells {
            // 5
            guard let tikTokcell = cell as? TiktokStyleViewCell else {
                continue
            }
            guard let superView = cell.superview else {
                continue
            }
            // 6
            let cellFrame = tikTokcell.frame
            let rect = window.convert(cellFrame, from: superView)
            // 7
            let inter = rect.intersection(window.bounds)
            // 8
            let ratio = (inter.width * inter.height) / (cellFrame.width * cellFrame.height) * 100
            // 9
            let rep = (String(Int(ratio)) + "%")
            //tikTokcell.titleLabel.text = rep
            tikTokcell.subtitleLabel.text = rep
            // 10
            if ratio > 80 {
                tikTokcell.play()
            } else {
                tikTokcell.pause()
            }
        }
    }
}
