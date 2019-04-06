//
//  AlbumCellLayout.swift
//  DemoApp
//
//  Created by sumeet mourya on 03/04/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

protocol AlbumCellLayoutDelegate: class {
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat
}


class AlbumCellLayout: UICollectionViewLayout {
    
    //1. Pinterest Layout Delegate
    weak var delegate: AlbumCellLayoutDelegate!
    
    //2. Configurable properties
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 5
    fileprivate var titleTextPadding: CGFloat = 10

    //3. Array to keep a cache of attributes.
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    //4. Content height and size
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView, collectionView.numberOfItems(inSection: 0) != cache.count else {
            return
        }
        
        contentHeight = 0

        cache.removeAll()

        guard cache.isEmpty == true else {
            return
        }

        let columnWidth = (contentWidth) / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = CGFloat(170) + delegate.collectionView(collectionView: collectionView, heightForAnnotationAtIndexPath: IndexPath(item: item, section: 0), withWidth: (columnWidth - (cellPadding * (CGFloat(numberOfColumns + 1))) - (titleTextPadding * CGFloat(2))))
            let height = cellPadding * 2 + photoHeight + (titleTextPadding * CGFloat(2))
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
