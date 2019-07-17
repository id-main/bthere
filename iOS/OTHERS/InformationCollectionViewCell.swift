//
//  InformationCollectionViewCell.swift
//  Bthere
//
//  Created by User on 22.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class InformationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var viewIcon: UIView!
    
    func setDisplayData(_ icon:String)  {
        imgIcon.image = UIImage(named: icon)
    }
}
