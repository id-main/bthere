//
//  UpdateCustomerViewController.swift
//  bthree-ios
//
//  Created by Ungureanu Ioan on 1.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//
/*
 metoda pt update customer al unui supplier UpdateSupplierCustomer:
 
 {
 "iSupplierId": 15,
 "objProviderCustomer": {
 "iCustomerUserId": 73,
 "nvFirstName": "first 1",
 "nvLastName": "last 1",
 "dBirthdate": "\/Date(1422223200000)\/",
 "nvMail": "first1@test.com",
 "nvPhone": "039867326755",
 "bIsVip": 1,
 "nvSupplierRemark": "customer 73 updated"
 }
 }
 */
import UIKit
import PhoneNumberKit
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

//תת דף הוספת לקוח  מתוך לקוחות שלי
class UpdateCustomerViewController: NavigationModelViewController,UITextFieldDelegate,UIGestureRecognizerDelegate, UIScrollViewDelegate {
    var userdBirthdate:String = ""
    var delegate:reloadall!=nil
    let phoneNumberKit = PhoneNumberKit()
    var row:Int = 0
    var arrGoodPhone:Array<Character> = Array<Character>()
    var isValidFirstName:Bool = true
    var isValidLastName:Bool = true
    var isValidAdress:Bool = true
    var isValidEmail:Bool = true
    var isValidPhone:Bool = true
    var isCheckPhoneEnd:Bool = false
    var timer: Timer? = nil
    var fDidBegin = false
    var isLockedFromEditing:Bool = false //in case of existing user in db the fields will be locked from edit
    var newiUserId:Int = 0
    var GETFROMSERVERiUserId:Int = 0
    var newiUserStatusType:Int = 26
    var PROVIDERID:Int = 0
    var newiCreatedByUserId:Int = 0
    //JMODE +
    var isFORSETUPAPPOIMENT:Bool = false
    var firstNameVerify:String = ""
    var lastNameVerify:String = ""
    var telefonSalvatDeja:String = ""
    var mailSalvatDeja:String = ""
    var SalvatnvSupplierRemark:String = ""
    var dateServer = Date()
    var d:NSDictionary = NSDictionary()
    @IBOutlet weak var LABELFULLName: UILabel!
    @IBOutlet weak var LABELPHONENumber: UILabel!
    @IBOutlet weak var LABELEmail: UILabel!
    @IBOutlet weak var LABELDateofBirth: UILabel!
    @IBOutlet weak var LABELNOtes: UILabel!
    @IBOutlet weak var LABELTITLEOFPAGE: UILabel!
    @IBOutlet weak var LABELREQUIREDFIELD: UILabel!
    @IBOutlet weak var NEWSCROLLVIEW: UIScrollView!
    var generic:Generic = Generic()
    
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
    
    @IBOutlet weak var btnupDateCustomer: UIButton!
    
    @IBAction func upDateCustomer(_ sender: AnyObject) {
        
        dismissKeyboard()
        //send to server after validation
        if(/*self.isValidEmail == true && */ self.isValidPhone == true && self.isValidFirstName == true) {
            validToUpdate()
        } else {
            self.checkfnameValid(txtFName)
            //  self.checkmailvalid(txtEmail)
            self.checktelephonevalid(txtPhone)
        }
    }
    
    
    
    @IBOutlet weak var imgOpenPrefix: UIImageView!
    
    @IBOutlet weak var txtViewComments: UITextView!
    
    @IBOutlet weak var tblPrefix: UITableView!
    
    var arrPrefix:Array<String> = ["050","052","053","054","058"]
    
    @IBAction func btnVIPyes(_ sender: CheckBoxForExistSupplierOk) {
        btnVIPno.isCecked = false
        btnVIPyes.isCecked = true
        
        
    }
    @IBOutlet weak var btnVIPyes: CheckBoxForExistSupplierOk!
    
    @IBAction func btnVIPno(_ sender: CheckBoxForExistSupplierCancel) {
        btnVIPyes.isCecked = false
        btnVIPno.isCecked = true
    }
    @IBOutlet weak var btnVIPno: CheckBoxForExistSupplierCancel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:46) 
        self.newiUserStatusType = 26 //put back to default non activated user
        print("update newiUserId\(newiUserId)")
        self.PROVIDERID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

        
        registerForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func checkiflocked() {
        if  isLockedFromEditing == true {
            self.txtFName.isUserInteractionEnabled = false
            self.txtEmail.isUserInteractionEnabled = false
            self.txtPhone.isUserInteractionEnabled = false
            self.txtDate.isUserInteractionEnabled = false
        } else {
            self.txtFName.isUserInteractionEnabled = true
            self.txtEmail.isUserInteractionEnabled = false
            self.txtDate.isUserInteractionEnabled = false
            self.txtPhone.isUserInteractionEnabled = true
            
        }
        if self.newiUserStatusType == 26
        {
            self.txtPhone.isUserInteractionEnabled = false
        }
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
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
    func validToUpdate()
    {
        if isValidPhone == true  /*&& isValidEmail == true && isValidLastName == true */ &&
            isValidFirstName == true{
            if Reachability.isConnectedToNetwork() == false
            {
//                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else {
                /*
                 {
                 "iSupplierId": 15,
                 "objProviderCustomer": {
                 "iCustomerUserId": 73,
                 "nvFirstName": "first 1",
                 "nvLastName": "last 1",
                 "dBirthdate": "\/Date(1422223200000)\/",
                 "nvMail": "first1@test.com",
                 "nvPhone": "039867326755",
                 "bIsVip": 1,
                 "nvSupplierRemark": "customer 73 updated"
                 }
                 }
                 */
                var nvNickName:String = ""
                
                
                var dicUpdateUSER:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicUpdateUSER["iSupplierId"] = String(self.PROVIDERID) as AnyObject
                var dicobjProviderCustomer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicobjProviderCustomer["iCustomerUserId"] = String(newiUserId) as AnyObject
                if  self.newiUserStatusType == 26 {
                    dicobjProviderCustomer["nvFirstName"] = "" as AnyObject
                    dicobjProviderCustomer["nvLastName"] = "" as AnyObject
                    nvNickName = firstNameVerify + " " + lastNameVerify
                    
                } else {
                    
                    dicobjProviderCustomer["nvFirstName"] = firstNameVerify as AnyObject
                    dicobjProviderCustomer["nvLastName"] = lastNameVerify  as AnyObject
                    
                }
                //self.userdBirthdate
                dicobjProviderCustomer["dBirthdate"] = convertNSDateToString(self.dateServer) as AnyObject
               // dicobjProviderCustomer["dBirthdate"] = self.userdBirthdate as AnyObject
                dicobjProviderCustomer["nvMail"] = self.txtEmail.text! as AnyObject
                dicobjProviderCustomer["nvPhone"] = self.txtPhone.text! as AnyObject
                dicobjProviderCustomer["nvSupplierRemark"] = self.txtViewComments.text! as AnyObject
                dicobjProviderCustomer["bIsVip"] = false as AnyObject
                dicUpdateUSER["nvNickName"] = nvNickName as AnyObject
                if   btnVIPyes.isCecked == true {
                    dicobjProviderCustomer["bIsVip"] = true as AnyObject
                }
                dicUpdateUSER["objProviderCustomer"] = dicobjProviderCustomer as AnyObject
                print("what to send \(dicUpdateUSER)")
                
                
                print("\n********************************* update  customer  ********************\n")
                //                let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicUpdateUSER, options: NSJSONWritingOptions.PrettyPrinted)
                //                let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
                //\\print(jsonString)
                
                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)
//                    showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else
                {
                    api.sharedInstance.UpdateSupplierCustomer(dicUpdateUSER, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            //todo afisez eroare
                            
                            print("eroare la update cust \(RESPONSEOBJECT["Error"] ?? 1 as AnyObject)")
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            //todo afisez eroare
                            
                            print("eroare la update cust \(RESPONSEOBJECT["Error"] ?? -2 as AnyObject)")
                        }
                            
                        else
                        {
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                if myInt > 0 {
                                    print("e ok " + myInt.description)
                                    
                                    
                                    
                                    self.showAlertDelegateX("SUCCES_CUSTOMER_UPDATE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    
                                    //                                        Global.sharedInstance.defaults.setInteger(1, forKey: "refreshcustomer")
                                    //                                        Global.sharedInstance.defaults.synchronize()
                                    self.deregisterFromKeyboardNotifications()
                                    self.delegate.reloadTable()
                                    self.dismiss(animated: true, completion:nil)
                                    
                                    
                                } else {
                                    
//                                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                            }
                        }
                            }
                        }
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
//                            if AppDelegate.showAlertInAppDelegate == false
//                            {
//                                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                                AppDelegate.showAlertInAppDelegate = true
//                            }
                    })
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCustomer(newiUserId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LABELFULLName.text = "FULLNAME_STAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELPHONENumber.text = "PHONE_STAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELEmail.text = "EMAIL_LBL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELDateofBirth.text = "DATEBURN_LBL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELNOtes.text = "REMARK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LABELTITLEOFPAGE.text = "UPDATE_CUSTOMER_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnupDateCustomer.setTitle("SIMPLE_BUTTON_UPDATE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
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
        txtDate.delegate = self
        components.day = 1
        components.month = 1
        components.year = 2000 //be 2000...
        let STARTDate: Date = gregorian.date(from: components)!
        //(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        dP.date = STARTDate
        
        txtDate.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        
        dP.addTarget(self, action: #selector(AddNewCustomerViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        txtFName.delegate = self
        txtLName.delegate = self
        txtPhone.delegate = self
        txtEmail.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        //          btnPrefix.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        // Do any additional setup after loading the view.
        //        let d:NSDictionary = (Global.sharedInstance.searchCostumersArray.objectAtIndex(row) as! NSDictionary) as NSDictionary
        //        //\\    print("ce sterge \(d.description)")
        //        if let nvFullName:String = d.objectForKey("nvFullName") as? String {
        //            //\\print ("nvFullName \(nvFullName)")
        //            txtFName.text = nvFullName
        //        } else {
        //            txtFName.text = ""
        //        }
        //        if let nvPhone:String = d.objectForKey("nvPhone") as? String {
        //            //\\print ("nvPhone \(nvPhone)")
        //            txtPhone.text = nvPhone
        //        } else {
        //            txtPhone.text = ""
        //        }
        //        if let nvMail:String = d.objectForKey("nvMail") as? String {
        //            //\\print ("nvMail \(nvMail)")
        //            txtEmail.text = nvMail
        //        } else {
        //            txtEmail.text = ""
        //        }
        //        if let somethingelse:Int = d.objectForKey("bIsVip") as? Int {
        //            //\\print ("somethingelse \(somethingelse)")
        //            if(somethingelse == 1) {
        //                btnVIPno.isCecked = false
        //                btnVIPyes.isCecked = true
        //            }
        //        } else {
        //            btnVIPno.isCecked = true
        //            btnVIPyes.isCecked = false
        //        }
        //        if let nvSupplierNotes:String = d.objectForKey("nvSupplierRemark") as? String {
        //            //\\print ("NOTES \(nvSupplierNotes)")
        //            if(nvSupplierNotes.characters.count == 0) {
        //                txtViewComments.text = ""
        //
        //            } else {
        //                txtViewComments.text = nvSupplierNotes
        //            }
        //        }
        ////        if let userimg:String = d.objectForKey("nvImage") as? String {
        ////            //\\print ("userimg \(userimg)")
        ////            if(userimg.characters.count == 0) {
        ////                USERIMAGE.image = UIImage(named:"clients@x1.png")
        ////            }
        ////            else {
        ////                let encodedImageData = userimg
        ////                let dataDecoded:NSData = NSData(base64EncodedString: encodedImageData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        ////                let CONVERTEDimage = UIImage(data: dataDecoded)
        ////                USERIMAGE.image = CONVERTEDimage
        ////            }
        ////        }
        //        if let dBirthdate:NSDate = d.objectForKey("dBirthdate") as? NSDate {
        //            let aBIRTHDATE:String = getCurrentShortDate(dBirthdate)
        //            txtDate.text = aBIRTHDATE
        //        } else {
        //            txtDate.text = ""
        //        }
        //iCustomerUserId
        self.txtEmail.isUserInteractionEnabled = false
        self.txtDate.isUserInteractionEnabled = false
        
        LABELPHONENumber.adjustsFontSizeToFitWidth = true
        LABELEmail.adjustsFontSizeToFitWidth = true
        LABELNOtes.adjustsFontSizeToFitWidth = true
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
            //     let fullNameArr = fullNameVerify.componentsSeparatedByString(" ")
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
                if isLockedFromEditing == false {
                    validationPhone()
                }
            }
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFName {
            self.checkfnameValid(txtFName)
        }
        //        if textField == txtEmail {
        //       self.checkmailvalid(txtEmail)
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
            let arr = input.components(separatedBy: " ")
            for word in arr {
                if word.characters.count == 1
                {
                    return false
                }
            }
        }
        return true
    }
    //CheckCustomerExistByPhone(string nvPhone)  returns an integer for iUserId ////////  if  customer not extists returns 0
    
    func validationPhone()
    {
        var flag = true
        arrGoodPhone = []
        var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicPhone["nvPhone"] = txtPhone.text as AnyObject
        ///בדיקה שהטלפון לא קיים כבר במערכת
        self.generic.showNativeActivityIndicator(self)
        
        if Reachability.isConnectedToNetwork() == false//if there is connection
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.CheckCustomerExistByPhone(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.isCheckPhoneEnd = true
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                
                if RESPONSEOBJECT["Result"] as! Int == 0//phone not found
                {
                    print("numar verifica \(String(describing: RESPONSEOBJECT["Result"]))")
                    //\\print (responseObject["Result"])
                    if self.txtPhone.text?.characters.count > 2 {
                        let numertocompare = self.txtPhone.text
                        let index0 = numertocompare!.characters.index(numertocompare!.startIndex, offsetBy: 0)
                        let index1 = numertocompare!.characters.index(numertocompare!.startIndex, offsetBy: 1)
                        if self.txtPhone.text!.characters.count != 10 || (self.txtPhone.text?.characters[index0] != "0" || self.txtPhone.text?.characters[index1] != "5") {
                            self.txtPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            self.isValidPhone = false
                            self.txtPhone.textColor = UIColor.red
                            flag = false
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
                                break
                            }
                        }
                        
                        if flag == true
                        {
                            self.isValidPhone = true
                            self.txtPhone.textColor = UIColor.black
                            //\\   self.validToRegister()
                        }
                    }
                    self.newiUserStatusType = 26
                } else
                {
                    //since after number exist we don' t need to go far
                    //                    self.txtPhone.text = "PHONE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    //                    self.txtPhone.textColor = UIColor.redColor()
                    
                    //                    self.isValidPhone = false
                    //                    let Myarray:NSMutableArray = Global.sharedInstance.nameCostumersArray as NSMutableArray
                    //                    var isalreadyadded:Bool = false
                    //
                    //                    for item in Myarray {
                    //
                    //                        let MYmutableDictionary:NSDictionary = item as! NSDictionary
                    //                        if let nvPhone:String = MYmutableDictionary["nvPhone"] as? String {
                    //                            if nvPhone == self.txtPhone.text
                    //                            {
                    //                                isalreadyadded = true
                    //                                self.isLockedFromEditing = false
                    //                                self.checkiflocked()
                    //                                self.txtPhone.text = "CUSTOMER_EXIST2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    //                                                    self.txtPhone.textColor = UIColor.redColor()
                    
                    //                                                    self.isValidPhone = false
                    //
                    //                                 showAlertDelegateX("CUSTOMER_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    
                    //                                break
                    //                         }
                    //                        }
                    //                    }
                    //                        if isalreadyadded == false {
                    if self.isLockedFromEditing == false {
                        if let iUserID:Int = RESPONSEOBJECT["Result"] as? Int {
                            self.getCustomer(iUserID)
                            
                            return
                        }
                    }
                    
                }
                
                }
                
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    print("Error: ", Error!.localizedDescription)
                    self.generic.hideNativeActivityIndicator(self)
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    func validationMail()
    {
        var flag = true
        
        var dicMail:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicMail["nvMail"] = txtEmail.text as AnyObject
        ///בדיקה שהטלפון לא קיים כבר במערכת
        self.generic.showNativeActivityIndicator(self)
        
        if Reachability.isConnectedToNetwork() == false//if there is connection
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.CheckCustomerExistByMail(dicMail, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.isCheckPhoneEnd = true
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
              
                if RESPONSEOBJECT["Result"] as! Int == 0 //mail not found
                {
                      print("numar verifica \(String(describing: RESPONSEOBJECT["Result"]))")
                    //\\print (responseObject["Result"])
                    
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
                            //\\   self.validToRegister()
                        }
                    }
                }
                else {
                    //since after mail exist we don' t need to go far
                    //                    self.txtEmail.text = "MAIL_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    //                    self.txtEmail.textColor = UIColor.redColor()
                    
                    //                    self.isValidEmail = false
                    //                    return
                    //                    let Myarray:NSMutableArray = Global.sharedInstance.nameCostumersArray as NSMutableArray
                    //                    var isalreadyadded:Bool = false
                    
                    //                    for item in Myarray {
                    //
                    //                        let MYmutableDictionary:NSDictionary = item as! NSDictionary
                    //                        if let nvPhone:String = MYmutableDictionary["nvMail"] as? String {
                    //                            if nvPhone == self.txtEmail.text
                    //                            {
                    //                                isalreadyadded = true
                    //                                self.isLockedFromEditing = false
                    //                                self.checkiflocked()
                    //                                                    self.txtEmail.text = "CUSTOMER_EXIST2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    //                                                    self.txtEmail.textColor = UIColor.redColor()
                    
                    //                                                    self.isValidEmail = false
                    //
                    //                                showAlertDelegateX("CUSTOMER_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    
                    //                                break
                    //                            }
                    //                        }
                    //                    }
                    //                    if isalreadyadded == false {
                    if self.isLockedFromEditing == false {
                        if let iUserID:Int = RESPONSEOBJECT["Result"] as? Int {
                            self.getCustomer(iUserID)
                            
                            return
                        }
                        //   }
                    }
                }
                }
                
                
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    print("Error: ", Error!.localizedDescription)
                    self.generic.hideNativeActivityIndicator(self)
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
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
                if startString.characters.count > 10
                {
                    txtPhone.resignFirstResponder()
                    Alert.sharedInstance.showAlert("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    return false
                }
                else
                {
                    return true
                }
            }
            return true
        }
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
        //        if let _ = txtFName
        //        {
        //                        self.NEWSCROLLVIEW.scrollRectToVisible(btnVIPno!.frame, animated: true)
        //
        //        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification){
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: -keyboardSize!.height  , right: 0.0)
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
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                {
                    
                    print("customer existent \(String(describing: RESPONSEOBJECT["Result"]?.description))")
                    //                    var d:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                    //                    d = responseObject["Result"] as! Dictionary<String,AnyObject>
                    
                    /*
                     ustomer existent {
                     bAdvertisingApproval = 0;
                     bAutomaticUpdateApproval = 1;
                     bDataDownloadApproval = 1;
                     bIsGoogleCalendarSync = 1;
                     bIsManager = 0;
                     bTermOfUseApproval = 1;
                     dBirthdate = "<null>";
                     dMarriageDate = "<null>";
                     iCalendarViewType = "<null>";
                     iCityType = 1;
                     iCreatedByUserId = 702;
                     iLastModifyUserId = 0;
                     iSysRowStatus = 0;
                     iUserId = 7098;
                     iUserStatusType = 26;
                     nvDeviceToken = "<null>";
                     nvFirstName = "";
                     nvImage = "<null>";
                     nvImageFilePath = "<null>";
                     nvLastName = "";
                     nvMail = "";
                     nvNickName = "bianca dragusanu";
                     nvPassword = "";
                     nvPhone = 0523623114;
                     nvUserName = "";
                     nvVerification = "";
                     }
                     */
                    
                    print("self.newiUserStatusType before get data\(self.newiUserStatusType)")
                    //// this is essential  24 is activated 25 is non activated  _iUserStatusType : newiUserStatusType


                    if let somethingelseINT:Int =  RESPONSEOBJECT["Result"]!["iUserStatusType"] as? Int
                    {
                        self.newiUserStatusType = somethingelseINT
                        print("self.newiUserStatusType after get data\(self.newiUserStatusType)")
                    }
                    
                    if let somethingelse2:Int =  RESPONSEOBJECT["Result"]!["iUserId"] as? Int
                    {
                        self.GETFROMSERVERiUserId = somethingelse2
                    }
                    if self.GETFROMSERVERiUserId != self.newiUserId {
                        //date apartin altui user nu are voie sa il editeze
                        self.generic.hideNativeActivityIndicator(self)
                        self.showAlertDelegateX("THOSE_INFOS_ARE_OF_ANOTHER_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        self.txtPhone.text = self.telefonSalvatDeja
                        self.txtEmail.text = self.mailSalvatDeja
                        return
                        
                    } else {
                        print("STRiCustomerUserId \(self.newiUserId)")
                    }
                    
                    //////     print("STRiCustomerUserId \(self.newiUserId)")
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
                    //    self.userdBirthdate  = somethingelse6
                        print(" self.dateServer \(self.dateServer)")
                        
                    } else {
                        //todoself.dateServer = nill null
                        self.txtDate.text = ""
                        
                    }
                    self.txtViewComments.text = self.SalvatnvSupplierRemark
                    
                    
                    
                    //                    var nvSupplierRemark:String = ""
                    //                    if let somethingelse3 =  responseObject["Result"]!["nvSupplierNotes"] as? String
                    //                    {
                    //                        nvSupplierRemark = somethingelse3
                    //                        self.txtViewComments.text = nvSupplierRemark
                    //
                    //                    } else {
                    //                           self.txtViewComments.text = ""
                    //                    }
                    
                    
                    //self.txtViewComments
                    
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
                    var STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
                    
                    
                    
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
                        self.mailSalvatDeja = STRnvMail
                    }
                    if STRnvMail.characters.count > 0 { self.isValidEmail = true }
                    var STRnvPhone:String = ""
                    if let somethingelse6 =   RESPONSEOBJECT["Result"]!["nvPhone"] as? String
                    {
                        STRnvPhone = somethingelse6
                        self.txtPhone.text = STRnvPhone
                        self.txtPhone.textColor = UIColor.black
                        self.telefonSalvatDeja = STRnvPhone
                    }
                    if STRnvPhone.characters.count > 0 { self.isValidPhone = true }
                    if let INTiCreatedByUserId:Int =  RESPONSEOBJECT["Result"]!["iCreatedByUserId"] as? Int {
                        //\\print ("INTiCreatedByUserId \(INTiCreatedByUserId)")
                        if INTiCreatedByUserId != self.PROVIDERID {
                            self.newiCreatedByUserId = INTiCreatedByUserId
                        } else {
                            self.newiCreatedByUserId = self.PROVIDERID
                        }
                    }
                    print("self.newiUserStatusType before get data\(self.newiUserStatusType)")
                    //// this is essential  24 is activated 25 is non activated  _iUserStatusType : newiUserStatusType
                    if let somethingelseINT:Int =  RESPONSEOBJECT["Result"]!["iUserStatusType"] as? Int
                    {
                        self.newiUserStatusType = somethingelseINT
                        print("self.newiUserStatusType after get data\(self.newiUserStatusType)")
                    }
                    let checked_checkbox = UIImage(named: "okSelected.png")
                    let unChecked_checkbox = UIImage(named: "ok_unSelected.png")
                    let no_checkbox = UIImage(named: "Cancel-selected.png")
                    let no_unChecked_checkbox = UIImage(named: "Cancel_unSelected.png")
                    if let somethingelse9:Bool = RESPONSEOBJECT["Result"]!["bIsVip"] as? Bool {
                     print ("somethingelse \(somethingelse9)")
                        if(somethingelse9 == true) {
                            self.btnVIPyes.setImage(checked_checkbox, for:UIControl.State())
                            self.btnVIPno.setImage(no_unChecked_checkbox, for:UIControl.State())
                            self.btnVIPyes.setNeedsDisplay()
                             self.btnVIPno.setNeedsDisplay()
                            self.btnVIPno.isCecked = false
                            self.btnVIPyes.isCecked = true
                        }
                    } else {
                        self.btnVIPyes.setImage(unChecked_checkbox, for:UIControl.State())
                        self.btnVIPno.setImage(no_checkbox, for:UIControl.State())
                        self.btnVIPyes.setNeedsDisplay()
                        self.btnVIPno.setNeedsDisplay()
                        self.btnVIPno.isCecked = true
                        self.btnVIPyes.isCecked = false
                    }
                    
                    //self.dateServer
                    if( self.newiUserStatusType == 26) {//&&  self.newiCreatedByUserId == self.PROVIDERID  ) {
                        self.isLockedFromEditing = false
                        
                        if self.d["nvFullName"] != nil {
                            if let _:String = self.d.object(forKey: "nvFullName") as? String {
                                STRnvFullName = self.d.object(forKey: "nvFullName") as! String
                            }
                            if   STRnvFullName.characters.count > 0  {
                                self.isValidFirstName = true
                                self.txtFName.text = STRnvFullName
                                self.txtFName.textColor = UIColor.black
                                let fullNameArr = STRnvFullName.components(separatedBy: " ")
                                
                                let myArray : NSMutableArray = []
                                let size = fullNameArr.count
                                
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
                                            self.firstNameVerify = myArray.object(at: 0) as! String
                                            
                                        }
                                        if let _:String = myArray.object(at: 1) as? String {
                                            self.lastNameVerify = myArray.object(at: 1) as! String
                                            self.txtLName.text = self.lastNameVerify
                                        }
                                        
                                    }
                                    print("firstNameVerify\(self.firstNameVerify)")
                                    print("lastNameVerify\(self.lastNameVerify)")
                                    
                                }
                            }
                            
                        }
                        self.checkiflocked()
                        
                        
                        
                        
                        
                    } else {
                        self.isLockedFromEditing = true
                        self.checkiflocked()
                        
                    }
                    
                    
                }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    
                    self.generic.hideNativeActivityIndicator(self)
                    
                    
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
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
    func convertNSDateToString(_ dateTOConvert:Date)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //let dateStr = dateFormatter.stringFromDate(dateTOConvert)
        
        var myDateString = String(Int64(dateTOConvert.timeIntervalSince1970 * 1000))
        myDateString = "/Date(\(myDateString))/"
        
        
        return myDateString
    }
    
}

