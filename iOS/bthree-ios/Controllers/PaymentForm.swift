//
//  GenericWebView.swift
//  BThere
//
//  Created by Ioan Ungureanu on 19/07/2018
//  Copyright © 2018 BThere. All rights reserved.
//

import UIKit

class PaymentForm: NavigationModelViewController, UIWebViewDelegate {
    // Outlets
    @IBOutlet weak var titlescreen:UILabel!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet var liveChatWebView: UIWebView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var loadingWebActivity: UIActivityIndicatorView!
    @IBOutlet  weak var btnClose:UIButton!
    @IBOutlet weak var btnReloadPage:UIButton!
    @IBOutlet weak var btnback:UIButton!
    @IBAction func btnClose(_ sender: AnyObject) {
        //getProviderAllDetails()
             GetTokenByPN()
    }
    
    @IBAction func btnReloadPage(_ sender: AnyObject) {
        reloadPaymentPage()
    }
    var generic:Generic = Generic()
    var hastranzilatoken:Bool = false
    var userphone:String = ""
    var isfromSuppierSettings = false
    var isFROMCUSTOMER = false
    var popUpWorkingHours:popUpPaymentVC!
    
    func GetTokenByPN() {
        var userdic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.currentUser.nvPhone.count > 0 {
            userdic["nvPhone"] = Global.sharedInstance.currentUser.nvPhone as AnyObject
        }
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            self.generic.hideNativeActivityIndicator(self)
        }
        else
        {
            api.sharedInstance.GetTokenByPN(userdic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                print(responseObject)
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? Int {
                        let myresp = RESPONSEOBJECT["Result"] as! Int
                        if myresp == 1 {
                            //has code`
                            self.hastranzilatoken = true
                            self.getProviderAllDetails()
                        } else {
                            
                            
                            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                            let aaa:popUpPaymentVC = storyboardtest.instantiateViewController(withIdentifier: "popUpPaymentVC") as! popUpPaymentVC
                            let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
                            
                            if iOS8 == true {
                                aaa.modalPresentationStyle = UIModalPresentationStyle.custom
                            } else {
                                aaa.modalPresentationStyle = UIModalPresentationStyle.custom
                            }
                            self.present(aaa, animated: true, completion: nil)

                            
                            
                        }
                        
                    }
                }
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.hastranzilatoken = false
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }

    func reloadPaymentPage() {
        if Global.sharedInstance.currentUser.nvPhone.count > 0 {
            userphone = Global.sharedInstance.currentUser.nvPhone
            let stringURL = "https://direct.tranzila.com/ttxbthere/iframe.php?sum=5&lang=il&nologo=1&tranmode=VK&hidesum=1&phone=" + userphone
            let finalurl = stringURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            liveChatWebView.loadRequest(URLRequest(url: URL(string:finalurl!)!))
        } else {
            loadingWebActivity.stopAnimating()
            loadingWebActivity.isHidden = true
            self.showAlertDelegateX("MESSAGE_NO_PHONE_FOR_USER_FOUND".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isfromSuppierSettings == true || self.isFROMCUSTOMER == true
        {
            self.btnback.isHidden = false
            self.btnback.isUserInteractionEnabled = true
            self.backImg.isHidden = false
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                {
                    self.btnback.transform = scalingTransform
                    self.backImg.transform = scalingTransform
                }
        }
        else
        {
            self.btnback.isHidden = true
            self.btnback.isUserInteractionEnabled = false
            self.backImg.isHidden = true
            
        }
       // self.preferredContentSize = CGSize(width: self.view.frame.size.width - 80, height: 400)
        titlescreen.text = "PAYMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnReloadPage.setTitle("RETRY_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for:  UIControl.State())
        btnClose.setTitle("CONTINUE_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), for:  UIControl.State())
        liveChatWebView.delegate = self
        liveChatWebView.scrollView.bounces = false
        
        //  liveChatWebView.scalesPageToFit = true
        if Global.sharedInstance.currentUser.nvPhone.count > 0 {
            userphone = Global.sharedInstance.currentUser.nvPhone
            let stringURL = "https://direct.tranzila.com/ttxbthere/iframe.php?sum=5&lang=il&nologo=1&tranmode=VK&hidesum=1&phone=" + userphone
            let finalurl = stringURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            liveChatWebView.loadRequest(URLRequest(url: URL(string:finalurl!)!))
        } else {
            loadingWebActivity.stopAnimating()
            loadingWebActivity.isHidden = true
            self.showAlertDelegateX("MESSAGE_NO_PHONE_FOR_USER_FOUND".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction  func goBackButton(_ sender: AnyObject) {
        if isFROMCUSTOMER == true {
            self.openEntrance()
        } else {
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        frontviewcontroller!.pushViewController(viewcon, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:54)  
       
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingWebActivity.stopAnimating()
        loadingWebActivity.isHidden = true
    }
    func getProviderAllDetails()
    {
        Global.sharedInstance.FREEDAYSALLWORKERS = []
        Global.sharedInstance.NOWORKINGDAYS = []
        //show a loader
        let iUserId = Global.sharedInstance.currentUser.iUserId
        if let topController = UIApplication.topViewController() {
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            view8 = storyboard1.instantiateViewController(withIdentifier: "loadingBthere") as! loadingBthere
            let screenSize: CGRect = UIScreen.main.bounds
            view8.view.frame = screenSize
            view8.view.tag = 2000
            
            topController.view.addSubview(view8.view)
            topController.view.bringSubviewToFront(view8.view)
        }
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicUserId["iUserId"] = iUserId as AnyObject
        
        
        
        api.sharedInstance.getProviderAllDetails(dicUserId, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                    {
                        if (self.view8.view.window != nil) {
                            self.view8.view.removeFromSuperview()
                        }
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                    {
                        if (self.view8.view.window != nil) {
                            self.view8.view.removeFromSuperview()
                        }
                        UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")
                    }
                        
                    else
                    {
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                        //\\    print("crash 1 \(String(describing: RESPONSEOBJECT["Result"]))")
                            if (self.view8.view.window != nil) {
                                self.view8.view.removeFromSuperview()
                            }
                            if let _:ProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj((RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!) {
                                
                                Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                //\\print ("exact \( Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.description)")
                                
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
                                var dicForDefault1:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                dicForDefault1["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                                Global.sharedInstance.defaults.set(dicForDefault1, forKey: "supplierNameRegistered")
                                var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                dicForDefault["supplierRegistered"] = true as AnyObject
                                Global.sharedInstance.defaults.set(dicForDefault, forKey: "isSupplierRegistered")
                                Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
                                //because every new add business make the maker a manager
                                Global.sharedInstance.defaults.set(1, forKey:"ismanager")
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
                                
                                /// status 1
                            
                                let USERDEF = UserDefaults.standard
                                if  USERDEF.object(forKey: "iSupplierStatus") != nil  {
                                    print(USERDEF.integer(forKey: "iSupplierStatus"))
                                    if USERDEF.integer(forKey: "iSupplierStatus") == 2 {
                                        //contacts sync but trial expired
                                      Global.sharedInstance.isProvider = false
                                        self.openEntrance()
                                      
                                    }
                                    if USERDEF.integer(forKey: "iSupplierStatus") == 2 {
                                        //contacts sync but trial expired
                                        Global.sharedInstance.isProvider = true
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
                                    if USERDEF.integer(forKey: "iSupplierStatus") == 0 {
                                        self.openEntrance()
                                    }
                                }
                               
                                
                            }
                        }
                        
                        
                    }
                }
                //\\ self.getServicesProviderForSupplierfuncdoi()
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            if (self.view8.view.window != nil) {
                self.view8.view.removeFromSuperview()
            }
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
        })
    }
    func openEntrance() {
        
        
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
        Global.sharedInstance.defaults.synchronize()
        let rgister:entranceCustomerViewController = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        rgister.modalPresentationStyle = UIModalPresentationStyle.custom
        frontViewController.pushViewController(rgister, animated: false)
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController
        
        self.view.window!.rootViewController = mainRevealController
        self.view.window?.makeKeyAndVisible()
        
    }
}

