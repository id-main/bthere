//
//  NewAppointmentClientViewController.swift
//  Bthere
//
//  Created by User on 1.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//


protocol OpenDetailsAppointmentDelegate {
    func openDetailsAppointment()
}
protocol setNewOrderDelegate {
    func setNewOrder()
}

protocol dismissDelegate {
    func dismiss()
}

import UIKit

//הוסף תור ללקוח- קביעת תור חדש
class NewAppointmentClientViewController: UIViewController,UITextViewDelegate,OpenDetailsAppointmentDelegate,setNewOrderDelegate,dismissDelegate{
    var isfromSPECIALiCustomerUserId:Int = 0
    //MARK: - Properties
    
    var clientStoryBoard:UIStoryboard?
    let language = Bundle.main.preferredLocalizations.first! as NSString
    var storyBoard1:UIStoryboard?
    var dateFormatter:DateFormatter = DateFormatter()
    var order:OrderObj?
    var delegatGetCustomerOrders:getCustomerOrdersDelegate!=nil
    var generic:Generic = Generic()
    var arrProviders:Array<SearchResulstsObj> = Array<SearchResulstsObj>()
    var arrSeviceProviders:Array<User> =  Array<User>()
    var arrSeviceTypes:Array<objProviderServices> = Array<objProviderServices>()
    var supplierID:Int = Int()
    var supplierAddress:String = ""
    
    
    var serviceProvidersID: Int = Int()
    var providerServiceID:Int = Int()
    var dtOrder:Date = Date()
    var dtOrderTime:Date = Date()
    
    //MARK: - Outlet
    
    @IBOutlet weak var lblNameServicer: UILabel!
    
    @IBOutlet weak var lblServiceTypeSelected: UILabel!
    
    @IBOutlet weak var lblNameSupplier: UILabel!
    @IBOutlet weak var lblTitleNewTurn: UILabel!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func btnClose(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var dpDate: UIDatePicker!
    
    @IBOutlet weak var lblDateSelected: UILabel!
    
    @IBOutlet weak var dpHour: UIDatePicker!
    
    @IBOutlet weak var lblHourSelected: UILabel!
    
    @IBOutlet weak var lblSupplier: UILabel!
    
    @IBOutlet weak var viewSupplier: UIView!
    
    //ספק
    @IBAction func btnOpenSupplier(_ sender: AnyObject) {
        
        dpDate.isHidden = true
        dpDate.tag = 0
        dpHour.isHidden = true
        dpHour.tag = 0
        
        if tblSuppliers.tag == 0//סגור
        {
            tblSuppliers.tag = 1
            tblSuppliers.isHidden = false
        }
        else
        {
            tblSuppliers.tag = 0
            tblSuppliers.isHidden = true
        }
        tblSuppliers.reloadData()
    }
    
    @IBOutlet weak var btnOpenSupplier: UIButton!
    
    @IBOutlet weak var tblSuppliers: UITableView!
    
    @IBOutlet weak var lblServiceProvider: UILabel!
    
    @IBOutlet weak var viewServiceProvider: UIView!
    
    @IBAction func btnOpenServiceProvider(_ sender: AnyObject) {
        
        dpDate.isHidden = true
        dpDate.tag = 0
        dpHour.isHidden = true
        dpHour.tag = 0
        if supplierID != 0
        {
            if tblServiceProvider.tag == 0//close
            {
                
                tblServiceProvider.tag = 1
                tblServiceProvider.isHidden = false
            }
            else
            {
                tblServiceProvider.tag = 0
                tblServiceProvider.isHidden = true
            }
        }
        else
        {
            Alert.sharedInstance.showAlert("NO_SELECTED_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        tblSuppliers.reloadData()
    }
    
    @IBOutlet weak var tblServiceProvider: UITableView!
    
    @IBOutlet weak var lblServiceType: UILabel!
    
    @IBOutlet weak var viewServiceType: UIView!
    
    @IBAction func btnOpenServiceType(_ sender: AnyObject) {
        
        dpDate.isHidden = true
        dpDate.tag = 0
        dpHour.isHidden = true
        dpHour.tag = 0
        
        if tblServiceType.tag == 0
        {
            tblServiceType.tag = 1
            tblServiceType.isHidden = false
        }
        else
        {
            tblServiceType.tag = 0
            tblServiceType.isHidden = true
        }
    }
    
    @IBOutlet weak var tblServiceType: UITableView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var viewDate: UIView!
    
    @IBOutlet weak var btnOpenDate: UIButton!
    
    @IBAction func btnOpenDate(_ sender: AnyObject) {
        
        dpHour.isHidden = true
        dpHour.tag = 0
        
        if dpDate.tag == 0
        {
            dpDate.tag = 1
            dpDate.isHidden = false
        }
        else
        {
            dpDate.tag = 0
            dpDate.isHidden = true
        }
    }
    
    
    @IBOutlet weak var lblHour: UILabel!
    
    @IBOutlet weak var viewHour: UIView!
    
    @IBAction func btnOpenHour(_ sender: AnyObject) {
        
        dpDate.isHidden = true
        dpDate.tag = 0
        
        if dpHour.tag == 0
        {
            dpHour.tag = 1
            dpHour.isHidden = false
        }
        else
        {
            dpHour.tag = 0
            dpHour.isHidden = true
        }
    }
    
    @IBOutlet weak var lblRemark: UILabel!
    
    @IBOutlet weak var txtVRemark: UITextView!
    
    @IBOutlet weak var btnMakeAppointment: UIButton!
    //קבע תור
    @IBAction func btnMakeAppointment(_ sender: AnyObject) {
        
        var arrayServicesKods:Array<Int> = []//מערך לשמירת כל הקודים של השרותים
        var arrayServicesKodsToServer:Array<Int> = []
        arrayServicesKods.append(serviceProvidersID)
        arrayServicesKodsToServer.append(providerServiceID)
        self.saveOrderTimeInString()
        if self.isfromSPECIALiCustomerUserId != 0 {
            order = OrderObj(_iSupplierId:supplierID, _iUserId: self.isfromSPECIALiCustomerUserId, _iSupplierUserId: arrayServicesKods, _iProviderServiceId: arrayServicesKodsToServer, _dtDateOrder:Global.sharedInstance.eventBthereDate, _nvFromHour:Global.sharedInstance.hourFreeEventInPlusMenu, _nvComment: txtVRemark.text,_nvToHour:"")
        } else {
            order = OrderObj(_iSupplierId:supplierID, _iUserId: Global.sharedInstance.currentUser.iUserId, _iSupplierUserId: arrayServicesKods, _iProviderServiceId: arrayServicesKodsToServer, _dtDateOrder:Global.sharedInstance.eventBthereDate, _nvFromHour:Global.sharedInstance.hourFreeEventInPlusMenu, _nvComment: txtVRemark.text,_nvToHour:"")
        }
        
        
        
        
        
        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicOrderObj["orderObj"] = order!.getDic() as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.CheckIfOrderIsAvailable(dicOrderObj, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1//הצליח
                        {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            if let _ = RESPONSEOBJECT["Result"] as? String {
                            let date = Global.sharedInstance.getStringFromDateString(RESPONSEOBJECT["Result"] as! String)
                            Global.sharedInstance.NewEventToHour = dateFormatter.string(from: date)
                            }
                            self.openDetailsAppointment()//פתיחת פרטי התור
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//זמן תפוס
                        {
                            let viewCon:noTurnViewController = self.clientStoryBoard!.instantiateViewController(withIdentifier: "noTurnViewController") as! noTurnViewController
                            viewCon.delegate = self
                            viewCon.delegateDismiss = self
                            viewCon.orderObj = self.order
                            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                            self.present(viewCon, animated: true, completion: nil)
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//שגיאה
                        {
                            self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
            })
        }
    }
    
    //MARK: - initial
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        if USERDEF.object(forKey: "isfromSPECIALiCustomerUserId") == nil {
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
        } else {
            if let _:Int = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as? Int {
                let myint = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as! Int
                self.isfromSPECIALiCustomerUserId = myint
            }
        }
        clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        storyBoard1 = UIStoryboard(name: "Main", bundle: nil)
        
        let dateFormatterHours = DateFormatter()
        dateFormatterHours.dateFormat = "HH:mm:SS"
        dpHour.date = dateFormatterHours.date(from: "12:30:00")!
        
        getProviders()
        
        dpDate.isHidden = true
        dpHour.isHidden = true
        
        //  if language != "he" && (DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P) {
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") != 0 && (DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P) {
            
            lblTitleNewTurn.font = UIFont(name: "OpenSansHebrew-Bold", size: 21)
            lblSupplier.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblServiceProvider.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblServiceType.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblDate.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblHour.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblRemark.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            btnMakeAppointment.titleLabel!.font =  UIFont(name: "OpenSansHebrew-Light", size: 13)
        }
            // else if language != "he" && (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) {
        else if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") != 0 && (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) {
            lblTitleNewTurn.font = UIFont(name: "OpenSansHebrew-Bold", size: 18)
            lblSupplier.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblServiceProvider.font = UIFont(name: "OpenSansHebrew-Light", size: 12)
            lblServiceType.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblDate.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblHour.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblRemark.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            btnMakeAppointment.titleLabel!.font =  UIFont(name: "OpenSansHebrew-Light", size: 11)
        }
            
        else if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS{
            
            lblTitleNewTurn.font = UIFont(name: "OpenSansHebrew-Bold", size: 22)
            
            lblSupplier.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblServiceProvider.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblServiceType.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblDate.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblHour.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblRemark.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            
            btnMakeAppointment.titleLabel!.font =  UIFont(name: "OpenSansHebrew-Light", size: 17)
        }
        
        txtVRemark.delegate = self
        
        tblSuppliers.separatorStyle = .none
        tblServiceProvider.separatorStyle = .none
        tblServiceType.separatorStyle = .none
        
        tblSuppliers.isHidden = true
        tblServiceProvider.isHidden = true
        tblServiceType.isHidden = true
        
        //the table is closed
        tblSuppliers.tag = 0
        tblServiceProvider.tag = 0
        tblServiceType.tag = 0
        
        lblTitleNewTurn.text = "NEW_TURN_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblSupplier.text = "COSTUMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblServiceProvider.text = "SERVICE_PROVIDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblServiceType.text = "SERVICE_TYPE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblDate.text = "DATE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblHour.text = "HOUR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblRemark.text = "REMARK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        btnMakeAppointment.setTitle("MAKE_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        tblSuppliers.separatorStyle = .none
        
        dpDate.backgroundColor = Colors.sharedInstance.color6
        dpDate.setValue(UIColor.black, forKeyPath: "textColor")
        dpDate.setValue(0.8, forKeyPath: "alpha")
        dpDate.datePickerMode = UIDatePicker.Mode.date
        dpDate.setValue(false, forKey: "highlightsToday")
        dpDate.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        dpHour.backgroundColor = Colors.sharedInstance.color6
        dpHour.setValue(UIColor.black, forKeyPath: "textColor")
        dpHour.setValue(0.8, forKeyPath: "alpha")
        dpHour.datePickerMode = UIDatePicker.Mode.time
        dpHour.setValue(false, forKey: "highlightsToday")
        dpHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - dismiss key board
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            txtVRemark.resignFirstResponder()
        }
        super.touchesBegan(touches, with:event)
    }
    
    //MARK: - table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblSuppliers{
            return arrProviders.count
        }
        else if tableView == tblServiceProvider
        {
            return arrSeviceProviders.count
        }
        else
        {
            return arrSeviceTypes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "newTurnTableViewCell")as!newTurnTableViewCell
        
        if tableView == tblSuppliers
        {
            cell.setDisplayData((arrProviders[indexPath.row] as SearchResulstsObj).nvProviderName
            )
        }
        else if tableView == tblServiceProvider
        {
            let s = "\((arrSeviceProviders[indexPath.row] as User).nvFirstName) \((arrSeviceProviders[indexPath.row] as User).nvLastName)"
            cell.setDisplayData(s)
        }
        else
        {
            let s = "\((arrSeviceTypes[indexPath.row] as objProviderServices).nvServiceName)"
            cell.setDisplayData(s)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if tableView == tblSuppliers
        {
            lblSupplier.text = (arrProviders[indexPath.row] as SearchResulstsObj).nvProviderName
            supplierID = (arrProviders[indexPath.row] as SearchResulstsObj).iProviderId
            supplierAddress = (arrProviders[indexPath.row] as SearchResulstsObj).nvAdress
            getServicesProviderForSupplier((arrProviders[indexPath.row] as SearchResulstsObj).iProviderId)
            getProviderServicesForSupplier((arrProviders[indexPath.row] as SearchResulstsObj).iProviderId)
            
            tblSuppliers.isHidden = true
            tblSuppliers.tag = 0
        }
        if tableView == tblServiceProvider
        {
            let fullName = "\((arrSeviceProviders[indexPath.row] as User).nvFirstName) \((arrSeviceProviders[indexPath.row] as User).nvLastName)"
            lblServiceProvider.text = fullName
            tblServiceProvider.isHidden = true
            tblServiceProvider.tag = 0
            serviceProvidersID = (arrSeviceProviders[indexPath.row] as User).iUserId
        }
        if tableView == tblServiceType
        {
            let serviceName = (arrSeviceTypes[indexPath.row] as objProviderServices).nvServiceName
            lblServiceType.text = serviceName
            tblServiceType.isHidden = true
            tblServiceType.tag = 0
            providerServiceID = (arrSeviceTypes[indexPath.row] as objProviderServices).iProviderServiceId
            
        }
    }
    
    func tableView(_ tableView: UITableView!, heightForRowAtIndexPath indexPath: IndexPath!) -> CGFloat {
        
        switch tableView {
        case tblSuppliers:
            if arrProviders.count < 3
            {
                tblSuppliers.frame.size.height = self.view.frame.size.height * 0.07 * CGFloat(arrProviders.count)
            }
            
        case tblServiceType:
            if arrSeviceTypes.count < 3
            {
                tblServiceType.frame.size.height = self.view.frame.size.height * 0.07 * CGFloat(arrSeviceTypes.count)
            }
        case tblServiceProvider:
            if arrSeviceProviders.count < 3
            {
                tblServiceProvider.frame.size.height = self.view.frame.size.height * 0.07 * CGFloat(arrSeviceProviders.count)
            }
        default:
            return self.view.frame.size.height * 0.07
        }
        return self.view.frame.size.height * 0.07
        
    }
    
    //קבלת רשימת ספקים ללקוח
    func getProviders()
    {
        let searchObj:SearchResulstsObj = SearchResulstsObj()
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if self.isfromSPECIALiCustomerUserId != 0 {
            dic["iUserId"] = self.isfromSPECIALiCustomerUserId as AnyObject
        } else {
            dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        }
        
        
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetProviderListForCustomer(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _ =  RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                            Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                            self.arrProviders = searchObj.objProvidersToArray(Global.sharedInstance.dicResults)
                            }
                            self.tblSuppliers.reloadData()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                //\\print(NSError)
            })
        }
    }
    
    // MARK: - DatePicker
    
    //בעת גלילת הפיקר
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        if sender == dpDate//תאריך
        {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dtOrder = sender.date
            lblDateSelected.text = dateFormatter.string(from: sender.date)
        }
        else if sender == dpHour//שעות
        {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "HH:mm:SS"
            dtOrderTime  = sender.date
            lblHourSelected.text = dateFormatter.string(from: sender.date)
        }
    }
    
    //קבלת נותני שרות לספק
    func getServicesProviderForSupplier(_ supplierId:Int)
    {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = supplierId as AnyObject
        var arrUsers:Array<User> = Array<User>()
        
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
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            self.showAlertDelegateX("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                                let u:User = User()
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                arrUsers = u.usersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                }
                                if arrUsers.count != 0
                                {
                                    self.arrSeviceProviders = arrUsers
                                    self.tblServiceProvider.reloadData()
                                }
                            }
                        }
                    }
                }
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                
            })
        }
        
    }
    
    //קבלת שרותים לספק
    func  getProviderServicesForSupplier(_ isupplierID:Int)
    {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = isupplierID as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
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
                                
                                self.arrSeviceTypes = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                if self.arrSeviceTypes.count == 0
                                {
                                    self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                                else
                                {
                                    self.tblServiceType.reloadData()
                                }
                            }
                        }
                    }
                }
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                
            })
        }
    }
    //קבע תור
    func setNewOrder()
    {
        var arrayServicesKods:Array<Int> = []//מערך לשמירת כל הקודים של השרותים
        var arrayServicesKodsToServer:Array<Int> = []
        arrayServicesKods.append(serviceProvidersID)
        arrayServicesKodsToServer.append(providerServiceID)
        self.saveOrderTimeInString()
        var order:OrderObj = OrderObj()
        if self.isfromSPECIALiCustomerUserId != 0 {
            order = OrderObj(_iSupplierId:supplierID, _iUserId: self.isfromSPECIALiCustomerUserId, _iSupplierUserId: arrayServicesKods, _iProviderServiceId: arrayServicesKodsToServer, _dtDateOrder:Global.sharedInstance.eventBthereDate , _nvFromHour:Global.sharedInstance.hourFreeEventInPlusMenu, _nvComment: txtVRemark.text,_nvToHour:"")
        } else {
            order = OrderObj(_iSupplierId:supplierID, _iUserId: Global.sharedInstance.currentUser.iUserId, _iSupplierUserId: arrayServicesKods, _iProviderServiceId: arrayServicesKodsToServer, _dtDateOrder:Global.sharedInstance.eventBthereDate , _nvFromHour:Global.sharedInstance.hourFreeEventInPlusMenu, _nvComment: txtVRemark.text,_nvToHour:"")
        }
        if order.iUserId == 134 {
            let USERDEF = UserDefaults.standard
            if  USERDEF.object(forKey: "numberdefaultForOcassional") != nil {
                if let _:String = USERDEF.value(forKey: "numberdefaultForOcassional") as? String {
                    let ceva:String = USERDEF.value(forKey: "numberdefaultForOcassional") as! String
                    order.nvComment = ceva
                }
            }
        }
        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        print(order.getDic())
        
        
        dicOrderObj["orderObj"] = order.getDic() as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.newOrder(dicOrderObj, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//אם אין תור פנוי בזמן הזה
                        {
                            let viewCon:noTurnViewController = self.clientStoryBoard!.instantiateViewController(withIdentifier: "noTurnViewController") as! noTurnViewController
                            viewCon.delegate = self
                            viewCon.orderObj = self.order
                            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                            self.present(viewCon, animated: true, completion: nil)
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1//הצליח
                        {
                            
                            print("Global.sharedInstance.currentUser.bIsGoogleCalendarSync: \(Global.sharedInstance.currentUser.bIsGoogleCalendarSync)")
                            if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
                              //  Calendar.sharedInstance.saveEventInDeviceCalander()
                              
                            } else {
                                
                            }
                            //\\no need   self.getFreeDaysForServiceProvider()
                        }
                            //in case of 2 no event can be save this is special case so he just recieve push from server
                            //in case of 3 customer was rejected and cannot make appointment
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 3  || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 4//
                        {
                            
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//שגיאה
                        {
                            self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        if Global.sharedInstance.currentUser.iUserId != 0 {
                            api.sharedInstance.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                        }
                    }
                }
            },failure:
                {
                    (AFHTTPRequestOperation, NSError) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    if Global.sharedInstance.currentUser.iUserId != 0 {
                        api.sharedInstance.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                    }
            })
        }
    }
//    func saveEventInDeviceCalander()
//    {
//        let calendar = Foundation.Calendar.current
//        var startDate:Date?
//        var endDate:Date?
//
//        dateFormatt.dateFormat = "dd/MM/YYYY"
//        var eventDate:Date = dicEvent["date"] as! Date
//
//        //cut "12:40-15:50"
//        if self.dicEvent["hours"] != nil
//        {
//            let hours : String = (self.dicEvent["hours"]?.description)!
//            let hoursArr : [String] = hours.components(separatedBy: "-")
//
//            let startHour : String = hoursArr[0]//12:40
//            let endHour : String = hoursArr[1]//15:50
//
//            dateFormatt.dateFormat = "HH:mm"
//
//            var componentsmStart1 = (calendar as NSCalendar).components([.year,.month,.day,.hour, .minute], from: eventDate)
//            componentsmStart1.hour = Int(startHour.components(separatedBy: ":")[0])!
//            componentsmStart1.minute = Int(startHour.components(separatedBy: ":")[1])!
//
//            let gregorian = Foundation.Calendar(identifier: .gregorian)
//            eventDate = gregorian.date(from: componentsmStart1)!
//            //\\print(eventDate)
//
//            startDate = eventDate
//            endDate = dateFormatt.date(from: endHour)!
//
//            let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: startDate!)
//
//            let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: endDate!)
//
//            //יצירת תאריכי התחלה וסיום לאירוע - ע״פ התאריך והשעות.
//            startDate = Calendar.sharedInstance.getPartsOfDate( eventDate, to: componentsStart)
//            endDate = Calendar.sharedInstance.getPartsOfDate(eventDate, to: componentsEnd)
//
//            //בדיקה את התאריך סיום גדול מתאריך התחלה
//            if small(endDate!, rhs: startDate!) == true
//            {
//                Alert.sharedInstance.showAlert("ILLEGAL_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//            }
//            else
//            {
//                //יצירת האירוע
//                let eventStore : EKEventStore = EKEventStore()
//
//                eventStore.requestAccess(to: .event, completion: { (granted, error) in
//                    if (granted) && (error == nil) {
//                        let event = EKEvent(eventStore: eventStore)
//                        if let _:String = self.dicEvent["name"] as? String {
//                            event.title = self.dicEvent["name"] as! String
//                        }
//                        if let _:String = self.dicEvent["remark"] as? String {
//                            event.notes = self.dicEvent["remark"] as! String
//
//                        }
//                        //הוספתי את :by_BThere להערות לזיהוי שזהו אירוע שנקבע באפליקצית ביזר
//                        event.isAllDay = false
//                        event.startDate = startDate!
//                        event.endDate = endDate!
//                        //\\ event.notes = notes! + " :by_BThere"
//
//                        event.calendar = eventStore.defaultCalendarForNewEvents
//                        do
//                        {
//                            try eventStore.save(event, span: .thisEvent)
//                            Alert.sharedInstance.showAlert("SUCCESS_NEW_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//
//                        }
//                        catch let e as NSError {
//                            print(e)
//                            return
//                        }
//                    } else {
//                        let alert = UIAlertController(title: nil, message: "REQUEST_CALENDAR_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
//                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
//                        })
//                        alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
//                        })
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                })
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
//        else
//        {
//            Alert.sharedInstance.showAlert("NO_HOUR".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//        }
//    }
    //קבלת ימים פנויים לנותן שרות
    func getFreeDaysForServiceProvider(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
        Global.sharedInstance.dicGetFreeDaysForServiceProvider["lProviderServiceId"] = Global.sharedInstance.arrayServicesKodsToServer as AnyObject
        
        
        if Reachability.isConnectedToNetwork() == false
        {
            
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetFreeDaysForServiceProvider(Global.sharedInstance.dicGetFreeDaysForServiceProvider, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            
                            dateFormatter.timeZone = TimeZone(identifier: "GMT")
                            let ps:providerFreeDaysObj = providerFreeDaysObj()
                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                            Global.sharedInstance.getFreeDaysForService = ps.objFreeDaysToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            }
                            //איפוס המערך מנתונים ישנים
                            Global.sharedInstance.dateFreeDays = []
                            
                            for i in 0 ..< Global.sharedInstance.getFreeDaysForService.count{
                                let dateDt = Calendar.sharedInstance.addDay(Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate))//היום שיש בו שעות פנויות
                                
                                Global.sharedInstance.dateFreeDays.append(dateDt)//מערך שמכיל את תאריכי הימים בהם אפשר לקבוע תור ז״א יש בהם שעות פנויות
                            }
                            Global.sharedInstance.fromHourArray = Global.sharedInstance.dateFreeDays
                            Global.sharedInstance.endHourArray = Global.sharedInstance.dateFreeDays
                            
                            
                            for i in 0 ..< Global.sharedInstance.dateFreeDays.count{//יש לי מערך של תאריכים ובאותו מקום של התאריך במערך יש לי את השעות של התורים הפנויים של אותו תאריך
                                let provider:providerFreeDaysObj = Global.sharedInstance.getFreeDaysForService[i]
                                
                                let hourStart = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvFromHour)
                                
                                Global.sharedInstance.fromHourArray[i] = hourStart
                                let hourEnd = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvToHour)
                                Global.sharedInstance.endHourArray[i] = hourEnd
                                
                            }
                            
                            let currentDate:Date = Date()
                            var dayOfWeekToday = 0
                            
                            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
                            
                            //אתחול מערך השעות הפנויות לשבוע
                            //ואתחול מערך האירועים של ביזר
                            for i in 0 ..< 7 {
                                
                                let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i + 1)
                                
                                Global.sharedInstance.setFreeHours(curDate, dayOfWeek: i)
                                Global.sharedInstance.getBthereEvents(curDate, dayOfWeek: i)
                            }
                        }
                    }
                    self.delegatGetCustomerOrders.GetCustomerOrders()
                    //self.GetCustomerOrders()
                }
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    func saveOrderTimeInString()
    {
        let calendar = Foundation.Calendar.current
        let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: dtOrderTime)
        
        let hourS = componentsStart.hour
        let minuteS = componentsStart.minute
        
        Global.sharedInstance.eventBthereDate = dtOrder
        
        Global.sharedInstance.eventBthereDateStart = Calendar.sharedInstance.getPartsOfDate(Global.sharedInstance.eventBthereDate , to: componentsStart)
        
        var hourS_Show:String = hourS!.description
        var minuteS_Show:String = minuteS!.description
        
        if hourS! < 10
        {
            hourS_Show = "0" + hourS_Show
        }
        
        if minuteS! < 10
        {
            minuteS_Show = "0" +   minuteS_Show
        }
               
        let fullHourS = "\(hourS_Show):\(minuteS_Show)"
        Global.sharedInstance.hourFreeEventInPlusMenu = fullHourS
    }
    
    //פתיחת פרטי הזמנה
    func openDetailsAppointment()
    {
        let storyboard = UIStoryboard(name: "ClientExist", bundle: nil)
        
        let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let viewController = storyboard.instantiateViewController(withIdentifier: "detailsAppointmetClientViewController") as! detailsAppointmetClientViewController
        self.delegatGetCustomerOrders = viewController
        
        viewController.tag = 4//תור חדש
        viewController.fromViewMode = false
        viewController.delegateSetNewOrder = self
        
        viewController.dateEvent = dtOrder
        viewController.fromHour = (order!.nvFromHour)
        viewController.supplierName = self.lblSupplier.text!
        viewController.serviceName = lblServiceType.text!
        viewController.address = supplierAddress
        
        frontviewcontroller?.pushViewController(viewController, animated: false)
        
        let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
    func dismiss()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let viewController = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        
        frontviewcontroller?.pushViewController(viewController, animated: false)
        
        let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
}

