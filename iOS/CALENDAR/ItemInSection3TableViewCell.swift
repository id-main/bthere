//
//  ItemInSection3TableViewCell.swift
//  bthree-ios
//
//  Created by User on 24.2.2016.
//  Copyright © 2017 Webit. All rights reserved.
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


protocol addRowForSection3Delegate{
    func addRow(_ tag:Int , row:Int)
}

protocol saveDataDelegate{
    func saveData()->Bool
}

protocol delKbNotificationDelegate {
    func delKbNotification()
}

protocol tableViewAddressDelegate {
    func tableViewAddress(_ lastContentOffset:CGFloat)
}
//Adding employees
class ItemInSection3TableViewCell: UITableViewCell,UITextFieldDelegate,saveDataDelegate,delKbNotificationDelegate,saveDataToWorkerDelegate{
    var ONCEONLOAD:Int = 0
    var delegate:addRowForSection3Delegate! = nil
    var delegateSave:reloadTableForSaveDelegate! = nil
    var delegateScroll:scrollOnEditDelegate!=nil
    var delegateKbBusiness:delKbNotifBusinessDelegate!=nil
    var delegateKbCalendar:delKbCalenderNotifDelegate!=nil
    var delegateZeroMaxMin:ZeroDPMaxMinDelegte!=nil
    var delegateGeneric:genericDelegate!=nil
    var sectionCell:Int = 0
    var contentOffset:CGFloat = 0
    var serviceProvidersForEdit = objServiceProvidersForEdit()
    var flag_FirstName:Bool = false
    var flag_LastName:Bool = false
    var flag_Phone:Bool = false
    var flag_PhoneInternet:Bool = true
    var flag_Email:Bool = false
    var flag_EmailInternet:Bool = true
    var flag_Date:Bool = false
    var indexCell:Int = 0
    var isSetData = false
    var selfEmailExist = ""
    var selfPhoneExist = ""
    var arrGoodPhone:Array<Character> = Array<Character>()
    var generic:Generic = Generic()
    var selectedTextField:UITextField?
    var IuserStatus:Int = 25
    var bismanager:Int = 0
    var iUserId:Int = 0
    var LOCALbsameW:Bool = false
    var PROVIDERID:Int = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var error1: UILabel!
    @IBOutlet weak var error2: UILabel!
    @IBOutlet weak var error3: UILabel!
    @IBOutlet weak var composedview: UIView!
    @IBOutlet weak var secondcomposedview: UIView!
    @IBOutlet weak var doTheHoursEqualTo: UILabel!
    @IBOutlet weak var doYouWantOpenPersonalCalendar: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblHoursWork: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnCheckBoxNo: checkBoxForDetailsWorker!
    @IBOutlet weak var btnCheckBox: CheckBoxForDetailsWorker2!
    @IBOutlet weak var btnHEIGHT: NSLayoutConstraint! //checkbox in workers
    @IBOutlet weak var dyanmicrowHEIGHT: NSLayoutConstraint! //row in list fields name, phone, email etc
    @IBOutlet weak var dyanmiclabelHOURSHEIGHT: NSLayoutConstraint! //label are his working hours equal
    @IBOutlet weak var dyanmiclabelErrorHEIGHT: NSLayoutConstraint! //label error 1, 2 , 3
    @IBAction func btnCheckBox(_ sender: AnyObject) {
        btnEqalHours.isEnabled = true
        btnEqalHoursNo.isEnabled = true
        btnCheckBoxNo.isCecked = false
    }
    @IBAction func btnCheckBoxNo(_ sender: AnyObject) {
        if btnEqalHoursNo.isCecked == true
        {
            if Global.sharedInstance.isOpenHoursForPlus == true{
                self.tag = -60
                Global.sharedInstance.isOpenHoursForPlusAction = false
                Global.sharedInstance.fromEdit = true
                delegate.addRow(self.tag, row: self.indexCell)
            }
            else if Global.sharedInstance.fromEdit == false{
                self.tag = -50
                delegate.addRow(self.tag, row: self.indexCell)
            }
            else{
                self.tag = -90
                Global.sharedInstance.clickNoCalendar = true
                delegate.addRow(self.tag, row: self.indexCell)
            }
        }
        btnEqalHoursNo.isCecked = false
        btnEqalHours.isEnabled = false
        btnEqalHoursNo.isEnabled = false
        btnEqalHours.isCecked = false
    }
    @IBAction func btnEqual(_ sender: CheckBoxForDetailsWorker2?)
    {
        Global.sharedInstance.isClickNoEqual = false
        if Global.sharedInstance.addRecess == true
        {
            Global.sharedInstance.GlobalDataVC!.delegateEnabledBtnDays.enabledTrueBtnDays()
        }
        Global.sharedInstance.addRecess = false
        if btnEqalHoursNo.isCecked == true
        {
            btnEqalHoursNo.isCecked = false
            sender?.isCecked = true
            if Global.sharedInstance.isOpenHoursForPlus == true{
                self.tag = -60     // Click on V in the same hours of activity on the Add Employee button
                Global.sharedInstance.isOpenHoursForPlusAction = false
                Global.sharedInstance.fromEdit = true
                delegate.addRow(self.tag, row: self.indexCell)
            }
            else  if Global.sharedInstance.fromEdit == true{
                self.tag = -80      // Pressing V during editing hours
                Global.sharedInstance.isOpenHoursForNewWorker =  false
                Global.sharedInstance.isClickEqual = true
                delegate.addRow(self.tag, row: self.indexCell)
            }
            else{
                self.tag = -50
                delegate.addRow(self.tag, row: self.indexCell)
            }
        }
    }
    @IBAction func btnNoEqwal(_ sender: checkBoxForDetailsWorker?) {
        Global.sharedInstance.isClickNoEqual = true
        Global.sharedInstance.isClickEqual  = false
        btnEqalHours.isCecked = false
        if Global.sharedInstance.GlobalDataVC!.delegateEnabledBtnDays != nil
        {
            Global.sharedInstance.GlobalDataVC!.delegateEnabledBtnDays.enabledTrueBtnDays()
        }
    }
    @IBOutlet weak var btnEqalHoursNo: checkBoxForDetailsWorker!
    @IBOutlet weak var btnEqalHours: CheckBoxForDetailsWorker2!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var conView: UIView!
    @IBAction func btnSave(_ sender: UIButton) {
        delegateSave.reloadTableForSave(self.tag,btnTag: 1)
    }
    @IBAction func checkNo(_ sender: CheckBox?)
    {
        Global.sharedInstance.onOpenTimeOpenHours = true
        Global.sharedInstance.hoursForWorker = true
        if sender?.isCecked == false
        {
            if Global.sharedInstance.isOpenHoursForPlus == true
            {
                Global.sharedInstance.hoursForWorkerFromPlus = true
                Global.sharedInstance.isOpenHoursForPlusAction = true
            }
            if Global.sharedInstance.fromEdit == false ||  Global.sharedInstance.isOpenHoursForPlusAction == true
            {
                delegate.addRow(self.tag, row: self.indexCell)//לחיצה על איקס בשעות פעילות שונות להוסף עובד
            }
            else if Global.sharedInstance.fromEdit == false
            {
                Global.sharedInstance.isOpenHoursForNewWorker = false
                Global.sharedInstance.fromEdit = false
                self.tag = -70
                delegate.addRow(self.tag, row: self.indexCell)
            }
            if Global.sharedInstance.fromEdit == true
            {
                self.tag = -70//לחיצה על איקס בשעות פעילות בעריכה
                Global.sharedInstance.hoursForWorkerFromEdit = true
                Global.sharedInstance.isOpenHoursForNewWorker =  true
                delegate.addRow(self.tag, row: self.indexCell)
                btnEqalHours.isCecked = false
                btnEqalHoursNo.isCecked = true
                Global.sharedInstance.itemInSection3TableViewCell?.delegateZeroMaxMin = Global.sharedInstance.hoursActive
                if Global.sharedInstance.itemInSection3TableViewCell?.delegateZeroMaxMin != nil
                {
                    Global.sharedInstance.itemInSection3TableViewCell?.delegateZeroMaxMin.ZeroDPMaxMin()
                }
            }
            btnEqalHours.isCecked = false
            sender?.isCecked = true
        }
    }
    //MARK: - Initial
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.btnHEIGHT.constant = 35
        self.dyanmicrowHEIGHT.constant = 40
        self.dyanmiclabelErrorHEIGHT.constant = 22
        self.dyanmiclabelHOURSHEIGHT.constant = 60
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.txtMail.textAlignment = .right
            self.txtPhone.textAlignment = .right
            self.txtFirstName.textAlignment = .right
            lblFirstName.textAlignment = .right
            lblEmail.textAlignment = .right
            lblPhone.textAlignment = .right
            lblHoursWork.textAlignment = .right
            doTheHoursEqualTo.textAlignment = .right
            error1.textAlignment  = .right
            error2.textAlignment = . right
            error3.textAlignment = .right
        } else {
            self.txtMail.textAlignment = .left
            self.txtPhone.textAlignment = .left
            self.txtFirstName.textAlignment = .left
            lblFirstName.textAlignment = .left
            lblEmail.textAlignment = .left
            lblPhone.textAlignment = .left
            lblHoursWork.textAlignment = .left
            doTheHoursEqualTo.textAlignment = .left
            error1.textAlignment  = .left
            error2.textAlignment = . left
            error3.textAlignment = .left
        }
        
        self.txtMail.isUserInteractionEnabled = true
        self.txtPhone.isUserInteractionEnabled = true
        self.txtFirstName.isUserInteractionEnabled = true
        print("self.IuserStatus \(self.IuserStatus)")
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 && self.IuserStatus == 24{
            self.txtMail.isUserInteractionEnabled = false
            self.txtPhone.isUserInteractionEnabled = false
            self.txtFirstName.isUserInteractionEnabled = false
        }
        lblFirstName.text = "FIRST_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblEmail.text = "MAIL_DP".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblPhone.text = "PHONE_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblHoursWork.text = "HOURS_ACTIVE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        doTheHoursEqualTo.text = "EQUAL_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        doTheHoursEqualTo.numberOfLines = 0
        isSetData = false
        selfPhoneExist = ""
        selfEmailExist = ""
        Global.sharedInstance.GlobalDataVC!.delegateSaveWorker = self
        txtPhone.delegate = self
        btnEqalHours.isEnabled = false
        if UIDevice.current.userInterfaceIdiom == .pad {
            doTheHoursEqualTo.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblFirstName.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblPhone.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblEmail.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblHoursWork.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            error1.font  = UIFont(name: "OpenSansHebrew-Light", size: 22)
            error2.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            error3.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            self.btnHEIGHT.constant = 90
            self.dyanmicrowHEIGHT.constant = 50
            self.dyanmiclabelErrorHEIGHT.constant = 30
            self.dyanmiclabelHOURSHEIGHT.constant = 70
        } else {
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
            {
                doTheHoursEqualTo.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblFirstName.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblPhone.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblEmail.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblHoursWork.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                error1.font  = UIFont(name: "OpenSansHebrew-Light", size: 14)
                error2.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                error3.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                self.btnHEIGHT.constant = 35
                self.dyanmicrowHEIGHT.constant = 40
                self.dyanmiclabelErrorHEIGHT.constant = 22
                self.dyanmiclabelHOURSHEIGHT.constant = 60
            }
            else if DeviceType.IS_IPHONE_6 ||  DeviceType.IS_IPHONE_6P
            {
                doTheHoursEqualTo.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblFirstName.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblPhone.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblEmail.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblHoursWork.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                error1.font  = UIFont(name: "OpenSansHebrew-Light", size: 16)
                error2.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                error3.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                self.btnHEIGHT.constant = 35
                self.dyanmicrowHEIGHT.constant = 40
                self.dyanmiclabelErrorHEIGHT.constant = 22
                self.dyanmiclabelHOURSHEIGHT.constant = 60
            }
        }
        Global.sharedInstance.saveTableViewCell?.delegateSaveData = self
        Global.sharedInstance.itemInSection2TableViewCell?.saveData = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtPhone.delegate = self
        txtMail.delegate = self
        txtPhone.textColor = UIColor.black
        txtMail.textColor = UIColor.black
        error1.text = ""
        error2.text = ""
        error3.text = ""
        self.txtPhone.text = ""
        self.txtMail.text = ""
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        PROVIDERID = providerID
    }
    func setDisplayData(_ user:objUsers,bsameW:Bool){
        Global.sharedInstance.defaults.set(1, forKey: "firsttimecell")
        Global.sharedInstance.defaults.synchronize()
        self.iUserId = user.iUserId
        isSetData = true
        Global.sharedInstance.isVclicedForWorkerForEdit = bsameW
        if let _:Int = user.iUserStatusType  {
            let x:Int = user.iUserStatusType
            if x == 24 {
                self.IuserStatus = user.iUserStatusType
            }
        }
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 && self.IuserStatus == 24{
            self.txtMail.isUserInteractionEnabled = false
            self.txtPhone.isUserInteractionEnabled = false
            self.txtFirstName.isUserInteractionEnabled = false
        }
        self.bismanager = user.bIsManager
        txtFirstName.text = user.nvFirstName + " " + user.nvLastName
        // txtLastName.text = user.nvLastName
        txtPhone.text = user.nvPhone
        txtMail.text = user.nvMail
        selfPhoneExist = txtPhone.text!
        selfEmailExist = txtMail.text!
        print("user.iUserStatusType \(user.iUserStatusType)")
        print("item.bSameWH \(bsameW)")
        if bsameW == false {
            LOCALbsameW = false
        } else {
            LOCALbsameW = true
        }
        print(" Global.sharedInstance.isClickNoEqual \( Global.sharedInstance.isClickNoEqual)")
        print("Global.sharedInstance.isClickEqual \(Global.sharedInstance.isClickEqual)")
        print("Global.sharedInstance.clickNoCalendar \(Global.sharedInstance.clickNoCalendar)")
        txtMail.textColor = UIColor.black
        txtPhone.textColor = UIColor.black
        //Identical hours press V user inactive
        if ( user.iUserStatusType == 25 ) && Global.sharedInstance.isClickNoEqual == false && Global.sharedInstance.isClickEqual == false && Global.sharedInstance.clickNoCalendar == false
        {
            btnEqalHoursNo.isCecked = false
            btnEqalHours.isCecked = true
            btnEqalHours.isEnabled = true
            btnEqalHoursNo.isEnabled = true
        }
            //hours are not identical press X user inactive
        else if( user.iUserStatusType == 25 ) && Global.sharedInstance.isClickNoEqual == false && Global.sharedInstance.isClickEqual == false && Global.sharedInstance.clickNoCalendar == false
        {
            btnEqalHoursNo.isCecked = true
            btnEqalHours.isCecked = false
            btnEqalHours.isEnabled = true
            btnEqalHoursNo.isEnabled = true
        }
            //existing users
        else if ( user.iUserStatusType == 24 || user.iUserStatusType == 25)  && Global.sharedInstance.isClickNoEqual == false && Global.sharedInstance.isClickEqual == true && Global.sharedInstance.clickNoCalendar == false
        {
            btnEqalHoursNo.isCecked = false
            btnEqalHours.isCecked = true
            btnEqalHours.isEnabled = true
            btnEqalHoursNo.isEnabled = true
        }
            //hours are not identical press X user is active
        else if  ( user.iUserStatusType == 24 || user.iUserStatusType == 25) && Global.sharedInstance.isClickNoEqual == true && Global.sharedInstance.isClickEqual == false && Global.sharedInstance.clickNoCalendar == false
        {
            btnEqalHoursNo.isCecked = true
            btnEqalHours.isEnabled = true
            self.setNeedsDisplay()
        }
        else if   ( user.iUserStatusType == 24 || user.iUserStatusType == 25)  && (Global.sharedInstance.isClickNoEqual == false || Global.sharedInstance.clickNoCalendar == true) && Global.sharedInstance.isClickEqual == false
        {
            btnEqalHoursNo.isCecked = true
            btnEqalHours.isCecked = false
            btnEqalHours.isEnabled = true
            btnEqalHoursNo.isEnabled = true
            self.setNeedsDisplay()
        }
        else if   ( user.iUserStatusType == 24 || user.iUserStatusType == 25)  &&    (Global.sharedInstance.isClickNoEqual == false || Global.sharedInstance.clickNoCalendar == false) && Global.sharedInstance.isClickEqual == false {
            btnEqalHoursNo.isCecked = false
            btnEqalHours.isCecked = true
            btnEqalHours.isEnabled = true
            btnEqalHoursNo.isEnabled = true
        }
        else if  ( user.iUserStatusType == 24 || user.iUserStatusType == 25)   &&    (Global.sharedInstance.isClickNoEqual == false || Global.sharedInstance.clickNoCalendar == false) && Global.sharedInstance.isClickEqual == false {
            btnEqalHoursNo.isCecked = true
            btnEqalHours.isCecked = false
            btnEqalHours.isEnabled = true
            btnEqalHoursNo.isEnabled = true
        }
        else if  (Global.sharedInstance.isClickNoEqual == false || Global.sharedInstance.clickNoCalendar == true) && Global.sharedInstance.isClickEqual == false
        {
            btnEqalHoursNo.isCecked = false
            btnEqalHours.isCecked = false
            btnEqalHours.isEnabled = false
            btnEqalHoursNo.isEnabled = false
        }
        else if Global.sharedInstance.isClickNoEqual == true && Global.sharedInstance.clickNoCalendar == false
        {
            btnEqalHoursNo.isCecked = true
            btnEqalHours.isEnabled = true
        }
        else if  Global.sharedInstance.isClickEqual == true && Global.sharedInstance.clickNoCalendar == false
        {
            btnEqalHoursNo.isCecked = false
            btnEqalHours.isCecked = true
            btnEqalHours.isEnabled = true
            Global.sharedInstance.isClickEqual = false
        }
        if Global.sharedInstance.clickNoCalendar == true{
            Global.sharedInstance.clickNoCalendar = false
        }
    }
    func setdisplayData()
    {
        error1.text = ""
        error2.text = ""
        error3.text = ""
        txtFirstName.text = txtFirstName.text
        txtPhone.text = txtPhone.text
        txtMail.text = txtMail.text
        self.txtMail.isUserInteractionEnabled = true
        self.txtPhone.isUserInteractionEnabled = true
        self.txtFirstName.isUserInteractionEnabled = true
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 && self.IuserStatus == 24{
            self.txtMail.isUserInteractionEnabled = false
            self.txtPhone.isUserInteractionEnabled = false
            self.txtFirstName.isUserInteractionEnabled = false
        }
    }
    func setDisplayDataNull()
    {
        Global.sharedInstance.isOpenWorker = true
        txtFirstName.text = ""
        txtLastName.text = ""
        txtPhone.text = ""
        txtMail.text = ""
        error1.text = ""
         error2.text = ""
         error3.text = ""
        btnEqalHours.isCecked = true    //√
        btnEqalHoursNo.isCecked = false  //x
        btnEqalHoursNo.isEnabled = true
        btnEqalHours.isEnabled = true
        self.txtMail.isUserInteractionEnabled = true
        self.txtPhone.isUserInteractionEnabled = true
        self.txtFirstName.isUserInteractionEnabled = true
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 && self.IuserStatus == 24{
            self.txtMail.isUserInteractionEnabled = false
            self.txtPhone.isUserInteractionEnabled = false
            self.txtFirstName.isUserInteractionEnabled = false
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func saveData()->Bool
    {
        self.txtMail.isUserInteractionEnabled = true
        self.txtPhone.isUserInteractionEnabled = true
        self.txtFirstName.isUserInteractionEnabled = true
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 && self.IuserStatus == 24{
            self.txtMail.isUserInteractionEnabled = false
            self.txtPhone.isUserInteractionEnabled = false
            self.txtFirstName.isUserInteractionEnabled = false
        }
        isPhoneExist()
        //        if isSetData == false {
        //       return false
        //        }
        var userStatus:Int?
        var bsameWH:Bool?
        var arrObjWorkingHourss:Array<objWorkingHours>?
        var objUserss:objUsers?
        //existing user or new one
        if self.IuserStatus  == 24 {
            userStatus = self.IuserStatus
        } else {
            userStatus = 25
        }
        if btnEqalHours.isCecked
        {
            bsameWH = true
            arrObjWorkingHourss = []
        }
        else
        {
            bsameWH = false
            saveHoursToWorker()
            arrObjWorkingHourss = Global.sharedInstance.serviceProvider.arrObjWorkingHours
        }
        //make first and last from array
        let fullNameVerify = txtFirstName.text! as String
        let fullNameString = fullNameVerify
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        
        let fullNameArr = fullNameString.components(separatedBy: " ")
        //\\   let fullNameArr = fullNameVerify.componentsSeparatedByString(" ")
        
        let size = fullNameArr.count
        var firstNameVerify = ""
        var lastNameVerify = ""
        
        if(size > 1) {
            let myArray : NSMutableArray = []
            for item in fullNameArr {
                //    print("ce item ||\(item)||...")
                let newString = item.replace(" ", withString:"")
                if(newString.characters.count > 0  ) {
                    print("Found \(newString)")
                    myArray.add(newString)
                }
            }
            let sizemutablearray = myArray.count
            if(sizemutablearray > 1 ) {
                firstNameVerify = myArray.object(at: 0) as! String
                lastNameVerify = myArray.object(at: 1) as! String
                self.txtLastName.text = lastNameVerify
                self.txtFirstName.textColor = UIColor.black
                error1.text = ""
                self.flag_FirstName = true
            }
            else {
                error1.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                self.flag_FirstName = false
            }
        }
        let dateString = "01/01/1901" // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        let birthday = dateFormatter.date(from: dateString)
        // let birthday : NSDate? = nil
        print("PROVIDERID \(PROVIDERID)")
        objUserss = objUsers(
            _nvUserName: txtMail.text!,
            _nvFirstName: firstNameVerify,
            _nvLastName: lastNameVerify,
            _dBirthdate: birthday!,
            _nvMail: txtMail.text!,
            _iCityType: 1,
            _nvPhone: txtPhone.text!,
            _nvPassword: "",
            _nvVerification: "",
            _bAutomaticUpdateApproval: false,
            _bDataDownloadApproval: false,
            _bTermOfUseApproval: false,
            _bAdvertisingApproval: false,
            _iUserStatusType: userStatus!,
            _bIsGoogleCalendarSync: false,
            _iCreatedByUserId: PROVIDERID,
            _iLastModifyUserId: PROVIDERID,
            _iSysRowStatus: 1,
            _bIsManager:  self.bismanager,
            _iUserId: self.iUserId,
            _allPHONES:[],
            _nvNickName: ""
        )
        print("bug Global.sharedInstance.currentProvider.iUserId \(PROVIDERID)")
        Global.sharedInstance.serviceProvider.objsers = objUserss!
        Global.sharedInstance.serviceProvider = objServiceProviders(
            _objsers: objUserss!,
            _arrObjWorkingHours: arrObjWorkingHourss!,
            _bSameWH: bsameWH!,
            _liPermissionType: [],
            _objProviderServices: []
        )
        serviceProvidersForEdit = objServiceProvidersForEdit()
        serviceProvidersForEdit = objServiceProvidersForEdit(
            _objsers: objUserss!,
            _arrObjWorkingHours: Global.sharedInstance.serviceProviderForEdit.arrObjWorkingHours,
            _arrObjWorkingRest: Global.sharedInstance.serviceProviderForEdit.arrObjWorkingRest,
            _isHoursSelected: Global.sharedInstance.isHoursSelectedChild,
            _isHoursSelectedRest: Global.sharedInstance.isHoursSelectedRestChild,
            _isSelectAllHours: Global.sharedInstance.isSelectAllHoursChild,
            _isSelectAllRecess: Global.sharedInstance.isSelectAllRestChild,
            _bSameWH: bsameWH!)
        Global.sharedInstance.defaults.set(0, forKey: "firsttimecell")
        Global.sharedInstance.defaults.synchronize()
        
        if Global.sharedInstance.isServiceProviderEditOpen == true
        {
            Global.sharedInstance.isFromEdit = true
            if checkValidity() == true && Global.sharedInstance.isAllFlagsFalse == false
            {
                if Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 0
                {
                    Global.sharedInstance.generalDetails.arrObjServiceProviders.remove(at: Global.sharedInstance.indexForArr)
                    Global.sharedInstance.arrObjServiceProvidersForEdit.remove(at: Global.sharedInstance.indexForArr)//בשביל עריכה
                }
                Global.sharedInstance.generalDetails.arrObjServiceProviders.insert(Global.sharedInstance.serviceProvider, at:Global.sharedInstance.indexForArr)
                Global.sharedInstance.arrObjServiceProvidersForEdit.insert(serviceProvidersForEdit, at:Global.sharedInstance.indexForArr)
                Global.sharedInstance.isValidWorkerDetails = true
                Global.sharedInstance.arrWorkHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
                Global.sharedInstance.serviceProviderForEdit = objServiceProvidersForEdit()
                Global.sharedInstance.serviceProvider = objServiceProviders()
                serviceProvidersForEdit = objServiceProvidersForEdit()
                return true
            }
            if Global.sharedInstance.isAllFlagsFalse == true
            {
                Global.sharedInstance.isAllFlagsFalse = false
            }
        }
        else
        {
            if checkValidity() == true && Global.sharedInstance.isAllFlagsFalse == false
            {
                Global.sharedInstance.generalDetails.arrObjServiceProviders.append(Global.sharedInstance.serviceProvider)//בשביל השליחה לשרת
                Global.sharedInstance.arrObjServiceProvidersForEdit.append(serviceProvidersForEdit)//בשביל עריכה
                Global.sharedInstance.isValidWorkerDetails = true
                Global.sharedInstance.arrWorkHoursChild =  [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
                Global.sharedInstance.serviceProviderForEdit = objServiceProvidersForEdit()
                Global.sharedInstance.serviceProvider = objServiceProviders()
                serviceProvidersForEdit = objServiceProvidersForEdit()
                return true
            }
            if Global.sharedInstance.isAllFlagsFalse == true
            {
                Global.sharedInstance.arrWorkHoursChild =  [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
                Global.sharedInstance.serviceProvider = objServiceProviders()
                return false
            }
        }
        Global.sharedInstance.isValidWorkerDetails = false
        Global.sharedInstance.arrWorkHoursChild =  [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.serviceProvider = objServiceProviders()
        return false
    }
    //MARK: - TextField
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        Global.sharedInstance.txtAdressItem3 = false
        if delegateKbBusiness != nil
        {
            // remove the keyBoard event from businessServices cell
            delegateKbBusiness.delKbNotifBusiness()
        }
        if delegateKbCalendar != nil
        {
            delegateKbCalendar.delKbCalenderNotif()
        }
        if Global.sharedInstance.didSection3Closed == true
        {
            NotificationCenter.default.addObserver(self,selector: #selector(ItemInSection3TableViewCell.keyboardWillShow(_:)),name: UIResponder.keyboardWillShowNotification,object: nil)
            NotificationCenter.default.addObserver(self,selector: #selector(ItemInSection3TableViewCell.keyboardWillHide(_:)),name: UIResponder.keyboardWillHideNotification,object: nil)
            Global.sharedInstance.didSection3Closed = false
        }
        selectedTextField = textField
        if textField == txtFirstName {
            error1.text = ""
        }
        if textField == txtPhone {
            error2.text = ""
        }
        if textField == txtMail {
            error3.text = ""
        }
        textField.textColor = UIColor.black
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFirstName
        {
            if txtFirstName.text != "" && isValidName(txtFirstName.text!) == false
            {
                error1.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            } else {
                
                let fullNameVerify = txtFirstName.text! as String
                let fullNameString = fullNameVerify
                    .components(separatedBy: " ")
                    .filter { !$0.isEmpty }
                    .joined(separator: " ")
                
                let fullNameArr = fullNameString.components(separatedBy: " ")
                //      let fullNameArr = fullNameVerify.componentsSeparatedByString(" ")
                let size = fullNameArr.count
                for a in fullNameArr {
                    print("eeeee |\(a.characters.count)|")
                }
                var firstNameVerify = ""
                var lastNameVerify = ""
                if(size > 1) {
                    let myArray : NSMutableArray = []
                    for item in fullNameArr {
                        let newString = item.replace(" ", withString:"")
                        if(newString.characters.count > 0  ) {
                            print("Found \(newString)")
                            myArray.add(newString)
                        }
                    }
                    let sizemutablearray = myArray.count
                    if(sizemutablearray > 1 ) {
                        firstNameVerify = myArray.object(at: 0) as! String
                        lastNameVerify = myArray.object(at: 1) as! String
                        self.txtLastName.text = lastNameVerify
                        self.txtFirstName.textColor = UIColor.black
                        error1.text = ""
                        self.flag_FirstName = true
                    }
                    else {
                        error1.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        self.flag_FirstName = false
                    }
                } else {
                    error1.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    self.flag_FirstName = false
                }
            }
        }
            
        else if textField == txtPhone
        {
            if txtPhone.text != ""
            {
                
                isPhoneExist()
            }
            if txtPhone.text != "" && (isValidPhone(txtPhone.text!) == false || txtPhone.text?.characters.count < 10)
            {
                error2.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            }
        }
        else if textField  == txtMail
        {
            if txtMail.text != ""
            {
                isEmailExist()
            }
            if txtMail.text != "" && isValidEmail(txtMail.text!) == false
            {
                error3.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField){
        case(txtFirstName):
            txtPhone.becomeFirstResponder()
        case(txtPhone):
            txtMail.becomeFirstResponder()
        case(txtMail):
            txtMail.resignFirstResponder()
        default:
            txtFirstName.becomeFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        startString += string
        if textField == txtPhone
        {
            if startString.characters.count > 10
            {
                Alert.sharedInstance.showAlertDelegate("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                return false
            }
            else
            {
                return true
            }
        }
        return true
    }
    func dismissKeboard()
    {
        if txtMail.isFirstResponder {
            txtMail.resignFirstResponder()
        }
        if txtPhone.isFirstResponder{
            txtPhone.resignFirstResponder()
        }
        if txtFirstName.isFirstResponder {
            txtFirstName.resignFirstResponder()
        }
    }
    //MARK: - Validation
    func checkValidity() -> Bool
    {
        dismissKeboard()
        if self.txtFirstName.text == "" || error1.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error1.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            self.flag_FirstName = false
        }
        else if txtFirstName.text!.characters.count < 3 || isValidName(txtFirstName.text!) == false ///שם פרטי
        {
            self.flag_FirstName = false
        }
        else
        {
            let fullNameVerify = txtFirstName.text! as String
            let fullNameString = fullNameVerify
                .components(separatedBy: " ")
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            
            let fullNameArr = fullNameString.components(separatedBy: " ")
            //   let fullNameArr = fullNameVerify.componentsSeparatedByString(" ")
            
            let size = fullNameArr.count
            var firstNameVerify = ""
            var lastNameVerify = ""
            if(size > 1) {
                let myArray : NSMutableArray = []
                for item in fullNameArr {
                    let newString = item.replace(" ", withString:"")
                    if(newString.characters.count > 0  ) {
                        print("Found \(newString)")
                        myArray.add(newString)
                    }
                }
                let sizemutablearray = myArray.count
                if(sizemutablearray > 1 ) {
                    firstNameVerify = myArray.object(at: 0) as! String
                    lastNameVerify = myArray.object(at: 1) as! String
                    self.txtLastName.text = lastNameVerify
                    self.txtFirstName.textColor = UIColor.black
                    error1.text = ""
                    self.flag_FirstName = true
                }
                else {
                    error1.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    self.flag_FirstName = false
                }
            } else {
                error1.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                self.flag_FirstName = false
            }
        }
        if self.txtMail.text == "" || error3.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error3.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error3.text == "MAIL_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error3.text == "EMPLOYE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error3.text ==  "EMPLOYE_EXIST_in_db".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            self.flag_Email = false
        }
        else if isValidEmail(txtMail.text!) == false
        {
            self.flag_Email = false
        }
        else
        {
            if flag_EmailInternet == false
            {
                self.flag_Email = false
            }
            else
            {
                self.flag_Email = true
            }
        }
        if self.txtPhone.text == "" || error2.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error2.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error2.text == "PHONE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE) ||  error2.text == "EMPLOYE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error2.text ==  "EMPLOYE_EXIST_in_db".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error2.text ==  "CANNOT_USE_OWN_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            self.flag_Phone = false
        }
        else if isValidPhone(txtPhone.text!) == false || txtPhone.text?.characters.count < 10
        {
            self.flag_Phone = false
        }
        else
        {
            if flag_PhoneInternet == false
            {
                self.flag_Phone = false
            }
            else
            {
                self.flag_Phone = true
            }
        }
        if flag_Email == true && flag_Phone == true && flag_FirstName == true /* && flag_LastName == true */
        {
            Global.sharedInstance.isAllFlagsFalse = false
            return true
        }
        if error3.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) && error2.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) && error1.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)  /*&& txtLastName.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) */
            && Global.sharedInstance.isFromEdit == false && Global.sharedInstance.isOpenHours == false
        {
            Global.sharedInstance.isAllFlagsFalse = true
            flag_Email = true
            flag_Phone = true
            flag_FirstName = true
            txtFirstName.textColor = UIColor.black
            txtMail.textColor = UIColor.black
            txtPhone.textColor = UIColor.black
            
            return true
        }
        Global.sharedInstance.isAllFlagsFalse = false
        return false
    }
    func isValidName(_ input: String) -> Bool {
        var numSpace = 0
        for chr in input.characters {
         if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr >= "א" && chr <= "ת") && !(chr >= "0" && chr <= "9") && chr != " " && chr != "’" && chr != "‘"  && chr != "“" && chr != "'" && chr != "\"" && chr != "”" && chr != "“" && chr != "”" && chr != "׳" && (input.isRussiantext(title: input) == false) ) {
                return false
            }
            if chr == " "
            {
                numSpace += 1
            }
        }
        if numSpace == input.characters.count || numSpace == input.characters.count - 1
        {
            return false
        }
        return true
    }
    
    func isValidPhone(_ input: String) -> Bool {
        if input.characters.count > 2 {
            let index0 = input.characters.index(input.startIndex, offsetBy: 0)
            let index1 = input.characters.index(input.startIndex, offsetBy: 1)
            if input.characters[index0] != "0" || input.characters[index1] != "5"{
                return false
            }
            for chr in input.characters {
                if (!(chr >= "0" && chr <= "9") && !(chr == "-"))  {
                    return false
                }
            }
        }
        return true
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    //for scrolling the table up, on begin editing textField, to show it above the keyBoard
    @objc func keyboardWillShow(_ note: Notification) {
        if Global.sharedInstance.isFirstOpenKeyBoard == false
        {
            Global.sharedInstance.isFirstOpenKeyBoard = true
            if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if delegateScroll != nil
                {
                    //       delegateScroll.scrollOnEdit(keyboardSize,textField: selectedTextField!)
                }
                else
                {
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                    Global.sharedInstance.didSection3Closed = true
                }
                Global.sharedInstance.isFirstCloseKeyBoard = false
            }
        }
    }
    //for scrolling the table down, after editing textField
    @objc func keyboardWillHide(_ note: Notification) {
        if Global.sharedInstance.isFirstCloseKeyBoard == false
        {
            Global.sharedInstance.isFirstCloseKeyBoard = true
            if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if delegateScroll != nil
                {
                    //        delegateScroll.scrollOnEndEdit(keyboardSize)
                }
                else
                {
                    // remove the keyBoard events - Notifications
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                    Global.sharedInstance.didSection3Closed = true
                }
                Global.sharedInstance.isFirstOpenKeyBoard = false
            }
        }
    }
    // remove the keyBoard events to prevent invoke the events from other cells
    func delKbNotification()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        Global.sharedInstance.didSection3Closed = true
    }
    
    func saveDataToWorker() -> Bool
    {
        error1.text = ""
        error2.text = ""
        error3.text = ""
        self.txtMail.isUserInteractionEnabled = true
        self.txtPhone.isUserInteractionEnabled = true
        self.txtFirstName.isUserInteractionEnabled = true
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 && self.IuserStatus == 24{
            self.txtMail.isUserInteractionEnabled = false
            self.txtPhone.isUserInteractionEnabled = false
            self.txtFirstName.isUserInteractionEnabled = false
        }
        
        if saveData() == true
        {
            resetPropertiesForNewWorkerHours()
            delegateSave.reloadTableForSave(2,btnTag: self.sectionCell)
            Global.sharedInstance.fisValidWorker = true
            return true
        }
        else
        {
            resetPropertiesForNewWorkerHours()
            if Global.sharedInstance.isAllFlagsFalse == true && Global.sharedInstance.isOpenNewWorker == true {
                delegateSave.reloadTableForSave(-200,btnTag: -200)
            }
            
            Global.sharedInstance.fisValidWorker = false
            return true
        }
    }
    func saveHoursToWorker()
    {
        var workingHours = objWorkingHours()
        Global.sharedInstance.serviceProviderForEdit = objServiceProvidersForEdit()
        for i in 0 ..< Global.sharedInstance.arrWorkHoursChild.count {
            if Global.sharedInstance.isHoursSelectedRestChild[i]
            {
                let workingHoursEdit = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType,
                                                       _nvFromHour: Global.sharedInstance.arrWorkHoursChild[i].nvFromHour,
                                                       _nvToHour: Global.sharedInstance.arrWorkHoursChild[i].nvToHour)
                if workingHoursEdit.iDayInWeekType != 0 && workingHoursEdit.nvFromHour != "" && workingHoursEdit.nvToHour != ""
                {
                    Global.sharedInstance.serviceProviderForEdit.arrObjWorkingHours[i] = workingHoursEdit//בשביל עריכה
                }
                let workingHoursEditRest = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHoursRestChild[i].iDayInWeekType,
                                                           _nvFromHour: Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour,
                                                           _nvToHour: Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour)
                if workingHoursEditRest.iDayInWeekType != 0 && workingHoursEditRest.nvFromHour != "" && workingHoursEditRest.nvToHour != ""
                {
                    Global.sharedInstance.serviceProviderForEdit.arrObjWorkingRest[i] = workingHoursEditRest//בשביל עריכה
                }
                
                workingHours = objWorkingHours(
                    _iDayInWeekType: Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType,
                    _nvFromHour: Global.sharedInstance.arrWorkHoursChild[i].nvFromHour,
                    _nvToHour: Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour)
                Global.sharedInstance.serviceProvider.arrObjWorkingHours.append(workingHours)
                //--------------
                workingHours = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType,
                                               _nvFromHour: Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour,
                                               _nvToHour: Global.sharedInstance.arrWorkHoursChild[i].nvToHour)
                Global.sharedInstance.serviceProvider.arrObjWorkingHours.append(workingHours)
            }
            else
            {
                workingHours = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType,
                                               _nvFromHour: Global.sharedInstance.arrWorkHoursChild[i].nvFromHour,
                                               _nvToHour: Global.sharedInstance.arrWorkHoursChild[i].nvToHour)
                if workingHours.iDayInWeekType != 0 && workingHours.nvFromHour != "" && workingHours.nvToHour != ""
                {
                    Global.sharedInstance.serviceProvider.arrObjWorkingHours.append(workingHours)
                }
                let workingHoursEdit = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType,
                                                       _nvFromHour: Global.sharedInstance.arrWorkHoursChild[i].nvFromHour,
                                                       _nvToHour: Global.sharedInstance.arrWorkHoursChild[i].nvToHour)
                if workingHoursEdit.iDayInWeekType != 0 && workingHoursEdit.nvFromHour != "" && workingHoursEdit.nvToHour != ""
                {
                    Global.sharedInstance.serviceProviderForEdit.arrObjWorkingHours[i] = workingHoursEdit//בשביל עריכה
                }
            }
        }
    }
    
    func resetPropertiesForNewWorkerHours()
    {
        if Global.sharedInstance.addRecess == true
        {
            Global.sharedInstance.GlobalDataVC!.delegateEnabledBtnDays.enabledTrueBtnDays()
        }
        Global.sharedInstance.isSelectAllRestChild = false
        Global.sharedInstance.isSelectAllHoursChild = false
        Global.sharedInstance.addRecess = false
        Global.sharedInstance.isHoursSelectedChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRestChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.currentBtnDayTagChild = -1
        Global.sharedInstance.currentBtnDayTagRestChild = -1
        Global.sharedInstance.lastBtnDayTagChild = -1
        Global.sharedInstance.lastBtnDayTagRestChild = -1
        Global.sharedInstance.arrWorkHoursRestChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    }
    func isPhoneExist()
    {
        //txtPhone.text
        let phonenumber = txtPhone.text
        let myuserphonenumber = Global.sharedInstance.currentUser.nvPhone
        if phonenumber == myuserphonenumber {
        self.error2.text = "CANNOT_USE_OWN_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        } else {
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dictionaryForServer["nvPhone"] = txtPhone.text as AnyObject
        delegateGeneric.showGeneric()
        if Reachability.isConnectedToNetwork() == false//if there is connection
        {
            delegateGeneric.hideGeneric()
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            self.flag_EmailInternet = false
        }
        else
        {
            delegateGeneric.showGeneric()
            if Reachability.isConnectedToNetwork() == false
            {
                delegateGeneric.hideGeneric()
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                self.flag_EmailInternet = false
            }
            else
            {
                api.sharedInstance.GetEmployeeDataByPhone(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                self.flag_Phone = false
                                self.error2.text = "EMPLOYE_EXIST_in_db".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            } else {
                                let myemployes :Array<objServiceProviders> = Global.sharedInstance.generalDetails.arrObjServiceProviders
                                for servPro:objServiceProviders in myemployes {
                                    if servPro.objsers.nvPhone == self.txtPhone.text {
                                        self.flag_Phone = false
                                        self.error2.text = "EMPLOYE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                        self.flag_Phone = false
                                    } else {
                                        if self.selfPhoneExist != self.txtPhone.text
                                        {
                                            self.flag_Phone = true
                                        }
                                    }
                                }
                            }
                           
                        }
                    }
                    self.isSetData = false
                    self.delegateGeneric.hideGeneric()
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                })
            }
        }
        }
    }
    func isEmailExist()
    {
        delegateGeneric.showGeneric()
        if Reachability.isConnectedToNetwork() == false//if there is connection
        {
            delegateGeneric.hideGeneric()
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            self.flag_EmailInternet = false
        }
        else
        {
            var dictonaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dictonaryForServer["nvMail"] = txtMail.text as AnyObject
            delegateGeneric.showGeneric()
            if Reachability.isConnectedToNetwork() == false
            {
                delegateGeneric.hideGeneric()
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                self.flag_EmailInternet = false
            }
            else
            {
                api.sharedInstance.GetEmployeeDataByEmail(dictonaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                self.flag_Email = false
                                self.error3.text = "EMPLOYE_EXIST_in_db".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            } else {
                                let myemployes :Array<objServiceProviders> = Global.sharedInstance.generalDetails.arrObjServiceProviders
                                for servPro:objServiceProviders in myemployes {
                                    if servPro.objsers.nvMail == self.txtMail.text {
                                        self.error2.text = "EMPLOYE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                        self.flag_Email = false
                                    } else {
                                        if self.selfEmailExist != self.txtMail.text
                                        {
                                            self.flag_Email = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.isSetData = false
                    self.delegateGeneric.hideGeneric()
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                })
            }
        }
    }
}
extension String
{
    func replace(_ target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
