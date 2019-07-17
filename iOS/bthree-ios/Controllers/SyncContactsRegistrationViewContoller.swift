//
//  SyncContactsRegistrationViewContoller.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 10.08.2017
//  Copyright © 2017 BThere. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Contacts
protocol hideChooseAllDelegateax {
    func hideChooseAll()
}
//דף 5 בהרשמה סנכרון עם אנשי קשר

class SyncContactsRegistrationViewContoller: NavigationModelViewController ,UITableViewDelegate,UITableViewDataSource,hideChooseAllDelegateax,UITextFieldDelegate {
    private var workItem: DispatchWorkItem?
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var isfromcustomer:Bool = false
    var phone:Array<String> = []
    var chunksarryarr:[[objSyncContact]] =  [[objSyncContact]]()
    var whatarraytosend:Int = 0 //contains index of array of 300 contacts to send
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
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var lblChooseCustomers: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblChooseAll: UILabel!
    @IBOutlet weak var titlescreen: UILabel!
    @IBOutlet weak var btnChooseAll: UIButton!
    @IBOutlet weak var viewchooseAll: UIView!
    
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
                NSPredicate(format: "nvContactName contains[c] %@",mysearchtxt)
            searchcontactList = contactList.filter { namePredicate.evaluate(with: $0) }
            if searchcontactList.count != contactList.count {
                self.btnChooseAll.isHidden = true
            }
            print("names = \(searchcontactList)")
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCONTACTS.reloadData()
            })
        } else {
            issearch = false
            searchcontactList =  contactList
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCONTACTS.reloadData()
            })
        }
    }
    func openEntrance() {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        vc.myformchangelanguage = true
        frontviewcontroller?.pushViewController(vc, animated: false)

        //initialize REAR View Controller- it is the LEFT hand menu.

        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()

        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController

        appDelegate.window!.rootViewController = mainRevealController
        appDelegate.window?.makeKeyAndVisible()

    }
    //iustin
//    func openSupplierCalendar()
//    {
//        Global.sharedInstance.isProvider = true
//        Global.sharedInstance.isFIRSTSUPPLIER = true
//        
//        ////////
//        let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
//
//        //                    let vc = supplierStoryBoard!.instantiateViewControllerWithIdentifier("CalendarSupplierViewController") as! CalendarSupplierViewController
//        //                    Global.sharedInstance.whichReveal = true
//        //                     Global.sharedInstance.isFromprintCalender = false
//        //                    frontviewcontroller?.pushViewController(vc, animated: false)
//
//        // initialize REAR View Controller- it is the LEFT hand menu.
//
//        let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//
//        let mainRevealController = SWRevealViewController()
//
//        mainRevealController.frontViewController = frontviewcontroller
//        mainRevealController.rearViewController = rearViewController
//        let CalendarSupplier: CalendarSupplierViewController = supplierStoryBoard!.instantiateViewController(withIdentifier: "CalendarSupplierViewController")as! CalendarSupplierViewController
//        let navigationController: UINavigationController = UINavigationController(rootViewController: CalendarSupplier)
//        mainRevealController.pushFrontViewController(navigationController, animated: false)
//        //                    mainRevealController.revealToggle(animated: true)
//        Global.sharedInstance.isFromprintCalender = false
//        let window :UIWindow = UIApplication.shared.keyWindow!
//        window.rootViewController = mainRevealController
//    }
    @IBAction func btnback(_ sender: UIButton) {
        if self.isfromcustomer == false {
            DispatchQueue.global().asyncAfter(deadline: .now()) {
                self.workItem?.cancel()
            }
            
            
         
        self.dismiss()
        } else {
        
            DispatchQueue.global().asyncAfter(deadline: .now()) {
                self.workItem?.cancel()
            }
         
        self.openEntrance()
        }
    }
    func importcontacts() {
        if Reachability.isConnectedToNetwork() == false
        {
            
            self.view.makeToast(message: "NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })
        }
        else {
            
            self.generic.showNativeActivityIndicatorInteractionEnabled(self)
            let objSyncContactsUsers:NSMutableArray = []
            let objSyncContactsUsers1:NSMutableArray = []
            let objSyncContactsUsers2:NSMutableArray = []
            let objSyncContactsUsers3:NSMutableArray = []
            var phones:Array<String> = []
            let dateString = "01/01/1901" // change to your date format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "dd/MM/yyyy"
            let birthday = dateFormatter.date(from: dateString)
            
            
            
            //SPECIAL USE WITH EXTREME CARE IF YOU WANT TO WORK ON LIVE !!! COMMENT ORIGINAL FROM BELLOW TILL   //END ORIGINAL
            let url = Bundle.main.url(forResource: "JHC", withExtension: "json")
            let data = try? Data(contentsOf: url!)
            do {
                let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let myaarr = object as? NSArray {
                    print("here is")
                    for i in 0..<myaarr.count {
                        let item = myaarr[i]
                        if let _:NSDictionary = item as?  NSDictionary {
                            let myitem = item as!  NSDictionary
                            //  print (item["nvFirstName"])
                            var nvfirstname = ""
                            var nvlastname = ""
                            var nvNickName:String = ""
                            if let testnvFirstName:String = myitem["nvFirstName"] as? String {
                                if testnvFirstName != ""  {
                                    nvfirstname = testnvFirstName
                                }
                            }
                            if let testnvlastname:String = myitem["nvlastname"] as? String {
                                if testnvlastname != ""  {
                                    nvlastname = testnvlastname
                                }
                            }
                            
                            nvNickName = nvfirstname + " " + nvlastname
                            var cleannumber:String = ""
                            if let _:String = myitem["nvPhone"] as? String {
                                let c:String = myitem["nvPhone"] as! String
                                
                                
                                if c != "" {
                                    cleannumber = cleanPhoneNumber(c)
                                    
                                }
                            }
                            
                            if cleannumber.count > 2 {
                                let numertocompare = cleannumber
                                let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                                let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                                if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                                    
                                    //ignore all bad numbers
                                }
                                else
                                {
                                    let  objSyncContactnew:objSyncContact =  objSyncContact(_nvFirstName: "",_bAutomaticUpdateApproval: false,_iLastModifyUserId: 0,_nvPassword: "",_nvUserName: "",_iCityType: 0,_nvVerification: "",
                                                                                            _bAdvertisingApproval: false,_iCreatedByUserId: 0,_bIsManager: 0,_dBirthdate: birthday!,_nvMail: "",_iUserStatusType: 26,_bIsGoogleCalendarSync: false,_bDataDownloadApproval: false,_nvLastName: "",_nvPhone: /* contact.nvPhone */ cleannumber,_iSysRowStatus: 1,_bTermOfUseApproval: false,_iUserId: 0,_allPHONES: [],_nvNickName: nvNickName)
                                    
                                    let dicobjUSER = objSyncContactnew.getDic()
                                    ///
                                    
                                    if i < 1000 {
                                        if !objSyncContactsUsers.contains(dicobjUSER) {
                                            objSyncContactsUsers.add(dicobjUSER)
                                        }
                                    } else if (i >= 1000 && i < 2000 ) {
                                        if !objSyncContactsUsers1.contains(dicobjUSER) {
                                            objSyncContactsUsers1.add(dicobjUSER)
                                        }
                                    } else if (i >= 2000 && i < 3000 ) {
                                        if !objSyncContactsUsers2.contains(dicobjUSER) {
                                            objSyncContactsUsers2.add(dicobjUSER)
                                        }
                                    } else  if i > 3000 {
                                        if !objSyncContactsUsers3.contains(dicobjUSER) {
                                            objSyncContactsUsers3.add(dicobjUSER)
                                        }
                                    }
                                    ////
                                    
                                }
                            }
                            
                            
                        }
                    }
                }
            } catch {
                // Handle Error
            }
            self.trysendingcontacts(objSyncContactsUsers)
            self.trysendingcontacts(objSyncContactsUsers1)
            self.trysendingcontacts(objSyncContactsUsers2)
            self.trysendingcontacts(objSyncContactsUsers3)
        }
        self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
    }
    
    
    
    
    //END SPECIAL
    func trysendingcontacts (_ objSyncContactsUsers:NSMutableArray) {
        var dicomposed:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //\\  dicomposed["UserObj"] = objSyncContactsUsers
        dicomposed["objSyncContactsUsers"] = objSyncContactsUsers
        
        
        //send empty nvphonelist other it wil crash
        //\\    dicomposed["nvPhoneList"] = phones
        dicomposed["nvPhoneList"] = [] as AnyObject
        dicomposed["iProviderId"] = self.supplierID as AnyObject
        //special case   dicomposed["iProviderId"] = 886
        let bAutoApproval = true
        dicomposed["bAutoApproval"] = bAutoApproval as AnyObject
        // dicbusiness["obj"] = dicomposed
        //\\   api.sharedInstance.UpdateSyncContacts(dicomposed, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
        api.sharedInstance.SyncContactsRegistration(dicomposed, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                    {
                        self.view.makeToast(message: "ERROR_UPDATE_CONTACTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                            self.hidetoast()
                        })
                    }
                    else
                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                        {
                            let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                            
                            if myInt == 1 {
                                //success
                                
                                self.view.makeToast(message: "UPDATED_SYNC_CONTACTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
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
            self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
            self.view.makeToast(message: "ERROR_UPDATE_BUSINESS_PROFILE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })
            
        })
        
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

                let estearr: Array<CustomerObj> =  Array<CustomerObj>()
                self.processMYARRAY(estearr)
            })
        }
        else {



            var dicomposed:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dicomposed["iProviderId"] = self.supplierID as AnyObject
            api.sharedInstance.GetProviderContact(dicomposed, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            let estearr: Array<CustomerObj> =  Array<CustomerObj>()
                            self.processMYARRAY(estearr)
                        }
                        else
                            if let arrDic:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                let estearr: Array<CustomerObj> = self.customerObjToArray(arrDic)
                                self.processMYARRAY(estearr)
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
                let estearr: Array<CustomerObj> =  Array<CustomerObj>()
                self.processMYARRAY(estearr)
            })

        }
      
    }
    func processMYARRAY (_ mycostomers:  Array<CustomerObj>) {
        var temporary:Array<Contact> = Array<Contact>()
        print("toti existenti \(mycostomers)")
        PRELOADEDcontactList = mycostomers
        

        for item in PRELOADEDcontactList {
            
            var cleannumber:String = ""
            if item.userObj.nvPhone != "" {
                
                cleannumber = cleanPhoneNumber(item.userObj.nvPhone)
                item.userObj.nvPhone = cleannumber
            }
            let c:Contact = Contact(_iUserId: item.userObj.iUserId, _iUserStatusType: item.userObj.iUserStatusType, _nvContactName: item.userObj.nvFirstName + " " + item.userObj.nvLastName , _nvPhone: /* item.userObj.nvPhone */ cleannumber, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: true, _nvFirstName: item.userObj.nvFirstName, _nvLastName: item.userObj.nvLastName, _allPHONES:item.userObj.allPHONES,_nvNickName: "")
            if !temporary.contains(c) {
                if c.nvContactName != "" {
                 temporary.append(c)
               }
            }
            
        }
    
        if temporary.count == 0 {
            temporary = Global.sharedInstance.contactList
            for item in temporary {
                item.bIsSync = false
            }
        }
            
        else {
            var keysuniquevalues:Array<String> = Array<String>()
            
                         for itemx in temporary {
                            keysuniquevalues.append(itemx.nvPhone)
                        }
                         var set = Set(keysuniquevalues)
            var scontactList:Array<Contact> = Array<Contact>()
            for item in Global.sharedInstance.contactList {
                let c:String = item.nvPhone
                if set.contains(c) {
              //    break
                    
                } else {
                 scontactList.append(item)
                }
            }
            print(scontactList.count)
            
            Global.sharedInstance.contactList = scontactList
            for item in scontactList {

                                    item.bIsSync = false
                                    temporary.append(item)
            
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
        
      
        
        print("cate sunt \(temporary.count)")
        
        var finalefiltered:Array<Contact> = Array<Contact>()
        for item in temporary {
            print("ce nume ?\(item.nvContactName )")
            if  item.nvContactName.count > 1  {
            //    print("item.nvContactName \(item.nvContactName.characters.count) si bsync check \(PREETYJSON_JMOD(item.getContactDic()))")
                if !finalefiltered.contains(item) {
                    finalefiltered.append(item)
                }
            }
        }
        print("cate sunt finalefiltered \(finalefiltered.count)")
        let sortedByFirstNameSwifty = finalefiltered.sorted(by: { $0.nvLastName < $1.nvLastName })
        contactList = sortedByFirstNameSwifty
        searchcontactList = Array<Contact>()
        searchcontactList =  contactList
        btnChooseAll.isHidden = false
        
        for contact in contactList
        {
            print("contact gasit \(contact.nvContactName)")
            if contact.bIsSync == false {
                btnChooseAll.isHidden = true
                break
            }
            //   contact.bIsSync = false
        }
        
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
    @IBAction func btnsave(_ sender: UIButton) {
        var phones:Array<String> = []
        let dateString = "01/01/1901" // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        let birthday = dateFormatter.date(from: dateString)
        
        for contact in contactList {
            if contact.bIsSync == true
            {
                phones.append(contact.nvPhone)
            }
        }
        var swiftarr:Array<objSyncContact> = Array<objSyncContact>()
        for contact in contactList {
            if contact.bIsSync == true
            {
                var nvfirstname = ""
                var nvlastname = ""
                var nvNickName:String = ""
                if contact.nvFirstName != ""  {
                    nvfirstname = contact.nvFirstName
                }
                if contact.nvLastName != ""  {
                    nvlastname = contact.nvLastName
                }
                nvNickName = nvfirstname + " " + nvlastname
                let c:String = contact.nvPhone
                var cleannumber:String = ""
                
                if c != "" {
                    cleannumber = cleanPhoneNumber(c)
                    
                }
                if cleannumber.count > 2 {
                    let numertocompare = cleannumber
                    let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                    let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                    if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                        //ignore all bad number
                    }
                    else
                    {
                        if nvNickName.count > 0 {
                        let  objSyncContactnew:objSyncContact =  objSyncContact(_nvFirstName: "", _bAutomaticUpdateApproval: false, _iLastModifyUserId: 0, _nvPassword: "", _nvUserName: "", _iCityType: 0, _nvVerification: "", _bAdvertisingApproval: false, _iCreatedByUserId: 0, _bIsManager: 0, _dBirthdate: birthday!, _nvMail: "", _iUserStatusType: 26, _bIsGoogleCalendarSync: false, _bDataDownloadApproval: false, _nvLastName: "", _nvPhone: /* contact.nvPhone */ cleannumber, _iSysRowStatus: 1, _bTermOfUseApproval: false, _iUserId: 0, _allPHONES: [], _nvNickName: nvNickName)
                        if !swiftarr.contains(objSyncContactnew) {
                            swiftarr.append(objSyncContactnew)
                        }
                        
                    }
                    }
                }
            }
        }
        if self.isfromcustomer {
            if swiftarr.count >= 4 {
        }
            else {
              self.opensyncontactspopup()
                return
            }
        }
        if swiftarr.count == 0 {
           
            self.dismiss()
         
        } else
        if swiftarr.count > 100 {
            let chunkSize = 100
            let chunks = stride(from: 0, to: swiftarr.count, by: chunkSize).map {
                Array(swiftarr[$0..<min($0 + chunkSize, swiftarr.count)])
            }
            print("chunks \(chunks)")
            howmanyarraystosend = chunks.count
            self.chunksarryarr = chunks
            self.alldatasend()
        }
        else {
            howmanyarraystosend = 1
            sendContacts(listof300: swiftarr)
        }
        
    }
    func alldatasend() {
        let whatgroup = self.whatarraytosend
        let arr = self.chunksarryarr
        if let _ = arr[whatgroup] as [objSyncContact]? {
        let listof300 = arr[whatgroup]
         sendContacts(listof300: listof300)
        }
 
    }
    func sendContacts(listof300:Array<objSyncContact>){
        
        var dicomposed:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        let emptyarr:Array = [] as Array
        let bAutoApproval = true
        var asend:NSMutableArray = NSMutableArray()
        asend = []
        for item in listof300 {
            let objtoadd = item.getDic()
            if !asend.contains(objtoadd) {
                asend.add(objtoadd)
            }
        }
        self.generic.showNativeActivityIndicatorInteractionEnabled(self)
        howmanyarraystosend = howmanyarraystosend - 1
        self.whatarraytosend = self.whatarraytosend + 1
        
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
           
            dicomposed["objSyncContactsUsers"] = asend as AnyObject
            dicomposed["iProviderId"] = self.supplierID as AnyObject
            dicomposed["bAutoApproval"] = bAutoApproval as AnyObject
            dicomposed["nvPhoneList"] = emptyarr as AnyObject
            api.sharedInstance.SyncContactsRegistration(dicomposed, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                                self.alldatasend()
                            }
                        }
                        else
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                
                                if myInt == 1 {
                                    if self.howmanyarraystosend == 0 {
                                        self.view.makeToast(message: "UPDATED_SYNC_CONTACTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(4.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                            self.hidetoast()
                                            if self.isfromcustomer == false {
                                                self.dismiss()
                                            } else {
                                                //iustin
                                                Global.sharedInstance.isFIRSTSUPPLIER = true
                                                self.openEntrance()
                                            }
                                            
                                            
                                        })

                                    } else {
                                        self.alldatasend()
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
                    self.alldatasend()
                }
                
            })
        }
    }

    func testARR() {
        let url = Bundle.main.url(forResource: "JHC", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        do {
            let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let myaarr = object as? NSArray {
                print("here is")
                for item in myaarr {
                    if let _:NSDictionary = item as?  NSDictionary {
                        let myitem = item as!   NSDictionary
                        print (myitem["nvFirstName"])
                    }
                }
            }
        } catch {
            // Handle Error
        }
    }
    
    
    
    func setContacts() {
        
        Global.sharedInstance.contactList = []
        let store = CNContactStore()
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
            var rootViewController = UIApplication.shared.keyWindow?.rootViewController
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.first
            }
            if let tabBarController = rootViewController as? UITabBarController {
                rootViewController = tabBarController.selectedViewController
            }
            rootViewController?.present(alert, animated: true, completion: nil)
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
                phone = []
                let contactPerson: CNContact = record
                var givenName = ""
                var familyName = ""
                var numecompus = ""
                var MobNumVar = ""
                
                givenName = contactPerson.givenName;
                familyName = contactPerson.familyName;
                numecompus = givenName + " " + familyName
                if numecompus.count > 0 {
                if contactPerson.phoneNumbers.count > 0 {
                    //person has 1 or more numbers
                    for i in 0..<contactPerson.phoneNumbers.count {
                        MobNumVar = (contactPerson.phoneNumbers[i].value ).value(forKey: "digits") as! String
                        let cleaned =  cleanPhoneNumber(MobNumVar)
//                        if cleaned.characters.count > 2 {
//                            let numertocompare = cleaned
//                            let index0 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 0)
//                            let index1 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 1)
//                            if numertocompare.characters.count != 10 || (numertocompare.characters[index0] != "0" || numertocompare.characters[index1] != "5") {
                        if cleaned.count > 2 {
                            let numertocompare = cleaned
                            let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                            let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                            if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                                //ignore all bad numbers
                                // print("bad number? \(numertocompare)")
                            } else {
                                //all this person numbers go to _allPHONES:phone array see below
                                    phone.append(cleaned)
                            }
                        }
                    }
//                    if phone.count > 0 {
//                        indexForUserid = indexForUserid + 1
//                        let firstvalidphone = phone[0] // only first valid number found is added to _nvPhone
//                        let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:phone,_nvNickName:numecompus)
//
//                        Global.sharedInstance.contactList.append(c)
//
//                    }
                    //JMODE CHANGED ON 28.01.2019
                    if phone.count > 0 {
                        for i in 0..<phone.count { //JMODE+ 28.01.2019
                            indexForUserid = indexForUserid + 1
                            let firstvalidphone = phone[i] // JMODE phone[0]old code only first valid number found is added to _nvPhone
                            let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:phone,_nvNickName:numecompus)
                            Global.sharedInstance.contactList.append(c)
                        }
                    }
                }
                }
            }
            var myafterset =   Global.sharedInstance.contactList.uniquevals
            Global.sharedInstance.contactList = myafterset
            //   let descriptor: NSSortDescriptor = NSSortDescriptor(key: "nvLastName", ascending: true)
            let sortedByFirstNameSwifty =  Global.sharedInstance.contactList.sorted(by: { $0.nvLastName < $1.nvLastName })
            Global.sharedInstance.contactList = sortedByFirstNameSwifty

            print("ce are aici iar \(Global.sharedInstance.contactList )")
            DispatchQueue.main.async {
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
                 self.GetProviderContact()
            }
        ////    END PARSING ////
            
        case .notDetermined:
            DispatchQueue.main.async {
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
            }
            print("requesting access...")
            store.requestAccess(for: .contacts){succeeded, err in
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
                var rootViewController = UIApplication.shared.keyWindow?.rootViewController
                if let navigationController = rootViewController as? UINavigationController {
                    rootViewController = navigationController.viewControllers.first
                }
                if let tabBarController = rootViewController as? UITabBarController {
                    rootViewController = tabBarController.selectedViewController
                }
                rootViewController?.present(alert, animated: true, completion: nil)
                
            }
        default:
            print("Not handled")
        }
        
       
    }
    
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
        
        
     
     
  
        btnsave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
       
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
        if self.isfromcustomer == true {
        titlescreen.text =  "INVITE_CUSTOMERS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        } else {
             titlescreen.text =  "INVITE_CUSTOMERS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            
        }
        //  supplierID = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
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
        
        
        txtSearchCustomer.delegate = self
        txtSearchCustomer.text = "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            
        } else {
            txtSearchCustomer.textAlignment = .left
        }
        lblChooseAll.text = "SELECT_ALL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblChooseCustomers.text = "CHOOSE_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblChooseCustomers.numberOfLines = 1
        lblChooseCustomers.sizeToFit()
        
        
        tblCONTACTS.separatorStyle = .none
        
        
        let tapViewAll:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseAll))
        
        viewchooseAll.addGestureRecognizer(tapViewAll)
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //check if popup with description for what this screen is needed was presented
        if  Global.sharedInstance.defaults.object(forKey: "PRESENTEDSYNCONTACTSPOPUPEXPLAIN") == nil {
             Global.sharedInstance.defaults.set(0, forKey: "PRESENTEDSYNCONTACTSPOPUPEXPLAIN")
            Global.sharedInstance.defaults.synchronize()
        }
        if  Global.sharedInstance.defaults.integer(forKey: "PRESENTEDSYNCONTACTSPOPUPEXPLAIN") == 0 {
            Global.sharedInstance.defaults.set(1, forKey: "PRESENTEDSYNCONTACTSPOPUPEXPLAIN")
            Global.sharedInstance.defaults.synchronize()
            let viewCon:PopSyncContactViewController = storyboard.instantiateViewController(withIdentifier: "PopSyncContactViewController") as! PopSyncContactViewController
          //  viewCon.isfromsettings = true
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            //viewCon.delegate = Global.sharedInstance.rgisterModelViewController
            self.present(viewCon, animated: true, completion: nil)
          
        }
         workItem = DispatchWorkItem {
            Global.sharedInstance.contactList = []
            let store = CNContactStore()
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
                var rootViewController = UIApplication.shared.keyWindow?.rootViewController
                if let navigationController = rootViewController as? UINavigationController {
                    rootViewController = navigationController.viewControllers.first
                }
                if let tabBarController = rootViewController as? UITabBarController {
                    rootViewController = tabBarController.selectedViewController
                }
                rootViewController?.present(alert, animated: true, completion: nil)
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
                    var numecompus = ""
                    var MobNumVar = ""
                    
                    givenName = contactPerson.givenName;
                    familyName = contactPerson.familyName;
                    numecompus = givenName + " " + familyName
                    if numecompus.count > 0 {
                    if contactPerson.phoneNumbers.count > 0 {
                        //person has 1 or more numbers
                        for i in 0..<contactPerson.phoneNumbers.count {
                            MobNumVar = (contactPerson.phoneNumbers[i].value ).value(forKey: "digits") as! String
                            let cleaned = self.cleanPhoneNumber(MobNumVar)
                            //                        if cleaned.characters.count > 2 {
                            //                            let numertocompare = cleaned
                            //                            let index0 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 0)
                            //                            let index1 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 1)
                            //                            if numertocompare.characters.count != 10 || (numertocompare.characters[index0] != "0" || numertocompare.characters[index1] != "5") {
                            if cleaned.count > 2 {
                                let numertocompare = cleaned
                                let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                                let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                                if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                                    //ignore all bad numbers
                                    // print("bad number? \(numertocompare)")
                                } else {
                                    //all this person numbers go to _allPHONES:phone array see below
                                    self.phone.append(cleaned)
                                }
                            }
                        }
//                        if self.phone.count > 0 {
//                            indexForUserid = indexForUserid + 1
//                            let firstvalidphone = self.phone[0] // only first valid number found is added to _nvPhone
//                            let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:self.phone,_nvNickName:numecompus)
//
//                            Global.sharedInstance.contactList.append(c)
//
//                        }
                        if self.phone.count > 0 {
                            for i in 0..<self.phone.count { //JMODE+ 28.01.2019
                                indexForUserid = indexForUserid + 1
                                let firstvalidphone = self.phone[i] // JMODE phone[0]old code only first valid number found is added to _nvPhone
                                let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:self.phone,_nvNickName:numecompus)
                                Global.sharedInstance.contactList.append(c)
                            }
                        }
                    }
                    }
                }
                var myafterset =   Global.sharedInstance.contactList.uniquevals
                Global.sharedInstance.contactList = myafterset
                //   let descriptor: NSSortDescriptor = NSSortDescriptor(key: "nvLastName", ascending: true)
                let sortedByFirstNameSwifty =  Global.sharedInstance.contactList.sorted(by: { $0.nvLastName < $1.nvLastName })
                Global.sharedInstance.contactList = sortedByFirstNameSwifty
                
                print("ce are aici iar \(Global.sharedInstance.contactList )")
                DispatchQueue.main.async {
                    self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
                    self.GetProviderContact()
                }
                ////    END PARSING ////
                
            case .notDetermined:
                DispatchQueue.main.async {
                    self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
                }
                print("requesting access...")
                store.requestAccess(for: .contacts){succeeded, err in
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
                    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
                    if let navigationController = rootViewController as? UINavigationController {
                        rootViewController = navigationController.viewControllers.first
                    }
                    if let tabBarController = rootViewController as? UITabBarController {
                        rootViewController = tabBarController.selectedViewController
                    }
                    rootViewController?.present(alert, animated: true, completion: nil)
                    
                }
            default:
                print("Not handled")
            }
            
            
        }
       DispatchQueue.global().async(execute: workItem!)
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
      
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblChooseCustomers.font = UIFont(name: "OpenSansHebrew-Regular", size: 12.5)
            lblChooseAll.font = UIFont(name: "OpenSansHebrew-Regular", size: 12.5)
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
        cell.delegate = self
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
         //   print("nume :\(contactcheck.nvLastName) prenume : \(contactcheck.nvFirstName)nickname  \(contactcheck.nvNickName))")
            for item in PRELOADEDcontactList {
                let phonepreloaded = item.userObj.nvPhone
                if phonecheck == phonepreloaded {
                    phoneexists = true
                    self.view.makeToast(message: "MANAGE_CUSTOMER_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                    })
                    break
                }
            }
            
            if (tableView.cellForRow(at: indexPath)as!SyncContactsRegistrationTableViewCell).btnISsync.isHidden == true//כדי להדליק איש קשר
            {
                if phoneexists == false {
                    (tableView.cellForRow(at: indexPath)as!SyncContactsRegistrationTableViewCell).btnISsync.isHidden = false
                    contactList[indexPath.row].bIsSync = true
                    
                    var isChooseAll = true
                    
                    //בדיקה האם להדליק את הכפתור- בחר הכל, אם בחרתי את כולם
                    
                    for Item in contactList
                    {
                        if Item.bIsSync == false
                        {
                            isChooseAll = false
                            break
                        }
                    }
                    if isChooseAll == true
                    {
                        btnChooseAll.isHidden = false
                    }
                    
                }
            }
            else//כדי לכבות איש קשר
            {
                if phoneexists == false {
                    (tableView.cellForRow(at: indexPath)as!SyncContactsRegistrationTableViewCell).btnISsync.isHidden = true
                    
                    contactList[indexPath.row].bIsSync = false
                    btnChooseAll.isHidden = true
                }
                searchcontactList = contactList
            }
        }
        
        if issearch == true {
            var phoneexists:Bool = false
            let contactcheck =  searchcontactList[indexPath.row]
            let phonecheck = contactcheck.nvPhone
            for item in PRELOADEDcontactList {
                let phonepreloaded = item.userObj.nvPhone
                if phonecheck == phonepreloaded {
                    phoneexists = true
                    self.view.makeToast(message: "MANAGE_CUSTOMER_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                    })
                    break
                }
            }
            
            if (tableView.cellForRow(at: indexPath)as!SyncContactsRegistrationTableViewCell).btnISsync.isHidden == true//כדי להדליק איש קשר
            {
                if phoneexists == false {
                    (tableView.cellForRow(at: indexPath)as!SyncContactsRegistrationTableViewCell).btnISsync.isHidden = false
                    searchcontactList[indexPath.row].bIsSync = true
                    
                    var isChooseAll = true
                    //בדיקה האם להדליק את הכפתור- בחר הכל, אם בחרתי את כולם
                    for Item in searchcontactList
                    {
                        if Item.bIsSync == false
                        {
                            isChooseAll = false
                            break
                        }
                    }
                    if searchcontactList.count != contactList.count {
                         isChooseAll = false
                    }
                    if isChooseAll == true
                    {
                        btnChooseAll.isHidden = false
                    }
                    
                }
            }
            else//כדי לכבות איש קשר
            {
                (tableView.cellForRow(at: indexPath)as!SyncContactsRegistrationTableViewCell).btnISsync.isHidden = true
                if phoneexists == false {
                    searchcontactList[indexPath.row].bIsSync = false
                    btnChooseAll.isHidden = true
                }
                
                let indexOfA:Int = contactList.index(of: searchcontactList[indexPath.row])!
                print("indexOfA \(indexOfA)")
                contactList[indexOfA].bIsSync = searchcontactList[indexPath.row].bIsSync
            }
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
    
    @objc func chooseAll()
    {
        if issearch == false {
            
            if btnChooseAll.isHidden == true
            {
                btnChooseAll.isHidden = false
                for contact in contactList
                {
                    contact.bIsSync = true
                }
            }
            else
            {
                btnChooseAll.isHidden = true
                for contact in contactList
                {
                    contact.bIsSync = false
                }
            }
            tblCONTACTS.reloadData()
        } else {
            if btnChooseAll.isHidden == true
            {
                btnChooseAll.isHidden = false
                for contact in searchcontactList
                {
                    contact.bIsSync = true
                }
            }
            else
            {
                btnChooseAll.isHidden = true
                for contact in searchcontactList
                {
                    contact.bIsSync = false
                }
            }
            tblCONTACTS.reloadData()
        }
    }
    
    
    
    //פונקציה המופעלת בעת לחיצה על כפתור של איש קשר כדי לכבותו,
    //הפונקציה מכבה את הכפתור ״בחר הכל״
    func hideChooseAll()
    {
        btnChooseAll.isHidden = true
    }
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
                let z:Contact = searchcontactList[i]
                
                if let _:Int = contactList.index(of: z) {
                    let indexOfA:Int = contactList.index(of: z)!
                    print("indexOfA \(indexOfA)")
                    contactList[indexOfA].bIsSync = z.bIsSync
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
            for char in (modedphone)
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

