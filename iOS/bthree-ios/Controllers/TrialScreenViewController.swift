//
//  TrialScreenViewController.swift
//  BThere
//
//  Created by Ioan Ungureanu on 25/07/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit
//תקנון ותנאי השימוש
class TrialScreenViewController: NavigationModelViewController {
 
    //MARK: - Outlet
    
    @IBOutlet weak var TITLE_TRIAL: UILabel!
    @IBOutlet weak var LINE_ONE_TRIAL: UILabel!
    @IBOutlet weak var LINE30DAYS_TRIAL: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var BTNTRIALNO: UIButton!
    @IBOutlet weak var BTNTRIALYES: UIButton!
    
    @IBAction func BTNTRIALNO(_ sender: AnyObject) {
      //  getProviderAllDetails()
        Global.sharedInstance.defaults.set(0,  forKey: "iBusinessStatus")
        Global.sharedInstance.defaults.set(0,  forKey: "iSupplierStatus")
        Global.sharedInstance.defaults.synchronize()
        openEntrance()
    }
    @IBAction func BTNTRIALYES(_ sender: AnyObject) {
    
        self.openPaymentForm()
  
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
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
                TITLE_TRIAL.text = "TITLE_TRIAL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                LINE_ONE_TRIAL.text = "LINE_ONE_TRIAL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                LINE30DAYS_TRIAL.text = "LINE30DAYS_TRIAL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                BTNTRIALYES.setTitle("BTNTRIALYES".localized(LanguageMain.sharedInstance.USERLANGUAGE), for:  UIControl.State())
                BTNTRIALNO.setTitle("BTNTRIALNO".localized(LanguageMain.sharedInstance.USERLANGUAGE), for:  UIControl.State())
                
                if   let rtf = Bundle.main.url(forResource: "trialversion", withExtension: "rtf", subdirectory: nil, localization: nil) {
                    
                    do {
                        let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                        self.txtView.attributedText  = attributedString
                        self.txtView.textAlignment = .right
                    } catch let error {
                        print("Got an error \(error)")
                    }
            }
        
    
       
        self.txtView.setContentOffset(.zero, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLayoutSubviews() {
        self.txtView.setContentOffset(.zero, animated: true)
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
                     //\\       print("crash 1 \(String(describing: RESPONSEOBJECT["Result"]))")
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
    func openPaymentForm() {
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
        window.rootViewController = mainRevealController
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}
