//
//  DaySupplierRowInListCollectionViewCell.swift
//  Bthere
//
//  Created by User on 23.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים:
class DaySupplierRowInListCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlet
    
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblServices: UILabel!
    @IBOutlet var lblHour: UILabel!
    @IBOutlet var lblPunctepuncte: UILabel!
    
    //MARK: - Initial
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            lblDesc.textAlignment = .right
            lblServices.textAlignment = .right
            lblHour.textAlignment = .right
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, UIEdgeInsets indexPath: IndexPath) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0,bottom: 0,right: 0);
    }
    func setDisplayData(_ hourDesc:String,desc:String,services:String,_isexpanded:Bool, _islastrow:Bool,_isBthereEvent: Bool, _isHourPast:Bool, _isBlocked:Bool,_isocassional:Bool){
        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 16)
        lblDesc.font = labelFont
        lblHour.font = labelFont
        lblDesc.textColor = UIColor.black
        lblHour.textColor = UIColor.black
        lblServices.textColor = UIColor.black
        lblServices.font = labelFont
        lblPunctepuncte.text = "..."
        print("lblDesc.font: \(lblDesc.font.pointSize)")
        print("lblHour.font: \(lblHour.font.pointSize)")
        print("lblServices.font: \(lblServices.font.pointSize)")
        if _isocassional == true {
            // Occasional customer
            lblDesc.text = "OCCASIONAL_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            lblHour.text = hourDesc
            lblServices.numberOfLines = 0
            lblServices.text = services
          //  lblPunctepuncte.isHidden = true
            lblPunctepuncte.text = ""
            if _isHourPast == true {
                lblDesc.textColor = Colors.sharedInstance.color3
                lblHour.textColor = Colors.sharedInstance.color3
                lblServices.textColor  = Colors.sharedInstance.color3
            } else {
                lblDesc.textColor = UIColor.black
                lblHour.textColor = UIColor.black
                lblServices.textColor = UIColor.black
            }
            return
        } else {
            lblDesc.text = desc
            lblPunctepuncte.isHidden = true
            lblServices.isHidden = true
            lblServices.numberOfLines = 0
            lblServices.text = services
            lblHour.text = hourDesc
            
            if _isexpanded == true {
                lblServices.isHidden = false
            }
            if _isexpanded == false && _islastrow == true {
                lblPunctepuncte.isHidden = false
                
            }
            
            //  if _isBthereEvent == false {
            lblServices.textColor = UIColor.black
            lblDesc.alpha = 1
            lblHour.alpha = 1
            lblServices.alpha = 1
            
            if _isBlocked {
                lblServices.text = "BlockedBySupplier"
                lblDesc.textColor = Colors.sharedInstance.redforblockinghours
                lblHour.textColor = Colors.sharedInstance.redforblockinghours
                lblServices.textColor = Colors.sharedInstance.redforblockinghours
                lblServices.text = ""
                lblDesc.text = ""
                lblHour.text = ""
//                lblServices.alpha = 0
//                lblDesc.alpha = 0
//                lblHour.alpha = 0
  //              lblPunctepuncte.isHidden = true
                lblPunctepuncte.text = ""
              //  return
                
            } else {
            if _isHourPast == true {
                lblDesc.textColor = Colors.sharedInstance.color3
                lblHour.textColor = Colors.sharedInstance.color3
                lblServices.textColor = Colors.sharedInstance.color3
            } else {
                lblDesc.textColor = UIColor.black
                lblHour.textColor = UIColor.black
                lblServices.textColor = UIColor.black
            }
            }
            if _isBthereEvent == false {
                lblDesc.textColor = Colors.sharedInstance.greenforsyncedincalendar
                lblHour.textColor = Colors.sharedInstance.greenforsyncedincalendar
            }
        }
        

    }
}
