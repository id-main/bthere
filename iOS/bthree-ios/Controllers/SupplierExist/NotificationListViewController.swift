//
//  NotificationListViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 10.01.2018
//  Copyright © 2017 BTHERE. All rights reserved.
//

//

import UIKit

class NotificationListViewController: NavigationModelViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    var intSuppliersecondID:Int = 0
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var guidanceVideoButton: UIButton!
    @IBOutlet var QATable: UITableView!
    var refreshControl: UIRefreshControl!
    // @IBOutlet var cellBorderView: UIView!
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    let dateFormatter = DateFormatter()
    let calendar = Foundation.Calendar.current
    // Constants
     var questionsStrings:NSArray = NSArray()
//    let questionsStrings: NSMutableArray = ["HELP_Q1".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q2".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q3".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q4".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q5".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q6".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q7".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q8".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q9".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q10".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:55)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getasecondid()
        //GetPushNotificationListTop50BySupplierId() replaced by GetPushNotificationListTop50ByProviderUserId on 15.04.2019
        // Language
        titleLabel.text = "NOTIFICATIONs_LIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.QATable.delegate = self
        self.QATable.dataSource = self
        self.QATable.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.QATable.rowHeight = UITableView.automaticDimension
        self.QATable.estimatedRowHeight = 140
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        refreshControl.addTarget(self, action: #selector(NotificationListViewController.refreshTable(_:)), for: UIControl.Event.valueChanged)
        self.QATable.addSubview(refreshControl)

    }
    func getasecondid(){
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
                self.setupISupplierSecondID(0)
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
                                            self.setupISupplierSecondID(myInt)
                                        }
                                    }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.setupISupplierSecondID(0)
                })
            }
        }


    }

    func setupISupplierSecondID (_ ISupplierSecondID:Int){
        self.intSuppliersecondID = ISupplierSecondID
        print("self.intSuppliersecondID \(self.intSuppliersecondID)")
        if ISupplierSecondID == 0 {
            if Global.sharedInstance.giveServicesArray.count > 0
            {

                let myowner = Global.sharedInstance.giveServicesArray[0]
                Global.sharedInstance.defaults.setValue(myowner.iUserId , forKey: "idSupplierWorker")
                self.intSuppliersecondID = myowner.iUserId
                Global.sharedInstance.defaults.synchronize()
            }
        }
        GetPushNotificationListTop50ByProviderUserId()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Close
    @IBAction func closeButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return questionsStrings.count
    }
    
    
    @objc func refreshTable(_ sender:AnyObject) {
        //self.GetPushNotificationListTop50BySupplierId()
        GetPushNotificationListTop50ByProviderUserId()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NOTIFICATIONSTableViewCell", for: indexPath) as! NOTIFICATIONSTableViewCell
        cell.borderView.isHidden = false
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var whatdate:Date = Date()
        var senddate = ""
        var messagesent = ""
        var dayofweek = ""
        var hourstring = ""
        if let _:NSDictionary = questionsStrings[indexPath.row] as? NSDictionary {
        let myDictionary = questionsStrings[indexPath.row] as! NSDictionary
            
            
            if let NOTIFDATE =  myDictionary.object(forKey: "dtSentDate") as? String
            {
                whatdate = Global.sharedInstance.getStringFromDateString(NOTIFDATE)
                let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: whatdate)
                let hourS = componentsStart.hour
                let minuteS = componentsStart.minute
                var hourS_Show:String = hourS!.description
                var minuteS_Show:String = minuteS!.description
               
                if hourS! < 10
                {
                    hourS_Show = "0" + hourS_Show
                }
               
                if minuteS! < 10
                {
                    minuteS_Show = "0" +   minuteS_Show
                }
                hourstring =  "\(hourS_Show):\(minuteS_Show)"

                if  dateFormatter.string(from: whatdate) != "" {
                    senddate = dateFormatter.string(from: whatdate)
                    let dayWeek = Calendar.sharedInstance.getDayOfWeek(whatdate)
                    dayofweek = DateFormatter().weekdaySymbols[dayWeek! - 1]
                }
                print("senddate\(senddate)")
            }
            if let _:String = myDictionary.object(forKey: "nvContent") as? String {
                messagesent = myDictionary.object(forKey: "nvContent") as! String
            }
           
           let composedstring =  dayofweek + " | " + senddate + " | " + hourstring
//            messagesent = "Thanks. I spent 2 days trying everything I could find to get my labels to resize correctly. The weird thing was that some did resize, but other cell designs did not. I could not find a difference in the constraints or other settings. However, your solution worked great. I did create a UILabel subclass and put the preferredMaxLayoutWidth setting inside setBounds to avoid hard references to the UILabels in the table view controller"
        
        cell.setDisplayData(messagesent, datesenton:composedstring )
        }
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do nothing -> go to day view and hour of meeting
        if let _:NSDictionary = questionsStrings[indexPath.row] as? NSDictionary {
            let myDictionary = questionsStrings[indexPath.row] as! NSDictionary
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var isok1 :Bool = false
            var isok2 :Bool = false
            var hour = 0
            var minute = 0
            var dayneed = Date()
            var stringDate = ""
            if let _:String = myDictionary.object(forKey: "nvContent") as? String {
                let  messagesent = myDictionary.object(forKey: "nvContent") as! String
                let datecomponents = messagesent.components(separatedBy: " ")
                print("messagesent \(messagesent) and  datecomponents \(datecomponents)")
                for a in datecomponents {
                    if a.count == 5 && a[2] == ":" {
                        let mypartofhour = a.components(separatedBy: ":")
                        if mypartofhour.count == 2 {
                            isok1 = true

                            print("found hour \(a)")
                            let a1 = mypartofhour[0]
                            let a2 = mypartofhour[1]

                            if a1[0] == "0" {
                                hour = Int(String(a1[1]))!
                            } else {
                                hour =  Int(String(a1))!
                            }
                            if a2[0] == "0" {
                                minute = Int(String(a2[1]))!
                            } else {
                                minute = Int(String(a2))!
                            }
                            break
                        }
                    }
                }
                for a in datecomponents {
                    if a.count == 10 &&  a.contains("/") {
                        let mypartofday = a.components(separatedBy: "/")
                        if mypartofday.count == 3 {

                            print("found date \(a)")
                            if  let _:Date = Global.sharedInstance.getDateFromString(a) as Date? {
                                dayneed =    Global.sharedInstance.getDateFromString(a)
                                stringDate = Global.sharedInstance.convertNSDateToString(dayneed)
                                print("dayneed \(dayneed) ")
                                isok2 = true
                                break
                            }
                        }
                    }
                }
                if isok1 == true  && isok2 == true { // has date and hour also
                    let USERDEF = Global.sharedInstance.defaults
                    USERDEF.setValue(1, forKey:"FORCEDAYOPEN") //it is need for open day at notification hour
                    USERDEF.setValue(stringDate, forKey:"DAYTOOPEN")
                    USERDEF.setValue(hour, forKey:"HOURTOOPEN")
                    USERDEF.synchronize()
                    self.dismiss(animated: false, completion: {
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
                })
                }
            }
        }







        }
    func GetPushNotificationListTop50ByProviderUserId() {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var myarr:NSArray =  NSArray()
        dic["iProviderUserId"] = self.intSuppliersecondID as AnyObject

        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetPushNotificationListTop50ByProviderUserId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("GetPushNotificationListTop50ByProviderUserId \(RESPONSEOBJECT)")
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        print("responseObject notif \(RESPONSEOBJECT["Result"])")
                        if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                             myarr =  RESPONSEOBJECT["Result"] as! NSArray
                            self.processArray(myarr)
                        } else {
                             myarr =   NSArray()
                            self.processArray(myarr)
                        }
                    }
                } else {
                     self.processArray(myarr)
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.processArray(myarr)
            })
        }
    }
        func GetPushNotificationListTop50BySupplierId(){
            var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            var supplierID:Int = 0
            if Global.sharedInstance.providerID == 0 {
                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                    supplierID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                }
            } else {
                supplierID = Global.sharedInstance.providerID
            }
            dic["iSupplierId"] = supplierID as AnyObject

            if Reachability.isConnectedToNetwork() == false
            {
                Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetPushNotificationListTop50BySupplierId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                print("GetPushNotificationListTop50BySupplierId \(RESPONSEOBJECT)")
                if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                    Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else{
                print("responseObject notif \(RESPONSEOBJECT["Result"])")
                    if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                        let myarr =  RESPONSEOBJECT["Result"] as! NSArray
                        self.processArray(myarr)
                    } else {
                        let myarr =   NSArray()
                        self.processArray(myarr)
                    }
                    /* "dtSentDate": "/Date(1515535200000+0200)/",
                     "nvContent": "Some push notification message test" */
                    
                }
                
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
            })
        }
    }
    func processArray(_ myarray:NSArray) {
        questionsStrings = myarray
         self.QATable.reloadData()

        self.refreshControl.endRefreshing()
        
    }
}
