//
//  JoNewWorkerViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 09/03/2018
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


protocol reloadTblDelegateParentWorker {
    func reloadTbl()
    func showerroemessageforselectall()
    func showerroemessageforaddbreaks()
    func OPENBREAKS()
    func OPENHOURS()
    func showerroemessagenodays()
    func showerroemessageincorrectbreaks()
    func presentVC(_ MYALERT:UIAlertController)
    
}
class JoNewWorkerViewController: NavigationModelViewController, UIGestureRecognizerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, reloadTblDelegateParentWorker {
    var delegateReloadTbl:reloadTblServiceDelegte!=nil
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    let heightiphone:CGFloat = 45.0
    let heightipad:CGFloat = 60.0
    var minusHEIGHT:CGFloat = 120
    var heightforrowsarray:Array<CGFloat> = Array<CGFloat>()
    
    var originframe:CGFloat = 0
    @IBOutlet weak var dynamictableheight:NSLayoutConstraint!
    var originalMAINTABLEorigin: CGFloat = 0.0
    var DELEGATERELOAD:reloadTblDelegateParent!=nil
    @IBOutlet weak var NEWSCROLLVIEW: UIScrollView!
    var selectedTextField:UITextField?
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var btnclose: UIButton!
    @IBOutlet weak var error1: UILabel!
    @IBOutlet weak var error2: UILabel!
    @IBOutlet weak var error3: UILabel!
    var isscrolled:Bool = false //screen was scrolled to previous choosen domain
    var hashoursselected:Bool = true // were bussiness hours selected ?
    var hasfreehoursselected:Bool = true // were bussiness free hours selected ?
    var isOPENBUSINESSHOUR:Bool = true //WORKING HOURS by default
    var isOPENBUSINESSBREAKS:Bool = false //
    @IBOutlet weak var MAINTABLE : UITableView!
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
    var IuserStatus:Int = 25
    var bismanager:Int = 0
    var iUserId:Int = 0
    var LOCALbsameW:Bool = false
    var PROVIDERID:Int = 0
    @IBOutlet weak var blackview:UIView!
    @IBOutlet weak var bottomview:UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var doTheHoursEqualTo: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnNoSelect: checkBoxForDetailsWorker!
    @IBAction func btnNoSelect(_ sender: AnyObject) {
         heightforrowsarray = [0,0,0]
        btnYesSelect.isCecked = false
        btnNoSelect.isCecked = true
        OPENHOURS()
     
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
       
    }
    
    @IBOutlet weak var btnYesSelect: CheckBoxForDetailsWorker2!
    @IBAction func btnYesSelect(_ sender: AnyObject) {
     
        btnYesSelect.isCecked = true
        btnNoSelect.isCecked = false
       isOPENBUSINESSHOUR = false
        isOPENBUSINESSBREAKS = false
        self.reloadTbl()
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
           heightforrowsarray = [0,0,0]
    }
    @IBAction func btnclose(_ sender: AnyObject) {
        dismissKeyboard()
        dimissViewController()
        
    }
    
    @IBAction func btnsave(_ sender: AnyObject){
        dismissKeyboard()
        if saveData() == true {
            
            let USERDEF = UserDefaults.standard
            USERDEF.set(1, forKey: "RELOADAFTERSERVICEADD")
            USERDEF.synchronize()
            DELEGATERELOAD.reloadTbl()
            dimissViewController()
            
        } else {
            showAlert("COMPLETE_REQUIRED_FIELDS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        
        
        
    }
    func presentVC(_ MYALERT:UIAlertController) {
        self.present(MYALERT, animated: true, completion: nil)
    }
    @objc func OPENBREAKS() {
        isOPENBUSINESSHOUR = false
        isOPENBUSINESSBREAKS = true
        reloadTbl()
    }
    func OPENHOURS() {
        isOPENBUSINESSHOUR = true
        isOPENBUSINESSBREAKS = false
        reloadTbl()
    }
    func showerroemessageforselectall() {
        showAlertDelegateX("CANT_SELECT_ALL_DAYS_BEFORE_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
    }
    func showerroemessageforaddbreaks() {
        showAlertDelegateX("SELECT_HOURS_FOR_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
    }
    func showerroemessagenodays() {
        showAlertDelegateX("NO_DAY_SELECTED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
    }
    func showerroemessageincorrectbreaks() {
        self.view.makeToast(message:  "INCORRECT_BREAKS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.hidetoast()
        })
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    func reloadTbl() {
        
        LISTALLWORKINGHOURSFORSERVER()
        self.showSelectedHoursAndDays()
        self.showSelectedRecessAndDays()
        self.MAINTABLE.reloadData()
        
    }
        @objc func refreshtable(){
        
        self.MAINTABLE.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        self.MAINTABLE.delegate = self
        self.MAINTABLE.dataSource = self
        NEWSCROLLVIEW.delegate = self
        NEWSCROLLVIEW.isScrollEnabled = true
        originframe = NEWSCROLLVIEW.frame.origin.y
        heightforrowsarray = [0,0,0]
        drawelements()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //func to dismiss the popUp
   @objc func dimissViewController()  {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    func drawelements(){
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.txtMail.textAlignment = .right
            self.txtPhone.textAlignment = .right
            self.txtFirstName.textAlignment = .right
            lblFirstName.textAlignment = .right
            lblEmail.textAlignment = .right
            lblPhone.textAlignment = .right
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
        doTheHoursEqualTo.text = "\("HOURS_ACTIVE".localized(LanguageMain.sharedInstance.USERLANGUAGE)) \n \("EQUAL_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
        doTheHoursEqualTo.numberOfLines = 0
        isSetData = false
        selfPhoneExist = ""
        selfEmailExist = ""
        txtPhone.delegate = self
        if UIDevice.current.userInterfaceIdiom == .pad {
            doTheHoursEqualTo.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblFirstName.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblPhone.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblEmail.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            error1.font  = UIFont(name: "OpenSansHebrew-Light", size: 19)
            error2.font = UIFont(name: "OpenSansHebrew-Light", size: 19)
            error3.font = UIFont(name: "OpenSansHebrew-Light", size: 19)
        } else {
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
            {
                doTheHoursEqualTo.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblFirstName.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblPhone.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblEmail.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                error1.font  = UIFont(name: "OpenSansHebrew-Light", size: 14)
                error2.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                error3.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            }
            else if DeviceType.IS_IPHONE_6 ||  DeviceType.IS_IPHONE_6P
            {
                doTheHoursEqualTo.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblFirstName.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblPhone.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblEmail.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                error1.font  = UIFont(name: "OpenSansHebrew-Light", size: 16)
                error2.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                error3.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            }
        }
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtPhone.delegate = self
        txtMail.delegate = self
        txtPhone.textColor = UIColor.black
        txtMail.textColor = UIColor.black
        error1.text = ""
        error2.text = ""
        error3.text = ""
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
        let checked_checkbox = UIImage(named: "OK-select.png")
        self.btnYesSelect.isCecked = true
        self.btnYesSelect.setImage(checked_checkbox, for: UIControl.State())
        dynamictableheight.constant = 0
        let closeallkeys:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        closeallkeys.cancelsTouchesInView = false
        self.view.addGestureRecognizer(closeallkeys)
        self.MAINTABLE.reloadData()
        calculateTableViewHeight()
        btnclose.setTitle("CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnsave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        //        let Screenheight = UIScreen.mainScreen().bounds.size.height
        //        var contentsize:CGSize = CGSizeMake ( self.view.frame.size.width, Screenheight * 1.2)
        //        let contentheight = 60 + self.blackview.frame.size.height + dynamictableheight.constant + self.bottomview.frame.size.height * 2 + 60
        //        contentsize.height = contentheight
        //        self.NEWSCROLLVIEW.contentSize = contentsize
        // print("contentsize \(contentsize.height) si \(self.NEWSCROLLVIEW.contentInset)")
    }
    //txtfields
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        self.NEWSCROLLVIEW.frame.origin.y = originframe
        //because nsnotif for keyboard show is not working anymore need this hc fix
        return true;
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let calculateheight:CGFloat = textField.superview!.superview!.frame.origin.y
        
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: calculateheight, right: 0.0)
        
        self.NEWSCROLLVIEW.contentInset = contentInsets
        self.NEWSCROLLVIEW.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = UIScreen.main.bounds
        aRect.size.height -= calculateheight
        
        
        if (!aRect.contains(textField.superview!.superview!.frame.origin))
        {
            self.NEWSCROLLVIEW.scrollRectToVisible(textField.superview!.superview!.frame, animated: true)
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
    
    func showAlert(_ mess:String)
    {
        let alertController = UIAlertController(title: "", message:
            mess, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
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
    
    func isValidName(_ input: String) -> Bool {
        var numSpace = 0
        for chr in input.characters {
           if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr >= "א" && chr <= "ת") && !(chr >= "0" && chr <= "9") && chr != " " && chr != "’" && chr != "‘"  && chr != "“" && chr != "'" && chr != "\"" && chr != "”" && chr != "“" && chr != "”" && chr != "׳" && (input.isRussiantext(title: input) == false) )  {
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
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFirstName
        {
            if txtFirstName.text != "" && isValidName(txtFirstName.text!) == false
            {
                error1.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            } else {
                
                let fullNameVerify = txtFirstName.text! as String
                let bar = fullNameVerify
                    .components(separatedBy: " ")
                    .filter { !$0.isEmpty }
                    .joined(separator: " ")
                
                let fullNameArr = bar.components(separatedBy: " ")
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
        
        
        dismissKeyboard()
        let Screenheight = UIScreen.main.bounds.size.height
        var contentsize:CGSize = CGSize ( width: self.view.frame.size.width, height: Screenheight * 1.2)
        let contentheight = self.blackview.frame.size.height + dynamictableheight.constant + self.bottomview.frame.size.height * 2 + 120
        contentsize.height = contentheight
        print("contentsize \(contentsize.height) si \(self.NEWSCROLLVIEW.contentInset)")
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.NEWSCROLLVIEW.contentInset = contentInsets
        self.NEWSCROLLVIEW.scrollIndicatorInsets = contentInsets
        self.NEWSCROLLVIEW.contentSize = contentsize
        self.NEWSCROLLVIEW.frame.origin.y = originframe
        
    }
    func isPhoneExist()
    {
        var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicPhone["nvPhone"] = txtPhone.text as AnyObject
        
        if Reachability.isConnectedToNetwork() == false//if there is no connection
        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            self.flag_EmailInternet = false
        }
        else
        {
            if Reachability.isConnectedToNetwork() == false
            {
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                self.flag_EmailInternet = false
            }
            else
            {
                api.sharedInstance.GetEmployeeDataByPhone(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                    
                    
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                })
            }
        }
    }
    func isEmailExist()
    {
        if Reachability.isConnectedToNetwork() == false//if there is no connection
        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            self.flag_EmailInternet = false
        }
        else
        {
            var dicMail:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dicMail["nvMail"] = txtMail.text as AnyObject
            
            if Reachability.isConnectedToNetwork() == false
            {
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                self.flag_EmailInternet = false
            }
            else
            {
                api.sharedInstance.GetEmployeeDataByEmail(dicMail, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                    
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                })
            }
        }
    }
    
    
    
    @objc func dismissKeyboard() {
        
        self.NEWSCROLLVIEW.frame.origin.y = originframe
        
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let y = indexPath.row
        ////////////    WORKER HOURS SECTION            ////////////
        let x = 0
        
        let cell:DomainTableViewCell = domaincell(x, row:y)
        let cell1:HoursWorkerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HoursWorkerTableViewCell")as!HoursWorkerTableViewCell
        let cell2:BreaksWorkerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BreaksWorkerTableViewCell")as!BreaksWorkerTableViewCell
        
        cell1.DELEGATERELOAD = self
        cell2.DELEGATERELOAD = self
        if y < 2 {
            return cell
        }
        if y == 2  {
            calculateTableViewHeight()
            if isOPENBUSINESSHOUR == true {
                return cell1
            } else {
                return cell2
            }
        }
        
        
        ////////////   END OF WORKER HOURS SECTION       ////////////
        let cellx = UITableViewCell()
        return cellx
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func calculateTableViewHeight() -> CGFloat {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.MAINTABLE.layoutIfNeeded()
        }, completion: { (complete) in
            self.dynamictableheight.constant = 0
            for myfloat in self.heightforrowsarray {
                self.dynamictableheight.constant += myfloat
            }
            print("self.dynamictableheight \(self.dynamictableheight) heightforrows array \(self.heightforrowsarray)")
            let Screenheight = UIScreen.main.bounds.size.height
            var contentsize:CGSize = CGSize ( width: self.view.frame.size.width, height: Screenheight * 1.2)
            let contentheight =  self.blackview.frame.size.height + self.dynamictableheight.constant + self.bottomview.frame.size.height * 2 + 120
            contentsize.height = contentheight
            self.NEWSCROLLVIEW.contentSize = contentsize
            
        })
        
        return dynamictableheight.constant
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //     heightforrowsarray = []
        
        var y:CGFloat = 0
        
        
        
        if btnNoSelect.isCecked == true {
            let z = indexPath.row
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            //  worker -> working hours label row
            if z == 0 {
                if Global.sharedInstance.hourShowChild .characters.count > 0 {
                    var font = UIFont()
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    let Mystr = showSelectedHoursAndDays()
                    if deviceIdiom != .pad {
                        font = UIFont(name: "OpenSansHebrew-Bold", size: 15)!
                        let calculateheight = heightForView(Mystr, font: font, width: tableView.frame.size.width - 30)
                        y =  calculateheight + 25  //25
                        
                    } else {
                        font = UIFont(name: "OpenSansHebrew-Bold", size: 17)!
                        let calculateheight = heightForView(Mystr, font: font, width: tableView.frame.size.width - 70)
                        y =  calculateheight + 15  //25
                    }
                    
                } else {
                    y = 0
                }
                
                heightforrowsarray[0] = y
                
            }
            
            // free hours label row
            if z == 1 {
                if Global.sharedInstance.hourShowRecessChild.characters.count > 0 {
                    var font = UIFont()
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    let Mystr = showSelectedHoursAndDays()
                    if deviceIdiom != .pad {
                        font = UIFont(name: "OpenSansHebrew-Bold", size: 15)!
                        let calculateheight = heightForView(Mystr, font: font, width: tableView.frame.size.width - 30)
                        y =  calculateheight + 25  //25
                        
                    } else {
                        font = UIFont(name: "OpenSansHebrew-Bold", size: 17)!
                        let calculateheight = heightForView(Mystr, font: font, width: tableView.frame.size.width - 70)
                        y =  calculateheight + 15  //25
                    }
                } else {
                    
                    y = 0
                }
                
                heightforrowsarray[1] = y
            }
            //  select hours row
            //business hours has extra add breaks button
            if  z == 2 {
                if isOPENBUSINESSHOUR == true {
                    if deviceIdiom == .pad {
                        y = self.view.frame.size.height * 0.6
                    } else {
                        y = 435
                    }
                } else {
                    //breaks has less height because of hidden add breaks
                    if deviceIdiom == .pad {
                        y = self.view.frame.size.height * 0.56
                    } else {
                        y = 410
                    }
                }
                
                heightforrowsarray[2] = y
                
            }
            calculateTableViewHeight()
            
        } else {
            
            y = 0
            dynamictableheight.constant = y
        }
        
        ////////////   END OF WORKER HOURS SECTION       ////////////
        return y
    }
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    func showSelectedHoursAndDays() -> String
    {
        var  DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShowChild = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedChild[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHoursChild[i].nvFromHour != ""  && Global.sharedInstance.arrWorkHoursChild[i].nvToHour != "" && (Global.sharedInstance.arrWorkHoursChild[i].nvFromHour != Global.sharedInstance.arrWorkHoursChild[i].nvToHour )
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelectedChild[j] == true
                            {
                                if Global.sharedInstance.arrWorkHoursChild[i].nvFromHour == Global.sharedInstance.arrWorkHoursChild[j].nvFromHour &&
                                    Global.sharedInstance.arrWorkHoursChild[i].nvToHour == Global.sharedInstance.arrWorkHoursChild[j].nvToHour
                                {
                                    Global.sharedInstance.hourShowChild = "\(Global.sharedInstance.hourShow) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShowChild = String(Global.sharedInstance.hourShowChild .characters.dropLast())
                        Global.sharedInstance.hourShowChild = "\(Global.sharedInstance.hourShow) - "
                        
                        if Global.sharedInstance.isHoursSelectedChild[i] == true
                        {
                            Global.sharedInstance.hourShowChild = "\(Global.sharedInstance.hourShow) \(cutHour(Global.sharedInstance.arrWorkHoursChild[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHoursChild[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShowChild = String(Global.sharedInstance.hourShowChild .characters.dropLast())
        
        return Global.sharedInstance.hourShowChild
    }
    func showSelectedRecessAndDays() -> String
    {
        var  DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShowRecessChild = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedRest[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour != ""  && Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour != "" && (Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour != Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour )
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelectedRest[j] == true
                            {
                                if Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour == Global.sharedInstance.arrWorkHoursRestChild[j].nvFromHour &&
                                    Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour == Global.sharedInstance.arrWorkHoursRestChild[j].nvToHour
                                {
                                    Global.sharedInstance.hourShowRecessChild = "\(Global.sharedInstance.hourShowRecessChild) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShowRecessChild = String(Global.sharedInstance.hourShowRecessChild.characters.dropLast())
                        Global.sharedInstance.hourShowRecessChild = "\(Global.sharedInstance.hourShowRecessChild) - "
                        
                        if Global.sharedInstance.isHoursSelectedRest[i] == true
                        {
                            Global.sharedInstance.hourShowRecessChild = "\(Global.sharedInstance.hourShowRecessChild) \(cutHour(Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShowRecessChild = String(Global.sharedInstance.hourShowRecessChild.characters.dropLast())
        
        if Global.sharedInstance.hourShowRecessChild != ""
        {
            Global.sharedInstance.hourShowRecessChild = "\("RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)):\(Global.sharedInstance.hourShowRecessChild)"
        }
        
        return Global.sharedInstance.hourShowRecessChild
    }
    
    //cut last 3 characters of string to avoid hh:mm -> :00
    func cutHour(_ hour:String) -> String {
        var fixedHour = String(hour.characters.dropLast())
        fixedHour = String(fixedHour.characters.dropLast())
        fixedHour = String(fixedHour.characters.dropLast())
        return fixedHour
    }
    
    func convertDays(_ day:Int) -> String {
        switch day {
        case 0:
            return "SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 1:
            return "MONDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 2:
            return "TUESDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 3:
            return "WEDNSDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 4:
            return "THIRTHDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 5:
            return "FRIDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 6:
            return "SHABAT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        default:
            return "SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
    }
    func domaincell(_ section:Int,row:Int) -> DomainTableViewCell {
        var font = UIFont()
        var font2 = UIFont()
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            font = UIFont(name: "OpenSansHebrew-Bold", size: 15)!
            font2 = UIFont(name: "OpenSansHebrew-Light", size: 17)!
        } else {
            font = UIFont(name: "OpenSansHebrew-Bold", size: 17)!
            font2 = UIFont(name: "OpenSansHebrew-Light", size: 19)!
        }
        let cell:DomainTableViewCell = MAINTABLE.dequeueReusableCell(withIdentifier: "DomainTableViewCell")as!DomainTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lblText?.font = font2
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let y = row
        ////////////    WORKER HOURS SECTION  LABELS           ////////////
        if y == 0 {      //hashoursselected == true
            cell.lblText?.font = font
            cell.contentView.backgroundColor = UIColor.clear
            cell.lblText?.textColor = Colors.sharedInstance.color4
            cell.arrow.image = nil
            cell.lblText?.lineBreakMode = .byWordWrapping
            cell.lblText?.numberOfLines = 0
            let Mystr = showSelectedHoursAndDays()
            if Mystr.characters.count > 0 {
                cell.lblText?.text = Mystr
            } else {
                cell.lblText?.text = ""
            }
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
            return cell
        } else if y == 1 {      //hasfreehoursselected == true
            cell.lblText?.font = font
            cell.contentView.backgroundColor = UIColor.clear
            cell.lblText?.textColor = Colors.sharedInstance.color3
            cell.arrow.image = nil
            cell.lblText?.lineBreakMode = .byWordWrapping
            cell.lblText?.numberOfLines = 0
            let Mystr = showSelectedRecessAndDays()
            if Mystr.characters.count > 0 {
                cell.lblText?.text = Mystr
            } else {
                cell.lblText?.text = ""
            }
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
            return cell
        }
        
        ////////////   END OF BUSINESS HOURS SECTION       ////////////
        
        return cell
    }
    func LISTALLWORKINGHOURSFORSERVER() {
        Global.sharedInstance.generalDetails.arrObjWorkingHours = Array<objWorkingHours>() //empty before mix the working and rest
        //IN CASE YOU WANT TO TEST OR CLEAR PREVIOUS BAD SAVED DATA USE FROM HERE ====>
        //    var workingHours:objWorkingHours = objWorkingHours()
        //      var workingHoursTEST:objWorkingHours = objWorkingHours()
        //            workingHours = objWorkingHours(
        //                _iDayInWeekType: 1,
        //                _nvFromHour: "10:30:00",
        //                _nvToHour: "11:00:00")
        //        workingHoursTEST = objWorkingHours(
        //            _iDayInWeekType: 1,
        //            _nvFromHour: "12:30:00",
        //            _nvToHour: "19:00:00")
        //        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
        //        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHoursTEST)
        //   <==== <====<====<====<====<====<====<====<====<==== to here AND COMMENT BELLOW
        var mymixedarray:Array<objWorkingHours> = Array<objWorkingHours>()
        
        ////////Global.sharedInstance.arrWorkHoursChild
        for x in Global.sharedInstance.arrWorkHoursChild {
            print("ce a ramaas wh \(x.getDic())")
            var workingHours:objWorkingHours = objWorkingHours()
            if x.iDayInWeekType != 0 && (x.nvFromHour != x.nvToHour) {
                workingHours = objWorkingHours(
                    _iDayInWeekType: x.iDayInWeekType,
                    _nvFromHour: x.nvFromHour,
                    _nvToHour: x.nvToHour)
                if !mymixedarray.contains(workingHours) {
                    mymixedarray.append(workingHours)
                }
            }
        }
        //   print("Global.sharedInstance.arrWorkHoursRestChild \(Global.sharedInstance.arrWorkHoursRestChild)")
        for x in Global.sharedInstance.arrWorkHoursRestChild {
            print("rh ce ramane \(x.getDic())")
            var workingHours:objWorkingHours = objWorkingHours()
            if x.iDayInWeekType != 0 && (x.nvFromHour != x.nvToHour) {
                workingHours = objWorkingHours(
                    _iDayInWeekType: x.iDayInWeekType,
                    _nvFromHour: x.nvFromHour,
                    _nvToHour: x.nvToHour)
                if !mymixedarray.contains(workingHours) {
                    mymixedarray.append(workingHours)
                }
            }
        }
        print("mym \(mymixedarray.count)")
        if mymixedarray.count > 0 {
            for i in 1...7 {
                var hoursinday:Array<objWorkingHours> = []
                for z in 0..<mymixedarray.count {
                    let arie:objWorkingHours = mymixedarray[z]
                    let ay = arie.iDayInWeekType
                    if ay == i {
                        hoursinday.append(arie)
                    }
                }
                print("////////// \(i)")
                if hoursinday.count == 0 {
                    print("no working hours ")
                } else  if hoursinday.count == 1 && hoursinday[0].iDayInWeekType == i {
                    print("onele \(hoursinday[0].getDic())")
                    let oneelement:objWorkingHours = hoursinday[0]
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(oneelement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(oneelement)
                    }
                } else    if hoursinday.count == 2 && hoursinday[0].iDayInWeekType == i && hoursinday[1].iDayInWeekType == i {
                    print("onelex \(hoursinday[0].getDic())")
                    print("secondx \(hoursinday[1].getDic())")
                    let firstelement:objWorkingHours = hoursinday[0]
                    let secondelement:objWorkingHours = hoursinday[1]
                    let workelement:objWorkingHours = objWorkingHours()
                    let restlement:objWorkingHours = objWorkingHours()
                    workelement.iDayInWeekType = i
                    restlement.iDayInWeekType = i
                    workelement.nvFromHour = firstelement.nvFromHour
                    workelement.nvToHour = secondelement.nvFromHour
                    restlement.nvFromHour = secondelement.nvToHour
                    restlement.nvToHour = firstelement.nvToHour
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(workelement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workelement)
                    }
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(restlement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(restlement)
                    }
                }
            }
        }
        
        /////////till HERE
        for nextw in Global.sharedInstance.generalDetails.arrObjWorkingHours {
            print("nextw \(nextw.getDic())")
        }
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
        if btnYesSelect.isCecked
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
        let bar = fullNameVerify
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        
        let fullNameArr = bar.components(separatedBy: " ")
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
            let bar = fullNameVerify
                .components(separatedBy: " ")
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            
            let fullNameArr = bar.components(separatedBy: " ")
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
        if self.txtPhone.text == "" || error2.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error2.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error2.text == "PHONE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE) ||  error2.text == "EMPLOYE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE) || error2.text ==  "EMPLOYE_EXIST_in_db".localized(LanguageMain.sharedInstance.USERLANGUAGE)
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
                let workingHoursEditRest = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType,
                                                           _nvFromHour: Global.sharedInstance.arrWorkHoursChild[i].nvFromHour,
                                                           _nvToHour: Global.sharedInstance.arrWorkHoursChild[i].nvToHour)
                if workingHoursEditRest.iDayInWeekType != 0 && workingHoursEditRest.nvFromHour != "" && workingHoursEditRest.nvToHour != ""
                {
                    Global.sharedInstance.serviceProviderForEdit.arrObjWorkingRest[i] = workingHoursEditRest//בשביל עריכה
                }
                
                workingHours = objWorkingHours(
                    _iDayInWeekType: Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType,
                    _nvFromHour: Global.sharedInstance.arrWorkHoursChild[i].nvFromHour,
                    _nvToHour: Global.sharedInstance.arrWorkHoursChild[i].nvFromHour)
                Global.sharedInstance.serviceProvider.arrObjWorkingHours.append(workingHours)
                //--------------
                workingHours = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType,
                                               _nvFromHour: Global.sharedInstance.arrWorkHoursChild[i].nvToHour,
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
        Global.sharedInstance.arrWorkHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    }

}

