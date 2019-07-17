//
//  RowInListCollectionViewCell.swift
//  Bthere
//
//  Created by User on 23.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים:
class RowInListCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlet
    
//    @IBOutlet var lblDesc: UILabel!
//  @IBOutlet var lblServices: UILabel!
    @IBOutlet var lblHour: UILabel!
    
    //MARK: - Initial
    
    
    func setDisplayData(_ hourDesc:String,desc:String,services:String,_isHourPast: Bool, _isOcasionalCustomer: Bool,_fromSixMonthReport:Bool,_iscancel:Int,_isblocked:Bool,_isdayevent:Bool){
  var   newiscancel = 0
        print("ooo zzzz\(self.contentView.frame.size.width)")
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            lblHour.textAlignment = .right
        }
        lblHour.text = hourDesc  + "\n" + desc + " - " + services
        lblHour.numberOfLines = 2
        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 16)
        lblHour.textColor = UIColor.black
        if _isdayevent == true {
            lblHour.textColor = Colors.sharedInstance.greenforsyncedincalendar
            lblHour.alpha = 1
            return
        }
        
         if _fromSixMonthReport == false {
            if services == "BlockHours"  {
                lblHour.textColor = Colors.sharedInstance.redforblockinghours
                lblHour.alpha = 0.6
                return
            }
            if _isblocked == true {
                lblHour.textColor = Colors.sharedInstance.redlightforblocked
                lblHour.alpha = 1
                return
            }
            if _isHourPast == true {
            lblHour.font = labelFont
            lblHour.textColor = Colors.sharedInstance.color3
        } else {
            lblHour.font = labelFont
            lblHour.textColor = UIColor.black
        }
         } else {
            //red for canceled
          //  if _iscancel == 0 {
            newiscancel = _iscancel
             if newiscancel == 92 {
                lblHour.font = labelFont
                lblHour.textColor = UIColor.red
                lblHour.text = hourDesc  + "\n" + desc + " - " + services  + " |  " + "WAS_CANCELLED".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                lblHour.numberOfLines = 3
            } else {
                lblHour.font = labelFont
                lblHour.textColor = UIColor.black
            }
            
        }
    }
    
}
