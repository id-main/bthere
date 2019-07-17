//
//  JoCalendarSettingsTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 07/03/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class JoCalendarSettingsTableViewCell: UITableViewCell, UITextFieldDelegate {
    var PARENTDELEGATE:reloadTblDelegateParent!=nil
    var isValidMaxServiceForCustomer:Bool = false
    var isValidPeriodInWeeksForMaxServices:Bool = false
    var iFirstCalendarViewType:Int = 0
    @IBOutlet weak var lblDoWantLimit: TTTAttributedLabel!
    @IBOutlet weak var lblNumAppointmets: TTTAttributedLabel!
    @IBOutlet weak var lblDuringTurns: TTTAttributedLabel!
    @IBOutlet weak var btnYesSelect: JoCheckBoxForDetailsWorker2!
    @IBOutlet weak var txtMaxServiceForCustomer: UITextField!
    @IBOutlet weak var txtPeriodInWeeksForMaxServices: UITextField!
    @IBAction func btnYesSelect(_ sender: JoCheckBoxForDetailsWorker2) {
        btnNoCheck.isCecked = false
        txtPeriodInWeeksForMaxServices.isEnabled = true
        txtMaxServiceForCustomer.isEnabled = true
        if txtMaxServiceForCustomer.text == ""
        {
            txtMaxServiceForCustomer.text = "3"
            
        }
        if txtPeriodInWeeksForMaxServices.text == ""
        {
            txtPeriodInWeeksForMaxServices.text = "6"
        }
        btnYesSelect.isCecked = true
    }
    @IBOutlet weak var btnNoCheck: JocheckBoxForDetailsWorker!
    @IBAction func btnNoCheck(_ sender: JocheckBoxForDetailsWorker)
    {
        btnYesSelect.isCecked = false
        btnNoCheck.isCecked = true
        txtPeriodInWeeksForMaxServices.isEnabled = false
        txtMaxServiceForCustomer.isEnabled = false
        txtMaxServiceForCustomer.textColor = UIColor.black
        txtMaxServiceForCustomer.text = ""
        txtPeriodInWeeksForMaxServices.textColor = UIColor.black
        txtPeriodInWeeksForMaxServices.text = ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblDoWantLimit.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        lblNumAppointmets.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        lblDuringTurns.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        
        lblDoWantLimit.textAlignment = .left
        lblNumAppointmets.textAlignment = .left
        lblDuringTurns.textAlignment = .left
        txtMaxServiceForCustomer.delegate = self
        txtPeriodInWeeksForMaxServices.delegate = self
        txtMaxServiceForCustomer.textAlignment = .left
        txtPeriodInWeeksForMaxServices.textAlignment = .left
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            lblDoWantLimit.textAlignment = .right
            lblNumAppointmets.textAlignment = .right
            lblDuringTurns.textAlignment = .right
            txtMaxServiceForCustomer.textAlignment = .right
            txtPeriodInWeeksForMaxServices.textAlignment = .right
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            lblDoWantLimit.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblNumAppointmets.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblDuringTurns.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            txtMaxServiceForCustomer.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            txtPeriodInWeeksForMaxServices.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
        } else {
            lblDoWantLimit.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
            lblNumAppointmets.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
            lblDuringTurns.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
            txtMaxServiceForCustomer.font = UIFont(name: "OpenSansHebrew-Light", size: 18)
            txtPeriodInWeeksForMaxServices.font = UIFont(name: "OpenSansHebrew-Light", size: 18)
        }
        
        let CalendarDictionary =  Global.sharedInstance.generalDetails.calendarProperties
        print("get Dictionary\(CalendarDictionary.getDic())")
        
        if CalendarDictionary.bLimitSeries == false {
            self.btnNoCheck(btnNoCheck)
            btnNoCheck.setNeedsLayout()
            btnYesSelect.setNeedsLayout()
            self.txtMaxServiceForCustomer.text = ""
            self.txtPeriodInWeeksForMaxServices.text = ""
        } else {
            self.btnYesSelect(btnYesSelect)
            btnNoCheck.setNeedsDisplay()
            btnYesSelect.setNeedsDisplay()
            self.txtMaxServiceForCustomer.text = String(CalendarDictionary.iMaxServiceForCustomer)
            self.txtPeriodInWeeksForMaxServices.text = String(CalendarDictionary.iPeriodInWeeksForMaxServices)
        }
        lblDoWantLimit.text = "LIMIT_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblNumAppointmets.text = "NUM_TURNS_MEETINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblDuringTurns.text = "DURATION_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
      
    }

    override func layoutSubviews() {

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - TextField
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        var startString = ""
        if (textField.text != nil) 
        {
            startString += textField.text!
        }
        startString += string
        let limitNumber = Int(startString)
            if textField == txtPeriodInWeeksForMaxServices
        {
            if txtPeriodInWeeksForMaxServices.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                textField.textColor = UIColor.black
                textField.text = ""
            }
            else
            {
               
                return true

            }
        }
        else if textField == txtMaxServiceForCustomer
        {
            if txtMaxServiceForCustomer.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                textField.textColor = UIColor.black
                textField.text = ""
            }
            else
            {
                if limitNumber > 100
                {
                    Alert.sharedInstance.showAlertDelegate("MAX_CHAR".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return false
                }
                else
                {
                    return true
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || (textField.text == "3" && textField == txtMaxServiceForCustomer) || (textField.text == "6" && textField == txtPeriodInWeeksForMaxServices)
        {
            textField.text = ""
        }
        
        textField.textColor = UIColor.black
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
     
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
    
   }
