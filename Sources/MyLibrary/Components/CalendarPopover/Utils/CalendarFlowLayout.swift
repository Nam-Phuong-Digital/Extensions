//
//  File.swift
//  
//
//  Created by Dai Pham on 04/02/2024.
//

import UIKit

public class CalendarFlowLayout: UICollectionViewFlowLayout {

    private let cellHeight: CGFloat = 50.0
    
    /// - Tag: ColumnFlowExample
    public override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        
        self.sectionInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 0.0, right: 10.0)
        self.sectionInsetReference = .fromSafeArea
        self.scrollDirection = .vertical
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let cellWidth = (availableWidth / CGFloat(7)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
    }
}

@available (iOS 13,*)
public extension UICollectionViewLayout {
    class func createLayout(
        columns: Int
    ) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            
            let groupSize:NSCollectionLayoutSize
            
            let item = NSCollectionLayoutItem(layoutSize: itemsize)
            
            let group: NSCollectionLayoutGroup
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(50))

            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitem: item,count: columns)
            group.interItemSpacing = .fixed(1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.interGroupSpacing = 0
            section.orthogonalScrollingBehavior = .groupPaging
            if #available(iOS 14.0, *) {
                section.contentInsetsReference = .none
            }
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        config.scrollDirection = .horizontal
        layout.configuration = config
        return layout
    }
}
