//
//  DefinationsClientViewController.swift
//  Bthere
//
//  Created by User on 8.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class DefinationsClientViewController: NavigationModelViewController,openFromMenuDelegate {
    
    @IBOutlet weak var imgPlusMenu: UIImageView!
    @IBOutlet weak var viewPDTop: UIView!
    @IBOutlet weak var viewPDRight: UIView!
    @IBOutlet weak var viewPDButtom: UIView!
    @IBOutlet weak var viewPDLeft: UIView!
    //--------
    
    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var viewLang: UIView!
    @IBOutlet weak var viewBRight: UIView!
    @IBOutlet weak var viewBLeft: UIView!
    @IBOutlet weak var viewBTop: UIView!
    @IBOutlet weak var viewBbuttom: UIView!
    //-----
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPay: UILabel!
    @IBOutlet weak var lblNotifications: UILabel!
    @IBOutlet weak var lblPersonalDetails: UILabel!
    @IBOutlet weak var lblLang: UILabel!
    
    @IBOutlet weak var viewGDLeft: UIView!
    @IBOutlet weak var viewGDTop: UIView!
    
    @IBOutlet weak var viewGDRight: UIView!
    @IBOutlet weak var viewGDButtom: UIView!
    //---
    
    @IBOutlet weak var viewNButtom: UIView!
    @IBOutlet weak var viewNTop: UIView!
    
    @IBOutlet weak var viewNLeft: UIView!
    @IBOutlet weak var viewNRight: UIView!
    //----
    
    @IBOutlet weak var viewPLeft: UIView!
    @IBOutlet weak var viewPRight: UIView!
    @IBOutlet weak var viewPButton: UIView!
    @IBOutlet weak var viewPTop: UIView!
    
    @IBOutlet weak var lblAdvertising: UILabel!
    @IBOutlet weak var viewPerDetails: UIView!
    @IBOutlet weak var viewNotifications: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //"DELETE_USER_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblTitle.text = "SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblAdvertising.text = "ADVERTISINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
      //  if Global.sharedInstance.rtl
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            imgPlusMenu.image = UIImage(named: "plus.png")
        }
        else
        {
            imgPlusMenu.image = UIImage(named: "plusEnglish.png")
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AdvantageSearchViewController.imageTapped))
        imgPlusMenu.isUserInteractionEnabled = true
        imgPlusMenu.addGestureRecognizer(tapGestureRecognizer)
        
        lblPay.text = "PAYMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblNotifications.text = "NOTIFICATIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblPersonalDetails.text = "PERSONAL_DETAILS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblLang.text = "LANG".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        addShaddow(viewPDTop)
        addShaddow(viewPDButtom)
        addShaddow(viewPDRight)
        addShaddow(viewPDLeft)
        addShaddow(viewBRight)
        addShaddow(viewBLeft)
        addShaddow(viewBbuttom)
        addShaddow(viewBTop)
        addShaddow(viewGDTop)
        addShaddow(viewGDRight)
        addShaddow(viewGDButtom)
        addShaddow(viewGDLeft)
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openNotifications))
        self.viewNotifications.addGestureRecognizer(tap1)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openCustomer))
        self.viewPerDetails.addGestureRecognizer(tap2)
        
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openLanguage))
        self.viewLang.addGestureRecognizer(tap3)
        
        let tap4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openPayments))
        self.viewPayment.addGestureRecognizer(tap4)
        
        //        addShaddow(viewGDButtom)
        //        addShaddow(viewGDButtom)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        self.view.addBackground()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addShaddow(_ view:UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 1.5
    }
    
    @objc func openNotifications(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller:UINavigationController = UINavigationController()
        
        let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
        let vc = storyboardCExist.instantiateViewController(withIdentifier: "notificationsForDefinationsViewController") as! notificationsForDefinationsViewController
        
        frontviewcontroller.pushViewController(vc, animated: false)
        
        
        //initialize REAR View Controller- it is the LEFT hand menu.
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    //פרטים אישיים
    func openPersonDetails(){
        
        if Global.sharedInstance.arrayDicForTableViewInCell[2]![2].count == 0
        {
            if Reachability.isConnectedToNetwork() == false
            {
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
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
                        //2do
                        //במקום זה צריך להיות textField
                        //            Global.sharedInstance.arrayDicForTableViewInCell[4]![1] = sysAlert.SysnvAletName(12)
                    }
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let frontviewcontroller:UINavigationController = UINavigationController()
                    let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
                    let vc = storyboardCExist.instantiateViewController(withIdentifier: "personalDetailsViewController") as! personalDetailsViewController
                    frontviewcontroller.pushViewController(vc, animated: false)
                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.frontViewController = frontviewcontroller
                    mainRevealController.rearViewController = rearViewController
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController
                    }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        if AppDelegate.showAlertInAppDelegate == false
//                        {
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            AppDelegate.showAlertInAppDelegate = true
//                        }
                })
            }
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let frontviewcontroller:UINavigationController = UINavigationController()
            let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
            let vc = storyboardCExist.instantiateViewController(withIdentifier: "personalDetailsViewController") as! personalDetailsViewController
            frontviewcontroller.pushViewController(vc, animated: false)
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
        }
    }


    @objc func openLanguage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller:UINavigationController = UINavigationController()
        let storyboardClientExist = UIStoryboard(name: "ClientExist", bundle: nil)
        let vc = storyboardClientExist.instantiateViewController(withIdentifier: "langForClientViewController") as! langForClientViewController
        vc.isfromsettings = true
        frontviewcontroller.pushViewController(vc, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    @objc func openPayments(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller:UINavigationController = UINavigationController()
        let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
        let vc = storyboardCExist.instantiateViewController(withIdentifier: "PaymentMethodViewController") as! PaymentMethodViewController
        frontviewcontroller.pushViewController(vc, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
   @objc  func imageTapped(){
        let storyboard1:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewCon:MenuPlusViewController = storyboard1.instantiateViewController(withIdentifier: "MenuPlusViewController") as! MenuPlusViewController
        viewCon.delegate = self
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }
    
    func openFromMenu(_ con:UIViewController)
    {
        self.present(con, animated: true, completion: nil)
    }
    @objc func openCustomer() {
        var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetCustomerDetails["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject


        if Reachability.isConnectedToNetwork() == false {

//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in

                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                        let FULLDICTIONARY = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                        print(FULLDICTIONARY)
                        var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        if let _ = FULLDICTIONARY["bIsGoogleCalendarSync"] as? Int {
                            let x = FULLDICTIONARY["bIsGoogleCalendarSync"] as! Int
                            if x == 0 {
                                Global.sharedInstance.currentUser.bIsGoogleCalendarSync = false
                            } else {
                                Global.sharedInstance.currentUser.bIsGoogleCalendarSync = true
                            }
                            print("personal informations calendar \(Global.sharedInstance.currentUser.bIsGoogleCalendarSync)")

                        }
                        dicForDefault["nvClientName"] = FULLDICTIONARY["nvFirstName"]
                        Global.sharedInstance.defaults.set(dicForDefault, forKey: "currentClintName")
                        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        dicUserId["currentUserId"] = FULLDICTIONARY["iUserId"]
                        Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                        Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                        Global.sharedInstance.currentUser.dBirthdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dBirthdate
                            , options: [])!
                        Global.sharedInstance.currentUser.dMarriageDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dMarriageDate
                            , options: [])!
                        self.readpersonaldetails()
                    }
                }

            },failure: {(AFHTTPRequestOperation, Error) -> Void in

//                if AppDelegate.showAlertInAppDelegate == false {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
                self.readpersonaldetails()
            })
        }
    }
    func readpersonaldetails() {

        Global.sharedInstance.isProvider = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller:UINavigationController = UINavigationController()
        let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
        let vc = storyboardCExist.instantiateViewController(withIdentifier: "personalDetailsViewController") as! personalDetailsViewController
        frontviewcontroller.pushViewController(vc, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
}
