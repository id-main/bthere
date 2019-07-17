//
//  MyEmployeTableViewCellFinal.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 29.03.2017
//  Copyright © 2017 Bthere. All rights reserved.
//

import UIKit

class MyEmployeTableViewCellFinal: UITableViewCell,UITableViewDataSource, UITableViewDelegate,  UITextFieldDelegate {
    var delegate:reloadALLDelegate!=nil
    @IBOutlet weak var Manager_permission: UILabel!
    @IBOutlet weak var Authorizations_by_service: UILabel!
    @IBOutlet weak var tblServices: UITableView!
    @IBOutlet weak var textservices: UITextField!
    @IBOutlet weak var img: UIView!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnshowtableservices: UIButton!
    @IBOutlet weak var saveemployeinfo: UIButton!
    @IBOutlet var lblWorkerName: UILabel!
    var isOpen:Bool = false
    var isOpenHours:Bool = false
    var row:Int = 0
    var isEdit:Int = 0
    @IBOutlet weak var btnCoverEdit: UIButton!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet var btnEdit: UIButton!
    var isOpenHoursForCell:Bool = false
    var PERMISSIONSArray:NSMutableArray = NSMutableArray()
    var ADDSERVArray:Array<Int> = []
    var DELSERVArray:Array<Int> = []
    var DELTOSERVER:Array<Int> = []
    var actualCHECKED:Array<String> = []
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var isManager:Bool = false
    var idEmploye:Int = 0
    var EMPLOYE:User = User()
    var arrayWorkers:NSMutableArray = NSMutableArray()
    var totalNumberManagers:Int = 0
    var employeCanBeUpgraded:Bool = false
    var generic:Generic = Generic()
    var myID:Int = 0
    @IBOutlet weak var btnVIPno: CheckBoxForExistEmployeCancel!
    @IBOutlet weak var btnVIPyes: CheckBoxForExistEmployeOk!
    
    @IBAction func btnVIPyes(_ sender: CheckBoxForExistEmployeOk) {
        btnVIPno.isCecked = false
        btnVIPyes.isCecked = true
         self.isManager = true
    }
    @IBAction func saveemployeinfo(_ sender: AnyObject) {
        
        tryGetSupplierCustomerUserIdByEmployeeId()
//


    }
    func firstAddServices(){
        for i in 0..<self.ADDSERVArray.count {
            let servid:Int = self.ADDSERVArray[i]
            self.AddServicePermissionForUser(self.idEmploye, iSupplierServiceId: servid)
        }
    }
    func thenDelServices(){
        for i in 0..<self.DELTOSERVER.count {
            let servid:Int = self.DELTOSERVER[i]
            self.DeleteServicePermissionByServicePermissionId(servid)
        }
    }
    func UpdateEmployeeIsManager( _ iUserId:Int,  bIsManager:Bool) {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        dic["iUserId"] = iUserId as AnyObject
        dic["bIsManager"] = bIsManager as AnyObject
        
        
        api.sharedInstance.UpdateEmployeeIsManager(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                print("UpdateEmployeeIsManager \(responseObject ?? 1 as AnyObject)")
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Result"] as? Int {
                
                let REZULTATE:Int = RESPONSEOBJECT["Result"] as! Int
                if REZULTATE == 0 || REZULTATE == 1 {
                      print("OK")
                    Alert.sharedInstance.showAlertDelegate("EMPLOYE_MANAGER_CHANGED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                } else {
                    Alert.sharedInstance.showAlertDelegate("ERROR_CHANGE_MANAGER_STATUS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
            }
            }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
        
    }

    @IBAction func btnVIPno(_ sender: CheckBoxForExistEmployeCancel) {
        btnVIPyes.isCecked = false
        btnVIPno.isCecked = true
        self.isManager = false
        print("btnvipno \(btnVIPno.isCecked)")
    }
    
    @IBOutlet weak var top: UIView!
    @IBOutlet weak var bottom: UIView!
    var isExpanded:Bool = false
        {
        didSet
        {
            if !isExpanded {
                self.imgHeightConstraint.constant = 0.0
                
            } else {
                self.imgHeightConstraint.constant = 400.0
            }
        }
    }
    
    override func awakeFromNib() {
        self.Manager_permission.text = "Manager_permission".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.Authorizations_by_service.text = "Authorizations_by_service".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.saveemployeinfo.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        self.textservices?.delegate = self
        super.awakeFromNib()
        self.ADDSERVArray = []
        self.DELSERVArray = []
        self.DELTOSERVER = []
        self.actualCHECKED = []
        self.selectionStyle = .none
//        btnVIPno.isCecked = true
//        btnVIPyes.isCecked = true
         self.tblServices.isHidden = true
//        calculateManagers()
       
        //        if let _:User = self.arrayWorkers[indexPath.row] as? User {
        //            let MYD:User = self.arrayWorkers[indexPath.row] as! User
        //            var STRinvFirstName:String = ""
        //            if let somethingelse3:String =  MYD.nvFirstName
        //            {
        //                STRinvFirstName = somethingelse3
        //            }
        //        }
        
        //        for (index, element) in self.arrayWorkers () {
        //            print("Item \(index): \(element)")
        //        }
        
        
       
//        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.expandorcollapse))
//        tap1.delegate = self
//        self.textservices.addGestureRecognizer(tap1)
    }
//    func expandorcollapse(){
//        print("tblServices.hidden ? \(tblServices.hidden)")
//       self.tblServices.hidden = !self.tblServices.hidden
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var MYINT:Int = 0
                MYINT = self.ProviderServicesArray.count
       
        return MYINT
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell: MyEmployeServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyEmployeServiceTableViewCell") as! MyEmployeServiceTableViewCell
     //   if tableView == self.tblServices {
        
            cell.contentView.backgroundColor = UIColor.black
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.tag = indexPath.row
            var index:Int = 0
            index = indexPath.row
              print("cell service.tag now \(cell.tag)")
            //   cell.delegate = self
            if let _:objProviderServices  = self.ProviderServicesArray[indexPath.row] {
                let MYD:objProviderServices  = self.ProviderServicesArray[indexPath.row]
              
                var STRinvFirstName:String = ""
                if let somethingelse3:String =  MYD.nvServiceName
                {
                    STRinvFirstName = somethingelse3
                }
                
                let STRnvFullName:String = STRinvFirstName
                
                  print("index name \(STRnvFullName) si \(index)")

                
              cell.setDisplayData(STRnvFullName,aPERMISSIONSArray: self.PERMISSIONSArray,myuser: self.EMPLOYE,myservice: MYD)

                
              
            }
        
            return cell
       

    }
    func setDisplayData(_ st:String, myd:User,servArray:Array<objProviderServices>,aPERMISSIONSArray:NSMutableArray){
        print(myd.bIsManager)
        self.EMPLOYE = myd
        self.ProviderServicesArray = servArray
        self.PERMISSIONSArray = aPERMISSIONSArray
        self.idEmploye = myd.iUserId
        lblWorkerName.text = st
        if myd.bIsManager == 0 {
            self.btnVIPno.isCecked = true
            self.btnVIPyes.isCecked = false
            self.isManager = false
        } else {
            self.btnVIPno.isCecked = false
            self.btnVIPyes.isCecked = true
            self.isManager = true
            
        }
       self.setuptextservices()



      
    }
    func setDataTable(_ arrayservices:Array<objProviderServices>) {
       self.ProviderServicesArray = arrayservices
     
    }
    @IBAction func btnEditWorker(_ sender: UIButton) {
        //        self.isEdit = 1
        //        delegate.reloadTableForEdit1(self.tag,my: self)
    }
    
    @IBAction func btntry(_ sender: UIButton) {
        //        self.isEdit = 1
        //        delegate.reloadTableForEdit1(self.tag,my: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               //\\print(indexPath.row)
                guard let cell = self.tblServices.cellForRow(at: indexPath) as? MyEmployeServiceTableViewCell
                    else { return }
         self.contentView.bringSubviewToFront(bottom)
        if   cell.btnAddservicePermission.isCecked == true {
            cell.btnAddservicePermission.isCecked = false
            let servicename:String = cell.lblServiceName.text!
            if self.actualCHECKED.contains(servicename) {
                let ox:Int = self.actualCHECKED.index(of: servicename)!
                self.actualCHECKED.remove(at: ox)
                }
        
        }else {
            cell.btnAddservicePermission.isCecked = true
            let servicename:String = cell.lblServiceName.text!
            if !self.actualCHECKED.contains(servicename) {
            self.actualCHECKED.append(servicename)
            }
                 }
          print("cell.userid and service \(cell.Usera.iUserId) \(cell.service.iProviderServiceId)")
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tblServices.beginUpdates()
            self.tblServices.endUpdates()
        })
        self.refreshtextservices()
        
    
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
//        guard let cell = self.tblServices.cellForRowAtIndexPath(indexPath) as? MyEmployeServiceTableViewCell
//            else { return }
//        
//        cell.isExpanded = false
//        
//        self.tblEmployes.beginUpdates()
//        self.tblEmployes.endUpdates()
        
        
        
    }
    func AddServicePermissionForUser(_ iUserId:Int,iSupplierServiceId:Int) {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        dic["iUserId"] = iUserId as AnyObject
        dic["iSupplierServiceId"] = iSupplierServiceId as AnyObject
        api.sharedInstance.AddServicePermissionForUser(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                
            if let _ = RESPONSEOBJECT["Result"] as? Int {
                let REZULTATE:Int = RESPONSEOBJECT["Result"] as! Int
                if REZULTATE > 0 {
                    //  self.DeleteServicePermissionByServicePermissionId(20)
                    if self.ADDSERVArray.contains(iSupplierServiceId) {
                        let ox:Int = self.ADDSERVArray.index(of: iSupplierServiceId)!
                        self.ADDSERVArray.remove(at: ox)
                    }
                    }
                }
            }
        }
            ,failure: {(AFHTTPRequestOperation, Error) -> Void in
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
        
    }
    func DeleteServicePermissionByServicePermissionId(_ iServicePermissionId:Int ) {
        ///iServicePermissionId
        var y:Int = 0
        var dicDelpermission:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        y = iServicePermissionId
        dicDelpermission["iServicePermissionId"] =  y as AnyObject
          print("\n********************************* DeleteServicePermissionForUser  ********************\n")
//        let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicDelpermission, options: NSJSONWritingOptions.PrettyPrinted)
//        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
//        print(jsonString)
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.DeleteServicePermissionByServicePermissionId(dicDelpermission, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                {
                      print("eroare la DeleteServicePermissionForUser \(String(describing: RESPONSEOBJECT["Error"]))")
                }
                else
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        
                          print("eroare la DeleteServicePermissionForUser \(String(describing: RESPONSEOBJECT["Error"]))")
                    }
                    else
                    {
                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                        {
                            let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                              print("raspuns la delete \(myInt)")
                            if myInt > 0 {
                                if self.DELTOSERVER.contains(myInt) {
                                    if self.DELTOSERVER.contains(iServicePermissionId) {
                                        let ox:Int = self.DELTOSERVER.index(of: iServicePermissionId)!
                                        self.DELTOSERVER.remove(at: ox)
                                    }
                                }
                                }
                            }
                        }
                    }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
            })
        }
        
    }
    func refreshtextservices() {
        var textforServices:String = ""
        if  self.actualCHECKED.count > 0 {
            textforServices =  self.actualCHECKED.joined(separator: ",")
            self.textservices?.text = textforServices
        } else {
             self.textservices?.text = "SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        
       
    }
    func setuptextservices(){
      self.actualCHECKED = []
      
            for i in 0..<self.PERMISSIONSArray.count {
                if let _:NSDictionary = self.PERMISSIONSArray[i] as? NSDictionary {
                    let MOD:NSDictionary = self.PERMISSIONSArray[i] as! NSDictionary
                        if let _:Int = MOD["iUserId"] as? Int {
                        let currentuserid:Int = MOD["iUserId"] as! Int
                          print("currentuserid \(currentuserid)")
                                                 if let _:Int = MOD["iSupplierServiceId"] as? Int {
                            let currentserviceID:Int = MOD["iSupplierServiceId"] as! Int
                              print("currentserviceID \(currentserviceID)")
                            for y in 0..<self.ProviderServicesArray.count {
                                let myservid:objProviderServices = self.ProviderServicesArray[y]
                                let oriceID:Int = myservid.iProviderServiceId
                                let stringnameID:String = myservid.nvServiceName
                                  print("myservid \(myservid.iProviderServiceId)")
                            if currentuserid == idEmploye && currentserviceID == oriceID {
                                if !self.actualCHECKED.contains(stringnameID) {
                                    self.actualCHECKED.append(stringnameID)
                                }
                            }
                        }
                    }
                }
            }
        }
        refreshtextservices()

    }

//    func tryGetSupplierCustomerUserIdByEmployeeId() {
//        var y:Int = 0
//        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
//            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
//            if let x:Int = a.value(forKey: "currentUserId") as? Int{
//                y = x
//            }
//        }
//        dicuser["iUserId"] =  y as AnyObject
//        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//            if let _ = responseObject as? Dictionary<String,AnyObject> {
//                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                if let _:Int = RESPONSEOBJECT["Result"] as? Int
//                {
//                    let myInt :Int = RESPONSEOBJECT["Result"] as! Int
//                    print("sup id e ok ? " + myInt.description)
//                    if myInt == 0 {
//                        //NO EMPL NO BUSINESS
//                        //   self.setupdefaults(0)
//                        //\\print ("no business")
//                    } else {
//                        //self.setupdefaults(myInt)
//                        self.GetSecondUserIdByFirstUserId(myInt)
//                    }
//                }
//            }
//        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
//        })
//    }
    

    func GetSecondUserIdByFirstUserId(_ employeID:Int)  {
        
        var y:Int = 0
        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        y = employeID
        dicEMPLOYE["iUserId"] =  y as AnyObject
//        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
//            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            api.sharedInstance.GetSecondUserIdByFirstUserId(dicEMPLOYE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
//                    self.generic.hideNativeActivityIndicator(self)
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            print("eroare la GetSecondUserIdByFirstUserId \(RESPONSEOBJECT["Error"] ?? -1 as AnyObject)")
                        }
                        else
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                
                                print("eroare la GetSecondUserIdByFirstUserId \(RESPONSEOBJECT["Error"] ?? -2 as AnyObject)")
                            }
                                
                            else
                            {
                                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                {
                                    self.myID = (RESPONSEOBJECT["Result"] as? Int)!
                                    print(" my SECOND USER ID \(self.myID)")
                                    print("his SECOND USER ID \(self.idEmploye)")
                                    
                                    if self.myID == self.idEmploye && self.btnVIPno.isCecked == true
                                    {
                                        Alert.sharedInstance.showAlertDelegate("AT_LEAST_ONE_MANAGER_NEEDED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    }
                                    
                                    else
                                    {
                                        self.UpdateEmployeeIsManager( self.idEmploye, bIsManager:self.isManager)
                                        for cell1 in self.tblServices.visibleCells {
                                            if let customCell:MyEmployeServiceTableViewCell =  cell1 as? MyEmployeServiceTableViewCell {
                                                if customCell.btnAddservicePermission.isCecked == false {
                                                    if !self.DELSERVArray.contains(customCell.service.iProviderServiceId) {
                                                        self.DELSERVArray.append(customCell.service.iProviderServiceId)
                                                    }
                                                    if self.ADDSERVArray.contains(customCell.service.iProviderServiceId) {
                                                        let ox:Int = self.ADDSERVArray.index(of: customCell.service.iProviderServiceId)!
                                                        self.ADDSERVArray.remove(at: ox)
                                                    }
                                                }
                                            }
                                        }
                                        for cell2 in self.tblServices.visibleCells {
                                            if let customCell2:MyEmployeServiceTableViewCell =  cell2 as? MyEmployeServiceTableViewCell {
                                                if customCell2.btnAddservicePermission.isCecked == true {
                                                    if !self.ADDSERVArray.contains(customCell2.service.iProviderServiceId) {
                                                        self.ADDSERVArray.append(customCell2.service.iProviderServiceId)
                                                    }
                                                    if self.DELSERVArray.contains(customCell2.service.iProviderServiceId) {
                                                        let ox:Int = self.DELSERVArray.index(of: customCell2.service.iProviderServiceId)!
                                                        self.DELSERVArray.remove(at: ox)
                                                    }

                                                }
                                            }
                                        }


                                        self.DELTOSERVER = []

                                        for y in 0..<self.DELSERVArray.count {
                                            let myservid:Int = self.DELSERVArray[y]
                                            print("myservid \(myservid)")
                                            print("idEmploye \(self.idEmploye)")
                                            for i in 0..<self.PERMISSIONSArray.count {
                                                if let _:NSDictionary = self.PERMISSIONSArray[i] as? NSDictionary {
                                                    let MOD:NSDictionary = self.PERMISSIONSArray[i] as! NSDictionary
                                                    if let _:Int = MOD["iUserId"] as? Int {
                                                        let currentuserid:Int = MOD["iUserId"] as! Int
                                                        print("currentuserid \(currentuserid)")
                                                        if let _:Int = MOD["iSupplierServiceId"] as? Int {
                                                            let currentserviceID:Int = MOD["iSupplierServiceId"] as! Int
                                                            print("currentserviceID \(currentserviceID)")
                                                            let currentpermissionID:Int = MOD["iServicePermissionId"] as! Int

                                                            if currentuserid == self.idEmploye && currentserviceID == myservid {
                                                                if !self.DELTOSERVER.contains(currentpermissionID) {
                                                                    self.DELTOSERVER.append(currentpermissionID)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        if self.ADDSERVArray.count > 0 {
                                            //  self.firstAddServices()
                                            for i in 0..<self.ADDSERVArray.count {
                                                let servid:Int = self.ADDSERVArray[i]
                                                self.AddServicePermissionForUser(self.idEmploye, iSupplierServiceId: servid)
                                            }
                                        }
                                        if self.DELTOSERVER.count > 0 {
                                            //   self.thenDelServices()
                                            for i in 0..<self.DELTOSERVER.count {
                                                let servid:Int = self.DELTOSERVER[i]
                                                self.DeleteServicePermissionByServicePermissionId(servid)
                                            }
                                        }
                                        self.delegate.reloadalldata()
                                        print ("succes update")

                                        print("ADDSERVArray \(self.ADDSERVArray)")
                                        print("DELSERVArray \(self.DELSERVArray)")
                                        print("DELTOSERVER \(self.DELTOSERVER)")
                                    }
                                    // do something
                                }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                
                
            })
        }
        
    }
    
    
    func tryGetSupplierCustomerUserIdByEmployeeId() {
        var y:Int = 0
        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        dicuser["iUserId"] =  y as AnyObject
//        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
//            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            
            api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
//                    self.generic.hideNativeActivityIndicator(self)
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _:Int = RESPONSEOBJECT["Result"] as? Int
                    {
                        let myInt :Int = RESPONSEOBJECT["Result"] as! Int
                        print("sup id e ok ? " + myInt.description)
                        if myInt == 0 {
                            //NO EMPL NO BUSINESS
                        } else {
                            self.GetSecondUserIdByFirstUserId(myInt)
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                
            })
        }
    }
    
    
    
    }



