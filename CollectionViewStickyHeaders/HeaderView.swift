//
//  Created by Pete Callaway on 10/01/2015.
//  Copyright (c) 2015 Dative Studios. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {

    @IBOutlet weak var label: UILabel?
    
    
    class var reuseIdentifier: String {
        return "HeaderView"
    }
}
