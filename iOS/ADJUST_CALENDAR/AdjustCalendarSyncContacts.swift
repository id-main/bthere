//
//  AdjustCalendarSyncContacts.swift
//  Bthere
//
//  Created by Iustin Bthere on 1/7/19.
//  Copyright © 2019 Webit. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Contacts
class AdjustCalendarSyncContacts: NavigationModelViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    private var workItem: DispatchWorkItem?
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var isfromcustomer:Bool = false
    var phone:Array<String> = []
    var chunksarryarr:[[objSyncContact]] =  [[objSyncContact]]()
    var contactsIndex:Int = 0 //contains index of array of 300 contacts to send
    var howmanyarraystosend:Int = 0
    
    var supplierID = 0
    let phoneNumberKit = PhoneNumberKit()
    var generic:Generic = Generic()
    var issearch:Bool = false
    //\\ var existingcontactListFORSAVE:NSMutableArray = NSMutableArray() //precompleted on didload
    var PRELOADEDcontactList:Array<CustomerObj> = Array<CustomerObj>() //preloaded on didload
    var INITIALcontactList:Array<Contact> = Array<Contact>()//JUST SIMPLE CONTACT OBJECT array TO EASY COMPARE WITH Global contacts list
    var contactList: Array<Contact> = Array<Contact>()
    var searchcontactList: Array<Contact> = Array<Contact>()
    var lastChecked:Int = -1
    var newiUserStatusType:Int = 26
//    var newiCreatedByUserId:Int = 0
    var PROVIDERID:Int = 0
    // -1 => nothing checked, 0 => from list, 1 => from search

    var modifiedPhoneNumber:String = ""
    var myDelegate:didSelectContact!=nil
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var titlescreen: UILabel!
    
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var tblCONTACTS: UITableView!
    @IBOutlet weak var txtSearchCustomer: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var BTNSEARCH : UIButton!
    //MARK: - initial
    @IBAction func btnsearch(_ sender: AnyObject?) {
        dismissKeyBoard()
        let textX: String = txtSearchCustomer.text!
        if textX != "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE) &&  textX.count > 0  {
            let  mysearchtxt = textX
            issearch = true
            let namePredicate =
                NSPredicate(format: "nvContactName contains[cd] %@",mysearchtxt)
            searchcontactList = contactList.filter { namePredicate.evaluate(with: $0) }
            print("names = \(searchcontactList)")
            print("lastChecked: \(lastChecked)")
            print("search count: \(searchcontactList.count)")
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCONTACTS.reloadData()
            })
        } else {
            issearch = false
            searchcontactList =  contactList
            print("lastChecked: \(lastChecked)")
            print("contact count: \(searchcontactList.count)")
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCONTACTS.reloadData()
            })
        }
    }
    
    @IBAction func continueAction(_ sender: UIButton)
    {
  
        
    
//        print("nume user: \(contactList[lastChecked].nvContactName) ")
//        print("nr de telefon user: \(contactList[lastChecked].nvPhone)")
        
//        isValidPhoneNumber
//        modifiedPhoneNumber

        if lastChecked != -1
        {
        
        
        if isValidPhoneNumber(phoneNumberToValidate: contactList[lastChecked].nvPhone)
        {
            if modifiedPhoneNumber == ""
            {
                modifiedPhoneNumber = contactList[lastChecked].nvPhone
            }
            //aici
                
                if modifiedPhoneNumber != ""
                {
                    
                        Global.sharedInstance.adjustCalendarUserInfo["nvPhoneNumber"] = self.modifiedPhoneNumber as AnyObject
                        Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] = self.contactList[self.lastChecked].nvContactName as AnyObject
                        self.myDelegate.setContact()
                        self.dismiss(animated: true, completion: nil)
                    
//                    var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//                    dicPhone["nvPhone"] = modifiedPhoneNumber as AnyObject
//                    //                dicPhone["nvPhone"] = "0501111111" as AnyObject
//                    // 7399
//
//                    //not get iuserid by phone
//                    if Reachability.isConnectedToNetwork() == false//if there is connection
//                    {
//                        self.generic.hideNativeActivityIndicator(self)
//                        showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    }
//                    else
//                    {
//                        api.sharedInstance.CheckCustomerExistByPhone(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                            self.generic.hideNativeActivityIndicator(self)
//                            if let _ = responseObject as? Dictionary<String,AnyObject> {
//                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                                if let _ = RESPONSEOBJECT["Result"] as? Int {
//                                    print("numar verifica \(String(describing: RESPONSEOBJECT["Result"]))")
//
//                                    if RESPONSEOBJECT["Result"] as! Int == 0//phone not found
//                                    {
//                                        //user is not in dataBase, we need to Add him/her as a new customer
//                                        self.addNewCustomer()
//
//                                    } else
//                                    {
//                                        //number exists in database
//                                        Global.sharedInstance.adjustCalendarUserInfo = Dictionary<String,AnyObject>()
//                                        Global.sharedInstance.adjustCalendarUserInfo["nvPhoneNumber"] = self.modifiedPhoneNumber as AnyObject
//                                        Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] = self.contactList[self.lastChecked].nvContactName as AnyObject
//                                        Global.sharedInstance.adjustCalendarUserInfo["userID"] = RESPONSEOBJECT["Result"] as AnyObject
//
//                                        self.dismiss(animated: true, completion: nil)
//
//                                    }
//                                }
//                            }
//                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                            print("Error: ", Error!.localizedDescription)
//                            self.generic.hideNativeActivityIndicator(self)
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        })
//
//                    }
                }
        }
        else
        {
            Alert.sharedInstance.showAlert("PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
        }
        else
        {
            Alert.sharedInstance.showAlert("ONE_CONTACT_AT_LEAST".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
        
    }
   
    
    

    
    
    func isValidPhoneNumber(phoneNumberToValidate:String) -> Bool
    {
            modifiedPhoneNumber = ""
            var cleanNumber:String = ""
            if phoneNumberToValidate.count > 1
            {
                
                var cleanedString: String = (phoneNumberToValidate.components(separatedBy: CharacterSet(charactersIn: "0123456789-+()").inverted) as NSArray).componentsJoined(by: "")
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
                        modifiedPhoneNumber = cleanNumber
                        return true
                    }
                }
                
                
            }
            
            if phoneNumberToValidate.characters.count > 10
            {
//                Alert.sharedInstance.showAlert("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                return false
            }
            else if phoneNumberToValidate.characters.count == 0 || phoneNumberToValidate.characters.count == 1
            {
                return false
            }
                
            else
            {
                //                    textField.text = cleanNumber
                return true
            }
        
        
    }
    
    func openEntrance()
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let viewController = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        viewController.myformchangelanguage = true
        frontviewcontroller?.pushViewController(viewController, animated: false)
        
        //initialize REAR View Controller- it is the LEFT hand menu.
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        appDelegate.window!.rootViewController = mainRevealController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    @IBAction func btnback(_ sender: UIButton)
    {
        Global.sharedInstance.adjustCalendarUserInfo = Dictionary<String,AnyObject>()
        self.dismiss(animated: true, completion: {
        self.myDelegate.setContact()
            
        })
    }

    
    
    
    

    
//    func dismiss(){
//        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
//        let frontviewcontroller:UINavigationController? = UINavigationController()
//        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
//        frontviewcontroller!.pushViewController(viewcon, animated: false)
//        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
//        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//        let mainRevealController = SWRevealViewController()
//        mainRevealController.frontViewController = frontviewcontroller
//        mainRevealController.rearViewController = rearViewController
//        let window :UIWindow = UIApplication.shared.keyWindow!
//        window.rootViewController = mainRevealController
//    }
    
    func hidetoast(){
        view.hideToastActivity()
    }
    
   @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func GetProviderContact(){
        
        self.generic.showNativeActivityIndicatorInteractionEnabled(self)
        
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
            //showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            self.view.makeToast(message: "NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
                
                let emptyArray: Array<CustomerObj> =  Array<CustomerObj>()
                self.processMYARRAY(emptyArray)
            })
        }
        else {
            
            
            
            var dicSentToServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dicSentToServer["iProviderId"] = self.supplierID as AnyObject
            api.sharedInstance.GetProviderContact(dicSentToServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            let emptyArray: Array<CustomerObj> =  Array<CustomerObj>()
                            self.processMYARRAY(emptyArray)
                        }
                        else
                            if let responseDictionary:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                let arrayForProcessing: Array<CustomerObj> = self.customerObjToArray(responseDictionary)
                                self.processMYARRAY(arrayForProcessing)
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
                let emptyArray: Array<CustomerObj> =  Array<CustomerObj>()
                self.processMYARRAY(emptyArray)
            })
            
        }
        
    }
    func processMYARRAY (_ mycostomers:  Array<CustomerObj>) {
        var temporaryContactsArray:Array<Contact> = Array<Contact>()
        print("toti existenti \(mycostomers)")
        PRELOADEDcontactList = mycostomers
        
        
        for item in PRELOADEDcontactList {

            var cleannumber:String = ""
            if item.userObj.nvPhone != "" {

                cleannumber = cleanPhoneNumber(item.userObj.nvPhone)
                item.userObj.nvPhone = cleannumber
            }
            let contact:Contact = Contact(_iUserId: item.userObj.iUserId, _iUserStatusType: item.userObj.iUserStatusType, _nvContactName: item.userObj.nvFirstName + " " + item.userObj.nvLastName , _nvPhone: /* item.userObj.nvPhone */ cleannumber, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: true, _nvFirstName: item.userObj.nvFirstName, _nvLastName: item.userObj.nvLastName, _allPHONES:item.userObj.allPHONES,_nvNickName: "")
            if !temporaryContactsArray.contains(contact) {
                if contact.nvContactName != "" {
                    temporaryContactsArray.append(contact)
                }
            }

        }
        
        if temporaryContactsArray.count == 0 {
            temporaryContactsArray = Global.sharedInstance.contactList
            for item in temporaryContactsArray {
                item.bIsSync = false
            }
        }
            
        else {
            var temporaryPhoneNumbers:Array<String> = Array<String>()
            
            for itemx in temporaryContactsArray {
                temporaryPhoneNumbers.append(itemx.nvPhone)
            }
            let uniquePhoneNumbers = Set(temporaryPhoneNumbers)
            var temporaryContactList:Array<Contact> = Array<Contact>()
            for item in Global.sharedInstance.contactList {
                let c:String = item.nvPhone
                if uniquePhoneNumbers.contains(c) {
                    //    break
                    
                } else {
                    temporaryContactList.append(item)
                }
            }
            print(temporaryContactList.count)
            
            Global.sharedInstance.contactList = temporaryContactList
            for item in temporaryContactList
            {
                
                item.bIsSync = false
                temporaryContactsArray.append(item)
                
            }
        }
        
        //        for item in Global.sharedInstance.contactList {
        //            let c:String = item.nvPhone
        //            var cleannumber:String = ""
        //            if c != ""  && c.characters.count > 2 {
        //                let cleaned =  cleanPhoneNumber(c)
        //                let numertocompare = cleaned
        //                let index0 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 0)
        //                let index1 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 1)
        //                if numertocompare.characters.count != 10 || (numertocompare.characters[index0] != "0" || numertocompare.characters[index1] != "5") {
        //
        //                    //ignore all bad numbers
        //                    print("bad number? \(numertocompare)")
        //                } else {
        //                    cleannumber = cleanPhoneNumber(c)
        //                    item.nvPhone = cleannumber
        //                }
        //            } else {
        //                //nothing
        //            }
        //
        //        }
        //        if temporary.count == 0 {
        //            temporary = Global.sharedInstance.contactList
        //            for item in temporary {
        //                item.bIsSync = false
        //            }
        //        }
        //
        //        else {
        //            var keysuniquevalues:Array<String> = Array<String>()
        //
        //             for itemx in temporary {
        //                keysuniquevalues.append(itemx.nvPhone)
        //            }
        //             var set = Set(keysuniquevalues)
        //            for item in Global.sharedInstance.contactList {
        //                let c:String = item.nvPhone
        ////
        //                if set.contains(c) {
        //                 //   let indexidsearch = set.index(of:c)
        //                    break
        //
        //                } else {
        //                        if !temporary.contains(item) {
        //
        //
        //                            let cleaned = cleanPhoneNumber(item.nvPhone)
        //                            if cleaned  != "" && cleaned.characters.count > 2 {
        //
        //                                let numertocompare = cleaned
        //                                let index0 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 0)
        //                                let index1 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 1)
        //                                if numertocompare.characters.count != 10 || (numertocompare.characters[index0] != "0" || numertocompare.characters[index1] != "5") {
        //                                    //ignore all bad numbers
        //                                } else {
        //                                    //fix userid because it an be previous deleted but still on server
        //                                   //    for itemx in temporary {
        ////                                    if itemx.iUserId > 0 {
        ////                                        item.iUserId = itemx.iUserId
        ////                                    }
        //                                    item.bIsSync = false
        //                               //print("whatif \(item.getContactDic())")
        //                                    temporary.append(item)
        //                                }
        //                            }  else {
        //                                //nothing
        //                            }
        //                                }
        //                }
        //            }
        //        }
        
        
        
//        print("cate sunt \(temporary.count)")
//
        var finalContactsArray:Array<Contact> = Array<Contact>()
        for item in temporaryContactsArray {
//            print("ce nume ?\(item.nvContactName )")
            if  item.nvContactName.count > 1  {
                //    print("item.nvContactName \(item.nvContactName.characters.count) si bsync check \(PREETYJSON_JMOD(item.getContactDic()))")
                if !finalContactsArray.contains(item) {
                    finalContactsArray.append(item)
                }
            }
        }
//        print("cate sunt finalefiltered \(finalefiltered.count)")
        contactList = finalContactsArray
        searchcontactList = Array<Contact>()
        searchcontactList =  contactList
        
//        for contact in contactList
//        {
//            print("contact gasit \(contact.nvContactName)")
//            //   contact.bIsSync = false
//        }
        self.generic.hideNativeActivityIndicator(self)
        
        tblCONTACTS.reloadData()
    }
    func opensyncontactspopup() {
        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
        let viewpopupSyncContacts = storyboardtest.instantiateViewController(withIdentifier: "popupSyncContacts") as! popupSyncContacts
        if self.iOS8 {
            viewpopupSyncContacts.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewpopupSyncContacts.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        
        self.present(viewpopupSyncContacts, animated: true, completion: nil)
    }
    //
    func PREETYJSON_JMOD(_ params:Dictionary<String,AnyObject>) {
        print("*********************************  contact  my data ********************\n")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print("*********************************  contact  my data ********************\n")
    }
//    @IBAction func btnsave(_ sender: UIButton) {
//        var phones:Array<String> = []
//        let dateString = "01/01/1901" // change to your date format
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat =  "dd/MM/yyyy"
//        let birthday = dateFormatter.date(from: dateString)
//
//        for contact in contactList {
//            if contact.bIsSync == true
//            {
//                phones.append(contact.nvPhone)
//            }
//        }
//        var swiftarr:Array<objSyncContact> = Array<objSyncContact>()
//        for contact in contactList {
//            if contact.bIsSync == true
//            {
//                var nvfirstname = ""
//                var nvlastname = ""
//                var nvNickName:String = ""
//                if contact.nvFirstName != ""  {
//                    nvfirstname = contact.nvFirstName
//                }
//                if contact.nvLastName != ""  {
//                    nvlastname = contact.nvLastName
//                }
//                nvNickName = nvfirstname + " " + nvlastname
//                let c:String = contact.nvPhone
//                var cleannumber:String = ""
//
//                if c != "" {
//                    cleannumber = cleanPhoneNumber(c)
//
//                }
//                if cleannumber.count > 2 {
//                    let numertocompare = cleannumber
//                    let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
//                    let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
//                    if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
//                        //ignore all bad number
//                    }
//                    else
//                    {
//                        if nvNickName.count > 0 {
//                            let  objSyncContactnew:objSyncContact =  objSyncContact(_nvFirstName: "", _bAutomaticUpdateApproval: false, _iLastModifyUserId: 0, _nvPassword: "", _nvUserName: "", _iCityType: 0, _nvVerification: "", _bAdvertisingApproval: false, _iCreatedByUserId: 0, _bIsManager: 0, _dBirthdate: birthday!, _nvMail: "", _iUserStatusType: 26, _bIsGoogleCalendarSync: false, _bDataDownloadApproval: false, _nvLastName: "", _nvPhone: /* contact.nvPhone */ cleannumber, _iSysRowStatus: 1, _bTermOfUseApproval: false, _iUserId: 0, _allPHONES: [], _nvNickName: nvNickName)
//                            if !swiftarr.contains(objSyncContactnew) {
//                                swiftarr.append(objSyncContactnew)
//                            }
//
//                        }
//                    }
//                }
//            }
//        }
//        if self.isfromcustomer {
//            if swiftarr.count >= 4 {
//            }
//            else {
//                self.opensyncontactspopup()
//                return
//            }
//        }
//        if swiftarr.count == 0 {
//
//            self.dismiss()
//
//        } else
//            if swiftarr.count > 100 {
//                let chunkSize = 100
//                let chunks = stride(from: 0, to: swiftarr.count, by: chunkSize).map {
//                    Array(swiftarr[$0..<min($0 + chunkSize, swiftarr.count)])
//                }
//                print("chunks \(chunks)")
//                howmanyarraystosend = chunks.count
//                self.chunksarryarr = chunks
//                self.alldatasend()
//            }
//            else {
//                howmanyarraystosend = 1
//                sendContacts(listof300: swiftarr)
//        }
//
//    }
    func resendIfLeft() {
        let indexContact = self.contactsIndex
        let arr = self.chunksarryarr
        if let _ = arr[indexContact] as [objSyncContact]? {
            let listof300 = arr[indexContact]
            sendContacts(listof300: listof300)
        }
        
    }
    func sendContacts(listof300:Array<objSyncContact>){
        
        var dicToSendToServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        let emptyArray:Array = [] as Array
        let bAutoApproval = true
        var contactsUsers:NSMutableArray = NSMutableArray()
        contactsUsers = []
        for item in listof300 {
            let objtoadd = item.getDic()
            if !contactsUsers.contains(objtoadd) {
                contactsUsers.add(objtoadd)
            }
        }
        self.generic.showNativeActivityIndicatorInteractionEnabled(self)
        howmanyarraystosend = howmanyarraystosend - 1
        self.contactsIndex = self.contactsIndex + 1
        
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            
            dicToSendToServer["objSyncContactsUsers"] = contactsUsers as AnyObject
            dicToSendToServer["iProviderId"] = self.supplierID as AnyObject
            dicToSendToServer["bAutoApproval"] = bAutoApproval as AnyObject
            dicToSendToServer["nvPhoneList"] = emptyArray as AnyObject
            api.sharedInstance.SyncContactsRegistration(dicToSendToServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
                
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            if self.howmanyarraystosend == 0 {
                                self.view.makeToast(message: "ERROR_UPDATE_CONTACTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()
                                })
                            } else {
                                self.resendIfLeft()
                            }
                        }
                        else
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let integerServerResponse :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                
                                if integerServerResponse == 1 {
                                    if self.howmanyarraystosend == 0 {
                                        self.view.makeToast(message: "UPDATED_SYNC_CONTACTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(4.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                            self.hidetoast()
                                            if self.isfromcustomer == false {
                                                self.dismiss(animated: true, completion: nil)
                                            } else {
                                                self.openEntrance()
                                            }
                                            
                                            
                                        })
                                        
                                    } else {
                                        self.resendIfLeft()
                                    }
                                }
                        }
                    }
                }
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
                if self.howmanyarraystosend == 0 {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                } else {
                    self.resendIfLeft()
                }
                
            })
        }
    }
    
    //special case - ask Ioan
//    func testARR() {
//        let url = Bundle.main.url(forResource: "JHC", withExtension: "json")
//        let data = try? Data(contentsOf: url!)
//        do {
//            let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//            if let myaarr = object as? NSArray {
//                print("here is")
//                for item in myaarr {
//                    if let _:NSDictionary = item as?  NSDictionary {
//                        let myitem = item as!   NSDictionary
//                        print (myitem["nvFirstName"])
//                    }
//                }
//            }
//        } catch {
//            // Handle Error
//        }
//    }
    
    
    

    
    func contacts() -> [CNContact]  {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            //  CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            //  CNContactImageDataAvailableKey,
            //   CNContactThumbnailImageDataKey
            ] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return results
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   testARR()
        //    existingcontactListFORSAVE = []
        self.navigationController?.navigationBar.isHidden = true
        PRELOADEDcontactList = []
        
        self.generic.showNativeActivityIndicatorInteractionEnabled(self)
        
        
        
        
        
        btnsave.setTitle("CONTINUE_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        //  Global.sharedInstance.setContacts()
        
        //        let leftarrowback = UIImage(named: "sageata2.png")
        //        self.btnback.setImage(leftarrowback, for: UIControlState())
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnback.transform = scalingTransform
            self.backImg.transform = scalingTransform
        }
        btnback.imageView!.contentMode = .scaleAspectFit

            titlescreen.text =  "SELECT_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        
        //  supplierID = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
        
        
        txtSearchCustomer.delegate = self
        txtSearchCustomer.text = "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            
        } else {
            txtSearchCustomer.textAlignment = .left
        }
        
        
        tblCONTACTS.separatorStyle = .none
   
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        workItem = DispatchWorkItem {
//            Global.sharedInstance.contactList = []
//            let store = CNContactStore()
//            print(CNContactStore.authorizationStatus(for: .contacts).hashValue)
//            switch CNContactStore.authorizationStatus(for: .contacts){
//
//            case .denied:
//                print("ask")
//                DispatchQueue.main.async {
//                    self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
//                }
//                let alert = UIAlertController(title: nil, message: "REQUEST_CONTACTS_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
//                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
//                })
//                alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
//                })
//                var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//                if let navigationController = rootViewController as? UINavigationController {
//                    rootViewController = navigationController.viewControllers.first
//                }
//                if let tabBarController = rootViewController as? UITabBarController {
//                    rootViewController = tabBarController.selectedViewController
//                }
//                rootViewController?.present(alert, animated: true, completion: nil)
//            case .authorized:
//
//                print("access granted")
//                // getContactNames()
//                // print("lazy \(self.contacts)")
//                var contactsFull: [CNContact] = []
//                contactsFull = self.contacts()
//                /////// JMODE PLUS NEW iOS 10 CONTACT LOCATIONS ////////
//
//                 ), emailAddresses=(
//                 ), postalAddresses=(not fetched)>
//                 */
//                var indexForUserid : Int = 0
//
//                for record:CNContact in contactsFull
//                {
//                    self.phone = []
//                    let contactPerson: CNContact = record
//                    var givenName = ""
//                    var familyName = ""
//                    var numecompus = ""
//                    var MobNumVar = ""
//
//                    givenName = contactPerson.givenName;
//                    familyName = contactPerson.familyName;
//                    numecompus = givenName + " " + familyName
//                    if numecompus.count > 0 {
//                        if contactPerson.phoneNumbers.count > 0 {
//                            //person has 1 or more numbers
//                            for i in 0..<contactPerson.phoneNumbers.count {
//                                MobNumVar = (contactPerson.phoneNumbers[i].value ).value(forKey: "digits") as! String
//                                let cleaned = self.cleanPhoneNumber(MobNumVar)
//                                //                        if cleaned.characters.count > 2 {
//                                //                            let numertocompare = cleaned
//                                //                            let index0 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 0)
//                                //                            let index1 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 1)
//                                //                            if numertocompare.characters.count != 10 || (numertocompare.characters[index0] != "0" || numertocompare.characters[index1] != "5") {
//                                if cleaned.count > 2 {
//                                    let numertocompare = cleaned
//                                    let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
//                                    let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
//                                    if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
//                                        //ignore all bad numbers
//                                        // print("bad number? \(numertocompare)")
//                                    } else {
//                                        //all this person numbers go to _allPHONES:phone array see below
//                                        self.phone.append(cleaned)
//                                    }
//                                }
//                            }
////                            if self.phone.count > 0 {
////                                indexForUserid = indexForUserid + 1
////                                let firstvalidphone = self.phone[0] // only first valid number found is added to _nvPhone
////                                let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:self.phone,_nvNickName:numecompus)
////
////                                Global.sharedInstance.contactList.append(c)
////
////                            }
//                            if self.phone.count > 0 {
//                                for i in 0..<self.phone.count { //JMODE+ 28.01.2019
//                                    indexForUserid = indexForUserid + 1
//                                    let firstvalidphone = self.phone[i] // JMODE phone[0]old code only first valid number found is added to _nvPhone
//                                    let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:self.phone,_nvNickName:numecompus)
//                                    Global.sharedInstance.contactList.append(c)
//                                }
//                            }
//                        }
//                    }
//                }
//                var myafterset =   Global.sharedInstance.contactList.uniquevals
//                Global.sharedInstance.contactList = myafterset
//                //   let descriptor: NSSortDescriptor = NSSortDescriptor(key: "nvLastName", ascending: true)
//               // let sortedByFirstNameSwifty =  Global.sharedInstance.contactList.sorted(by: { $0.nvLastName < $1.nvLastName })
//                let sortedByFirstNameSwifty =  Global.sharedInstance.contactList.sorted(by: { $0.nvContactName < $1.nvContactName })
//                Global.sharedInstance.contactList = sortedByFirstNameSwifty
//
//                print("ce are aici iar \(Global.sharedInstance.contactList )")
//                DispatchQueue.main.async {
//                    self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
//                    self.GetProviderContact()
//                }
//                ////    END PARSING ////
//
//            case .notDetermined:
//                DispatchQueue.main.async {
//                    self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
//                }
//                print("requesting access...")
//                store.requestAccess(for: .contacts){succeeded, err in
//                    guard err == nil && succeeded
//                        else{
//                            print("error")
//                            return
//                    }
//                    print("no try access granted")
//                    //  self.getContactNames()
//                    let alert = UIAlertController(title: nil, message: "REQUEST_CONTACTS_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
//                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
//                    })
//                    alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
//                    })
//                    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//                    if let navigationController = rootViewController as? UINavigationController {
//                        rootViewController = navigationController.viewControllers.first
//                    }
//                    if let tabBarController = rootViewController as? UITabBarController {
//                        rootViewController = tabBarController.selectedViewController
//                    }
//                    rootViewController?.present(alert, animated: true, completion: nil)
//
//                }
//            default:
//                print("Not handled")
//            }
//
//
//        }
//        DispatchQueue.global().async(execute: workItem!)
        // DispatchQueue.global().async(execute: mydispatchWorkItem)
        //        DispatchQueue.main.async {
        //          //  DispatchQueue.global(qos: .userInitiated).async {
        //
        //               mydispatchWorkItem
        //
        //            }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Global.sharedInstance.providerID == 0 {
            PROVIDERID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                PROVIDERID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            PROVIDERID = Global.sharedInstance.providerID
        }
//        newiCreatedByUserId = PROVIDERID
        
        
        Global.sharedInstance.contactList = []
        let authorizationForAccessingContacts = CNContactStore()
        print(CNContactStore.authorizationStatus(for: .contacts).hashValue)
        switch CNContactStore.authorizationStatus(for: .contacts){
            
        case .denied:
            print("ask")
            DispatchQueue.main.async {
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
            }
            let alert = UIAlertController(title: nil, message: "REQUEST_CONTACTS_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
            })
//            var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//            if let navigationController = rootViewController as? UINavigationController {
//                rootViewController = navigationController.viewControllers.first
//            }
//            if let tabBarController = rootViewController as? UITabBarController {
//                rootViewController = tabBarController.selectedViewController
//            }

            self.present(alert, animated: true, completion: nil)

        case .authorized:
            
            print("access granted")
            // getContactNames()
            // print("lazy \(self.contacts)")
            var contactsFull: [CNContact] = []
            contactsFull = self.contacts()
            /////// JMODE PLUS NEW iOS 10 CONTACT LOCATIONS ////////
            
            var indexForUserid : Int = 0
            
            for record:CNContact in contactsFull
            {
                self.phone = []
                let contactPerson: CNContact = record
                var givenName = ""
                var familyName = ""
                var fullName = ""
                var mobilePhoneNumber = ""
                
                givenName = contactPerson.givenName;
                familyName = contactPerson.familyName;
                fullName = givenName + " " + familyName
                if fullName.count > 0 {
                    if contactPerson.phoneNumbers.count > 0 {
                        //person has 1 or more numbers
                        for i in 0..<contactPerson.phoneNumbers.count {
                            mobilePhoneNumber = (contactPerson.phoneNumbers[i].value ).value(forKey: "digits") as! String
//                            let cleaned = self.cleanPhoneNumber(MobNumVar)
                            //                        if cleaned.characters.count > 2 {
                            //                            let numertocompare = cleaned
                            //                            let index0 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 0)
                            //                            let index1 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 1)
                            //                            if numertocompare.characters.count != 10 || (numertocompare.characters[index0] != "0" || numertocompare.characters[index1] != "5") {
//                            if cleaned.count > 2 {
//                                let numertocompare = cleaned
//                                let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
//                                let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
//                                if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
//                                    //ignore all bad numbers
//                                    // print("bad number? \(numertocompare)")
//                                } else {
//                                    //all this person numbers go to _allPHONES:phone array see below
//                                    self.phone.append(cleaned)
//                                }
//                            }
                            self.phone.append(mobilePhoneNumber)
                        }
                        
                        //                            if self.phone.count > 0 {
                        //                                indexForUserid = indexForUserid + 1
                        //                                let firstvalidphone = self.phone[0] // only first valid number found is added to _nvPhone
                        //                                let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:self.phone,_nvNickName:numecompus)
                        //
                        //                                Global.sharedInstance.contactList.append(c)
                        //
                        //                            }
//                        self.phone.append(cleaned)
                        if self.phone.count > 0 {
                            for i in 0..<self.phone.count { //JMODE+ 28.01.2019
                                indexForUserid = indexForUserid + 1
                                let firstvalidphone = self.phone[i] // JMODE phone[0]old code only first valid number found is added to _nvPhone
                                let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: fullName, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:self.phone,_nvNickName:fullName)
                                Global.sharedInstance.contactList.append(c)
                            }
                        }
                    }
                }
            }
            Global.sharedInstance.contactList = Global.sharedInstance.contactList.uniquevals
            //   let descriptor: NSSortDescriptor = NSSortDescriptor(key: "nvLastName", ascending: true)
            // let sortedByFirstNameSwifty =  Global.sharedInstance.contactList.sorted(by: { $0.nvLastName < $1.nvLastName })
            let sortedByFirstNameSwifty =  Global.sharedInstance.contactList.sorted(by: { $0.nvContactName < $1.nvContactName })
            Global.sharedInstance.contactList = sortedByFirstNameSwifty
            
            let emptyCustomerObjArray:Array<CustomerObj> = Array<CustomerObj>()
            self.processMYARRAY(emptyCustomerObjArray)
//            print("ce are aici iar \(Global.sharedInstance.contactList )")
//            DispatchQueue.main.async {
//                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
//                self.GetProviderContact()
//            }
//            let estearr: Array<CustomerObj> = self.customerObjToArray(arrDic)
//            self.processMYARRAY(estearr)
            ////    END PARSING ////
            
        case .notDetermined:
            DispatchQueue.main.async {
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
            }
            print("requesting access...")
            authorizationForAccessingContacts.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded
                    else{
                        print("error")
                        return
                }
                print("no try access granted")
                //  self.getContactNames()
                let alert = UIAlertController(title: nil, message: "REQUEST_CONTACTS_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
                })
//                var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//                if let navigationController = rootViewController as? UINavigationController {
//                    rootViewController = navigationController.viewControllers.first
//                }
//                if let tabBarController = rootViewController as? UITabBarController {
//                    rootViewController = tabBarController.selectedViewController
//                }
                self.present(alert, animated: true, completion: nil)
                
            }
        default:
            print("Not handled")
        }
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if issearch == false {
            print("contactList.count \(contactList.count)")

            return contactList.count
            
        } else {
            return searchcontactList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "SyncContactsRegistrationTableViewCell")as!SyncContactsRegistrationTableViewCell
//        cell.delegate = self
        cell.btnISsync.tag = indexPath.row
        cell.btnISsync.isUserInteractionEnabled = false
        if issearch == false {
            cell.btnISsync.isHidden = !contactList[indexPath.row].bIsSync
            cell.setDisplayData(contactList[indexPath.row].nvContactName)
            let contactcheck =  contactList[indexPath.row]
            let phonecheck = contactcheck.nvPhone
            //    print("nume :\(contactcheck.nvLastName) prenume : \(contactcheck.nvFirstName)nickname  \(contactcheck.nvNickName))")
            for item in PRELOADEDcontactList {
                let phonepreloaded = item.userObj.nvPhone
                if phonecheck == phonepreloaded {
                    cell.btnISsync.isHidden = false
                }
            }
        }
        else {
            cell.btnISsync.isHidden = !searchcontactList[indexPath.row].bIsSync
            cell.setDisplayData(searchcontactList[indexPath.row].nvContactName)
            let contactcheck =  searchcontactList[indexPath.row]
            let phonecheck = contactcheck.nvPhone
            //     print("nume :\(contactcheck.nvLastName) prenume : \(contactcheck.nvFirstName)nickname  \(contactcheck.nvNickName))")
            for item in PRELOADEDcontactList {
                let phonepreloaded = item.userObj.nvPhone
                if phonecheck == phonepreloaded {
                    cell.btnISsync.isHidden = false
                }
            }
            
        }
        cell.selectionStyle = .none
        if indexPath.row == 0
        {
            cell.viewTOp.isHidden = false
        }
        else{
            cell.viewTOp.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if issearch == false {
            var phoneexists:Bool = false
            let contactcheck =  contactList[indexPath.row]
            let phonecheck = contactcheck.nvPhone
            print("false search, indexPath: \(indexPath.row)")
            
//            lastCheckedSearch = -1
//           contactcheck.bIsSync = !contactcheck.bIsSync
            if lastChecked == -1
            {
                contactcheck.bIsSync = true
//                isCheckedFromSearch = 0
                lastChecked = indexPath.row
                
            }
            else if lastChecked != -1
            {
                if lastChecked == indexPath.row
                {
                    contactcheck.bIsSync = false
                    lastChecked = -1
                }
                else
                {
                    
                    contactList[lastChecked].bIsSync = false
                    contactcheck.bIsSync = true
                    lastChecked = indexPath.row
                }
                
            }

            
            // asdasdasdasdasd
//            if lastCheckedSearch != -1
//            {
//                lastChecked = contactList.index(of: searchcontactList[lastCheckedSearch])!
//                lastCheckedSearch = -1
//            }
//
//
//            if lastChecked == -1
//            {
//                contactcheck.bIsSync = true
//                lastChecked = indexPath.row
//            }
//            else if lastChecked == indexPath.row
//            {
//                contactcheck.bIsSync = false
//                lastChecked = -1
//
//            }
//            else
//            {
//                contactcheck.bIsSync = true
//                contactList[lastChecked].bIsSync = false
//                lastChecked = indexPath.row
//            }
            
           //asdasdasdasd
            
//            if lastChecked == -1 && lastCheckedSearch == -1
//            {
//                lastChecked = indexPath.row
//                contactList[lastChecked].bIsSync = true
//            }
//            else if lastChecked == -1 && lastCheckedSearch != -1
//            {
//                contactList[lastCheckedSearch].bIsSync = false
//                lastCheckedSearch = -1
//                lastChecked = indexPath.row
//                contactList[lastChecked].bIsSync = true
//
//
//            }
//            else if lastChecked != -1 && lastCheckedSearch == -1
//            {
//                if lastChecked == indexPath.row
//                {
//                    contactList[lastChecked].bIsSync = false
//                    lastChecked = -1
//                }
//                else
//                {
//                    contactList[lastChecked].bIsSync = false
//                    lastChecked = indexPath.row
//                    contactList[lastChecked].bIsSync = true
//
//                }
//            }
//            print("searchList count before assign: \(searchcontactList.count)")
            searchcontactList = contactList
            print("contact list count in did select \(searchcontactList.count)")
            print("last checked in did select: \(lastChecked)")
            
            }

        
        if issearch == true {
            var phoneexists:Bool = false
            let contactcheck =  searchcontactList[indexPath.row]
            let phonecheck = contactcheck.nvPhone
            let indexOfA:Int = contactList.index(of: searchcontactList[indexPath.row])!
            print("true search, indexOfA: \(indexOfA)")
            
            if lastChecked == -1
            {
                contactcheck.bIsSync = true
                //                isCheckedFromSearch = 0
                lastChecked = indexOfA
                
            }
            else if lastChecked != -1
            {
                if lastChecked == indexOfA
                {
                    contactcheck.bIsSync = false
                    lastChecked = -1
                }
                else
                {
                    contactList[lastChecked].bIsSync = false
                    contactcheck.bIsSync = true
                    lastChecked = indexOfA
                }
                
            }
//            if lastChecked != -1
//            {
//                lastCheckedSearch = searchcontactList.index(of: contactList[lastChecked])!
//                lastChecked = -1
//            }
            
            
//            if lastChecked == -1 && lastCheckedSearch == -1
//            {
//                lastCheckedSearch = indexOfA
//                contactList[lastCheckedSearch].bIsSync = true
//            }
//            else if lastChecked == -1 && lastCheckedSearch != -1
//            {
//                if lastCheckedSearch == indexOfA
//                {
//                    contactList[lastCheckedSearch].bIsSync = false
//                    lastCheckedSearch = -1
//                }
//                else
//                {
//                    contactList[lastCheckedSearch].bIsSync = false
//                    lastCheckedSearch = indexOfA
//                    contactList[lastCheckedSearch].bIsSync = true
//
//                }
//            }
//            else if lastChecked != -1 && lastCheckedSearch == -1
//            {
//                contactList[lastChecked].bIsSync = false
//                lastChecked = -1
//                lastCheckedSearch = indexOfA
//                contactList[lastCheckedSearch].bIsSync = true
//
//            }
            // asdasdasd
//            if lastCheckedSearch == -1
//            {
//                contactcheck.bIsSync = true
//                lastCheckedSearch = indexOfA
//            }
//            else if lastCheckedSearch == indexOfA
//            {
//                contactcheck.bIsSync = false
//                lastCheckedSearch = -1
//            }
//            else
//            {
//                contactList[lastCheckedSearch].bIsSync = false
//                lastCheckedSearch = indexOfA
//                contactcheck.bIsSync = true
//            }
            // asdasdasdas
//            print("searchList count in search true \(searchcontactList.count)")
            contactList[indexOfA].bIsSync = searchcontactList[indexPath.row].bIsSync
            print("search list count in did select \(searchcontactList.count)")
            print("last checked in did select: \(lastChecked)")
        }
        self.tblCONTACTS.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if issearch == false {
            let contactcheck =  contactList[indexPath.row]
            let phonecheck = contactcheck.nvPhone
            //   print("nume :\(contactcheck.nvLastName) prenume : \(contactcheck.nvFirstName)nickname  \(contactcheck.nvNickName))")
            for item in PRELOADEDcontactList {
                let phonepreloaded = item.userObj.nvPhone
                if phonecheck == phonepreloaded {
                    return 0
                }
            }
        } else {
            let contactcheck =  searchcontactList[indexPath.row]
            let phonecheck = contactcheck.nvPhone
            //        print("nume :\(contactcheck.nvLastName) prenume : \(contactcheck.nvFirstName)nickname  \(contactcheck.nvNickName))")
            for item in PRELOADEDcontactList {
                let phonepreloaded = item.userObj.nvPhone
                if phonecheck == phonepreloaded {
                    return 0
                }
            }
        }
        return view.frame.size.height*0.12
    }
    
    
    
    
    //פונקציה המופעלת בעת לחיצה על כפתור של איש קשר כדי לכבותו,
    //הפונקציה מכבה את הכפתור ״בחר הכל״

    func textFieldDidChange(_ textField: UITextField) {
        //Working code JMODE+
        if textField.text?.count == 0 {
            issearch = false
            dismissKeyBoard()
            btnsearch(nil)
        }
    }
    @objc func dismissKeyBoard() {
        
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if textField.text == ""
        {
            textField.text =  "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            issearch = false
            textField.resignFirstResponder()
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCONTACTS.reloadData()
            })
        } else if  textField.text ==  "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
            issearch = false
            textField.resignFirstResponder()
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCONTACTS.reloadData()
            })
        }
        else {
            issearch = true
            //execute search without tap button keeps selected values
            for i in 0..<searchcontactList.count {
                let contact:Contact = searchcontactList[i]
                
                if let _:Int = contactList.index(of: contact) {
                    let indexOfContact:Int = contactList.index(of: contact)!
                    print("indexOfA \(indexOfContact)")
                    contactList[indexOfContact].bIsSync = contact.bIsSync
                }
            }
            
            self.btnsearch(nil)
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtSearchCustomer
        {
            if textField.text == "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                textField.text = ""
            }
        }
    }
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        startString += string
        print("startString \(startString) \(textField.text)")
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if substring == ""
        {
            startString = ""
        }
        
        if startString.count == 0
        {
            textField.text = "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            issearch = false
            dismissKeyBoard()
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCONTACTS.reloadData()
            })
            return false
        }
        else
        {
            issearch = true
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtSearchCustomer
        {
            if textField.text == ""
            {
                textField.text = "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                issearch = false
                dismissKeyBoard()
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tblCONTACTS.reloadData()
                })
            }
        }
    }
    func dicToCustomerObj(_ dic:Dictionary<String,AnyObject>)->CustomerObj
    {
        let customerObj:CustomerObj = CustomerObj()
        
        customerObj.userObj = customerObj.userObj.dicToObjUsers(dic["userObj"] as! Dictionary<String,AnyObject>)
        customerObj.iProviderId = Global.sharedInstance.parseJsonToInt(dic["iProviderId"]!)
        customerObj.bIsVip = dic["bIsVip"] as! Bool
        
        return customerObj
    }
    
    func customerObjToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<CustomerObj>
    {
        
        var arrCustomerObj:Array<CustomerObj> = Array<CustomerObj>()
        var objCustomerObj:CustomerObj = CustomerObj()
        
        for i in 0  ..< arrDic.count
        {
            objCustomerObj = dicToCustomerObj(arrDic[i])
            arrCustomerObj.append(objCustomerObj)
        }
        return arrCustomerObj
    }
    func cleanPhoneNumber(_ nvPhone:String) -> String {
        var temporaryPhoneNumber:String = ""
        var phoneNmbToBeCleaned = nvPhone
        if  nvPhone != ""
        {
            //add to check if number has country code
            do {
                let phoneNumber = try phoneNumberKit.parse(nvPhone)
                let phoneNumberCustomDefaultRegion = try phoneNumber.countryCode
                if phoneNumberCustomDefaultRegion != 0 {
                    print ("phoneNumberCustomDefaultRegion \(phoneNumberCustomDefaultRegion)")
                    let newString = phoneNmbToBeCleaned.stringByReplacingFirstOccurrenceOfString(target: String(phoneNumberCustomDefaultRegion), withString: "0")
                    phoneNmbToBeCleaned = newString
                    print("formated number is \(phoneNmbToBeCleaned)")
                }
            }
            catch {
                print("Generic parser error")
            }
            for char in (phoneNmbToBeCleaned)
            {
                if (char >= "0" && char <= "9") || char == "*"
                {
                    let c:Character = char
                    temporaryPhoneNumber = temporaryPhoneNumber + String(c)
                }
            }
        }
        return temporaryPhoneNumber
    }
    

}
