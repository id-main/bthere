//
//  OcasionalCustomerPhoneViewController.swift
//  bthree-ios
//
//  Created by Ungureanu Ioan on 01.02.2017
//  Copyright © 2017 Bthere. All rights reserved.
//

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

class OcasionalCustomerPhoneViewController: UIViewController,UITextFieldDelegate {
    let phoneNumberKit = PhoneNumberKit()
    var didClickOnConnect:Bool = false
    var delegate:openControlersDelegate!=nil
    var isValidPhone:Bool = false
    var generic:Generic = Generic()
    var timer: Timer? = nil
    var fDidBegin = false
    var dateServer = Date()
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var indexRow:Int = 0
    @IBOutlet weak var existUser: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtFPhone: UITextField!
    @IBOutlet weak var btnConnect: UIButton!
    @IBAction func btnConnect(_ sender: AnyObject) {
        self.checktelephonevalid(txtFPhone)
        if self.isValidPhone == true {
            self.validToRegister()
        }
    }
    //MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:41)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

    
        txtFPhone.addTarget(self, action: #selector(OcasionalCustomerPhoneViewController.textFieldDidChange), for: .editingChanged)
        txtFPhone.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OcasionalCustomerPhoneViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        lblPhone.text = "PHONE_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        existUser.text = "OCASIONAL_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnConnect.setTitle("ADD_NEW_CUSTOMMER".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - KeyBoard
    
    ///dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelbtn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - TextField
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtFPhone.textColor = UIColor.white
        txtFPhone.text = ""
    }
    
    func checktelephonevalid(_ textField: UITextField) {
        if txtFPhone.text == "" || txtFPhone.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            isValidPhone = false
            txtFPhone.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)//"שדה חובה*"
            txtFPhone.textColor = UIColor.red
        }
        else{
            //GLOBALPHONEValidation ->//  isValidPhone = true
            let numbertoclean = cleanPhoneNumber(self.txtFPhone.text!)
            if numbertoclean.count > 2 {
            let index0 = numbertoclean.index(numbertoclean.startIndex, offsetBy: 0)
            let index1 = numbertoclean.index(numbertoclean.startIndex, offsetBy: 1)
            if self.txtFPhone.text?.count < 10 || (self.txtFPhone.text?[index0] != "0" || self.txtFPhone.text?[index1] != "5")
            {
                
                self.isValidPhone = false
                self.txtFPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                self.txtFPhone.textColor = UIColor.red
            } else {
            let specialCharacterRegEx  = "[*]?[0-9]+"
            let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            let specialresult = texttest2.evaluate(with: self.txtFPhone.text)
            if (specialresult) {
               self.isValidPhone = true
            }
            }
        }
        }
    }

    @objc func textFieldDidChange()
    {
        if isValidPhone == true
        {
            let lastCharacter = txtFPhone.text!.substring(from: txtFPhone.text!.characters.index(before: txtFPhone.text!.endIndex))
            
            isValidPhone = false
            txtFPhone.text = lastCharacter
            txtFPhone.textColor = UIColor.white
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
                
                
                if textField == txtFPhone
                {
                    
                    var cleanNumber:String = ""
                    if string.count > 1
                    {
                        
                        var cleanedString: String = (string.components(separatedBy: CharacterSet(charactersIn: "0123456789-+()").inverted) as NSArray).componentsJoined(by: "")
                        print("cleaned string \(cleanedString)")
                        //            cleanedString = "+972505119731" // modedphone    String    "+972505119731"
                        if cleanedString != ""
                        {
                            if cleanedString.count > 3 {
                            let first3 = cleanedString.substring(to:cleanedString.index(cleanedString.startIndex, offsetBy: 3))
                            if first3 == "009"
                            {
                                let start = cleanedString.index(cleanedString.startIndex, offsetBy: 2)
                                let end = cleanedString.endIndex
                                let range = start..<end
                                
                                let mySubstring = cleanedString[range]
                                
                                cleanedString = "+" + mySubstring
                                
                            }
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
                    {    txtFPhone.resignFirstResponder()
                        Alert.sharedInstance.showAlert("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        return false
                    }
                        
                    else
                    {
                        //                    textField.text = cleanNumber
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
    
func validToRegister()
{
    if isValidPhone == true
    {
        if Reachability.isConnectedToNetwork() == false
        {
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else {
         
            var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dictionaryForServer["iSupplierId"] = 0 as AnyObject

            var providerID:Int = 0
            if Global.sharedInstance.providerID == 0 {
                providerID = 0
                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                    providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                   
                }
            } else {
                providerID = Global.sharedInstance.providerID
            }
            let phoneNumberOccasional:String = self.txtFPhone.text!
            dictionaryForServer["iSupplierId"] = providerID as AnyObject
            dictionaryForServer["nvPhoneNum"] = phoneNumberOccasional as AnyObject
            
              print("what to send \(dictionaryForServer)")
            
            
              print("\n********************************* add ocasional customer  ********************\n")
//            let jsonData = try! NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
//            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
//            print(jsonString)
            
           self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                 self.generic.hideNativeActivityIndicator(self)
//                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else
            {

            //    returns always  134
                 api.sharedInstance.AddOccasionalUser(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any!) -> Void in
                     self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                      print("ce astepta \(String(describing: RESPONSEOBJECT["Result"]))")
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                    {
                        //todo afisez eroare
                         self.generic.hideNativeActivityIndicator(self)
                        //  print("eroare la add new \(RESPONSEOBJECT["Error"])")
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        //todo afisez eroare
                         self.generic.hideNativeActivityIndicator(self)
                          print("eroare la add new \(String(describing: RESPONSEOBJECT["Error"]))")
                    }
                        
                    else
                    {
                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                        {
                            let resultServer :Int = (RESPONSEOBJECT["Result"] as? Int)!
                            print("e ok ? " + resultServer.description)
                            if resultServer > 0 {
                                
                                                             self.showAlertDelegateX("ADDED_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                Global.sharedInstance.nameOfCustomer = "OCCASIONAL_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                self.dismiss(animated: true, completion:  {
                                    
                                    let USERDEF = UserDefaults.standard
                                    if  USERDEF.object(forKey: "numberdefaultForOcassional") != nil
                                    {
                                      USERDEF.removeObject(forKey: "numberdefaultForOcassional")
                                      USERDEF.synchronize()
                                    }
                                    let numberdefault:String = phoneNumberOccasional
                                    USERDEF.set(numberdefault, forKey: "numberdefaultForOcassional")
                                    USERDEF.synchronize()
                                    self.view.endEditing(true)
                                
//                                    let USERDEF = UserDefaults.standard
//                                    if  USERDEF.object(forKey: "numberdefaultForOcassional") != nil {
//                                        USERDEF.removeObject(forKey: "numberdefaultForOcassional")
//                                        USERDEF.synchronize()
//                                    }
//
                                self.getProviderServicesForSupplierFunc(resultServer)
                                })
                                
                                }
                            } else {
                           
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                     self.generic.hideNativeActivityIndicator(self)
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
                         self.generic.hideNativeActivityIndicator(self)
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
                })
            }
        }
    }
}
    func getProviderServicesForSupplierFunc(_ isfromSPECIALiCustomerUserId:Int)
    {
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //dicSearch["iProviderId"] = Global.sharedInstance.providerID
        if Global.sharedInstance.providerID == 0 {
            dictionaryForServer["iProviderId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dictionaryForServer["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
             //   Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            dictionaryForServer["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }
          print("CEEE Global.sharedInstance.providerID \(Global.sharedInstance.providerID)")
        
        api.sharedInstance.getProviderServicesForSupplier(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
            {
                self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                
                
            }
            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
            {
                
                
                if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                let ps:objProviderServices = objProviderServices()
                if let _:Array<Dictionary<String,AnyObject>> = (RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>>) {
                self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                
                
                if self.ProviderServicesArray.count == 0
                {
                    self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    
                }
                else
                {
                    for item in self.ProviderServicesArray {
                        
                          print("self.ProviderServicesArray \(item.description)")
                    }
                    //make them optional or it will crash
                    
                    
                    let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                    let frontviewcontroller:UINavigationController? = UINavigationController()
                    Global.sharedInstance.arrayServicesKodsToServer = []
                    Global.sharedInstance.arrayServicesKods = []
                    Global.sharedInstance.whichReveal = true
                    Global.sharedInstance.viewCon = clientStoryBoard.instantiateViewController(withIdentifier: "SupplierListServicesViewController") as?ListServicesViewController
                    if let  Anarray:Array<objProviderServices> =  self.ProviderServicesArray  {
                        Global.sharedInstance.viewCon?.ProviderServicesArray   = Anarray
                        Global.sharedInstance.viewCon?.indexRow = self.indexRow //it is 0 because we are from own supplier only one row then
                        let USERDEF = Global.sharedInstance.defaults
                        USERDEF.set(self.indexRow, forKey: "listservicesindexRow")
                        USERDEF.set(isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
                        USERDEF.synchronize()
                        Global.sharedInstance.viewCon?.isfromSPECIALSUPPLIER = true
                        Global.sharedInstance.viewCon?.isfromSPECIALiCustomerUserId = isfromSPECIALiCustomerUserId
                    }
                    let USERDEF = Global.sharedInstance.defaults
                    USERDEF.set(3,forKey: "backFromMyListServices")
                    USERDEF.synchronize()
                    frontviewcontroller!.pushViewController(Global.sharedInstance.viewCon!, animated: false)
                    //initialize REAR View Controller- it is the LEFT hand menu.
                    let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                    let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.frontViewController = frontviewcontroller
                    mainRevealController.rearViewController = rearViewController
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController
                    }
                }
                } else {
                       self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            
        })
        
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
}

