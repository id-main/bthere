//
//  PlusMenuNewSupplier.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 22/11/2018 dmy :)
//  Copyright © 2018 Bthere. All rights reserved.
// Replaces old MenuPlusViewController which anyway was obsolete

import Foundation
import UIKit
protocol reloadcalendardelegate {
    func rereadcalendar()
}
class PlusMenuNewSupplier: UIView, UIGestureRecognizerDelegate,reloadcalendardelegate {
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var greaterView: UIView!
    @IBOutlet weak var CentralButton: UIView!
    @IBOutlet weak var circlePic1: UIImageView!
    @IBOutlet weak var circlePic2: UIImageView!
    @IBOutlet weak var circlePic3: UIImageView!
    @IBOutlet weak var circlePic4: UIImageView!
    @IBOutlet weak var circlePic5: UIImageView!
    @IBOutlet weak var circlePic6: UIImageView!
    
    let calendar = Foundation.Calendar.current
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var myArrayLabels = Array<UILabel>()
    var myarrstring = Array<String>()
    var ismanager:Bool = false
    func rereadcalendar() {
        Global.sharedInstance.isProvider = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        let viewCon = SupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as!  CalendarSupplierViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        frontViewController.pushViewController(viewCon, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        myArrayLabels.append(lbl1)
        myArrayLabels.append(lbl2)
        myArrayLabels.append(lbl3)
        myArrayLabels.append(lbl4)
        myArrayLabels.append(lbl5)
        myArrayLabels.append(lbl6)

        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openSendMassNotification))
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openCustomerApproval))
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openSupplierNewEvent))
        let tap4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openCancelBlockHours))
        let tap5: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openBlockHours))
        let tap6: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openNewAppointment))
        tap1.delegate = self
        tap2.delegate = self
        tap3.delegate = self
        tap4.delegate = self
        tap5.delegate = self
        tap6.delegate = self
        view1.addGestureRecognizer(tap1)
        view2.addGestureRecognizer(tap2)
        view3.addGestureRecognizer(tap3)
        view4.addGestureRecognizer(tap4)
        view5.addGestureRecognizer(tap5)
        view6.addGestureRecognizer(tap6)
        let tapExit:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeMe))
        let tapExit1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeMe))
        CentralButton.addGestureRecognizer(tapExit)
        greaterView.addGestureRecognizer(tapExit1)
        myarrstring = []
        myarrstring = ["NEW_S_MESSAGE_TO_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                       "NEW_S_CUSTOMERS_APPROVAL".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                       "NEW_S_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                       "NEW_S_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                       "NEW_S_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                       "NEW_S_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ]
        for i in 0..<myArrayLabels.count {
            myArrayLabels[i].text = myarrstring[i]
        }
        blockInteractionForCircles(true)
        print("blocked permissions")
        checkEmployeesPermissions()

    }

    //commit comment
    func checkEmployeesPermissions()
    {
        var y:Int = 0
        var dicISMANAGERUSER:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId > 0 {
            if  Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0{
                if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                    let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                    if let x:Int = a.value(forKey: "currentUserId") as? Int{
                        y = x
                    }
                }
                dicISMANAGERUSER["iUserId"] =  y as AnyObject
                
            } else {
                dicISMANAGERUSER["iUserId"] =   Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId as AnyObject
            }
        } else {
            if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
            }
            dicISMANAGERUSER["iUserId"] =  y as AnyObject
        }
        
        //    dicISMANAGERUSER["iUserId"] =   Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId
        print("\n********************************* IsManagerUser  ********************\n")
        //  let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicISMANAGERUSER, options: NSJSONWritingOptions.PrettyPrinted)
        //   let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        //\\print(jsonString)
//        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            blockInteractionForCircles(false)
            print("no blocked permissions")
//            self.generic.hideNativeActivityIndicator(self)
            //                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.IsManagerUser(dicISMANAGERUSER, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        print("ce astepta \(String(describing: RESPONSEOBJECT["Result"]))")
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            //todo afisez eroare
                            print("eroare la IsManagerUser \(String(describing: RESPONSEOBJECT["Error"]))")
                            self.blockInteractionForCircles(false)
                            print("no blocked permissions")
                        }
                        else
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                //todo afisez eroare
//                                self.generic.hideNativeActivityIndicator(self)
                                print("eroare la IsManagerUser \(String(describing: RESPONSEOBJECT["Error"]))")
                                self.blockInteractionForCircles(false)
                                print("no blocked permissions")
                            }
                            else
                            {
                                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                {
                                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                    if myInt == 1 {
//                                        self.generic.hideNativeActivityIndicator(self)
                                        self.setupfinale(1)
                                        print("is manager")
                                    } else {
//                                        self.generic.hideNativeActivityIndicator(self)
                                        self.setupfinale(0)
                                    }
                                }
                                else
                                {
                                    self.blockInteractionForCircles(false)
                                    print("no blocked permissions")
                                }
                        }
                    }
                    else
                    {
                        self.blockInteractionForCircles(false)
                        print("no blocked permissions")
                    }
                }
                else
                {
                    self.blockInteractionForCircles(false)
                    print("no blocked permissions")
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.blockInteractionForCircles(false)
                print("no blocked permissions")
//                self.generic.hideNativeActivityIndicator(self)
                //                        if AppDelegate.showAlertInAppDelegate == false
                //                        {
                //                            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                //                            AppDelegate.showAlertInAppDelegate = true
                //                        }
            })
        }
        
    }
    
    func setupfinale(_ employeismanager: Int) {
        blockInteractionForCircles(false)
        print("no blocked permissions")
        if employeismanager == 0 {
            self.ismanager = false
            Global.sharedInstance.defaults.set(0, forKey: "ismanager") //false
            if Global.sharedInstance.employeesPermissionsArray.contains(1) == false
            {
                view6.isUserInteractionEnabled = false
                self.lbl6.textColor = .white
                circlePic6.image = UIImage(named: "psgri.png")
            }
            if Global.sharedInstance.employeesPermissionsArray.contains(2) == false
            {
                view2.isUserInteractionEnabled = false
                self.lbl2.textColor = .white
                circlePic2.image = UIImage(named: "psgri.png")
            }
            if Global.sharedInstance.employeesPermissionsArray.contains(3) == false
            {
                view1.isUserInteractionEnabled = false
                self.lbl1.textColor = .white
                circlePic1.image = UIImage(named: "psgri.png")
            }
            if Global.sharedInstance.employeesPermissionsArray.contains(5) == false
            {
                view4.isUserInteractionEnabled = false
                self.lbl4.textColor = .white
                circlePic4.image = UIImage(named: "psgri.png")
                view5.isUserInteractionEnabled = false
                self.lbl5.textColor = .white
                circlePic5.image = UIImage(named: "psgri.png")
            }
            
        } else{
            self.ismanager = true
            Global.sharedInstance.defaults.set(1, forKey: "ismanager") //false
        }
        //\\print ("self.ismanager \(self.ismanager)")
        Global.sharedInstance.defaults.synchronize()
        
//        tryGetSupplierCustomerUserIdByEmployeeId()
//        tableView.reloadData()
    }
    
    func blockInteractionForCircles(_ decision:Bool)
    {
        if decision == true
        {
            view1.isUserInteractionEnabled = false
            view2.isUserInteractionEnabled = false
            view3.isUserInteractionEnabled = false
            view4.isUserInteractionEnabled = false
            view5.isUserInteractionEnabled = false
            view6.isUserInteractionEnabled = false
        }
        else
        {
            view1.isUserInteractionEnabled = true
            view2.isUserInteractionEnabled = true
            view3.isUserInteractionEnabled = true
            view4.isUserInteractionEnabled = true
            view5.isUserInteractionEnabled = true
            view6.isUserInteractionEnabled = true
        }
    }
    
    @objc func removeMe() {
        self.removeFromSuperview()
    }
    //1
    @objc func openSendMassNotification(){
        fixPROVIDERID(whatfix: 1)

    }
    //2
    @objc func openCustomerApproval() {
        fixPROVIDERID(whatfix: 2)

    }
    //3
    @objc func openSupplierNewEvent() {
        fixPROVIDERID(whatfix: 3)

    }
    //4
    @objc func openCancelBlockHours() {
        fixPROVIDERID(whatfix: 4)

    }
    //5
    @objc func openBlockHours() {
        fixPROVIDERID(whatfix: 5)

    }
    //6
    @objc func openNewAppointment() {
        fixPROVIDERID(whatfix: 0)

    }
    func fixPROVIDERID(whatfix:Int) {
        Global.sharedInstance.whichReveal = true
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if dicUserId["currentUserId"] as! Int != 0
            {
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                api.sharedInstance.GetSupplierIdByEmployeeId(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                        {
                            let iIdBuisnessDetails :Int = (RESPONSEOBJECT["Result"] as? Int)!
                            print("sup id e ok ? " + iIdBuisnessDetails.description)
                            if iIdBuisnessDetails == 0 {

                            } else {
                                Global.sharedInstance.providerID = iIdBuisnessDetails
                                Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails = iIdBuisnessDetails

                            }
                        }
                    }

                    self.afterfixprovider(_whatfix: whatfix)

                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.afterfixprovider(_whatfix: whatfix)
                })
            }
        }
    }
    func afterfixprovider(_whatfix :Int) {
        switch (_whatfix) {
        case 0:

            let frontviewcontroller:UINavigationController? = UINavigationController()
            let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
            Global.sharedInstance.isProvider = true
            frontviewcontroller!.pushViewController(viewCon, animated: false)
            //initialize REAR View Controller- it is the LEFT hand menu.
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
        case 1:
            let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
            let viewCon:SendMassNotification = mainstoryb.instantiateViewController(withIdentifier: "SendMassNotification") as! SendMassNotification
            viewCon.view.frame = CGRect(x: 0, y:64, width:self.frame.size.width, height: self.frame.size.height - 64)
            self.parentViewController?.present(viewCon, animated: true, completion: nil)
        case 2:
            let mainstoryb = UIStoryboard(name: "SupplierExist", bundle: nil)
            let viewRegulation: CustomerApproval = mainstoryb.instantiateViewController(withIdentifier: "CustomerApprovalID")as! CustomerApproval
            viewRegulation.view.frame = CGRect(x: 0, y:64, width:self.frame.size.width, height: self.frame.size.height - 64)
            viewRegulation.modalPresentationStyle = UIModalPresentationStyle.custom
            self.parentViewController?.present(viewRegulation, animated: true, completion: nil)
        case 3:
            let mainstoryb = UIStoryboard(name: "SupplierExist", bundle: nil)
            let viewRegulation: SupplierNewEvent = mainstoryb.instantiateViewController(withIdentifier: "SupplierNewEvent")as! SupplierNewEvent
            viewRegulation.view.frame = CGRect(x: 0, y:64, width:self.frame.size.width, height: self.frame.size.height - 64)
            viewRegulation.delegatereload = self
            self.parentViewController?.present(viewRegulation, animated: true, completion: nil)
        case 4:
            let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
            let viewRegulation: BlockingHoursTableViewController = mainstoryb.instantiateViewController(withIdentifier: "BlockingHoursTableViewController")as! BlockingHoursTableViewController
            viewRegulation.view.frame = CGRect(x: 0, y:64, width:self.frame.size.width, height: self.frame.size.height - 64)
            self.parentViewController?.present(viewRegulation, animated: true, completion: nil)
        case 5:
            let mainstoryb = UIStoryboard(name: "SupplierExist", bundle: nil)
            let viewCon:BlockHoursViewController = mainstoryb.instantiateViewController(withIdentifier: "BlockHoursViewController") as! BlockHoursViewController
            viewCon.view.frame = CGRect(x: 0, y:64, width:self.frame.size.width, height: self.frame.size.height - 64)
            self.parentViewController?.present(viewCon, animated: true, completion: nil)
        default:
            print("fixed provider id: \(Global.sharedInstance.providerID)")
        }
    }
    @objc func openMyAppointments() {
        GetCustomerOrders(1)
    }
    @objc func openNewEvent () {
    }
    @objc func openCancellationView () {
        GetCustomerOrders(2)
    }
    func GetCustomerOrders(_ whichOpened:Int)
    {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject

        if Reachability.isConnectedToNetwork() == false
        {

            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetCustomerOrdersNoLogo(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    let ps:OrderDetailsObj = OrderDetailsObj()
                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                        Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    }
                    if Global.sharedInstance.ordersOfClientsArray.count != 0
                    {
                        var filteredarray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()
                        for item in Global.sharedInstance.ordersOfClientsArray {
                            if (!self.hourisless(item) && self.isdateequal(item) ) || self.isdateafter(item) {
                                if item.nvComment != "BlockedBySupplier" {
                                    if !filteredarray.contains(item) {
                                        filteredarray.append(item)
                                    }
                                }
                            }
                            filteredarray =   filteredarray.sorted(by: { ($1 ).dtDateOrder > ($0 ).dtDateOrder })
                            Global.sharedInstance.ordersOfClientsArray = filteredarray
                        }
                        let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                        let viewCon:myAppointmentsViewController = clientStoryBoard.instantiateViewController(withIdentifier: "myAppointmentsViewController") as! myAppointmentsViewController
                        viewCon.whichOpenMe = whichOpened
                        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                        self.parentViewController?.present(viewCon, animated: true, completion: nil)
                    }
                    else
                    {
                        Alert.sharedInstance.showAlertDelegate("NO_APPOINTMENTS__FROM_YOU".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                //                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))

            })
        }
    }
    func hourisless (_ itemx: OrderDetailsObj) -> Bool {
        var islessh:Bool  = false
        var eventHour:Int = 0
        var eventMinutes:Int = 0
        //   if itemx.iCoordinatedServiceId > 0 { don't care all events has starting and ending hours and hollydays are in separated array
        if let a1:Character =  itemx.nvFromHour[itemx.nvFromHour.startIndex] as Character? {
            if a1 == "0" {
                //now get the real hour
                if let a2:Character =  itemx.nvFromHour[itemx.nvFromHour.index(itemx.nvFromHour.startIndex, offsetBy: 1)] as Character?{
                    if a2 == "0" {
                        print("ora1 0 add to 0")
                        eventHour = 0
                    }
                    else {
                        print("ora1 \(a2) add to \(a2)") //section
                        let str = String(a2)
                        let IntHOUR:Int = Int(str)!
                        eventHour = IntHOUR

                    }
                }
            }
            else { //full hour 2 chars
                let fullNameArr = itemx.nvFromHour.components(separatedBy: ":")
                let size = fullNameArr.count
                if(size > 1 ) {
                    if let _:String = fullNameArr[0] as String? {
                        let hourstring:String = fullNameArr[0]
                        let numberFromString:Int = Int(hourstring)!
                        eventHour = numberFromString
                    }
                }
            }
        }
        // }
        let componentsToday = (calendar as NSCalendar).components([.hour, .minute], from: Date())
        let minutulacum = componentsToday.minute
        let oraacum = componentsToday.hour

        if eventHour < oraacum! {
            islessh = true
        } else  if eventHour == oraacum {
            //minutes compare
            let fullNameArr = itemx.nvFromHour.components(separatedBy: ":")
            let size = fullNameArr.count
            if(size > 1 ) {
                if let _:String = fullNameArr[1] as String? {
                    let hourstring:String = fullNameArr[1]
                    if let a1:Character =  hourstring[hourstring.startIndex] as Character? {
                        if a1 == "0" {
                            //now get the real minute
                            if let a2:Character =  hourstring[hourstring.index(hourstring.startIndex, offsetBy: 1)] as Character? {
                                if a2 == "0" {
                                    print("minutul 0 add to 0")
                                    eventMinutes = 0
                                }
                                else {
                                    print("minutul \(a2) add to \(a2)") //section
                                    let str = String(a2)
                                    let IntHOUR:Int = Int(str)!
                                    eventMinutes = IntHOUR

                                }
                            }
                        }
                        else { //full minutes 2 chars
                            let fullNameArr = itemx.nvFromHour.components(separatedBy: ":")
                            let size = fullNameArr.count
                            if(size > 1 ) {
                                if let _:String = fullNameArr[1]  as String? {
                                    let hourstring:String = fullNameArr[1]
                                    let numberFromString:Int = Int(hourstring)!
                                    eventMinutes = numberFromString
                                }
                            }
                        }
                    }
                }
            }
            if eventMinutes < minutulacum! {
                islessh = true
            } else {
                islessh = false
            }
        }


        else {
            islessh = false
        }
        //\\print ("oraacum \(oraacum) - minutulacum \(minutulacum) si eventHour \(eventHour)  eventMinutes \(eventMinutes) ")

        return islessh
    }
    func isdateafter (_ itemx: OrderDetailsObj) -> Bool {
        var isafter:Bool  = false
        let eventDay:Date = itemx.dtDateOrder as Date
        //\\print ("eventday \(eventDay)")
        let todayStart:Date = Date()
        if eventDay.compare(todayStart) == ComparisonResult.orderedDescending
        {
            NSLog("date1 after date2");
            isafter = true

        } else if eventDay.compare(todayStart) == ComparisonResult.orderedAscending
        {
            NSLog("date1 before date2");
            isafter = false
        } else
        {
            NSLog("dates are equal");
            isafter = false
        }

        return isafter
    }
    func isdateequal (_ itemx: OrderDetailsObj) -> Bool {
        var isafter:Bool  = false
        let eventDay:Date = itemx.dtDateOrder as Date
        //\\print ("eventday \(eventDay)")
        let todayStart:Date = Date()
        if eventDay.compare(todayStart) == ComparisonResult.orderedDescending
        {
            NSLog("date1 after date2");
            isafter = false

        } else if eventDay.compare(todayStart) == ComparisonResult.orderedAscending
        {
            NSLog("date1 before date2");
            isafter = false
        } else
        {
            NSLog("dates are equal");
            isafter = true
        }

        return isafter
    }
}
