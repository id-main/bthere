//
//  SupplierSettings.swift -> replaces  DefinationsViewController Implementing more clear and elegant Collectionview to avoid 40 views....
//  Bthere
//
//  Created by Ioan Ungureanu on 09.02.2017 /d/m/y
//  Copyright © 2017 Bthere. All rights reserved.
//
/*
 Settings
 1. My details
 2. Working hours
 3. Services
 4. Notifications
 5. Sync contacts
 6. Employees
 7. Add calendar
 8. Manage calendar
 9. Language
 */
import UIKit
protocol OPENVIEWSINPOPUP {
    func openView(WHICHINT: Int)
}
class SupplierSettings: NavigationModelViewController, UICollectionViewDataSource ,UICollectionViewDelegate, OPENVIEWSINPOPUP,UICollectionViewDelegateFlowLayout {
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    @IBOutlet weak var titlescreen:UILabel!
    @IBOutlet weak var ttil:UICollectionView! //our items
    @IBOutlet weak var containerttil:UIView!
    var itemuri:[String] = []
    var generic:Generic = Generic()
    var subView:UIView = UIView()
    var view1 : SupplierNotificationsViewController!

    var view3 : RegisterBuisnessProphielViewController!
    var view2 : SupplierBusinessDetailViewController!
    var view4 : GlobalDataViewController!
    var view5 : SupplierContactSyncViewController!
    var viewnew: SupplierSettingsCalendar!
    var viewsethours :SettingsSetupWorkingHours!
    var viewsetservice:SettingsSetupServices!
    var ismanager:Bool = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:47)
        self.itemuri = [
            "MYDETAILS".localized(LanguageMain.sharedInstance.USERLANGUAGE),    //1
            "POP_UP_WORKING_HOURS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE),   //2
            "SETUP_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE),   //3
            "NOTIFICATIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE),    //4
            "SYNC_CONTACTS_SETTING".localized(LanguageMain.sharedInstance.USERLANGUAGE),    //5
            "EMPLOYES".localized(LanguageMain.sharedInstance.USERLANGUAGE), //6
            "ADD_CALENDARS".localized(LanguageMain.sharedInstance.USERLANGUAGE), //7
            "MANAGE_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE),  //8
            "LANG".localized(LanguageMain.sharedInstance.USERLANGUAGE)//9
        ]
        self.ttil.delegate = self
        self.ttil.dataSource = self
        self.ttil.layer.shadowColor = UIColor.black.cgColor
        self.ttil.layer.shadowOpacity = 0.4
        self.ttil.layer.shadowOffset = CGSize.zero
        self.ttil.layer.shadowRadius = 1.5

        checkEmployeesPermissions()
    }

    //MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemuri.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:CellSettingssupplier = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSettingssupplier",for: indexPath) as! CellSettingssupplier
        //  Aligning right to left on UICollectionView when RTL language

        let i:Int = indexPath.row
        cell.setDisplayDatax(self.itemuri[i], isManager: self.ismanager)

        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            cell.transform = scalingTransform

        }
        print("indexPath.row: \(indexPath.row)")



//        if indexPath.row == 6 {
//        cell.isUserInteractionEnabled = false
//        cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color6
//        }
//        DispatchQueue.main.async {

//        }
        return cell
    }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
        {
            return 0.0
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
        {
            return 0.0
        }




    func collectionView(_ collectionView: UICollectionView, didSelectItemAt
        indexPath: IndexPath) {
        let i:Int = indexPath.row
//        if indexPath.row == 3 {
//
//        }
//        else {
            self.goToScreens(i + 1)
      //  }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, UIEdgeInsets indexPath: IndexPath?) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0,bottom: 0,right: 0);
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let totalHeight: CGFloat = (self.view.frame.width / 3)
        let totalWidth: CGFloat = (self.view.frame.width / 3)
        return CGSize(width: totalWidth, height: totalHeight)
    }


    func closemenu(){
        if (self.revealViewController()?.frontViewPosition == FrontViewPosition.right) {
            self.revealViewController()?.revealToggle(animated: true)
        }

    }
    func goToScreens(_ screen:Int) {
        closemenu()
        switch screen {
        case 1:
            view2 = self.storyboard?.instantiateViewController(withIdentifier: "SupplierBusinessDetailViewController") as? SupplierBusinessDetailViewController
            view2.view.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 40)
            self.addChild(view2)
            self.view.addSubview(view2.view)
            self.view.bringSubviewToFront(view2.view)
            break
        case 2:
           // working hours
            let mainstoryb = UIStoryboard(name: "NewDevel", bundle: nil)
            viewsethours = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupWorkingHours") as? SettingsSetupWorkingHours
            viewsethours.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            self.addChild(viewsethours)
            self.view.addSubview(viewsethours.view)
            self.view.bringSubviewToFront(viewsethours.view)
            break
        case 3:
            //services
            let mainstoryb = UIStoryboard(name: "newlistservices", bundle: nil)
            viewsetservice = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupServices") as? SettingsSetupServices
            viewsetservice.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            self.addChild(viewsetservice)
            self.view.addSubview(viewsetservice.view)
            self.view.bringSubviewToFront(viewsetservice.view)
//            Global.sharedInstance.defaults.set(1, forKey: "ISFROMSETTINGS")
//            Global.sharedInstance.defaults.synchronize()
            break

//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let frontviewcontroller:UINavigationController = UINavigationController()
//            let vc = storyboard.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
//            subView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + self.navigationController!.navigationBar.frame.size.height  , width: view.frame.width, height: view.frame.height * 0.2 - 9)
//            vc.view.frame = CGRect(x: 0, y: subView.frame.height + self.navigationController!.navigationBar.frame.size.height * 0.9, width: view.frame.width, height: view.frame.height - subView.frame.height - self.navigationController!.navigationBar.frame.size.height - ((view.frame.size.height * 0.1) + 18 ))
//            frontviewcontroller.pushViewController(vc, animated: false)
//            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//            let mainRevealController = SWRevealViewController()
//            mainRevealController.frontViewController = frontviewcontroller
//            mainRevealController.rearViewController = rearViewController
//            let window :UIWindow = UIApplication.shared.keyWindow!
//            window.rootViewController = mainRevealController
        case 4:
            view1 = self.storyboard?.instantiateViewController(withIdentifier: "SupplierNotificationsViewController") as? SupplierNotificationsViewController
            view1.view.frame = self.view.frame
            self.addChild(view1)
            self.view.addSubview(view1.view)
            self.view.bringSubviewToFront(view1.view)
            break
        case 5:
            let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
            view5 = storyboardSupplierExist.instantiateViewController(withIdentifier: "SupplierContactSyncViewController") as? SupplierContactSyncViewController
            view5.view.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 40)
            view5.isfromcustomer = false
            self.addChild(view5)
            self.view.addSubview(view5.view)
            self.view.bringSubviewToFront(view5.view)
            break
        case 6:
          // self.IsManagerUser()
            if  Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
//                presentAccesCodePopup(WHICHSCREEN:1)
                openView(WHICHINT: 1)

            }
            break
        case 7:
           //add calendar WAS disabled
            if  Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
//                presentAccesCodePopup(WHICHSCREEN:2)
                openView(WHICHINT: 2)
            }
            break

        case 8:
            viewnew = self.storyboard?.instantiateViewController(withIdentifier: "SupplierSettingsCalendar") as? SupplierSettingsCalendar
            let width = UIScreen.main.bounds.size.width
            let height = UIScreen.main.bounds.size.height
            viewnew.view.frame = CGRect(x: 0, y: 40, width: width, height: height - 40)
            self.addChild(viewnew)
            self.view.addSubview(viewnew.view)
            self.view.bringSubviewToFront(viewnew.view)

            break
        case 9:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let frontviewcontroller:UINavigationController = UINavigationController()
            let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
            let vc = storyboardSupplierExist.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
            frontviewcontroller.pushViewController(vc, animated: false)
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
            break

            /*case 8:
             let mainstoryb = UIStoryboard(name: "Main", bundle: nil)
             let viewCon: DeleteProvider = mainstoryb.instantiateViewControllerWithIdentifier("DeleteProvider")as! DeleteProvider
             viewCon.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
             viewCon.isProvider = true
             viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
             if self.iOS8 {
             viewCon.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
             } else {
             viewCon.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
             }
             self.presentViewController(viewCon, animated: true, completion: nil)
             break

             case 9:
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let frontviewcontroller:UINavigationController = UINavigationController()
             let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
             let vc = storyboardSupplierExist.instantiateViewControllerWithIdentifier("LanguageViewController") as! LanguageViewController
             frontviewcontroller.pushViewController(vc, animated: false)
             let rearViewController = storyboard.instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
             let mainRevealController = SWRevealViewController()
             mainRevealController.frontViewController = frontviewcontroller
             mainRevealController.rearViewController = rearViewController
             let window :UIWindow = UIApplication.sharedApplication().keyWindow!
             window.rootViewController = mainRevealController
             break
             */
        case 11:
            openPaymentForm()
            break
        default:
            //nothing
            break
        }
    }
    func presentAccesCodePopup(WHICHSCREEN:Int) {
         closemenu()
        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
        let  viewpopupAccessCode:popupAccessCode = storyboardtest.instantiateViewController(withIdentifier: "popupAccessCode") as! popupAccessCode
        viewpopupAccessCode.delegate = self
        if self.iOS8 {
            viewpopupAccessCode.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewpopupAccessCode.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        if WHICHSCREEN == 1 {   //set employee
            viewpopupAccessCode.WHICHSCREEN = 1
            self.present(viewpopupAccessCode, animated: true, completion: nil)
        }
        if WHICHSCREEN == 2 {   //set calendar
            viewpopupAccessCode.WHICHSCREEN = 2
            self.present(viewpopupAccessCode, animated: true, completion: nil)
        }


    }
    func openView(WHICHINT: Int) {
        if WHICHINT == 1 {
        self.IsManagerUser()
        }
        if WHICHINT == 2 {
            let mainstoryb = UIStoryboard(name: "addeditcalendar", bundle: nil)
            Global.sharedInstance.myIndexForEditCalendar = 0 //NO CALENDAR IS IN EDIT BEFORE THIS SCREEN
            let viewSettingsSetupEmployees: SettingsSetupCalendars = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupCalendars")as! SettingsSetupCalendars
            viewSettingsSetupEmployees.view.frame = self.view.frame
            self.addChild(viewSettingsSetupEmployees)
            self.view.addSubview(viewSettingsSetupEmployees.view)
            self.view.bringSubviewToFront(viewSettingsSetupEmployees.view)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        self.titlescreen.text = "SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            self.ttil.transform = scalingTransform
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

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
                        }
                        else
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                //todo afisez eroare
                                //                                self.generic.hideNativeActivityIndicator(self)
                                print("eroare la IsManagerUser \(String(describing: RESPONSEOBJECT["Error"]))")
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
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
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
        if employeismanager == 0 {
            self.ismanager = false
            Global.sharedInstance.defaults.set(0, forKey: "ismanager") //false
            ttil.reloadData()

        } else{
            self.ismanager = true
            Global.sharedInstance.defaults.set(1, forKey: "ismanager") //false
            ttil.reloadData()
        }
        //\\print ("self.ismanager \(self.ismanager)")
        Global.sharedInstance.defaults.synchronize()
        //        tryGetSupplierCustomerUserIdByEmployeeId()
        //        tableView.reloadData()
    }


    func addShaddow(_ view:UIView) {
        /*view.layer.shadowColor = UIColor.blackColor().CGColor
         view.layer.shadowOpacity = 0.4
         view.layer.shadowOffset = CGSizeZero
         view.layer.shadowRadius = 1.5*/
    }

    func openPaymentForm() {
        Global.sharedInstance.isProvider = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        let viewCon = storyboard.instantiateViewController(withIdentifier: "PaymentForm") as!  PaymentForm
        viewCon.isfromSuppierSettings = true
        viewCon.isFROMCUSTOMER = false
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        frontViewController.pushViewController(viewCon, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    func IsManagerUser()
        //returneaza  1 daca este manager sau 0 dc nu este manager la json la proprietatea Result (..."Result": 1 cand este manager)
        //returns  1 if is manager or 0 in json  Result (..."Result": 1 when user is manager)
    {
        if Reachability.isConnectedToNetwork() == false
        {
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else {
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
                let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
                }
                dicISMANAGERUSER["iUserId"] =  y as AnyObject
            }
            print("\n********************************* IsManagerUser  ********************\n")
            //\\ let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicISMANAGERUSER, options: NSJSONWritingOptions.PrettyPrinted)
            //\\ let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            //\\ print(jsonString)
            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else
            {
                api.sharedInstance.IsManagerUser(dicISMANAGERUSER, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                       self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {


                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                    {
                        //todo afisez eroare
                        self.generic.hideNativeActivityIndicator(self)
                        print("eroare la IsManagerUser \(RESPONSEOBJECT["Error"])")
                    }
                    else
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            //todo afisez eroare
                            self.generic.hideNativeActivityIndicator(self)
                            print("eroare la IsManagerUser \(RESPONSEOBJECT["Error"])")
                        }
                        else
                        {
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                if myInt == 1 {
                                    print("is manager")
                                  //  self.showAlertDelegateX("wait! not finished yet :)")
//                                    let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
//                                    let viewCon = storyboardSupplierExist.instantiateViewController(withIdentifier: "EmployePermissionViewController") as! EmployePermissionViewController
//                                    if self.iOS8 {
//                                        viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                                    } else {
//                                        viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
//                                    }
//                                    self.present(viewCon, animated: true, completion: nil)
                                    let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
                                    Global.sharedInstance.myIndexForEditWorker = 0 //NO EMPLOYEE IS IN EDIT BEFORE THIS SCREEN
                                    let viewSettingsSetupEmployees: SettingsSetupEmployees = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupEmployees")as! SettingsSetupEmployees
                                    viewSettingsSetupEmployees.view.frame = self.view.frame
                                    self.addChild(viewSettingsSetupEmployees)
                                    self.view.addSubview(viewSettingsSetupEmployees.view)
                                    self.view.bringSubviewToFront(viewSettingsSetupEmployees.view)
//                                    let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
//                                    var viewEmployee = storyboardSupplierExist.instantiateViewController(withIdentifier: "EmployePermissionViewController") as! EmployePermissionViewController //
//                                    viewEmployee.view.frame = self.view.frame
//                                    self.addChildViewController(viewEmployee)
//                                    self.view.addSubview(viewEmployee.view)
//                                    self.view.bringSubview(toFront: viewEmployee.view)

                                } else {
                                    print("is not manager")
                                    self.showAlertDelegateX("MANAGER_ONLY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                            }
                    }
                        }
                    }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
//                        if AppDelegate.showAlertInAppDelegate == false
//                        {
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            AppDelegate.showAlertInAppDelegate = true
//                        }
                })
            }
        }
    }
}
 //JMODE FOR LIVE NO EMPLOYEES 21.03.2019
//
////  SupplierSettings.swift -> replaces  DefinationsViewController Implementing more clear and elegant Collectionview to avoid 40 views....
////  Bthere
////
////  Created by Ioan Ungureanu on 09.02.2017 /d/m/y
////  Copyright © 2017 Bthere. All rights reserved.
////
///*
// Settings
// 1. My details
// 2. Working hours
// 3. Services
// 4. Notifications
// 5. Sync contacts
// 6. Employees
// 7. Add calendar
// 8. Manage calendar
// 9. Language
// */
//import UIKit
//
//protocol OPENVIEWSINPOPUP {
//    func openView(WHICHINT: Int)
//}
//class SupplierSettings: NavigationModelViewController, UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, OPENVIEWSINPOPUP {
//
//    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
//    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
//    @IBOutlet weak var titlescreen:UILabel!
//    @IBOutlet weak var ttil:UICollectionView! //our items
//    @IBOutlet weak var containerttil:UIView!
//    var itemuri:[String] = []
//    var generic:Generic = Generic()
//    var subView:UIView = UIView()
//    var view1 : SupplierNotificationsViewController!
//
//    var view3 : RegisterBuisnessProphielViewController!
//    var view2 : SupplierBusinessDetailViewController!
//    var view4 : GlobalDataViewController!
//    var view5 : SupplierContactSyncViewController!
//    var viewnew: SupplierSettingsCalendar!
//    var viewsethours :SettingsSetupWorkingHours!
//    var viewsetservice:SettingsSetupServices!
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        GoogleAnalyticsSendEvent(x:47)
//        self.itemuri = [
//            "MYDETAILS".localized(LanguageMain.sharedInstance.USERLANGUAGE),    //1
//            "POP_UP_WORKING_HOURS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE),   //2
//            "SETUP_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE),   //3
//            "NOTIFICATIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE),    //4
//            "SYNC_CONTACTS_SETTING".localized(LanguageMain.sharedInstance.USERLANGUAGE),    //5
//            "EMPLOYES".localized(LanguageMain.sharedInstance.USERLANGUAGE), //6
//            // "ADD_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE), //-nil
//            "MANAGE_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE),  //7
//            "LANG".localized(LanguageMain.sharedInstance.USERLANGUAGE)//8
//        ]
//        self.ttil.delegate = self
//        self.ttil.dataSource = self
//        self.ttil.layer.shadowColor = UIColor.black.cgColor
//        self.ttil.layer.shadowOpacity = 0.4
//        self.ttil.layer.shadowOffset = CGSize.zero
//        self.ttil.layer.shadowRadius = 1.5
//    }
//
//    //MARK: - UICollectionViewDelegate
//    func numberOfSections(in collectionView: UICollectionView) -> Int{
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.itemuri.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//        let cell:CellSettingssupplier = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSettingssupplier",for: indexPath) as! CellSettingssupplier
//        //  Aligning right to left on UICollectionView when RTL language
//        var scalingTransform : CGAffineTransform!
//        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
//        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
//        {
//            cell.transform = scalingTransform
//        }
//        let i:Int = indexPath.row
//
//        //        if indexPath.row == 6 {
//        //        cell.isUserInteractionEnabled = false
//        //        cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color6
//        //        }
//        DispatchQueue.main.async {
//            cell.setDisplayDatax(self.itemuri[i])
//        }
//        return cell
//    }
//
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex indexPath: IndexPath?) -> Int {
////        return 0
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex indexPath: IndexPath?) -> Int {
////        return 0
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
////        return 0
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
////        return 0
////    }
////    func collectionView(_ collectionView: UICollectionView,
////                        layout collectionViewLayout: UICollectionViewLayout,
////                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
////        return 0.0
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout
////        collectionViewLayout: UICollectionViewLayout,
////                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
////        return 0.0
////    }
////    func collectionView(_ collectionView: UICollectionView,
////                        layout collectionViewLayout: UICollectionViewLayout,
////                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
////        return 0.0
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout
////        collectionViewLayout: UICollectionViewLayout,
////                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
////        return 0.0
////    }
//
////    func collectionView(_ collectionView: UICollectionView,
////                        layout collectionViewLayout: UICollectionViewLayout,
////                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
////    {
////        return 0.0
////    }
//
////     func collectionView(_ collectionView: UICollectionView,
////                                 layout collectionViewLayout: UICollectionViewLayout,
////                                 minimumLineSpacingForSectionAt section: Int) -> CGFloat
////    {
////        return 0.0
////    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 0.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 0.0
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt
//        indexPath: IndexPath) {
//        let i:Int = indexPath.row
//        //        if indexPath.row == 3 {
//        //
//        //        }
//        //        else {
//        self.goToScreens(i + 1)
//        //  }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, UIEdgeInsets indexPath: IndexPath) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 0, left: 0,bottom: 0,right: 0);
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let totalHeight: CGFloat = (self.view.frame.width / 3)
//        let totalWidth: CGFloat = (self.view.frame.width / 3)
//        return CGSize(width: totalWidth, height: totalHeight)
//    }
//
//    func goToScreens(_ screen:Int) {
//        switch screen {
//        case 1:
//            view2 = self.storyboard?.instantiateViewController(withIdentifier: "SupplierBusinessDetailViewController") as? SupplierBusinessDetailViewController
//            view2.view.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 40)
//            self.addChild(view2)
//            self.view.addSubview(view2.view)
//            self.view.bringSubviewToFront(view2.view)
//            break
//        case 2:
//            // working hours
//            let mainstoryb = UIStoryboard(name: "NewDevel", bundle: nil)
//            viewsethours = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupWorkingHours") as? SettingsSetupWorkingHours
//            viewsethours.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//            self.addChild(viewsethours)
//            self.view.addSubview(viewsethours.view)
//            self.view.bringSubviewToFront(viewsethours.view)
//            break
//        case 3:
//            //services
//            let mainstoryb = UIStoryboard(name: "newlistservices", bundle: nil)
//            viewsetservice = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupServices") as? SettingsSetupServices
//            viewsetservice.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//            self.addChild(viewsetservice)
//            self.view.addSubview(viewsetservice.view)
//            self.view.bringSubviewToFront(viewsetservice.view)
//            break
//            //            Global.sharedInstance.defaults.set(1, forKey: "ISFROMSETTINGS")
//            //            Global.sharedInstance.defaults.synchronize()
//            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            //            let frontviewcontroller:UINavigationController = UINavigationController()
//            //            let vc = storyboard.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
//            //            subView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + self.navigationController!.navigationBar.frame.size.height  , width: view.frame.width, height: view.frame.height * 0.2 - 9)
//            //            vc.view.frame = CGRect(x: 0, y: subView.frame.height + self.navigationController!.navigationBar.frame.size.height * 0.9, width: view.frame.width, height: view.frame.height - subView.frame.height - self.navigationController!.navigationBar.frame.size.height - ((view.frame.size.height * 0.1) + 18 ))
//            //            frontviewcontroller.pushViewController(vc, animated: false)
//            //            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//            //            let mainRevealController = SWRevealViewController()
//            //            mainRevealController.frontViewController = frontviewcontroller
//            //            mainRevealController.rearViewController = rearViewController
//            //            let window :UIWindow = UIApplication.shared.keyWindow!
//        //            window.rootViewController = mainRevealController
//        case 4:
//            view1 = self.storyboard?.instantiateViewController(withIdentifier: "SupplierNotificationsViewController") as? SupplierNotificationsViewController
//            view1.view.frame = self.view.frame
//            self.addChild(view1)
//            self.view.addSubview(view1.view)
//            self.view.bringSubviewToFront(view1.view)
//            break
//        case 5:
//            let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
//            view5 = storyboardSupplierExist.instantiateViewController(withIdentifier: "SupplierContactSyncViewController") as? SupplierContactSyncViewController
//            view5.view.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 40)
//            view5.isfromcustomer = false
//            self.addChild(view5)
//            self.view.addSubview(view5.view)
//            self.view.bringSubviewToFront(view5.view)
//            break
//        case 6:
//            self.IsManagerUser()
//            break
//            //        case 7:
//            //           //add calendar disabled
//        //            break
//        case 7:
//            viewnew = self.storyboard?.instantiateViewController(withIdentifier: "SupplierSettingsCalendar") as? SupplierSettingsCalendar
//            let width = UIScreen.main.bounds.size.width
//            let height = UIScreen.main.bounds.size.height
//            viewnew.view.frame = CGRect(x: 0, y: 40, width: width, height: height - 40)
//            self.addChild(viewnew)
//            self.view.addSubview(viewnew.view)
//            self.view.bringSubviewToFront(viewnew.view)
//            break
//        case 8:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let frontviewcontroller:UINavigationController = UINavigationController()
//            let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
//            let vc = storyboardSupplierExist.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
//            frontviewcontroller.pushViewController(vc, animated: false)
//            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//            let mainRevealController = SWRevealViewController()
//            mainRevealController.frontViewController = frontviewcontroller
//            mainRevealController.rearViewController = rearViewController
//            let window :UIWindow = UIApplication.shared.keyWindow!
//            window.rootViewController = mainRevealController
//            break
//
//            /*case 8:
//             let mainstoryb = UIStoryboard(name: "Main", bundle: nil)
//             let viewCon: DeleteProvider = mainstoryb.instantiateViewControllerWithIdentifier("DeleteProvider")as! DeleteProvider
//             viewCon.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//             viewCon.isProvider = true
//             viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
//             if self.iOS8 {
//             viewCon.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//             } else {
//             viewCon.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
//             }
//             self.presentViewController(viewCon, animated: true, completion: nil)
//             break
//
//             case 9:
//             let storyboard = UIStoryboard(name: "Main", bundle: nil)
//             let frontviewcontroller:UINavigationController = UINavigationController()
//             let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
//             let vc = storyboardSupplierExist.instantiateViewControllerWithIdentifier("LanguageViewController") as! LanguageViewController
//             frontviewcontroller.pushViewController(vc, animated: false)
//             let rearViewController = storyboard.instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
//             let mainRevealController = SWRevealViewController()
//             mainRevealController.frontViewController = frontviewcontroller
//             mainRevealController.rearViewController = rearViewController
//             let window :UIWindow = UIApplication.sharedApplication().keyWindow!
//             window.rootViewController = mainRevealController
//             break
//             */
//        case 11:
//            openPaymentForm()
//            break
//        default:
//            //nothing
//            break
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.addBackground()
//        self.titlescreen.text = "SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        var scalingTransform : CGAffineTransform!
//        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
//        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
//        {
//            self.ttil.transform = scalingTransform
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//
//    }
//
//    func addShaddow(_ view:UIView) {
//        /*view.layer.shadowColor = UIColor.blackColor().CGColor
//         view.layer.shadowOpacity = 0.4
//         view.layer.shadowOffset = CGSizeZero
//         view.layer.shadowRadius = 1.5*/
//    }
//
//    func openPaymentForm() {
//        Global.sharedInstance.isProvider = true
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
//        let viewCon = storyboard.instantiateViewController(withIdentifier: "PaymentForm") as!  PaymentForm
//        viewCon.isfromSuppierSettings = true
//        viewCon.isFROMCUSTOMER = false
//        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
//        frontViewController.pushViewController(viewCon, animated: false)
//        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//        let mainRevealController = SWRevealViewController()
//        mainRevealController.frontViewController = frontViewController
//        mainRevealController.rearViewController = rearViewController
//        let window :UIWindow = UIApplication.shared.keyWindow!
//        window.rootViewController = mainRevealController
//    }
//    func IsManagerUser()
//        //returneaza  1 daca este manager sau 0 dc nu este manager la json la proprietatea Result (..."Result": 1 cand este manager)
//        //returns  1 if is manager or 0 in json  Result (..."Result": 1 when user is manager)
//    {
//        if Reachability.isConnectedToNetwork() == false
//        {
//            //            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//        }
//        else {
//            var y:Int = 0
//            var dicISMANAGERUSER:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//            if Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId > 0 {
//                if  Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0{
//                    if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
//                        let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
//                        if let x:Int = a.value(forKey: "currentUserId") as? Int{
//                            y = x
//                        }
//                    }
//                    dicISMANAGERUSER["iUserId"] =  y as AnyObject
//                } else {
//                    dicISMANAGERUSER["iUserId"] =   Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId as AnyObject
//                }
//            } else {
//                if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
//                    let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
//                    if let x:Int = a.value(forKey: "currentUserId") as? Int{
//                        y = x
//                    }
//                }
//                dicISMANAGERUSER["iUserId"] =  y as AnyObject
//            }
//            print("\n********************************* IsManagerUser  ********************\n")
//            //\\ let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicISMANAGERUSER, options: NSJSONWritingOptions.PrettyPrinted)
//            //\\ let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
//            //\\ print(jsonString)
//            self.generic.showNativeActivityIndicator(self)
//            if Reachability.isConnectedToNetwork() == false
//            {
//                self.generic.hideNativeActivityIndicator(self)
//                //                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//            }
//            else
//            {
//                api.sharedInstance.IsManagerUser(dicISMANAGERUSER, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                    self.generic.hideNativeActivityIndicator(self)
//                    if let _ = responseObject as? Dictionary<String,AnyObject> {
//                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//
//
//                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
//                            {
//                                //todo afisez eroare
//                                self.generic.hideNativeActivityIndicator(self)
//                                print("eroare la IsManagerUser \(RESPONSEOBJECT["Error"])")
//                            }
//                            else
//                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
//                                {
//                                    //todo afisez eroare
//                                    self.generic.hideNativeActivityIndicator(self)
//                                    print("eroare la IsManagerUser \(RESPONSEOBJECT["Error"])")
//                                }
//                                else
//                                {
//                                    if let _:Int = RESPONSEOBJECT["Result"] as? Int
//                                    {
//                                        let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
//                                        if myInt == 1 {
//                                            print("is manager")
//                                            //                                    let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
//                                            //                                    let viewCon = storyboardSupplierExist.instantiateViewController(withIdentifier: "EmployePermissionViewController") as! EmployePermissionViewController
//                                            //                                    if self.iOS8 {
//                                            //                                        viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                                            //                                    } else {
//                                            //                                        viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
//                                            //                                    }
//                                            //                                    self.present(viewCon, animated: true, completion: nil)
//                                            let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
//                                            var viewEmployee = storyboardSupplierExist.instantiateViewController(withIdentifier: "EmployePermissionViewController") as! EmployePermissionViewController //
//                                            viewEmployee.view.frame = self.view.frame
//                                            self.addChild(viewEmployee)
//                                            self.view.addSubview(viewEmployee.view)
//                                            self.view.bringSubviewToFront(viewEmployee.view)
//
//                                        } else {
//                                            print("is not manager")
//                                            self.showAlertDelegateX("MANAGER_ONLY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                                        }
//                                    }
//                            }
//                        }
//                    }
//                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    self.generic.hideNativeActivityIndicator(self)
//                    //                        if AppDelegate.showAlertInAppDelegate == false
//                    //                        {
//                    //                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    //                            AppDelegate.showAlertInAppDelegate = true
//                    //                        }
//                })
//            }
//        }
//    }
//     func openView(WHICHINT: Int) {
//    }
//}
