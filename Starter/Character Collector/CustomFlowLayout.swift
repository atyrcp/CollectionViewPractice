//
//  CustomFlowLayout.swift
//  Character Collector
//
//  Created by alien on 2019/6/2.
//  Copyright © 2019 Razeware, LLC. All rights reserved.
//

import UIKit

class CustomHeaderViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var deltaY: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CustomHeaderViewLayoutAttributes
        copy.deltaY = self.deltaY
        
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attribute = object as? CustomHeaderViewLayoutAttributes {
            if attribute.deltaY == self.deltaY {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class CustomFlowLayout: UICollectionViewFlowLayout {
    let defaultAlpha: CGFloat = 0.5
    let defaultScale: CGFloat = 0.5
    var closestY: CGFloat = 0.0
    var didSetupCollectionview = false
    var maxStretch: CGFloat = 0.0
    
    override func prepare() {
        super.prepare()
        
        if !didSetupCollectionview {
            didSetupCollectionview.toggle()
            setupCollectionview()
        }
        
    }
    
    
    override class var layoutAttributesClass : AnyClass {
        return CustomHeaderViewLayoutAttributes.self
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let defaultAttributes = super.layoutAttributesForElements(in: rect) else {return nil}
        
        var resultAttributes = [UICollectionViewLayoutAttributes]()
        
        let offset = collectionView!.contentOffset
        
        for attribute in defaultAttributes {
            if attribute.representedElementKind != nil {
                let customHeaderAttributes = attribute as! CustomHeaderViewLayoutAttributes
                if offset.y < 0 {
                    let deltaY = abs(offset.y)
                    customHeaderAttributes.deltaY = deltaY
                    var frame = customHeaderAttributes.frame
                    frame.size.height = min(max(0, headerReferenceSize.height + deltaY), maxStretch)
//                    frame.size.height = max(0, headerReferenceSize.height + deltaY)
                    frame.origin.y = frame.minY - deltaY
                    customHeaderAttributes.frame = frame
                    resultAttributes.append(customHeaderAttributes)
                }
            } else {
                let copyAttribute = attribute.copy() as! UICollectionViewLayoutAttributes
                changeAttribute(for: copyAttribute)
                resultAttributes.append(copyAttribute)
            }
            
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
        
        attribute.alpha = alpha
//        attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        attribute.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attribute.zIndex = Int(alpha * 10)
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let layoutAttributes = layoutAttributesForElements(in: self.collectionView!.bounds)
        
        let center = collectionView!.bounds.size.height / 2
        let offset = proposedContentOffset.y + center
        
        let closestPoint = layoutAttributes?.sorted(by: { (firstElement, secondElement) -> Bool in
            if abs(firstElement.center.y - offset) < abs(secondElement.center.y - offset) {
                return true
            } else {
                return false
            }
        }).first
        closestY = closestPoint!.center.y
        let point = CGPoint(x: proposedContentOffset.x, y: closestPoint!.center.y - center)
        
        return point
    }
    
    func setupCollectionview() {
        let xInset = (collectionView!.bounds.width - self.itemSize.width) / 2
        let yInset = (collectionView!.bounds.height - self.itemSize.height) / 2
        
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
    }
}
