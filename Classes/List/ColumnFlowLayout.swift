//
//  ColumnFlowLayout.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 14/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    private let minColumnWidth: CGFloat = 300.0
    private let cellHeight: CGFloat = 70.0
    
    // MARK: Layout Overrides
    
    /// - Tag: ColumnFlowExample
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        sectionInsetReference = .fromSafeArea
    }
}
