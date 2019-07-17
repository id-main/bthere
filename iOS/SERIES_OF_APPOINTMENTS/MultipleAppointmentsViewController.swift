//
//  MultipleAppointmentsViewController.swift
//  BThere
//
//  Created by Ioan Ungureanu on 28/02/2018
//  Copyright © 2018 Bthere. All rights reserved.
//
protocol openNextAppointmentDelegate {
    func goback()
}
import UIKit
import MarqueeLabel
import EventKit
class MultipleAppointmentsViewController: NavigationModelViewController,openFromMenuDelegate, UITableViewDelegate,UITableViewDataSource,openNextAppointmentDelegate,UIGestureRecognizerDelegate {
    // Outlets
    var sumofservicetime:Int = 0
    var bIsAvailableForNewCustomer = 0
    var iHoursForPreCancelServiceByCustomer = 0
    @IBOutlet weak var CentralButton:UIView!
    var isfromSPECIALiCustomerUserId:Int = 0
    @IBOutlet weak var butonwidth: NSLayoutConstraint!
    @IBOutlet weak var englishPlusMenu: UIImageView!
    @IBOutlet var topBorderView: UIView!
    @IBOutlet var popConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblAppointments: UITableView!
    @IBOutlet weak var btnBACK:UIButton!
    @IBOutlet weak var btnFINISH:UIButton!
    @IBOutlet var newsDealsLabel: MarqueeLabel!
    @IBOutlet weak var imgPlusMenu: UIImageView!
    var viewpop: PopUpGenericViewController!
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var numberofOrderstoSend:Int = 0
    var numberofOrderstoReSend:Int = 0
    var failedSEndOrders: Array<OrderObj> =  Array<OrderObj>()
    var failedafterSecondSEndOrders: Array<OrderObj> =  Array<OrderObj>()
    var numberofmaxAppointmentspermited:Int = 0
    var iPeriodInWeeksForMaxServices:Int = 0
    var iMaxServiceForCustomer:Int = 0
    var iCustomerViewLimit:Int = 0
    var ISFROMSPECIALSUPPLIER:Bool = false
    var bLimitSeries:Bool = false
    var generic:Generic = Generic()
    let calendar = Foundation.Calendar.current
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:58)
        let USERDEF = Global.sharedInstance.defaults
        if USERDEF.object(forKey: "isfromSPECIALiCustomerUserId") == nil
        {
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
        } else {
            if let _:Int = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as? Int {
                let myint = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as! Int
                self.isfromSPECIALiCustomerUserId = myint
            }
        }


            print("services kods ids: \(Global.sharedInstance.arrayGiveServicesKods)")
        if Global.sharedInstance.ordersOfClientsTemporaryArray.count > 0 {
        Global.sharedInstance.multipleAppointmentsSupplierIDs.append([Global.sharedInstance.ordersOfClientsTemporaryArray[0].iProviderUserId])
  
        }
        
            print("Global.sharedInstance.currentUser.iUserId \(Global.sharedInstance.currentUser.iUserId) and isfromSPECIALiCustomerUserId \(self.isfromSPECIALiCustomerUserId)")
        
        for  item in Global.sharedInstance.ordersOfClientsTemporaryArray
        {
            print("order obj here: \(item.getDic())")
        }
    }
    @objc func openPlusMenuNewCustomer(){
        if let _ =  Bundle.main.loadNibNamed("PlusMenu3CirclesNewCustomer", owner: self, options: nil)?.first as? PlusMenuNewCustomer
        {
            let openpopmenu = Bundle.main.loadNibNamed("PlusMenu3CirclesNewCustomer", owner: self, options: nil)?.first as! PlusMenuNewCustomer
            openpopmenu.frame = self.view.frame
            self.view.addSubview(openpopmenu)
            self.view.bringSubviewToFront(openpopmenu)
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            butonwidth.constant = 80
        } else {
            butonwidth.constant = 70
        }
        let tapOpenPlusMenuNewCustomer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewCustomer))
        tapOpenPlusMenuNewCustomer.delegate = self
        CentralButton.addGestureRecognizer(tapOpenPlusMenuNewCustomer)
        GetProviderSettingsForCalendarmanagement()
        self.getnews()
        self.newsDealsLabel.restartLabel()
        let leftarrowback = UIImage(named: "sageata2.png")
        self.btnBACK.setImage(leftarrowback, for: UIControl.State())
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnBACK.transform = scalingTransform
        }
        btnBACK.imageView!.contentMode = .scaleAspectFit
        lblTitle.text = "LBLAPPOINTMENT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        self.tblAppointments.delegate = self
        self.tblAppointments.dataSource = self
        self.tblAppointments.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tblAppointments.rowHeight = UITableView.automaticDimension
        self.tblAppointments.estimatedRowHeight = 340
        let attrs = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.boldSystemFont(ofSize: 19.0),
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : Colors.sharedInstance.color4,
            convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1] as [String : Any]
        
        let attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:"FINISH_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary(attrs))
        attributedString.append(buttonTitleStr)
        btnFINISH.setAttributedTitle(attributedString, for: UIControl.State())
        
        
    }
    func GetProviderSettingsForCalendarmanagement() {
        let USERDEF = UserDefaults.standard
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("response for GetProviderSettingsForCalendarmanagement \(RESPONSEOBJECT)")
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                let possiblerezult:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                if let _:Bool = possiblerezult["bLimitSeries"] as? Bool {
                                    self.bLimitSeries = possiblerezult["bLimitSeries"] as! Bool
                                }
                                if self.bLimitSeries == false { //defaults 26 in 52 weeks...means multiple once
                                    self.iMaxServiceForCustomer = 26
                                    self.iPeriodInWeeksForMaxServices = 52
                                } else {
                                    if let _:Int = possiblerezult["iMaxServiceForCustomer"] as? Int {
                                        self.iMaxServiceForCustomer = possiblerezult["iMaxServiceForCustomer"] as! Int
                                        if self.iMaxServiceForCustomer == 0 {
                                            self.iMaxServiceForCustomer = 3
                                        }
                                    } else {
                                        self.iMaxServiceForCustomer = 3
                                    }

                                    if let _:Int = possiblerezult["iPeriodInWeeksForMaxServices"] as? Int {
                                        self.iPeriodInWeeksForMaxServices = possiblerezult["iPeriodInWeeksForMaxServices"] as! Int
                                        if  self.iPeriodInWeeksForMaxServices == 0 {
                                            self.iPeriodInWeeksForMaxServices  = 6
                                        }
                                    } else {
                                        self.iPeriodInWeeksForMaxServices = 6
                                    }

                                }
                                
                                if let _:Int = possiblerezult["iCustomerViewLimit"] as? Int {
                                    self.iCustomerViewLimit = possiblerezult["iCustomerViewLimit"] as! Int
                                }
                                if self.iCustomerViewLimit == 0 {
                                    self.iCustomerViewLimit = 52
                                }
                                if let _:Bool = possiblerezult["bIsAvailableForNewCustomer"] as? Bool {
                                    let myint:Bool =  possiblerezult["bIsAvailableForNewCustomer"] as! Bool
                                    if myint == true {
                                        self.bIsAvailableForNewCustomer = 1
                                    } else {
                                        self.bIsAvailableForNewCustomer = 0
                                    }
                                }
                                if let _:Int = possiblerezult["iHoursForPreCancelServiceByCustomer"] as? Int {
                                    let myint:Int =  possiblerezult["iHoursForPreCancelServiceByCustomer"] as! Int
                                    if myint == 1 {
                                        self.iHoursForPreCancelServiceByCustomer = 1
                                    } else {
                                        self.iHoursForPreCancelServiceByCustomer = 0
                                    }
                                }
                                USERDEF.set(self.iCustomerViewLimit, forKey: "CALENDARWEEKSFORSUPPLIER")
                                USERDEF.set(self.iMaxServiceForCustomer, forKey: "MAXSERVICEFORCUSTOMER")
                                USERDEF.set(self.iPeriodInWeeksForMaxServices , forKey: "WEEKSFORSUPPLIER")
                                USERDEF.set(self.bIsAvailableForNewCustomer, forKey: "bIsAvailableForNewCustomer")
                                USERDEF.set(self.iHoursForPreCancelServiceByCustomer, forKey: "iHoursForPreCancelServiceByCustomer")
                                USERDEF.synchronize()
                                self.numberofmaxAppointmentspermited =  self.read_iMaxServiceForCustomer()
                                self.tblAppointments.reloadData()
                            }
                        } else {
                            //user was not found
                            self.SETUPDEFAULTSINCASEOFFAILURE()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.SETUPDEFAULTSINCASEOFFAILURE()
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    func SETUPDEFAULTSINCASEOFFAILURE() {
        let USERDEF = UserDefaults.standard
        self.iMaxServiceForCustomer = 3
        self.iPeriodInWeeksForMaxServices = 6
        self.iCustomerViewLimit = 52
        USERDEF.set(self.iCustomerViewLimit, forKey: "CALENDARWEEKSFORSUPPLIER")
        USERDEF.set(self.iMaxServiceForCustomer, forKey: "MAXSERVICEFORCUSTOMER")
        USERDEF.set(self.iPeriodInWeeksForMaxServices , forKey: "WEEKSFORSUPPLIER")
        USERDEF.synchronize()
    }
    
    func openFromMenu(_ con:UIViewController)
    {
        self.present(con, animated: true, completion: nil)
    }
    
   @objc  func imageTapped(){
        if self.ISFROMSPECIALSUPPLIER {
            let storyBoard = UIStoryboard(name:"SupplierExist", bundle: nil)
            let viewCon:PLUSMENUSupplier = storyBoard.instantiateViewController(withIdentifier: "PLUSMENUSupplier") as! PLUSMENUSupplier
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            viewCon.delegate = self
            self.present(viewCon, animated: true, completion: nil)
        } else {
            Global.sharedInstance.currentOpenedMenu = self

            let viewCon:MenuPlusViewController = storyBoard1?.instantiateViewController(withIdentifier: "MenuPlusViewController") as! MenuPlusViewController
            viewCon.delegate = self
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(viewCon, animated: true, completion: nil)
        }
    }
    @IBAction func finishall() {
        btnFINISH.isUserInteractionEnabled = false
        let uniqueVals = uniq(Global.sharedInstance.arrayServicesKodsToServer)
        var counterFor:Int = -1
        for  item in Global.sharedInstance.ordersOfClientsTemporaryArray {
            counterFor += 1
            var providerID:Int = 0
            if Global.sharedInstance.providerID == 0 {
                providerID = 0
                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                    providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                    
                }
            } else {
                providerID = Global.sharedInstance.providerID
            }
            //quick fix for order date
            let dateFormatterzz = DateFormatter()
            dateFormatterzz.dateFormat = "dd/MM/yyyy"
            let datef = dateFormatterzz.string(from: item.dtDateOrder as Date)
            let cleandate = Global.sharedInstance.getDateFromString(datef)
            let  fixedcurrentDate =  Calendar.sharedInstance.addDay(cleandate)
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
//commit commentsdfsdfsdfsdfsdfsdf

            print("Global.sharedInstance.currentUser.iUserId \(Global.sharedInstance.currentUser.iUserId) and isfromSPECIALiCustomerUserId \(self.isfromSPECIALiCustomerUserId)")
            if self.isfromSPECIALiCustomerUserId != 0 {
                self.generic.showNativeActivityIndicator(self)
                let order = OrderObj(_iSupplierId: providerID, _iUserId: self.isfromSPECIALiCustomerUserId, _iSupplierUserId: [Global.sharedInstance.ordersOfClientsTemporaryArray[counterFor].iProviderUserId], _iProviderServiceId:uniqueVals, _dtDateOrder:fixedcurrentDate,_nvFromHour: item.nvFromHour, _nvComment: "",_nvToHour:"")
                let delay = 5 * Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                     self.generic.hideNativeActivityIndicator(self)
                    self.setNewOrder(order)
                })
            } else {
                self.generic.showNativeActivityIndicator(self)
            let order = OrderObj(_iSupplierId: providerID, _iUserId: Global.sharedInstance.currentUser.iUserId, _iSupplierUserId: [Global.sharedInstance.ordersOfClientsTemporaryArray[counterFor].iProviderUserId], _iProviderServiceId:uniqueVals, _dtDateOrder:fixedcurrentDate,_nvFromHour: item.nvFromHour, _nvComment: "",_nvToHour:"")
                let delay = 5 * Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                      self.generic.hideNativeActivityIndicator(self)
                    self.setNewOrder(order)
                })
            }

        }
        
    }
    @IBAction func btnBACK(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        let modelclendar:ModelCalendarForAppointmentsViewController = clientStoryBoard.instantiateViewController(withIdentifier: "ModelCalendarForAppointments") as! ModelCalendarForAppointmentsViewController
        modelclendar.modalPresentationStyle = UIModalPresentationStyle.custom
        if ISFROMSPECIALSUPPLIER == true {
            Global.sharedInstance.whichReveal = true

        }
        modelclendar.isfromSPECIALSUPPLIER = self.ISFROMSPECIALSUPPLIER
        frontViewController.pushViewController(modelclendar, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController
        self.view.window!.rootViewController = mainRevealController
        self.view.window?.makeKeyAndVisible()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (Global.sharedInstance.ordersOfClientsTemporaryArray.count > 0) {
            self.topBorderView.isHidden = false
        } else {
            self.topBorderView.isHidden = true
        }
        if (Global.sharedInstance.ordersOfClientsTemporaryArray.count > 0) {
            return Global.sharedInstance.ordersOfClientsTemporaryArray.count + 1 //BTN_NEXT_APPOINTMENT
        }
        return 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mynumberofsections = self.tblAppointments.numberOfSections
        print("how much in array of orders\(Global.sharedInstance.ordersOfClientsTemporaryArray.count) and no of sections \(mynumberofsections)")
        if (Global.sharedInstance.ordersOfClientsTemporaryArray.count > 0) {
            if indexPath.section != mynumberofsections - 1  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleAppointmentTableViewCell") as!  MultipleAppointmentTableViewCell
                var Objecttoclean:OrderDetailsObj = OrderDetailsObj()
                Objecttoclean = Global.sharedInstance.ordersOfClientsTemporaryArray[indexPath.section]
                cell.setDisplayData(Objecttoclean, _whatindex:  indexPath.section)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            } else {
                if Global.sharedInstance.ordersOfClientsTemporaryArray.count == numberofmaxAppointmentspermited {

                    let cell = tableView.dequeueReusableCell(withIdentifier: "NextAppointmentTableViewCell") as!  NextAppointmentTableViewCell
                    cell.BTN_NEXT_APPOINTMENT.isUserInteractionEnabled = false
                    cell.BTN_NEXT_APPOINTMENT.isHidden = true
                    cell.contentView.isHidden = true
                    cell.isUserInteractionEnabled = false
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.delegate = self
                    return cell

                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NextAppointmentTableViewCell") as!  NextAppointmentTableViewCell
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.BTN_NEXT_APPOINTMENT.isUserInteractionEnabled = true
                    cell.BTN_NEXT_APPOINTMENT.isHidden = false
                    cell.contentView.isHidden = false
                    cell.isUserInteractionEnabled = true
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.delegate = self
                    return cell
                }
            }
        }
        let cell = UITableViewCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func goback(){
        btnBACK(self.btnBACK)
    }
    
    func getnews(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            var y:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
                dic["iUserId"] = y as AnyObject
            }
            api.sharedInstance.GetNewsAndUpdates(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        if let abcd = RESPONSEOBJECT["Result"] as? String {
                            self.newsDealsLabel.tag = 101
                            self.newsDealsLabel.type = .continuous
                            self.newsDealsLabel.animationCurve = .linear
                            self.newsDealsLabel.type = .leftRight
                            self.newsDealsLabel.text  = abcd
                            self.newsDealsLabel.restartLabel()
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
    
    func setNewOrder(_ myorder:OrderObj)
    {
        
        var order:OrderObj = OrderObj()
        order = myorder
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
        dicOrderObj["orderObj"] = order.getDic() as AnyObject
        print("order dic \(order.getDic())")
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            self.generic.hideNativeActivityIndicator(self)
        }
        else
        {
            api.sharedInstance.newOrder(dicOrderObj, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            //success
                            self.saveEventInDeviceCalander(myOrder: order)
                            print("success")
                            self.numberofOrderstoSend = self.numberofOrderstoSend + 1
                            print("\(Global.sharedInstance.ordersOfClientsTemporaryArray.count) si numberofOrderstoSend \(self.numberofOrderstoSend)")
                            if  self.numberofOrderstoSend == Global.sharedInstance.ordersOfClientsTemporaryArray.count {
                                if self.failedSEndOrders.count > 0 {
                                    self.retrysendFailedOrders()
                                } else {
                                    //end screen
                                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                                    self.viewpop = (storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController)
                                    if self.iOS8 {
                                        self.viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                    } else {
                                        self.viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
                                    }
                                    self.viewpop.isfromWhichScreen = 2
                                    self.viewpop.ISFROMSPECIALSUPPLIER = self.ISFROMSPECIALSUPPLIER
                                    self.present(self.viewpop, animated: true, completion: nil)
                                }
                            }
                        }
                            
                        else {
                            self.generic.hideNativeActivityIndicator(self)
                            self.numberofOrderstoSend = self.numberofOrderstoSend + 1
                            self.failedSEndOrders.append(order)
                            
                            print("\(Global.sharedInstance.ordersOfClientsTemporaryArray.count) si numberofOrderstoSend \(self.numberofOrderstoSend)")
                            
                            if  self.numberofOrderstoSend == Global.sharedInstance.ordersOfClientsTemporaryArray.count {
                                if self.failedSEndOrders.count > 0 {
                                    self.retrysendFailedOrders()
                                } else {
                                    //end screen
                                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                                    self.viewpop = (storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController)
                                    if self.iOS8 {
                                        self.viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                    } else {
                                        self.viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
                                    }
                                    self.viewpop.isfromWhichScreen = 2
                                    self.present(self.viewpop, animated: true, completion: nil)
                                }
                                
                            }
                        }
                    }
                }
            },failure:
                {
                    (AFHTTPRequestOperation, NSError) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    self.numberofOrderstoSend = self.numberofOrderstoSend + 1
                    print("\(Global.sharedInstance.ordersOfClientsTemporaryArray.count) si numberofOrderstoSend \(self.numberofOrderstoSend)")
                    if  self.numberofOrderstoSend == Global.sharedInstance.ordersOfClientsTemporaryArray.count {
                        if self.failedSEndOrders.count > 0 {
                            self.retrysendFailedOrders()
                        } else {
                            //end screen
                            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                            self.viewpop = (storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController)
                            if self.iOS8 {
                                self.viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            } else {
                                self.viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
                            }
                            self.viewpop.isfromWhichScreen = 2
                            self.present(self.viewpop, animated: true, completion: nil)
                        }
                        
                    }
                    
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
        
    }
    func retrysendFailedOrders() {
        numberofOrderstoReSend = self.failedSEndOrders.count
        for item in self.failedSEndOrders {
            resendNewOrder(item)
            
        }
    }
    func resendNewOrder(_ myorder:OrderObj)
    {
        
        var order:OrderObj = OrderObj()
        order = myorder
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
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 3 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 4
                        {
                            self.failedafterSecondSEndOrders.append(myorder)
                        }
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            //success
                            self.saveEventInDeviceCalander(myOrder: order)
                            print("success")
                            self.numberofOrderstoReSend = self.numberofOrderstoReSend - 1
                            print("\(self.failedSEndOrders.count) si numberofOrderstoReSend \(self.numberofOrderstoReSend)")
                            if  self.numberofOrderstoReSend == 0 {
                                
                                //end screen
                                let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                                self.viewpop = (storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController)
                                if self.iOS8 {
                                    self.viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                } else {
                                    self.viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
                                }
                                self.viewpop.isfromWhichScreen = 2
                                self.present(self.viewpop, animated: true, completion: nil)
                            }
                            
                        }
                            
                        else {
                            self.numberofOrderstoReSend = self.numberofOrderstoReSend - 1
                            print("\(self.failedSEndOrders.count) si numberofOrderstoReSend \(self.numberofOrderstoReSend)")
                            
                            if  self.numberofOrderstoReSend == 0  && self.failedafterSecondSEndOrders.count == self.failedSEndOrders.count  {                            //failed some
                                let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                                self.viewpop = (storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController)
                                if self.iOS8 {
                                    self.viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                } else {
                                    self.viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
                                }
                                self.viewpop.isfromWhichScreen = 4
                                self.present(self.viewpop, animated: true, completion: nil)
                            }
                            if  self.numberofOrderstoReSend == 0  && self.failedafterSecondSEndOrders.count != self.failedSEndOrders.count  {                            //end screen
                                let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                                self.viewpop = (storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController)
                                if self.iOS8 {
                                    self.viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                } else {
                                    self.viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
                                }
                                self.viewpop.isfromWhichScreen = 2
                                self.present(self.viewpop, animated: true, completion: nil)
                            }
                            
                            
                            
                        }
                    }
                }
                
            },failure:
                {
                    (AFHTTPRequestOperation, NSError) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    self.numberofOrderstoReSend = self.numberofOrderstoReSend - 1
                    print("\(self.failedSEndOrders.count) si numberofOrderstoReSend \(self.numberofOrderstoReSend)")
                    if  self.numberofOrderstoReSend == 0 {
                        //end screen
                        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                        self.viewpop = (storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController)
                        if self.iOS8 {
                            self.viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        } else {
                            self.viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
                        }
                        self.viewpop.isfromWhichScreen = 2
                        self.present(self.viewpop, animated: true, completion: nil)
                    }
                    
                    
                    
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
        
    }
    func read_iMaxServiceForCustomer() -> Int {
        let need_Int = self.iMaxServiceForCustomer
        return need_Int
        
    }
    
    func hoursminutesfromString(hminutes: String) -> Array<Int> {
        var myarr =  Array<Int> ()
        var numHOURS:Int = 0
        var numMINUTES:Int = 0
        let hourminString = hminutes
        if hourminString.contains(":") {
            let splited = hourminString.components(separatedBy: ":")
            if splited.count == 2 {
                if splited[0].count == 2 &&  splited[1].count == 2 {
                    
                    // 1. first clean hours
                    let a1 =  splited[0].substring(to: 1)
                    if a1 == "0" {
                        //now get the real hour
                        let a2 =  splited[0].substring(from: 0)
                        if a2 == "0" {
                            numHOURS = 0
                        }
                        else {
                            let IntHOUR:Int = Int(a2)!
                            numHOURS = IntHOUR
                        }
                    }
                    else {
                        let a3 = splited[0]
                        let IntHOUR:Int = Int(a3)!
                        numHOURS = IntHOUR
                    }
                    //second clean minutes
                    let a4 =  splited[1].substring(to: 1)
                    if a4 == "0" {
                        //now get the real hour
                        let a5 =  splited[1].substring(from: 0)
                        if a5 == "0" {
                            numMINUTES = 0
                        }
                        else {
                            let IntMINUTES:Int = Int(a5)!
                            numMINUTES = IntMINUTES
                        }
                    }
                    else {
                        let a5 = splited[1]
                        let IntMINUTES:Int = Int(a5)!
                        numMINUTES = IntMINUTES
                    }
                    
                    //all logic in this condition
                    myarr.append(numHOURS)
                    myarr.append(numMINUTES)
                }
            }
        }
        
        return myarr
    }
    
    func saveEventInDeviceCalander(myOrder:OrderObj)
    {
        //        var addMinutes : Int = 0
        let myAarray : Array<Int> =  myOrder.iProviderServiceId

        var serviceName = ""
        
        //     print("variabila service id \(i)")
        if Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices.count > 0 {
            for service in Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices {
                let idservice = service.iProviderServiceId
                if myAarray.contains(idservice) {
                    let servicetime = service.iTimeOfService
                    sumofservicetime = sumofservicetime + servicetime

                }
            }
        }
        //since all orders have the same services we can extract only object at [0] and get service names(s)

        var Objecttoclean:OrderDetailsObj = OrderDetailsObj()
        if Global.sharedInstance.ordersOfClientsTemporaryArray.count > 0 {
        Objecttoclean = Global.sharedInstance.ordersOfClientsTemporaryArray[0]
            print(Objecttoclean.getDic())
        let objunique = Objecttoclean.objProviderServiceDetails.uniquevals
        print("unice \(objunique.count)")

        for e in objunique {
            print("e \(e.nvServiceName)")
            if serviceName == ""
            {
                serviceName = e.nvServiceName
            }
            else
            {
                serviceName += ",\(e.nvServiceName)"
            }
        }

        if serviceName == "" {
            serviceName = Objecttoclean.title
        }
        if serviceName == "" {
            serviceName = Global.sharedInstance.serviceName
        }
        }

        if Global.sharedInstance.iServiceTimeSUM > 0 {
            sumofservicetime = Global.sharedInstance.iServiceTimeSUM 
        }
        if sumofservicetime == 0 {
            sumofservicetime = 2 //just to make sure end date si greater than start date
        }
        print(myOrder.getDic())
        print("sumofservicetime\(sumofservicetime)")
        
        
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil)
            {
                let event = EKEvent(eventStore: eventStore)
                //   let providerName = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName
                var myname:String = ""
                if Global.sharedInstance.nameOfCustomer != ""
                {
                    myname = Global.sharedInstance.nameOfCustomer
                }
                else
                {
                    myname = Global.sharedInstance.currentProviderToCustomer.nvProviderName
                }
                let serviceName =  "\(myname) : \(serviceName)"
         //    let serviceName =  "\(Global.sharedInstance.currentProviderToCustomer.nvProviderName) \(serviceName)"
                print("Global.sharedInstance.hourFreeEvent \(Global.sharedInstance.hourFreeEvent)")
                print(self.hoursminutesfromString(hminutes:  myOrder.nvFromHour))
                let myarr = self.hoursminutesfromString(hminutes: myOrder.nvFromHour)
                event.notes = "Bthere"
                event.title = serviceName
                event.isAllDay = false
                var ondedate = myOrder.dtDateOrder as Date
                //clean date to dmy
                let componentsEvent = (self.calendar as NSCalendar).components([.day, .month, .year], from: ondedate)
                let gregorian = Foundation.Calendar(identifier: .gregorian)
                
                if  let _ = gregorian.date(from: componentsEvent) as Date?
                {
                    ondedate = gregorian.date(from: componentsEvent)!
                }
                if let _ = (self.calendar as NSCalendar).date(byAdding: .day, value: -1, to: ondedate) as Date?
                {
                    ondedate = (self.calendar as NSCalendar).date(byAdding: .day, value: -1, to: ondedate)!
                }
                
                var htoadd:Int = 0
                var mintoadd:Int = 0
                
                if myarr.count == 2 {
                    htoadd = myarr[0]
                    mintoadd = myarr[1]
                }
                if let _ = self.calendar.date(byAdding: .hour, value: htoadd, to:ondedate) as Date?
                {
                    ondedate =  self.calendar.date(byAdding: .hour, value: htoadd, to:ondedate)!
                }
                if let _ = self.calendar.date(byAdding: .minute, value: mintoadd, to: ondedate) as Date?
                {
                    ondedate =  self.calendar.date(byAdding: .minute, value: mintoadd, to: ondedate)!
                }
                
                event.startDate = ondedate
                print("eventBthereDateStart \( event.startDate ?? Date())")
                let enddate = self.calendar.date(byAdding: .minute, value: self.sumofservicetime, to: event.startDate )
                event.endDate = enddate!
                event.calendar = eventStore.defaultCalendarForNewEvents
                do
                {
                    try eventStore.save(event, span: .thisEvent)
                    print("success - " + event.title)
                }
                catch let e as NSError
                {
                    print(e)
                    return
                }
            }
            else
            {
                let alert = UIAlertController(title: nil, message: "REQUEST_CALENDAR_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
                })
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
