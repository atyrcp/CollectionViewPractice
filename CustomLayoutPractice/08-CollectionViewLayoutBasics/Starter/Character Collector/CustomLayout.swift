//
//  CustomLayout.swift
//  Character Collector
//
//  Created by alien on 2019/6/5.
//  Copyright © 2019 Razeware, LLC. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewLayout {
    
    var numberOfColumns = 0
    var cache = [UICollectionViewLayoutAttributes]()
    var contentHeight: CGFloat = 0
    var cellHeight: CGFloat = 300
    var width: CGFloat {
        return collectionView!.bounds.width
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        if cache.isEmpty {
            let numberOfPadding = numberOfColumns - 1
            let padding: CGFloat = 10
            let columnWidth = (width - CGFloat(numberOfPadding) * padding) / CGFloat(numberOfColumns)
            
            
            var xOffset = [CGFloat]()
            for column in 0..<numberOfColumns {
                let offset = (columnWidth + padding) * CGFloat(column)
                xOffset.append(offset)
            }
            
            var yOffset = Array<CGFloat>.init(repeating: 0, count: numberOfColumns)
            
            var column = 0
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: cellHeight)
                
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attribute.frame = frame
                cache.append(attribute)
                
                contentHeight = max(frame.maxY, contentHeight)
                yOffset[column] = yOffset[column] + cellHeight + 10
                column = column >= numberOfColumns - 1 ? 0 : column + 1
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resultAttribute = [UICollectionViewLayoutAttributes]()
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                resultAttribute.append(attribute)
            }
        }
        return resultAttribute
    }
    
    
}
