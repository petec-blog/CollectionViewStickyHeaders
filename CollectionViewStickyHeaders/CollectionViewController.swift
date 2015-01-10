//
//  Created by Pete Callaway on 10/01/2015.
//  Copyright (c) 2015 Dative Studios. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("TESTCELL", forIndexPath: indexPath) as UICollectionViewCell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "TESTHEADER", forIndexPath: indexPath) as HeaderView
            headerView.label?.text = "Section \(indexPath.section)"
            
            return headerView
        }
        else {
            assert(false, "Unsupported supplementary view kind")
            return UICollectionReusableView()
        }
    }
    
}

