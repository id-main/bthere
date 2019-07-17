//
//  MenuTableViewController.swift
//  bthree-ios
//
//  Created by User on 22.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//תפריט צד


class MenuTableViewController: UITableViewController {
    var trialdetails:Array<Int> = Array<Int>()
    let calendar = Foundation.Calendar.current
    var viewpopupReport: ReportLastSixmonthsViewController!
    var isLOCKEDREGISTRATION:Bool = true
    var viewpopupAccessCode : popupAccessCode!
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var subView:UIView = UIView()
    var view3 :RegisterBuisnessProphielViewController!
    var revealController: SWRevealViewController!
    var frontViewController: UIViewController!
    var frontNavigationController: UINavigationController? = nil
    var storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
    var generic = Generic()
    //    var arrayString:Array<String> = ["MY_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MY_GIVESERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE),/*"Notifications",*/ "ABOUT_US".localized(LanguageMain.sharedInstance.USERLANGUAGE),"REGISTER_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"print".localized(LanguageMain.sharedInstance.USERLANGUAGE),"HELP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var arrayString:Array<String> = ["MY_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MY_GIVESERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE),/*"Notifications",*/ "ABOUT_US".localized(LanguageMain.sharedInstance.USERLANGUAGE),"REGISTER_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"HELP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE)]


    // Old array for customer language
    // var arrayString:Array<String> = ["MY_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MY_GIVESERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ABOUT_US".localized(LanguageMain.sharedInstance.USERLANGUAGE),"REGISTER_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"print".localized(LanguageMain.sharedInstance.USERLANGUAGE),"LOG_OUT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    //["MY_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MY_GIVESERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ABOUT_US".localized(LanguageMain.sharedInstance.USERLANGUAGE),"REGISTER_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"//\\print".localized(LanguageMain.sharedInstance.USERLANGUAGE),"LOG_OUT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    // Old array for supplier language
    // var arrayStringSupplierExist = ["MY_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE),"BUSINESS_PAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"REPORTS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ABOUT_US".localized(LanguageMain.sharedInstance.USERLANGUAGE),"print".localized(LanguageMain.sharedInstance.USERLANGUAGE),"LOG_OUT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    var arrayStringSupplierExist =
        ["MY_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE),"BUSINESS_PAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"NOTIFICATIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"REPORTS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ABOUT_US".localized(LanguageMain.sharedInstance.USERLANGUAGE),"print".localized(LanguageMain.sharedInstance.USERLANGUAGE),"HELP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    // var arrayImages:Array<String> = ["myCalendar@x1.png","clients@x1.png","settings@x1.png","aboutUs@x1.png","registerAsSupplier.png","print@x1.png","signOut@x1.png"]

    var arrayImages:Array<String> = ["ccalendar-1.png","cservice-providers-1.png","settings-1.png",/*"notifications_J.png",*/"cabout-us-1.png","cregister-business-1.png",/*"cprint.png",*/"newHelpIcon.png"]
    // Customer old array
    // var arrayImages:Array<String> = ["ccalendar-1.png","cservice-providers-1.png","settings-1.png","cabout-us-1.png","cregister-business-1.png","cprint.png","clog-out-1.png"]

    var arrayImagesSupplierExist:Array<String> = ["ccalendar-1.png","cprofile.png","cservice-providers-1.png","settings-1.png","notifications_J.png","ppstatistics.png","cabout-us-1.png","cprint.png","newHelpIcon.png"] //fix
    // Supplier old array
    // var arrayImagesSupplierExist:Array<String> = ["ccalendar-1.png","cprofile.png","cservice-providers-1.png","settings-1.png","ppstatistics.png","cabout-us-1.png","cprint.png","clog-out-1.png"] //fix

    var separatorView: UIView = UIView()
    var isemploye:Bool = false // is  employe
    var ismanager:Bool = false //is employe and manager
    var issimpleCustomer:Bool = true //is simple customer
    var providerID:Int = 0

    //MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.readTrial()
        print("Global.sharedInstance.defaults.objectForKey: currentUserId \(Global.sharedInstance.defaults.object(forKey: "currentUserId"))")
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.currentUser.nvPhone != "" {
            generic.showNativeActivityIndicator(self)
            dictionaryForServer["nvPhone"] =  Global.sharedInstance.currentUser.nvPhone as AnyObject
            if Reachability.isConnectedToNetwork() == false
            {
                generic.hideNativeActivityIndicator(self)

            }
            else
            {
                api.sharedInstance.GetEmployeeDataByPhone(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>

                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                print("EMPLOYE_EXIST_in_db" ?? "1")
                            } else {
                                //employe was deleted
                                Global.sharedInstance.defaults.set(0, forKey: "firstpopup_welcomeBusinessalreadyseen")
                                Global.sharedInstance.defaults.set(0, forKey: "wasshownwelcometoBthere")
                                Global.sharedInstance.defaults.set(0, forKey: "firstpopup_addEmployeesalreadyseen")
                                Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
                                Global.sharedInstance.defaults.set(0, forKey: "ismanager")
                                Global.sharedInstance.defaults.set(1, forKey: "issimpleCustomer") //indeed
                                Global.sharedInstance.defaults.set(0, forKey: "isemploye")
                                Global.sharedInstance.defaults.removeObject(forKey: "providerDic")
                                Global.sharedInstance.defaults.removeObject(forKey: "isSupplierRegistered")
                                Global.sharedInstance.defaults.removeObject(forKey: "supplierNameRegistered")
                                Global.sharedInstance.currentProviderDetailsObj = ProviderDetailsObj()
                                Global.sharedInstance.isFIRSTREGISTER = false
                                Global.sharedInstance.defaults.set(0, forKey:"ISFROMSETTINGS")
                                Global.sharedInstance.defaults.synchronize()
                            }
                        }
                    }
                    self.generic.hideNativeActivityIndicator(self)
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                })

            }
        }
        //check if is customer, worker or manager
        if Global.sharedInstance.providerID == 0 && Global.sharedInstance.isInMeetingProcess == 0 {
            //21.03.2017GetSupplierIdByEmployeeId
            if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
            {
                var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                if dicUserId["currentUserId"] as! Int != 0
                {
                    //קבלת פרטי הלקוח
                    var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                    dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                    api.sharedInstance.GetSupplierIdByEmployeeId(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let resultInteger :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                print("sup id e ok ? " + resultInteger.description)
                                if resultInteger == 0 {
                                    //NO EMPL NO BUSINESS
                                    self.setupdefaults(0)
                                } else {
                                    self.setupdefaults(resultInteger)
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        //                        if AppDelegate.showAlertInAppDelegate == false
                        //                        {
                        //                            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        //                            AppDelegate.showAlertInAppDelegate = true
                        //                        }
                    })
                }
            }
        } else {
            if Global.sharedInstance.isInMeetingProcess == 0
            {
                self.setupdefaults(Global.sharedInstance.providerID)
            }

        }
        print("Global.sharedInstance.providerID 2: \(Global.sharedInstance.providerID)")
    }
    func setupfinale(_ employeismanager: Int) {
        if employeismanager == 0 {
            self.ismanager = false
            Global.sharedInstance.defaults.set(0, forKey: "ismanager") //false
        } else{
            self.ismanager = true
            Global.sharedInstance.defaults.set(1, forKey: "ismanager") //false
        }
        //\\print ("self.ismanager \(self.ismanager)")
        Global.sharedInstance.defaults.synchronize()
        tryGetSupplierCustomerUserIdByEmployeeId()
        tableView.reloadData()
    }
    func tryGetSupplierCustomerUserIdByEmployeeId() {
        var userID:Int = 0
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let currentUserID:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let userIdInteger:Int = currentUserID.value(forKey: "currentUserId") as? Int{
                userID = userIdInteger
            }
        }
        dictionaryForServer["iUserId"] =  userID as AnyObject
        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                {
                    let resultInteger :Int = (RESPONSEOBJECT["Result"] as? Int)!
                    print("sup id e ok ? " + resultInteger.description)
                    if resultInteger == 0 {
                        //NO EMPL NO BUSINESS
                        self.setupdefaults(0)
                        //\\print ("no business")
                    } else {
                        //self.setupdefaults(myInt)
                        api.sharedInstance.GetSecondUserIdByFirstUserId(userID)
                        self.callgetprovideralldetails(resultInteger)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            //            if AppDelegate.showAlertInAppDelegate == false
            //            {
            //                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            //                AppDelegate.showAlertInAppDelegate = true
            //            }
        })
    }
//    func callgetprovideralldetails(_ iUseridSupplier:Int) {
        func callgetprovideralldetails(_ iUseridSupplier:Int) {
            if Global.sharedInstance.whichReveal == true {
                api.sharedInstance.getProviderAllDetailsbyEmployeID(iUseridSupplier)
            }
        }
//    }


    func setupdefaults(_ providerIDD: Int) {
        print("whre is this")
        if providerIDD == 0 {
            //no bussiness simple customer
            self.issimpleCustomer = true
            self.isemploye = false
            Global.sharedInstance.providerID = 0
            Global.sharedInstance.defaults.set(1, forKey: "issimpleCustomer") //true
            Global.sharedInstance.defaults.set(0, forKey: "isemploye") //false
        } else {
            self.issimpleCustomer = false
            self.isemploye = true
            Global.sharedInstance.providerID = providerIDD
            Global.sharedInstance.defaults.set(0, forKey: "issimpleCustomer") //false
            Global.sharedInstance.defaults.set(1, forKey: "isemploye") //true
        }
        Global.sharedInstance.defaults.synchronize()
        print("providerIDD \(Global.sharedInstance.providerID)")
        if  self.isemploye == true {
            if Reachability.isConnectedToNetwork() == false
            {
                //                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else {
                var userID:Int = 0
                var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                if Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId > 0 {
                    if  Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0{
                        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                            let currentUserId:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                            if let userIdInteger:Int = currentUserId.value(forKey: "currentUserId") as? Int{
                                userID = userIdInteger
                            }
                        }
                        dictionaryForServer["iUserId"] =  userID as AnyObject

                    } else {
                        dictionaryForServer["iUserId"] =   Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId as AnyObject
                    }
                } else {
                    if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                        let userIDictionary:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                        if let userIdInteger:Int = userIDictionary.value(forKey: "currentUserId") as? Int{
                            userID = userIdInteger
                        }
                    }
                    dictionaryForServer["iUserId"] =  userID as AnyObject
                }

                //    dicISMANAGERUSER["iUserId"] =   Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId
                print("\n********************************* IsManagerUser  ********************\n")
                //  let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicISMANAGERUSER, options: NSJSONWritingOptions.PrettyPrinted)
                //   let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
                //\\print(jsonString)
                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)
                    //                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else
                {
                    api.sharedInstance.IsManagerUser(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                                print("ce astepta \(String(describing: RESPONSEOBJECT["Result"]))")
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                                {
                                    //todo afisez eroare
                                    print("eroare la IsManagerUser \(String(describing: RESPONSEOBJECT["Error"]))")
                                }
                                else
                                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                                    {
                                        //todo afisez eroare
                                        self.generic.hideNativeActivityIndicator(self)
                                        print("eroare la IsManagerUser \(String(describing: RESPONSEOBJECT["Error"]))")
                                    }
                                    else
                                    {
                                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                        {
                                            let resultServer :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                            if resultServer == 1 {
                                                self.generic.hideNativeActivityIndicator(self)
                                                self.setupfinale(1)
                                                print("is manager")
                                            } else {
                                                self.generic.hideNativeActivityIndicator(self)
                                                self.setupfinale(0)
                                            }
                                        }
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        //                        if AppDelegate.showAlertInAppDelegate == false
                        //                        {
                        //                            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        //                            AppDelegate.showAlertInAppDelegate = true
                        //                        }
                    })
                }
            }
        }
    }
    func checkisLOCKEDREGISTRATION() {
        let dictionaryForServer:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetIsBlockSupReg(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("haree \(RESPONSEOBJECT)")
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else   if let _:Int = RESPONSEOBJECT["Result"] as? Int {
                        let resultServer :Int = (RESPONSEOBJECT["Result"] as? Int)!
                        print("sup id e ok ? " + resultServer.description)
                        if resultServer == 0 {
                            self.isLOCKEDREGISTRATION = false
                        } else{
                            self.isLOCKEDREGISTRATION = true
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                print("Eroare \(Error!.localizedDescription)")
            })
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        //     self.checkisLOCKEDREGISTRATION()

        self.view.backgroundColor = Colors.sharedInstance.color5

        if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P{
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 285
            self.revealViewController().frontViewShadowColor = UIColor.clear
        }
        else if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 230
            self.revealViewController().frontViewShadowColor = UIColor.clear
        }
        if Global.sharedInstance.whichReveal == false
        {
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        // self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillLayoutSubviews() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        let y = bounds.origin.y
        //width: width*0.8
        self.view.superview!.bounds = CGRect(x:bounds.origin.x + 30 ,y:y, width: width-180,height: height
        )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.delegate = self
        tableView.dataSource = self
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Global.sharedInstance.whichReveal == false{
            return arrayString.count
        }
        return arrayStringSupplierExist.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = Colors.sharedInstance.color5
        if Global.sharedInstance.whichReveal == false
        {
            //iustin
            //            switch indexPath.row {
            //            case 5:
            //                cell.isUserInteractionEnabled = false
            //                cell.backgroundColor = Colors.sharedInstance.color6
            //            default : cell.isUserInteractionEnabled = true
            //            cell.backgroundColor = Colors.sharedInstance.color5
            //            }
            cell.setDisplayData(arrayString[indexPath.row], image: arrayImages[indexPath.row])
            //            if indexPath.row == 5
            //            {
            //            cell.viewButtom.hidden = true
            //            }
            //            else
            //            {
            cell.viewButtom.isHidden = false
            //            }
        }
        else
        {
            cell.setDisplayData(arrayStringSupplierExist[indexPath.row], image: arrayImagesSupplierExist[indexPath.row])
            cell.isUserInteractionEnabled = true
            cell.backgroundColor = Colors.sharedInstance.color5
             if  Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1{

                cell.isUserInteractionEnabled = true
                cell.backgroundColor = Colors.sharedInstance.color5
            }
            else
            {
                if indexPath.row == 1 || indexPath.row == 5  {
                    cell.isUserInteractionEnabled = false
                    cell.backgroundColor = Colors.sharedInstance.color6
                }
            }
            if indexPath.row == (arrayStringSupplierExist.count - 1)
            {
                cell.viewButtom.isHidden = true
            }
            else
            {
                cell.viewButtom.isHidden = false
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let revealController: SWRevealViewController = self.revealViewController()
        let frontViewController: UIViewController = revealController.frontViewController
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        if (frontViewController.isKind(of: UINavigationController.self)){
            frontNavigationController = (frontViewController as AnyObject) as? UINavigationController
        }
        //שיעשה clear למי שבחרו קודם
        tableView.reloadData()

        if Global.sharedInstance.whichReveal == false//לקוח
        {
            tableView.cellForRow(at: indexPath)!.backgroundColor = Colors.sharedInstance.color3
            switch indexPath.row
            {
            case 0://היומן שלי
                Global.sharedInstance.isFromMenu = true
                //
                let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                //                if let topController = UIApplication.topViewController() {
                //                self.generic.showNativeActivityIndicator(topController)
                //            }
                let CalendarSupplier: ModelCalenderViewController = clientStoryBoard.instantiateViewController(withIdentifier: "ModelCalenderViewController")as! ModelCalenderViewController
                let navigationController: UINavigationController = UINavigationController(rootViewController: CalendarSupplier)
                revealController.pushFrontViewController(navigationController, animated: false)
                revealController.revealToggle(animated: true)//(בגלל שלמעלה ה- animated: false)שיסגור את התפריט ולא ישאיר אותו פתוח בצד
                Global.sharedInstance.isFromprintCalender = false
                Global.sharedInstance.whichDesignOpenDetailsAppointment = 0



            case 1://נותני השרות שלי
                let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                let giveMyServices:giveMyServicesViewController = clientStoryBoard.instantiateViewController(withIdentifier: "giveMyServicesViewController")as! giveMyServicesViewController
                let navigationController: UINavigationController = UINavigationController(rootViewController: giveMyServices)
                revealController.pushFrontViewController(navigationController, animated: false)
                revealController.revealToggle(animated: true)//שיסגור את התפריט ולא ישאיר אותו פתוח בצד
                break

            case 2://הגדרות
                Global.sharedInstance.isProvider = false
                let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                let DefinationsClient: CustomerSettings = clientStoryBoard.instantiateViewController(withIdentifier: "CustomerSettings")as! CustomerSettings
                let navigationController: UINavigationController = UINavigationController(rootViewController: DefinationsClient)
                revealController.pushFrontViewController(navigationController, animated: false)
                revealController.revealToggle(animated: true)//שיסגור את התפריט ולא ישאיר אותו פתוח בצד
                break
                //            case 3:
                //                let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
                //                let viewRegulation: NotificationListViewController = mainstoryb.instantiateViewControllerWithIdentifier("NotificationListViewController")as! NotificationListViewController
                //                viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
                //                viewRegulation.modalPresentationStyle = UIModalPresentationStyle.Custom
            //                self.presentViewController(viewRegulation, animated: true, completion: nil)
            case 3://אודותינו
                let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                let aboutUs: AboutUsClientViewController = clientStoryBoard.instantiateViewController(withIdentifier: "AboutUsClientViewController")as! AboutUsClientViewController
                let navigationController: UINavigationController = UINavigationController(rootViewController: aboutUs)
                revealController.pushFrontViewController(navigationController, animated: false)
                revealController.revealToggle(animated: true)
////                    let myViewController = AdjustYourCalendarViewController(nibName: "AdjustYourCalendarViewController", bundle: nil)
////                    myViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
////                    let navigationController: UINavigationController = UINavigationController(rootViewController: myViewController)
////                                    revealController.pushFrontViewController(navigationController, animated: false)
////                                    revealController.revealToggle(animated: true)
////                    self.present(myViewController, animated: true, completion: nil)
//                let myViewController = AdjustYourCalendarViewController(nibName: "AdjustYourCalendarViewController", bundle: nil)
//                myViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
//                self.present(myViewController, animated: true, completion: nil)
                
                break
            case 4://הרשם כעסק
                let USERDEF = UserDefaults.standard
                print(USERDEF.integer(forKey: "iSupplierStatus"))
                //   TEST MODE ONLY USERDEF.set(2, forKey: "iSupplierStatus")
                //   TEST MODE ONLY USERDEF.synchronize()
                //Global.sharedInstance.defaults.set(iSyncedStatus,  forKey: "iSyncedStatus")
                if  USERDEF.object(forKey: "iSupplierStatus") != nil && Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil {
                    print(USERDEF.integer(forKey: "iSupplierStatus"))
                    print(USERDEF.integer(forKey: "iSyncedStatus"))
                    //                    myArr.append(APPDELiTrialDays)
                    //                    myArr.append(diff!)
                    //                    self.trialdetails = myArr
                    if self.trialdetails.count == 2 {
                        let whatstatus = self.trialdetails[0]
                        if whatstatus > 0  { // user has trial days from server
                            let diff = self.trialdetails[1] // number of days in difference from datetrial start to current date
                            if diff <= 0 {
                                Global.sharedInstance.isProvider = false
                                //   Alert.sharedInstance.showAlert("PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                                {
                                    let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                                    let paragraphStyle = NSMutableParagraphStyle()
                                    // Here is the key thing!
                                    paragraphStyle.alignment = .right

                                    let messageText = NSMutableAttributedString(
                                        string: "PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                        attributes: convertToOptionalNSAttributedStringKeyDictionary([
                                            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                                            convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                                            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                                        ])
                                    )

                                    alertView.setValue(messageText, forKey: "attributedMessage")

                                    self.present(alertView, animated: true, completion: nil)
                                } else {
                                    let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                                    let paragraphStyle = NSMutableParagraphStyle()
                                    // Here is the key thing!
                                    paragraphStyle.alignment = .left

                                    let messageText = NSMutableAttributedString(
                                        string: "PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                        attributes: convertToOptionalNSAttributedStringKeyDictionary([
                                            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                                            convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                                            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                                        ])
                                    )

                                    alertView.setValue(messageText, forKey: "attributedMessage")

                                    self.present(alertView, animated: true, completion: nil)
                                }
                                //                            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                                //                            let storyboard = UIStoryboard(name: "Testing", bundle: nil)
                                //                            let frontViewController = storyboard1.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                                //                            let viewCon = storyboard.instantiateViewController(withIdentifier: "popupTrialExpired") as!  popupTrialExpired
                                //                            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                                //                            frontViewController.pushViewController(viewCon, animated: false)
                                //                            let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                //                            let mainRevealController = SWRevealViewController()
                                //                            mainRevealController.frontViewController = frontViewController
                                //                            mainRevealController.rearViewController = rearViewController
                                //                            let window :UIWindow = UIApplication.shared.keyWindow!
                                //                            window.rootViewController = mainRevealController
                                return
                            }
                        } else {
                            //nothing ..
                        }
                    }

                    if USERDEF.integer(forKey: "iSupplierStatus") == 2 {
                        //contacts sync but trial expired
                        //      Alert.sharedInstance.showAlert("PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                        {
                            let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                            let paragraphStyle = NSMutableParagraphStyle()
                            // Here is the key thing!
                            paragraphStyle.alignment = .right

                            let messageText = NSMutableAttributedString(
                                string: "PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                attributes: convertToOptionalNSAttributedStringKeyDictionary([
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                                ])
                            )

                            alertView.setValue(messageText, forKey: "attributedMessage")

                            self.present(alertView, animated: true, completion: nil)
                        } else {
                            let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                            let paragraphStyle = NSMutableParagraphStyle()
                            // Here is the key thing!
                            paragraphStyle.alignment = .left

                            let messageText = NSMutableAttributedString(
                                string: "PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                attributes: convertToOptionalNSAttributedStringKeyDictionary([
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                                ])
                            )

                            alertView.setValue(messageText, forKey: "attributedMessage")

                            self.present(alertView, animated: true, completion: nil)
                        }
                        //                        Global.sharedInstance.isProvider = false
                        //                        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                        //                        let storyboard = UIStoryboard(name: "Testing", bundle: nil)
                        //                        let frontViewController = storyboard1.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                        //                        let viewCon = storyboard.instantiateViewController(withIdentifier: "popupTrialExpired") as!  popupTrialExpired
                        //                        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                        //                        frontViewController.pushViewController(viewCon, animated: false)
                        //                        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                        //                        let mainRevealController = SWRevealViewController()
                        //                        mainRevealController.frontViewController = frontViewController
                        //                        mainRevealController.rearViewController = rearViewController
                        //                        let window :UIWindow = UIApplication.shared.keyWindow!
                        //                        window.rootViewController = mainRevealController
                        return
                    }
                    if  USERDEF.integer(forKey: "iSupplierStatus") == 0 {
                        //no contacts sync
                        if USERDEF.integer(forKey: "iSyncedStatus") == 0 {
                            //contacts sync but no payment
                            Global.sharedInstance.isProvider = false
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let storyboardone = UIStoryboard(name: "SupplierExist", bundle: nil)
                            let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                            let viewCon = storyboardone.instantiateViewController(withIdentifier: "SyncContactsRegistrationViewContoller") as!  SyncContactsRegistrationViewContoller
                            viewCon.isfromcustomer = true
                            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                            frontViewController.pushViewController(viewCon, animated: false)
                            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                            let mainRevealController = SWRevealViewController()
                            mainRevealController.frontViewController = frontViewController
                            mainRevealController.rearViewController = rearViewController
                            let window :UIWindow = UIApplication.shared.keyWindow!
                            window.rootViewController = mainRevealController
                            return
                        }
                        if USERDEF.integer(forKey: "iSyncedStatus") == 1 {
                            //contacts sync but no payment
                            /*
                             Global.sharedInstance.isProvider = false
                             let storyboard = UIStoryboard(name: "Main", bundle: nil)
                             let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                             let viewCon = storyboard.instantiateViewController(withIdentifier: "PaymentForm") as!  PaymentForm
                             viewCon.isfromSuppierSettings = false
                             viewCon.isFROMCUSTOMER = true
                             viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                             frontViewController.pushViewController(viewCon, animated: false)
                             let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                             let mainRevealController = SWRevealViewController()
                             mainRevealController.frontViewController = frontViewController
                             mainRevealController.rearViewController = rearViewController
                             let window :UIWindow = UIApplication.shared.keyWindow!
                             window.rootViewController = mainRevealController */
                            //   Alert.sharedInstance.showAlert("PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                            {
                                let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                                let paragraphStyle = NSMutableParagraphStyle()
                                // Here is the key thing!
                                paragraphStyle.alignment = .right

                                let messageText = NSMutableAttributedString(
                                    string: "PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                    attributes: convertToOptionalNSAttributedStringKeyDictionary([
                                        convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                                        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                                        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                                    ])
                                )

                                alertView.setValue(messageText, forKey: "attributedMessage")

                                self.present(alertView, animated: true, completion: nil)
                            } else {
                                let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                                let paragraphStyle = NSMutableParagraphStyle()
                                // Here is the key thing!
                                paragraphStyle.alignment = .left

                                let messageText = NSMutableAttributedString(
                                    string: "PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                    attributes: convertToOptionalNSAttributedStringKeyDictionary([
                                        convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                                        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                                        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                                    ])
                                )

                                alertView.setValue(messageText, forKey: "attributedMessage")

                                self.present(alertView, animated: true, completion: nil)
                            }
                            return
                        }

                        //  Alert.sharedInstance.showAlert("PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        //   return

                    } else  if  USERDEF.integer(forKey: "iSupplierStatus") == 1 {
                        //make sure this supplier has no trial ended

                        Alert.sharedInstance.showAlert("REGISTERED_AS_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    }
                } else

                    if Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil
                    {
                        let dicClientName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") as! Dictionary<String,String>
                        if dicClientName["nvSupplierName"] == ""//אם אינו רשום כעסק
                        {
                            Global.sharedInstance.defaults.set(0, forKey: "ISFROMSETTINGS")
                            Global.sharedInstance.defaults.synchronize()
                            let viewCon:RgisterModelViewController = self.storyboard?.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
                            let viewCon1:GlobalDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
                            viewCon.delegateFirstSection = viewCon1
                            viewCon.delegateSecond1Section = viewCon1
                            let front = self.storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                            front.pushViewController(viewCon, animated: false)
                            let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                            let mainRevealController = SWRevealViewController()
                            mainRevealController.frontViewController = front
                            mainRevealController.rearViewController = rearViewController
                            let window :UIWindow = UIApplication.shared.keyWindow!
                            window.rootViewController = mainRevealController
                        }
                        else
                        {
                            Alert.sharedInstance.showAlert("REGISTERED_AS_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        }
                    }
                    else //אם אינו רשום כעסק
                    {
                        // 1. is locked register business
                        //                    if self.isLOCKEDREGISTRATION == true {
                        //                        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                        //                        viewpopupAccessCode = storyboardtest.instantiateViewController(withIdentifier: "popupAccessCode") as! popupAccessCode
                        //                        if self.iOS8 {
                        //                            viewpopupAccessCode.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        //                        } else {
                        //                            viewpopupAccessCode.modalPresentationStyle = UIModalPresentationStyle.currentContext
                        //                        }
                        //
                        //                        self.present(viewpopupAccessCode, animated: true, completion: nil)
                        //                    }else {
                        //2. register business not locked
                        Global.sharedInstance.defaults.set(0, forKey: "ISFROMSETTINGS")
                        Global.sharedInstance.defaults.synchronize()

                        Global.sharedInstance.isProvider = true
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewCon:RgisterModelViewController = storyboard.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
                        let viewCon1:GlobalDataViewController = storyboard.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
                        viewCon.delegateFirstSection = viewCon1
                        viewCon.delegateSecond1Section = viewCon1
                        let front = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                        front.pushViewController(viewCon, animated: false)
                        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                        let mainRevealController = SWRevealViewController()
                        mainRevealController.frontViewController = front
                        mainRevealController.rearViewController = rearViewController
                        let window :UIWindow = UIApplication.shared.keyWindow!
                        window.rootViewController = mainRevealController


                        //      }
                }
                //iustin
                //            case 5://הדפס
                //                let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                //                let printCalendar: PrintCalendarViewController = clientStoryBoard.instantiateViewController(withIdentifier: "PrintCalendarViewController")as! PrintCalendarViewController
                //                revealController.present(printCalendar, animated: true, completion: nil)
                //                revealController.revealToggle(animated: true)//שיסגור את התפריט ולא ישאיר אותו פתוח בצד
            //                break
            case 5://התנתק
                //                Global.sharedInstance.logoutUSER()
                let clientStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
                let viewCon:NewHelpViewController = clientStoryBoard.instantiateViewController(withIdentifier: "NewHelpViewController") as! NewHelpViewController
                revealController.present(viewCon, animated: true, completion: nil)
                revealController.revealToggle(animated: true)//שיסגור את התפריט ולא ישאיר אותו פתוח בצד
                break

            default:
                break
            }
        }
        else//ספק
        {
               NotificationCenter.default.post(name: Notification.Name("DismissEditCityorAddress"), object: nil)
            tableView.cellForRow(at: indexPath)!.backgroundColor = Colors.sharedInstance.color4

            switch indexPath.row {
            case 0:
                fixPROVIDERID(whatfix: 0)
            case 1:
                fixPROVIDERID(whatfix: 1)
            case 2:
                fixPROVIDERID(whatfix: 2)
            case 3:
                fixPROVIDERID(whatfix: 3)
            case 4:
                fixPROVIDERID(whatfix: 4)
            case 5:
                fixPROVIDERID(whatfix: 5)
            case 6:
                fixPROVIDERID(whatfix: 6)
            case 7:
                fixPROVIDERID(whatfix: 7)
            case 8:
                fixPROVIDERID(whatfix: 8)
            case 9:
                fixPROVIDERID(whatfix: 9)

            default: break
            }
        }
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
                            let responseResult :Int = (RESPONSEOBJECT["Result"] as? Int)!
                            print("sup id e ok ? " + responseResult.description)
                            if responseResult == 0 {

                            } else {
                                Global.sharedInstance.providerID = responseResult
                                Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails = responseResult

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
        let revealController: SWRevealViewController = self.revealViewController()
        let frontViewController: UIViewController = revealController.frontViewController

        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        switch (_whatfix) {
        case 0:
            Global.sharedInstance.isFromMenu = true
            //aici iustin
            let CalendarSupplier: CalendarSupplierViewController = storybrd.instantiateViewController(withIdentifier: "CalendarSupplierViewController")as! CalendarSupplierViewController
            let navigationController: UINavigationController = UINavigationController(rootViewController: CalendarSupplier)
            revealController.pushFrontViewController(navigationController, animated: false)
            revealController.revealToggle(animated: true)
            Global.sharedInstance.isFromprintCalender = false
        case 1:
            Global.sharedInstance.defaults.set(1, forKey: "ISFROMMENU")
            Global.sharedInstance.defaults.synchronize()
            let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
            let giveregisterprofile:RegisterBuisnessProphielViewController = storyboardMain.instantiateViewController(withIdentifier: "RegisterBuisnessProphielViewController") as! RegisterBuisnessProphielViewController
            let navigationController: UINavigationController = UINavigationController(rootViewController: giveregisterprofile)
            revealController.pushFrontViewController(navigationController, animated: false)
//            revealController.revealToggle(animated: true)
            if (self.revealViewController()?.frontViewPosition == FrontViewPosition.right)
            {
                self.revealViewController()?.revealToggle(animated: true)
            }
        case 2:
            let MyCostumers: MyCostumersViewController = storybrd.instantiateViewController(withIdentifier: "MyCostumersViewController")as! MyCostumersViewController
            let navigationController: UINavigationController = UINavigationController(rootViewController: MyCostumers)
            revealController.pushFrontViewController(navigationController, animated: false)
            revealController.revealToggle(animated: true)
        case 3:
//            if self.ismanager == false {
//            }
//            if self.ismanager == true {
                //  let DefinationsController: DefinationsViewController = storybrd.instantiateViewControllerWithIdentifier("DefinationsViewController")as! DefinationsViewController
                let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
                let navigationController: UINavigationController = UINavigationController(rootViewController: viewcon)
                revealController.pushFrontViewController(navigationController, animated: false)
                revealController.revealToggle(animated: true)
//            }
        case 4:
            let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
            let viewRegulation: NotificationListViewController = mainstoryb.instantiateViewController(withIdentifier: "NotificationListViewController")as! NotificationListViewController
            viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
            viewRegulation.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(viewRegulation, animated: true, completion: nil)
        case 5:
            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
            viewpopupReport = storyboardtest.instantiateViewController(withIdentifier: "ReportLastSixmonthsViewController") as! ReportLastSixmonthsViewController
            let navigationController: UINavigationController = UINavigationController(rootViewController: viewpopupReport)
            revealController.pushFrontViewController(navigationController, animated: false)
            revealController.revealToggle(animated: true)
        case 6:
            let clientStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let aboutUs: AboutUsSupplierViewController = clientStoryBoard.instantiateViewController(withIdentifier: "AboutUsSupplierViewController")as! AboutUsSupplierViewController
            let navigationController: UINavigationController = UINavigationController(rootViewController: aboutUs)
            revealController.pushFrontViewController(navigationController, animated: false)
            revealController.revealToggle(animated: true)
        case 7:
            let spStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let printCalendar: PrintCalendarSupplierVC = spStoryBoard.instantiateViewController(withIdentifier: "PrintCalendarSupplierVC")as! PrintCalendarSupplierVC
            revealController.present(printCalendar, animated: true, completion: nil)
            revealController.revealToggle(animated: true)
            Global.sharedInstance.isFromprintCalender = false
        case 8:
            let clientStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let viewCon:NewHelpViewController = clientStoryBoard.instantiateViewController(withIdentifier: "NewHelpViewController") as! NewHelpViewController
            revealController.present(viewCon, animated: true, completion: nil)
            revealController.revealToggle(animated: true)
        case 9:  // logout
            Global.sharedInstance.defaults.removeObject(forKey: "verificationPhone")
            Global.sharedInstance.defaults.set(true, forKey: "LogOut")
            Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
            Global.sharedInstance.defaults.set(0, forKey: "ismanager")
            Global.sharedInstance.defaults.set(1, forKey: "issimpleCustomer") //indeed
            Global.sharedInstance.defaults.set(0, forKey: "isemploye")
            Global.sharedInstance.defaults.removeObject(forKey: "currentClintName")
            Global.sharedInstance.defaults.removeObject(forKey: "currentUserId")
            Global.sharedInstance.defaults.removeObject(forKey: "providerDic")
            Global.sharedInstance.defaults.removeObject(forKey: "isSupplierRegistered")
            Global.sharedInstance.defaults.removeObject(forKey: "supplierNameRegistered")
            Global.sharedInstance.currentProviderDetailsObj = ProviderDetailsObj()
            Global.sharedInstance.isFIRSTREGISTER = false
            //clear also business hour and profile
            Global.sharedInstance.defaults.set(0, forKey:"ISFROMSETTINGS")
            Global.sharedInstance.defaults.synchronize()
            let manager = FBSDKLoginManager()
            manager.logOut()
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            Global.sharedInstance.defaults.synchronize()
            Global.sharedInstance.providerID = 0 // !IMPORTANT remove all references to previous logged in bussiness
            Global.sharedInstance.didOpenBusinessDetails = false
            Global.sharedInstance.getEventsFromMyCalendar()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController:entranceViewController = storyboard.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
            let testNavigationController = UINavigationController(rootViewController: initialViewController)
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = testNavigationController
        default:
            print("fixed provider id: \(Global.sharedInstance.providerID)")
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.sharedInstance.whichReveal == false
        {
            return tableView.frame.height / 6.1
        }
        return tableView.frame.height / 9.5
    }
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    func gradientLine(_ cellView:UIView,width:CGFloat,height:CGFloat)
    {
        let lineForCells:UIImageView = UIImageView(frame: CGRect(x: 0,y: height - 1, width: width  , height: 1.5))
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor,
            UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: width - 100, height: 2)
        lineForCells.layer.insertSublayer(gradient, at: 0)
        cellView.addSubview(lineForCells)
    }
    func readTrial(){
        self.trialdetails = Array<Int>()
        //GetTrialDataByUserId
        //        reponseGetTrialDataByUserId ["Result": {
        //            dtCreateDate = "/Date(1535109962880+0300)/";
        //            iTrialDays = 25;
        //            }, "Error": {
        //            ErrorCode = 1;
        //            ErrorMessage = Success;
        //            }]
        //-- si cand da eroare "Error" -1
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {

            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if dicUserId["currentUserId"] as! Int != 0  {
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)
                    //                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else
                {

                    api.sharedInstance.GetTrialDataByUserId(dicForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            print("reponseGetTrialDataByUserId \(RESPONSEOBJECT)")

                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 0 {
                                    //no record found
                                    Global.sharedInstance.defaults.removeObject(forKey: "APPDELiTrialDays")
                                    Global.sharedInstance.defaults.removeObject(forKey: "APPDELdtCreateDate")
                                    Global.sharedInstance.defaults.synchronize()
                                }
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                                {
                                    //2 keys
                                    var APPDELiTrialDays = 0
                                    var APPDELdtCreateDate = Date()
                                    let  reponseGetTrialDataByUserId = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                    if let _:String =  reponseGetTrialDataByUserId["dtCreateDate"] as? String {
                                        let APPLDELdtCreateDateserver = reponseGetTrialDataByUserId["dtCreateDate"] as! String
                                        if let _:Date =  Global.sharedInstance.getStringFromDateString(APPLDELdtCreateDateserver) {
                                            APPDELdtCreateDate = Global.sharedInstance.getStringFromDateString(APPLDELdtCreateDateserver)
                                        }
                                    }
                                    if let _:Int =  reponseGetTrialDataByUserId["iTrialDays"] as? Int {
                                        APPDELiTrialDays = reponseGetTrialDataByUserId["iTrialDays"] as! Int
                                    }
                                    Global.sharedInstance.defaults.set(APPDELiTrialDays,forKey: "APPDELiTrialDays")
                                    Global.sharedInstance.defaults.set(APPDELdtCreateDate,forKey: "APPDELdtCreateDate")
                                    Global.sharedInstance.defaults.synchronize()
                                }
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                    //error from server
                                    Global.sharedInstance.defaults.removeObject(forKey: "APPDELiTrialDays")
                                    Global.sharedInstance.defaults.removeObject(forKey: "APPDELdtCreateDate")
                                    Global.sharedInstance.defaults.synchronize()
                                }
                            }
                        }
                        self.calculateDaysTrialPeriod()
                        self.generic.hideNativeActivityIndicator(self)
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)

                        //                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        self.calculateDaysTrialPeriod()
                    })
                }
            }
        }
    }
    //End GetTrialDataByUserId
    func calculateDaysTrialPeriod() -> Array<Int> {
        print( Global.sharedInstance.defaults.value(forKey: "APPDELiTrialDays"))
        print(Global.sharedInstance.defaults.value(forKey: "APPDELdtCreateDate"))
        var APPDELiTrialDays = 0
        var APPDELdtCreateDate = Date()
        if Global.sharedInstance.defaults.object(forKey: "APPDELiTrialDays") != nil {
            if let _:Int = Global.sharedInstance.defaults.value(forKey: "APPDELiTrialDays") as? Int {
                APPDELiTrialDays = Global.sharedInstance.defaults.value(forKey: "APPDELiTrialDays") as! Int
            }
        }
        if Global.sharedInstance.defaults.object(forKey: "APPDELdtCreateDate") != nil {
            if let _:Date = Global.sharedInstance.defaults.value(forKey: "APPDELdtCreateDate") as? Date {
                APPDELdtCreateDate = Global.sharedInstance.defaults.value(forKey: "APPDELdtCreateDate") as! Date
            }
        }
        var myArr:Array<Int> =  Array<Int>()
        //today dmy
        let componentstoday = (self.calendar as NSCalendar).components([.day, .month, .year], from: Date())
        let gregorian = Foundation.Calendar(identifier: .gregorian)
        var ondedate = Date()
        if  let _ = gregorian.date(from: componentstoday) as Date?
        {
            ondedate = gregorian.date(from: componentstoday)!
        }
        //server start pay date
        var trialstart = Date()
        let componentsserverdate = (self.calendar as NSCalendar).components([.day, .month, .year], from: APPDELdtCreateDate)
        if  let _ = gregorian.date(from: componentsserverdate) as Date?
        {
            trialstart = gregorian.date(from: componentsserverdate)!
        }

        let dateEndwhenTrialExpire = self.calendar.date(byAdding: .day, value: APPDELiTrialDays, to: trialstart)
        let diff = dateEndwhenTrialExpire?.interval(ofComponent: .day, fromDate: ondedate)
        if diff! < 0 {
            print("trial expired")
        } else if diff! == 10 {
            let USERDEF = Global.sharedInstance.defaults
            if USERDEF.object(forKey: "") != nil {
                if let _:Int =  USERDEF.value(forKey: "PRESENTED2ODAYSPASSED") as? Int {
                    let toprompt =  USERDEF.value(forKey: "PRESENTED2ODAYSPASSED") as! Int
                    if toprompt == 0 {
                        USERDEF.setValue(1, forKey: "PRESENTED2ODAYSPASSED")
                        USERDEF.synchronize()
                        //Alert.sharedInstance.showAlert("TEN_DAYS_LEFT_BEFORE_TRIAL_ENDS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                        {
                            let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                            let paragraphStyle = NSMutableParagraphStyle()
                            // Here is the key thing!
                            paragraphStyle.alignment = .right

                            let messageText = NSMutableAttributedString(
                                string: "TEN_DAYS_LEFT_BEFORE_TRIAL_ENDS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                attributes: convertToOptionalNSAttributedStringKeyDictionary([
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                                ])
                            )

                            alertView.setValue(messageText, forKey: "attributedMessage")

                            self.present(alertView, animated: true, completion: nil)
                        } else {
                            let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                            let paragraphStyle = NSMutableParagraphStyle()
                            // Here is the key thing!
                            paragraphStyle.alignment = .left

                            let messageText = NSMutableAttributedString(
                                string: "TEN_DAYS_LEFT_BEFORE_TRIAL_ENDS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                attributes: convertToOptionalNSAttributedStringKeyDictionary([
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                                ])
                            )

                            alertView.setValue(messageText, forKey: "attributedMessage")

                            self.present(alertView, animated: true, completion: nil)
                        }


                    }
                }
            } else {
                USERDEF.setValue(1, forKey: "PRESENTED2ODAYSPASSED")
                USERDEF.synchronize()
                //  Alert.sharedInstance.showAlert("TEN_DAYS_LEFT_BEFORE_TRIAL_ENDS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                {
                    let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    let paragraphStyle = NSMutableParagraphStyle()
                    // Here is the key thing!
                    paragraphStyle.alignment = .right

                    let messageText = NSMutableAttributedString(
                        string: "TEN_DAYS_LEFT_BEFORE_TRIAL_ENDS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                        attributes: convertToOptionalNSAttributedStringKeyDictionary([
                            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                            convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                        ])
                    )

                    alertView.setValue(messageText, forKey: "attributedMessage")

                    self.present(alertView, animated: true, completion: nil)
                } else {
                    let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    let paragraphStyle = NSMutableParagraphStyle()
                    // Here is the key thing!
                    paragraphStyle.alignment = .left

                    let messageText = NSMutableAttributedString(
                        string: "TEN_DAYS_LEFT_BEFORE_TRIAL_ENDS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                        attributes: convertToOptionalNSAttributedStringKeyDictionary([
                            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraphStyle,
                            convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.preferredFont(forTextStyle: .body),
                            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black
                        ])
                    )

                    alertView.setValue(messageText, forKey: "attributedMessage")

                    self.present(alertView, animated: true, completion: nil)
                }
            }

        }
        myArr.append(APPDELiTrialDays)
        myArr.append(diff!)
        self.trialdetails = myArr
        return myArr
    }
}
extension Date {

    func interval(ofComponent comp: Foundation.Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Foundation.Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}
extension Date {
    func getrealdate(x:Date) -> Date {
        print(x)
        let date = x
        let dateFormatter = DateFormatter()
        //  dateFormatter.timeZone = TimeZone.current
        //    dateFormatter.locale = Locale.current
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT-02")!
        let dateString : String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        if(dateString.contains("a")){
            // 12 h format
            dateFormatter.dateFormat = "yyyy/MM/dd'T'hh:mm" //am pm
        }else{
            // 24 h format
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm"
        }
        let strDate = dateFormatter.string(from: date)
        var dateComponents = DateComponents()
        // Create date from components
        let datecomponents = strDate.components(separatedBy: "T")
        if datecomponents.count == 2 {
            let needday = datecomponents[0]
            let needhour = datecomponents[1]
            let splitday = needday.components(separatedBy: "/")
            let splithour = needhour.components(separatedBy: ":")
            if splitday.count == 3 {
                let needyear = Int(splitday[0])
                let needmonth = Int(splitday[1])
                let realday = Int(splitday[2])
                dateComponents.year = needyear
                dateComponents.month = needmonth
                dateComponents.day = realday
            }
            if splithour.count == 2 {
                let realhour = Int(splithour[0])
                let realminute = Int(splithour[1])
                dateComponents.hour = realhour
                dateComponents.minute = realminute
            }
        }

        var userCalendar =  Foundation.Calendar.current // user calendar
        userCalendar.timeZone = TimeZone(abbreviation: "GMT+02")!
        let someDateTime = userCalendar.date(from: dateComponents)
        return someDateTime!
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
