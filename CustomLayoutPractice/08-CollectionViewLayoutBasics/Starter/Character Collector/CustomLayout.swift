//
//  CustomLayout.swift
//  Character Collector
//
//  Created by alien on 2019/6/5.
//  Copyright © 2019 Razeware, LLC. All rights reserved.
//

import UIKit

protocol CustomLayoutDelegate {
    func collectionView(_ collectionview: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
    func collectionView(_ collectionview: UICollectionView, heightForDescriptionLabelAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class CustomCollectionViewLayoutAttribute: UICollectionViewLayoutAttributes {
    var imageHeight: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CustomCollectionViewLayoutAttribute
        copy.imageHeight = self.imageHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attribute = object as? CustomCollectionViewLayoutAttribute {
            if attribute.imageHeight == self.imageHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class CustomLayout: UICollectionViewLayout {
    
    var numberOfColumns = 0
    var cache = [CustomCollectionViewLayoutAttribute]()
    var contentHeight: CGFloat = 0
    var cellHeight: CGFloat = 300
    var width: CGFloat {
        return collectionView!.bounds.width
    }
    var delegate: CustomLayoutDelegate!
    
    override class var layoutAttributesClass: AnyClass {
        return CustomCollectionViewLayoutAttribute.self
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
                
                let cellImageHeight = delegate.collectionView(collectionView!, heightForItemAtIndexPath: indexPath, withWidth: columnWidth)
                let cellLabelHeight = delegate.collectionView(collectionView!, heightForDescriptionLabelAtIndexPath: indexPath, withWidth: columnWidth)
                
                cellHeight = cellImageHeight + cellLabelHeight + padding
                
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: cellHeight)
                
                let attribute = CustomCollectionViewLayoutAttribute(forCellWith: indexPath)
                attribute.frame = frame
                attribute.imageHeight = cellImageHeight
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
