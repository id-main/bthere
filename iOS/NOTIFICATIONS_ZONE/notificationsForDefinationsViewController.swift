//
//  notificationsForDefinationsViewController.swift
//  Bthere
//
//  Created by User on 8.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import MarqueeLabel

class notificationsForDefinationsViewController: NavigationModelViewController,UITableViewDelegate,UITableViewDataSource,openFromMenuDelegate {
    
    //MARK: - Properties
    
    var arrayHeaders:Array<String> = ["DISCOUNT_MINUTE_90".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MINUTES_BEFORE_MEETING_20".localized(LanguageMain.sharedInstance.USERLANGUAGE),"OK_FROM_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"UPDATE_WAIT_TURN".localized(LanguageMain.sharedInstance.USERLANGUAGE),"UPDATES_NEWS".localized(LanguageMain.sharedInstance.USERLANGUAGE), "B4HOURSBEFORESERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    
    var generic:Generic = Generic()
    var isfirsttime:Bool = true
    //MARK: - Outlet
    
    @IBOutlet weak var imgPlusMenu: UIImageView!
    @IBOutlet weak var lblAdvertising: MarqueeLabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblNotifTItle: UILabel!
    @IBOutlet weak var tblNotifications: UITableView!
    //שמור
    @IBAction func btnSave(_ sender: AnyObject) {
        
        var dicAddAlert:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicAddAlert["customerAlertsSettingsObj"] = Global.sharedInstance.customerAlertsSettingsObj.getDic() as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            
            api.sharedInstance.AddAlertSettingsForCustomer(dicAddAlert, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                print("dic alert \(dicAddAlert)")
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//לא הצליח
                        {
                            Alert.sharedInstance.showAlert("ERROR_SAVE".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            Alert.sharedInstance.showAlert("SUCCESS_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            //open DefinationsClientViewController
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let frontviewcontroller:UINavigationController = UINavigationController()
                            
                            let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
                            let vc = storyboardCExist.instantiateViewController(withIdentifier: "CustomerSettings") as! CustomerSettings
                            
                            frontviewcontroller.pushViewController(vc, animated: false)
                            
                            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                            
                            let mainRevealController = SWRevealViewController()
                            
                            mainRevealController.frontViewController = frontviewcontroller
                            mainRevealController.rearViewController = rearViewController
                            
                            let window :UIWindow = UIApplication.shared.keyWindow!
                            window.rootViewController = mainRevealController
                            
                        }
                    }
                }
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
            })
        }
    }
    
    //MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:25)  
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         tblNotifications.separatorStyle = .none
      
        
    }
    override func  viewDidLayoutSubviews() {
        if isfirsttime == true {
            isfirsttime = false
            DispatchQueue.main.async {
                var dicGetAlert:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicGetAlert["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                }
                else
                {
                    api.sharedInstance.GetAlertSettingsForCustomer(dicGetAlert, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            print("resp \(responseObject ?? "")")
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 // הצליח
                                {
                                    if let _ = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                                        Global.sharedInstance.customerAlertsSettingsObj = Global.sharedInstance.customerAlertsSettingsObj.getFromDic(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                    }
                                    self.tblNotifications.reloadData()
                                }
                            }
                        }
                        
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                    })
                }
                
            }
        }
      //       self.tblNotifications.reloadData()
            //
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
      //  self.getnews()
      //  self.lblAdvertising.restartLabel()
        
        //  if Global.sharedInstance.rtl
//        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
//        {
//            imgPlusMenu.image = UIImage(named: "plus.png")
//        }
//        else
//        {
//            imgPlusMenu.image = UIImage(named: "plusEnglish.png")
//        }
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped))
//        imgPlusMenu.isUserInteractionEnabled = true
//        imgPlusMenu.addGestureRecognizer(tapGestureRecognizer)
        
     //   lblAdvertising.text = "ADVERTISINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnSave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblNotifTItle.text = "NOTIFICATIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
       
       
         self.tblNotifications.reloadData()
        
    }
    
    
    func getnews(){
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //    dic["iLanguageId"] = finalIntforlang
        
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
             var userID:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let currentUserDictionary:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let userIdInteger:Int = currentUserDictionary.value(forKey: "currentUserId") as? Int{
                    userID = userIdInteger
                }
                dictionaryForServer["iUserId"] = userID as AnyObject
            }
            api.sharedInstance.GetNewsAndUpdates(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        if let result = RESPONSEOBJECT["Result"] as? String {
                            self.lblAdvertising.tag = 101
                            self.lblAdvertising.type = .continuous
                            self.lblAdvertising.animationCurve = .linear
                            self.lblAdvertising.type = .leftRight
                            self.lblAdvertising.text  = result
                            self.lblAdvertising.restartLabel()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHeaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "notificationForDefinationsTableViewCell")as!notificationForDefinationsTableViewCell
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.setDisplayData(arrayHeaders[indexPath.row],select:ItemToBool(indexPath.row))
        if indexPath.row != 5
        {
            cell.viewButtom.isHidden = true
        }
        else
        {
            cell.viewButtom.isHidden = false
        }
       // disabled all except 20 min before appointment for now
        if indexPath.row != 1 && indexPath.row != 5
        {
            cell.btnSelect.isCecked = false
            cell.btnUnSelect.isCecked = true
            cell.btnSelect.isUserInteractionEnabled = false
            cell.btnUnSelect.isUserInteractionEnabled = false
        }
        
        //
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tblNotifications.frame.size.height/6
    }
    
    //מקבלת אינדקס של השורה בטבלה ומחזירה את הערך(true או false)למשתנה הזה
    func ItemToBool(_ indexPath:Int) -> Bool
    {
        switch indexPath {
        case 0:
            return Global.sharedInstance.customerAlertsSettingsObj.b90thAlertTime
            
        case 1:
            return Global.sharedInstance.customerAlertsSettingsObj.b20minutesBeforeService
            
        case 2:
            return Global.sharedInstance.customerAlertsSettingsObj.bPermissionsFromBusinesses
            
        case 3:
            return Global.sharedInstance.customerAlertsSettingsObj.bOrderInWaiting
            
        case 4:
            return Global.sharedInstance.customerAlertsSettingsObj.bUpdatesAndNews
        case 5:
            return Global.sharedInstance.customerAlertsSettingsObj.b4hoursBeforeService
        default:
            return true
        }
    }
    
    @objc func imageTapped(){
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
}
