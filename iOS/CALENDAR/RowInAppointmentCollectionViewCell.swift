//
//  RowInAppointmentCollectionViewCell.swift
//  Bthere
//
//  Created by User on 25.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class RowInAppointmentCollectionViewCell: UICollectionViewCell {
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblHour: UILabel!
    var USERDict:NSDictionary = NSDictionary()
    
    func setDisplayData(_ hourDesc:String,desc:String,MYUSERDICT:NSDictionary){
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            lblDesc.textAlignment = .right
            lblHour.textAlignment = .right
        } else {
            lblDesc.textAlignment = .left
            lblHour.textAlignment = .left
        }
        self.USERDict = MYUSERDICT
        lblDesc.text = desc
        lblHour.text = hourDesc
    }

}
