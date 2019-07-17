//
//  SupplierBusinessDetailViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 02.08.2017
//  Copyright © 2017 Bthere. All rights reserved.
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

protocol saveInGlobalDelegate1{
    func saveDataInGlobal()
    func selectedDomain(_WHICHDOMAIN:Int)
}
class SupplierBusinessDetailViewController: NavigationModelViewController, UITextFieldDelegate, UITableViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,SPGooglePlacesAutocompleteQueryDelegate,saveInGlobalDelegate1 {
    //MARK: - Outlet
    var ISEXPANDED:Bool = false
    @IBOutlet weak var DOMAINLIST: UITableView!
    @IBOutlet weak var tableViewOne: UITableView!
    @IBOutlet weak var tableViewCity: UITableView!
    @IBOutlet weak var dynamictableheight:NSLayoutConstraint!
    @IBOutlet weak var dynamicrowheight:NSLayoutConstraint!
    @IBOutlet weak var lblValidDomain:UILabel!
    var fbusinessdomain:Bool = false
    var supplierID = 0
    var isSearch = false
    let googlePlacesAutocomplete = SPGooglePlacesAutocompleteQuery()
    var listAutocompletePlace:[SPGooglePlacesAutocompletePlace] = []
    var coordinatePackage:CLLocationCoordinate2D!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbtopersonal: UILabel!
    @IBOutlet weak var lbtrequiredfield: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var btntppersonal: UIButton!
    @IBOutlet weak var namebusiness: UITextField!
    @IBOutlet weak var idbusinesscode: UITextField!
    @IBOutlet weak var addressBusiness: SuggestiveTextField!
    @IBOutlet weak var cityBusiness: SuggestiveTextField!
    @IBOutlet weak var phoneBusiness: UITextField!
    @IBOutlet weak var emailBusiness: UITextField!
    @IBOutlet weak var websiteBusiness: UITextField!
    @IBOutlet weak var requiredFields: UILabel!
    @IBOutlet weak var secondtitle: UILabel!
    @IBOutlet weak var topersonal: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    
    //error labels
    
    @IBOutlet weak var e_namebusiness: UILabel!
    @IBOutlet weak var e_idbusinesscode: UILabel!
    @IBOutlet weak var e_addressBusiness: UILabel!
    @IBOutlet weak var e_cityBusiness: UILabel!
    @IBOutlet weak var e_phoneBusiness: UILabel!
    @IBOutlet weak var e_emailBusiness: UILabel!
    @IBOutlet weak var e_websiteBusiness: UILabel!
   
    @IBAction func btnback(_ sender: UIButton) {
        dismiss()
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    @IBAction func btnsave(_ sender: UIButton) {
        if checkValidity2() == true {
        //save to server then dismiss
        if Reachability.isConnectedToNetwork() == false
        {
            self.view.makeToast(message: "NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })
        }
        else {
            
            self.generic.showNativeActivityIndicator(self)
            var dicbusiness:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
             var dicomposed:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dicomposed["nvSupplierName"] = self.namebusiness.text as AnyObject
            dicomposed["nvBusinessIdentity"] = self.idbusinesscode.text as AnyObject
            dicomposed["nvAddress"] = self.addressBusiness.text as AnyObject
            dicomposed["nvCity"] = self.cityBusiness.text as AnyObject
            dicomposed["nvPhone"] = self.phoneBusiness.text as AnyObject
            dicomposed["nvEmail"] = self.emailBusiness.text as AnyObject
            dicomposed["nvSiteAddress"] = self.websiteBusiness.text as AnyObject
            dicomposed["iBusinessId"] = self.supplierID as AnyObject
            dicomposed["iFieldId"] = Global.sharedInstance.generalDetails.iFieldId as AnyObject
            dicbusiness["obj"] = dicomposed as AnyObject
            print("dicbusiness: \(String(describing: dicbusiness["obj"]))")
            api.sharedInstance.UpdateProviderBusinessDetails2(dicbusiness, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in

                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("updateeeeee RESPONSEOBJECT \(RESPONSEOBJECT)")
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                {
                    self.view.makeToast(message: "ERROR_UPDATE_BUSINESS_PROFILE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                         self.generic.hideNativeActivityIndicator(self)
                    })
                }
                else
                    if let _:Int = RESPONSEOBJECT["Result"] as? Int
                    {
                        let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                        
                        if myInt == 1 {
                            //success
                    
                            self.view.makeToast(message: "UPDATED_BUSINESS_PROFILE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(4.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.hidetoast()

                                self.dismiss()
                            
                            })
                            
                        }
                }
                    }
                }
                
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    self.view.makeToast(message: "ERROR_UPDATE_BUSINESS_PROFILE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                    })
                    
            })
            
            }

      
        } else {
            print("err")
        }
    }
    @IBAction func btntppersonal(_ sender: UIButton) {
        openCustomer()
    }
    //booleans for check validity
    var fBusinessName = false
    var fId = false
    var fAdderss = false
    var fCity = false
    var fPhone = false
    var fEmail = false
    var fSite = false
    var generic:Generic = Generic()
    var addressEdit = false
    var adressResult:[String] = []//מכיל את הכתובות להשלמה
    var citiesResult:[String] = []//מכיל את הערים להשלמה
    var isTxtAdress = false
    var isTxtCity = false
    var searchResults: [String]!

    var ADDRESS_FORMATED = ""
    var   EDIT_ADDRESS_FORMATED = false
    

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField){
        case(namebusiness):
            idbusinesscode.becomeFirstResponder()
        case(idbusinesscode):
            cityBusiness.becomeFirstResponder()
        case(cityBusiness):
            addressBusiness.becomeFirstResponder()
        case(addressBusiness):
            emailBusiness.becomeFirstResponder()
        case(emailBusiness):
            websiteBusiness.becomeFirstResponder()
        case(websiteBusiness):
            dismissKeyboard()
        default:
            namebusiness.becomeFirstResponder()
        }
        
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cityBusiness {
            googlePlacesAutocomplete.input = textField.text! + string
            if Reachability.isConnectedToNetwork() == false
            {
                //   Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            } else {
                googlePlacesAutocomplete.fetchPlaces()
            }
        }
        else if textField == addressBusiness {
            
            if cityBusiness.text != "" && !(textField.text?.contains(cityBusiness.text!))!
            {
                googlePlacesAutocomplete.input = cityBusiness.text! + textField.text! + string
            }
            else
            {
                googlePlacesAutocomplete.input = textField.text! + string
            }
            if Reachability.isConnectedToNetwork() == false
            {
        
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
        
        
        if textField == idbusinesscode
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
        
              if textField == namebusiness
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:50)
//        if let navController = self.navigationController {
//            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:#selector(self.closetables))
//            for case let subbutton as UIView in navController.view.subviews {
//                print("my button y origin\(subbutton.frame.origin.y) &  height \(subbutton.frame.size.height)")
//                subbutton.addGestureRecognizer(tap)
//            }
//
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DismissEditCityorAddress"), object: nil)
        self.view.endEditing(true)


    }
    override func willMove(toParent parent: UIViewController?) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(SupplierBusinessDetailViewController.closetables), name: NSNotification.Name(rawValue: "DismissEditCityorAddress"), object: nil)

        Global.sharedInstance.domainBuisness = ""
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.getDic()
        if let _:Int = dic["iFieldId"]  as? Int{
            let dicgeneraliFieldId:Int = dic["iFieldId"]  as! Int
            Global.sharedInstance.generalDetails.iFieldId = dicgeneraliFieldId
            for i in 0..<AppDelegate.arrDomainFilter.count {
                var domain:Domain = Domain()
                domain = AppDelegate.arrDomainFilter[i]
                if domain.iCategoryRowId == dicgeneraliFieldId {
                    Global.sharedInstance.domainBuisness = domain.nvCategoryName
                    print("Global.sharedInstance.domainBuisness \(Global.sharedInstance.domainBuisness)")
                }
            }
        }
        print("|Global.sharedInstance.generalDetails.iFieldId\(Global.sharedInstance.generalDetails.iFieldId)")
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let x = CGFloat(screenHeight * 0.08)
        dynamicrowheight.constant = x
        if ISEXPANDED ==  false {
            dynamictableheight.constant = dynamicrowheight.constant
        } else {
            dynamictableheight.constant = CGFloat( dynamicrowheight.constant + CGFloat(AppDelegate.arrDomains.count) * dynamicrowheight.constant)
        }
        self.scrollView.delegate = self
        self.tableViewOne.delegate = self
        self.tableViewOne.dataSource = self
        self.tableViewCity.delegate = self
        self.tableViewCity.delegate = self
        self.DOMAINLIST.delegate = self
        self.DOMAINLIST.dataSource = self
        googlePlacesAutocomplete.delegate = self
        self.searchResults = Array()
        addressBusiness.layer.borderWidth = 1
        addressBusiness.layer.borderColor = UIColor.black.cgColor
        cityBusiness.layer.borderWidth = 1
        cityBusiness.layer.borderColor = UIColor.black.cgColor
        tableViewCity.isHidden = true
        tableViewOne.isHidden = true
        namebusiness.delegate = self
        idbusinesscode.delegate = self
        addressBusiness.delegate = self
        cityBusiness.delegate = self
        phoneBusiness.delegate = self
        emailBusiness.delegate = self
        websiteBusiness.delegate = self
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            
            namebusiness.textAlignment = .right
            idbusinesscode.textAlignment = .right
            phoneBusiness.textAlignment = .right
            websiteBusiness.textAlignment = .right
            emailBusiness.textAlignment = .right
            addressBusiness.textAlignment = .right
            lbtopersonal.textAlignment = .right
            lbtrequiredfield.textAlignment = .right
        }
        else
        {
            namebusiness.textAlignment = .left
            idbusinesscode.textAlignment = .left
            phoneBusiness.textAlignment = .left
            websiteBusiness.textAlignment = .left
            emailBusiness.textAlignment = .left
            addressBusiness.textAlignment = .left
            lbtopersonal.textAlignment = .left
            lbtrequiredfield.textAlignment = .left
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:#selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        namebusiness.attributedPlaceholder = NSAttributedString(string:"BUSINESS_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        idbusinesscode.attributedPlaceholder = NSAttributedString(string: "ID".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        phoneBusiness.attributedPlaceholder = NSAttributedString(string:"PHONE".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        websiteBusiness.attributedPlaceholder = NSAttributedString(string:"SITE".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        emailBusiness.attributedPlaceholder = NSAttributedString(string:"EMAIL".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        addressBusiness.attributedPlaceholder = NSAttributedString(string:"ADDRES".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        cityBusiness.attributedPlaceholder = NSAttributedString(string:"CITY".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        e_namebusiness.isHidden = true
        e_idbusinesscode.isHidden = true
        e_cityBusiness.isHidden = true
        e_addressBusiness.isHidden = true
        e_phoneBusiness.isHidden = true
        e_emailBusiness.isHidden = true
        e_websiteBusiness.isHidden = true
        lblValidDomain.isHidden = true

        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        supplierID = providerID
        namebusiness.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName
        idbusinesscode.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvBusinessIdentity
        cityBusiness.text =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvCity
        addressBusiness.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress
        phoneBusiness.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvPhone
        emailBusiness.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvEmail
        websiteBusiness.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSiteAddress
       
        lblTitle.text  = "MY_DETAILS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        secondtitle.text =   "BUSINESS_INFO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lbtopersonal.text =   "TO_PERSONAL_INFO_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lbtrequiredfield.text =   "REQUIRED_FIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnsave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
//        let leftarrowback = UIImage(named: "sageata2.png")
//        self.btnback.setImage(leftarrowback, for: UIControlState())
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnback.transform = scalingTransform
            self.backImg.transform = scalingTransform
            cityBusiness.textAlignment = .right
//            secondtitle.transform = scalingTransform
        }
        else
        {
            cityBusiness.textAlignment = .left
//            secondtitle.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
//        btnback.imageView!.contentMode = .scaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    self.view.addBackground()
    }
    func isValidPhone(_ input: String) -> Bool {
        for chr in input {
            if (!(chr >= "0" && chr <= "9") && !(chr == "-") && !(chr == "*")) {
                return false
            }
        }
        
        return true
    }
    func googlePlaceReverseGeocode(_ address: String) {
        if Global.sharedInstance.isAddressCity == false
        {
            addressBusiness.text = address
        }
        else
        {
            cityBusiness.text = address
        }
    }
    
    func googlePlaceReverseGeocode(_ address: String , country: String ,city: String)
    {
        
    }
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
            
            //st
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
                addressBusiness.setSuggestions(placesName)
                addressBusiness.setSuggestionsPlacesId(placesId)
                addressBusiness.matchStrings(addressBusiness.text)
                addressBusiness.showSuggestionTableView()
            }
            else
            {
                cityBusiness.setSuggestions(placesName)
                cityBusiness.setSuggestionsPlacesId(placesId)
                cityBusiness.matchStrings(cityBusiness.text)
                cityBusiness.showSuggestionTableView()
            }
           
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y < 100
        {
            if addressEdit == true
            {
                if Global.sharedInstance.isAddressCity == false
                {
                    addressBusiness.showSuggestionTableView()
                }
                else
                {
                    cityBusiness.showSuggestionTableView()
                }
            }
        }
        else
        {
            if addressEdit == true
            {
                if Global.sharedInstance.isAddressCity == false
                {
                    addressBusiness.dismissSuggestionTableView()
                }
                else
                {
                    cityBusiness.dismissSuggestionTableView()
                }
            }
        }
    }
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

    func isValidAddress(_ textField:UITextField) -> Bool {
        
        if textField == addressBusiness
        {
          
            isTxtAdress  = false
            return true
          
        }
        else if textField == cityBusiness
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

    func checkValidity2() -> Bool
    {
        if self.namebusiness.text == ""
        {
            self.e_namebusiness.isHidden = false
            self.e_namebusiness.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fBusinessName = false
        }
        else if self.namebusiness.text!.characters.count < 2 || isValidString(namebusiness.text!) == false
        {
            self.e_namebusiness.isHidden = false
            self.e_namebusiness.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            
            self.fBusinessName = false
        }
            
        else
        {
            self.fBusinessName = true
        }
        
        if self.idbusinesscode.text == ""
        {
            self.e_idbusinesscode.isHidden = false
            self.e_idbusinesscode.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fId = false
        }
        else if self.idbusinesscode.text!.count < 9 || self.idbusinesscode.text!.count > 9 //|| !Validation.sharedInstance.isTzValid(txtId.text!)
        {
            self.e_idbusinesscode.isHidden = false
            self.e_idbusinesscode.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fId = false
        }
        else
        {
            self.fId = true
        }
        
        if self.addressBusiness.text == ""
        {
            self.e_addressBusiness.isHidden = false
            self.e_addressBusiness.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fAdderss = false
        }
        else if self.addressBusiness.text!.count < 2 || isValidAddress(addressBusiness) == false
            
        {
            self.e_addressBusiness.isHidden = false
            self.e_addressBusiness.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fAdderss = false
        }
            
        else
        {
          
            print("verify fADDRESS_FORMATED " + ADDRESS_FORMATED)
            let s1 : String  = self.addressBusiness.text!
            let numberRegEx  = ".*[0-9]+.*"
            let testCase     = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            var arenumere: Bool = false
            arenumere = testCase.evaluate(with: s1)
            if( arenumere == false) {
                self.e_addressBusiness.isHidden = false
                self.e_addressBusiness.text = "ADDRESS_DONT_CONTAIN_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                self.fAdderss = false
            } else {
        
                self.e_addressBusiness.isHidden = true
                self.fAdderss = true
            }
     }
    
        if self.cityBusiness.text == ""
        {
            self.e_cityBusiness.isHidden = false
            self.e_cityBusiness.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.fCity = false
        }
        else if self.cityBusiness.text!.count < 2 || isValidAddress(cityBusiness) == false
        {
            self.e_cityBusiness.isHidden = false
            self.e_cityBusiness.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            
            self.fCity = false
        }
        else
        {
            self.fCity = true
        }
        
        if self.emailBusiness.text == ""
        {
            self.e_emailBusiness.isHidden = false
            self.e_emailBusiness.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            fEmail = false
        }
        else if self.isValidEmail(self.emailBusiness.text!) == false
        {
            self.e_emailBusiness.isHidden = false
            self.e_emailBusiness.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            fEmail = false
        }
        else{
            fEmail = true
        }
        if self.phoneBusiness.text == ""
        {
            self.e_phoneBusiness.isHidden = false
            self.e_phoneBusiness.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            fPhone = false
        }
        else if self.isValidPhone(self.phoneBusiness.text!) == false || phoneBusiness.text?.count < 5
        {
            self.e_phoneBusiness.isHidden = false
            self.e_phoneBusiness.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            fPhone = false
        }
        else{
            fPhone = true
        }
        
        
        if websiteBusiness.text != ""//כי זה לא שדה חובה
        {
           
            if verifyUrl(websiteBusiness.text) == false
            {
                self.e_websiteBusiness.isHidden = false
                self.e_websiteBusiness.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
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

    func dismiss(){
        //close and return to settings
        var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
        if dicUserId["currentUserId"] as! Int != 0
        {
            let myint =  dicUserId["currentUserId"] as! Int
            
            if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
            {
                api.sharedInstance.getProviderAllDetailsbySimpleUserID(myint)
            }
            else
            {
               api.sharedInstance.getProviderAllDetails(myint)
            }
        }
         self.generic.hideNativeActivityIndicator(self)
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        frontviewcontroller!.pushViewController(viewcon, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
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

        let cell:SettingsDomainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsDomainTableViewCell") as! SettingsDomainTableViewCell
        cell.selectionStyle = .none

        if tableView.tag == 3 {
            let y = indexPath.row
            cell.tag = y
            cell.delegate = self
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
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)

        if tableView.tag == 3  {
            print ("aaaaaaa")
        } else {
            tableView.isHidden = true

        }
    }
    func googlePlaceGeocoded(_ latitude:Double, longitude:Double)
    {
        
        if Global.sharedInstance.isAddressCity == false
        {
            self.addressBusiness.text = ""
        }
        else
        {
            self.cityBusiness.text = ""
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField
        {
        case emailBusiness:
            e_emailBusiness.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            self.cityBusiness.dismissSuggestionTableView()
            self.addressBusiness.dismissSuggestionTableView()
            break
        case phoneBusiness:
            e_phoneBusiness.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            self.cityBusiness.dismissSuggestionTableView()
            self.addressBusiness.dismissSuggestionTableView()
            break
        case addressBusiness:
            let s1 : String = cityBusiness.text!
            if s1 != "" && s1.count > 2 {
                print("edit address ok")
                addressBusiness.isEnabled = true
                addressBusiness.isUserInteractionEnabled = true
                addressEdit = true
                Global.sharedInstance.isAddressCity = false
                e_addressBusiness.isHidden = true
                isTxtAdress = true
                isTxtCity = false
            } else {
                Alert.sharedInstance.showAlertDelegate("COMPLETE_CITY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                addressBusiness.isEnabled = false
                addressBusiness.isUserInteractionEnabled = false
                print("edit address not permited")
            }
            
            
            break
            
        case cityBusiness:
            addressEdit = true
            Global.sharedInstance.isAddressCity = true
            e_cityBusiness.isHidden = true
            isTxtAdress = false
            isTxtCity = true
            addressBusiness.isEnabled = true
            addressBusiness.isUserInteractionEnabled = true
            break
            
        case namebusiness:
            e_namebusiness.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            self.cityBusiness.dismissSuggestionTableView()
            self.addressBusiness.dismissSuggestionTableView()
            break
        case idbusinesscode:
            e_idbusinesscode.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            self.cityBusiness.dismissSuggestionTableView()
            self.addressBusiness.dismissSuggestionTableView()
            break
        case websiteBusiness:
            e_websiteBusiness.isHidden = true
            addressEdit = false
            isTxtAdress = false
            isTxtCity = false
            self.cityBusiness.dismissSuggestionTableView()
            self.addressBusiness.dismissSuggestionTableView()
            
        default:break
        }
        
    }
    func openPersonDetails(){
        
        if Global.sharedInstance.arrayDicForTableViewInCell[2]![2].count == 0
        {
            if Reachability.isConnectedToNetwork() == false
            {
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                api.sharedInstance.GetSysAlertsList(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                 
                    let sysAlert:SysAlerts = SysAlerts()
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                            Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                        }

                    
                    if Global.sharedInstance.arrSysAlerts.count != 0
                    {
                        Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
                        Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
                        Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
                        Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
                        Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
                        Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
                        //2do
                        //במקום זה צריך להיות textField
                        //            Global.sharedInstance.arrayDicForTableViewInCell[4]![1] = sysAlert.SysnvAletName(12)
                    }
                    Global.sharedInstance.whichReveal = false
                        self.providerCustomer()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let frontviewcontroller:UINavigationController = UINavigationController()
                        let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
                        let vc = storyboardCExist.instantiateViewController(withIdentifier: "personalDetailsViewController") as! personalDetailsViewController
                        frontviewcontroller.pushViewController(vc, animated: false)
                        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                        let mainRevealController = SWRevealViewController()
                        mainRevealController.frontViewController = frontviewcontroller
                        mainRevealController.rearViewController = rearViewController
                        let window :UIWindow = UIApplication.shared.keyWindow!
                        window.rootViewController = mainRevealController

                    }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        if AppDelegate.showAlertInAppDelegate == false
//                        {
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            AppDelegate.showAlertInAppDelegate = true
//                        }
                })
            }
        }
        else
        {
             Global.sharedInstance.whichReveal = false
            self.providerCustomer()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let frontviewcontroller:UINavigationController = UINavigationController()
            let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
            let vc = storyboardCExist.instantiateViewController(withIdentifier: "personalDetailsViewController") as! personalDetailsViewController
            frontviewcontroller.pushViewController(vc, animated: false)
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController

        }
    }
    func openCustomer() {
        var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetCustomerDetails["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in

                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                        let FULLDICTIONARY = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                        print(FULLDICTIONARY)
                        var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        if let _ = FULLDICTIONARY["bIsGoogleCalendarSync"] as? Int {
                            let x = FULLDICTIONARY["bIsGoogleCalendarSync"] as! Int
                            if x == 0 {
                                Global.sharedInstance.currentUser.bIsGoogleCalendarSync = false
                            } else {
                                Global.sharedInstance.currentUser.bIsGoogleCalendarSync = true
                            }
                            print("personal informations calendar \(Global.sharedInstance.currentUser.bIsGoogleCalendarSync)")

                        }
                        dicForDefault["nvClientName"] = FULLDICTIONARY["nvFirstName"]
                        dicForDefault["nvPhone"] = FULLDICTIONARY["nvPhone"]
                        Global.sharedInstance.defaults.set(dicForDefault, forKey: "currentClintName")
                        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        dicUserId["currentUserId"] = FULLDICTIONARY["iUserId"]
                        Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                        Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                        Global.sharedInstance.currentUser.dBirthdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dBirthdate
                            , options: [])!
                        Global.sharedInstance.currentUser.dMarriageDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dMarriageDate
                            , options: [])!
                        self.readpersonaldetails()
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                if AppDelegate.showAlertInAppDelegate == false {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
                self.readpersonaldetails()
            })
        }
    }
        func readpersonaldetails() {
            Global.sharedInstance.whichReveal = false
            Global.sharedInstance.isProvider = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let frontviewcontroller:UINavigationController = UINavigationController()
            let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
            let vc = storyboardCExist.instantiateViewController(withIdentifier: "personalDetailsViewController") as! personalDetailsViewController
            frontviewcontroller.pushViewController(vc, animated: false)
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
        }
    func saveDataInGlobal() {

    }
    func selectedDomain(_WHICHDOMAIN:Int) {
        print(_WHICHDOMAIN)
        self.cityBusiness.dismissSuggestionTableView()
        self.addressBusiness.dismissSuggestionTableView()
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
    @objc func closetables() {
        view.endEditing(true)
        self.cityBusiness.dismissSuggestionTableView()
        self.addressBusiness.dismissSuggestionTableView()
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
