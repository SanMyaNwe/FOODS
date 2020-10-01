//
//  DynamicLayout.swift
//  Foods
//
//  Created by Riki on 9/30/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

protocol DynamicLayoutDelegate {
    func collecionView(collecionView: UICollectionView, photoHeightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat
}

class DynamicLayout: UICollectionViewLayout {
    
    // properties
    
    var delegate: DynamicLayoutDelegate?
    
    var preparedAttribures: [DynamicLayoutAttributes] = []
    var contentHeight: CGFloat = 0
    var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return (collectionView!.frame.width - (insets.left + insets.right))
    }
    
    // calculate attributes for all items
    override func prepare() {
        
        guard let collectionView = collectionView else { return }
        
        let screenSize: CGSize = UIScreen.main.bounds.size
        let cellPadding: CGFloat = 24
        let numberOfItems: CGFloat = 2
        
        let totalPadding: CGFloat = cellPadding * (numberOfItems + 1)
        let itemWidth: CGFloat = (screenSize.width - totalPadding) / numberOfItems
        var itemHeight: CGFloat = 0
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        var xOffsets: [CGFloat] = [CGFloat](repeating: 0, count: Int(numberOfItems))
        var yOffsets: [CGFloat] = [CGFloat](repeating: 0, count: Int(numberOfItems))
        
        for column in 0..<Int(numberOfItems) {
            xOffsets[column] = cellPadding + (itemWidth + cellPadding) * CGFloat(column)
        }
        
        var column = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            // calculate frame for current item
            let photoHeight = delegate!.collecionView(collecionView: collectionView, photoHeightForItemAt: indexPath, width: itemWidth)
            
            itemHeight = photoHeight
            
            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: itemWidth, height: itemHeight)
            let attributes = DynamicLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            attributes.photoHeight = photoHeight
            preparedAttribures.append(attributes)
            
            // update yOffset for next item
            contentHeight = max(contentHeight, frame.maxY)
            yOffsets[column] += itemHeight + cellPadding
            
            if Int(numberOfItems - 1) == column  {
                column = 0
            } else {
                column += 1
            }
            
        }
    }
    
    // return all calculated attributes for all items
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = [DynamicLayoutAttributes]()
        
        for attribute in preparedAttribures {
            if attribute.frame.intersects(rect) {
                attributes.append(attribute)
            }
        }
        return attributes
    }
    
    // return content size for collection view
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
}

class DynamicLayoutAttributes: UICollectionViewLayoutAttributes {
    var photoHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! DynamicLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? DynamicLayoutAttributes {
            if attributes.photoHeight == photoHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}
