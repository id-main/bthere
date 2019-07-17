//
//  DeleteProvider.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 29.08.2017
//  Copyright © 2017 Bthere. All rights reserved.
//

import UIKit

class DeleteProvider: NavigationModelViewController {
    var isProvider:Bool = false
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    @IBOutlet weak var neededheight: NSLayoutConstraint! //dynamic height for iPad and iPhone neededheight.constant Important!
    @IBOutlet weak var viewprincipal: UIView!
    @IBOutlet weak var popoutTitleLabel: UILabel!
    @IBOutlet weak var lblNameProvider: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    @IBAction func btnUpdate(_ sender: AnyObject) {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        if isProvider == true {
            //DeleteSupplierBySupplierId
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
            
            if Reachability.isConnectedToNetwork() == false
            {
//                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else
            {
                api.sharedInstance.DeleteSupplierBySupplierId(dic,success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                            {
                                self.showAlertDelegateX("ERROR_DELETE_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else{
                                self.showAlertDelegateX("SUCCES_DELETE_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                Global.sharedInstance.defaults.removeObject(forKey: "verificationPhone")
                                Global.sharedInstance.defaults.set(true, forKey: "LogOut")
                                Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
                                Global.sharedInstance.defaults.set(0, forKey: "ismanager")
                                Global.sharedInstance.defaults.set(1, forKey: "issimpleCustomer") //false all
                                Global.sharedInstance.defaults.set(0, forKey: "isemploye")
                                Global.sharedInstance.defaults.removeObject(forKey: "currentClintName")
                                Global.sharedInstance.defaults.removeObject(forKey: "currentUserId")
                                Global.sharedInstance.defaults.removeObject(forKey: "providerDic")
                                Global.sharedInstance.defaults.removeObject(forKey: "isSupplierRegistered")
                                Global.sharedInstance.defaults.removeObject(forKey: "supplierNameRegistered")
                                Global.sharedInstance.isFIRSTREGISTER = false
                                Global.sharedInstance.defaults.set(0, forKey:"ISFROMSETTINGS")
                                Global.sharedInstance.defaults.synchronize()
                                let manager = FBSDKLoginManager()
                                manager.logOut()
                                FBSDKAccessToken.setCurrent(nil)
                                FBSDKProfile.setCurrent(nil)
                                Global.sharedInstance.defaults.synchronize()
                                Global.sharedInstance.providerID = 0 // !IMPORTANT remove all references to previous logged in user in case of bussiness
                                Global.sharedInstance.didOpenBusinessDetails = false
                                Global.sharedInstance.getEventsFromMyCalendar()
                                let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                if Reachability.isConnectedToNetwork() == false
                                {
//                                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                                else
                                {
                                    api.sharedInstance.GetSysAlertsList(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                            let sysAlert:SysAlerts = SysAlerts()
                                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                                Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                                if Global.sharedInstance.arrSysAlerts.count != 0
                                                {
                                                    Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
                                                }
                                            }
                                        }
                                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                                        if AppDelegate.showAlertInAppDelegate == false
//                                        {
//                                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                                            AppDelegate.showAlertInAppDelegate = true
//                                        }
                                    })
                                }
                                self.dismiss(animated: true, completion: {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                                    let vc = storyboard.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
                                    frontviewcontroller?.pushViewController(vc, animated: false)
                                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                    let mainRevealController = SWRevealViewController()
                                    mainRevealController.frontViewController = frontviewcontroller
                                    mainRevealController.rearViewController = rearViewController
                                    let window :UIWindow = UIApplication.shared.keyWindow!
                                    window.rootViewController = mainRevealController
                                    window.makeKeyAndVisible()
                                })
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    if AppDelegate.showAlertInAppDelegate == false
                    {
                        self.showAlertDelegateX("ERROR_DELETE_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        AppDelegate.showAlertInAppDelegate = true
                    }
                })
            }
        }
        if isProvider == false {
            //DeleteUserByUserId
            var iUserId:Int = 0
            var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
            {
                dicUserId = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                if dicUserId["currentUserId"] as! Int != 0 {
                    iUserId = dicUserId["currentUserId"] as! Int
                }
            }
            dic["iUserId"] = iUserId as AnyObject
            
            if Reachability.isConnectedToNetwork() == false
            {
//                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else
            {
                api.sharedInstance.DeleteUserByUserId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                            {
                                self.showAlertDelegateX("ERROR_DELETE_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else{
                                self.showAlertDelegateX("SUCCES_DELETE_simpleUSER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                Global.sharedInstance.defaults.removeObject(forKey: "verificationPhone")
                                Global.sharedInstance.defaults.set(true, forKey: "LogOut")
                                Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
                                Global.sharedInstance.defaults.set(0, forKey: "ismanager")
                                Global.sharedInstance.defaults.set(1, forKey: "issimpleCustomer") //false all
                                Global.sharedInstance.defaults.set(0, forKey: "isemploye")
                                Global.sharedInstance.defaults.removeObject(forKey: "currentClintName")
                                Global.sharedInstance.defaults.removeObject(forKey: "currentUserId")
                                Global.sharedInstance.defaults.removeObject(forKey: "providerDic")
                                Global.sharedInstance.defaults.removeObject(forKey: "isSupplierRegistered")
                                Global.sharedInstance.defaults.removeObject(forKey: "supplierNameRegistered")
                                Global.sharedInstance.isFIRSTREGISTER = false
                                let manager = FBSDKLoginManager()
                                manager.logOut()
                                FBSDKAccessToken.setCurrent(nil)
                                FBSDKProfile.setCurrent(nil)
                                Global.sharedInstance.defaults.synchronize()
                                Global.sharedInstance.providerID = 0 // !IMPORTANT remove all references to previous logged in user in case of bussiness
                                Global.sharedInstance.didOpenBusinessDetails = false
                                Global.sharedInstance.getEventsFromMyCalendar()
                                let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                if Reachability.isConnectedToNetwork() == false
                                {
//                                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                                else
                                {
                                    api.sharedInstance.GetSysAlertsList(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                            let sysAlert:SysAlerts = SysAlerts()
                                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                                Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                                if Global.sharedInstance.arrSysAlerts.count != 0
                                                {
                                                    Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
                                                    Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
                                                }
                                            }
                                        }
                                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                                        if AppDelegate.showAlertInAppDelegate == false
//                                        {
//                                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                                            AppDelegate.showAlertInAppDelegate = true
//                                        }
                                    })
                                    
                                }
                                self.dismiss(animated: true, completion: {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                                    let vc = storyboard.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
                                    frontviewcontroller?.pushViewController(vc, animated: false)
                                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                    let mainRevealController = SWRevealViewController()
                                    mainRevealController.frontViewController = frontviewcontroller
                                    mainRevealController.rearViewController = rearViewController
                                    let window :UIWindow = UIApplication.shared.keyWindow!
                                    window.rootViewController = mainRevealController
                                    window.makeKeyAndVisible()
                                })
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    if AppDelegate.showAlertInAppDelegate == false
                    {
                        self.showAlertDelegateX("ERROR_DELETE_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        AppDelegate.showAlertInAppDelegate = true
                    }
                })
            }
          }
    }
    
    @IBAction func btnNo(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        let height = UIScreen.main.bounds.size.height
        if UIDevice.current.userInterfaceIdiom == .pad {
            neededheight.constant = height * 0.19
        } else {
            neededheight.constant = height * 0.32
        }
        viewprincipal.layoutIfNeeded()
        popoutTitleLabel.text = "DELETE_USER_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnUpdate.setTitle("YES".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnNo.setTitle("NO".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblNameProvider.text =  "DELETE_USER_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        if isProvider == true {
            btnNo.backgroundColor = Colors.sharedInstance.color4
            btnUpdate.backgroundColor = Colors.sharedInstance.color4
            lblNameProvider.textColor = Colors.sharedInstance.color4
        } else {
            btnNo.backgroundColor = Colors.sharedInstance.color3
            btnUpdate.backgroundColor = Colors.sharedInstance.color3
            lblNameProvider.textColor = Colors.sharedInstance.color3
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
