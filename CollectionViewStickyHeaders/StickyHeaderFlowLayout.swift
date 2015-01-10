//
//  Created by Pete Callaway on 10/01/2015.
//  Copyright (c) 2015 Dative Studios. All rights reserved.
//

import UIKit


class StickyHeaderFlowLayout: UICollectionViewFlowLayout {


    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // Return true so we're asked for layout attributes as the content is scrolled
        return true
    }

    
    
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        // Get the layout attributes for a standard UICollectionViewFlowLayout
        var elementsLayoutAttributes = super.layoutAttributesForElementsInRect(rect) as? [UICollectionViewLayoutAttributes]
        if elementsLayoutAttributes == nil {
            return nil
        }
        
        
        // Define a struct we can use to store optional layout attributes in a dictionary
        struct HeaderAttributes {
            var layoutAttributes: UICollectionViewLayoutAttributes?
        }
        var visibleSectionHeaderLayoutAttributes = [Int : HeaderAttributes]()
        
        
        // Loop through the layout attributes we have
        for (index, layoutAttributes) in enumerate(elementsLayoutAttributes!) {
            let section = layoutAttributes.indexPath.section
            
            switch layoutAttributes.representedElementCategory {
            case .SupplementaryView:
                // If this is a set of layout attributes for a section header, replace them with modified attributes
                if layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader {
                    let newLayoutAttributes = layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: layoutAttributes.indexPath)
                    elementsLayoutAttributes![index] = newLayoutAttributes
                    
                    // Store the layout attributes in the dictionary so we know they've been dealt with
                    visibleSectionHeaderLayoutAttributes[section] = HeaderAttributes(layoutAttributes: newLayoutAttributes)
                }
                
            case .Cell:
                // Check if this is a cell for a section we've not dealt with yet
                if visibleSectionHeaderLayoutAttributes[section] == nil {
                    // Stored a struct for this cell's section so we can can fill it out later if needed
                    visibleSectionHeaderLayoutAttributes[section] = HeaderAttributes(layoutAttributes: nil)
                }
            
            case .DecorationView:
                break
            }
        }
        
        // Loop through the sections we've found
        for (section, headerAttributes) in visibleSectionHeaderLayoutAttributes {
            // If the header for this section hasn't been set up, do it now
            if headerAttributes.layoutAttributes == nil {
                let newAttributes = layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: section))
                elementsLayoutAttributes!.append(newAttributes)
            }
        }
        
        return elementsLayoutAttributes
    }
    
    
    
    
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        // Get the layout attributes for a standard flow layout
        let attributes = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
        
        // If this is a header, we should tweak it's attributes
        if elementKind == UICollectionElementKindSectionHeader {
            if let fullSectionFrame = frameForSection(indexPath.section) {
                let minimumY = max(collectionView!.contentOffset.y + collectionView!.contentInset.top, fullSectionFrame.origin.y)
                let maximumY = CGRectGetMaxY(fullSectionFrame) - headerReferenceSize.height - collectionView!.contentInset.bottom
                
                attributes.frame = CGRect(x: 0, y: min(minimumY, maximumY), width: collectionView!.bounds.size.width, height: headerReferenceSize.height)
                attributes.zIndex = 1
            }
        }
        
        return attributes
    }

    
    
    
    
    // MARK: Private helper methods
    
    private func frameForSection(section: Int) -> CGRect? {

        // Sanity check
        let numberOfItems = collectionView!.numberOfItemsInSection(section)
        if numberOfItems == 0 {
            return nil
        }
        
        // Get the index paths for the first and last cell in the section
        let firstIndexPath = NSIndexPath(forRow: 0, inSection: section)
        let lastIndexPath = numberOfItems == 0 ? firstIndexPath : NSIndexPath(forRow: numberOfItems - 1, inSection: section)
        
        // Work out the top of the first cell and bottom of the last cell
        var firstCellTop = layoutAttributesForItemAtIndexPath(firstIndexPath).frame.origin.y
        let lastCellBottom = CGRectGetMaxY(layoutAttributesForItemAtIndexPath(lastIndexPath).frame)
        
        // Build the frame for the section
        var frame = CGRectZero

        frame.size.width = collectionView!.bounds.size.width
        frame.origin.y = firstCellTop
        frame.size.height = lastCellBottom - firstCellTop

        // Increase the frame to allow space for the header
        frame.origin.y -= headerReferenceSize.height
        frame.size.height += headerReferenceSize.height
        
        // Increase the frame to allow space for an section insets
        frame.origin.y -= sectionInset.top
        frame.size.height += sectionInset.top
        
        frame.size.height += sectionInset.bottom
        
        return frame
    }

}
