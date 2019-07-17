//
//  CustomerApproval.swift
//  BThere
//
//  Created by Eduard Stefanescu on 9/19/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
class CustomerApproval: NavigationModelViewController, UITableViewDelegate, UITableViewDataSource,reloadTableparentDelegate {
    // Outlets
    @IBOutlet weak var popOutView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var approvalsTable: UITableView!
    @IBOutlet weak var noRequestsView: UIView!
    @IBOutlet weak var noRequestsLabel: UILabel!
    @IBOutlet weak var popOutHeightConstraint: NSLayoutConstraint! // Default 450 else 212
    
    // Variables
    var OneUSER:User = User()
    var customersList:Array<String> = Array<String>()
    var MYCLIENTS: NSMutableArray =  NSMutableArray()
    var generic:Generic =  Generic()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:35)
        noRequestsView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //\\   GENERATECUSTOMERS()
        titleLabel.text = "CUSTOMER_APPROVAL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        noRequestsLabel.text = "CUSTOMER_APPROVAL_NO_REQUESTS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        
        getCustomers()
        // Set language

        
        // Hide the table, show the message
        
        
        
        approvalsTable.delegate = self
        approvalsTable.dataSource = self
        self.approvalsTable.separatorStyle = .none
        //        approvalsTable.separatorColor = UIColor.blackColor()
        approvalsTable.tableFooterView = UIView() //this hides possible empty cells bellow visible ones
        approvalsTable.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Close pop out
    @IBAction func closeButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Set no automatically
    @IBAction func noButton(_ sender: AnyObject) {
        noButton.setBackgroundImage(UIImage(named: "Cancel-select"), for: UIControl.State())
        yesButton.setBackgroundImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
    }
    
    
    // Set yes automatically
    @IBAction func yesButton(_ sender: AnyObject) {
        noButton.setBackgroundImage(UIImage(named: "Cancel_unSelected"), for: UIControl.State())
        yesButton.setBackgroundImage(UIImage(named: "OK-select"), for: UIControl.State())
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MYCLIENTS.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomerApprovedViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomerApprovedViewCell") as! CustomerApprovedViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.viewDelegate = self
        
        if (indexPath.row == 0) {
            let bounds = UIScreen.main.bounds
            let widthscreen = bounds.size.width
            let aline:UIView = UIView()
            aline.backgroundColor = UIColor.black
            aline.frame = CGRect(x: cell.contentView.layer.frame.origin.x, y: cell.contentView.frame.origin.y ,width: widthscreen, height: 1)
            cell.addSubview(aline)
            cell.bringSubviewToFront(aline)
        }
        
        // Confirm button
        cell.confirmButton.setTitle("CONFIRM_BTN_DEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        // Delete button
        cell.deleteButton.setTitle("DELETE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        cell.deleteButton.layer.borderWidth = 1
        cell.deleteButton.layer.borderColor = UIColor.black.cgColor
        cell.PrecompleteUser(MYCLIENTS.object(at: indexPath.row) as! NSDictionary)
        
        return cell
    }
    
    
    //based on api function MakeCustomerSupplierActiveByCustomerUserId
    func CONFIRM_OR_DELETE_APROVED_CUSTOMER(_ myCustomerUserId:Int, statusServer:Int) {
        if Reachability.isConnectedToNetwork() == false
        {
            
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
             self.generic.showNativeActivityIndicator(self)
            //this form JSON to send
            var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            var bIsAuthorizedFromSupplier:Bool = false
            if statusServer == 1 {
                bIsAuthorizedFromSupplier = true
            }
            var providerID:Int = 0
            if Global.sharedInstance.providerID == 0 {
                providerID = 0
                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                    providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                    
                }
            } else {
                providerID = Global.sharedInstance.providerID
            }
            dic["iProviderId"] = providerID as AnyObject
            dic["iStatus"] = statusServer as AnyObject //we just test no need to confirm
            dic["iCustomerUserId"] = myCustomerUserId as AnyObject
            dic["bIsAuthorizedFromSupplier"] = bIsAuthorizedFromSupplier as AnyObject
            api.sharedInstance.SetStatusForCustomerSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                print("e ok ? " + myInt.description)
                                if myInt > 0 {
                                    // if success and YESNO was 1  make toast -> CUSTOMER_APPROVAL_CONFIRM
                                    if statusServer == 1 {
                                        self.view.makeToast(message: "CUSTOMER_APPROVAL_CONFIRM".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                            self.hidetoast()
                                        })
                                    }
                                    if statusServer == 2 { //-> aici un mesaj cu REQ DELETED
                                        self.view.makeToast(message: "CUSTOMER_APPROVAL_DELETE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                            self.hidetoast()
                                        })
                                    }
                                }
                                else {
                                    self.view.makeToast(message: "ERROR_APPROVAL".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                        self.hidetoast()
                                    })
                                    
                                }
                            }
                        } else {
                            self.view.makeToast(message: "ERROR_APPROVAL".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.hidetoast()
                            })
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                    self.showAlertDelegateX("ERROR_ADD_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    //reload table on hide toast
    func hidetoast(){
        self.view.hideToastActivity()
        self.reloadTablePARENT()
    }
    
    
    func seeCustomerDetais(_ customerID:Int, _nvFullName:String, _nvPhone:String, _nvMail:String, _nvImage:String, _dBirthdate:String) {
        let detailsCustomerViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsCustomerViewController") as! DetailsCustomerViewController
        detailsCustomerViewController.isFromCustomerApproval = true
        detailsCustomerViewController.MYiCustomerUserId = customerID
        detailsCustomerViewController.customerFullName = _nvFullName
        detailsCustomerViewController.customerPhone = _nvPhone
        detailsCustomerViewController.customerEmail = _nvMail
        detailsCustomerViewController.customerImage = _nvImage
        detailsCustomerViewController.customerBirthday = _dBirthdate
        detailsCustomerViewController.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(detailsCustomerViewController, animated: true, completion: nil)
    }
    
    
    // GetCustomersBySupplierId
    func getCustomers() {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var providerID:Int = 0
        
        if (Global.sharedInstance.providerID == 0) {
            providerID = 0
            
            if (Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0) {
                providerID = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
            
        } else {
            providerID = Global.sharedInstance.providerID
        }
        
        dic["iSupplierId"] = providerID as AnyObject
        let TEMPARRAY:NSMutableArray = NSMutableArray()
        if (Reachability.isConnectedToNetwork() == false) {
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        } else {
            self.generic.showNativeActivityIndicator(self)
            self.MYCLIENTS = NSMutableArray()
            self.MYCLIENTS = []
            api.sharedInstance.GetCustomersBySupplierId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1 {
                            print("eroare la getCustomers \(RESPONSEOBJECT["Error"])")
                            
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 {
                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                        } else {
                            if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>> {
                                
                                let ARRAYDELUCRU : Array<Dictionary<String, AnyObject>> = (RESPONSEOBJECT["Result"] as! Array<Dictionary<String, AnyObject>>)
                                
                                for item in ARRAYDELUCRU {
                                    let d:NSDictionary = (item as NSDictionary) as NSDictionary
                                    let MYmutableDictionary:NSMutableDictionary = [:]
                                    
                                    // ID
                                    var STRiCustomerUserId:String = ""
                                    if let somethingelse2:Int =  d.object(forKey: "iCustomerUserId") as? Int {
                                        STRiCustomerUserId = String(somethingelse2)
                                    }
                                    
                                    print("STRiCustomerUserId \(STRiCustomerUserId)")
                                    
                                    // First name
                                    var STRinvFirstName:String = ""
                                    if let somethingelse3 =  d.object(forKey: "nvFirstName") as? String {
                                        STRinvFirstName = somethingelse3
                                    }
                                    
                                    // Last name
                                    var STRnvLastName:String = ""
                                    if let somethingelse4 =  d.object(forKey: "nvLastName") as? String {
                                        STRnvLastName = somethingelse4
                                    }
                                    
                                    // Full name
                                    let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
                                    var STRnvImage:String = ""
                                    if let somethingelse =  d.object(forKey: "nvImage") as? String {
                                        STRnvImage = somethingelse
                                    } else {
                                        STRnvImage = ""
                                    }
                                    
                                    var INTiCustomerUserId:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "iCustomerUserId") as? Int {
                                        INTiCustomerUserId = somethingelse
                                    }
                                    
                                    // Active
                                    //                            var isintbactive:Int = 0
                                    //                            if let somethingelse7 =  d.objectForKey("bActive") as? Int {
                                    //                                isintbactive = somethingelse7
                                    //                            }
                                    
                                    // Status
                                    var iStatus:Int = 0
                                    if let ciStatus =  d.object(forKey: "iStatus") as? Int {
                                        iStatus = ciStatus
                                    }
                                    
                                    // Nickname
                                    var nvNickName:String = ""
                                    if let cnvNickName = d.object(forKey: "nvNickName") as? String {
                                        nvNickName = cnvNickName
                                    }
                                    
                                    // Phone
                                    var nvPhone:String = ""
                                    if let dicPhone = d.object(forKey: "nvPhone") as? String {
                                        nvPhone = dicPhone
                                    }
                                    
                                    // Email
                                    var nvMail:String = ""
                                    if let dicMail = d.object(forKey: "nvMail") as? String {
                                        nvMail = dicMail
                                    }
                                    
                                    // Birthday
                                    var dBirthdate:String = ""
                                    if let dicBirthdate = d.object(forKey: "dBirthdate") as? String {
                                        dBirthdate = dicBirthdate
                                    }
                                    
                                    // Put together
                                    MYmutableDictionary["nvFullName"] = STRnvFullName
                                    MYmutableDictionary["nvImage"] = STRnvImage
                                    MYmutableDictionary["iCustomerUserId"] = INTiCustomerUserId
                                    MYmutableDictionary["iStatus"] = iStatus
                                    MYmutableDictionary["nvNickName"] = nvNickName
                                    MYmutableDictionary["nvPhone"] = nvPhone
                                    MYmutableDictionary["nvMail"] = nvMail
                                    MYmutableDictionary["dBirthdate"] = dBirthdate
                                    
                                    // Check status
                                    if (iStatus == 0 || iStatus == 4) {
                                        TEMPARRAY.add(MYmutableDictionary)
                                    }
                                }
                            }
                        }
                        self.processarray(TEMPARRAY)
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                  self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    //now filter array
    func processarray(_ myarray:NSMutableArray) {
        //filter TEMPARRAY
        if myarray.count > 0 {
            
            for item in myarray {
                var isintbactive:Int = 0
                let d:NSDictionary = (item as! NSDictionary) as NSDictionary
                if let somethingelse8 =  d.object(forKey: "iStatus") as? Int {
                    isintbactive = somethingelse8
                }
                if isintbactive == 0 || isintbactive == 4  { // in test
                    if !self.MYCLIENTS.contains(item) {
                        self.MYCLIENTS.add(item)
                    }
                }
            }
            if self.MYCLIENTS.count > 0 {
                noRequestsView.isHidden = true
            } else {
                noRequestsView.isHidden = false
            }
        }
        else {
            noRequestsView.isHidden = false
        }
        
        //reload table on main thread
        DispatchQueue.main.async(execute: { () -> Void in
            self.approvalsTable.reloadData()
        })
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  when user tap on table row
        
        //  print(MYCLIENTS[indexPath.row].getDic())
    }
    func reloadTablePARENT() {
        getCustomers()
    }
    func GENERATECUSTOMERS(){
        let testfinal:Array<String> =  randomNumbersStringwithLength(5,howmanyrepetitions: 50, type:0) //first name
        let testfinal2:Array<String> =  randomNumbersStringwithLength(6,howmanyrepetitions: 50, type:1) //last name
        let testfinal3:Array<String> = randomNumbersStringwithLength(5,howmanyrepetitions: 50, type:2) //phone
        let testfinal4:Array<String> = randomNumbersStringwithLength(20,howmanyrepetitions: 50, type:3) //email
        
        let mydate:Date = Date()
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                //  Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        for i in 0..<testfinal.count {
            OneUSER = User() //or the other way .mutableCopy() as! User
            var oneInt:Int = 0
            if i > 25 {
                oneInt = 1
            }
            OneUSER = User(
                _iUserId: 0,
                _nvUserName: (testfinal[i] as String + testfinal2[i] as String ) as String,
                _nvFirstName: testfinal[i]  as String,
                _nvLastName: testfinal2[i]  as String,
                //_nvSupplierNotes: self.txtViewComments.text,
                _dBirthdate: mydate,//txtDate,
                _nvMail: testfinal4[i] as String,
                //   _nvAdress: "",
                _iCityType: 1,
                _nvPhone: testfinal3[i] as String, // + (randomNumbersStringwithLength(8) as String) as String,
                _nvPassword: "",
                _nvVerification: "",
                _bAutomaticUpdateApproval: true,//אם סימן אני מאשר
                _bDataDownloadApproval: true,//?
                _bAdvertisingApproval: false,//אם סימן קראתי את התקנון
                _bTermOfUseApproval: true,//תמיד
                // _iUserStatusType: 24, //or 25
                _iUserStatusType : 25, //KEEP IN MIND 25 is for non active else 24 is allready active
                _bIsGoogleCalendarSync: true,
                _nvImage:"",
                //   _iCreatedByUserId: 1,//?
                _iCreatedByUserId : providerID,
                _iLastModifyUserId: 1,//?
                _iSysRowStatus: 1,//?
                _bIsManager: 0,
                _nvDeviceToken: "",
                _iStatus: oneInt,
                _nvNickName: ""
            )
            
            var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            var providerCustomersObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            
            providerCustomersObj["bIsVip"] = false as AnyObject
            providerCustomersObj["nvSupplierRemark"] = testfinal[i] as AnyObject
            
            dic["iSupplierId"] = providerID as AnyObject
            dic["bIsCreatedBySupplierId"] = false as AnyObject
            
            var dicobjUSER:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dicobjUSER = OneUSER.getDic()
            //(UserObj objUser, int iSupplierId)
            dic["objUser"] = dicobjUSER as AnyObject
            dic["providerCustomersObj"] = providerCustomersObj as AnyObject
            print("what to send \(dicobjUSER)")
            senddelay(dic)
        }
        
        
    }
    func GENERATEUSERS(){
        let testfinal:Array<String> =  randomNumbersStringwithLength(5,howmanyrepetitions: 250, type:0) //first name
        let testfinal2:Array<String> =  randomNumbersStringwithLength(6,howmanyrepetitions: 250, type:1) //last name
        let testfinal3:Array<String> = randomNumbersStringwithLength(8,howmanyrepetitions: 250, type:2) //phone
        let testfinal4:Array<String> = randomNumbersStringwithLength(20,howmanyrepetitions: 250, type:3) //email

        var arr = Array<String>()
        for i in 0..<testfinal.count {
            var MYUSER = User() //or the other way .mutableCopy() as! User
            MYUSER.nvFirstName = testfinal[i]
            MYUSER.nvLastName = testfinal2[i]
            MYUSER.nvPhone = testfinal3[i]
            MYUSER.iUserStatusType = 24
            MYUSER.iSysRowStatus = 1
            MYUSER.nvMail = testfinal4[i]
            var dicRegister:Dictionary<String,Dictionary<String,AnyObject>> = Dictionary<String,Dictionary<String,AnyObject>>()
            var dicDicRegister:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

            dicDicRegister = MYUSER.getDic()
            dicRegister["objUser"] = dicDicRegister
            api.sharedInstance.RegisterUser(dicRegister, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in

                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    print("RESPONSEOBJECT msg verification: \(String(describing: RESPONSEOBJECT["Result"]))")
                    arr.append(MYUSER.nvPhone)
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in

            })
        }
         print("arr \(arr)")


    }
    func senddelay(_ dic:Dictionary<String,AnyObject>) {
        print("\n********************************* add new customer  ********************\n")
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        
        
        if Reachability.isConnectedToNetwork() == false
        {
            
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.SupplierAddCustomer(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in      //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            //todo afisez eroare
                            print("eroare la add new \(RESPONSEOBJECT["Error"])")
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            //todo afisez eroare
                            print("eroare la add new \(RESPONSEOBJECT["Error"])")
                        }
                        else
                        {
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                print("e ok ? " + myInt.description)
                            }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                if AppDelegate.showAlertInAppDelegate == false
                {
                    self.showAlertDelegateX("ERROR_ADD_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    AppDelegate.showAlertInAppDelegate = true
                }
            })
        }
    }
    
    
    
}
func randomStringWithLength (_ len : Int) -> NSString {
    
    let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 0 ..< len {
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    return randomString
}

func randomNumbersStringwithLength (_ lenfornumber : Int, howmanyrepetitions: Int, type: Int ) -> Array<String> {
    var uniquevals: Array<String> =  Array<String>()
    var letters : NSString = ""
    switch (type) {
    case 0: //first name
        letters  = "ABCDEFGHIJK"
        repeat {
            let randomString : NSMutableString = NSMutableString(capacity: lenfornumber)
            
            for _ in 0 ..< lenfornumber {
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.character(at: Int(rand)))
                
            }
            if !uniquevals.contains(randomString as String) {
                uniquevals.append(randomString as String)
            }
            
        } while uniquevals.count <= howmanyrepetitions
    case 1: //last name
        letters  = "LMNOPQRSTUVWXYZ"
        repeat {
            let randomString : NSMutableString = NSMutableString(capacity: lenfornumber)
            
            for _ in 0 ..< lenfornumber {
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.character(at: Int(rand)))
                
            }
            if !uniquevals.contains(randomString as String) {
                uniquevals.append(randomString as String)
            }
            
        } while uniquevals.count <= howmanyrepetitions
    case 2: //phone number
        letters  = "0123456789"
        repeat {
            let randomString : NSMutableString = NSMutableString(capacity: lenfornumber)
            
            for _ in 0 ..< lenfornumber {
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.character(at: Int(rand)))
                
            }
            let prefix:String = "05"
            let randstr = prefix + (randomString as String)
            
            if !uniquevals.contains(randstr as String) {
                uniquevals.append(randstr as String)
            }
            
        } while uniquevals.count <= howmanyrepetitions
    case 3:  //email
        letters  = "abcdefghijklmnopqrstuvwxyz"
        
        repeat {
            let randomString : NSMutableString = NSMutableString(capacity: lenfornumber)
            
            for _ in 0 ..< lenfornumber {
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.character(at: Int(rand)))
                
            }
            let suffix:String = "@txztest.com"
            let randstr =  (randomString as String) + suffix
            
            
            if !uniquevals.contains(randstr as String) {
                uniquevals.append(randstr as String)
            }
            
        } while uniquevals.count <= howmanyrepetitions
    default:
        letters  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        repeat {
            let randomString : NSMutableString = NSMutableString(capacity: lenfornumber)
            
            for _ in 0 ..< lenfornumber {
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.character(at: Int(rand)))
                
            }
            if !uniquevals.contains(randomString as String) {
                uniquevals.append(randomString as String)
            }
            
        } while uniquevals.count <= howmanyrepetitions
    }
    
    
    return uniquevals
}

//for others who try to learn
//    Un Array simply este de forma:
//    Array = [obiect1, obiect2, obiect3] -> Array = [a,b,c] si tabelar ar insemina o coloana in xls
//    randul 1 ->  obiect1 = Array[0]
//    randul 2 -> obiect2  = Array[1]
//    randul 3 -> obiect23= Array[2]
//
//
//    O matrice extinsa , custom e de forma: Array = [ [ . ] ]
//    Array =[ [obiectcustom1, obiectcustom2] ,
//    [obiectcustom3, obiectcustom4]]
//
//    si tabelar ar insemna 2 coloane in xls
//    randul 1->  obiectcustom1 = Array[0][0] obiectcustom2 = Array[0][1]
//    random 2 -> obiectcustom3 = Array[1][0] obiectcustom4 = Array[1][1]

