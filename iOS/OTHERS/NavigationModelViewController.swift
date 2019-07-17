//
//  NavigationModelViewController.swift
//  bthree-ios
//
//  Created by Lior Ronen on 2/17/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import Social

class NavigationModelViewController: UIViewController {
    var view8 : loadingBthere!
    //MARK: - Properties
    //var generic:Generic = Generic()
    var backButton: UIBarButtonItem?
    var backButtonleft: UIBarButtonItem?
    var storyBoard1:UIStoryboard?
    var supplierStoryBoard:UIStoryboard?
    var button:UIButton = UIButton()
    var navLabel: UILabel?
    var leftbtnImage:UIImage?
    var trialdetails:Array<Int> = Array<Int>()
    let mainRevealController:SWRevealViewController =  SWRevealViewController()
    let calendar1 = Foundation.Calendar.current
    var  generictwo:Generic = Generic()
    //MARK: - Initial
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
     //   readTrial()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
  
        //
        //        if AppDelegate.fromChangeLanguage == false
        //        {
        //            if AppDelegate.isDeviceLanguageRTL()
        //            {
        //                Global.sharedInstance.rtl = true
        //            }
        //            else
        //            {
        //                Global.sharedInstance.rtl = false
        //            }
        //        }
        //        else
        //        {
        //            AppDelegate.fromChangeLanguage = false
        //        }
        if Global.sharedInstance.defaults.value(forKey: "currentClintName") != nil//לא מצב צפיה
        {
            //פתיחת תפריט צד בהחלקה על המסך הצידה
            if self.revealViewController() != nil
            {
        //        self.self.revealViewController(). GestureRecognizer().isEnabled = false
//                self.revealViewController().panGestureRecognizer().location(in: self.view)
//                self.revealViewController().panGestureRecognizer()
//                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
        
        supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        storyBoard1 = UIStoryboard(name: "Main", bundle: nil)
        let menueBtn: UIButton = UIButton(type: .custom)
        let menueBtnImage: UIImage = UIImage(named: "icon-menu.png")!
        
        menueBtn.setBackgroundImage(menueBtnImage, for: UIControl.State())
        
        menueBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        menueBtn.addTarget(self, action: #selector(self.openSideMenu), for: .touchUpInside)
        
        menueBtn.frame = CGRect(x: -11, y: -7, width: 35, height: 28)
        
        let backButtonView: UIView = UIView(frame: CGRect(x: 0, y: -15, width: 44, height: 34))
        backButtonView.bounds = backButtonView.bounds.offsetBy(dx: -14, dy: -7)
        backButtonView.addSubview(menueBtn)
        
        backButton = UIBarButtonItem(customView: backButtonView)
        // self.navigationItem.rightBarButtonItem = backButton
        
        //  if Global.sharedInstance.rtl
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            self.navigationItem.rightBarButtonItem = self.backButton//menu button in right
        }
        else
        {
            self.navigationItem.leftBarButtonItem = self.backButton//menu button in left
        }
        
        
        //Bthere picture
//        let backView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
//        let titleImageView: UIImageView = UIImageView(image: UIImage(named: "3.png"))
//        titleImageView.frame = CGRect(x: 0, y: 0, width: titleImageView.frame.size.width * 0.8, height: 40)
//        // Here I am passing origin as (45,5) but can pass them as your requirement.
//        backView.addSubview(titleImageView)
//        self.navigationItem.titleView = backView
        
        //label to show name of client or supplier
        //  let navLabel: UILabel = UILabel(frame: CGRectMake(self.view.frame.width - 90, 19, 90, 30))
        navLabel = UILabel(frame: CGRect(x: self.view.frame.width - 90, y: 19, width: 90, height: 30))
        navLabel!.textColor = UIColor.red
        navLabel!.textAlignment = .center
        self.navigationController?.navigationBar.addSubview(navLabel!)
        navLabel!.backgroundColor = UIColor.clear
        navLabel!.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
        
        
        
        let leftbtn: UIButton = UIButton(type: .custom)
        //let leftbtnImage: UIImage?

        
        
        if Global.sharedInstance.isProvider == true
        {
            self.navLabel!.textColor = Colors.sharedInstance.color4
            leftbtnImage = UIImage(named: "user-2.png")!
            
            
            //iustin
            let screenRect:CGRect = UIScreen.main.bounds
            if screenRect.size.height == 568
            {
                let backView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
                let titleImageView: UIImageView = UIImageView(image: UIImage(named: "3.png"))
                titleImageView.frame = CGRect(x: 0, y: 0, width: titleImageView.frame.size.width * 0.6, height: 30)
                titleImageView.center.x = backView.center.x
                let businessLabel: UILabel = UILabel(frame: CGRect(x: backView.bounds.size.width * 0.35, y:(titleImageView.bounds.size.height), width: 70, height: 10))
                //            businessLabel.center = CGPoint(x: 160, y: 285)
                businessLabel.textAlignment = .center
                businessLabel.text = "NAVIGATION_BUSINESS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                businessLabel.textColor = UIColor(red:0.57, green:0.80, blue:0.85, alpha:1.0)
                businessLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
                businessLabel.center.x = backView.center.x
//                businessLabel.sizeToFit()
                // Here I am passing origin as (45,5) but can pass them as your requirement.
                backView.addSubview(titleImageView)
                backView.addSubview(businessLabel)
                self.navigationItem.titleView = backView
            }
            else
            {
                
                let backView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.7))
                let titleImageView: UIImageView = UIImageView(image: UIImage(named: "3.png"))
//                titleImageView.frame = CGRect(x: backView.bounds.size.width * 0.20  , y: 0, width: backView.bounds.size.width * 0.7, height: 28)
                titleImageView.frame = CGRect(x: 0, y: 0, width: titleImageView.frame.size.width * 0.6, height: 30)
                titleImageView.center.x = backView.center.x
                let businessLabel: UILabel = UILabel(frame: CGRect(x: backView.bounds.size.width * 0.35, y:(titleImageView.bounds.size.height), width: 90, height: 12))
                //            businessLabel.center = CGPoint(x: 160, y: 285)
                businessLabel.textAlignment = .center
                businessLabel.text = "NAVIGATION_BUSINESS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                businessLabel.textColor = UIColor(red:0.57, green:0.80, blue:0.85, alpha:1.0)
                businessLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
                businessLabel.center.x = backView.center.x
//                businessLabel.sizeToFit()
                // Here I am passing origin as (45,5) but can pass them as your requirement.
                backView.addSubview(titleImageView)
                backView.addSubview(businessLabel)
                self.navigationItem.titleView = backView
            }
            

            
            if Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil {
                
                var dicSupplierName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") as! Dictionary<String,String>
                if dicSupplierName["nvSupplierName"] != ""
                {
                    self.navLabel!.text = dicSupplierName["nvSupplierName"]
                    //Global.sharedInstance.currentProvider.nvSupplierName 
                }
                else
                {
                    if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1 // && Global.sharedInstance.defaults.integerForKey("ismanager") == 0
                    {
                        if Global.sharedInstance.defaults.value(forKey: "currentClintName") != nil
                        {
                            var dicClientName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "currentClintName") as! Dictionary<String,String>
                            if dicClientName["nvClientName"] != ""
                            {
                                self.navLabel!.text = dicClientName["nvClientName"]//Global.sharedInstance.currentUser.nvFirstName
                            }
                            else
                            {
                                self.navLabel!.text = "NAME_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            }
                        }
                        
                    }
                    //  navLabel.text = "NAME_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                }
            } else if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName.count > 0 {
                 self.navLabel!.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName
            }
            else
            {
                navLabel!.text = "NAME_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                
            }
        
            
            
        }
        else
        {
            let backView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
            let titleImageView: UIImageView = UIImageView(image: UIImage(named: "3.png"))
            titleImageView.frame = CGRect(x: 0, y: 0, width: titleImageView.frame.size.width * 0.8, height: 40)
            // Here I am passing origin as (45,5) but can pass them as your requirement.
            backView.addSubview(titleImageView)
            self.navigationItem.titleView = backView
            
            navLabel!.textColor = Colors.sharedInstance.color3
            leftbtnImage = UIImage(named: "customerIcon1.png")!
            
            if Global.sharedInstance.defaults.value(forKey: "currentClintName") != nil
            {
                var dicClientName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "currentClintName") as! Dictionary<String,String>
                if dicClientName["nvClientName"] != ""
                {
                    navLabel!.text = dicClientName["nvClientName"]//Global.sharedInstance.currentUser.nvFirstName
                }
                else
                {
                    navLabel!.text = "NAME_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                }
            }
            else
            {
                //מצב צפיה - כפתור חזור למסך כניסה למקרה שירצה להכנס כלקוח קיים
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.leftBarButtonItem = nil
                
                let leftToViewMode: UIButton = UIButton(type: .custom)
                leftToViewMode.setTitle("<", for: UIControl.State())
                leftToViewMode.titleLabel?.font = UIFont(name: "OpenSansHebrew-Bold", size: 25)
                leftToViewMode.setTitleColor(UIColor.white, for: UIControl.State())
                leftToViewMode.addTarget(self, action: #selector(NavigationModelViewController.goToEntrance), for: .touchUpInside)
                leftToViewMode.frame = CGRect(x: self.view.frame.size.width - 50, y: 0, width: 50, height: 50)
                self.navigationController?.navigationBar.addSubview(leftToViewMode)
                
                button = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: -15, width: 90, height: 60))
                button.backgroundColor = UIColor.clear
                //button.setTitle("", forState: .Normal)
                button.addTarget(self, action: #selector(NavigationModelViewController.goToEntrance), for: .touchUpInside)
                self.navigationController?.navigationBar.addSubview(button)
                self.navigationItem.setHidesBackButton(true, animated:true)
            }
        }
        if Global.sharedInstance.defaults.value(forKey: "currentClintName") != nil || Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
        {
            leftbtn.setBackgroundImage(leftbtnImage, for: UIControl.State())
            leftbtn.addTarget(self, action: #selector(NavigationModelViewController.fixPROVIDERID), for: .touchUpInside)
            let backButtonV: UIView = UIView(frame: CGRect(x: 0, y: -15, width: 20, height: 20))
            if Global.sharedInstance.isProvider == true
            {
                leftbtn.frame = CGRect(x: -30, y: -15, width: 35, height: 20)
                backButtonV.bounds = backButtonView.bounds.offsetBy(dx: -14, dy: -7)
            }
            else
            {
                leftbtn.frame = CGRect(x: -30, y: -15, width: 25, height: 25)
//                leftbtn.imageView?.center.x = leftbtn.center.x
                backButtonV.bounds = backButtonView.bounds.offsetBy(dx: -21, dy: -3)
                
            }
            
            
//            backButtonV.bounds = backButtonView.bounds.offsetBy(dx: -14, dy: -7)
            
            backButtonV.addSubview(leftbtn)
            leftbtn.bounds.origin.x = backButtonV.center.x
//            navLabel!.bounds.origin.x = backButtonV.center.x
            //iustin
            

            
            backButtonleft = UIBarButtonItem(customView: backButtonV)
            //  self.navigationItem.leftBarButtonItem = backButtonleft
            
            //     if Global.sharedInstance.rtl
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
            {
                self.navigationItem.leftBarButtonItem = self.backButtonleft//providerCustomer in left
                // button = UIButton(frame: CGRect(x: 0, y: -15, width: 90, height: 60))
                self.button = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: -15, width: 90, height: 60))
                
            }
            else
            {
                self.button = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: -15, width: 90, height: 60))
                self.navigationItem.rightBarButtonItem = self.backButtonleft//providerCustomer in right
            }
            //   button = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: -15, width: 90, height: 60))
            button.backgroundColor = UIColor.clear
            //button.setTitle("", forState: .Normal)
            button.addTarget(self, action: #selector(NavigationModelViewController.fixPROVIDERID), for: .touchUpInside)
            self.navigationController?.navigationBar.addSubview(button)
            
            /*
             if Global.sharedInstance.rtl
             {
             self.navigationItem.setLeftBarButtonItems([backButton!], animated: true)
             }
             else
             {
             self.navigationItem.setRightBarButtonItems([backButtonleft!], animated: true)
             }
             */
            
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        print("height navigation bar: \(String(describing: self.navigationController?.navigationBar.frame.size.height))")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tryGetSupplierCustomerUserIdByEmployeeIddoi() {
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
                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                    //\\print("sup id e ok ? " + myInt.description)
                    if myInt == 0 {
                        //NO EMPL NO BUSINESS
                        //   self.setupdefaults(0)
                        //\\print ("no business")
                    } else {
                        //self.setupdefaults(myInt)
                        self.callgetprovideralldetails(myInt)
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
    
    func callgetprovideralldetails(_ iUseridSupplier:Int)
    {
        if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
        {
            api.sharedInstance.getProviderAllDetailsbySimpleUserID(iUseridSupplier)
        }
        else
        {
            api.sharedInstance.getProviderAllDetails(iUseridSupplier)
        }
    }
    //move to customer or provider
    //when click on image provider/customer in top
    @objc func fixPROVIDERID() {
        self.generictwo.showNativeActivityIndicator(self)
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if dicUserId["currentUserId"] as! Int != 0
            {
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                api.sharedInstance.GetSupplierIdByEmployeeId(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                     self.generictwo.hideNativeActivityIndicator(self)
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
                    self.GetSecondUserIdByFirstUserIdTwo()

                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                      self.generictwo.hideNativeActivityIndicator(self)
                    self.GetSecondUserIdByFirstUserIdTwo()
                    
                })
            }
        }
    }
    
    //iustin
    func getEmployeePermissions(_ employeID:Int)
    {
          self.generictwo.showNativeActivityIndicator(self)
        var dicEmployeePermissions:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        if employeID != 0
        {
            dicEmployeePermissions["iProviderUserId"] = employeID as AnyObject
//            dicEmployeePermissions["iProviderUserId"] = 28797 as AnyObject
            print("ce trimit: \(dicEmployeePermissions)")
            if Reachability.isConnectedToNetwork() == false
            {
                //            self.generic.hideNativeActivityIndicator(self)
                  self.generictwo.hideNativeActivityIndicator(self)
            }
            else
            {
                api.sharedInstance.GetEmployeeMobilePermissions(dicEmployeePermissions,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                          self.generictwo.hideNativeActivityIndicator(self)
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        print("response GetEmployeeMobilePermissions: \(String(describing: RESPONSEOBJECT["Result"]))")
                        
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int
                        {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Int>
                                {
                                    Global.sharedInstance.employeesPermissionsArray = RESPONSEOBJECT["Result"] as! Array<Int>
                                    print("Global.sharedInstance.employeesPermissionsArray: \(Global.sharedInstance.employeesPermissionsArray)")
                                }
                                else
                                {
                                    Alert.sharedInstance.showAlertDelegate("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    print("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                            }
                            else
                            {
                                Alert.sharedInstance.showAlertDelegate("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                print("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                        }
                        self.providerCustomer()
                    }
                    
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                      self.generictwo.hideNativeActivityIndicator(self)
                    Alert.sharedInstance.showAlertDelegate("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    print("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    self.providerCustomer()
                    //                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                })
            }
        }


    }
    
    func GetSecondUserIdByFirstUserIdTwo()  {
          self.generictwo.showNativeActivityIndicator(self)
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
                  self.generictwo.hideNativeActivityIndicator(self)
            }
            else
            {
                api.sharedInstance.GetSecondUserIdByFirstUserId(dicEMPLOYE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                          self.generictwo.hideNativeActivityIndicator(self)
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
                                        print("SECOND USER ID \(myInt)")
                                        if myInt > 0 {
                                            self.getEmployeePermissions(myInt)
//                                            self.providerCustomer()
                                        } else {
                                            self.providerCustomer()
                                        }
                                    }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                      self.generictwo.hideNativeActivityIndicator(self)
                    self.providerCustomer()
                })
            }
        }
        

    }
    
    
//    func tryGetSupplierCustomerUserIdByEmployeeIdTwo() {
//        var y:Int = 0
//        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
//            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
//            if let x:Int = a.value(forKey: "currentUserId") as? Int{
//                y = x
//            }
//        }
//        dicuser["iUserId"] =  y as AnyObject
//        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//            if let _ = responseObject as? Dictionary<String,AnyObject> {
//                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                if let _:Int = RESPONSEOBJECT["Result"] as? Int
//                {
//                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
//                    print("sup id e ok ? " + myInt.description)
//                    if myInt == 0 {
//
//                    } else {
//                        self.GetSecondUserIdByFirstUserIdTwo(myInt)
//                    }
//                }
//            }
//        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//
//        })
//    }

    
    
    
    func providerCustomer()
    {
        
        let USERDEF = UserDefaults.standard
        print("entering register key: \(String(describing: USERDEF.value(forKey: "isenteringregister")))")
    //    Global.sharedInstance.defaults.set(iSyncedStatus,  forKey: "iSyncedStatus")
        if  USERDEF.object(forKey: "iSupplierStatus") != nil && Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil {
         //   TEST MODE ONLY USERDEF.set(2, forKey: "iSupplierStatus")
         //   TEST MODE ONLY USERDEF.synchronize()
            if  USERDEF.integer(forKey: "iSupplierStatus") == 0   {
                
                if USERDEF.integer(forKey: "iSyncedStatus") == 0 {
                    //contacts sync but no payment
                    Global.sharedInstance.isProvider = false
                    Global.sharedInstance.whichReveal = false
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let storyboardone = UIStoryboard(name: "SupplierExist", bundle: nil)
                    let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                    let viewCon = storyboardone.instantiateViewController(withIdentifier: "SyncContactsRegistrationViewContoller") as!  SyncContactsRegistrationViewContoller
                    viewCon.isfromcustomer = true
                    viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                    frontViewController.pushViewController(viewCon, animated: false)
                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                //    let mainRevealController = SWRevealViewController()
                    mainRevealController.frontViewController = frontViewController
                    mainRevealController.rearViewController = rearViewController
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController
                    return
                }
                else if USERDEF.integer(forKey: "iSyncedStatus") == 1 {
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
                else
                {
                    gotoEntranceCustomer()
                    return
                }
                

            }
            else if  USERDEF.integer(forKey: "iSupplierStatus") == 2 {
                //trial expired
                Global.sharedInstance.isProvider = false
              //  Alert.sharedInstance.showAlert("PROMPT_USER_BUSINESS_STATUS0".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
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
                gotoEntranceCustomer()
                //                let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                //                let storyboard = UIStoryboard(name: "Testing", bundle: nil)
                //                let frontViewController = storyboard1.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                //                let viewCon = storyboard.instantiateViewController(withIdentifier: "popupTrialExpired") as!  popupTrialExpired
                //                viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                //                frontViewController.pushViewController(viewCon, animated: false)
                //                let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                //                let mainRevealController = SWRevealViewController()
                //                mainRevealController.frontViewController = frontViewController
                //                mainRevealController.rearViewController = rearViewController
                //                let window :UIWindow = UIApplication.shared.keyWindow!
                //                window.rootViewController = mainRevealController
                return
            }
            if self.trialdetails.count == 2 {
                let whatstatus = self.trialdetails[0]
                if whatstatus > 0  { // user has trial days from server
                    let diff = self.trialdetails[1] // number of days in difference from datetrial start to current date
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

        } else {
            
            if Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil
            {
                let dicClientName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") as! Dictionary<String,String>
                if dicClientName["nvSupplierName"] == ""//אם אינו רשום כעסק
                {
                    Global.sharedInstance.defaults.set(0, forKey: "ISFROMSETTINGS")
                    Global.sharedInstance.defaults.synchronize()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewCon:RgisterModelViewController = storyboard.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
                    let viewCon1:GlobalDataViewController = storyboard.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
                    viewCon.delegateFirstSection = viewCon1
                    viewCon.delegateSecond1Section = viewCon1
                    let front = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                    front.pushViewController(viewCon, animated: false)
                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                 //   let mainRevealController = SWRevealViewController()
                    mainRevealController.frontViewController = front
                    mainRevealController.rearViewController = rearViewController
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController
                    
                    return
//                    self.window!.rootViewController = mainRevealController
//                    self.window?.makeKeyAndVisible()
                    
//                    let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
//                    let vc = storyBoard1!.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
//                    frontviewcontroller?.pushViewController(vc, animated: false)
//
//                    Global.sharedInstance.whichReveal = false
//                    //initialize REAR View Controller- it is the LEFT hand menu.
//                    let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//
//                    let mainRevealController = SWRevealViewController()
//
//                    mainRevealController.frontViewController = frontviewcontroller
//                    mainRevealController.rearViewController = rearViewController
//
//                    let window:UIWindow = UIApplication.shared.keyWindow!
//                    window.rootViewController = mainRevealController
                }
                else
                {
                    gotoEntranceCustomer()
                    return
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
              //  let mainRevealController = SWRevealViewController()
                mainRevealController.frontViewController = front
                mainRevealController.rearViewController = rearViewController
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.rootViewController = mainRevealController
                
                return
                
                //      }
            }
            
//            if  USERDEF.integer(forKey: "isenteringregister") == 0 {
//            gotoEntranceCustomer()
//            return
//            }
        }
        if Global.sharedInstance.isProvider == true//רוצה לעבור מספק ללקוח
        {
            //לא צריך לשאול שום שאלה כי ברור שהוא רשום כלקוח וממילא עוברים ללקוח קיים
            Global.sharedInstance.isProvider = false
            
            let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            let vc = storyBoard1!.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
            frontviewcontroller?.pushViewController(vc, animated: false)
            
            Global.sharedInstance.whichReveal = false
            //initialize REAR View Controller- it is the LEFT hand menu.
            let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            

            
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            
            let window:UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
        }
        else//רוצה לעבור מלקוח לספק
        {
            //צריך לבדוק האם הוא רשום כספק
            if Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil
            {
                var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                
                if Reachability.isConnectedToNetwork() == false
                {
                    
//                    showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else
                {
                    var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                    if dicUserId["currentUserId"] as! Int != 0  {
                        //                            var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                    }
                    
                    if !(Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1) {
//                        dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
                        

                        
                        //show a loader
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
                        
                        api.sharedInstance.getProviderAllDetails(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            //hide the loader
                            if (self.view8.view.window != nil) {
                                self.view8.view.removeFromSuperview()
                            }
                            //end hide
                            
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                                    {
                                        Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                    }
                                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                                    {
                                        Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                        
                                        
                                    }
                                    else
                                    {
                                        var mydic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                        if let _ = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                                        Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                            mydic = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                        }
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
                                        //\\print ("x1 -> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName)")
                                        //\\print ("x2-> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress)")
                                        //\\print ("x3 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen)")
                                        //   //\\print ("x4 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage)")
                                        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                                            Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                                            //\\print("wtccc2 \( Global.sharedInstance.providerID)")
                                        }
                                        //resets to first worker
                                        //                                  Global.sharedInstance.defaults.setInteger(-1, forKey: "idSupplierWorker")
                                        //                                  Global.sharedInstance.defaults
                                    }
                                }
                            }
                            
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                            if AppDelegate.showAlertInAppDelegate == false
//                            {
//                                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                                AppDelegate.showAlertInAppDelegate = true
//                            }
                        })
                    }
                        
                    else {
                        tryGetSupplierCustomerUserIdByEmployeeIddoi()
                        
                    }
                    
                }
                
                
                
                
                var dicClientName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") as! Dictionary<String,String>
                //רק אם רשום כספק ,אחרת לא קורה כלום!
                
                if dicClientName["nvSupplierName"] != ""
                {
                    
                    Global.sharedInstance.isProvider = true
                    ///
                    
                    ////////
                    let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                    
                    //                    let vc = supplierStoryBoard!.instantiateViewControllerWithIdentifier("CalendarSupplierViewController") as! CalendarSupplierViewController
                    //                    Global.sharedInstance.whichReveal = true
                    //                     Global.sharedInstance.isFromprintCalender = false
                    //                    frontviewcontroller?.pushViewController(vc, animated: false)
                    
                    // initialize REAR View Controller- it is the LEFT hand menu.
                    
                    let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    
              //      let mainRevealController = SWRevealViewController()

                    mainRevealController.frontViewController = frontviewcontroller
                    mainRevealController.rearViewController = rearViewController
                    let CalendarSupplier: CalendarSupplierViewController = supplierStoryBoard!.instantiateViewController(withIdentifier: "CalendarSupplierViewController")as! CalendarSupplierViewController
                    let navigationController: UINavigationController = UINavigationController(rootViewController: CalendarSupplier)
                    mainRevealController.pushFrontViewController(navigationController, animated: false)
//                    mainRevealController.revealToggle(animated: true)
                    Global.sharedInstance.isFromprintCalender = false
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController
                    return
                }
                
                
            }
            else
            {
                if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1 {
                    Global.sharedInstance.isProvider = true
                    Global.sharedInstance.isFromprintCalender = false
                    let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                    
                    let vc = supplierStoryBoard!.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
                    Global.sharedInstance.whichReveal = true
                    frontviewcontroller?.pushViewController(vc, animated: false)
                    
                    // initialize REAR View Controller- it is the LEFT hand menu.
                    
                    let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    
                   // let mainRevealController = SWRevealViewController()
                    
                    mainRevealController.frontViewController = frontviewcontroller
                    mainRevealController.rearViewController = rearViewController
                    
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController
                    return
                    
                }
                else if Global.sharedInstance.defaults.integer(forKey: "issimpleCustomer") == 1
                {
                    //\\  Alert.sharedInstance.showAlert("NOT_SUPPLIER_REGISTER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    gotoEntranceCustomer()
                }
            }

            
        }
    }
    @objc func openSideMenu()
    {
        view.endEditing(true)
        let mytop = self

        if mytop.title == "SupplierSettings" {
            NotificationCenter.default.post(name: Notification.Name("DismissEditCityorAddress"), object: nil)
        }



    }
    
    @objc func goToEntrance()
    {
        
        let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyBoard1!.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        
        Global.sharedInstance.whichReveal = false
        //initialize REAR View Controller- it is the LEFT hand menu.
        let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
       // let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    func gotoEntranceCustomer() {
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyBoard1!.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        

        //initialize REAR View Controller- it is the LEFT hand menu.
        let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
      //  let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
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
                        self.calculateDaysTrialPeriod()
                      
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                      
                        
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
        self.trialdetails = myArr
        return myArr
    }
    
}

///JMODE OLD CODE
////  NavigationModelViewController.swift
////  bthree-ios
////
////  Created by Lior Ronen on 2/17/16.
////  Copyright © 2016 Webit. All rights reserved.
////
//
//import UIKit
//import Social
//
//class NavigationModelViewController: UIViewController {
//
//    //MARK: - Properties
//
//    var backButton: UIBarButtonItem?
//    var backButtonleft: UIBarButtonItem?
//    var storyBoard1:UIStoryboard?
//    var supplierStoryBoard:UIStoryboard?
//    var button:UIButton = UIButton()
//
//    //MARK: - Initial
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if AppDelegate.fromChangeLanguage == false
//        {
//            if AppDelegate.isDeviceLanguageRTL()
//            {
//                Global.sharedInstance.rtl = true
//            }
//            else
//            {
//                Global.sharedInstance.rtl = false
//            }
//        }
//        else
//        {
//            AppDelegate.fromChangeLanguage = false
//        }
//        if self.revealViewController() != nil
//        {
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
//
//        supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
//        storyBoard1 = UIStoryboard(name: "Main", bundle: nil)
//        let menueBtn: UIButton = UIButton(type: .Custom)
//        let menueBtnImage: UIImage = UIImage(named: "icon-menu.png")!
//
//        menueBtn.setBackgroundImage(menueBtnImage, forState: .Normal)
//
//        menueBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
//
//        menueBtn.addTarget(self, action: #selector(self.openSideMenu), forControlEvents: .TouchUpInside)
//
//        menueBtn.frame = CGRectMake(-11, -7, 35, 28)
//
//        let backButtonView: UIView = UIView(frame: CGRectMake(0, -15, 44, 34))
//        backButtonView.bounds = CGRectOffset(backButtonView.bounds, -14, -7)
//        backButtonView.addSubview(menueBtn)
//
//        backButton = UIBarButtonItem(customView: backButtonView)
//       // self.navigationItem.rightBarButtonItem = backButton
//
//            if Global.sharedInstance.rtl
//            {
//                self.navigationItem.rightBarButtonItem = self.backButton//menu button in right
//            }
//            else
//            {
//                self.navigationItem.leftBarButtonItem = self.backButton//menu button in left
//            }
//
//
//        //Bthere picture
//        let backView: UIView = UIView(frame: CGRectMake(0, 0, 120, 40))
//        let titleImageView: UIImageView = UIImageView(image: UIImage(named: "3.png"))
//        titleImageView.frame = CGRectMake(0, 0, titleImageView.frame.size.width * 0.8, 40)
//        // Here I am passing origin as (45,5) but can pass them as your requirement.
//        backView.addSubview(titleImageView)
//        self.navigationItem.titleView = backView
//
//        //label to show name of client or supplier
//        let navLabel: UILabel = UILabel(frame: CGRectMake(self.view.frame.width - 90, 19, 90, 30))
//        navLabel.textColor = UIColor.redColor()
//        navLabel.textAlignment = .Center
//        self.navigationController?.navigationBar.addSubview(navLabel)
//        navLabel.backgroundColor = UIColor.clearColor()
//        navLabel.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
//
//
//
//        let leftbtn: UIButton = UIButton(type: .Custom)
//        let leftbtnImage: UIImage?
//
//
//        if Global.sharedInstance.isProvider == true
//        {
//            navLabel.textColor = Colors.sharedInstance.color4
//            leftbtnImage = UIImage(named: "user-2.png")!
//
//            if Global.sharedInstance.defaults.valueForKey("supplierNameRegistered") != nil {
//
//                var dicSupplierName:Dictionary<String,String> = Global.sharedInstance.defaults.valueForKey("supplierNameRegistered") as! Dictionary<String,String>
//                if dicSupplierName["nvSupplierName"] != ""
//                {
//                    navLabel.text = dicSupplierName["nvSupplierName"]
//                    //Global.sharedInstance.currentProvider.nvSupplierName
//                }
//                else
//                {
//                    navLabel.text = "NAME_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//                }
//            }
//            else
//            {
//                navLabel.text = "NAME_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//            }
//
//        }
//        else
//        {
//            navLabel.textColor = Colors.sharedInstance.color3
//            leftbtnImage = UIImage(named: "4.png")!
//
//            if Global.sharedInstance.defaults.valueForKey("currentClintName") != nil
//            {
//                var dicClientName:Dictionary<String,String> = Global.sharedInstance.defaults.valueForKey("currentClintName") as! Dictionary<String,String>
//                if dicClientName["nvClientName"] != ""
//                {
//                    navLabel.text = dicClientName["nvClientName"]//Global.sharedInstance.currentUser.nvFirstName
//                }
//                else
//                {
//                    navLabel.text = "NAME_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//                }
//            }
//            else
//            {
////מצב צפיה - כפתור חזור למסך כניסה למקרה שירצה להכנס כלקוח קיים
//                self.navigationItem.rightBarButtonItem = nil
//                self.navigationItem.leftBarButtonItem = nil
//
//                let leftToViewMode: UIButton = UIButton(type: .Custom)
//                leftToViewMode.setTitle("<", forState: .Normal)
//                leftToViewMode.titleLabel?.font = UIFont(name: "OpenSansHebrew-Bold", size: 25)
//                leftToViewMode.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//                leftToViewMode.addTarget(self, action: #selector(NavigationModelViewController.goToEntrance), forControlEvents: .TouchUpInside)
//                leftToViewMode.frame = CGRectMake(self.view.frame.size.width - 50, 0, 50, 50)
//                self.navigationController?.navigationBar.addSubview(leftToViewMode)
//
//                button = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: -15, width: 90, height: 60))
//                button.backgroundColor = UIColor.clearColor()
//                //button.setTitle("", forState: .Normal)
//                button.addTarget(self, action: #selector(NavigationModelViewController.goToEntrance), forControlEvents: .TouchUpInside)
//                self.navigationController?.navigationBar.addSubview(button)
//                self.navigationItem.setHidesBackButton(true, animated:true)
//            }
//        }
//        if Global.sharedInstance.defaults.valueForKey("currentClintName") != nil
//        {
//            leftbtn.setBackgroundImage(leftbtnImage, forState: .Normal)
//            leftbtn.addTarget(self, action: #selector(NavigationModelViewController.providerCustomer), forControlEvents: .TouchUpInside)
//            leftbtn.frame = CGRectMake(-30, -15, 30, 20)
//            let backButtonV: UIView = UIView(frame: CGRectMake(0, -15, 40, 20))
//            backButtonV.bounds = CGRectOffset(backButtonView.bounds, -14, -7)
//
//            backButtonV.addSubview(leftbtn)
//            backButtonleft = UIBarButtonItem(customView: backButtonV)
//            //  self.navigationItem.leftBarButtonItem = backButtonleft
//
//                if Global.sharedInstance.rtl
//                {
//                    self.navigationItem.leftBarButtonItem = self.backButtonleft//providerCustomer in left
//                    // button = UIButton(frame: CGRect(x: 0, y: -15, width: 90, height: 60))
//                    self.button = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: -15, width: 90, height: 60))
//
//                }
//                else
//                {
//                    self.button = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: -15, width: 90, height: 60))
//                    self.navigationItem.rightBarButtonItem = self.backButtonleft//providerCustomer in right
//                }
//            //   button = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: -15, width: 90, height: 60))
//            button.backgroundColor = UIColor.clearColor()
//            //button.setTitle("", forState: .Normal)
//            button.addTarget(self, action: #selector(NavigationModelViewController.providerCustomer), forControlEvents: .TouchUpInside)
//            self.navigationController?.navigationBar.addSubview(button)
//
//            /*
//             if Global.sharedInstance.rtl
//             {
//             self.navigationItem.setLeftBarButtonItems([backButton!], animated: true)
//             }
//             else
//             {
//             self.navigationItem.setRightBarButtonItems([backButtonleft!], animated: true)
//             }
//             */
//
//        }
//        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
//    }
//
//    override func viewDidAppear(animated: Bool) {
//
//        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    //move to customer or provider
//    //when click on image provider/customer in top
//    func providerCustomer()  {
//
//        if Global.sharedInstance.isProvider == true//רוצה לעבור מספק ללקוח
//        {
//            //לא צריך לשאול שום שאלה כי ברור שהוא רשום כלקוח וממילא עוברים ללקוח קיים
//            Global.sharedInstance.isProvider = false
//
//            let frontviewcontroller = storyBoard1!.instantiateViewControllerWithIdentifier("navigation") as? UINavigationController
//            let vc = storyBoard1!.instantiateViewControllerWithIdentifier("entranceCustomerViewController") as! entranceCustomerViewController
//            frontviewcontroller?.pushViewController(vc, animated: false)
//
//            Global.sharedInstance.whichReveal = false
//            //initialize REAR View Controller- it is the LEFT hand menu.
//            let rearViewController = storyBoard1!.instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
//
//            let mainRevealController = SWRevealViewController()
//
//            mainRevealController.frontViewController = frontviewcontroller
//            mainRevealController.rearViewController = rearViewController
//
//            let window:UIWindow = UIApplication.sharedApplication().keyWindow!
//            window.rootViewController = mainRevealController
//        }
//        else//רוצה לעבור מלקוח לספק
//        {
//            //צריך לבדוק האם הוא רשום כספק
//            if Global.sharedInstance.defaults.valueForKey("supplierNameRegistered") != nil
//            {
//                var dicClientName:Dictionary<String,String> = Global.sharedInstance.defaults.valueForKey("supplierNameRegistered") as! Dictionary<String,String>
//                //רק אם רשום כספק ,אחרת לא קורה כלום!
//                if dicClientName["nvSupplierName"] != ""
//                {
//                    Global.sharedInstance.isProvider = true
//
//                    let frontviewcontroller = storyBoard1!.instantiateViewControllerWithIdentifier("navigation") as? UINavigationController
//                    let vc = supplierStoryBoard!.instantiateViewControllerWithIdentifier("CalendarSupplierViewController") as! CalendarSupplierViewController
//                    Global.sharedInstance.whichReveal = true
//                    frontviewcontroller?.pushViewController(vc, animated: false)
//
//                    // initialize REAR View Controller- it is the LEFT hand menu.
//
//                    let rearViewController = storyBoard1!.instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
//
//                    let mainRevealController = SWRevealViewController()
//
//                    mainRevealController.frontViewController = frontviewcontroller
//                    mainRevealController.rearViewController = rearViewController
//
//                    let window :UIWindow = UIApplication.sharedApplication().keyWindow!
//                    window.rootViewController = mainRevealController
//                }
//                else
//                {
//                    Alert.sharedInstance.showAlert("NOT_SUPPLIER_REGISTER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                }
//            }
//            else
//            {
//                Alert.sharedInstance.showAlert("NOT_SUPPLIER_REGISTER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//            }
//        }
//    }
//    func openSideMenu()
//    {
//        view.endEditing(true)
//    }
//
//    func goToEntrance()
//    {
//        let frontviewcontroller = storyBoard1!.instantiateViewControllerWithIdentifier("navigation") as? UINavigationController
//        let vc = storyBoard1!.instantiateViewControllerWithIdentifier("entranceViewController") as! entranceViewController
//        frontviewcontroller?.pushViewController(vc, animated: false)
//
//        Global.sharedInstance.whichReveal = false
//        //initialize REAR View Controller- it is the LEFT hand menu.
//        let rearViewController = storyBoard1!.instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
//        
//        let mainRevealController = SWRevealViewController()
//        
//        mainRevealController.frontViewController = frontviewcontroller
//        mainRevealController.rearViewController = rearViewController
//        
//        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
//        window.rootViewController = mainRevealController
//    }
//
//
//}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
