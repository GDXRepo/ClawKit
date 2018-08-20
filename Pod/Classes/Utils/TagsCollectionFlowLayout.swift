//
//  PinNumberPadFlowLayout.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 13.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

public final class PinNumberPadFlowLayout: UICollectionViewFlowLayout {
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.map { $0.representedElementKind == nil ? layoutAttributesForItem(at: $0.indexPath)! : $0 }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes,
            let collectionView = self.collectionView else {
                // should never happen
                return nil
        }
        let sectionInset = evaluatedSectionInsetForSection(at: indexPath.section)
        guard indexPath.item != 0 else {
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        guard let previousFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))?.frame else {
            // should never happen
            return nil
        }
        // if the current frame, once left aligned to the left and stretched to the full collection view
        // width intersects the previous frame then they are on the same line
        guard previousFrame.intersects(CGRect(x: sectionInset.left, y: currentItemAttributes.frame.origin.y, width: collectionView.frame.width - sectionInset.left - sectionInset.right, height: currentItemAttributes.frame.size.height)) else {
            // make sure the first item on a line is left aligned
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        currentItemAttributes.frame.origin.x = previousFrame.origin.x + previousFrame.size.width + evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
        return currentItemAttributes
    }
    
    public func evaluatedMinimumInteritemSpacingForSection(at section: NSInteger) -> CGFloat {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
    public func evaluatedSectionInsetForSection(at index: NSInteger) -> UIEdgeInsets {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, insetForSectionAt: index) ?? sectionInset
    }
    
}

public extension UICollectionViewLayoutAttributes {
    
    public func leftAlignFrame(withSectionInset sectionInset: UIEdgeInsets) {
        frame.origin.x = sectionInset.left
    }
    
}
