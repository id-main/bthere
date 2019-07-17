//
//  EDIT_CALENDAR_FIRST_SCREEN.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 21/03/2019
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit
//protocol saveInGlobalDelegate3{
//    func saveDataInGlobal()
//    func selectedDomain(_WHICHDOMAIN:Int, _state: Bool) //access permissions
//    func selectedDomainTwo(_WHICHDOMAIN:Int, _state: Bool) //services permissions
//}

class EDIT_CALENDAR_FIRST_SCREEN: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, saveInGlobalDelegate3 {
    var APPPERMISSIONS_ARRAY:Array<appPermissions> = Array<appPermissions>()
    var delegate:SettingsSetupCalendars!=nil
    var myIndex:Int = 0
    var EMPLOYEE:objServiceProviders = objServiceProviders()
    var TABLE_ACCESS_PERMISSIONS_ISEXPANDED:Bool = false
    var TABLE_SERVICE_PERMISSIONS_ISEXPANDED:Bool = false
    var ACCESS_PERMISSIONS_ARRAY = Array<String>()
    var SERVICE_PERMISSIONS_ARRAY = Array<String>()
    var SELECTED_PERMISSION_TEXT = ""
    var SELECTED_SERVICE_PERMISSION_TEXT = ""
    var ACCESS_PERMISSIONS_ARRAY_SELECTED =  Array<String>()
    var SERVICE_PERMISSIONS_ARRAY_SELECTED = Array<String>()
    var ACCESS_PERMISSIONS_ARRAY_TO_SERVER =  Array<Int>()
    var SERVICE_PERMISSIONS_ARRAY_TO_SERVER = Array<Int>()
    var ismanager:Bool = false
    var isvalidphone:Bool = false
    var isvalidname:Bool = false
    var generic:Generic = Generic()
    var NewUser:User = User()
    var firstNameVerify = ""
    var lastNameVerify = ""
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    @IBOutlet weak var SELECTED_PERMISSION_TEXT_LABEL: UILabel!
    @IBOutlet weak var SELECTED_SERVICE_PERMISSION_TEXT_LABEL: UILabel!
    @IBOutlet weak var ADD_EMPLOYEE:UILabel!
    @IBOutlet weak var FULL_NAME:UILabel!
    @IBOutlet weak var PHONE_NUMBER:UILabel!
    @IBOutlet weak var MANAGER_PERMISSION:UILabel!
    @IBOutlet weak var ACCESS_PERMISSIONS :UILabel!
    @IBOutlet weak var SERVICE_PERMISSIONS :UILabel!
    @IBOutlet weak var ERRORTXTFULLNAME:UILabel!
    @IBOutlet weak var ERRORTXTPHONENUMBER:UILabel!
    @IBOutlet weak var TXTFULLNAME:UITextField!
    @IBOutlet weak var TXTPHONENUMBER:UITextField!
    @IBOutlet weak var NEXT_BUTTON:UIButton!
    @IBOutlet weak var OPENTABLE1_BUTTON:UIButton!
    @IBOutlet weak var OPENTABLE2_BUTTON:UIButton!
    @IBOutlet weak var btnYesSelect: CheckBoxForDetailsWorker3!
    @IBOutlet weak var btnNoSelect: checkBoxForDetailsWorker4!
    @IBOutlet weak var TABLE_ACCESS_PERMISSIONS:UITableView!
    @IBOutlet weak var TABLE_SERVICE_PERMISSIONS:UITableView!
    //  @IBOutlet weak var leftarrowblue: UIImageView!
    @IBOutlet weak var rightarrowblue: UIImageView!
    @IBOutlet weak var FIRSTARROW: UIImageView!
    @IBOutlet weak var SECONDARROW: UIImageView!

    @IBAction func btnNoSelect(_ sender: AnyObject) {
        ismanager = false
        btnYesSelect.isCecked = false
        btnNoSelect.isCecked = true
        OPENTABLE1_BUTTON.isUserInteractionEnabled = true
        OPENTABLE2_BUTTON.isUserInteractionEnabled = true
        OPENTABLE1_BUTTON.backgroundColor = UIColor.clear
        OPENTABLE2_BUTTON.backgroundColor = UIColor.clear
        OPENTABLE1_BUTTON.alpha = 1
        OPENTABLE2_BUTTON.alpha = 1
    }
    @IBAction func btnYesSelect(_ sender: AnyObject) {
        var mystr = ""
        ismanager = true
        btnYesSelect.isCecked = true
        btnNoSelect.isCecked = false
        TABLE_ACCESS_PERMISSIONS_ISEXPANDED = false
        TABLE_SERVICE_PERMISSIONS_ISEXPANDED = false
        TABLE_ACCESS_PERMISSIONS.reloadData()
        TABLE_SERVICE_PERMISSIONS.reloadData()
        TABLE_ACCESS_PERMISSIONS.isHidden = true
        TABLE_SERVICE_PERMISSIONS.isHidden = true
        OPENTABLE1_BUTTON.isUserInteractionEnabled = false
        //OPENTABLE2_BUTTON.isUserInteractionEnabled = false
        OPENTABLE1_BUTTON.alpha = 0.7
       // OPENTABLE2_BUTTON.alpha = 0.7
        OPENTABLE1_BUTTON.backgroundColor = UIColor.lightGray
      //  OPENTABLE2_BUTTON.backgroundColor = UIColor.lightGray
        for a in self.APPPERMISSIONS_ARRAY {
            let permissionname = a.nvValue
            let permissionid = a.iPermissionType
            if !ACCESS_PERMISSIONS_ARRAY_TO_SERVER.contains(permissionid!) {
                ACCESS_PERMISSIONS_ARRAY_TO_SERVER.append(permissionid!)
                ACCESS_PERMISSIONS_ARRAY_SELECTED.append(permissionname!)
            }
        }
    if ACCESS_PERMISSIONS_ARRAY_SELECTED.count == 0 {
    SELECTED_PERMISSION_TEXT = ""
    SELECTED_PERMISSION_TEXT_LABEL.text = "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    } else {
    mystr =  ACCESS_PERMISSIONS_ARRAY_SELECTED.joined(separator: ", ")
    SELECTED_PERMISSION_TEXT = mystr
    SELECTED_PERMISSION_TEXT_LABEL.text = SELECTED_PERMISSION_TEXT
    }
    self.TABLE_ACCESS_PERMISSIONS.reloadData()
        mystr = ""
        for service in self.ProviderServicesArray {
            let serviceidserver = service.iProviderServiceId
            let servicename = service.nvServiceName
            if !SERVICE_PERMISSIONS_ARRAY_TO_SERVER.contains(serviceidserver) {
                SERVICE_PERMISSIONS_ARRAY_TO_SERVER.append(serviceidserver)
                SERVICE_PERMISSIONS_ARRAY_SELECTED.append(servicename)
            }
        }

    if SERVICE_PERMISSIONS_ARRAY_SELECTED.count == 0 {
    SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text = "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    } else {
    mystr =  SERVICE_PERMISSIONS_ARRAY_SELECTED.joined(separator: ", ")
    SELECTED_SERVICE_PERMISSION_TEXT = mystr
    SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text = SELECTED_SERVICE_PERMISSION_TEXT
    }
    self.TABLE_SERVICE_PERMISSIONS.reloadData()
    }
    @IBAction func OPENTABLE1_BUTTON(_ sender: AnyObject) {
        TABLE_SERVICE_PERMISSIONS.isHidden = true
        SECONDARROW.image = UIImage(named: "generaldataleft.png")
        OPENTABLE1_BUTTON.isSelected = !OPENTABLE1_BUTTON.isSelected
        if  OPENTABLE1_BUTTON.isSelected == true {
            TABLE_ACCESS_PERMISSIONS.isHidden = false
            FIRSTARROW.image = UIImage(named: "generaldatadown.png")
        } else {
            TABLE_ACCESS_PERMISSIONS.isHidden = true
            FIRSTARROW.image = UIImage(named: "generaldataleft.png")
        }
    }
    @IBAction func OPENTABLE2_BUTTON(_ sender: AnyObject) {
        TABLE_ACCESS_PERMISSIONS.isHidden = true
        FIRSTARROW.image = UIImage(named: "generaldataleft.png")
        OPENTABLE2_BUTTON.isSelected = !OPENTABLE2_BUTTON.isSelected
        if  OPENTABLE2_BUTTON.isSelected == true {
            TABLE_SERVICE_PERMISSIONS.isHidden = false
            SECONDARROW.image = UIImage(named: "generaldatadown.png")
        } else {
            TABLE_SERVICE_PERMISSIONS.isHidden = true
            SECONDARROW.image = UIImage(named: "generaldataleft.png")
        }
    }
    @IBAction func NEXTSTEP() {
        if self.isvalidname == true && self.isvalidphone == true {
            //goto step 2
            let USERedit = Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers
            USERedit.nvPhone = self.TXTPHONENUMBER.text!
            USERedit.nvFirstName =  self.TXTFULLNAME.text! //firstNameVerify
            USERedit.nvLastName = ""//self.lastNameVerify
            if  btnYesSelect.isCecked == true {
            USERedit.bIsManager = 1
            } else {
            USERedit.bIsManager = 0
            }
            if  btnNoSelect.isCecked == true {
                USERedit.bIsManager = 0
            } else {
                USERedit.bIsManager = 1
            }
            let NEW_EMPLOYEE_EDIT:objEMPLOYEE = objEMPLOYEE()

           

            NEW_EMPLOYEE_EDIT.objsers.iUserId = USERedit.iUserId
            NEW_EMPLOYEE_EDIT.objsers.nvUserName = USERedit.nvUserName
            NEW_EMPLOYEE_EDIT.objsers.nvFirstName = USERedit.nvFirstName
            NEW_EMPLOYEE_EDIT.objsers.nvLastName = USERedit.nvLastName
            NEW_EMPLOYEE_EDIT.objsers.dBirthdate = USERedit.dBirthdate
            NEW_EMPLOYEE_EDIT.objsers.nvMail = USERedit.nvMail
            NEW_EMPLOYEE_EDIT.objsers.iCityType = USERedit.iCityType
            NEW_EMPLOYEE_EDIT.objsers.nvPhone = USERedit.nvPhone
            NEW_EMPLOYEE_EDIT.objsers.nvPassword = USERedit.nvPassword
            NEW_EMPLOYEE_EDIT.objsers.nvVerification = USERedit.nvVerification
            NEW_EMPLOYEE_EDIT.objsers.bAutomaticUpdateApproval = USERedit.bAutomaticUpdateApproval
            NEW_EMPLOYEE_EDIT.objsers.bDataDownloadApproval = USERedit.bDataDownloadApproval
            NEW_EMPLOYEE_EDIT.objsers.bTermOfUseApproval = USERedit.bTermOfUseApproval
            NEW_EMPLOYEE_EDIT.objsers.bAdvertisingApproval = USERedit.bAdvertisingApproval
            NEW_EMPLOYEE_EDIT.objsers.iUserStatusType = USERedit.iUserStatusType
            NEW_EMPLOYEE_EDIT.objsers.bIsGoogleCalendarSync = USERedit.bIsGoogleCalendarSync
            NEW_EMPLOYEE_EDIT.objsers.nvImage = USERedit.nvImage
            NEW_EMPLOYEE_EDIT.objsers.iCreatedByUserId = USERedit.iCreatedByUserId
            NEW_EMPLOYEE_EDIT.objsers.iLastModifyUserId = USERedit.iLastModifyUserId
            NEW_EMPLOYEE_EDIT.objsers.iSysRowStatus = USERedit.iSysRowStatus
            NEW_EMPLOYEE_EDIT.objsers.dMarriageDate = USERedit.dMarriageDate
            NEW_EMPLOYEE_EDIT.objsers.iCalendarViewType = USERedit.iCalendarViewType
            NEW_EMPLOYEE_EDIT.objsers.bIsManager = USERedit.bIsManager
            NEW_EMPLOYEE_EDIT.objsers.nvDeviceToken = USERedit.nvDeviceToken
            NEW_EMPLOYEE_EDIT.objsers.iStatus = USERedit.iStatus
            NEW_EMPLOYEE_EDIT.objsers.nvNickName = USERedit.nvNickName
            NEW_EMPLOYEE_EDIT.objsers.iProviderUserId = USERedit.iProviderUserId
            NEW_EMPLOYEE_EDIT.liPermissionType = ACCESS_PERMISSIONS_ARRAY_TO_SERVER
            NEW_EMPLOYEE_EDIT.objProviderServicesIDS = SERVICE_PERMISSIONS_ARRAY_TO_SERVER // arrayservices
            print(ACCESS_PERMISSIONS_ARRAY_TO_SERVER.description)
            let mainstoryb = UIStoryboard(name: "SetupCalendarWorkinghours", bundle: nil)
            let viewEmployeeSettingsSetupWorkingHours: EDITCalendarSettingsSetupWorkingHours = mainstoryb.instantiateViewController(withIdentifier: "EDITCalendarSettingsSetupWorkingHours")as! EDITCalendarSettingsSetupWorkingHours
            viewEmployeeSettingsSetupWorkingHours.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
            viewEmployeeSettingsSetupWorkingHours.modalPresentationStyle = .custom
            viewEmployeeSettingsSetupWorkingHours.myIndex = myIndex
            viewEmployeeSettingsSetupWorkingHours.delegate = self.delegate
            Global.sharedInstance.NEW_EMPLOYEE_EDIT.liPermissionType = NEW_EMPLOYEE_EDIT.liPermissionType
            Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers = NEW_EMPLOYEE_EDIT.objsers
          //  Global.sharedInstance.NEW_EMPLOYEE_EDIT.objProviderServicesx = NEW_EMPLOYEE_EDIT.objProviderServicesx
            Global.sharedInstance.NEW_EMPLOYEE_EDIT.objProviderServicesIDS = NEW_EMPLOYEE_EDIT.objProviderServicesIDS
            if  SELECTED_PERMISSION_TEXT_LABEL.text == "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
                viewEmployeeSettingsSetupWorkingHours.SELECTED_PERMISSION_TEXT_LABEL_TEXT = ""
            } else {
                viewEmployeeSettingsSetupWorkingHours.SELECTED_PERMISSION_TEXT_LABEL_TEXT = SELECTED_PERMISSION_TEXT_LABEL.text!
            }
            if SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text == "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
                viewEmployeeSettingsSetupWorkingHours.SELECTED_SERVICE_PERMISSION_TEXT_LABEL_TEXT = ""
            } else {
            viewEmployeeSettingsSetupWorkingHours.SELECTED_SERVICE_PERMISSION_TEXT_LABEL_TEXT = SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text!
            }
            self.present(viewEmployeeSettingsSetupWorkingHours, animated: true, completion: nil)

        } else {
              Alert.sharedInstance.showAlertDelegate("COMPLETE_REQUIRED_FIELDS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
    }
    func GetApplicationPermissions() {
        var iLanguageId = 0
        if  let _:Int = Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") as Int? {
            iLanguageId = Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") + 1
        }
        var dicGetApplicationPermissions:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetApplicationPermissions["iLanguageId"] = iLanguageId as AnyObject
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
        }
        else
        {
            api.sharedInstance.GetApplicationPermissions(dicGetApplicationPermissions, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    self.generic.hideNativeActivityIndicator(self)
                    print("responseObject GetApplicationPermissions \(responseObject ??  1 as AnyObject)")
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            let ps: appPermissions = appPermissions()
                            if let _:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String,AnyObject>>
                            {

                                self.APPPERMISSIONS_ARRAY = ps.appPermissionsToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                print("self.APPPERMISSIONS_ARRAY \(self.APPPERMISSIONS_ARRAY)")
                                for q in self.APPPERMISSIONS_ARRAY {
                                    print(q.getDic())
                                }

                            }
                        }
                    }
                }
                self.precompleteACCESS_PERMISSIONS_ARRAY()
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
               self.precompleteACCESS_PERMISSIONS_ARRAY()

            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        print(Global.sharedInstance.NEW_EMPLOYEE_EDIT.objProviderServicesIDS)
        myIndex = Global.sharedInstance.myIndexForEditWorker
        print("aaamyIndex \(myIndex)")
        GetApplicationPermissions()
        //EMPLOYEE
        OPENTABLE1_BUTTON.layer.borderColor = UIColor.darkGray.cgColor
        OPENTABLE1_BUTTON.layer.borderWidth = 1
        OPENTABLE2_BUTTON.layer.borderColor = UIColor.darkGray.cgColor
        OPENTABLE2_BUTTON.layer.borderWidth = 1
        btnYesSelect.isCecked = false
        btnNoSelect.isCecked = true
        ACCESS_PERMISSIONS_ARRAY = ["faaaaaaaanaa",
                                    "naaaaaaaaana",
                                    "mmaaaaaaaana",
                                    "maaaaaaaaana",
                                    "aeaaaaaaaana",
                                    "neaaaaaaaana",
                                    "meaaaaaaaana",
                                    "miaaaaaaaana",
                                    "ifaaaaaaaana",
                                    "reaaaaaaaana",
                                    "eaaaaaaaaana",
                                    "aiaaaaaaaana",
                                    "inaaaaaaaana",
                                    "emaaaaaaaana",
                                    "enaaaaaaaana"]
        SERVICE_PERMISSIONS_ARRAY = ["aaaaaaaafa",
                                     "aaaaaaaana",
                                     "mmaaaaaaaa",
                                     "maaaaaaaaa",
                                     "aeaaaaaaaa",
                                     "neaaaaaaaa",
                                     "meaaaaaaaa",
                                     "miaaaaaaaa",
                                     "ifaaaaaaaa",
                                     "reaaaaaaaa",
                                     "eaaaaaaaaa",
                                     "aiaaaaaaaa",
                                     "inaaaaaaaa",
                                     "emaaaaaaaa",
                                     "envaaaaaaa",]
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {

            rightarrowblue.image =    UIImage(named: "leftarrowblue.png")
            //     leftarrowblue.image =    UIImage(named: "returnarrowinsuppliuerregistrationhebrew.png")
        }
        else
        {
            rightarrowblue.image =    UIImage(named: "rightarrowblue.png")
            //     leftarrowblue.image =    UIImage(named: "returnarrowinsuppliuerregistration.png")
        }
        TABLE_ACCESS_PERMISSIONS.delegate = self
        TABLE_SERVICE_PERMISSIONS.delegate = self
        TABLE_ACCESS_PERMISSIONS.isHidden = true
        TABLE_ACCESS_PERMISSIONS.dataSource = self
        TABLE_SERVICE_PERMISSIONS.dataSource = self
        TABLE_SERVICE_PERMISSIONS.isHidden = true
        TXTFULLNAME.delegate = self
        TXTPHONENUMBER.delegate = self
        let USERDEF = UserDefaults.standard
        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            FULL_NAME.textAlignment = .right
            PHONE_NUMBER.textAlignment = .right
            TXTFULLNAME.textAlignment = .right
            TXTPHONENUMBER.textAlignment = .right
            MANAGER_PERMISSION.textAlignment = .right
            ACCESS_PERMISSIONS.textAlignment = .right
            SERVICE_PERMISSIONS.textAlignment = .right
            ERRORTXTPHONENUMBER.textAlignment = .right
            ERRORTXTFULLNAME.textAlignment = .right
        } else {
            FULL_NAME.textAlignment = .left
            PHONE_NUMBER.textAlignment = .left
            TXTFULLNAME.textAlignment = .left
            TXTPHONENUMBER.textAlignment = .left
            MANAGER_PERMISSION.textAlignment = .left
            ACCESS_PERMISSIONS.textAlignment = .left
            SERVICE_PERMISSIONS.textAlignment = .left
            ERRORTXTPHONENUMBER.textAlignment = .left
            ERRORTXTFULLNAME.textAlignment = .left
        }
        TXTFULLNAME.isUserInteractionEnabled = true
        TXTPHONENUMBER.isUserInteractionEnabled = false
        self.isvalidname = true
        self.isvalidphone = true
        TXTFULLNAME.backgroundColor = UIColor.clear
        TXTPHONENUMBER.backgroundColor = UIColor.lightGray
        TXTFULLNAME.alpha = 1
        TXTPHONENUMBER.alpha = 0.7
        let myuser = Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers
        let fullname:String = myuser.nvFirstName + " " + myuser.nvLastName
        if fullname.count > 1 {
            TXTFULLNAME.text = fullname
        }
        let fullNameVerify = TXTFULLNAME.text! as String
        let bar = fullNameVerify
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        let fullNameArr = bar.components(separatedBy: " ")
        let size = fullNameArr.count

        for a in fullNameArr {
            print("eeeee |\(a.count)|")
        }
        if(size > 1) {
            let myArray : NSMutableArray = []
            for item in fullNameArr {
                let newString = item.replace(" ", withString:"")
                if(newString.count > 0  ) {
                    print("Found \(newString)")
                    myArray.add(newString)
                }
            }
            let sizemutablearray = myArray.count
            if(sizemutablearray > 1 ) {
                firstNameVerify = myArray.object(at: 0) as! String
                lastNameVerify = myArray.object(at: 1) as! String


            }
        }
        let phonenumber = myuser.nvPhone
        if phonenumber.count == 10 {
            TXTPHONENUMBER.text = phonenumber
        }
//        let a = myuser.bIsManager
//        if myIndex == 0 {   //LOCK BUSINESS OWNER FOR EDIT FLAG bIsManager TO BE SURE IS ALWAYS al least a manager
//            btnYesSelect.isCecked = true
//            btnNoSelect.isCecked = false
//            btnYesSelect(self.btnYesSelect)
//            btnYesSelect.isUserInteractionEnabled = false
//            btnNoSelect.isUserInteractionEnabled = false
//            btnYesSelect.isEnabled = false
//            btnNoSelect.isEnabled = false
//            OPENTABLE1_BUTTON.isUserInteractionEnabled = false
//         //   OPENTABLE2_BUTTON.isUserInteractionEnabled = false
//
//        } else {
//        if a == 0 {
//        btnYesSelect.isCecked = false
//        btnNoSelect.isCecked = true
//        btnNoSelect(self.btnNoSelect)
//        } else {
//        btnYesSelect.isCecked = true
//        btnNoSelect.isCecked = false
//        btnYesSelect(self.btnYesSelect)
//        }
       // }
        ismanager = false
        btnYesSelect.isCecked = false
        btnNoSelect.isCecked = true
        btnYesSelect.isUserInteractionEnabled = false
        btnNoSelect.isUserInteractionEnabled = false
        btnYesSelect.isEnabled = false
        btnNoSelect.isEnabled = false
        OPENTABLE1_BUTTON.isUserInteractionEnabled = false
        OPENTABLE2_BUTTON.isUserInteractionEnabled = true
        OPENTABLE1_BUTTON.backgroundColor = UIColor.lightGray
        OPENTABLE2_BUTTON.backgroundColor = UIColor.clear
        OPENTABLE1_BUTTON.alpha = 1
        OPENTABLE2_BUTTON.alpha = 1
        if Global.sharedInstance.NEW_EMPLOYEE_EDIT.bSameWH == true {
        Global.sharedInstance.employehassamehours = true
        } else {
        Global.sharedInstance.employehassamehours = false
        }

        //test
        Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS = Global.sharedInstance.NEW_EMPLOYEE_EDIT.arrObjWorkingHours
        ADD_EMPLOYEE.text = "EDIT_CALENDARS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        FULL_NAME.text = "FULL_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        PHONE_NUMBER.text = "PHONE_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        MANAGER_PERMISSION.text = "MANAGER_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ACCESS_PERMISSIONS.text = "ACCESS_PERMISSIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        SERVICE_PERMISSIONS.text = "SERVICE_PERMISSIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ERRORTXTFULLNAME.text = ""
        ERRORTXTPHONENUMBER.text = ""
        NEXT_BUTTON.setAttributedTitle(NSAttributedString(string:"NEXT_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!, convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1])), for: .normal)
        FIRSTARROW.image = UIImage(named: "generaldataleft.png")
        SECONDARROW.image = UIImage(named: "generaldataleft.png")
        if SELECTED_PERMISSION_TEXT != "" {
            SELECTED_PERMISSION_TEXT_LABEL.text = SELECTED_PERMISSION_TEXT
        } else {
            SELECTED_PERMISSION_TEXT_LABEL.text = "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }

        if SELECTED_SERVICE_PERMISSION_TEXT != "" {
            SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text = SELECTED_SERVICE_PERMISSION_TEXT
        } else {
            SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text = "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        getProviderServicesForSupplierFunc()

    }
    func getProviderServicesForSupplierFunc()
    {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
            dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

        } else {
            dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }
        print("CEEE Global.sharedInstance.providerID \(Global.sharedInstance.providerID)")

        api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                    //    self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {

                        let ps:objProviderServices = objProviderServices()
                        if let _:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String,AnyObject>>
                        {
                            print("aaaaaaaa \(RESPONSEOBJECT["Result"] ?? 1 as AnyObject)")
                            self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            if self.ProviderServicesArray.count == 0
                            {
                    //            self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else
                            {
                                for item in self.ProviderServicesArray {
                                    print("self.ProviderServicesArray \(item.description)")
                                }
                            }
                        //    self.getServicesProviderForSupplierfunc()
                        } else {
                      //      self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                }
            }
            self.precompleteSERVICE_PERMISSIONS_ARRAY()

        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            self.precompleteSERVICE_PERMISSIONS_ARRAY()

        })
    }
    func precompleteSERVICE_PERMISSIONS_ARRAY(){
        var mystr = ""

        if Global.sharedInstance.NEW_EMPLOYEE_EDIT.objProviderServicesIDS.count > 0 {
            for service in self.ProviderServicesArray {
                let serviceidserver = service.iProviderServiceId
                let servicename = service.nvServiceName
                                 for i in 0..<Global.sharedInstance.NEW_EMPLOYEE_EDIT.objProviderServicesIDS.count {
                                    if let x:Int = Global.sharedInstance.NEW_EMPLOYEE_EDIT.objProviderServicesIDS[i] as Int? {
                                    let servpermissionid = x
                                    if servpermissionid == serviceidserver {
                                            SERVICE_PERMISSIONS_ARRAY_SELECTED.append(servicename)
                                        if !SERVICE_PERMISSIONS_ARRAY_TO_SERVER.contains(servpermissionid) {
                                            SERVICE_PERMISSIONS_ARRAY_TO_SERVER.append(servpermissionid)
                                        }
                                        }
                                    }
                            }

            }
        }


            if SERVICE_PERMISSIONS_ARRAY_SELECTED.count == 0 {
                SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text = "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            } else {
                mystr =  SERVICE_PERMISSIONS_ARRAY_SELECTED.joined(separator: ", ")
                SELECTED_SERVICE_PERMISSION_TEXT = mystr
                SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text = SELECTED_SERVICE_PERMISSION_TEXT
            }

        self.TABLE_SERVICE_PERMISSIONS.reloadData()
    }
    func precompleteACCESS_PERMISSIONS_ARRAY(){
        var mystr = ""
        if myIndex != 0 {
        if Global.sharedInstance.NEW_EMPLOYEE_EDIT.liPermissionType.count > 0 {

            for permission in self.APPPERMISSIONS_ARRAY {
                let id = permission.iPermissionType
                let permissionname = permission.nvValue
                for permissionid in Global.sharedInstance.NEW_EMPLOYEE_EDIT.liPermissionType {
                    if permissionid == id {
                        ACCESS_PERMISSIONS_ARRAY_SELECTED.append(permissionname!)
                        if !ACCESS_PERMISSIONS_ARRAY_TO_SERVER.contains(permissionid) {
                            ACCESS_PERMISSIONS_ARRAY_TO_SERVER.append(permissionid)
                        }
                    }
                }
            }
        }
        } else {
            for a in self.APPPERMISSIONS_ARRAY {
                let permissionname = a.nvValue
                let permissionid = a.iPermissionType
                ACCESS_PERMISSIONS_ARRAY_SELECTED.append(permissionname!)
                if !ACCESS_PERMISSIONS_ARRAY_TO_SERVER.contains(permissionid!) {
                    ACCESS_PERMISSIONS_ARRAY_TO_SERVER.append(permissionid!)
                }
            }
        }
        if ACCESS_PERMISSIONS_ARRAY_SELECTED.count == 0 {
            SELECTED_PERMISSION_TEXT = ""
            SELECTED_PERMISSION_TEXT_LABEL.text = "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        } else {
            mystr =  ACCESS_PERMISSIONS_ARRAY_SELECTED.joined(separator: ", ")
            SELECTED_PERMISSION_TEXT = mystr
            SELECTED_PERMISSION_TEXT_LABEL.text = SELECTED_PERMISSION_TEXT
        }
         self.TABLE_ACCESS_PERMISSIONS.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //func to dismiss the popUp
    @IBAction func closePopup(_ sender:AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    //TABLES   // ROW 0   CHOOSE_PERMISSION.text = "ADD_EMPLOYEE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return  APPPERMISSIONS_ARRAY.count
        }
        return ProviderServicesArray.count //SERVICE_PERMISSIONS_ARRAY.count
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {



        if tableView.tag == 1 {
            let cell:EDITACCESSPERMISIONCell = tableView.dequeueReusableCell(withIdentifier: "EDITACCESSPERMISIONCell") as! EDITACCESSPERMISIONCell
            cell.selectionStyle = .none
            cell.delegate = self
            let y = indexPath.row
            cell.arrow.image = nil
            cell.tag = y

            var font2 = UIFont()
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
            {
                font2 = UIFont(name: "OpenSansHebrew-Light", size: 17)!
            } else {
                font2 = UIFont(name: "OpenSansHebrew-Light", size: 19)!
            }
            cell.lblText?.font = font2
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            var isselected = false
            let a:appPermissions = APPPERMISSIONS_ARRAY[y]
            if let _ =  a.nvValue as String?  {
                let mybusinessdomain =  a.nvValue as! String
                cell.lblText?.text = mybusinessdomain
                if ACCESS_PERMISSIONS_ARRAY_SELECTED.contains(mybusinessdomain) {
                    isselected = true
                } else {
                    isselected = false
                }
            }
            cell.setDataForCell(isselected)
            return cell
        } else {
            let cell2:EDITSERVICEPERMISIONCell = tableView.dequeueReusableCell(withIdentifier: "EDITSERVICEPERMISIONCell") as! EDITSERVICEPERMISIONCell
            cell2.selectionStyle = .none
            cell2.delegate = self
            let y = indexPath.row
            cell2.tag = y

            var font2 = UIFont()
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
            {
                font2 = UIFont(name: "OpenSansHebrew-Light", size: 17)!
            } else {
                font2 = UIFont(name: "OpenSansHebrew-Light", size: 19)!
            }
            cell2.lblText?.font = font2
            cell2.separatorInset = UIEdgeInsets.zero
            cell2.layoutMargins = UIEdgeInsets.zero
            var isselected = false
            let myObjectforService = ProviderServicesArray[y]

            if let _ =  myObjectforService.nvServiceName as String?  {
                let mybusinessdomain =  myObjectforService.nvServiceName
                let myserviceid = myObjectforService.iProviderServiceId
                cell2.lblText?.text = mybusinessdomain
                if SERVICE_PERMISSIONS_ARRAY_TO_SERVER.contains(myserviceid) {
                    isselected = true
                } else {
                    isselected = false
                }
            }
            cell2.setDataForCell(isselected)
            return cell2
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)

        if tableView.tag == 2 {
            print ("aaaaaaa")
        } else {
            tableView.isHidden = true

        }
    }
    func saveDataInGlobal() {

    }
    func selectedDomain(_WHICHDOMAIN:Int, _state: Bool) {
        TABLE_SERVICE_PERMISSIONS_ISEXPANDED = false
        TABLE_SERVICE_PERMISSIONS.reloadData()
        TABLE_SERVICE_PERMISSIONS.isHidden = true
        print(_WHICHDOMAIN)
        let a:appPermissions = APPPERMISSIONS_ARRAY[_WHICHDOMAIN]
        var mystr = a.nvValue
        let myid = a.iPermissionType

        if _state == false {
                if ACCESS_PERMISSIONS_ARRAY_TO_SERVER.contains(myid!) {
                    let x = ACCESS_PERMISSIONS_ARRAY_TO_SERVER.index(of: myid!)
                    ACCESS_PERMISSIONS_ARRAY_TO_SERVER.remove(at: x!)
                    if let _ = ACCESS_PERMISSIONS_ARRAY_SELECTED[x!] as String?  {
                        ACCESS_PERMISSIONS_ARRAY_SELECTED.remove(at: x!)
                    }
                }
        } else{

                if !ACCESS_PERMISSIONS_ARRAY_TO_SERVER.contains(myid!) {
                    ACCESS_PERMISSIONS_ARRAY_TO_SERVER.append(myid!)
                    ACCESS_PERMISSIONS_ARRAY_SELECTED.append(mystr!)
                }
        }
        if ACCESS_PERMISSIONS_ARRAY_SELECTED.count == 0 {
            SELECTED_PERMISSION_TEXT_LABEL.text = "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        } else {
            mystr = ACCESS_PERMISSIONS_ARRAY_SELECTED.joined(separator: ", ")

            SELECTED_PERMISSION_TEXT = mystr!
            SELECTED_PERMISSION_TEXT_LABEL.text = SELECTED_PERMISSION_TEXT
        }
        self.TABLE_ACCESS_PERMISSIONS.reloadData()
    }
    func selectedDomainTwo(_WHICHDOMAIN:Int, _state: Bool) {
        print(_WHICHDOMAIN)
        TABLE_ACCESS_PERMISSIONS_ISEXPANDED = false
        TABLE_ACCESS_PERMISSIONS.reloadData()
        TABLE_ACCESS_PERMISSIONS.isHidden = true
        var mystr = "" // SERVICE_PERMISSIONS_ARRAY[_WHICHDOMAIN]""
        let myObjectforService = ProviderServicesArray[_WHICHDOMAIN]
        if let _ =  myObjectforService.nvServiceName as String?  {
        let mystr =  myObjectforService.nvServiceName
        let myid = myObjectforService.iProviderServiceId
            if _state == false {
                if SERVICE_PERMISSIONS_ARRAY_TO_SERVER.contains(myid) {
                    let x = SERVICE_PERMISSIONS_ARRAY_TO_SERVER.index(of: myid)
                    SERVICE_PERMISSIONS_ARRAY_TO_SERVER.remove(at: x!)
                    if let _ = SERVICE_PERMISSIONS_ARRAY_SELECTED[x!] as String?  {
                        let myx = SERVICE_PERMISSIONS_ARRAY_SELECTED[x!]
                        let ax = SERVICE_PERMISSIONS_ARRAY_SELECTED.index(of: myx)
                        SERVICE_PERMISSIONS_ARRAY_SELECTED.remove(at: ax!)
                    }
                }
            } else{

                if !SERVICE_PERMISSIONS_ARRAY_TO_SERVER.contains(myid) {
                    SERVICE_PERMISSIONS_ARRAY_TO_SERVER.append(myid)
                    SERVICE_PERMISSIONS_ARRAY_SELECTED.append(mystr)
                }
            }
        }
        if SERVICE_PERMISSIONS_ARRAY_SELECTED.count == 0 {
             SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text = "CHOOSE_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        } else {
        mystr =  SERVICE_PERMISSIONS_ARRAY_SELECTED.joined(separator: ", ")
        SELECTED_SERVICE_PERMISSION_TEXT = mystr
        SELECTED_SERVICE_PERMISSION_TEXT_LABEL.text = SELECTED_SERVICE_PERMISSION_TEXT
        }
        self.TABLE_SERVICE_PERMISSIONS.reloadData()
    }
    func checkPhoneExist()
    {
        let phonenumber = TXTPHONENUMBER.text
        let myuserphonenumber = Global.sharedInstance.currentUser.nvPhone
        if phonenumber == myuserphonenumber {
            self.ERRORTXTPHONENUMBER.text = "CANNOT_USE_OWN_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        } else {
            var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dicPhone["nvPhone"] = TXTPHONENUMBER.text as AnyObject
            if Reachability.isConnectedToNetwork() == false
            {
                generic.hideNativeActivityIndicator(self)
                self.isvalidphone = false
            }
            else
            {
                api.sharedInstance.GetEmployeeDataByPhone(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                self.isvalidphone = false
                                self.ERRORTXTPHONENUMBER.text = "EMPLOYE_EXIST_in_db".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            } else {
                                let myemployes :Array<objEMPLOYEE> = Global.sharedInstance.ARRAYCALENDAR
                                self.ERRORTXTPHONENUMBER.text = ""
                                self.isvalidphone = true
                                for servPro:objEMPLOYEE in myemployes {
                                    if servPro.objsers.nvPhone == self.TXTPHONENUMBER.text {
                                        self.isvalidphone = false
                                        self.ERRORTXTPHONENUMBER.text = "EMPLOYE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                    }
                                }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                })
            }
        }
    }
    func isValidName(_ input: String) -> Bool {
        let letters = CharacterSet.letters

        let phrase = input
        let range = phrase.rangeOfCharacter(from: letters)
        let decimalCharacters = CharacterSet.decimalDigits

        let decimalRange = phrase.rangeOfCharacter(from: decimalCharacters)

        if decimalRange != nil {
            print("Numbers found")
            return false
        }
        // range will be nil if no letters is found
        if range != nil {
            print("letters found")
            return true
        }
        else {
            print("letters not found")
            return false
        }
//        var numSpace = 0
//        for chr in input {
//            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr >= "א" && chr <= "ת") && !(chr == " "))  {
//                return false
//            }
//            if chr == " "
//            {
//                numSpace += 1
//            }
//        }
//        if numSpace == input.count || numSpace == input.count - 1
//        {
//            return false
//        }
//        return true
    }

    func isValidPhone(_ input: String) -> Bool {
        if input.count > 2 {
            let index0 = input.index(input.startIndex, offsetBy: 0)
            let index1 = input.index(input.startIndex, offsetBy: 1)
            if input[index0] != "0" || input[index1] != "5"{
                return false
            }
            for chr in input {
                if (!(chr >= "0" && chr <= "9") && !(chr == "-"))  {
                    return false
                }
            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == TXTFULLNAME
        {
            if TXTFULLNAME.text != "" && isValidName(TXTFULLNAME.text!) == false
            {
                ERRORTXTFULLNAME.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                self.isvalidname = false
            } else {

                let fullNameVerify = TXTFULLNAME.text! as String

                if fullNameVerify.count > 2 {
                    self.isvalidname = true
                } else {
                    ERRORTXTFULLNAME.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    self.isvalidname = false
                }
            }
        }

         if textField == TXTPHONENUMBER
        {

            if TXTPHONENUMBER.text != "" && (isValidPhone(TXTPHONENUMBER.text!) == false || (TXTPHONENUMBER.text?.count)! < 10)
            {
                ERRORTXTPHONENUMBER.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                self.isvalidphone = false
            } else {
                //   checkPhoneExist()
                self.isvalidphone = true
                
            }

        }

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        startString += string
        if textField == TXTPHONENUMBER
        {
            if startString.count > 10
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TXTPHONENUMBER
        {
            ERRORTXTPHONENUMBER.text = ""
        }
        if textField == TXTFULLNAME
        {
            ERRORTXTFULLNAME.text = ""
        }
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
