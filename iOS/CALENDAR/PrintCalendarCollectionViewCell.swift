//
//  printCalendarCollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 15.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class printCalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDayDesc: UILabel!
    
    func setDisplayData(_ num:Int){
        lblDayDesc.text = String(num)
    }
    
    func setNull(){
         lblDayDesc.text = ""
    }
}
