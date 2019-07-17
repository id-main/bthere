//
//  AddNewCustomerViewController.swift
//  bthree-ios
//
//  Created by Ungureanu Ioan on 1.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//
/*
 am creat serviciul pentru add customer cu numele SupplierAddCustomer (este facut pe baza serviciului RegisterUser la care se mai adauga un parametru int iSupplierId)
 
 Semnatura serviciului la registeruser este: RegisterUser(UserObj objUser)
 Iar la SupplierAddCustomer este: SupplierAddCustomer(UserObj objUser, int iSupplierId)
 */
import UIKit
import PhoneNumberKit
import Contacts
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

//תת דף הוספת לקוח  מתוך לקוחות שלי
class AddNewCustomerViewController: NavigationModelViewController,UITextFieldDelegate,UIGestureRecognizerDelegate, UIScrollViewDelegate {
    var isfromSPECIALiCustomerUserId:Int = 0
    let phoneNumberKit = PhoneNumberKit()
    var arrGoodPhone:Array<Character> = Array<Character>()
    var delegate:reloadall! = nil
    var isCheckPhoneEnd:Bool = false
    var isValidAdress:Bool = true
    var isValidEmail:Bool = true
    var isValidPhone:Bool = true
    var isValidFirstName:Bool = true
    var isValidLastName:Bool = true
    var bIsCreatedBySupplierId:Bool = false
    var timer: Timer? = nil
    var fDidBegin = false
    var isLockedFromEditing:Bool = false //in case of existing user in db the fields will be locked from edit
    var newiUserId:Int = 0
    var newiUserStatusType:Int = 26
    var newiCreatedByUserId:Int = 0
    var PROVIDERID:Int = 0
    var generic:Generic = Generic()
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var indexRow:Int = 0
    //JMODE +
    var isFORSETUPAPPOIMENT:Bool = false
    var firstNameVerify:String = ""
    var lastNameVerify:String = ""
    var dateServer = Date()
    @IBOutlet weak var LABELFULLName: UILabel!
    @IBOutlet weak var LABELPHONENumber: UILabel!
    @IBOutlet weak var LABELEmail: UILabel!
    @IBOutlet weak var LABELDateofBirth: UILabel!
    @IBOutlet weak var LABELNOtes: UILabel!
    @IBOutlet weak var LABELTITLEOFPAGE: UILabel!
    @IBOutlet weak var LABELREQUIREDFIELD: UILabel!
    @IBOutlet weak var NEWSCROLLVIEW: UIScrollView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var viewIn: UIView!
    @IBOutlet weak var dP: UIDatePicker!
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtNumStreet: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnPrefix: UIButton!
    @IBOutlet weak var btnAddCustomer: UIButton!
    
    @IBAction func btnPrefix(_ sender: AnyObject) {
        if tblPrefix.isHidden == true
        {
            tblPrefix.isHidden = false
        }
        else
        {
            tblPrefix.isHidden = true
        }
    }
    @IBAction func btnAddCustomer(_ sender: AnyObject) {
        //send to server after validation
        self.checkfnameValid(txtFName)
        //   self.checkmailvalid(txtEmail)
        self.checktelephonevalid(txtPhone)
        //   if(self.isValidEmail == true && self.isValidPhone == true && self.isValidFirstName == true) {
        if( self.isValidPhone == true && self.isValidFirstName == true) {
            
            validToRegister()
        }
    }
    func reloadTable() {
        
    }
    @IBOutlet weak var btnMakeAppointment: UIButton!
    
    @IBAction func btnMakeAppointment(_ sender: AnyObject) {
        self.checkfnameValid(txtFName)
        // self.checkmailvalid(txtEmail)
        self.checktelephonevalid(txtPhone)
        // if(self.isValidEmail == true && self.isValidPhone == true && self.isValidFirstName == true) {
        self.view.endEditing(true)
        if( self.isValidPhone == true && self.isValidFirstName == true) {
            isFORSETUPAPPOIMENT = true
            validToRegister()
        }
    }
    
//    func stringByReplacingFirstOccurrenceOfString(target: String, withString replaceString: String) -> String
//    {
//
//        if let range = String.rangeOfCharacter(target)
//        {
//            return self.stringByReplacingCharactersInRange(range?, withString: replaceString)
//        }
//        return self
//    }
    
    func cleanPhoneNumber(_ nvPhone:String) -> String {
        var  nvTmpPN2:String = ""
        var modedphone = nvPhone
        if  nvPhone != ""
        {
            //add to check if number has country code
            do {
                let phoneNumber = try phoneNumberKit.parse(nvPhone)
                let phoneNumberCustomDefaultRegion = try phoneNumber.countryCode
                if phoneNumberCustomDefaultRegion != 0 {
                    print ("phoneNumberCustomDefaultRegion \(phoneNumberCustomDefaultRegion)")
                    
//                    let newString = modedphone.replacestr(String(phoneNumberCustomDefaultRegion), withString: "0")
                    let newString = modedphone.stringByReplacingFirstOccurrenceOfString(target: String(phoneNumberCustomDefaultRegion), withString: "0")
                    modedphone = newString
                    print("formated number is \(modedphone)")
                }
            }
            catch {
                print("Generic parser error")
            }
            for char in (modedphone.characters)
            {
                if (char >= "0" && char <= "9") || char == "*"
                {
                    let c:Character = char
                    nvTmpPN2 = nvTmpPN2 + String(c)
                }
            }
        }
        return nvTmpPN2
    }
    func validToRegister()
    {
        self.view.endEditing(true)
        if isValidPhone == true /* && isValidEmail == true  && isValidLastName == true */ &&
            isValidFirstName == true{
            if Reachability.isConnectedToNetwork() == false
            {
//                DispatchQueue.main.async(execute: { () -> Void in
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                })
                
            }
            else {
                var  user:User = User()
                let base64 = ""
                var nvNickName:String = ""
                var cleannumber:String = ""
                if self.txtPhone.text != "" {
                    cleannumber = self.cleanPhoneNumber(self.txtPhone.text!)
                }
                if newiUserStatusType == 26 {
                    let dateString = "01/01/1901" // change to your date format
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat =  "dd/MM/yyyy"
                    let STRdBirthdate:Date = dateFormatter.date(from: dateString)!
                    
                    nvNickName = firstNameVerify + " " + lastNameVerify
                    user = User(_iUserId: newiUserId,
                                _nvUserName: "",
                                _nvFirstName: "",
                                _nvLastName: "",
                                //_nvSupplierNotes: self.txtViewComments.text,
                        _dBirthdate: STRdBirthdate,//txtDate,
                        _nvMail: "",
                        //   _nvAdress: "",
                        _iCityType: 1,
                        _nvPhone: /*self.txtPhone.text! */ cleannumber,
                        _nvPassword: "",
                        _nvVerification: "",
                        _bAutomaticUpdateApproval: true,//אם סימן אני מאשר
                        _bDataDownloadApproval: true,//?
                        _bAdvertisingApproval: false,//אם סימן קראתי את התקנון
                        _bTermOfUseApproval: true,//תמיד
                        // _iUserStatusType: 24, //or 26 - non active
                        _iUserStatusType : newiUserStatusType, //KEEP IN MIND 25 is for non active else 24 is allready active
                        _bIsGoogleCalendarSync: true,
                        _nvImage:base64,
                        //   _iCreatedByUserId: 1,//?
                        _iCreatedByUserId :newiCreatedByUserId,
                        _iLastModifyUserId: 1,//?
                        _iSysRowStatus: 1,//?
                        _bIsManager: 0,
                        _nvDeviceToken: "",
                        _iStatus:  1,
                        _nvNickName: nvNickName
                    )
                } else {
                    
                    user = User(_iUserId: newiUserId,
                                _nvUserName: self.txtEmail.text!,
                                _nvFirstName: firstNameVerify,
                                _nvLastName: lastNameVerify,
                                //_nvSupplierNotes: self.txtViewComments.text,
                        _dBirthdate: self.dateServer,//txtDate,
                        _nvMail: self.txtEmail.text!,
                        //   _nvAdress: "",
                        _iCityType: 1,
                        _nvPhone:  /*self.txtPhone.text! */ cleannumber,
                        _nvPassword: "",
                        _nvVerification: "",
                        _bAutomaticUpdateApproval: true,//אם סימן אני מאשר
                        _bDataDownloadApproval: true,//?
                        _bAdvertisingApproval: false,//אם סימן קראתי את התקנון
                        _bTermOfUseApproval: true,//תמיד
                        // _iUserStatusType: 24, //or 26 - non active
                        _iUserStatusType : newiUserStatusType, //KEEP IN MIND 25 is for non active else 24 is allready active
                        _bIsGoogleCalendarSync: true,
                        _nvImage:base64,
                        //   _iCreatedByUserId: 1,//?
                        _iCreatedByUserId :newiCreatedByUserId,
                        _iLastModifyUserId: 1,//?
                        _iSysRowStatus: 1,//?
                        _bIsManager: 0,
                        _nvDeviceToken: "",
                        _iStatus:  1,
                        _nvNickName: nvNickName
                    )
                }
                var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                
                //NEWVIPANDNOTES on server side
                var providerCustomersObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                
                providerCustomersObj["bIsVip"] = false as AnyObject
                if   btnVIPyes.isCecked == true {
                    providerCustomersObj["bIsVip"] = true as AnyObject
                }
                //to do
                //                dic["isOPTIONAL"] = 0
                //                if   btnVIPyes.isCecked == true {
                //                    dic["isVIP"] = 1
                //                }
                providerCustomersObj["nvSupplierRemark"] = self.txtViewComments.text as AnyObject
                
                //END TODO
                //                dic["iSupplierId"] = 0
                //                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                //                dic["iSupplierId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                //                }
                var providerID:Int = 0
                if Global.sharedInstance.providerID == 0 {
                    providerID = 0
                    if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                        providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                        
                    }
                } else {
                    providerID = Global.sharedInstance.providerID
                }
                dic["iSupplierId"] = providerID as AnyObject
                //JMODE bIsCreatedBySupplierId
                if self.newiUserId == 0 {
                    dic["bIsCreatedBySupplierId"] = false as AnyObject
                }
                dic["bIsCreatedBySupplierId"] = false as AnyObject
                if self.newiCreatedByUserId != self.PROVIDERID {
                    dic["bIsCreatedBySupplierId"] = false as AnyObject
                } else {
                    dic["bIsCreatedBySupplierId"] = true as AnyObject
                }
                if self.newiUserId == 0 {
                    dic["bIsCreatedBySupplierId"] = false as AnyObject
                }
                dic["nvNickName"] = nvNickName as AnyObject
                var dicobjUSER:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicobjUSER = user.getDic()
                //(UserObj objUser, int iSupplierId)
                dic["objUser"] = dicobjUSER as AnyObject
                dic["providerCustomersObj"] = providerCustomersObj as AnyObject
                print("what to send \(dic)")
                
                
                print("\n********************************* add new customer  ********************\n")
                //\\ let jsonData = try! NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
                //\\ let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
                //\\ print(jsonString)
                
                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                    })
                    
                }
                else
                {
                    api.sharedInstance.SupplierAddCustomer(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        //   print("ce astepta \(RESPONSEOBJECT["Result"])")
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            print("eroare la add new \(String(describing: RESPONSEOBJECT["Error"]))")
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            print("eroare la add new \(String(describing: RESPONSEOBJECT["Error"]))")
                        }
                        else
                        {
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                print("e ok la supplier add customer? " + myInt.description)
                                print("response request supplier add customer \(RESPONSEOBJECT)")
                                if myInt > 0 {

                                    self.generic.hideNativeActivityIndicator(self)
                                    if self.isFORSETUPAPPOIMENT == true  {
                                        self.generic.hideNativeActivityIndicator(self)
                                        self.deregisterFromKeyboardNotifications()
                                        self.getProviderServicesForSupplierFunc(myInt)
                                    }
                                    else {
//                                        DispatchQueue.main.async(execute: { () -> Void in
//                                            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                                        })
                                        self.deregisterFromKeyboardNotifications()
                                        self.delegate.reloadTable()
                                        self.dismiss(animated: true, completion:nil)
                                    }
                                }
                            }
                        }
                            }}},failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        if AppDelegate.showAlertInAppDelegate == false
                        {
                            DispatchQueue.main.async(execute: { () -> Void in
                                Alert.sharedInstance.showAlert("ERROR_ADD_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            })
                        }
                    })
                }
            }
        }
    }
    func getProviderServicesForSupplierFunc(_ isfromSPECIALiCustomerUserId:Int)     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
    {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        if Global.sharedInstance.providerID == 0 {
            dicSearch["iProviderId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
                
            }
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
                        DispatchQueue.main.async(execute: { () -> Void in
                            Alert.sharedInstance.showAlert("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        })
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                            let ps:objProviderServices = objProviderServices()
                            self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            if self.ProviderServicesArray.count == 0
                            {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    Alert.sharedInstance.showAlert("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                })
                            }
                            else
                            {
                                for item in self.ProviderServicesArray {
                                    print("self.ProviderServicesArray \(item.description)")
                                }
                                //make them optional or it will crash
                                
                                if let _ =  self.txtFName.text
                                {
                                    if self.txtFName.text != ""
                                    {
                                        Global.sharedInstance.nameOfCustomer = self.txtFName.text!
                                    }
                                }
                                
                                
                                let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                                let frontviewcontroller:UINavigationController? = UINavigationController()
                                Global.sharedInstance.arrayServicesKodsToServer = []
                                Global.sharedInstance.arrayServicesKods = []
                                Global.sharedInstance.whichReveal = true
                                Global.sharedInstance.viewCon = clientStoryBoard.instantiateViewController(withIdentifier: "SupplierListServicesViewController") as?ListServicesViewController
                                if let  _:Array<objProviderServices> =  self.ProviderServicesArray  {
                                    let Anarray =  self.ProviderServicesArray
                                    Global.sharedInstance.viewCon?.ProviderServicesArray   = Anarray
                                    Global.sharedInstance.viewCon?.indexRow = self.indexRow //it is 0 because we are from own supplier only one row then
                                    let USERDEF = Global.sharedInstance.defaults
                                    USERDEF.set(self.indexRow, forKey: "listservicesindexRow")
                                    USERDEF.set(isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
                                    USERDEF.synchronize()
                                    print("aici userdef: \(String(describing: USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")))")
                                    Global.sharedInstance.viewCon?.isfromSPECIALSUPPLIER = true
                                    Global.sharedInstance.viewCon?.isfromSPECIALiCustomerUserId = isfromSPECIALiCustomerUserId
                                    
                                }
                                let USERDEF = Global.sharedInstance.defaults
                                USERDEF.set(3,forKey: "backFromMyListServices")
                                USERDEF.synchronize()
                                frontviewcontroller!.pushViewController(Global.sharedInstance.viewCon!, animated: false)
                                let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                                let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                let mainRevealController = SWRevealViewController()
                                mainRevealController.frontViewController = frontviewcontroller
                                mainRevealController.rearViewController = rearViewController
                                let window :UIWindow = UIApplication.shared.keyWindow!
                                window.rootViewController = mainRevealController
                            }
                        }
                    }
                }
            }
        }
            ,failure: {(AFHTTPRequestOperation, Error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    Alert.sharedInstance.showAlert("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                })
        })
    }
    
    
    
    @IBOutlet weak var imgOpenPrefix: UIImageView!
    
    @IBOutlet weak var txtViewComments: UITextView!
    
    @IBOutlet weak var tblPrefix: UITableView!
    
    var arrPrefix:Array<String> = ["050","052","053","054","058"]
    
    @IBAction func btnVIPyes(_ sender: CheckBoxForExistSupplierOk) {
        btnVIPno.isCecked = false
        btnVIPyes.isCecked = true
        
        
    }
    @IBOutlet weak var btnCancel:UIButton!
    @IBOutlet weak var btnVIPyes: CheckBoxForExistSupplierOk!
    
    @IBAction func btnVIPno(_ sender: CheckBoxForExistSupplierCancel) {
        btnVIPyes.isCecked = false
        btnVIPno.isCecked = true
    }
    @IBOutlet weak var btnVIPno: CheckBoxForExistSupplierCancel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:42)
        self.newiUserStatusType = 26 //put back to default non activated user
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        newiCreatedByUserId = providerID
        PROVIDERID = providerID
        registerForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewCustomerViewController.keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewCustomerViewController.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func checkiflocked() {
        if  isLockedFromEditing == true {
            self.txtFName.isUserInteractionEnabled = false
            self.txtEmail.isUserInteractionEnabled = false
            //            self.txtPhone.isUserInteractionEnabled = false
            self.txtDate.isUserInteractionEnabled = false
        } else {
            self.txtFName.isUserInteractionEnabled = true
            self.txtEmail.isUserInteractionEnabled = false
            //            self.txtPhone.isUserInteractionEnabled = true
            self.txtDate.isUserInteractionEnabled = false
        }
    }
    
    
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        if USERDEF.object(forKey: "isfromSPECIALiCustomerUserId") == nil {
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
        } else {
            if let _:Int = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as? Int {
                let myint = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as! Int
                self.isfromSPECIALiCustomerUserId = myint
            }
        }
        
        
        self.NEWSCROLLVIEW.isScrollEnabled = true
        let contentsize:CGSize = CGSize ( width: self.view.frame.size.width, height: self.view.frame.size.height * 1.3)
        self.NEWSCROLLVIEW.contentSize = contentsize
        LABELFULLName.text = "FULLNAME_STAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELPHONENumber.text = "PHONE_STAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELEmail.text = "EMAIL_LBL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELDateofBirth.text = "DATEBURN_LBL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELNOtes.text = "REMARK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELTITLEOFPAGE.text = "ADD_NEW_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnAddCustomer.setTitle("ADD_NEW_CUSTOMMER".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnMakeAppointment.setTitle("MAKE_new_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 {
        if Global.sharedInstance.employeesPermissionsArray.contains(4) && !Global.sharedInstance.employeesPermissionsArray.contains(1) {
            btnMakeAppointment.isUserInteractionEnabled = false
            btnMakeAppointment.backgroundColor = Colors.sharedInstance.color6
        }
        }
        LABELREQUIREDFIELD.text = "REQUIRED_FIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELFULLName.sizeToFit()
        LABELPHONENumber.sizeToFit()
        LABELEmail.sizeToFit()
        LABELDateofBirth.sizeToFit()
        LABELNOtes.sizeToFit()
        LABELTITLEOFPAGE.sizeToFit()
        LABELREQUIREDFIELD.sizeToFit()
        NEWSCROLLVIEW.delegate = self
        
        /////// tblPrefix.hidden = true
        dP.backgroundColor = Colors.sharedInstance.color1
        dP.setValue(UIColor.white, forKeyPath: "textColor")
        dP.setValue(0.8, forKeyPath: "alpha")
        dP.datePickerMode = UIDatePicker.Mode.date
        // self.NEWSCROLLVIEW.bringSubviewToFront(dP)
        dP.isHidden = true
        self.view.bringSubviewToFront(dP)
        let gregorian: Foundation.Calendar = Foundation.Calendar(identifier: .gregorian)
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.year = -80
        let minDate: Date = (gregorian as NSCalendar).date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        
        components.year = -0
        let maxDate: Date = (gregorian as NSCalendar).date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        dP.minimumDate = minDate
        dP.maximumDate = maxDate
        components.day = 1
        components.month = 1
        components.year = 2000 //be 2000...
        let STARTDate: Date = gregorian.date(from: components)!
        //(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        dP.date = STARTDate
        txtDate.delegate = self
        
        
        txtDate.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        
        dP.addTarget(self, action: #selector(AddNewCustomerViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        txtFName.delegate = self
        txtLName.delegate = self
        txtPhone.delegate = self
        txtEmail.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.delegate = self
        self.txtEmail.isUserInteractionEnabled = false
        self.txtDate.isUserInteractionEnabled = false
        view.addGestureRecognizer(tap)
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            dP.locale = Locale(identifier: "he_IL")
        } else {
            // English
            dP.locale = Locale(identifier: "en_GB")
        }
        
        LABELPHONENumber.adjustsFontSizeToFitWidth = true
        LABELEmail.adjustsFontSizeToFitWidth = true
        LABELNOtes.adjustsFontSizeToFitWidth = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtPhone
        {
            
            txtPhone.text = ""
            newiUserStatusType = 26
//            txtEmail.text = ""
            txtDate.text = ""
//            txtFName.text = ""
//            txtFName.isUserInteractionEnabled = true
            txtEmail.isUserInteractionEnabled = true
            return true
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        // self.deregisterFromKeyboardNotifications()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //   MARK: - DatePicker
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateServer = sender.date
        txtDate.text = dateFormatter.string(from: sender.date)
    }
    //commit c
    
    // MARK: - KeyBoard
    
    //=======================KeyBoard================
    
    
    @objc func dismissKeyboard() {
        dP.isHidden = true
        view.endEditing(true)
        
    }
    
    // MARK: - TextField
    //=========================TextField==============
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        if textField.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || textField.text == "MAIL_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE) || textField.text == "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE) || textField.text == "PHONE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE) || textField.text == "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE) || textField.text == "MAIL_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE) ||
            textField.text == "MAIL_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE) ||  textField.text == "CUSTOMER_EXIST2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            textField.text = ""
            textField.textColor = UIColor.black
        }
        
        if textField == txtDate
        {
            textField.inputView = UIView()
            dP.isHidden = false
        }
        else
        {
            dP.isHidden = true
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true;
    }
    func checkfnameValid (_ textfield: UITextField) {
        if txtFName.text == "" || txtFName.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtFName.text == "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE){
            isValidFirstName = false
            txtFName.text = "REQUIRED_FIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            txtFName.textColor = UIColor.red
        }
        else{
            let fullNameVerify = txtFName.text! as String
            let bar = fullNameVerify
                .components(separatedBy: " ")
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            
            let fullNameArr = bar.components(separatedBy: " ")
            //   let fullNameArr = fullNameVerify.componentsSeparatedByString(" ")
            let myArray : NSMutableArray = []
            let size = fullNameArr.count
            //\\print ("size of my arr \(size)")
            if(size > 1) {
                for item in fullNameArr {
                    if(item.characters.count > 0) {
                        print("Found \(item)")
                        myArray.add(item)
                    }
                }
                let sizemutablearray = myArray.count
                for item in myArray {
                    print("Found myArray\(item)")
                }
                if(sizemutablearray > 1 ) {
                    if let _:String = myArray.object(at: 0) as? String {
                        firstNameVerify = myArray.object(at: 0) as! String
                        
                    }
                    if let _:String = myArray.object(at: 1) as? String {
                        lastNameVerify = myArray.object(at: 1) as! String
                        self.txtLName.text = lastNameVerify
                    }
                    
                }
                print("firstNameVerify\(firstNameVerify)")
                print("lastNameVerify\(lastNameVerify)")
                if(firstNameVerify.characters.count < 2  || isValidName(firstNameVerify) == false || isValidName(lastNameVerify) == false || lastNameVerify.characters.count < 2 ) {
                    isValidFirstName = false
                    txtFName.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    txtFName.textColor = UIColor.red
                }
                else {
                    isValidFirstName = true
                }
            } else {
                isValidFirstName = false
                txtFName.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                txtFName.textColor = UIColor.red
                
            }
        }
        
    }
    func checkmailvalid (_ textField: UITextField) {
        if txtEmail.text == "" || txtEmail.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) ||  txtEmail.text == "CUSTOMER_EXIST2".localized(LanguageMain.sharedInstance.USERLANGUAGE){
            isValidEmail = false
            txtEmail.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)//"שדה חובה*"
            txtEmail.textColor = UIColor.red
        }
        else if !Validation.sharedInstance.mailValidation(txtEmail.text!){
            isValidEmail = false
            txtEmail.text = "MAIL_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)//"חובה להכניס אימייל תקין*"
            txtEmail.textColor = UIColor.red
        }
        else{
            //  isValidEmail = true
            if isLockedFromEditing == false {
                validationMail()
            }
            
            
        }
    }
    
    func checktelephonevalid(_ textField: UITextField) {
        if txtPhone.text == "" || txtPhone.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) ||  txtPhone.text == "CUSTOMER_EXIST2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            isValidPhone = false
            txtPhone.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)//"שדה חובה*"
            txtPhone.textColor = UIColor.red
        }
        else{
            //GLOBALPHONEValidation ->//  isValidPhone = true
            let index0 = self.txtPhone.text?.characters.index((self.txtPhone.text?.startIndex)!, offsetBy: 0)
            let index1 = self.txtPhone.text?.characters.index((self.txtPhone.text?.startIndex)!, offsetBy: 1)
            if self.txtPhone.text?.characters.count < 10 || (self.txtPhone.text?.characters[index0!] != "0" || self.txtPhone.text?.characters[index1!] != "5")
            {
                
                self.isValidPhone = false
                self.txtPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                self.txtPhone.textColor = UIColor.red
            }
            let specialCharacterRegEx  = "[*]?[0-9]+"
            let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            let specialresult = texttest2.evaluate(with: self.txtPhone.text)
            if (specialresult) {
                //                if isLockedFromEditing == false {
                validationPhone()
                //                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFName {
            self.checkfnameValid(txtFName)
        }
        //        if textField == txtEmail {
        //            self.checkmailvalid(txtEmail)
        //        }
        if textField == txtPhone {
            self.checktelephonevalid(txtPhone)
        }
    }
    func isValidName(_ input: String) -> Bool {
        var numSpace = 0
        for chr in input.characters {
            //    //\\print ("verifychr \(chr)")
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr >= "א" && chr <= "ת") && !(chr >= "0" && chr <= "9") && chr != " " && chr != "’" && chr != "‘"  && chr != "“" && chr != "'" && chr != "\"" && chr != "”" && chr != "“" && chr != "”" && chr != "׳" && (input.isRussiantext(title: input) == false) ) {
                return false
            }
            if chr == " "
            {
                numSpace += 1
            }
        }
        if numSpace == input.characters.count || numSpace == input.characters.count - 1// אם יש רק רווחים או רק אות אחת והשאר רווחים
        {
            return false
        }
        else if numSpace > 0
        {
            let bar = input
                .components(separatedBy: " ")
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            
            let arr = bar.components(separatedBy: " ")
            // let arr = input.componentsSeparatedByString(" ")
            for word in arr {
                if word.characters.count == 1
                {
                    return false
                }
            }
        }
        return true
    }
    //CheckCustomerExistByPhone(string nvPhone)  return an integer for iUserId ////////  if customer does not exist returns 0
    
    func validationPhone()      //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
    {
        var flag = true
        arrGoodPhone = []
        var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var cleannumber:String = ""
        if self.txtPhone.text != "" {
            cleannumber = self.cleanPhoneNumber(self.txtPhone.text!)
        }
        dicPhone["nvPhone"] = cleannumber as AnyObject
        self.generic.showNativeActivityIndicator(self)
        
        
        if Reachability.isConnectedToNetwork() == false//if there is connection
        {
                    self.generic.hideNativeActivityIndicator(self)
//            DispatchQueue.main.async(execute: { () -> Void in
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
//            })
        }
        else
        {
            api.sharedInstance.CheckCustomerExistByPhone(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    self.isCheckPhoneEnd = true
                    print("numar verifica \(String(describing: RESPONSEOBJECT["Result"]))")
                    if RESPONSEOBJECT["Result"] as! Int == 0 //phone not found
                    {
                        //\\print (responseObject["Result"])
                        if self.txtPhone.text!.characters.count > 2 {
                            let numertocompare = self.txtPhone.text
                            let index0 = numertocompare!.characters.index(numertocompare!.startIndex, offsetBy: 0)
                            let index1 = numertocompare!.characters.index(numertocompare!.startIndex, offsetBy: 1)
                            if self.txtPhone.text!.characters.count != 10 || (self.txtPhone.text?.characters[index0] != "0" || self.txtPhone.text?.characters[index1] != "5") {
                                self.txtPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                self.isValidPhone = false
                                self.txtPhone.textColor = UIColor.red
                                flag = false
                                Global.sharedInstance.isValid_Phone = true
                                self.newiUserStatusType = 26
                                return
                            }
                        }
                        if  self.txtPhone.text != ""
                        {
                            for char in (self.txtPhone.text?.characters)!
                            {
                                if (char >= "0" && char <= "9") || char == "*"
                                {
                                    let c:Character = char
                                    self.arrGoodPhone.append(c)
                                }
                                else
                                {
                                    self.txtPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                    self.isValidPhone = false
                                    self.txtPhone.textColor = UIColor.red
                                    flag = false
                                    self.newiUserStatusType = 26
                                    break
                                }
                            }
                            if flag == true
                            {
                                self.isValidPhone = true
                                self.txtPhone.textColor = UIColor.black
                            }
                        }
                        
                        self.newiUserStatusType = 26
                        
                    } else
                    {
                        //since after number exist we don' t need to go far
                        let Myarray:NSMutableArray = Global.sharedInstance.nameCostumersArray as NSMutableArray
                        var isalreadyadded:Bool = false
                        for item in Myarray {
                            let MYmutableDictionary:NSDictionary = item as! NSDictionary
                            if let nvPhone:String = MYmutableDictionary["nvPhone"] as? String {
                                let partialnumber = self.txtPhone.text!
                                let compareresult = String(partialnumber.characters.prefix(1))
                                let modified = partialnumber.replace(compareresult, withString:"")
                                let finalservernumber = "0972" + modified
                                if nvPhone == finalservernumber    //JMODE 15.01.2018 self.txtPhone.text
                                {
                                    isalreadyadded = true
                                    self.isLockedFromEditing = false
                                    self.checkiflocked()
                                    self.txtPhone.text = "CUSTOMER_EXIST2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                    self.txtPhone.textColor = UIColor.red
                                    self.generic.hideNativeActivityIndicator(self)
                                    self.isValidPhone = false
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        Alert.sharedInstance.showAlert("CUSTOMER_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                                    })
                                    break
                                }
                            }
                        }
                        if isalreadyadded == false {
                            //                            if self.self.isLockedFromEditing == false {
                            if let iUserID:Int = RESPONSEOBJECT["Result"] as? Int {
                                self.getCustomer(iUserID)
                                return
                            }
                            //                            }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                print("Error: ", Error!.localizedDescription)
                self.generic.hideNativeActivityIndicator(self)
//                DispatchQueue.main.async(execute: { () -> Void in
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
//                })
            })
        }
    }
    func validationMail()      //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
    {
        var flag = true
        var dicMail:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicMail["nvMail"] = txtEmail.text as AnyObject
        ///בדיקה שהטלפון לא קיים כבר במערכת
        self.generic.showNativeActivityIndicator(self)
        
        if Reachability.isConnectedToNetwork() == false//if there is connection
        {
            self.generic.hideNativeActivityIndicator(self)
//            DispatchQueue.main.async(execute: { () -> Void in
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
//            })
        }
        else
        {
            api.sharedInstance.CheckCustomerExistByMail(dicMail, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    self.isCheckPhoneEnd = true
                    // print("numar verifica \(responseObject["Result"])")
                    if RESPONSEOBJECT["Result"] as! Int == 0 //mail not found
                    {
                        if  self.txtEmail.text != ""// לא תקין
                        {
                            if Validation.sharedInstance.mailValidation(self.txtEmail.text!) {
                                flag = true
                            } else {
                                
                                self.txtEmail.text = "MAIL_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                self.isValidEmail = false
                                self.txtEmail.textColor = UIColor.red
                                flag = false
                                return
                            }
                            
                            if flag == true
                            {
                                self.isValidEmail = true
                                self.txtEmail.textColor = UIColor.black
                            }
                        }
                    }
                    else {
                        //since after mail exist we don' t need to go far
                        let Myarray:NSMutableArray = Global.sharedInstance.nameCostumersArray as NSMutableArray
                        var isalreadyadded:Bool = false
                        for item in Myarray {
                            let MYmutableDictionary:NSDictionary = item as! NSDictionary
                            if let nvPhone:String = MYmutableDictionary["nvMail"] as? String {
                                if nvPhone == self.txtEmail.text
                                {
                                    isalreadyadded = true
                                    self.isLockedFromEditing = false
                                    self.checkiflocked()
                                    self.txtEmail.text = "CUSTOMER_EXIST2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                    self.txtEmail.textColor = UIColor.red
                                    self.generic.hideNativeActivityIndicator(self)
                                    self.isValidEmail = false
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        Alert.sharedInstance.showAlert("CUSTOMER_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                                    })
                                    self.generic.hideNativeActivityIndicator(self)
                                    break
                                }
                            }
                        }
                        if isalreadyadded == false {
                            if self.isLockedFromEditing == false {
                                if let iUserID:Int = RESPONSEOBJECT["Result"] as? Int {
                                    self.getCustomer(iUserID)
                                    self.generic.hideNativeActivityIndicator(self)
                                    return
                                }
                            }
                        }
                    }
                    self.generic.hideNativeActivityIndicator(self)
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                print("Error: ", Error!.localizedDescription)
                self.generic.hideNativeActivityIndicator(self)
//                DispatchQueue.main.async(execute: { () -> Void in
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
//                })
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        fDidBegin = false
        timer?.invalidate()
        timer = nil
        if true {
            
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.doDelayed), userInfo: string, repeats: false)
            
            
            var startString = ""
            if (textField.text != nil)
            {
                startString += textField.text!
            }
            startString += string
            
            
            
            if textField == txtPhone
            {
                
                var cleanNumber:String = ""
                if string.count > 1
                {
                    
                    var cleanedString: String = (string.components(separatedBy: CharacterSet(charactersIn: "0123456789-+()").inverted) as NSArray).componentsJoined(by: "")
                    print("cleaned string \(cleanedString)")
//                    cleanedString = "+972505119721" // modedphone    String    "+972505119731"
                    if cleanedString != ""
                    {
                        let first3 = cleanedString.substring(to:cleanedString.index(cleanedString.startIndex, offsetBy: 3))
                        if first3 == "009"
                        {
                            let start = cleanedString.index(cleanedString.startIndex, offsetBy: 2)
                            let end = cleanedString.endIndex
                            let range = start..<end
                            
                            let mySubstring = cleanedString[range]
                            
                            cleanedString = "+" + mySubstring
                            
                        }
                        cleanNumber = cleanPhoneNumber(cleanedString)
                        print("smart paste cleaned string: \(cleanNumber)")
                    }
                    if cleanNumber.characters.count > 2 {
                        let numertocompare = cleanNumber
                        let index0 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 0)
                        let index1 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 1)
                        if numertocompare.characters.count != 10 || (numertocompare.characters[index0] != "0" || numertocompare.characters[index1] != "5")
                        {
                            Alert.sharedInstance.showAlert("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            //                                            ignore all bad numbers
                            
                            return false
                            
                        }
                        else
                        {
                            textField.text = cleanNumber
                            return false
                        }
                    }
                    
                    
                }
                
                if startString.characters.count > 10
                {    txtPhone.resignFirstResponder()
                    Alert.sharedInstance.showAlert("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    return false
                }
                    
                else
                {
                    //                    textField.text = cleanNumber
                    return true
                }
                
                
            }
            
            
            
            
        }
        return true
    }
    @objc func doDelayed(_ t: Timer) {
        if fDidBegin == true
        {
            fDidBegin = false
        }
        else
        {
            dismissKeyboard()
        }
        timer = nil
    }
    @objc func keyboardWasShown(_ notification: Notification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.NEWSCROLLVIEW.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.NEWSCROLLVIEW.contentInset = contentInsets
        self.NEWSCROLLVIEW.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let _ = txtViewComments
        {
            
            if (!aRect.contains(txtViewComments!.frame.origin))
            {
                self.NEWSCROLLVIEW.scrollRectToVisible(txtViewComments!.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification){
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0,left: 0.0, bottom: -keyboardSize!.height /* + (self.navigationController?.navigationBar.frame.size.height)!*/, right: 0.0)
        self.NEWSCROLLVIEW.contentInset = contentInsets
        self.NEWSCROLLVIEW.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.NEWSCROLLVIEW.isScrollEnabled = false
        
    }
    func getCustomer(_ iUserid:Int)
    {
        
        var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetCustomerDetails["iUserId"] = iUserid as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            DispatchQueue.main.async(execute: { () -> Void in
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
//            })
        }
        else
        {
            api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                        print("customer existent \(RESPONSEOBJECT["Result"] ?? "ceva" as AnyObject) )")
                        /*
                         customer existent {
                         bAdvertisingApproval = 0;
                         bAutomaticUpdateApproval = 1;
                         bDataDownloadApproval = 1;
                         bIsGoogleCalendarSync = 0;
                         bTermOfUseApproval = 1;
                         dBirthdate = "<null>";
                         dMarriageDate = "<null>";
                         iCalendarViewType = "<null>";
                         iCityType = 1;
                         iCreatedByUserId = 0;
                         iLastModifyUserId = 0;
                         iSysRowStatus = 0;
                         iUserId = 5;
                         iUserStatusType = 24;
                         nvFirstName = client;
                         nvImage = "<null>";
                         nvImageFilePath = "<null>";
                         nvLastName = unu;
                         nvMail = "g@b.mm";
                         nvPassword = "";
                         nvPhone = 0541258258;
                         nvSupplierNotes = "<null>";
                         nvUserName = "g@b.mm";
                         nvVerification = 5825;
                         }
                         */
                        //now autofill fields
                        var dBirthdate:Date = Date()
                        if let somethingelse6 =   RESPONSEOBJECT["Result"]!["dBirthdate"] as? String
                        {
                            dBirthdate = Global.sharedInstance.getStringFromDateString(somethingelse6)
                            let aBIRTHDATE:String = self.getCurrentShortDate(dBirthdate)
                            self.txtDate.text = aBIRTHDATE
                            self.dP.date = self.getDateFromString(aBIRTHDATE)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = .none
                            dateFormatter.dateFormat = "dd/MM/yyyy"
                            self.dateServer = self.dP.date
                            print(" self.dateServer \(self.dateServer)")
                        } else {
                            self.txtDate.text = ""
                        }
                        if let somethingelse2:Int =  RESPONSEOBJECT["Result"]!["iUserId"] as? Int
                        {
                            self.newiUserId = somethingelse2
                            let USERDEF = Global.sharedInstance.defaults
                            USERDEF.setValue(self.newiUserId, forKey: "isfromSPECIALiCustomerUserId")
                            USERDEF.synchronize()
                            print(USERDEF.value(forKey: "isfromSPECIALiCustomerUserId"))
                        }
                        print("STRiCustomerUserId \(self.newiUserId)")
                        
                        var STRinvFirstName:String = ""
                        if let somethingelse3 =  RESPONSEOBJECT["Result"]!["nvFirstName"] as? String
                        {
                            STRinvFirstName = somethingelse3
                            
                        }
                        
                        var STRnvLastName:String = ""
                        if let somethingelse4 =  RESPONSEOBJECT["Result"]!["nvLastName"] as? String
                        {
                            STRnvLastName = somethingelse4
                        }
                        let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
                        
                        
                        if STRnvFullName.characters.count > 0 { self.isValidFirstName = true }
                        self.txtFName.text = STRnvFullName
                        self.txtFName.textColor = UIColor.black
                        self.firstNameVerify = STRinvFirstName
                        self.lastNameVerify = STRnvLastName
                        var STRnvMail:String = ""
                        if let somethingelse5 =  RESPONSEOBJECT["Result"]!["nvMail"] as? String
                        {
                            STRnvMail = somethingelse5
                            self.txtEmail.text = STRnvMail
                            self.txtEmail.textColor = UIColor.black
                        }
                        if STRnvMail.characters.count > 0 { self.isValidEmail = true }
                        var STRnvPhone:String = ""
                        if let somethingelse6 =   RESPONSEOBJECT["Result"]!["nvPhone"] as? String
                        {
                            STRnvPhone = somethingelse6
                            self.txtPhone.text = STRnvPhone
                            self.txtPhone.textColor = UIColor.black
                        }
                        if STRnvPhone.characters.count > 0 { self.isValidPhone = true }
                        if let somethingelse:Bool =  RESPONSEOBJECT["Result"]!["bIsVip"] as? Bool {
                            if(somethingelse == true) {
                                self.btnVIPno.isCecked = false
                                self.btnVIPyes.isCecked = true
                            }
                        } else {
                            self.btnVIPno.isCecked = true
                            self.btnVIPyes.isCecked = false
                        }
                        //// iCreatedByUserId :newiCreatedByUserId
                        if let INTiCreatedByUserId:Int =  RESPONSEOBJECT["Result"]!["iCreatedByUserId"] as? Int {
                            if INTiCreatedByUserId != self.PROVIDERID {
                                self.newiCreatedByUserId = INTiCreatedByUserId
                            }
                        }
                        print("self.newiUserStatusType before get data\(self.newiUserStatusType)")
                        //// this is essential  24 is activated 25 is non activated  _iUserStatusType : newiUserStatusType
                        if let somethingelseINT:Int =  RESPONSEOBJECT["Result"]!["iUserStatusType"] as? Int
                        {
                            self.newiUserStatusType = somethingelseINT
                            print("self.newiUserStatusType after get data\(self.newiUserStatusType)")
                        }
                        
                        if( self.newiUserStatusType == 26 &&  self.newiCreatedByUserId == self.PROVIDERID  ) {
                            self.isLockedFromEditing = false
                            self.checkiflocked()
                        } else  if( self.newiUserStatusType == 26 &&  self.newiCreatedByUserId != self.PROVIDERID  ) {
                            self.isLockedFromEditing = false
                            self.checkiflocked()
                        }  else {
                            self.isLockedFromEditing = true
                            self.checkiflocked()
                        }
                        var STRnvImage:String = ""
                        if let somethingelse =  RESPONSEOBJECT["Result"]!["nvImage"] as? String
                        {
                            STRnvImage = somethingelse
                        }
                        print("STRnvImage \(STRnvImage)")
                        //                        var STRnvSupplierNotes = ""
                        //                        if let nvSupplierNotes:String = d.objectForKey("nvSupplierNotes") as? String {
                        //                            if(nvSupplierNotes.characters.count == 0) {
                        //                                STRnvSupplierNotes = nvSupplierNotes
                        //
                        //                            } else {
                        //                                STRnvSupplierNotes = ""
                        //                            }
                        //                        }
                        
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
//                        AppDelegate.showAlertInAppDelegate = true
//                    })
//                }
            })
        }
    }
    func getCurrentShortDate(_ dateTOConvert:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let DateInFormat = dateFormatter.string(from: dateTOConvert)
        print("formatted date is =  \(DateInFormat)")
        return DateInFormat
    }
    
    func getDateFromString(_ dateString: String)->Date
    {
        var datAMEA:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.dateStyle = .short
        print("crASH \(dateString)")
        if let  _ = dateFormatter.date(from: dateString) {
            datAMEA = dateFormatter.date(from: dateString)!
            print("datestring \(getDateFromString) si data \(datAMEA)")
        }
        return datAMEA
    }
    
}

extension String
{
    func stringByReplacingFirstOccurrenceOfString(
        target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}
