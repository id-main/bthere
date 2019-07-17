//
//  CellSettingssupplier.swift
//  BThere
//
//  Created by BThere on 2/9/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import Foundation
import UIKit


class CellSettingssupplier: UICollectionViewCell  {
    @IBOutlet weak var titluitem:UILabel!
    var rowDIfferent:Int = 0 //for payment whitch is grey
    @IBOutlet weak var rectangleVIEW:UIView!
override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func setDisplayDatax(_ text: String, isManager:Bool)
{
//    if cell.titluitem.text == "SYNC_CONTACTS_SETTING".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//    {
//        if Global.sharedInstance.employeesPermissionsArray.contains(1) == false && ismanager == false
//        {
//            cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color6
//            cell.isUserInteractionEnabled = false
//        }
//        else
//        {
//            cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color4
//            cell.isUserInteractionEnabled = true
//        }
//    }
    titluitem.text = text
    self.rectangleVIEW.backgroundColor = Colors.sharedInstance.color4
    self.isUserInteractionEnabled = true
    if isManager == false {

        if titluitem.text == "LANG".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
            self.rectangleVIEW.backgroundColor = Colors.sharedInstance.color4
            self.isUserInteractionEnabled = true
        } else {
            self.rectangleVIEW.backgroundColor = Colors.sharedInstance.color6
            self.isUserInteractionEnabled = false
        }

        if titluitem.text == "SYNC_CONTACTS_SETTING".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
            if Global.sharedInstance.employeesPermissionsArray.contains(4) {
                self.rectangleVIEW.backgroundColor = Colors.sharedInstance.color4
                self.isUserInteractionEnabled = true

            } else {
                self.rectangleVIEW.backgroundColor = Colors.sharedInstance.color6
                self.isUserInteractionEnabled = false
            }
        }
    } else {


        self.rectangleVIEW.backgroundColor = Colors.sharedInstance.color4
        self.isUserInteractionEnabled = true
    }


}
}
 //JMODE FOR LIVE NO EMPLOYEES 21.03.2019
////
////  CellSettingssupplier.swift
////  BThere
////
////  Created by BThere on 2/9/17.
////  Copyright © 2017 Webit. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
//class CellSettingssupplier: UICollectionViewCell  {
//    @IBOutlet weak var titluitem:UILabel!
//    var rowDIfferent:Int = 0 //for payment whitch is grey
//    @IBOutlet weak var rectangleVIEW:UIView!
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        self.contentView.frame = self.bounds;
//        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    }
//
//    func setDisplayDatax(_ text: String)
//    {
//        if rowDIfferent == 6 {
//            self.rectangleVIEW.backgroundColor = UIColor.lightGray
//        }
//        titluitem.text = text
//    }
//}
