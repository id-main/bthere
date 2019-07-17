//
//  HoursCollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 16.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class HoursCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblHours: UILabel!
    
    func setDisplayData(_ str:String)
    {
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            lblHours.font = UIFont(name: lblHours.font.fontName, size: 14)
        }

        lblHours.text = str
    }
}
