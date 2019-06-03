//
//  CustomFlowLayout.swift
//  Character Collector
//
//  Created by alien on 2019/6/2.
//  Copyright © 2019 Razeware, LLC. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    let defaultAlpha: CGFloat = 0.5
    let defaultScale: CGFloat = 0.5
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let defaultAttributes = super.layoutAttributesForElements(in: rect) else {return nil}
        
        var resultAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in defaultAttributes {
            let copyAttribute = attribute.copy() as! UICollectionViewLayoutAttributes
            changeAttribute(for: copyAttribute)
            resultAttributes.append(copyAttribute)
        }
        
        return resultAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func changeAttribute(for attribute: UICollectionViewLayoutAttributes) {
        let collectionviewCenter = collectionView!.frame.size.height / 2
        let offset = collectionView!.contentOffset.y
        let currentCenter = attribute.center.y - offset
        
        let maxDis = self.itemSize.height + self.minimumLineSpacing
        let realDis = min(abs(currentCenter - collectionviewCenter), maxDis)
        
        let ratio = (maxDis - realDis) / maxDis
        let alpha = ratio * 0.5 + defaultAlpha
        let scale = ratio * 0.5 + defaultScale
        
        print(scale)
        
        attribute.alpha = alpha
//        attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        attribute.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attribute.zIndex = Int(alpha * 10)
    }
}
