//
//  Created by Pete Callaway on 10/01/2015.
//  Copyright (c) 2015 Dative Studios. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "TESTCELL", for: indexPath) as UICollectionViewCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TESTHEADER", for: indexPath) as! HeaderView
            headerView.label?.text = "Section \(indexPath.section)"
            
            return headerView
        }
        else {
            assert(false, "Unsupported supplementary view kind")
            return UICollectionReusableView()
        }
    }
    
}

