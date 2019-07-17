//
//  EmployePermissionViewController.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 29.03.2017
//  Copyright © 2017 Bthere. All rights reserved.
//
import UIKit
protocol reloadALLDelegate {
    func reloadalldata()
}
class EmployePermissionViewController: NavigationModelViewController,UIGestureRecognizerDelegate, UITextFieldDelegate,reloadALLDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var contentView: UIView!
    var intSuppliersecondID:Int = 0
    var expandedRows = Set<Int>()
    var arrayWorkers:  NSMutableArray = []
    var generic:Generic = Generic()
    var myArray : NSMutableArray = [] //employe array
    var issearch:Bool = false
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    @IBOutlet weak var tblEmployes: UITableView!
    @IBOutlet weak var backImg: UIImageView!
    
    
    var PERMISSIONSArray : NSMutableArray = [] //services with workers and permissions array
    var ARIEFINALA: NSMutableArray = []
    @IBOutlet weak var titleofScreen: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func btnClose(_ sender: AnyObject)
    {
//        self.dismiss(animated: true, completion: nil)
//        self.removeFromParentViewController()
//        yourViewController.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:53)  
        arrayWorkers = []
        //1. // 2. get uspplier id and second id
        tryGetSupplierCustomerUserIdByEmployeeId()
        
        //  self.AddServicePermissionForUser(1,iSupplierServiceId: 1)
        // 3. get list of all services for supplier
        
        
        //4. get workers
        
        //5. get permissions
        ///   self.GetServicesPermissionForUsersBySupplier()
        //6. add permission
        // self.AddServicePermissionForUser(235,iSupplierServiceId: 1)
        //7. delete permission
        // DeleteServicePermissionByServicePermissionId(int iServicePermissionId)
        super.viewWillAppear(animated)
        self.myArray = []
        //  self.view.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        // self.view.addBackground()
        // self.contentView.addBackground()
        self.titleofScreen.text = "EMPLOYE_PERMISSIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
//        let leftarrowback = UIImage(named: "sageata2.png")
//        self.btnClose.setImage(leftarrowback, for: UIControlState())
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            btnClose.transform = scalingTransform
            self.backImg.transform = scalingTransform
        }
        //  }
//        self.btnClose.imageView!.contentMode = .scaleAspectFit
        //\\self.tblEmployes.rowHeight = UITableViewAutomaticDimension
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // self.contentView.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        
        self.tblEmployes.rowHeight = UITableView.automaticDimension
//        let leftarrowback = UIImage(named: "sageata2.png")
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
//        self.btnClose.setImage(leftarrowback, for: UIControlState())
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            btnClose.transform = scalingTransform
            self.backImg.transform = scalingTransform
        }
//        self.btnClose.imageView!.contentMode = .scaleAspectFit
        print("self.arrayWorkers.count \(self.arrayWorkers.count)")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    //    func reloadTableForEdit1(tag:Int,my:MyEmployeTableViewCell)
    //    {
    //    print("x")
    //    }
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return  44
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var MYINT:Int = 0
        if tableView == self.tblEmployes {
            MYINT =  self.arrayWorkers.count
        }
        //        if tableView == self.tblServices {
        //             MYINT = self.ProviderServicesArray.count
        //        }
        return MYINT
    }
    @objc func expandorcollapse(_ sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        let indexPath = IndexPath(row: tag, section: 0)
        //\\print(indexPath.row)
        guard let cell = self.tblEmployes.cellForRow(at: indexPath) as? MyEmployeTableViewCellFinal
            else { return }
        cell.tblServices.isHidden = !cell.tblServices.isHidden
        
        //        self.tblEmployes.beginUpdates()
        //        self.tblEmployes.endUpdates()
    }
    
    @objc func showContent(_ sender: UITapGestureRecognizer) {
        //
        //        guard let cell = self.tblEmployes.cellForRowAtIndexPath(indexPath) as? MyEmployeTableViewCellFinal
        //            else { return }
        //
        //        self.expandedRows.remove(indexPath.row)
        //
        //        cell.isExpanded = false
        //        cell.tblServices.hidden = true
        //        self.tblEmployes.beginUpdates()
        //        self.tblEmployes.endUpdates()
        //
        
        let tag = sender.view!.tag
        let indexPath = IndexPath(row: tag, section: 0)
        //\\print(indexPath.row)
        guard let cell = self.tblEmployes.cellForRow(at: indexPath) as? MyEmployeTableViewCellFinal
            else { return }
        switch cell.isExpanded
        {
        case true:
            self.expandedRows.remove(indexPath.row)
            for cell1 in self.tblEmployes.visibleCells {
                if let customCell:MyEmployeTableViewCellFinal =  cell1 as? MyEmployeTableViewCellFinal {
                    
                    if customCell.isExpanded {
                        self.expandedRows.remove(customCell.tag)
                        customCell.isExpanded = false
                        customCell.tblServices.isHidden = true
                        self.tblEmployes.beginUpdates()
                        self.tblEmployes.endUpdates()
                        
                    }
                }
                // }
            }
            
        case false:
            for cell1 in self.tblEmployes.visibleCells {
                if let customCell:MyEmployeTableViewCellFinal =  cell1 as? MyEmployeTableViewCellFinal {
                    //  if customCell.tag != tag {
                    if customCell.isExpanded {
                        self.expandedRows.remove(customCell.tag)
                        customCell.isExpanded = false
                        customCell.tblServices.isHidden = true
                        self.tblEmployes.beginUpdates()
                        self.tblEmployes.endUpdates()
                        
                    }
                }
                // }
            }
            
            self.expandedRows.insert(indexPath.row)
        }
        
        
        cell.isExpanded = !cell.isExpanded
        DispatchQueue.main.async(execute: { () -> Void in
            //        self.tblEmployes.beginUpdates()
            //        self.tblEmployes.endUpdates()
            self.tblEmployes.reloadData()
            cell.tblServices.reloadData()
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //            let position :CGPoint = touch.locationInView(self.tblEmployes)
            //\\print(position.x)
            //\\print(position.y)
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MyEmployeTableViewCellFinal = tableView.dequeueReusableCell(withIdentifier: "MyEmployeTableViewCellFinal") as! MyEmployeTableViewCellFinal
        cell.contentView.backgroundColor = UIColor.black
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        if cell.isExpanded == true {
            
        }
        cell.tag = indexPath.row
        cell.delegate = self
        print("cell.tag now \(cell.tag)")
        //   cell.delegate = self
        if let _:User = self.arrayWorkers[indexPath.row] as? User {
            let MYD:User = self.arrayWorkers[indexPath.row] as! User
            var STRinvFirstName:String = ""
            if let somethingelse3:String =  MYD.nvFirstName
            {
                STRinvFirstName = somethingelse3
            }
            
            var STRnvLastName:String = ""
            if let somethingelse4:String =  MYD.nvLastName
            {
                STRnvLastName = somethingelse4
            }
            let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
            print("index name \(STRnvFullName) si \(index)")
            cell.setDisplayData(STRnvFullName,myd: MYD,servArray:self.ProviderServicesArray,aPERMISSIONSArray: self.PERMISSIONSArray)
            cell.tblServices.reloadData()
        }
        cell.bringSubviewToFront(cell.bottom)
        cell.bottom.isUserInteractionEnabled = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showContent(_:)))
        tap.delegate = self
        cell.top.tag = indexPath.row
        cell.top.addGestureRecognizer(tap)
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(expandorcollapse(_:)))
        tap1.delegate = self
        cell.btnshowtableservices.tag = indexPath.row
        cell.btnshowtableservices.addGestureRecognizer(tap1)
        cell.bringSubviewToFront(cell.btnshowtableservices)
        return cell
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //if tableView == self.tblEmployes {
        return 390.0
        // }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //                          //\\print(indexPath.row)
        //                        guard let cell = self.tblEmployes.cellForRowAtIndexPath(indexPath) as? MyEmployeTableViewCellFinal
        //                            else { return }
        //
        //                        switch cell.isExpanded
        //                        {
        //                        case true:
        //                            self.expandedRows.remove(indexPath.row)
        //                        case false:
        //                            self.expandedRows.insert(indexPath.row)
        //                        }
        //
        //
        //                        cell.isExpanded = !cell.isExpanded
        //
        //                        self.tblEmployes.beginUpdates()
        //                        self.tblEmployes.endUpdates()
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let cell = self.tblEmployes.cellForRow(at: indexPath) as? MyEmployeTableViewCellFinal
            else { return }
        
        self.expandedRows.remove(indexPath.row)
        
        cell.isExpanded = false
        cell.tblServices.isHidden = true
        self.tblEmployes.beginUpdates()
        self.tblEmployes.endUpdates()
        
        
        
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        //  self.getProviderServicesForSupplierFunc()
    //
    //    }
    
    
    
    func processworkers (_ myWorkers: NSMutableArray) {
        self.arrayWorkers = myWorkers
        Global.sharedInstance.CurrentProviderArrayWorkers = self.arrayWorkers
        print("Global.sharedInstance.CurrentProviderArrayWorkers \(Global.sharedInstance.CurrentProviderArrayWorkers)")
        for aaa in Global.sharedInstance.CurrentProviderArrayWorkers {
            let a:User = aaa as! User
            print("ce nu merge \(a.getDic())")
        }
        GetServicesPermissionForUsersBySupplier()
    
    }
    
    func setupISupplierSecondID (_ ISupplierSecondID:Int){
        self.intSuppliersecondID = ISupplierSecondID
        print("self.intSuppliersecondID \(self.intSuppliersecondID)")
        getProviderServicesForSupplierFunc()
        
    }
    //1
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
        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                {
                    let myInt :Int = RESPONSEOBJECT["Result"] as! Int
                    print("sup id e ok ? " + myInt.description)
                    if myInt == 0 {
                        //NO EMPL NO BUSINESS
                        //   self.setupdefaults(0)
                        //\\print ("no business")
                    } else {
                        //self.setupdefaults(myInt)
                        self.GetSecondUserIdByFirstUserId(myInt)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
        })
    }
    //2
    func GetSecondUserIdByFirstUserId(_ employeID:Int)  {
        
        var y:Int = 0
        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        y = employeID
        dicEMPLOYE["iUserId"] =  y as AnyObject
//        print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
//        let jsonData = try! JSONSerialization.data(withJSONObject: dicEMPLOYE, options: JSONSerialization.WritingOptions.prettyPrinted)
        //        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        //\\print(jsonString)
        if Reachability.isConnectedToNetwork() == false
        {
            
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetSecondUserIdByFirstUserId(dicEMPLOYE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
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
                                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                    print("SECOND USER ID \(myInt)")
                                    if myInt > 0 {
                                        self.setupISupplierSecondID(myInt)
                                    }
                                }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
            })
        }
    }
    //3.
    func getProviderServicesForSupplierFunc()
    {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
            dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            
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
                        self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        
                        let ps:objProviderServices = objProviderServices()
                        if let _:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String,AnyObject>>
                        {
                            print("aaaaaaaa \(RESPONSEOBJECT["Result"] ?? 1 as AnyObject)")
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
                            }
                            self.getServicesProviderForSupplierfunc()
                            
                        } else {
                            self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            
        })
    }
    //4.
    func getServicesProviderForSupplierfunc()
    {
        Global.sharedInstance.giveServiceName = ""
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.providerID == 0 {
            dicSearch["iProviderId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            }
        } else {
            dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }
        
        var arrUsers:Array<User> = Array<User>()
        let temparrayWorkers:  NSMutableArray = []
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.getServicesProviderForSupplierfunc(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    print("respresp \(responseObject ?? 1 as AnyObject)")
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            self.showAlertDelegateX("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            //   var Arr:NSArray = NSArray()
                            
                            //    Arr = responseObject["Result"] as! NSArray
                            let u:User = User()
                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                arrUsers = u.usersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            }
                            Global.sharedInstance.giveServicesArray = arrUsers
                            Global.sharedInstance.arrayGiveServicesKods = []
                            for  item in arrUsers{
                                Global.sharedInstance.arrayGiveServicesKods.append(item.iUserId)
                            }
                            Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
                            Global.sharedInstance.dicGetFreeDaysForServiceProvider["lServiseProviderId"] = Global.sharedInstance.arrayGiveServicesKods as AnyObject
                            
                            
                            
                            if arrUsers.count == 0
                            {
                                Global.sharedInstance.CurrentProviderArrayWorkers = []
                                self.showAlertDelegateX("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                self.processworkers(temparrayWorkers)
                            }
                            else
                            {
                                Global.sharedInstance.CurrentProviderArrayWorkers = []
                                for u:User in arrUsers
                                {
                                    
                                    api.sharedInstance.PREETYJSON_J(u.getDic(), pathofweb: "worker details")
                                    temparrayWorkers.add(u)
                                }
                                  self.processworkers(temparrayWorkers)
                            }
                            
                        }
                    }
                }
              
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    //5.
    func GetServicesPermissionForUsersBySupplier() {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        ////  self.myArray = [] //empty first
        /////  //JMODE in order to get services permissions for current provider and not all of them
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
        //   dic["iSupplierId"] = 20
        api.sharedInstance.GetServicesPermissionForUsersBySupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        
                        if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                            let REZULTATE:NSArray = RESPONSEOBJECT["Result"] as! NSArray
                            self.procesxsMYARRAY(REZULTATE)
                        }
                    } else {
                        //  showAlertDelegateX("NO_PERMISSION_FOR_SERVICES_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        self.view.makeToast(message: "NO_PERMISSION_FOR_SERVICES_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                            self.hidetoast()
                        })
                        
                        let REZULTATE:NSArray = NSArray()
                        self.procesxsMYARRAY(REZULTATE)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        })
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    //6.
    //AddServicePermissionForUser(int iUserId, int iSupplierServiceId)
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
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        })
    }
    
    //7.
    func DeleteServicePermissionByServicePermissionId(_ iServicePermissionId:Int ) {
        ///iServicePermissionId
        var y:Int = 0
        var dicDelpermission:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        y = iServicePermissionId
        dicDelpermission["iSupplierServiceId"] =  y as AnyObject
        print("\n********************************* DeleteServicePermissionByServicePermissionId  ********************\n")
        //        let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicDelpermission, options: NSJSONWritingOptions.PrettyPrinted)
        //        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        //\\print(jsonString)
        if Reachability.isConnectedToNetwork() == false
        {
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.DeleteServicePermissionByServicePermissionId(dicDelpermission, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            print("eroare la DeleteServicePermissionByServicePermissionId \(RESPONSEOBJECT["Error"])")
                        }
                        else
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                
                                print("eroare la DeleteServicePermissionByServicePermissionId \(RESPONSEOBJECT["Error"])")
                            }
                            else
                            {
                                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                {
                                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                    print("raspuns la delete \(myInt)")
                                }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
        
    }
    func procesxsMYARRAY(_ REZULTATE:NSArray) {
        /*
         //1st key = iSupplierServiceId
         //2nd key = iUserId
         //3rd key =  1 or 0
         //4th key = iServicePermissionId
         
         PERMISSIONSArray (
         {
         iServicePermissionId = 21;
         iSupplierServiceId = 54;
         iUserId = 235;
         },
         {
         iServicePermissionId = 22;
         iSupplierServiceId = 54;
         iUserId = 237;
         },
         {
         iServicePermissionId = 23;
         iSupplierServiceId = 53;
         iUserId = 237;
         }
         )
         */
        ARIEFINALA = []
        self.PERMISSIONSArray  = REZULTATE.mutableCopy() as! NSMutableArray
        print("PERMISSIONSArray \(PERMISSIONSArray)")
        print("ARIEFINALA \(ARIEFINALA)")
        self.tblEmployes.reloadData()

    }
    func reloadalldata() {
        arrayWorkers = []
        //1. // 2. get uspplier id and second id
        tryGetSupplierCustomerUserIdByEmployeeId()
    }
}
