//
//  CustomerOrDistributorViewController.swift
//  bthree-ios
//
//  Created by User on 22.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
//דף מעבר בין ספק ללקוח (לבדוק אם משתמשים)
class CustomerOrDistributorViewController: UIViewController{
    var generic:Generic = Generic()
    var view8 : loadingBthere!
    @IBOutlet weak var viewProvider: UIView!
    @IBOutlet weak var viewCustomer: UIView!
    
    var delegate:openChooseUserDelegate!=nil
    var delegate1:openCustomerDetailsDelegate!=nil
    var supplierStoryBoard:UIStoryboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        Crashlytics.sharedInstance().crash()
        supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomerOrDistributorViewController.openProvider))
        self.viewProvider.addGestureRecognizer(tap)
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomerOrDistributorViewController.openCustomer))
        self.viewCustomer.addGestureRecognizer(tap1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func openProvider()
    {
        var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
            dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
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
            api.sharedInstance.getProviderAllDetails(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                //hide the loader
                if (self.view8.view.window != nil) {
                    self.view8.view.removeFromSuperview()
                }
                //end hide
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        var provDetailsAll:ProviderDetailsObj = ProviderDetailsObj()
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            Alert.sharedInstance.showAlert("שגיאה", vc: self)
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                        {
                            self.dismiss(animated: false, completion: nil)
                            //פתיחת רישום ספק
                            if let _ = self.delegate
                            {
                                self.delegate.openBuisnessDetails()
                            }
                            else
                            {
                                Global.sharedInstance.isProvider = true
                                let viewCon1:GlobalDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                                let rgister:RgisterModelViewController = storyboard.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
                                frontViewController.pushViewController(rgister, animated: false)
                                rgister.delegateFirstSection = viewCon1
                                rgister.delegateSecond1Section = viewCon1
                                let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                let mainRevealController = SWRevealViewController()
                                mainRevealController.frontViewController = frontViewController
                                mainRevealController.rearViewController = rearViewController
                                let window :UIWindow = UIApplication.shared.keyWindow!
                                window.rootViewController = mainRevealController
                            }
                        }
                        else
                        {
                            Global.sharedInstance.isProvider = true
                            if let _ = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                            provDetailsAll = provDetailsAll.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                            }
                            let frontviewcontroller = self.storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                            let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
                            let vc = storyboardSupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
                            frontviewcontroller?.pushViewController(vc, animated: false)
                            let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                            let mainRevealController = SWRevealViewController()
                            mainRevealController.frontViewController = frontviewcontroller
                            mainRevealController.rearViewController = rearViewController
                            let window :UIWindow = UIApplication.shared.keyWindow!
                            window.rootViewController = mainRevealController
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
            })
        }
        else {
            var y:Int = 0
            var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
            }
            dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = y as AnyObject
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
            
            api.sharedInstance.getProviderAllDetailsbyEmployeID(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                //hide the loader
                if (self.view8.view.window != nil) {
                    self.view8.view.removeFromSuperview()
                }
                //end hide
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        var provDetailsAll:ProviderDetailsObj = ProviderDetailsObj()
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            Alert.sharedInstance.showAlert("שגיאה", vc: self)
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                        {
                            self.dismiss(animated: false, completion: nil)
                            //פתיחת רישום ספק
                            if let _ = self.delegate
                            {
                                self.delegate.openBuisnessDetails()
                            }
                            else
                            {
                                Global.sharedInstance.isProvider = true
                                let viewCon1:GlobalDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                                let rgister:RgisterModelViewController = storyboard.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
                                frontViewController.pushViewController(rgister, animated: false)
                                rgister.delegateFirstSection = viewCon1
                                rgister.delegateSecond1Section = viewCon1
                                let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                let mainRevealController = SWRevealViewController()
                                mainRevealController.frontViewController = frontViewController
                                mainRevealController.rearViewController = rearViewController
                                let window :UIWindow = UIApplication.shared.keyWindow!
                                window.rootViewController = mainRevealController
                            }
                        }
                        else
                        {
                            Global.sharedInstance.isProvider = true
                            provDetailsAll = provDetailsAll.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                            let frontviewcontroller = self.storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                            let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
                            let vc = storyboardSupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
                            frontviewcontroller?.pushViewController(vc, animated: false)
                            let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                            let mainRevealController = SWRevealViewController()
                            mainRevealController.frontViewController = frontviewcontroller
                            mainRevealController.rearViewController = rearViewController
                            let window :UIWindow = UIApplication.shared.keyWindow!
                            window.rootViewController = mainRevealController
                        }
                    }
                }
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
            })
            
        }
     }
    
    @objc func openCustomer()
    {
        //קבלת פרטי הלקוח
        var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetCustomerDetails["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if RESPONSEOBJECT["Result"] != nil {
                    Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
        })
        Global.sharedInstance.isProvider = false
        self.dismiss(animated: false, completion: nil)
        
        if let _ = delegate1
        {
            delegate1.openCustomerDetails()
        }
        else
        {
            Global.sharedInstance.whichDesignOpenDetailsAppointment = 0
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
            let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
            let rgister:ModelCalenderViewController = clientStoryBoard.instantiateViewController(withIdentifier: "ModelCalenderViewController") as! ModelCalenderViewController
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
    
    
}
