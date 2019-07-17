//
//  CalenderSettingTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/3/16.TTTAttributedLabel
//  Copyright © 2016 Webit. All rights reserved.
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

protocol dismiss{
    func dismmissKeybourd()
}

protocol delKbCalenderNotifDelegate {
    func delKbCalenderNotif()
}

class CalenderSettingTableViewCell: UITableViewCell,UITextFieldDelegate,delKbCalenderNotifDelegate,saveDataToWorkerDelegate
{

    var ISYESSELECTED:Bool = false
    //MARK: - Properties
    var delegate:dismiss! = nil
    var delegateSave:reloadTableForSaveDelegate! = nil
    var delegateKb:delKbNotificationDelegate!=nil
    var delegateKbBusiness:delKbNotifBusinessDelegate!=nil
    var delegateScroll:scrollOnEditDelegate!=nil
    var isValidDate = false
    var isValidMaxServiceForCustomer = false
    var isValidPeriodInWeeksForMaxServices = false
    var selectedTextField:UITextField?
    @IBOutlet weak var btnHEIGHT: NSLayoutConstraint! //checkbox in calendar
    @IBOutlet weak var dyanmicrowHEIGHT: NSLayoutConstraint! //1st row
    @IBOutlet weak var dyanmiclabelHEIGHT: NSLayoutConstraint! //2nd row
    @IBOutlet weak var dyanmiclabel2HEIGHT: NSLayoutConstraint! //3rd row
    //MARK: - Outlet
    let highLightedImgV = UIImage(named: "OK-select.png")
    let noHighlightedImgV = UIImage(named: "ok (1).png")
    let highLightedImgX = UIImage(named: "Cancel-select.png")
    let noHighlightedImgX = UIImage(named: "Cancel.png")
    @IBOutlet weak var noBtn: appointmentsSettingsBtnClass!
    @IBOutlet weak var yesBtn: appointmentsSettingsBtnClass!
    @IBOutlet weak var lblDoWantLimit: TTTAttributedLabel!
    @IBOutlet weak var lblDesignCal: UILabel!
    @IBAction func pressedNoBtn(_ sender: Any)
    {
       setBTNOON()

    }
    
    
    @IBAction func pressedYesBtn(_ sender: Any)
    {
        setBTNYESON()

    }
    
    @IBOutlet weak var lblNumAppointmets: TTTAttributedLabel!
    
    @IBOutlet weak var lblDuringTurns: TTTAttributedLabel!

    @IBOutlet weak var btnLimitSeries: checkBoxForDetailsWorker!
    
    @IBOutlet weak var txtMaxServiceForCustomer: UITextField!
    
    @IBOutlet weak var txtPeriodInWeeksForMaxServices: UITextField!
    
    //   @IBOutlet weak var txtDtCalendarOpenDate: UITextField!
    var iFirstCalendarViewType:Int = 0

    
    @IBAction func btnSave(_ sender: UIButton) {
        textFieldDidEndEditing(self.txtPeriodInWeeksForMaxServices)
        textFieldDidEndEditing(self.txtMaxServiceForCustomer)
        Global.sharedInstance.fIsSaveConCalenderSettingPressed = true
        if txtMaxServiceForCustomer.text == "0" && self.ISYESSELECTED == true || txtMaxServiceForCustomer.text == "" && self.ISYESSELECTED == true || txtMaxServiceForCustomer.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            isValidMaxServiceForCustomer = false
        }
        else
        {
            isValidMaxServiceForCustomer = true
        }
        
        if txtPeriodInWeeksForMaxServices.text == "0" && self.ISYESSELECTED == true || txtPeriodInWeeksForMaxServices.text == "" && self.ISYESSELECTED == true || txtPeriodInWeeksForMaxServices.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            isValidPeriodInWeeksForMaxServices = false
        }
        else
        {
            isValidPeriodInWeeksForMaxServices = true
        }
        
        if  isValidMaxServiceForCustomer == true && isValidPeriodInWeeksForMaxServices == true
        {
            delegateSave.reloadTableForSave(self.tag,btnTag: 1)
            Global.sharedInstance.generalDetails.calendarProperties = objCalendarProperties(
                _iFirstCalendarViewType: iFirstCalendarViewType,
                _dtCalendarOpenDate:String(),
                _bLimitSeries: self.ISYESSELECTED,
                _iMaxServiceForCustomer: Global.sharedInstance.parseJsonToInt(txtMaxServiceForCustomer.text! as AnyObject),
                _iPeriodInWeeksForMaxServices: Global.sharedInstance.parseJsonToInt(txtPeriodInWeeksForMaxServices.text! as AnyObject),
                _bSyncGoogleCalendar: false,/*btnYesSynch.isCecked*/
                _iCustomerViewLimit: 52,
                _iHoursForPreCancelServiceByCustomer:0,
                _bIsAvailableForNewCustomer:true
            )
            Global.sharedInstance.fIsEmptyCalenderSetting = false
            Global.sharedInstance.headersCellRequired[4] = true
        }
        else
        {
            setBTNOON()
            Global.sharedInstance.generalDetails.calendarProperties = objCalendarProperties(
                _iFirstCalendarViewType: iFirstCalendarViewType,
                _dtCalendarOpenDate:String(),
                _bLimitSeries: self.ISYESSELECTED,
                _iMaxServiceForCustomer: Global.sharedInstance.parseJsonToInt(txtMaxServiceForCustomer.text! as AnyObject),
                _iPeriodInWeeksForMaxServices: Global.sharedInstance.parseJsonToInt(txtPeriodInWeeksForMaxServices.text! as AnyObject),
                _bSyncGoogleCalendar: false,
                _iCustomerViewLimit: 52,
                _iHoursForPreCancelServiceByCustomer:0,
                _bIsAvailableForNewCustomer:true
            )
            Global.sharedInstance.fIsEmptyCalenderSetting = true
        }
        print("lalla  Global.sharedInstance.generalDetails.calendarProperties\( Global.sharedInstance.generalDetails.calendarProperties.bLimitSeries)")
    }
    
    //MARK: - Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnHEIGHT.constant = 35
        self.dyanmicrowHEIGHT.constant = 60
        self.dyanmiclabelHEIGHT.constant = 40
        self.dyanmiclabel2HEIGHT.constant = 40
        lblDoWantLimit.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        lblNumAppointmets.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        lblDuringTurns.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        lblDoWantLimit.textAlignment = .left
        lblNumAppointmets.textAlignment = .left
        lblDuringTurns.textAlignment = .left
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
            self.btnHEIGHT.constant = 90
            self.dyanmicrowHEIGHT.constant = 60
            self.dyanmiclabelHEIGHT.constant = 60
            self.dyanmiclabel2HEIGHT.constant = 60
        } else {
            lblDoWantLimit.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblNumAppointmets.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblDuringTurns.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            txtMaxServiceForCustomer.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            txtPeriodInWeeksForMaxServices.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
        }
        lblDoWantLimit.text = "LIMIT_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblNumAppointmets.text = "NUM_TURNS_MEETINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblDuringTurns.text = "DURATION_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        Global.sharedInstance.GlobalDataVC?.delegateSaveCalendar = self
        Global.sharedInstance.calendarSetting = self
        txtMaxServiceForCustomer.delegate = self
        txtPeriodInWeeksForMaxServices.delegate = self
        txtPeriodInWeeksForMaxServices.text = ""
        txtMaxServiceForCustomer.text = ""
        
        //    calendarset ["iFirstCalendarViewType": 0, "dtCalendarOpenDate": , "bLimitSeries": 0, "iMaxServiceForCustomer": 7, "iPeriodInWeeksForMaxServices": 50]
        
        
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
            var  calset:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            calset = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties.getDic()
            print(") what cal \(calset)")
            if let _:Int = calset["iFirstCalendarViewType"] as? Int {

                iFirstCalendarViewType = calset["iFirstCalendarViewType"] as! Int

            }
            if Global.sharedInstance.fIsEmptyCalenderSetting == true
                
            {
                txtPeriodInWeeksForMaxServices.isUserInteractionEnabled = false
                txtPeriodInWeeksForMaxServices.isEnabled = false
                txtMaxServiceForCustomer.isUserInteractionEnabled = false
                txtMaxServiceForCustomer.isEnabled = false
                setBTNOON()
            }
                
            else
            {
                 if let _:Bool = calset["bLimitSeries"] as? Bool {
                    let mysetupvalue = calset["bLimitSeries"] as! Bool
                    if mysetupvalue == true {
                        setBTNYESON()
                    } else {
                        txtPeriodInWeeksForMaxServices.isUserInteractionEnabled = false
                        txtPeriodInWeeksForMaxServices.isEnabled = false
                        txtMaxServiceForCustomer.isUserInteractionEnabled = false
                        txtMaxServiceForCustomer.isEnabled = false
                        setBTNOON()
                    }
                }

                if let _:Int = calset["iMaxServiceForCustomer"] as? Int {

                    if (calset["iMaxServiceForCustomer"] as? Int)! == 0
                    {
                      setBTNOON()
                    }
                    else
                    {
                    setBTNYESON()
                    }
                    txtMaxServiceForCustomer.text = (calset["iMaxServiceForCustomer"] as? Int)!.description
                }
                if let _:Int = calset["iPeriodInWeeksForMaxServices"] as? Int {
                    
                    if (calset["iPeriodInWeeksForMaxServices"] as? Int)! == 0
                    {
                    setBTNOON()
                    }
                    else
                    {
                    setBTNYESON()
                    }
                    txtPeriodInWeeksForMaxServices.text = (calset["iPeriodInWeeksForMaxServices"] as? Int)!.description
                }
            }
        }
        else
        {
            setBTNOON()
            ISYESSELECTED = false
            txtPeriodInWeeksForMaxServices.isUserInteractionEnabled = false
            txtPeriodInWeeksForMaxServices.isEnabled = false
            txtMaxServiceForCustomer.isUserInteractionEnabled = false
            txtMaxServiceForCustomer.isEnabled = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

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

        selectedTextField = textField
        
        if textField.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || (textField.text == "0" && textField == txtMaxServiceForCustomer) || (textField.text == "0" && textField == txtPeriodInWeeksForMaxServices )
        {
            textField.text = ""
        }


        if delegateKb != nil
        {
            delegateKb.delKbNotification()
        }
        if delegateKbBusiness != nil
        {
            delegateKbBusiness.delKbNotifBusiness()
        }
        
        if Global.sharedInstance.didCalendarSettingClose == true
        {
            NotificationCenter.default.addObserver(self,selector: #selector(CalenderSettingTableViewCell.keyboardWillShow(_:)),name: UIResponder.keyboardWillShowNotification,object: nil)
            NotificationCenter.default.addObserver(self,selector: #selector(CalenderSettingTableViewCell.keyboardWillHide(_:)),name: UIResponder.keyboardWillHideNotification,object: nil)
            Global.sharedInstance.didServicesClosed = false
        }

        textField.textColor = UIColor.black

        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate.dismmissKeybourd()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if textField == txtPeriodInWeeksForMaxServices
        {
            if let _:Int = textField.text?.integerValue
            {
                if textField.text![0] == "0"
                {
                    print("primul character \(textField.text![0])")
                    var myString = textField.text!
                    print("my string \(myString)")
                    while (myString[0] == "0" && myString.count > 1)
                    {
                        myString.remove(at: myString.startIndex)
                    }
                    textField.text = myString
                }

            }
            if textField.text == "" || textField.text == "0"
            {
                textField.text = "6"
            }
            
        }
        
        if textField == txtMaxServiceForCustomer
        {
            if let _:Int = textField.text?.integerValue
            {
            if textField.text![0] == "0"
                {
                    print("primul character \(textField.text![0])")
                    var myString = textField.text!
                    print("my string \(myString)")
                    while (myString[0] == "0" && myString.count > 1)
                    {
                        myString.remove(at: myString.startIndex)
                    }
                    textField.text = myString
                }
                
            }
            if textField.text == "" || textField.text == "0"
            {
                textField.text = "3"
            }
            
        }
    }
    

    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    @objc func keyboardWillShow(_ note: Notification)
    {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.contentView.frame.origin.y == 0{
                self.contentView.frame.origin.y -= keyboardSize.height / 2
            }
        }
        
        if Global.sharedInstance.isFirstOpenKeyBoard == false
        {
            Global.sharedInstance.isFirstOpenKeyBoard = true

            if let _ = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {

                if let _ = delegateScroll
                {
                }
                else
                {
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                    Global.sharedInstance.didCalendarSettingClose = true
                }
                Global.sharedInstance.isFirstCloseKeyBoard = false
            }
        }
    }
    //for scrolling the table down, after editing textField
    @objc func keyboardWillHide(_ note: Notification) {

        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.contentView.frame.origin.y != 0{
                self.contentView.frame.origin.y += keyboardSize.height / 2
            }
            if Global.sharedInstance.isFirstCloseKeyBoard == false
            {
                Global.sharedInstance.isFirstCloseKeyBoard = true
                if let _ = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {

                    if let _ = delegateScroll
                    {

                    }
                    else
                    {
                        // remove the keyBoard events - Notifications
                        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                        Global.sharedInstance.didCalendarSettingClose = true
                    }
                    Global.sharedInstance.isFirstOpenKeyBoard = false
                }
            }
        }
    }
    
    //  remove the keyBoard events to prevent invoke the events from other cells
    func delKbCalenderNotif()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        Global.sharedInstance.didCalendarSettingClose = true
    }
    
    func  saveDataToWorker()->Bool{
        textFieldDidEndEditing(self.txtPeriodInWeeksForMaxServices)
        textFieldDidEndEditing(self.txtMaxServiceForCustomer)
        Global.sharedInstance.fIsSaveConCalenderSettingPressed = true
        if txtMaxServiceForCustomer.text == "0" && self.ISYESSELECTED  == true ||  txtMaxServiceForCustomer.text == "0" && self.ISYESSELECTED  == true || txtMaxServiceForCustomer.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || self.ISYESSELECTED == false
        {
            isValidMaxServiceForCustomer = false
        }
        else
        {
            isValidMaxServiceForCustomer = true
        }

        if txtPeriodInWeeksForMaxServices.text == "0" && self.ISYESSELECTED  == true || txtPeriodInWeeksForMaxServices.text == "" && self.ISYESSELECTED  == true || txtPeriodInWeeksForMaxServices.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) ||  self.ISYESSELECTED == false
        {
            isValidPeriodInWeeksForMaxServices = false
        }
        else
        {
            isValidPeriodInWeeksForMaxServices = true
        }
        if isValidMaxServiceForCustomer == true && isValidPeriodInWeeksForMaxServices == true
        {
            delegateSave.reloadTableForSave(self.tag,btnTag: 1)
            Global.sharedInstance.generalDetails.calendarProperties = objCalendarProperties(
                _iFirstCalendarViewType: iFirstCalendarViewType,
                _dtCalendarOpenDate:String(),
                _bLimitSeries: self.ISYESSELECTED,
                _iMaxServiceForCustomer: Global.sharedInstance.parseJsonToInt(txtMaxServiceForCustomer.text! as AnyObject),
                _iPeriodInWeeksForMaxServices: Global.sharedInstance.parseJsonToInt(txtPeriodInWeeksForMaxServices.text! as AnyObject),
                _bSyncGoogleCalendar: false,
                _iCustomerViewLimit: 52,
                _iHoursForPreCancelServiceByCustomer:0,
                _bIsAvailableForNewCustomer:true
            )
            print("lalla  Global.sharedInstance.generalDetails.calendarProperties\( Global.sharedInstance.generalDetails.calendarProperties.bLimitSeries)")
            Global.sharedInstance.fIsEmptyCalenderSetting = false
            Global.sharedInstance.headersCellRequired[4] = true
            return true
        }
        else
        {
            setBTNOON()
            Global.sharedInstance.generalDetails.calendarProperties = objCalendarProperties(
                _iFirstCalendarViewType: iFirstCalendarViewType,
                _dtCalendarOpenDate:String(),
                _bLimitSeries: self.ISYESSELECTED,
                _iMaxServiceForCustomer: Global.sharedInstance.parseJsonToInt(txtMaxServiceForCustomer.text! as AnyObject),
                _iPeriodInWeeksForMaxServices: Global.sharedInstance.parseJsonToInt(txtPeriodInWeeksForMaxServices.text! as AnyObject),
                _bSyncGoogleCalendar: false,
                _iCustomerViewLimit: 52,
                _iHoursForPreCancelServiceByCustomer:0,
                _bIsAvailableForNewCustomer:true
            )
            Global.sharedInstance.fIsEmptyCalenderSetting = true
            return false
        }
        
    }

    func setBTNYESON() {
        ISYESSELECTED = true
        yesBtn.setImage(highLightedImgV, for:UIControl.State())
        noBtn.setImage(noHighlightedImgX, for:UIControl.State())
        yesBtn.setNeedsLayout()
        yesBtn.setNeedsDisplay()
        txtMaxServiceForCustomer.isUserInteractionEnabled = true
        txtMaxServiceForCustomer.isEnabled = true
        txtPeriodInWeeksForMaxServices.isUserInteractionEnabled = true
        txtPeriodInWeeksForMaxServices.isEnabled = true

    }
    func setBTNOON() {
        ISYESSELECTED = false
        yesBtn.setImage(noHighlightedImgV, for:UIControl.State())
        noBtn.setImage(highLightedImgX, for:UIControl.State())
        noBtn.setNeedsLayout()
        noBtn.setNeedsDisplay()
        txtMaxServiceForCustomer.isUserInteractionEnabled = false
        txtMaxServiceForCustomer.isEnabled = false
        txtPeriodInWeeksForMaxServices.isUserInteractionEnabled = false
        txtPeriodInWeeksForMaxServices.isEnabled = false
        txtMaxServiceForCustomer.text = ""
        txtPeriodInWeeksForMaxServices.text = ""

    }


}


