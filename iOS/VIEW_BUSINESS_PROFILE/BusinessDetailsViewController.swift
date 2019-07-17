//
//  BusinessDetailsViewController.swift
//  BThere
//
//  Created by Tami wexelbom on 8.2.2016.
//  Copyright © 2016 tamy. All rights reserved.
//
import UIKit
import CoreLocation
import Foundation
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

protocol saveInGlobalDelegate{
    func saveDataInGlobal()
    func selectedDomain(_WHICHDOMAIN:Int)
}
//דף 1 בהרשמה -פרטי עסק
class BusinessDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,saveInGlobalDelegate, SPGooglePlacesAutocompleteQueryDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    //MARK: - Outlet
    let googlePlacesAutocomplete = SPGooglePlacesAutocompleteQuery()
    var listAutocompletePlace:[SPGooglePlacesAutocompletePlace] = []
    var coordinatePackage:CLLocationCoordinate2D!
    var isSearch = false
    var siteSuffix = [".com",".net",".org",".edu",".biz",".gov",".mil",".info",".name",".me",".tv",".us",".mobi",".co.il"]
    var ISEXPANDED:Bool = false
    @IBOutlet weak var DOMAINLIST: UITableView!
    @IBOutlet weak var dynamictableheight:NSLayoutConstraint!
    @IBOutlet weak var dynamicrowheight:NSLayoutConstraint!
    @IBOutlet weak var tableViewOne: UITableView!
    @IBOutlet weak var tableViewCity: UITableView!
    @IBOutlet weak var btnFaceBook: FBSDKLoginButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBAction func btnBack(_ sender: UIButton) {
    }
    @IBOutlet weak var lblValidId: UILabel!
    @IBOutlet weak var lblValidPhone: UILabel!
    @IBOutlet weak var lblValidFax: UILabel!
    @IBOutlet weak var lblValidName: UILabel!
    @IBOutlet weak var lblValidSite: UILabel!
    @IBOutlet weak var lblValidEmail: UILabel!
    @IBOutlet weak var lblValidAddress: UILabel!
    @IBOutlet weak var lblValidCity: UILabel!
    @IBOutlet weak var lblValidDomain: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblID: UILabel!
    @IBOutlet var lblAddres: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var lblFax: UILabel!
    @IBOutlet var lblSite: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblSocialNetwork: UILabel!
    @IBOutlet var lblClickToCync: UILabel!
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var viewBusinessName: UIView!
    @IBOutlet weak var viewId: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewPhon: UIView!
    @IBOutlet weak var viewFax: UIView!
    @IBOutlet weak var viewSite: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtAdderss: SuggestiveTextField!
    @IBOutlet weak var txtCity: SuggestiveTextField!
    @IBOutlet weak var txtPhon: UITextField!
    @IBOutlet weak var txtFax: UITextField!
    @IBOutlet weak var txtSite: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var fBusinessName = false
    var fId = false
    var fAdderss = false
    var fCity = false
    var fPhone = false
    var fEmail = false
    var fFax = false
    var fSite = false
    var fbusinessdomain = false
    var addressEdit = false
    var adressResult:[String] = []
    var citiesResult:[String] = []
    var isTxtAdress = false
    var isTxtCity = false
    var searchResults: [String]!

    var addressIsInEditMode:Bool = false
    var cityIsInEditMode:Bool = false
    
    @IBAction func btnFacebook(_ sender: UIButton) {
    }
    @IBAction func btnInstagram(_ sender: UIButton) {
    }
    @IBAction func btnTwitter(_ sender: UIButton) {
    }
    @IBAction func btnGooglPlus(_ sender: UIButton) {
    }
    @IBOutlet weak var btnYouTube: UIButton!
    @IBOutlet weak var LblValidAddres: UILabel!
    @IBOutlet var btnContinue: UIButton!
    @IBAction func btnContinue(_ sender: UIButton) {
    }
    @IBOutlet var lblRequiredField: UILabel!


    @IBOutlet weak var viewSocialNetworks: UIView!
    var ADDRESS_FORMATED = ""
    var   EDIT_ADDRESS_FORMATED = false
    //MARK: - Initial

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let x = CGFloat(screenHeight * 0.08)
        dynamicrowheight.constant = x
        if ISEXPANDED ==  false {
            dynamictableheight.constant = dynamicrowheight.constant
        } else {
            dynamictableheight.constant = CGFloat( dynamicrowheight.constant + CGFloat(AppDelegate.arrDomains.count) * dynamicrowheight.constant)
        }



 //       let needheight =  dynamictableheight.constant
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, needheight, 0.0)
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationItem.setHidesBackButton(true, animated:false)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            txtId.textAlignment = .right
            txtCity.textAlignment = .right
            txtPhon.textAlignment = .right
            txtSite.textAlignment = .right
            txtEmail.textAlignment = .right
            txtAdderss.textAlignment = .right
            txtBusinessName.textAlignment = .right


        }
        else
        {
            txtId.textAlignment = .left
            txtCity.textAlignment = .left
            txtPhon.textAlignment = .left
            txtSite.textAlignment = .left
            txtEmail.textAlignment = .left
            txtAdderss.textAlignment = .left
            txtBusinessName.textAlignment = .left
        }

        scrollView.delegate = self
        googlePlacesAutocomplete.delegate = self

        self.searchResults = Array()

        DOMAINLIST.delegate = self
        DOMAINLIST.dataSource = self
        DOMAINLIST.separatorStyle = .none


        tableViewOne.delegate = self
        tableViewOne.dataSource = self
        tableViewCity.delegate = self
//        tableViewCity.delegate = self
//        tableViewCity.dataSource = self
        lblValidAddress.isHidden = true
        lblValidCity.isHidden = true
        lblValidEmail.isHidden = true
        lblValidId.isHidden = true
        lblValidName.isHidden = true
        lblValidPhone.isHidden = true
        lblValidSite.isHidden = true
        lblValidDomain.isHidden = true


        txtBusinessName.attributedPlaceholder = NSAttributedString(string:"BUSINESS_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtId.attributedPlaceholder = NSAttributedString(string: "ID".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtPhon.attributedPlaceholder = NSAttributedString(string:"PHONE".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtSite.attributedPlaceholder = NSAttributedString(string:"SITE".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtEmail.attributedPlaceholder = NSAttributedString(string:"EMAIL".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtAdderss.attributedPlaceholder = NSAttributedString(string:"ADDRES".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtCity.attributedPlaceholder = NSAttributedString(string:"CITY".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))

        Global.sharedInstance.rgisterModelViewController?.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:#selector(BusinessDetailsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        //scrolling whene the keyboard open
     //   self.registerForKeyboardNotifications()
        txtPhon.delegate = self
        txtId.delegate = self
        txtSite.delegate = self
        txtAdderss.delegate = self
        txtCity.delegate = self
        txtBusinessName.delegate = self
        txtEmail.delegate = self
        tableViewOne.isHidden = true
        tableViewCity.isHidden = true
        txtCity.layer.borderWidth = 1
        txtCity.layer.borderColor = UIColor.black.cgColor
        txtAdderss.layer.borderWidth = 1
        txtAdderss.layer.borderColor = UIColor.black.cgColor
        viewBusinessName.layer.borderWidth = 0.3
        viewId.layer.borderWidth = 0.3
        viewCity.layer.borderWidth = 0.3
        viewAddress.layer.borderWidth = 0.3
        viewPhon.layer.borderWidth = 0.3
        viewSite.layer.borderWidth = 0.3
        viewEmail.layer.borderWidth = 0.3
        viewBusinessName.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewId.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewCity.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewAddress.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewPhon.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewSite.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewEmail.layer.borderColor = Colors.sharedInstance.color5.cgColor


    }

    //top and bootom border to the views
    override func viewDidAppear(_ animated: Bool)
    {
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationItem.setHidesBackButton(true, animated:false)

        if Global.sharedInstance.isFromBack == true
        {
//            NotificationCenter.default.addObserver(self, selector: #selector(BusinessDetailsViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(BusinessDetailsViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            Global.sharedInstance.isFromBack = false
        }

        if Global.sharedInstance.RegisterNotEnd == true//לא סיים את תהליך הרישום
        {
            //אתחול השדות לפי מה שהמשתמש כבר הכניס ושמר
            txtBusinessName.text = Global.sharedInstance.currentProviderBuisnessDetails.nvSupplierName
            txtId.text = Global.sharedInstance.currentProviderBuisnessDetails.nvBusinessIdentity
            txtAdderss.text = Global.sharedInstance.currentProviderBuisnessDetails.nvAddress
            txtCity.text = Global.sharedInstance.currentProviderBuisnessDetails.nvCity

            txtPhon.text = Global.sharedInstance.currentProviderBuisnessDetails.nvPhone
            //  txtFax.text = Global.sharedInstance.currentProviderBuisnessDetails.nvFax
            txtSite.text = Global.sharedInstance.currentProviderBuisnessDetails.nvSiteAddress
            txtEmail.text = Global.sharedInstance.currentProviderBuisnessDetails.nvEmail
        }

        if Global.sharedInstance.didOpenBusinessDetails == false
        {
            Global.sharedInstance.didOpenBusinessDetails = true


        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    //MARK: - textField delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField){
        case(txtBusinessName):
            txtId.becomeFirstResponder()
        case(txtId):
            txtCity.becomeFirstResponder()
        case(txtCity):
            txtAdderss.becomeFirstResponder()
        case(txtAdderss):
            txtPhon.becomeFirstResponder()
        case(txtPhon):
            txtEmail.becomeFirstResponder()
            ////        case(txtFax):
        //            txtSite.becomeFirstResponder()
        case(txtEmail):
            txtSite.becomeFirstResponder()
        case(txtSite):
            dismissKeyboard()
        default:
            txtBusinessName.becomeFirstResponder()
        }

        return true
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }



    //MARK: - scrolling when the keyboard open

//    func registerForKeyboardNotifications(){
//        //Adding notifies on keyboard appearing
//        NotificationCenter.default.addObserver(self, selector: #selector(BusinessDetailsViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(BusinessDetailsViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//
//    func deregisterFromKeyboardNotifications(){
//        //Removing notifies on keyboard appearing
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }


//    func keyboardWasShown(_ notification: Notification){
//        //Need to calculate keyboard exact size due to Apple suggestions
//        self.scrollView.isScrollEnabled = true
//
//        let info : NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
//
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//
//        var aRect : CGRect = self.view.frame
//        aRect.size.height -= keyboardSize!.height
//        if let _ = txtEmail
//        {
//            if (!aRect.contains(txtEmail!.frame.origin))
//            {
//                self.scrollView.scrollRectToVisible(txtEmail!.frame, animated: true)
//            }
//        }
//    }
//
//    func keyboardWillBeHidden(_ notification: Notification){
//        //Once keyboard disappears, restore original positions
//        let info : NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, self.scrollView.frame.origin.y, -keyboardSize!.height, 0.0)
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//        self.view.endEditing(true)
//        self.scrollView.isScrollEnabled = false
//
//    }
    func checkValidity() -> Bool
    {
        if self.txtBusinessName.text == ""
        {
            self.lblValidName.isHidden = false
            self.lblValidName.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fBusinessName = false
        }
        else if self.txtBusinessName.text!.count < 2 || isValidString(txtBusinessName.text!) == false
        {
            //self.txtBusinessName.text = ""
            self.lblValidName.isHidden = false
            self.lblValidName.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

            self.fBusinessName = false
        }

        else
        {
            self.fBusinessName = true
        }

        if self.txtId.text == ""
        {
            self.lblValidId.isHidden = false
            self.lblValidId.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fId = false
        }
        else if self.txtId.text!.count < 9 || self.txtId.text!.count > 9
        {
            //self.txtId.text = ""
            self.lblValidId.isHidden = false
            self.lblValidId.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fId = false
        }
        else
        {
            self.fId = true
        }

        if self.txtAdderss.text == ""
        {
            self.lblValidAddress.isHidden = false
            self.lblValidAddress.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fAdderss = false
        }
        else if self.txtAdderss.text!.count < 2 || isValidAddress(txtAdderss) == false

        {
            //self.txtAdderss.text = ""
            self.lblValidAddress.isHidden = false
            self.lblValidAddress.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

            self.fAdderss = false
        }

        else
        {
            //JMODE check a number
            print("verify fADDRESS_FORMATED " + ADDRESS_FORMATED)
            let s1 : String  = self.txtAdderss.text!
            let numberRegEx  = ".*[0-9]+.*"
            let testCase     = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            var arenumere: Bool = false
            //                    arenumere = testCase.evaluateWithObject(s3)
            arenumere = testCase.evaluate(with: s1)
            if( arenumere == false) {
                self.lblValidAddress.isHidden = false
                self.lblValidAddress.text = "ADDRESS_DONT_CONTAIN_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                self.fAdderss = false
            } else {
                ///JMODE + ORIGINALCODE
                self.lblValidAddress.isHidden = true
                self.fAdderss = true
            }

        }


        //for city
        if self.txtCity.text == ""
        {
            self.lblValidCity.isHidden = false
            self.lblValidCity.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fCity = false
        }
        else if self.txtCity.text!.count < 2 || isValidAddress(txtCity) == false

        {
            //self.txtCity.text = ""
            self.lblValidCity.isHidden = false
            self.lblValidCity.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

            self.fCity = false
        }
        else
        {
            self.fCity = true
        }

        if self.txtEmail.text == ""
        {
            self.lblValidEmail.isHidden = false
            self.lblValidEmail.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            fEmail = false
        }
        else if self.isValidEmail(self.txtEmail.text!) == false
        {
            self.lblValidEmail.isHidden = false
            self.lblValidEmail.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            fEmail = false
        }
        else{
            fEmail = true
        }
        if self.txtPhon.text == ""
        {
            self.lblValidPhone.isHidden = false
            self.lblValidPhone.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            fPhone = false
        }
        else if self.isValidPhone(self.txtPhon.text!) == false || txtPhon.text?.count < 5
        {
            self.lblValidPhone.isHidden = false
            self.lblValidPhone.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            fPhone = false
        }
        else{
            fPhone = true
        }



        if txtSite.text != "" {
            //if validateUrl(txtSite.text!) == false
            if verifyUrl(txtSite.text) == false
            {
                self.lblValidSite.isHidden = false
                self.lblValidSite.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                fSite = false
            }
            else{
                fSite = true
            }
        }
        else{
            fSite = true
        }
        if Global.sharedInstance.domainBuisness != "" {
            fbusinessdomain = true
            self.lblValidDomain.isHidden = true
        } else {
            fbusinessdomain = false
            self.lblValidDomain.isHidden = false
            self.lblValidDomain.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        if fEmail == true && fPhone == true && fBusinessName == true  && fAdderss == true && fCity == true && fId == true  /*&& fFax == true */ && fSite == true && fbusinessdomain == true
        {
            return true
        }

        return false
    }

    func saveDataInGlobal()
    {
        if checkValidity() == true
        {
            if txtAdderss.restorationIdentifier != nil
            {
                Global.sharedInstance.placeIdForMap = txtAdderss.restorationIdentifier!
            }


            let provider:Provider = Provider(_iUserId: Global.sharedInstance.currentProvider.iUserId, _iIdBuisnessDetails: Global.sharedInstance.currentProvider.iIdBuisnessDetails, _nvSupplierName: txtBusinessName.text!, _nvBusinessIdentity: txtId.text!, _nvAddress: txtAdderss.text!, _nvCity: txtCity.text!, _iCityType: 1, _nvPhone: txtPhon.text!, _nvFax: txtPhon.text!, _nvEmail: txtEmail.text!, _nvSiteAddress: txtSite.text!, _nvFacebookLink: "", _nvInstagramLink: "")
            
            Global.sharedInstance.currentProvider = provider
            Global.sharedInstance.defaults.set(provider.getDic(), forKey: "providerDic")
            Global.sharedInstance.fIsValidDetails = true
            Global.sharedInstance.defaults.synchronize()
        }
        else
        {
            Global.sharedInstance.fIsValidDetails = false
        }
    }


    //for phone and fax
    func isValidPhone(_ input: String) -> Bool {
        for chr in input {
            if (!(chr >= "0" && chr <= "9") && !(chr == "-") && !(chr == "*")) {
                return false
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
    //for business Name
    func isValidString(_ name:String)->Bool
    {
        let charactersString:String = " !@#$%^&*+=-_{}[](),.?/\\ ";
        var ok:Bool = false

        var numSpace = 0
        for chr in name {
       if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr >= "א" && chr <= "ת") && !(chr >= "0" && chr <= "9") && chr != " " && chr != "’" && chr != "‘"  && chr != "“" && chr != "'" && chr != "\"" && chr != "”" && chr != "“" && chr != "”" && chr != "׳" && (name.isRussiantext(title: name) == false) )
            {

                ok = false;
            }
            else
            {
                ok = true;
            }
            for chr2 in charactersString
            {
                if chr2 == chr
                {
                    ok = true;
                }

            }
            if ok == false
            {
                return false
            }


            if chr == " "
            {
                numSpace += 1
            }
        }
        if numSpace == name.count || numSpace == name.count - 1// אם יש רק רווחים או רק אות אחת והשאר רווחים
        {
            return false
        }
        return true
    }

    // MARK: - TextField
    //=========================TextField==============

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        
        if textField == txtAdderss
        {
            addressIsInEditMode = false
        }
        if textField == txtCity
        {
            cityIsInEditMode = false
        }
        return true;
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch(textField)
        {
        case txtBusinessName:
            if self.txtBusinessName.text!.count < 2 && self.txtBusinessName.text != "" || isValidString(txtBusinessName.text!) == false && txtBusinessName.text != ""
            {
                //self.txtBusinessName.text = ""
                self.lblValidName.isHidden = false
                self.lblValidName.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                self.fBusinessName = false
            }

            else
            {
                self.fBusinessName = true
            }
        case txtId:
            if  (self.txtId.text!.count < 9 || self.txtId.text!.count > 9)
                && self.txtId.text != ""
            {
                //self.txtId.text = ""
                self.lblValidId.isHidden = false
                self.lblValidId.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                //Alert.sharedInstance.showAlert("נא להכניס 9 מספרים בלבד", vc: self)

                self.fId = false
            }
            else
            {
                self.fId = true
            }

        case txtAdderss:


            if self.txtAdderss.text == ""
            {
                tableViewOne.isHidden = true
                ADDRESS_FORMATED = ""
                EDIT_ADDRESS_FORMATED = false
                
            }

            if self.txtAdderss.text!.count < 2 && self.txtAdderss.text != "" || isValidAddress(txtAdderss) == false
            {
                //self.txtAdderss.text = ""
                self.lblValidAddress.isHidden = false
                self.lblValidAddress.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                self.fAdderss = false
                ADDRESS_FORMATED = ""
                EDIT_ADDRESS_FORMATED = false
            }
            else
            {
                self.fAdderss = true
                //now remove city and country from address
                //jmode
                /*
                 I have 2 methods to solve last task: first is to replace city and country in the address. But this sometimes is not right, see for example
                 city: Boston, MA, United States
                 address: Boston Hill, North Andover, MA, United States
                 (so Boston, MA, United States does not appears in address returned -> only 'MA, United States' becouse Google give also district name in answer as 'North Andover'. The street is Boston Hill.

                 Another bad example   when we have same street name in different districts, same state, same country:
                 Boston Hill, North Andover, MA, United States" and "Boston Hill, Westborough, MA, United States"

                 The second one is to split result address by first part before “,” so this is always the street as I tested. Both of them works, but I think the second one is best to choose to avoid using district names in address text and use only street name
                 I will use one of them, tell me which one you think is the best. You can connect with TeamViewer and see what I mean in both cases

                 */

                let s1 : String = txtCity.text!
                let s2 : String = txtAdderss.text!
                if(s1.count > 2 && s2.count > 2) {
                    print("fix address")
                    if s2.contains(s1) {
                        print("found city")
                        let s3 =  s2.replacingOccurrences(of: s1, with: "") as String

                        txtAdderss.text = s3
                        if (EDIT_ADDRESS_FORMATED == false) { //just once to retain edited address
                            ADDRESS_FORMATED = s3
                            EDIT_ADDRESS_FORMATED = true
                        }
                        // }
                    } else {
                        //second way
                        var s4 = ""
                        var s5 = ""
                        s4 = s2
                        let pointsArr = s1.components(separatedBy: ",")
                        let pointsArr2 = s2.components(separatedBy: ",")

                        for i in 0 ..< pointsArr.count {
                            let url = pointsArr[i]
                            print("ll " + url)
                            if(pointsArr2.contains(url)) {
                                s4 =  s4.replacingOccurrences(of: url, with: "") as String
                                print("s4 " + s4)
                            }
                            //clean in case of multiple replaces
                            s5 =  s4.replacingOccurrences(of: ",,", with: "") as String
                            s5 =  s5.replacingOccurrences(of: ",,,", with: "") as String
                            s5 =  s5.replacingOccurrences(of: ",,,,", with: "") as String
                            print("s5" + s5)
                            let ABTESTINGX = CheamaIOSObject()
                            let ABTESTING :String  = ABTESTINGX.formatStringWithoutCommas(s5)
                            print("formated string " + ABTESTING)
                            s5 = ABTESTING

                        }
                        txtAdderss.text = s5
                        if (EDIT_ADDRESS_FORMATED == false) { //just once to retain edited address
                            ADDRESS_FORMATED = s5
                            EDIT_ADDRESS_FORMATED = true
                        }

                        txtAdderss.setNeedsDisplay()
                    }

                }
            }
            print("fADDRESS_FORMATED " + ADDRESS_FORMATED)
            txtAdderss.dismissSuggestionTableView()

        case txtCity:

            if self.txtCity.text == ""
            {
                tableViewCity.isHidden = true
            }
            if self.txtCity.text!.count < 2 && self.txtCity.text != "" || isValidAddress(txtCity) == false

            {
                //self.txtCity.text = ""
                self.lblValidCity.isHidden = false
                self.lblValidCity.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                self.fCity = false
                
            }
            else
            {
                self.fCity = true
                txtAdderss.isEnabled = true
                txtAdderss.isUserInteractionEnabled = true
            }
            txtCity.dismissSuggestionTableView()

        case txtEmail:
            if self.isValidEmail(self.txtEmail.text!) == false && self.txtEmail.text != ""
            {
                //self.txtEmail.text = ""
                self.lblValidEmail.isHidden = false
                self.lblValidEmail.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                self.fEmail = false
            }
            else
            {
                self.fEmail = true
            }
        case txtPhon:

            if self.isValidPhone(self.txtPhon.text!) == false || txtPhon.text?.count < 5 && self.txtPhon.text != ""

            {
                //self.txtPhon.text = ""
                self.lblValidPhone.isHidden = false
                self.lblValidPhone.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                self.fPhone = false
            }
            else
            {
                self.fPhone = true
            }

        case txtSite:
            if txtSite.text != ""//כי זה לא שדה חובה
            {
                if verifyUrl(txtSite.text) == false
                {
                    self.lblValidSite.isHidden = false
                    self.lblValidSite.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                    self.fSite = false
                }
                else
                {
                    self.fSite = true
                }
            }
            else
            {
                self.fSite = true
            }


        default:return

        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        switch textField
        {
        case txtEmail:
            lblValidEmail.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            break
        case txtPhon:
            lblValidPhone.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            break
            //        case txtFax:
            //            lblValidFax.hidden = true
            //            addressEdit = false
            //            isTxtAdress = false
            //            isTxtCity = false
        //            break
        case txtAdderss:
            let s1 : String = txtCity.text!
            if s1 != "" && s1.count > 2 {
                print("edit address ok")
                txtAdderss.isEnabled = true
                txtAdderss.isUserInteractionEnabled = true
                addressEdit = true
                Global.sharedInstance.isAddressCity = false

                lblValidAddress.isHidden = true
                isTxtAdress = true
                isTxtCity = false
                addressIsInEditMode = true
                //            tableView.hidden = false
            } else {
                Alert.sharedInstance.showAlertDelegate("COMPLETE_CITY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                txtAdderss.isEnabled = false
                txtAdderss.isUserInteractionEnabled = false
                print("edit address not permited")
            }


            break

        case txtCity:
            addressEdit = true
            Global.sharedInstance.isAddressCity = true
            lblValidCity.isHidden = true
            isTxtAdress = false
            isTxtCity = true
            cityIsInEditMode = true
            txtAdderss.isEnabled = true
            txtAdderss.isUserInteractionEnabled = true

            //            tableView.hidden = false
            break

        case txtBusinessName:
            lblValidName.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            break
        case txtId:
            lblValidId.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            break
        case txtSite:
            lblValidSite.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            //        case txtEmail:
            //            lblValidEmail.hidden = true
            //            break
            //        case txtEmail:
            //            lblValidEmail.hidden = true
            //            break

        default:break//lblValidEmail.hidden = true
        }

    }

    //    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    ////        var location = CLLocationCoordinate2D(latitude: 47.620506, longitude: -122.349277)
    ////        var gp = GooglePlaces()
    ////        gp.search(location, radius: 2000, query: "coffee") { (items, errorDescription) -> Void in
    ////
    ////            //\\println("Result count: \(items!.count)")
    ////            for index in 0..<items!.count {
    ////                //\\println([items![index].name])
    ////            }
    ////        }
    //        let placesClient = GMSPlacesClient()
    //
    //        placesClient.autocompleteQuery(txtAdderss.text!, bounds: nil, filter: nil) { (results, error:NSError?) -> Void in
    //            self.resultsArray.removeAll()
    //            if results == nil {
    //                return
    //            }
    //            for result in results!{
    //                if let result = result as? GMSAutocompletePrediction{
    //                    self.resultsArray.append(result.attributedFullText.string)
    //                }
    //            }
    //            self.tableView.reloadData()
    //            //.searchResultController.reloadDataWithArray(self.resultsArray)
    //        }
    //        return true
    //    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == txtCity {
            Global.sharedInstance.isAddressCity = true
            googlePlacesAutocomplete.input = textField.text! + string
            print("google input city \(googlePlacesAutocomplete.input) ")

            if Reachability.isConnectedToNetwork() == false
            {
                //   Alert.sharedInstance.showAlert(NSLocalizedString("NO_INTERNET", comment: ""), vc: self)
            } else {
                googlePlacesAutocomplete.fetchPlaces()
            }
        }
        else if textField == txtAdderss {

            if txtCity.text != "" && !(textField.text?.contains(txtCity.text!))!
            {
                googlePlacesAutocomplete.input = txtCity.text! + " " + textField.text! + string
                print("google input \(googlePlacesAutocomplete.input) ")
            }
            else
            {
                googlePlacesAutocomplete.input = textField.text! + string
            }
            if Reachability.isConnectedToNetwork() == false
            {

                //    Alert.sharedInstance.showAlert(NSLocalizedString("NO_INTERNET", comment: ""), vc: self)
            } else {
                googlePlacesAutocomplete.fetchPlaces()
            }
        }

        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        startString += string


        if textField == txtId
        {
            if startString.count > 9
            {
                Alert.sharedInstance.showAlert("ENTER_NINE_CHAR".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                return false
            }
            else
            {
                return true
            }
        }

        if textField == txtBusinessName
        {
            if startString.count > 30
            {
                Alert.sharedInstance.showAlert("ENTER_ONLY30_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                return false
            }
            else
            {
                return true
            }
        }
        return true
    }


//    func verifyUrl (_ urlString: String?) -> Bool {
//        var firstStep = false
//
//        guard let urlString = urlString else {return false}
//        guard let url = URL(string: urlString) else {return false}
//
//        // Check length
//        if (strlen(urlString) < 8) {
//            return false
//        }
//
//        // Check prefix
//        if (!urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") && !urlString.hasPrefix("http://www.") && !urlString.hasPrefix("https://www.") && !urlString.hasPrefix("www.")) {
//            return false
//        }
//
//        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
//        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
//
//        if (predicate.evaluate(with: urlString) == false) {
//            // let regEx2 = "((\\w|-)+)(([.]|[/])((\\w|-)+))+"
//            let updatedURL = "http://" + urlString
//            let predicate2 = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
//            let newURL = URL(string: updatedURL)
//
//            if (predicate2.evaluate(with: updatedURL) == true) {
//                if (UIApplication.shared.canOpenURL(newURL!) == true) {
//                    firstStep = true
//                } else {
//                    firstStep = false
//                }
//            } else {
//                firstStep = false
//            }
//        } else {
//            if (predicate.evaluate(with: urlString) == true) {
//                if (UIApplication.shared.canOpenURL(url) == true) {
//                    firstStep = true
//                } else {
//                    firstStep = false
//                }
//            } else {
//                firstStep = false
//            }
//        }
//
//        if (firstStep == true) {
//            let possibleExtensions = [".ae", ".ai", ".asia", ".bb", ".com.br", ".net.br", ".eco.br", ".cm", ".cn", ".cd", ".com.hr", ".dk", ".eg", ".fr", ".ht", ".is", ".ie", ".jo", ".ly", ".com.mx", ".nl", ".ps", ".pe", ".pt", ".ro", ".com.ro", ".co.ro", ".sg", ".com.sg", ".kr", "co.kr", "or.kr", ".ne.kr", ".ch", ".tv", ".uk", ".co.uk", ".org.uk", ".me.uk", ".net.uk", ".us", ".vn", ".africa", ".ag", ".com.au", ".be", ".io", ".ca", ".com.cn", ".cg", ".hr", ".ec", ".eu", ".de", ".co.de", ".com.de", ".com.hk", ".in", ".it", ".co.it", ".la", ".my", ".com.my", ".org.my", ".net.my", ".mx", ".no", ".co.no", ".com.pa", ".pa", ".ph", ".com.pr", ".ru", ".sk", ".es", ".tw", ".ua", ".com.ua", ".net.ua", ".org.ua", ".com.uy", ".uy", ".org.uy", ".net.uy", ".uz", ".al", ".com.al", ".net.al", ".org.al", ".com.ar", ".at", ".bo", ".bg", ".cl", ".com.co", ".co.cr", ".cz", ".com.eg", ".fi", ".gr", ".com.gr", ".hk", ".com.hk", ".co.id", ".id", ".biz.id", ".my.id", ".web.id", ".co.id", ".jp", ".ne.jp", ".gr.jp", ".co.jp", ".lv", ".mr", ".me", ".pk", ".com.pk", ".com.py", ".net.py", ".edu.py", ".pl", ".qa", ".com.qa", ".sl", ".si", ".se", ".com.tr", ".web.tr", ".biz.tr", ".info.tr", ".tv.tr", ".co.uk", ".org.uk", ".me.uk", ".net.uk", ".uy", ".com.ve", ".co.il", ".il", ".idf.il", ".muni.il", ".gov.il", ".k12.il", ".net.il", ".org.il", ".ac.il", ".com", ".biz", ".mobi", ".travel", ".net", ".info", ".pw", ".tv", ".org", ".int", ".tel", ".xxx"]
//
//            var foundInArray = false
//            for webExtension in possibleExtensions {
//                if urlString.lowercased().range(of: webExtension) != nil {
//                    if (urlString.hasSuffix(webExtension)) {
//                        foundInArray = true
//                        break
//                    }
//                }
//            }
//
//            if (foundInArray == true) {
//                return true
//            } else {
//                return false
//            }
//        } else {
//            return false
//        }
//    }
    func verifyUrl (_ urlString: String?) -> Bool {


        if Global.sharedInstance.cutStringBySpace(urlString!, strToCutBy: ".").count == 2 || Global.sharedInstance.cutStringBySpace(urlString!, strToCutBy: ".").count == 3
        {
            for chr in urlString! {
                if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z") || (chr >= "0" && chr <= "9") || (chr == ".") && chr != "׳") {
                    return true
                }
            }
        }
        return false
    }




    //MARK: - table view

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 3 {
            if ISEXPANDED == false {
                return 1
            } else {
            return AppDelegate.arrDomains.count + 1
            }
        }
        return self.searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:DomainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DomainTableViewCell") as! DomainTableViewCell
        cell.selectionStyle = .none

        if tableView.tag == 3 {
            let y = indexPath.row
            cell.tag = y
            cell.delegate = self
                var font2 = UIFont()
                if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
                {
                    font2 = UIFont(name: "OpenSansHebrew-Light", size: 15)!
                } else {
                    font2 = UIFont(name: "OpenSansHebrew-Light", size: 15)!
                }
                cell.lblText?.font = font2
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero

                    if y == 0 {
                        if ISEXPANDED == false {
                            cell.arrow.image = UIImage(named: "generaldataleft.png")
                        } else {
                            cell.arrow.image = UIImage(named: "generaldatadown.png")
                        }
                        cell.contentView.backgroundColor = UIColor.clear
                        cell.lblText?.textColor = UIColor.black
                        if Global.sharedInstance.domainBuisness != "" {
                            cell.lblText?.text = Global.sharedInstance.domainBuisness
                            
                        } else {
                            cell.lblText?.text = "DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        }
                    } else {
                        cell.contentView.backgroundColor = UIColor.black
                        cell.lblText?.textColor = UIColor.white
                        cell.arrow.image = nil
                        if  AppDelegate.arrDomains.count > 0 {
                            //safe get the previous selected one
                            if Global.sharedInstance.domainBuisness != "" {
                                for searchdomain in AppDelegate.arrDomains {
                                    if searchdomain.nvCategoryName == Global.sharedInstance.domainBuisness {
                                        let myfoundindex = AppDelegate.arrDomains.index(of: searchdomain)
                                        print("myfoundindex \(myfoundindex ?? 0)")
                                        Global.sharedInstance.generalDetails.iFieldId = AppDelegate.arrDomainFilter[myfoundindex!].iCategoryRowId
                                        print(" Global.sharedInstance.generalDetails.iFieldId \( Global.sharedInstance.generalDetails.iFieldId)")
                                        if y == myfoundindex! + 1 {
                                            cell.contentView.backgroundColor = UIColor(red:145/255.0, green: 201/255.0, blue: 214/255.0, alpha: 1.0)
                                            cell.lblText?.textColor = UIColor.black
                                        }
                                        break
                                    }
                                }
                            }
                            if let _ =  AppDelegate.arrDomains[y - 1] as Domain?  {
                                let mybusinessdomain =  AppDelegate.arrDomains[y - 1]
                                cell.lblText?.text = mybusinessdomain.nvCategoryName
                            }
                        }
                    }
            return cell
        } else {
            cell.arrow.image = nil
            cell.arrow.isHidden = true
            cell.textLabel?.text = self.searchResults[indexPath.row]
        }
        return cell
    }
//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)

if tableView.tag == 3  {
    print ("aaaaaaa")
} else {
        tableView.isHidden = true

    }
    }
    //-MARK: SPGooglePlacesAutocompleteQueryDelegate
    func googlePlaceReload(_ listPlaces:[SPGooglePlacesAutocompletePlace])
    {
        if isSearch{
            googlePlacesAutocomplete.googleGeocoded(referenceToGeocoded:listPlaces[0].reference)
            isSearch = false
        }
        else{
            var placesName:[String] = []
            var placesId:[String] = []

            for place in listPlaces{
                placesName += [place.name]
                placesId += [place.placeId]
            }
            if isTxtAdress == true
            {
                adressResult = placesName

            }
            else if isTxtCity == true
            {
                citiesResult = placesName
            }
            listAutocompletePlace=listPlaces
            if Global.sharedInstance.isAddressCity == false
            {
                txtAdderss.setSuggestions(placesName)
                txtAdderss.setSuggestionsPlacesId(placesId)
                txtAdderss.matchStrings(txtAdderss.text)
                txtAdderss.showSuggestionTableView()
            }
            else
            {
                txtCity.setSuggestions(placesName)
                txtCity.setSuggestionsPlacesId(placesId)
                txtCity.matchStrings(txtCity.text)
                txtCity.showSuggestionTableView()
            }
        }
    }

    func googlePlaceGeocoded(_ latitude:Double, longitude:Double)
    {
        if Global.sharedInstance.isAddressCity == false
        {
            self.txtAdderss.text = ""
        }
        else
        {
            self.txtCity.text = ""
        }
    }

    func googlePlaceReverseGeocode(_ address: String) {
        if Global.sharedInstance.isAddressCity == false
        {
            txtAdderss.text = address
        }
        else
        {
            txtCity.text = address
        }
    }

    func googlePlaceReverseGeocode(_ address: String , country: String ,city: String)
    {

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
//        print(scrollView.contentOffset)
//        self.tableViewCity.setNeedsDisplay()
        if cityIsInEditMode
        {
            txtCity.showSuggestionTableView()
        }
        if addressIsInEditMode
        {
            txtAdderss.showSuggestionTableView()
        }
        
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        if scrollView.contentOffset.y < 100
//        {
//            if addressEdit == true
//            {
//                if Global.sharedInstance.isAddressCity == false
//                {
//                    txtAdderss.showSuggestionTableView()
//                }
//                else
//                {
//                    txtCity.showSuggestionTableView()
//                }
//            }
//        }
//        else
//        {
//            if addressEdit == true
//            {
//                if Global.sharedInstance.isAddressCity == false
//                {
//                    txtAdderss.dismissSuggestionTableView()
//                }
//                else
//                {
//                    txtCity.dismissSuggestionTableView()
//                }
//            }
//        }
//    }

    func isValidAddress(_ textField:UITextField) -> Bool {

        if textField == txtAdderss
        {
            isTxtAdress  = false
            return true
        }
        else if textField == txtCity
        {
            if citiesResult.contains(textField.text!)
            {
                isTxtCity = false
                return true
            } else {
                return true //fix for no network or no result on google
            }
        }
        return false
    }
    func selectedDomain(_WHICHDOMAIN:Int) {
        print(_WHICHDOMAIN)
        if _WHICHDOMAIN == 0 {
        ISEXPANDED = !ISEXPANDED
        if ISEXPANDED ==  false {
            dynamictableheight.constant = dynamicrowheight.constant
        } else {
            dynamictableheight.constant = CGFloat( dynamicrowheight.constant + CGFloat(AppDelegate.arrDomains.count) * dynamicrowheight.constant)
        }
  var   xindexPath = IndexPath(row: 0, section: 0)
            if ISEXPANDED ==  true {

            if  AppDelegate.arrDomains.count > 0 {
                if Global.sharedInstance.domainBuisness != "" {
                    for searchdomain in AppDelegate.arrDomains {
                        if searchdomain.nvCategoryName == Global.sharedInstance.domainBuisness {
                            let myfoundindex = AppDelegate.arrDomains.index(of: searchdomain)
                             xindexPath = IndexPath(row: myfoundindex! + 1, section: 0)


                        }
                    }
                }
            }
                DOMAINLIST.reloadData()
                self.DOMAINLIST.scrollToRow(at: xindexPath, at: .top, animated: false)
                let rectOfCellInTableView = self.DOMAINLIST.rectForRow(at: xindexPath)
                self.scrollView.scrollRectToVisible(rectOfCellInTableView, animated: true)
            } else {
                self.DOMAINLIST.scrollToRow(at: xindexPath, at: .top, animated: false)
                let rectOfCellInTableView = self.DOMAINLIST.rectForRow(at: xindexPath)
                self.scrollView.scrollRectToVisible(rectOfCellInTableView, animated: true)
                 DOMAINLIST.reloadData()
            }

        } else {
            if  AppDelegate.arrDomains.count > 0 {
                if let  _ = AppDelegate.arrDomains[_WHICHDOMAIN - 1] as Domain? {
                    let mybusinessdomain =  AppDelegate.arrDomains[_WHICHDOMAIN - 1]
                    Global.sharedInstance.domainBuisness =  mybusinessdomain.nvCategoryName
                    Global.sharedInstance.generalDetails.iFieldId = AppDelegate.arrDomainFilter[_WHICHDOMAIN - 1].iCategoryRowId
                    print(" Global.sharedInstance.generalDetails.iFieldId edited\( Global.sharedInstance.generalDetails.iFieldId)")
                }
            }
            ISEXPANDED = !ISEXPANDED
            if ISEXPANDED ==  false {
                dynamictableheight.constant = dynamicrowheight.constant
            } else {
                dynamictableheight.constant = CGFloat( dynamicrowheight.constant + CGFloat(AppDelegate.arrDomains.count) * dynamicrowheight.constant)
            }
             self.DOMAINLIST.reloadData()

        }
        if Global.sharedInstance.domainBuisness  != "" {
            lblValidDomain.isHidden = true
            
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var x:CGFloat  = 0.0
        if tableView.tag == 3 {
        let ax = indexPath.row

            if ISEXPANDED == false {
                if ax == 0 {
                x = dynamicrowheight.constant
                } else {
                    x = 0
                }
            } else {
            x = dynamicrowheight.constant // first title row
            }
        }
        return x
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
