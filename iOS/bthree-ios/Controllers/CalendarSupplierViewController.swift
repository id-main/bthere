//
//  CalendarSupplierViewController.swift
//  Bthere
//
//  Created by User on 22.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import MarqueeLabel
protocol OPENVIEW2 {
    func openview()
}

class CalendarSupplierViewController:  NavigationModelViewController,
    UIGestureRecognizerDelegate ,openFromMenuDelegate,clickToDayDelegate, clickToDayInWeekDelegate,OPENVIEW2
{
    //VAR MASS MOD
    var bIsAvailableForNewCustomer = 0
    var iHoursForPreCancelServiceByCustomer = 0
    @IBOutlet weak var CentralButton:UIView!
    @IBOutlet weak var CentralButtonImg:UIImageView!
    @IBOutlet weak var butonwidth: NSLayoutConstraint!
    var iFirstCalendarViewType:Int = 0 // 0 day, 1 weekn, 2 month
    //MARK: - Varibals
    var MYDATE:Date = Date()
    var WHICHPRINT:Int = 0 //1 = DAY 2 = WEEK 3= LIST
    var view8doi : loadingBthere!
    var loaderwasshow:Bool = false
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var generic:Generic = Generic()
    var delegateSetDate:setDateDelegate!=nil
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var attrs = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont.systemFont(ofSize: 18),
        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black,
        convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1] as [String : Any]
    var attrsDeselect = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont.systemFont(ofSize: 18)]
    var view1 : MonthDesignSupplierViewController!//month Design
    var view2 :ListDesignViewController!//list Design
   // var view3 :WeekDesignSupplierViewController!//week Design
    var view4 :DayDesignSupplierViewController!//day Design
    var attributedString = NSMutableAttributedString(string:"")
    var subView = UIView()
    var selectedView:UIViewController = UIViewController()
    var isAuto = false
    var trialdetails2:Array<Int> = Array<Int>()
    
    //MARK: - Outlet
    @IBOutlet var recordBtn: UIButton!
    @IBOutlet var imgMenu: UIImageView!
    @IBOutlet var myPlusImgEnglish: UIImageView!
    @IBOutlet var monthlyBtn: UIButton!
    @IBOutlet var weekBtn: UIButton!
    @IBOutlet var dayBtn: UIButton!
    @IBOutlet weak var buttonsTopConstraint:NSLayoutConstraint! // 14
    @IBOutlet var newslabel: MarqueeLabel!
    
    //MARK: - IBAction
    //when click on list design open list controller
    
    @IBAction func recordBtn(_ sender: UIButton) {
        
        if sender.tag == 0 || selectedView == view2{
            SelectDesighnedBtn(sender)
            sender.tag = 1
            SelectSingleForRecord()
            view1.view.isHidden = true
       //JMODE 31.01.2019     view3.view.isHidden = true
            view4.view.isHidden = true
            view2.view.isHidden = false
            self.view.bringSubviewToFront(view2.view)
            self.view.bringSubviewToFront(self.CentralButton)
            DispatchQueue.main.async(execute: { () -> Void in
                self.view2.bestmode()
                self.view2.view.setNeedsDisplay()
            })
            
            if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
            {
                view2.btnSyncGoogleSupplier.isCecked = true
            }
            else
            {
                view2.btnSyncGoogleSupplier.isCecked = false
            }
            selectedView = view2
        }
        else
        {
            sender.backgroundColor = Colors.sharedInstance.color6
            DeSelectDesighnedBtn(sender)
            selectedView = view2
            sender.tag = 0
        }
    }
    //לשונית חודש
    //when click on month design open month controller
    @IBAction func monthlyBtn(_ sender: UIButton) {
        if sender.tag == 0 || selectedView == view1
        {
            SelectDesighnedBtn(sender)
            sender.tag = 1
            SelectSingleForMonthly()
            view2.view.isHidden = true
          //JMODE 31.01.2019  view3.view.isHidden = true
            view4.view.isHidden = true
            view1.view.isHidden = false
            if WHICHPRINT > 0 {
                WHICHPRINT = 0
            }
            self.view.bringSubviewToFront(view1.view)
            self.view.bringSubviewToFront(self.CentralButton)
            DispatchQueue.main.async(execute: { () -> Void in
                self.view1.bestmode()
                self.view1.view.setNeedsDisplay()
            })
            if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
            {
                view1.btnSyn.isCecked = true
            }
            else
            {
                view1.btnSyn.isCecked = false
            }
            selectedView = view1
        }
        else{
            sender.tag = 0
            sender.backgroundColor = Colors.sharedInstance.color7
            DeSelectDesighnedBtn(sender)
            selectedView = view1
        }
        
    }
    
    //לשונית שבוע
    //when click on week design open week controller
    //JMODE 31.01.2019
//    @IBAction func weekBtn(_ sender: UIButton) {
//
//        if sender.tag == 0 || selectedView == view3{
//            SelectDesighnedBtn(sender)
//            sender.tag = 1
//            SelectSingleForWeek()
//            view1.view.isHidden = true
//            view4.view.isHidden = true
//            view2.view.isHidden = true
//            view3.view.isHidden = false
//            self.view.bringSubview(toFront: view3.view)
//            DispatchQueue.main.async(execute: { () -> Void in
//                if self.WHICHPRINT > 0 {
//                    self.WHICHPRINT = 0
//                } else {
//                    self.view3.bestmode()
//                }
//                self.view3.view.setNeedsDisplay()
//                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
//                {
//                    self.view4.btnSyncGoogelSupplier.isCecked = true
//                }
//                else
//                {
//                    self.view4.btnSyncGoogelSupplier.isCecked = false
//                }
//            })
//            selectedView = view3
//        }
//        else{
//            sender.tag = 0
//            DeSelectDesighnedBtn(sender)
//            selectedView = view3
//            sender.backgroundColor = Colors.sharedInstance.color8
//        }
//    }

    //לשונית יום
    //when click on day design open day controller
    @IBAction func dayBtn(_ sender: UIButton) {
        if sender.tag == 0 || selectedView == view4{
            SelectDesighnedBtn(sender)
            sender.tag = 1
            SelectSingleForDay()
            view1.view.isHidden = true
          //JMODE 31.01.2019  view3.view.isHidden = true
            view2.view.isHidden = true
            view4.view.isHidden = false
            if WHICHPRINT > 0 {
                WHICHPRINT = 0
            }
            self.view.bringSubviewToFront(view4.view)
            self.view.bringSubviewToFront(self.CentralButton)
            DispatchQueue.main.async(execute: { () -> Void in
                self.view4.frommonthorweek = false
                self.view4.bestmode()
                self.view4.view.setNeedsDisplay()
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
                {
                    self.view4.btnSyncGoogelSupplier.isCecked = true
                }
                else
                {
                    self.view4.btnSyncGoogelSupplier.isCecked = false
                }
            })
            selectedView = view4
        }
        else{
            sender.tag = 0
            DeSelectDesighnedBtn(sender)
            sender.backgroundColor = Colors.sharedInstance.color9
            selectedView = view4
        }
    }
    
    //MARK: - Initial
    
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
            api.sharedInstance.GetNewsAndUpdates(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        if let abcd = RESPONSEOBJECT["Result"] as? String {
                            self.newslabel.tag = 101
                            self.newslabel.type = .continuous
                            self.newslabel.animationCurve = .linear
                            self.newslabel.type = .leftRight
                            self.newslabel.text  = abcd
                            self.newslabel.restartLabel()
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
    func gotoEntranceCustomerx() {
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyBoard1!.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController

        let mainRevealController = SWRevealViewController()

        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController

        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
    func fixProviderID(_whichState:Int) {

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
                            let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                            print("sup id e ok ? " + myInt.description)
                            if myInt == 0 {

                            } else {
                               Global.sharedInstance.providerID = myInt
                               Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails = myInt
                            }
                        }
                    }
                    if _whichState == 1 {
                    self.GetProviderSettingsForCalendarmanagement()
                    }

                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    if _whichState == 1 {
                        self.GetProviderSettingsForCalendarmanagement()
                    }


                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         GoogleAnalyticsSendEvent(x:59)
        var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.currentUser.nvPhone != "" {
            generic.showNativeActivityIndicator(self)
            dicPhone["nvPhone"] =  Global.sharedInstance.currentUser.nvPhone as AnyObject
            if Reachability.isConnectedToNetwork() == false
            {
                generic.hideNativeActivityIndicator(self)

            }
            else
            {
                api.sharedInstance.GetEmployeeDataByPhone(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                                self.gotoEntranceCustomer()
                                return
                            }
                        }
                    }
                    self.generic.hideNativeActivityIndicator(self)
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                })

            }
        }
    //\\    if  Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")  == -1 {
            var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            var y:Int = 0
            var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
            }
            if y != 0
            {
                dicEMPLOYE["iUserId"] =  y as AnyObject
                print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
                if Reachability.isConnectedToNetwork() == false
                {

                }
                else
                {
                    api.sharedInstance.GetSecondUserIdByFirstUserId(dicEMPLOYE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                                {
                                    print("eroare la GetSecondUserIdByFirstUserId \(String(describing: RESPONSEOBJECT["Error"]))")
                                }
                                else
                                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                                    {
                                        print("eroare la GetSecondUserIdByFirstUserId \(String(describing: RESPONSEOBJECT["Error"]))")
                                    }
                                    else
                                    {
                                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                        {
                                            let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                            print("GetSecondUserIdByFirstUserId \(myInt)")
                                            if myInt > 0 {
                                                Global.sharedInstance.defaults.setValue(myInt , forKey: "idSupplierWorker")
                                                Global.sharedInstance.defaults.synchronize()
                                            } else {
                                                if Global.sharedInstance.giveServicesArray.count > 0
                                                {
                                                    let myowner = Global.sharedInstance.giveServicesArray[0]
                                                    Global.sharedInstance.defaults.setValue(myowner.iUserId , forKey: "idSupplierWorker")
                                                    Global.sharedInstance.defaults.synchronize()
                                                }
                                            }
                                        }
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                       
                    })
                }
           //\\ }



        print("idSupplierWorker in calendar: \(Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int)")
        }

        self.getnews()
        self.navigationController?.interactivePopGestureRecognizer?.delegate  = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.generic.hideNativeActivityIndicator(self)
        //show a loader
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        view8 = storyboard1.instantiateViewController(withIdentifier: "loadingBthere") as! loadingBthere
        let screenSize: CGRect = UIScreen.main.bounds
        view8.view.frame = screenSize
        view8.view.tag = 2000
        self.view.addSubview(view8.view)
        self.view.bringSubviewToFront(view8.view)
        //aici iustin de facut
     //  readTrial2()
        
//        if  USERDEF.object(forKey: "iSupplierStatus") != nil  {
//            print(USERDEF.integer(forKey: "iSupplierStatus"))
//            //   TEST MODE ONLY USERDEF.set(2, forKey: "iSupplierStatus")
//            //   TEST MODE ONLY USERDEF.synchronize()
//            if USERDEF.integer(forKey: "iSupplierStatus") == 2 {
//                //contacts sync but trial expired
//                Global.sharedInstance.isProvider = false
//                //     Alert.sharedInstance.showAlert("PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
//                {
//                    let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
//                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//                    // Here is the key thing!
//                    paragraphStyle.alignment = .right
//
//                    let messageText = NSMutableAttributedString(
//                        string: "PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//                        attributes: [
//                            NSParagraphStyleAttributeName: paragraphStyle,
//                            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
//                            NSForegroundColorAttributeName : UIColor.black
//                        ]
//                    )
//
//                    alertView.setValue(messageText, forKey: "attributedMessage")
//
//                    self.present(alertView, animated: true, completion: nil)
//                } else {
//                    let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
//                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//                    // Here is the key thing!
//                    paragraphStyle.alignment = .left
//
//                    let messageText = NSMutableAttributedString(
//                        string: "PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//                        attributes: [
//                            NSParagraphStyleAttributeName: paragraphStyle,
//                            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
//                            NSForegroundColorAttributeName : UIColor.black
//                        ]
//                    )
//
//                    alertView.setValue(messageText, forKey: "attributedMessage")
//
//                    self.present(alertView, animated: true, completion: nil)
//                }
//                gotoEntranceCustomerx()
//                //                let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
//                //                let storyboard = UIStoryboard(name: "Testing", bundle: nil)
//                //                let frontViewController = storyboard1.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
//                //                let viewCon = storyboard.instantiateViewController(withIdentifier: "popupTrialExpired") as!  popupTrialExpired
//                //                viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
//                //                frontViewController.pushViewController(viewCon, animated: false)
//                //                let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//                //                let mainRevealController = SWRevealViewController()
//                //                mainRevealController.frontViewController = frontViewController
//                //                mainRevealController.rearViewController = rearViewController
//                //                let window :UIWindow = UIApplication.shared.keyWindow!
//                //                window.rootViewController = mainRevealController
//                return
//            }
//        }

    }
    @objc func openPlusMenuNewProvider(){
        if let _ =  Bundle.main.loadNibNamed("PlusMenuNewSupplier", owner: self, options: nil)?.first as? PlusMenuNewSupplier
        {
            let openpopmenu = Bundle.main.loadNibNamed("PlusMenuNewSupplier", owner: self, options: nil)?.first as! PlusMenuNewSupplier
            openpopmenu.frame = self.view.frame
            self.view.addSubview(openpopmenu)
            self.view.bringSubviewToFront(openpopmenu)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        monthlyBtn.isUserInteractionEnabled = false
        recordBtn.isUserInteractionEnabled = false
        dayBtn.isUserInteractionEnabled = false
        if (Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjServiceProviders.count > 0) {
          //JMODE FOR LIVE NO EMPLOYEES 21.03.2019
            showfirstemployepopup()
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            butonwidth.constant = 80
        } else {
            butonwidth.constant = 70
        }
        print(Global.sharedInstance.isSyncWithGoogelCalendarSupplier)
        
       print(self.iFirstCalendarViewType)

        CentralButtonImg.image = UIImage(named: "Plus menu icon - Supplier")
        CentralButton.frame = CGRect(x: CentralButton.frame.origin.x, y: CentralButton.frame.origin.y, width: self.view.frame.size.width * 0.25, height: self.view.frame.size.width * 0.25 * 0.8)

//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(CalendarSupplierViewController.imageTapped))
//        tapGestureRecognizer.delegate = self
//        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
//        {
//            imgMenu.image = UIImage(named: "plushebrewsupplier.png")
//            imgMenu.isHidden = false
//            imgMenu.isUserInteractionEnabled = true
//            myPlusImgEnglish.isHidden = true
//            myPlusImgEnglish.isUserInteractionEnabled = false
//            imgMenu.addGestureRecognizer(tapGestureRecognizer)
//        }
//        else
//        {
//            myPlusImgEnglish.image = UIImage(named: "plushebrewsupplier.png")
//            myPlusImgEnglish.isHidden = false
//            myPlusImgEnglish.isUserInteractionEnabled = true
//            imgMenu.isHidden = true
//            imgMenu.isUserInteractionEnabled = true
//            myPlusImgEnglish.addGestureRecognizer(tapGestureRecognizer)
//        }

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalendarSupplierViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        let USERDEF = UserDefaults.standard
        if USERDEF.object(forKey:  "iFirstCalendarViewType") == nil {
        USERDEF.set(10 , forKey: "iFirstCalendarViewType") //will never be called if user does not open appointment details
        USERDEF.synchronize()
        } else {
            let myint = USERDEF.integer(forKey: "iFirstCalendarViewType")
            
            print(myint)
                
            }
       
        self.getnews()
        self.newslabel.restartLabel()
        GetCalendarsOfSupplier()
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.interactivePopGestureRecognizer?.delegate  = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        recordBtn.setTitle("DESIGN_LIST".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        monthlyBtn.setTitle("DESIGN_MONTH".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        weekBtn.setTitle("DESIGN_WEEK".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        dayBtn.setTitle("DESIGN_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        Global.sharedInstance.currDateSelected = Date()
        Calendar.sharedInstance.carrentDate = Date()
        Global.sharedInstance.whichReveal = true
        Global.sharedInstance.eleventCon = self
        
        subView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + self.navigationController!.navigationBar.frame.size.height , width: view.frame.width, height: view.frame.height * 0.15)
        self.navigationController?.isNavigationBarHidden = false
        var differentframeview1 = CGRect(x:0, y:0, width:0, height:0)
        var differentframeview2 = CGRect(x:0, y:0, width:0, height:0)
        if UIDevice.current.userInterfaceIdiom == .pad {
         differentframeview1 = CGRect(x: 0, y: subView.frame.height + (64 * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height -  CentralButton.frame.size.height)
         differentframeview2 = CGRect(x: 0, y: subView.frame.height + (64 * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height / 1.2  - CentralButton.frame.size.height)
        } else {
            differentframeview1 = CGRect(x: 0, y: subView.frame.height + (64 * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height - 25 - CentralButton.frame.size.height)
            differentframeview2 = CGRect(x: 0, y: subView.frame.height + (64 * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height / 1.22  - CentralButton.frame.size.height)
        }
        if WHICHPRINT != 0 {
            fixProviderID(_whichState: 0)
            switch WHICHPRINT {
                //                view3 = self.storyboard!.instantiateViewController(withIdentifier: "WeekDesignSupplierViewController") as! WeekDesignSupplierViewController
                //                view3.delegate = self
                //                view3.NOLOAD = false
                //                view3.FROMPRINT = false
                //                view3.view.frame = CGRect(x: 0, y: subView.frame.height + (self.navigationController!.navigationBar.frame.size.height * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height - self.navigationController!.navigationBar.frame.size.height - 60)
                //
            //                view3.delegate = self
            case 1: //dayview
                view2 = self.storyboard!.instantiateViewController(withIdentifier: "ListDesignViewController") as! ListDesignViewController
                view1 = self.storyboard!.instantiateViewController(withIdentifier: "MonthDesignSupplierViewController") as! MonthDesignSupplierViewController
                view4 = self.storyboard!.instantiateViewController(withIdentifier: "DayDesignSupplierViewController") as! DayDesignSupplierViewController
                view1.view.frame = differentframeview2
                view2.view.frame = differentframeview1
                view4.view.frame = differentframeview1

                view1.view.isHidden = true
                view2.view.isHidden = true
            //JMODE 31.01.2019    view3.view.isHidden = true
                view4.view.isHidden = false
                self.addChild(view1)
                self.addChild(view2)
           //JMODE 31.01.2019     self.addChildViewController(view3)
                self.addChild(view4)
                self.view.addSubview(view1.view)
                self.view.addSubview(view2.view)
             //JMODE 31.01.2019   self.view.addSubview(view3.view)
                self.view.addSubview(view4.view)
                selectedView = view4
                view4.FROMPRINT = true
                Calendar.sharedInstance.carrentDate = MYDATE
                view4.initDate(MYDATE)
                view4.setDateClick(MYDATE)
                self.dayBtn(dayBtn)
                
                
            case 2: //weekdesign

                view4 = self.storyboard!.instantiateViewController(withIdentifier: "DayDesignSupplierViewController") as! DayDesignSupplierViewController
                view2 = self.storyboard!.instantiateViewController(withIdentifier: "ListDesignViewController") as! ListDesignViewController
                view1 = self.storyboard!.instantiateViewController(withIdentifier: "MonthDesignSupplierViewController") as! MonthDesignSupplierViewController
                view1.view.frame = differentframeview2
                view2.view.frame = differentframeview1
                view4.view.frame = differentframeview1
                view4.view.isHidden = true
                view2.view.isHidden = true
                view2.view.isHidden = true
           //JMODE 31.01.2019     view3.view.isHidden = false
                self.addChild(view4)
                self.addChild(view2)
                self.addChild(view1)
           //JMODE 31.01.2019     self.addChildViewController(view3)
                self.view.addSubview(view4.view)
                self.view.addSubview(view1.view)
                self.view.addSubview(view2.view)
           //JMODE 31.01.2019     self.view.addSubview(view3.view)
//                selectedView = view3
//                view3.FROMPRINT = true
//                view3.NOLOAD = false
//                view3.initDateOfWeek(MYDATE)
                Calendar.sharedInstance.carrentDate = MYDATE
          //JMODE 31.01.2019      self.weekBtn(weekBtn)
                
                
            case 3:
                
                view1 = self.storyboard!.instantiateViewController(withIdentifier: "MonthDesignSupplierViewController") as! MonthDesignSupplierViewController
                view4 = self.storyboard!.instantiateViewController(withIdentifier: "DayDesignSupplierViewController") as! DayDesignSupplierViewController
                view2 = self.storyboard!.instantiateViewController(withIdentifier: "ListDesignViewController") as! ListDesignViewController
                view1.view.frame = differentframeview2
                view2.view.frame = differentframeview1
                view4.view.frame = differentframeview1
                view1.view.isHidden = true
                view4.view.isHidden = true
            //JMODE 31.01.2019    view3.view.isHidden = true
                view2.view.isHidden = false
                self.addChild(view4)
                self.addChild(view1)
            //JMODE 31.01.2019    self.addChildViewController(view3)
                self.addChild(view2)
                self.view.addSubview(view4.view)
                self.view.addSubview(view1.view)
                self.view.addSubview(view2.view)
          //JMODE 31.01.2019      self.view.addSubview(view3.view)
                selectedView = view2
                view2.FROMPRINT = true
                Calendar.sharedInstance.carrentDate = MYDATE
                self.recordBtn(recordBtn)
                
            default:
                print("nothing")
            }

            
            if Global.sharedInstance.isFIRSTSUPPLIER == true {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.view4.frommonthorweek = false
                    self.view4.bestmode()
                    self.view4.view.setNeedsDisplay()
                })
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
                {
                    view4.btnSyncGoogelSupplier.isCecked = true
                }
                else
                {
                    view4.btnSyncGoogelSupplier.isCecked = false
                }
                
            }
        
            
            if  Global.sharedInstance.isFromMenu == false{
                
            }
            else{
                Global.sharedInstance.isFromMenu = false
            }
            self.generic.hideNativeActivityIndicator(self)
            

            let tapOpenPlusMenuNewProvider:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewProvider))
            tapOpenPlusMenuNewProvider.delegate = self
            CentralButton.addGestureRecognizer(tapOpenPlusMenuNewProvider)
            monthlyBtn.isUserInteractionEnabled = true
            recordBtn.isUserInteractionEnabled = true
            dayBtn.isUserInteractionEnabled = true
        } else {
            self.generic.hideNativeActivityIndicator(self)
            fixProviderID(_whichState: 1)
        }
        }
        
 
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(animated)
        self.view.addBackground()
        self.view.sendSubviewToBack(view8.view)
        let USERDEF = Global.sharedInstance.defaults

        if USERDEF.object(forKey: "wasshownwelcometoBthere") != nil {
            if let _:Int = USERDEF.value(forKey: "wasshownwelcometoBthere") as? Int {
                let myint:Int = USERDEF.value(forKey: "wasshownwelcometoBthere") as! Int
                if myint == 0 {
                     USERDEF.set(1, forKey: "wasshownwelcometoBthere")
                    USERDEF.synchronize()
                    showWelcometoBtherePopup()
                } else {
                    if  USERDEF.value (forKey: "wasseenTextTOShow") != nil {
                        if  USERDEF.value (forKey: "wasseenTextTOShow") as! Int  == 0 {
                            if USERDEF.value(forKey: "TextTOShow") != nil {
                                if let _ = USERDEF.value(forKey: "TextTOShow") as? String {

                                    let mytexttoshow = USERDEF.value(forKey: "TextTOShow") as! String
                                    if mytexttoshow != "ABCDEFGH" {
                                        Alert.sharedInstance.showAlert(mytexttoshow, vc: self)
                                    }
                                }
                            }
                            USERDEF.set("ABCDEFGH", forKey: "TextTOShow")
                            USERDEF.set(1, forKey: "wasseenTextTOShow")
                            USERDEF.synchronize()
                        }
                    }
            }
        }
        }

    }

    func showfirstemployepopup() {
       // if Global.sharedInstance.isFIRSTSUPPLIER == true {
        if  Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
        let USERDEF = Global.sharedInstance.defaults
        if let _:Int = USERDEF.value(forKey: "wasshownwelcometoBthere") as? Int {
            let myint:Int = USERDEF.value(forKey: "wasshownwelcometoBthere") as! Int
            if myint == 1 {
                if let _:Int = USERDEF.value(forKey: "firstpopup_addEmployeesalreadyseen") as? Int {
                    let myint2:Int = USERDEF.value(forKey: "firstpopup_addEmployeesalreadyseen") as! Int
                    if myint2 == 0 {
            print("gata")
            let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
            let viewSettingsSetupEmployees: POP_UP_ADD_YOUR_EMPLOYEES = mainstoryb.instantiateViewController(withIdentifier: "POP_UP_ADD_YOUR_EMPLOYEES")as! POP_UP_ADD_YOUR_EMPLOYEES
            viewSettingsSetupEmployees.modalPresentationStyle = .overCurrentContext
            viewSettingsSetupEmployees.view.frame = self.view.frame
            viewSettingsSetupEmployees.delegate1 = self
            self.present(viewSettingsSetupEmployees, animated: true, completion: nil)
                    }
                }
            }
        }
        }
//            let storyboardSupplierExist = UIStoryboard(name: "Main", bundle: nil)
//            let viewCon = storyboardSupplierExist.instantiateViewController(withIdentifier: "ExistProviderFirstViewController") as! ExistProviderFirstViewController
//            if self.iOS8 {
//                viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            } else {
//                viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
//            }
//            Global.sharedInstance.isFIRSTSUPPLIER = false
//            self.present(viewCon, animated: true, completion: nil)
     //   }
    }
    func showWelcometoBtherePopup() {
          if Global.sharedInstance.isFIRSTSUPPLIER == true {
        let storyboardSupplierExist = UIStoryboard(name: "Testing", bundle: nil)
        let viewCon = storyboardSupplierExist.instantiateViewController(withIdentifier: "WelcomeBusinessPopUP") as! WelcomeBusinessPopUP
        if self.iOS8 {
            viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
            Global.sharedInstance.isFIRSTSUPPLIER = false
//            let window :UIWindow = UIApplication.shared.keyWindow!
//            window.rootViewController?.present(viewCon, animated: true, completion: nil)
        self.present(viewCon, animated: true, completion: nil)
        }
    }
    ///dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        //con?.view.removeFromSuperview()
    }
    
    //on click the menu plus - open it
    @objc func imageTapped(){
        let storyBoard = UIStoryboard(name:"SupplierExist", bundle: nil)
        let viewCon:PLUSMENUSupplier = storyBoard.instantiateViewController(withIdentifier: "PLUSMENUSupplier") as! PLUSMENUSupplier
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        viewCon.delegate = self
        self.present(viewCon, animated: true, completion: nil)
    }
    
    //Highlight the selected tab - month / week / day / list design
    func SelectDesighnedBtn(_ btn:UIButton){
        
        btn.backgroundColor = UIColor.clear
        //  underlineButton(btn, text: (btn.titleLabel?.text)!)
    }
    
    //Highlight the selected tab - month / week / day / list design
    func underlineButton(_ button : UIButton, text: String) {
        attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:text, attributes:convertToOptionalNSAttributedStringKeyDictionary(attrs))
        attributedString.append(buttonTitleStr)
        button.setAttributedTitle(attributedString, for: UIControl.State())
    }
    
    //cancel the highlight of selected tab - month / week / day / list design
    func DeSelectDesighnedBtn(_ btn:UIButton)
    {
        
        attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string: (btn.titleLabel?.text)!, attributes:convertToOptionalNSAttributedStringKeyDictionary(attrsDeselect))
        attributedString.append(buttonTitleStr)
        btn.setAttributedTitle(attributedString, for: UIControl.State())
    }
    
    func SelectSingleForRecord()
    {
        monthlyBtn.tag = 0
        monthlyBtn.backgroundColor = Colors.sharedInstance.color7
        DeSelectDesighnedBtn(monthlyBtn)
        weekBtn.tag = 0
        DeSelectDesighnedBtn(weekBtn)
        weekBtn.backgroundColor = Colors.sharedInstance.color8
        dayBtn.tag = 0
        dayBtn.backgroundColor = Colors.sharedInstance.color9
        DeSelectDesighnedBtn(dayBtn)
    }
    
    func SelectSingleForMonthly(){
        
        recordBtn.backgroundColor = Colors.sharedInstance.color6
        DeSelectDesighnedBtn(recordBtn)
        recordBtn.tag = 0
        weekBtn.tag = 0
        DeSelectDesighnedBtn(weekBtn)
        weekBtn.backgroundColor = Colors.sharedInstance.color8
        dayBtn.tag = 0
        dayBtn.backgroundColor = Colors.sharedInstance.color9
        DeSelectDesighnedBtn(dayBtn)
    }
    
    func SelectSingleForWeek(){
        monthlyBtn.tag = 0
        monthlyBtn.backgroundColor = Colors.sharedInstance.color7
        DeSelectDesighnedBtn(monthlyBtn)
        recordBtn.backgroundColor = Colors.sharedInstance.color6
        DeSelectDesighnedBtn(recordBtn)
        recordBtn.tag = 0
        dayBtn.tag = 0
        dayBtn.backgroundColor = Colors.sharedInstance.color9
        DeSelectDesighnedBtn(dayBtn)
    }
    
    func SelectSingleForDay(){
        monthlyBtn.tag = 0
        monthlyBtn.backgroundColor = Colors.sharedInstance.color7
        DeSelectDesighnedBtn(monthlyBtn)
        weekBtn.tag = 0
        DeSelectDesighnedBtn(weekBtn)
        weekBtn.backgroundColor = Colors.sharedInstance.color8
        recordBtn.backgroundColor = Colors.sharedInstance.color6
        DeSelectDesighnedBtn(recordBtn)
        recordBtn.tag = 0
    }
    
    
   
    
    //delegte func to open pages from plus menu
    func openFromMenu(_ con:UIViewController)
    {
        self.present(con, animated: true, completion: nil)
    }
    
    
    func clickToDay(){//open the day design when click one day in the month design
        
        SelectDesighnedBtn(dayBtn)
        SelectSingleForDay()
        selectedView.view.isHidden = true
        self.delegateSetDate = Global.sharedInstance.dayDesignCalendarSupplier
        view4.initDate(Global.sharedInstance.currDateSelected)
        view4.frommonthorweek = true
        view1.view.isHidden = true
     //JMODE 31.01.2019   view3.view.isHidden = true
        view2.view.isHidden = true
        view4.view.isHidden = false
        selectedView = view4
        view4.bestmode()
        delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick)
    }
    
    func clickToDayInWeek()//open the day design when click one day in the week design
    {
        SelectSingleForDay()
        selectedView.view.isHidden = true
        view4.initDate(Global.sharedInstance.currDateSelected)
        view4.frommonthorweek = true
        view1.view.isHidden = true
     //JMODE 31.01.2019   view3.view.isHidden = true
        view2.view.isHidden = true
        view4.view.isHidden = false
        selectedView = view4
        self.delegateSetDate = Global.sharedInstance.dayDesignCalendarSupplier
        selectedView = view4
        delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick)
        
    }
    func getProviderAllDetails(_ iUserId:Int)
    {
        //show a loader
        Global.sharedInstance.FREEDAYSALLWORKERS = []
        Global.sharedInstance.NOWORKINGDAYS = []
        if let topController = UIApplication.topViewController() {
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            view8 = storyboard1.instantiateViewController(withIdentifier: "loadingBthere") as! loadingBthere
            let screenSize: CGRect = UIScreen.main.bounds
            view8.view.frame = screenSize
            view8.view.tag = 2000
            
            topController.view.addSubview(view8.view)
            topController.view.bringSubviewToFront(view8.view)
        }
        //end show
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicUserId["iUserId"] = iUserId as AnyObject
        api.sharedInstance.getProviderAllDetails(dicUserId,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            //hide the loader
            if (self.view8.view.window != nil) {
                self.view8.view.removeFromSuperview()
            }
            //end hide
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                    {
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                    {
                        UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")
                    }
                    else
                    {
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                            //\\    print("crash 1 \(responseObject["Result"])")
                            if let _:ProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj((RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!) {
                                Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                let mydic :Dictionary<String,AnyObject> = (RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!
                                //IMPORTANT THIS FIX PROVIDERID AFTER SETTING ORDER TO ANOTHER ONE.
                                if let onedic:Dictionary<String,AnyObject> = mydic["objProviderProfile"] as? Dictionary<String,AnyObject> {
                                    if let Iprov:Int = onedic["iProviderUserId"] as? Int {
                                        print("dupaget \(Iprov)")
                                        if Iprov != 0 {
                                            Global.sharedInstance.providerID = Iprov
                                        }
                                    }
                                    //BLOCKED DAYS ARE GENERAL FOR PROVIDER AND
                                    // 1. SEPARATE FOR EVERY WORKER IF HE HAS bSameWH = 0
                                    // 2. SAME AS PROVIDER IF WORKER has bSameWH = 1
                                    let anotherarray:NSMutableArray = NSMutableArray()
                                    if let onearray:NSArray = onedic["objWorkingHours"] as? NSArray {

                                        for item in onearray {
                                            if let mydicfast:NSDictionary = item as? NSDictionary {
                                                if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                    if !anotherarray.contains(MYDAYINTS) {
                                                        anotherarray.add(MYDAYINTS)
                                                    }
                                                }
                                            }
                                        }
                                        //       Global.sharedInstance.FREEDAYSSUPPLIER
                                        let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                        for item in FIXEDNUMBERS {
                                            if !anotherarray.contains(item) {
                                                if !Global.sharedInstance.NOWORKINGDAYS.contains(item) {
                                                    Global.sharedInstance.NOWORKINGDAYS.add(item)
                                                }
                                            }
                                        }
                                    }
                                    print("NOWORKINGDAYS \(Global.sharedInstance.NOWORKINGDAYS)")
                                }

                                if let seconddic:Dictionary<String,AnyObject> = mydic["objProviderGeneralDetails"] as? Dictionary<String,AnyObject> {
                                    if let onearray:NSArray = seconddic["objServiceProviders"] as? NSArray
                                    {
                                        for item in onearray {
                                            let freedaysworkersrarray:NSMutableArray = NSMutableArray()
                                            let blockdaysworkersrarray:NSMutableArray = NSMutableArray()
                                            let USERX:NSMutableDictionary = NSMutableDictionary()
                                            if let mydicfast:NSDictionary = item as? NSDictionary {
                                                if let MYDAYINTS:Int = mydicfast["bSameWH"] as? Int {
                                                    var miUSERID:Int = 0
                                                    if let mydicuser:NSDictionary = mydicfast["objUsers"] as? NSDictionary {
                                                        if let _:Int = mydicuser["iUserId"] as? Int {
                                                            miUSERID = mydicuser["iUserId"] as! Int
                                                        }
                                                    }
                                                    if MYDAYINTS == 1 {
                                                        //same hours as provider
                                                        USERX["bSameWH"] = MYDAYINTS
                                                        USERX["WORKERID"] = miUSERID
                                                        USERX["FREEDAYS"] = Global.sharedInstance.NOWORKINGDAYS
                                                        if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                            Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                        }
                                                    } else {
                                                        //custom hours
                                                        if let workerhoursarraay:NSArray = mydicfast["objWorkingHours"] as? NSArray {
                                                            for item in workerhoursarraay {
                                                                if let mydicfast:NSDictionary = item as? NSDictionary {
                                                                    if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                                        if !freedaysworkersrarray.contains(MYDAYINTS) {
                                                                            freedaysworkersrarray.add(MYDAYINTS)
                                                                            print("MYDAYINTS \(MYDAYINTS)")
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            //       Global.sharedInstance.FREEDAYSSUPPLIER
                                                            let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                                            for item in FIXEDNUMBERS {
                                                                if !freedaysworkersrarray.contains(item) {
                                                                    if !blockdaysworkersrarray.contains(item) {
                                                                        blockdaysworkersrarray.add(item)
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        }
                                                        USERX["bSameWH"] = MYDAYINTS
                                                        USERX["WORKERID"] = miUSERID
                                                        USERX["FREEDAYS"] = blockdaysworkersrarray
                                                        if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                            Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                print("Global.sharedInstance.FREEDAYSALLWORKERS \(Global.sharedInstance.FREEDAYSALLWORKERS)")
                                Global.sharedInstance.isFIRSTSUPPLIER = true
                                var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                dicForDefault["supplierRegistered"] = true as AnyObject
                                Global.sharedInstance.defaults.set(dicForDefault, forKey: "isSupplierRegistered")
                                Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
                                Global.sharedInstance.isProvider = true
                                var iBusinessStatus:Int = 0
                                var iSupplierStatus:Int = 0
                                if let  _:Int = mydic["iBusinessStatus"] as? Int {
                                    iBusinessStatus = mydic["iBusinessStatus"] as! Int
                                }
                                if let  _:Int = mydic["iSupplierStatus"] as? Int {
                                    iSupplierStatus = mydic["iSupplierStatus"] as! Int
                                }
                                Global.sharedInstance.defaults.set(iBusinessStatus,  forKey: "iBusinessStatus")
                                Global.sharedInstance.defaults.set(iSupplierStatus,  forKey: "iSupplierStatus")
                                var iSyncedStatus:Int = 0
                                if let  _:Int = mydic["iSyncedStatus"] as? Int {
                                    iSyncedStatus = mydic["iSyncedStatus"] as! Int
                                }
                                Global.sharedInstance.defaults.set(iSyncedStatus,  forKey: "iSyncedStatus")
                                Global.sharedInstance.defaults.synchronize()
                                
                                
                                let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                                let frontviewcontroller = storyboard1.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                                let vc = self.supplierStoryBoard?.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
                                frontviewcontroller?.pushViewController(vc, animated: false)
                                let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                let mainRevealController = SWRevealViewController()
                                mainRevealController.frontViewController = frontviewcontroller
                                mainRevealController.rearViewController = rearViewController
                                let window :UIWindow = UIApplication.shared.keyWindow!
                                window.rootViewController = mainRevealController
                            }
                        }
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
    func GetProviderSettingsForCalendarmanagement() {
        
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
        self.generic.showNativeActivityIndicator(self)
        dicSearch["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
             self.generic.hideNativeActivityIndicator(self)
            //Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
             self.afterProviderSettingsForCalendar()
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                      self.generic.hideNativeActivityIndicator(self)
                    print("responseObject \(responseObject ??  1 as AnyObject)")
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                let possiblerezult:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                if let _:Int = possiblerezult["iFirstCalendarViewType"] as? Int {
                                    self.iFirstCalendarViewType = possiblerezult["iFirstCalendarViewType"] as! Int
                                     Global.sharedInstance.isSyncWithGoogelCalendarSupplier =  false
                                    if let _:Int = possiblerezult["bIsGoogleCalendarSync"] as? Int {
                                        let myint = possiblerezult["bIsGoogleCalendarSync"] as! Int
                                        if myint == 0 {
                                            Global.sharedInstance.isSyncWithGoogelCalendarSupplier =  false
                                            let USERDEF = Global.sharedInstance.defaults
                                            USERDEF.set(0, forKey: "SHOWEYEINCALENDARSUPPLIER")
                                            USERDEF.synchronize()

                                        } else {
                                            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true
                                            let USERDEF = Global.sharedInstance.defaults
                                            USERDEF.set(1, forKey: "SHOWEYEINCALENDARSUPPLIER")
                                            USERDEF.synchronize()
                                        }
                                    }

                                }

                                

                            }
                        }
                    }
                }
                  self.afterProviderSettingsForCalendar()
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                  self.generic.hideNativeActivityIndicator(self)
                self.afterProviderSettingsForCalendar()
            })
        }
    }
    func afterProviderSettingsForCalendar() {
        CentralButtonImg.image = UIImage(named: "Plus menu icon - Supplier")
        CentralButton.frame = CGRect(x: CentralButton.frame.origin.x, y: CentralButton.frame.origin.y, width: self.view.frame.size.width * 0.25, height: self.view.frame.size.width * 0.25 * 0.8)
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.interactivePopGestureRecognizer?.delegate  = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        var differentframeview1 = CGRect(x:0, y:0, width:0, height:0)
        var differentframeview2 = CGRect(x:0, y:0, width:0, height:0)
     if UIDevice.current.userInterfaceIdiom == .pad {
            differentframeview1 = CGRect(x: 0, y: subView.frame.height + (64 * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height -  CentralButton.frame.size.height)
            differentframeview2 = CGRect(x: 0, y: subView.frame.height + (64 * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height / 1.2  - CentralButton.frame.size.height)
        } else {
            differentframeview1 = CGRect(x: 0, y: subView.frame.height + (64 * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height - 25 - CentralButton.frame.size.height)
            differentframeview2 = CGRect(x: 0, y: subView.frame.height + (64 * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height / 1.22  - CentralButton.frame.size.height)
        }
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        view4 = storybrd.instantiateViewController(withIdentifier: "DayDesignSupplierViewController") as! DayDesignSupplierViewController
        view2 = storybrd.instantiateViewController(withIdentifier: "ListDesignViewController") as! ListDesignViewController
        view1 = storybrd.instantiateViewController(withIdentifier: "MonthDesignSupplierViewController") as! MonthDesignSupplierViewController

        view1.view.frame = differentframeview2
        view2.view.frame = differentframeview1
        view4.view.frame = differentframeview1



       
        self.addChild(view1)
        self.addChild(view2)
    //JMODE 31.01.2019    self.addChildViewController(view3)
        self.addChild(view4)
        self.view.addSubview(view1.view)
        self.view.addSubview(view2.view)
   //JMODE 31.01.2019     self.view.addSubview(view3.view)
        self.view.addSubview(view4.view)
        view1.view.isHidden = true
        view2.view.isHidden = true
   //JMODE 31.01.2019     view3.view.isHidden = true
        view4.view.isHidden = true
        view2.FROMPRINT = false
   //JMODE 31.01.2019     view3.FROMPRINT = false
        view4.FROMPRINT = false
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(CalendarSupplierViewController.imageTapped))
//        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
//        {
//            imgMenu.image = UIImage(named: "plushebrewsupplier.png")
//            imgMenu.isHidden = false
//            imgMenu.isUserInteractionEnabled = true
//            myPlusImgEnglish.isHidden = true
//            myPlusImgEnglish.isUserInteractionEnabled = false
//            imgMenu.addGestureRecognizer(tapGestureRecognizer)
//        }
//        else
//        {
//            myPlusImgEnglish.image = UIImage(named: "plushebrewsupplier.png")
//            myPlusImgEnglish.isHidden = false
//            myPlusImgEnglish.isUserInteractionEnabled = true
//            imgMenu.isHidden = true
//            imgMenu.isUserInteractionEnabled = true
//            myPlusImgEnglish.addGestureRecognizer(tapGestureRecognizer)
//        }







        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalendarSupplierViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        monthlyBtn.isUserInteractionEnabled = true
        recordBtn.isUserInteractionEnabled = true
        dayBtn.isUserInteractionEnabled = true
        let USERDEF = UserDefaults.standard
        print(USERDEF.integer(forKey: "iFirstCalendarViewType"))
         if USERDEF.object(forKey: "iFirstCalendarViewType") != nil {
        if USERDEF.integer(forKey: "iFirstCalendarViewType") != 10 {
            self.iFirstCalendarViewType = USERDEF.integer(forKey: "iFirstCalendarViewType")
        }
        }
       if USERDEF.integer(forKey: "FORCEDAYOPEN") == 1 {
         self.iFirstCalendarViewType = 0
         print( USERDEF.object(forKey: "DAYTOOPEN"))
        if USERDEF.object(forKey: "DAYTOOPEN") != nil {

            if  let _:Int = USERDEF.value(forKey: "DAYTOOPEN")  as? Int {
                let myin = USERDEF.integer(forKey: "DAYTOOPEN")
                if myin == 0 {
                print("nexam")

            } else
                if let _:String = USERDEF.value(forKey: "DAYTOOPEN") as? String {
                    let mydate =  USERDEF.value(forKey: "DAYTOOPEN") as! String
                     MYDATE =  Global.sharedInstance.getStringFromDateString(mydate)
                }
            } else
            if let _:String = USERDEF.value(forKey: "DAYTOOPEN") as? String {
               let mydate =  USERDEF.value(forKey: "DAYTOOPEN") as! String
                print("mywonder \(mydate)")
                MYDATE =  Global.sharedInstance.getStringFromDateString(mydate)
            }
        }
       } else {
        MYDATE = Date()
        }




        switch (self.iFirstCalendarViewType) {
           
        case 0: //dayview
            selectedView = view4
            view4.view.isHidden = false
            Calendar.sharedInstance.carrentDate = MYDATE
            view4.initDate(MYDATE)
            view4.setDateClick(MYDATE)
            self.dayBtn(dayBtn)
            if Global.sharedInstance.isFIRSTSUPPLIER == true {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.view4.frommonthorweek = false
                    self.view4.bestmode()
                    self.view4.view.setNeedsDisplay()
                })
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
                {
                    view4.btnSyncGoogelSupplier.isCecked = true 
                }
                else
                {
                    view4.btnSyncGoogelSupplier.isCecked = false
                }
                
            }
            //hide week view
//        case 1: //weekdesign
//            USERDEF.setValue(0, forKey:"FORCEDAYOPEN")
//            USERDEF.setValue(0, forKey:"DAYTOOPEN")
//            USERDEF.setValue(0, forKey:"HOURTOOPEN")
//            USERDEF.synchronize()
//            view3.view.isHidden = false
//            selectedView = view3
//            self.weekBtn(weekBtn)
//
        case 1: //day again
            selectedView = view4
            view4.view.isHidden = false
            Calendar.sharedInstance.carrentDate = MYDATE
            view4.initDate(MYDATE)
            view4.setDateClick(MYDATE)
            self.dayBtn(dayBtn)
            if Global.sharedInstance.isFIRSTSUPPLIER == true {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.view4.frommonthorweek = false
                    self.view4.bestmode()
                    self.view4.view.setNeedsDisplay()
                })
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
                {
                    view4.btnSyncGoogelSupplier.isCecked = true
                }
                else
                {
                    view4.btnSyncGoogelSupplier.isCecked = false
                }
                
            }
            
        case 2: //month design
            USERDEF.setValue(0, forKey:"FORCEDAYOPEN")
            USERDEF.setValue(0, forKey:"DAYTOOPEN")
            USERDEF.setValue(0, forKey:"HOURTOOPEN")
            USERDEF.synchronize()
            view1.view.isHidden = false
            selectedView = view1
            self.monthlyBtn(monthlyBtn)
            
        case 3: //left to do listview
            USERDEF.setValue(0, forKey:"FORCEDAYOPEN")
            USERDEF.setValue(0, forKey:"DAYTOOPEN")
            USERDEF.setValue(0, forKey:"HOURTOOPEN")
            USERDEF.synchronize()
            view2.view.isHidden = false
            selectedView = view2
            self.recordBtn(recordBtn)
            
        default:
            view1.view.isHidden = false
            selectedView = view1
            self.monthlyBtn(monthlyBtn)
        }

        
        
      
        
        if  Global.sharedInstance.isFromMenu == false{
            
        }
        else{
            Global.sharedInstance.isFromMenu = false
        }
        self.generic.hideNativeActivityIndicator(self)
        
        if (Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjServiceProviders.count > 1) {
            //JMODE FOR LIVE NO EMPLOYEES 21.03.2019
            showfirstemployepopup()
        }
        let tapOpenPlusMenuNewProvider:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewProvider))
        tapOpenPlusMenuNewProvider.delegate = self
        CentralButton.addGestureRecognizer(tapOpenPlusMenuNewProvider)
    }
    
    func readTrial2()
    {
        self.trialdetails2 = Array<Int>()
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
                if Reachability.isConnectedToNetwork() == false
                {
                    
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
                        self.calculateDaysTrialPeriod2()
                        
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        
                        
//                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        self.calculateDaysTrialPeriod2()
                    })
                }
            }
        }
    }
    
    func calculateDaysTrialPeriod2() {
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
        let componentstoday = (self.calendar1 as NSCalendar).components([.day, .month, .year], from: Date())
        let gregorian = Foundation.Calendar(identifier: .gregorian)
        var ondedate = Date()
        if  let _ = gregorian.date(from: componentstoday) as Date?
        {
            ondedate = gregorian.date(from: componentstoday)!
        }
        //server start pay date
        var trialstart = Date()
        let componentsserverdate = (self.calendar1 as NSCalendar).components([.day, .month, .year], from: APPDELdtCreateDate)
        if  let _ = gregorian.date(from: componentsserverdate) as Date?
        {
            trialstart = gregorian.date(from: componentsserverdate)!
        }
        
        let dateEndwhenTrialExpire = self.calendar1.date(byAdding: .day, value: APPDELiTrialDays, to: trialstart)
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
                        //     Alert.sharedInstance.showAlert("TEN_DAYS_LEFT_BEFORE_TRIAL_ENDS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
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
        self.trialdetails2 = myArr
        self.afterTrialCheck()
        //////////////////////////

        ///////////////////////
//        return myArr
    }
    
    func afterTrialCheck()
    {
        if self.trialdetails2.count == 2 {
            let whatstatus = self.trialdetails2[0]
            if whatstatus > 0  { // user has trial days from server
                let diff = self.trialdetails2[1] // number of days in difference from datetrial start to current date
                if diff <= 0 {
                    Global.sharedInstance.isProvider = false
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
                    //                         Alert.sharedInstance.showAlert("PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    gotoEntranceCustomer()
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
            } else {
                //nothing ..
            }
        }
    }
    func GetCalendarsOfSupplier(){

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
        self.generic.showNativeActivityIndicator(self)
        dicSearch["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
        }
        else
        {
            api.sharedInstance.GetCalendarsOfSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    self.generic.hideNativeActivityIndicator(self)
                    print("responseObject calendars \(responseObject ??  1 as AnyObject)")
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            let ps: objEMPLOYEE = objEMPLOYEE()
                            if let _:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String,AnyObject>>
                            {
                                var EMPLOYEES_ARRAY:Array<objEMPLOYEE> = Array<objEMPLOYEE>()
                                EMPLOYEES_ARRAY = ps.objServiceProvidersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)

                                print("self calendars\(EMPLOYEES_ARRAY)")
                                Global.sharedInstance.ARRAYCALENDAR = []
                                Global.sharedInstance.ARRAYCALENDAR = EMPLOYEES_ARRAY
                                for q in Global.sharedInstance.ARRAYCALENDAR {
                                    print(q.getDic())

                                }
                                self.creeate_calendars_free_hours()

                            }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)

            })
        }
    }
    //now creeate calendars free hours
    func creeate_calendars_free_hours()
    {
        print("Global.sharedInstance.FREEDAYSALLWORKERS \(Global.sharedInstance.FREEDAYSALLWORKERS)")
        Global.sharedInstance.FREEDAYSALLCALENDARS = []

        for a in Global.sharedInstance.ARRAYCALENDAR {
            let freedaysworkersrarray:NSMutableArray = NSMutableArray()
            let blockdaysworkersrarray:NSMutableArray = NSMutableArray()
            let USERX = NSMutableDictionary()
            let miUSERID = a.objsers.iUserId
            let bSameWH = a.bSameWH
            if bSameWH == true {
                //same hours as provider
                USERX["bSameWH"] = 1
                USERX["WORKERID"] = miUSERID
                USERX["FREEDAYS"] = Global.sharedInstance.NOWORKINGDAYS
                if !Global.sharedInstance.FREEDAYSALLCALENDARS.contains(USERX) {
                    Global.sharedInstance.FREEDAYSALLCALENDARS.add(USERX)
                }
            } else {
                //custom hours
                let workerhoursarraay = a.arrObjWorkingHours
                for z in workerhoursarraay {
                    let MYDAYINTS1:Int = z.iDayInWeekType
                    if !freedaysworkersrarray.contains(MYDAYINTS1) {
                        freedaysworkersrarray.add(MYDAYINTS1)
                        print("MYDAYINTS1 \(MYDAYINTS1)")
                    }
                }
                //       Global.sharedInstance.FREEDAYSSUPPLIER
                let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                for item in FIXEDNUMBERS {
                    if !freedaysworkersrarray.contains(item) {
                        if !blockdaysworkersrarray.contains(item) {
                            blockdaysworkersrarray.add(item)
                        }
                    }
                }

            USERX["bSameWH"] = 0
            USERX["WORKERID"] = miUSERID
            USERX["FREEDAYS"] = blockdaysworkersrarray
            if !Global.sharedInstance.FREEDAYSALLCALENDARS.contains(USERX) {
                Global.sharedInstance.FREEDAYSALLCALENDARS.add(USERX)
            }
            }

        }
        print("Global.sharedInstance.FREEDAYSALLCALENDARS \(Global.sharedInstance.FREEDAYSALLCALENDARS)")
    }
    func openview() {
        let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
        Global.sharedInstance.myIndexForEditWorker = 0 //NO EMPLOYEE IS IN EDIT BEFORE THIS SCREEN
        let viewSettingsSetupEmployees: SettingsSetupEmployees = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupEmployees")as! SettingsSetupEmployees
        viewSettingsSetupEmployees.modalPresentationStyle = .overCurrentContext
        viewSettingsSetupEmployees.view.frame = self.view.frame
        self.present(viewSettingsSetupEmployees, animated: true, completion: nil)
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
