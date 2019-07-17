//
//  SupplierSettingsCalendar.swift
//  Bthere
//  nefacut
//  Created by Ioan Ungureanu on 14.08.2017
//  Copyright © 2017 BThere. All rights reserved.
//  Updated on 13.02.2018

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

class SupplierSettingsCalendar: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate {
    var arrayDesigned = ["DESIGN_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                         //"DESIGN_WEEK".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                         "DESIGN_MONTH".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var currentUserToEdit:User = User()
    var supplierID = 0
    var generic:Generic = Generic()
    var bLimitSeries:Bool = false
    var iFirstCalendarViewType:Int = 0
    var iMaxServiceForCustomer:Int = 0
    var iPeriodInWeeksForMaxServices:Int = 0
    var iCustomerViewLimit:Int = 0
    var bIsAvailableForNewCustomer:Bool = true
    var iHoursForPreCancelServiceByCustomer = 0
    @IBOutlet weak var btnIn: UIButton!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnOpenTbl: UIButton!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var btnSelect: CheckBoxForExistSupplierOk!
    @IBOutlet weak var btnNoSelect: CheckBoxForExistSupplierCancel!
    @IBOutlet weak var btnSelect1: CheckBoxForExistSupplierOk!
    @IBOutlet weak var btnNoSelect1: CheckBoxForExistSupplierCancel!
    @IBOutlet weak var btnSelect2: CheckBoxForExistSupplierOk!
    @IBOutlet weak var btnNoSelect2: CheckBoxForExistSupplierCancel!
    @IBOutlet weak var btnSelect3: CheckBoxForExistSupplierOk!
    @IBOutlet weak var btnNoSelect3: CheckBoxForExistSupplierCancel!
    @IBOutlet weak var Calendarview: UILabel!
    @IBOutlet weak var Customerviewrange:UILabel!
    @IBOutlet weak var ADDING_NEW_CUSTOMERS:UILabel!
    @IBOutlet weak var APPOINTMENT_CANCEL_IMPOSSIBLE:UILabel!
    @IBOutlet weak var lblDesignCalendar: UILabel!
    @IBOutlet weak var numberofweeks: UITextField!
    @IBOutlet weak var syncwithmycalendar: UILabel!
    @IBOutlet weak var tblSelectDesigned: UITableView!
    @IBOutlet weak var titlescreen: UILabel!
    @IBOutlet weak var viewSync: UIView!
    @IBOutlet weak var view2:UIView!
    @IBOutlet weak var view3:UIView!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var lblDoWantLimit: UILabel!
    @IBOutlet weak var lblNumAppointmets: UILabel!
    @IBOutlet weak var lblDuringTurns: UILabel!
    @IBOutlet weak var txtMaxServiceForCustomer: UITextField!
    @IBOutlet weak var txtPeriodInWeeksForMaxServices: UITextField!
    @IBOutlet weak var VIEWlimitnumberofAppointments: UIView!
    @IBOutlet weak var dyanmicrowHEIGHT: NSLayoutConstraint! //limitnumberofAppointments height


    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss()
    }
    @IBAction func btnSelectAction1(_ sender: AnyObject) {
        if(btnSelect1.isCecked == true)
        {
            showpopup(_whichtext: 1)
            btnSelect1.isCecked = false
            btnNoSelect1.isCecked = true
            bIsAvailableForNewCustomer = false
        }
        else
        {
            btnSelect1.isCecked = true
            btnNoSelect1.isCecked = false
           bIsAvailableForNewCustomer = true
        }

    }
    @IBAction func btnSelectAction2(_ sender: AnyObject) {
        if(btnSelect2.isCecked == true)
        {
            btnSelect2.isCecked = false
            btnNoSelect2.isCecked = true
            iHoursForPreCancelServiceByCustomer = 0
        }
        else
        {
            showpopup(_whichtext: 2)
            btnSelect2.isCecked = true
            btnNoSelect2.isCecked = false
            iHoursForPreCancelServiceByCustomer = 1
        }

    }
    @IBAction func btnNoSelectAction1(_ sender: AnyObject) {
        if(btnNoSelect1.isCecked == true)
        {

            btnNoSelect1.isCecked = false
            btnSelect1.isCecked = true
            bIsAvailableForNewCustomer = true
        }
        else
        {
            showpopup(_whichtext: 1)
            btnNoSelect1.isCecked = true
            btnSelect1.isCecked = false
            bIsAvailableForNewCustomer = false
        }

    }
    @IBAction func btnNoSelectAction2(_ sender: AnyObject) {

        if(btnNoSelect2.isCecked == true)
        {
            showpopup(_whichtext: 2)
            btnNoSelect2.isCecked = false
            btnSelect2.isCecked = true
            iHoursForPreCancelServiceByCustomer = 1
        }
        else
        {
            btnNoSelect2.isCecked = true
            btnSelect2.isCecked = false
            iHoursForPreCancelServiceByCustomer = 0
        }

    }
    func showpopup(_whichtext:Int) {
        let newlistservices = UIStoryboard(name: "newlistservices", bundle: nil)
        let viewCon:ExplainPopUp24HoursViewController = newlistservices.instantiateViewController(withIdentifier: "ExplainPopUp24HoursViewController") as! ExplainPopUp24HoursViewController
        viewCon._whichtext = _whichtext
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }

    
    @IBAction func btnSelectAction(_ sender: AnyObject) {
        if(btnSelect.isCecked == true)
        {
            btnSelect.isCecked = false
            btnNoSelect.isCecked = true
            currentUserToEdit.bIsGoogleCalendarSync = false
        }
        else
        {
            btnSelect.isCecked = true
            btnNoSelect.isCecked = false
            currentUserToEdit.bIsGoogleCalendarSync = true
        }
    }
    
    @IBAction func btnNoSelectAction(_ sender: AnyObject) {
        if(btnNoSelect.isCecked == true)
        {
            btnNoSelect.isCecked = false
            btnSelect.isCecked = true
            currentUserToEdit.bIsGoogleCalendarSync = true
        }
        else
        {
            btnNoSelect.isCecked = true
            btnSelect.isCecked = false
            currentUserToEdit.bIsGoogleCalendarSync = false
        }
    }
    
    func dismiss(){
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        frontviewcontroller!.pushViewController(viewcon, animated: false)
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
    func hidetoast(){
        view.hideToastActivity()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func GetProviderSettingsForCalendarmanagement() {
        let USERDEF = UserDefaults.standard
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        self.supplierID = providerID
        
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dicSearch["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    print("responseObject \(responseObject ??  1 as AnyObject)")
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                let possiblerezult:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                let checked_checkboxOK = UIImage(named: "okSelected.png")
                                let unChecked_checkboxOK = UIImage(named: "ok_unSelected.png")
                                let checked_checkbox = UIImage(named: "Cancel-selected.png")
                                let unChecked_checkbox = UIImage(named: "Cancel_unSelected.png")
                                if let _:Bool = possiblerezult["bLimitSeries"] as? Bool {
                                    self.bLimitSeries = possiblerezult["bLimitSeries"] as! Bool

                                    if self.bLimitSeries == true {
                                        self.btnSelect3.isSelected = true
                                        self.btnNoSelect3.isSelected = false
                                        self.btnSelect3.setImage(checked_checkboxOK, for:UIControl.State())
                                        self.btnNoSelect3.setImage(unChecked_checkbox, for:UIControl.State())
                                        self.dyanmicrowHEIGHT.constant = 200
                                            if let _:Int = possiblerezult["iMaxServiceForCustomer"] as? Int {
                                                self.iMaxServiceForCustomer = possiblerezult["iMaxServiceForCustomer"] as! Int

                                                self.txtMaxServiceForCustomer.text = String(self.iMaxServiceForCustomer)

                                        }
                                            if let _:Int = possiblerezult["iPeriodInWeeksForMaxServices"] as? Int {
                                                self.iPeriodInWeeksForMaxServices = possiblerezult["iPeriodInWeeksForMaxServices"] as! Int
                                                self.txtPeriodInWeeksForMaxServices.text = String(self.iPeriodInWeeksForMaxServices)

                                            }

                                    } else {
                                        self.dyanmicrowHEIGHT.constant = 95
                                        self.btnSelect3.isSelected = false
                                        self.btnNoSelect3.isSelected = true
                                        self.btnSelect3.setImage(unChecked_checkboxOK, for:UIControl.State())
                                        self.btnNoSelect3.setImage(checked_checkbox, for:UIControl.State())
                                        self.txtPeriodInWeeksForMaxServices.text = ""
                                        self.txtMaxServiceForCustomer.text = ""

                                    }
                                }
                                if let _:Int = possiblerezult["iFirstCalendarViewType"] as? Int {
                                    self.iFirstCalendarViewType = possiblerezult["iFirstCalendarViewType"] as! Int
                                }
                                if let _:Bool = possiblerezult["bIsGoogleCalendarSync"] as? Bool {
                                    let myint:Bool =  possiblerezult["bIsGoogleCalendarSync"] as! Bool

                                    if myint == true {
                                        self.currentUserToEdit.bIsGoogleCalendarSync = true
                                        self.btnSelect.isSelected = true
                                        self.btnNoSelect.isSelected = false
                                        self.btnSelect.setImage(checked_checkboxOK, for:UIControl.State())
                                        self.btnNoSelect.setImage(unChecked_checkbox, for:UIControl.State())
                                    } else {
                                        self.currentUserToEdit.bIsGoogleCalendarSync = false
                                        self.btnSelect.isSelected = false
                                        self.btnNoSelect.isSelected = true
                                        self.btnSelect.setImage(unChecked_checkboxOK, for:UIControl.State())
                                        self.btnNoSelect.setImage(checked_checkbox, for:UIControl.State())
                                    }
                                }
                                if let _:Bool = possiblerezult["bIsAvailableForNewCustomer"] as? Bool {
                                    let myint:Bool =  possiblerezult["bIsAvailableForNewCustomer"] as! Bool

                                    if myint == true {
                                        self.bIsAvailableForNewCustomer = true
                                        self.btnSelect1.isSelected = true
                                        self.btnNoSelect1.isSelected = false
                                        self.btnSelect1.setImage(checked_checkboxOK, for:UIControl.State())
                                        self.btnNoSelect1.setImage(unChecked_checkbox, for:UIControl.State())
                                    } else {
                                        self.bIsAvailableForNewCustomer = false
                                        self.btnSelect1.isSelected = false
                                        self.btnNoSelect1.isSelected = true
                                        self.btnSelect1.setImage(unChecked_checkboxOK, for:UIControl.State())
                                        self.btnNoSelect1.setImage(checked_checkbox, for:UIControl.State())
                                    }
                                }
                                if let _:Int = possiblerezult["iHoursForPreCancelServiceByCustomer"] as? Int {
                                    let myint:Int =  possiblerezult["iHoursForPreCancelServiceByCustomer"] as! Int

                                    if myint == 1 {
                                        self.iHoursForPreCancelServiceByCustomer = 1
                                        self.btnSelect2.isSelected = true
                                        self.btnNoSelect2.isSelected = false
                                        self.btnSelect2.setImage(checked_checkboxOK, for:UIControl.State())
                                        self.btnNoSelect2.setImage(unChecked_checkbox, for:UIControl.State())
                                    } else {
                                        self.iHoursForPreCancelServiceByCustomer = 0
                                        self.btnSelect2.isSelected = false
                                        self.btnNoSelect2.isSelected = true
                                        self.btnSelect2.setImage(unChecked_checkboxOK, for:UIControl.State())
                                        self.btnNoSelect2.setImage(checked_checkbox, for:UIControl.State())
                                    }
                                }
                                //
                                
                                if self.iFirstCalendarViewType == 0
                                {
                                    self.btnIn.setTitle(self.arrayDesigned[0], for: UIControl.State()) //day
                                }
                                else if self.iFirstCalendarViewType == 2
                                {
                                    self.btnIn.setTitle(self.arrayDesigned[1], for: UIControl.State()) //month
                                }
                                    //hide week view
//                                else if self.iFirstCalendarViewType == 1 {
//                                    self.btnIn.setTitle(self.arrayDesigned[1], for: UIControlState()) //week
//                                }
                                else if self.iFirstCalendarViewType == 1 {
                                    self.btnIn.setTitle(self.arrayDesigned[0], for: UIControl.State()) //day again
                                }
                                self.currentUserToEdit.iCalendarViewType = self.iFirstCalendarViewType
                                if let _:Bool = possiblerezult["bLimitSeries"] as? Bool {
                                    self.bLimitSeries = possiblerezult["bLimitSeries"] as! Bool
                                }
                                if self.bLimitSeries == false { //defaults 26 in 52 weeks...means multiple once
                                    self.iMaxServiceForCustomer = 26
                                    self.iPeriodInWeeksForMaxServices = 52
                                } else {
                                    if let _:Int = possiblerezult["iMaxServiceForCustomer"] as? Int {
                                        self.iMaxServiceForCustomer = possiblerezult["iMaxServiceForCustomer"] as! Int
                                        if self.iMaxServiceForCustomer == 0 {
                                            self.iMaxServiceForCustomer = 3
                                        }
                                    } else {
                                        self.iMaxServiceForCustomer = 3
                                    }
                                    //                                    var  calset:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                    //                                    calset = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties.getDic()
                                    //                                    print(") what cal \(calset)")
                                    //                                    if let _:Int = calset["iPeriodInWeeksForMaxServices"] as? Int {
                                    //                                       self.iPeriodInWeeksForMaxServices = calset["iPeriodInWeeksForMaxServices"] as! Int
                                    //                                            if  self.iPeriodInWeeksForMaxServices == 0 {
                                    //                                                self.iPeriodInWeeksForMaxServices  = 6
                                    //                                            }
                                    //                                        }
                                    //                                    else {
                                    if let _:Int = possiblerezult["iPeriodInWeeksForMaxServices"] as? Int {
                                        self.iPeriodInWeeksForMaxServices = possiblerezult["iPeriodInWeeksForMaxServices"] as! Int
                                        if  self.iPeriodInWeeksForMaxServices == 0 {
                                            self.iPeriodInWeeksForMaxServices  = 6
                                        }
                                    } else {
                                        self.iPeriodInWeeksForMaxServices = 6
                                    }
                                    //                                    }
                                }
                                
                                if let _:Int = possiblerezult["iCustomerViewLimit"] as? Int {
                                    self.iCustomerViewLimit = possiblerezult["iCustomerViewLimit"] as! Int
                                }
                                if self.iCustomerViewLimit == 0 {
                                    self.iCustomerViewLimit = 52
                                }
                                if let _:Bool = possiblerezult["bIsAvailableForNewCustomer"] as? Bool {
                                    let myint:Bool =  possiblerezult["bIsAvailableForNewCustomer"] as! Bool
                                    if myint == true {
                                        self.bIsAvailableForNewCustomer = true
                                    } else {
                                        self.bIsAvailableForNewCustomer = false
                                    }
                                }
                                if let _:Int = possiblerezult["iHoursForPreCancelServiceByCustomer"] as? Int {
                                    let myint:Int =  possiblerezult["iHoursForPreCancelServiceByCustomer"] as! Int
                                    if myint == 1 {
                                        self.iHoursForPreCancelServiceByCustomer = 1
                                    } else {
                                        self.iHoursForPreCancelServiceByCustomer = 0
                                    }
                                }
                                USERDEF.set(self.iCustomerViewLimit, forKey: "CALENDARWEEKSFORSUPPLIER")
                                USERDEF.set(self.iMaxServiceForCustomer, forKey: "MAXSERVICEFORCUSTOMER")
                                USERDEF.set(self.iPeriodInWeeksForMaxServices , forKey: "WEEKSFORSUPPLIER")
                                USERDEF.set(self.bIsAvailableForNewCustomer, forKey: "bIsAvailableForNewCustomer")
                                USERDEF.set(self.iHoursForPreCancelServiceByCustomer, forKey: "iHoursForPreCancelServiceByCustomer")
                                USERDEF.synchronize()
                                self.numberofweeks.text = self.iCustomerViewLimit.description
                                
                            }
                        } else {
                            //error user not found
                            self.SETUPDEFAULTSINCASEOFFAILURE()
                            
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                self.SETUPDEFAULTSINCASEOFFAILURE()
            })
        }
    }    
    func SETUPDEFAULTSINCASEOFFAILURE() {
        if Global.sharedInstance.currentUser.iCalendarViewType == 0
        {
            self.btnIn.setTitle(self.arrayDesigned[0], for: UIControl.State()) //day
        }
        else if Global.sharedInstance.currentUser.iCalendarViewType == 2
        {
            self.btnIn.setTitle(self.arrayDesigned[1], for: UIControl.State()) //month
        }
            //hide week view
//        else if Global.sharedInstance.currentUser.iCalendarViewType == 1 {
//            self.btnIn.setTitle(self.arrayDesigned[1], for: UIControlState()) //week
//        }
        else if Global.sharedInstance.currentUser.iCalendarViewType == 1
        {
            self.btnIn.setTitle(self.arrayDesigned[0], for: UIControl.State()) //day again
        }
        self.currentUserToEdit.iCalendarViewType = Global.sharedInstance.currentUser.iCalendarViewType
        let USERDEF = UserDefaults.standard
        self.iMaxServiceForCustomer = 3
        self.iPeriodInWeeksForMaxServices = 6
        self.iCustomerViewLimit = 52
        USERDEF.set(self.iCustomerViewLimit, forKey: "CALENDARWEEKSFORSUPPLIER")
        USERDEF.set(self.iMaxServiceForCustomer, forKey: "MAXSERVICEFORCUSTOMER")
        USERDEF.set(self.iPeriodInWeeksForMaxServices , forKey: "WEEKSFORSUPPLIER")
        USERDEF.synchronize()
        self.numberofweeks.text = USERDEF.object(forKey: "CALENDARWEEKSFORSUPPLIER") as? String
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:51)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dyanmicrowHEIGHT.constant = 95
        self.VIEWlimitnumberofAppointments.setNeedsLayout()
        self.VIEWlimitnumberofAppointments.setNeedsDisplay()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        numberofweeks.delegate = self
        self.view.addGestureRecognizer(tap)
        Colors.sharedInstance.addTopAndBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: viewSync)
       //    Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: view2)
        //   Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: view3)
        btnsave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        titlescreen.text =  "MANAGE_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        syncwithmycalendar.text  =  "SYNC_MY_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        Calendarview.text =  "CALENDAR_VIEW".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        Customerviewrange.text =  "CUSTOMER_RANGE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ADDING_NEW_CUSTOMERS.text = "ADDING_NEW_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        APPOINTMENT_CANCEL_IMPOSSIBLE.text = "APPOINTMENT_CANCEL_IMPOSSIBLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblDoWantLimit.text = "LIMIT_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblNumAppointmets.text = "NUM_TURNS_MEETINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblDuringTurns.text = "DURATION_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        txtMaxServiceForCustomer.delegate = self
        txtPeriodInWeeksForMaxServices.delegate = self
        txtMaxServiceForCustomer.text = ""
        txtPeriodInWeeksForMaxServices.text = ""
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnback.transform = scalingTransform
            self.backImg.transform = scalingTransform
        }
        self.view.bringSubviewToFront(btnback)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            numberofweeks.textAlignment = .right
            btnIn.contentHorizontalAlignment = .right
            lblDoWantLimit.textAlignment = .right
            lblNumAppointmets.textAlignment = .right
            lblDuringTurns.textAlignment = .right
        } else {
            numberofweeks.textAlignment = .left
            btnIn.contentHorizontalAlignment = .left
            lblDoWantLimit.textAlignment = .left
            lblNumAppointmets.textAlignment = .left
            lblDuringTurns.textAlignment = .left
        }
        
        tblSelectDesigned.delegate = self
        tblSelectDesigned.dataSource = self
        tblSelectDesigned.separatorStyle = .none
        tblSelectDesigned.isHidden = true
      
        GetProviderSettingsForCalendarmanagement()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDesigned.count // 3 rows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "DescDesignTableViewCell")as!DescDesignTableViewCell
        cell.selectionStyle = .none
        cell.setDisplayData(arrayDesigned[indexPath.row])
        if indexPath.row == 1 {
            cell.viewButtom.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnIn.setTitle(arrayDesigned[indexPath.row], for: UIControl.State())
        tblSelectDesigned.isHidden = true
        btnIn.tag = 0
        let stringSelected = (tableView.cellForRow(at: indexPath) as! DescDesignTableViewCell).desc.text!
        let indexsearch = arrayDesigned.index(of: stringSelected)
        let intsarray = [0,2]
        currentUserToEdit.iCalendarViewType = intsarray[indexsearch!]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return tblSelectDesigned.frame.size.height/2
    }
    
    @IBAction func btnOpenTable(_ sender: UIButton) {
        if sender.tag == 0{
            tblSelectDesigned.isHidden = false
            sender.tag = 1
        }
        else{
            tblSelectDesigned.isHidden = true
            sender.tag = 0
        }
    }

        @IBAction func btnsave(_ sender: UIButton) {
            let checked_checkboxOK = UIImage(named: "okSelected.png")
            let unChecked_checkboxOK = UIImage(named: "ok_unSelected.png")
            let checked_checkbox = UIImage(named: "Cancel-selected.png")
            let unChecked_checkbox = UIImage(named: "Cancel_unSelected.png")
            var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            var providerID:Int = 0
            if Global.sharedInstance.providerID == 0 {
                providerID = 0
                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                    providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                }
            } else {
                providerID = Global.sharedInstance.providerID
            }
      if self.numberofweeks.text?.count > 0 {
                dicSearch["iProviderId"] = providerID as AnyObject
              //  dicSearch["iPeriodInWeeksForMaxServices"] =  self.numberofweeks.text as AnyObject
                dicSearch["iCustomerViewLimit"] =  self.numberofweeks.text as AnyObject
                var ischeck:Bool = false
                if self.btnSelect.isSelected == true {
                    ischeck = true
                }
                if self.btnNoSelect.isSelected == true {
                    ischeck = false
                }
                if self.btnNoSelect.isSelected == false && self.btnSelect.isSelected == false {
                    ischeck = false
                }
                Global.sharedInstance.currentUser.bIsGoogleCalendarSync = ischeck
                print("supplier settings calendar \(Global.sharedInstance.currentUser.bIsGoogleCalendarSync)")
                dicSearch["bLimitSeries"] = self.bLimitSeries as AnyObject
            var isValidMaxServiceForCustomer:Bool = false
          var isValidPeriodInWeeksForMaxServices:Bool = false
        if txtMaxServiceForCustomer.text == "0" && self.bLimitSeries == true || txtMaxServiceForCustomer.text == "" && self.bLimitSeries == true || txtMaxServiceForCustomer.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            isValidMaxServiceForCustomer = false
        }
        else
        {
            if let _ = Int(txtMaxServiceForCustomer.text!) {
                isValidMaxServiceForCustomer = true
            }
        }

        if txtPeriodInWeeksForMaxServices.text == "0" && self.bLimitSeries == true || txtPeriodInWeeksForMaxServices.text == "" && self.bLimitSeries == true || txtPeriodInWeeksForMaxServices.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            isValidPeriodInWeeksForMaxServices = false
        }
        else
        {
            if let _ = Int(txtPeriodInWeeksForMaxServices.text!) {
            isValidPeriodInWeeksForMaxServices = true
            }
        }

        if  isValidMaxServiceForCustomer == true && isValidPeriodInWeeksForMaxServices == true
        {

          self.bLimitSeries = true
        }
        else
        {
            self.bLimitSeries = false
            self.dyanmicrowHEIGHT.constant = 95
            self.btnSelect3.isSelected = false
            self.btnNoSelect3.isSelected = true
            self.btnSelect3.setImage(unChecked_checkboxOK, for:UIControl.State())
            self.btnNoSelect3.setImage(checked_checkbox, for:UIControl.State())
            self.txtPeriodInWeeksForMaxServices.text = ""
            self.txtMaxServiceForCustomer.text = ""

        }

                if self.bLimitSeries == false {
                 dicSearch["iMaxServiceForCustomer"] = 0 as AnyObject
                 dicSearch["iPeriodInWeeksForMaxServices"] = 0 as AnyObject

                } else {
                    let myint1 = Int(txtMaxServiceForCustomer.text!)
                    let myint2 = Int(txtPeriodInWeeksForMaxServices.text!)
                    dicSearch["iMaxServiceForCustomer"] = myint1 as AnyObject
                    dicSearch["iPeriodInWeeksForMaxServices"] = myint2 as AnyObject
        }
                dicSearch["bLimitSeries"] = bLimitSeries as AnyObject
                dicSearch["bIsGoogleCalendarSync"] = self.currentUserToEdit.bIsGoogleCalendarSync as AnyObject
                dicSearch["iFirstCalendarViewType"] = self.currentUserToEdit.iCalendarViewType as AnyObject
                dicSearch["bIsAvailableForNewCustomer"] = self.bIsAvailableForNewCustomer as AnyObject
                dicSearch["iHoursForPreCancelServiceByCustomer"] = self.iHoursForPreCancelServiceByCustomer as AnyObject
                print("aicie \(Global.sharedInstance.providerID)")
                if Reachability.isConnectedToNetwork() == false
                {
//                    showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else
                {
                    api.sharedInstance.SetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            print("mz RESPONSEOBJECT \(RESPONSEOBJECT)")
                           if let myre:Int = RESPONSEOBJECT["Result"] as? Int {
                            let USERDEF = UserDefaults.standard
                            if USERDEF.object(forKey: "iFirstCalendarViewType") != nil {
                            print(USERDEF.integer(forKey: "iFirstCalendarViewType"))
                            USERDEF.removeObject(forKey: "iFirstCalendarViewType")
                            USERDEF.synchronize()
                            }
                            if myre == 1 {
                                Global.sharedInstance.currentUser.bIsGoogleCalendarSync = ischeck
                                self.view.makeToast(message: "WEEKS_SAVED".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()
                                })
                            }
                        }
                        }
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
    
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    })
                }
            } else {
                self.view.makeToast(message: "COMPLETE_NUMBER_OF_WEEKS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    self.hidetoast()
                })
            }
        }
    

    @objc func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == numberofweeks || textField == txtPeriodInWeeksForMaxServices
        {
            if let _:Int = textField.text?.integerValue
            {
                if textField.text!.integerValue > 104
                {
                    textField.text = "0"
                    self.showAlertDelegateX("NUMBER_CHR_RANGE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                
                else if textField.text![0] == "0"
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

        }
    }
    @IBAction func btnSelectAction3(_ sender: AnyObject) {
        if(btnSelect3.isCecked == true)
        {
            self.bLimitSeries = false
            btnSelect3.isCecked = false
            btnNoSelect3.isCecked = true
            txtMaxServiceForCustomer.text = ""
            txtPeriodInWeeksForMaxServices.text = ""
            dyanmicrowHEIGHT.constant = 95
            self.VIEWlimitnumberofAppointments.setNeedsLayout()
            self.VIEWlimitnumberofAppointments.setNeedsDisplay()
        }
        else
        {
            btnSelect3.isCecked = true
            btnNoSelect3.isCecked = false
            if txtMaxServiceForCustomer.text == ""
            {
                txtMaxServiceForCustomer.text = "3"

            }
            if txtPeriodInWeeksForMaxServices.text == ""
            {
                txtPeriodInWeeksForMaxServices.text = "6"
            }
            self.bLimitSeries = true
            dyanmicrowHEIGHT.constant = 200
            self.VIEWlimitnumberofAppointments.setNeedsLayout()
            self.VIEWlimitnumberofAppointments.setNeedsDisplay()
        }

    }
    @IBAction func btnNoSelectAction3(_ sender: AnyObject) {

        if(btnNoSelect3.isCecked == true)
        {
            btnNoSelect3.isCecked = false
            btnSelect3.isCecked = true
            if txtMaxServiceForCustomer.text == ""
            {
                txtMaxServiceForCustomer.text = "3"

            }
            if txtPeriodInWeeksForMaxServices.text == ""
            {
                txtPeriodInWeeksForMaxServices.text = "6"
            }
            dyanmicrowHEIGHT.constant = 200
            self.bLimitSeries = true
            self.VIEWlimitnumberofAppointments.setNeedsLayout()
            self.VIEWlimitnumberofAppointments.setNeedsDisplay()
        }
        else
        {
            self.bLimitSeries = false
            txtMaxServiceForCustomer.text = ""
            txtPeriodInWeeksForMaxServices.text = ""
            btnNoSelect3.isCecked = true
            btnSelect3.isCecked = false
            dyanmicrowHEIGHT.constant = 95
            self.VIEWlimitnumberofAppointments.setNeedsLayout()
            self.VIEWlimitnumberofAppointments.setNeedsDisplay()
        }

    }
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


    
  }
    extension String {
        subscript (i: Int) -> Character {
            return self[index(startIndex, offsetBy: i)]
        }
}
