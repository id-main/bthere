//
//  SupplierNotificationsViewController.swift
//  BThere
//
//  Created by Eduard Stefanescu on 9/27/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit
import MarqueeLabel

class SupplierNotificationsViewController: NavigationModelViewController, openFromMenuDelegate {
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var appointmentLabel: UILabel!
    @IBOutlet weak var incomingLabel: UILabel!
    @IBOutlet weak var cancellationLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var customersLabel: UILabel!
    @IBOutlet weak var customersEventsLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var anniversaryLabel: UILabel!
    @IBOutlet weak var newsLabel: MarqueeLabel!
    @IBOutlet weak var backDesignButton: UIButton!
    @IBOutlet weak var apointmentYesButton: UIButton!
    @IBOutlet weak var apointmentNoButton: UIButton!
    @IBOutlet weak var incomingYesButton: UIButton!
    @IBOutlet weak var incomingNoButton: UIButton!
    @IBOutlet weak var cancellationYesButton: UIButton!
    @IBOutlet weak var cancellationNoButton: UIButton!
    @IBOutlet weak var minutesYesButton: UIButton!
    @IBOutlet weak var minutesNoButton: UIButton!
    @IBOutlet weak var customersYesButton: UIButton!
    @IBOutlet weak var customersNoButton: UIButton!
    @IBOutlet weak var customersEventsYesButton: UIButton!
    @IBOutlet weak var customersEventsNoButton: UIButton!
    @IBOutlet weak var birthdayYesButton: UIButton!
    @IBOutlet weak var birthdayNoButton: UIButton!
    @IBOutlet weak var anniversaryYesButton: UIButton!
    @IBOutlet weak var anniversaryNoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet var newsDealsLabel: UILabel!
    @IBOutlet var backImage: UIImageView!
    
    
    var notifsobject:SupplierAlertSettingsObj = SupplierAlertSettingsObj()
    var arraybuttonsyes:Array<UIButton> = Array<UIButton>()
    var arraybuttonsno:Array<UIButton> = Array<UIButton>()
    var arrayvalues:Array<Bool> = Array<Bool>()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:48) 
        self.getnews()
    }
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
            api.sharedInstance.GetNewsAndUpdates(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                    Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else{
                    if let abcd = RESPONSEOBJECT["Result"] as? String {
                        self.newsLabel.tag = 101
                        self.newsLabel.type = .continuous
                        self.newsLabel.animationCurve = .linear
                        self.newsLabel.type = .leftRight
                        self.newsLabel.text  = abcd
                        self.newsLabel.restartLabel()
                    }
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getnews()
        self.newsLabel.restartLabel()
        
        // Variables
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
        // Set language
        titleLabel.text = "NOTIFICATIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        appointmentLabel.text = "MEETING_UPDATES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        incomingLabel.text = "SUPPLIER_NOTIFICATIONS_INCOMING".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        cancellationLabel.text = "CANCELLATION_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        minutesLabel.text = "TEN_MINUTES_BEFORE_MEETING".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        customersLabel.text = "FOLLW_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        customersEventsLabel.text = "CUSTOMERS_EVENTS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        birthdayLabel.text = "SUPPLIER_NOTIFICATIONS_BIRTHDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        anniversaryLabel.text = "SUPPLIER_NOTIFICATIONS_ANIVERSARY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //   newsLabel.text = "SUPPLIER_NOTIFICATIONS_DEALS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        saveButton.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        arraybuttonsyes.append(apointmentYesButton)
        arraybuttonsyes.append(incomingYesButton)
        arraybuttonsyes.append(cancellationYesButton)
        arraybuttonsyes.append(minutesYesButton)
        arraybuttonsyes.append(customersYesButton)
        arraybuttonsyes.append(customersEventsYesButton)
        arraybuttonsyes.append(birthdayYesButton)
        arraybuttonsyes.append(anniversaryYesButton)
        //
        arraybuttonsno.append(apointmentNoButton)
        arraybuttonsno.append(incomingNoButton)
        arraybuttonsno.append(cancellationNoButton)
        arraybuttonsno.append(minutesNoButton)
        arraybuttonsno.append(customersNoButton)
        arraybuttonsno.append(customersEventsNoButton)
        arraybuttonsno.append(birthdayNoButton)
        arraybuttonsno.append(anniversaryNoButton)
        arrayvalues = [false,false,false,false,false,false, false, false]
        for item in arraybuttonsyes {
            item.contentMode = .scaleAspectFit
        }
        for item in arraybuttonsno {
            item.contentMode = .scaleAspectFit
        }
        var mydictionary:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        // Check language
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            backDesignButton.transform = scalingTransform
            plusButton.transform = scalingTransform
            backImage.transform = scalingTransform
        }
        //   GetSupplierAlertSettingsBySupplierId(int iSupplierId);
        if Reachability.isConnectedToNetwork() == false
        {
            
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            var providerID:Int = 0
            if Global.sharedInstance.providerID == 0 {
                providerID = 0
                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                    providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                    
                }
            } else {
                providerID = Global.sharedInstance.providerID
            }
            mydictionary["iSupplierId"] = providerID as AnyObject
            api.sharedInstance.GetSupplierAlertSettingsBySupplierId(mydictionary, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                {
                    let onething:SupplierAlertSettingsObj = SupplierAlertSettingsObj()
                    if let _:NSDictionary = RESPONSEOBJECT["Result"] as? NSDictionary {
                        self.notifsobject =  onething.dicToSupplierAlertSettingsObj(RESPONSEOBJECT["Result"] as! NSDictionary)
                        NSLog("%@",self.notifsobject.getDic().description)
                        //   print("notifsobject \(self.notifsobject)")
                        self.arrayvalues = onething.SupplierAlertSettingsObjToArray(self.notifsobject)
                        print("arrayvalues \(self.arrayvalues)")
                        self.arrayvalues[4] = false
                        
                        self.arrayvaluesToButtons()
                       self.arraybuttonsno[4].isUserInteractionEnabled = false
                       self.arraybuttonsyes[4].isUserInteractionEnabled = false
                        
                        
                        
                        
                    }
                    
                    
                    
                } else {
                    self.showAlertDelegateX("NO_ALERTS_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    for item in self.arraybuttonsyes {
                        self.checkunckeckbtn(item, ISCHECK: true)
                    }
                    
                    
                }
                    }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Go back to settings
    @IBAction func backButton(_ sender: AnyObject) {
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        
        frontviewcontroller!.pushViewController(viewcon, animated: false)
        
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
    
    func arrayvaluesToButtons() {
        
        //  self.arrayvalues =   [false, true, false, true, false, false, true, true]
        print("arrayvalues x \(self.arrayvalues)")
        for i in 0..<self.arrayvalues.count {
            let item:Bool = self.arrayvalues[i]
            if (i > 0 &&  i != 5){
                if item == true {
                    arraybuttonsyes[i].setImage(UIImage(named: "OK-select.png"), for: UIControl.State())
                    arraybuttonsyes[i].isSelected = true
                    arraybuttonsno[i].setImage(UIImage(named: "Cancel_unSelected.png"), for: UIControl.State())
                    arraybuttonsno[i].isSelected = false
                    arraybuttonsyes[i].layoutIfNeeded()
                    arraybuttonsno[i].layoutIfNeeded()
                } else {
                    arraybuttonsyes[i].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                    arraybuttonsyes[i].isSelected = false
                    arraybuttonsno[i].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                    arraybuttonsno[i].isSelected = true
                    arraybuttonsyes[i].layoutIfNeeded()
                    arraybuttonsno[i].layoutIfNeeded()
                }
            }
            if i == 0 {
                if item == false {
                    arraybuttonsyes[i].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                    arraybuttonsyes[i].isSelected = false
                    arraybuttonsno[i].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                    arraybuttonsno[i].isSelected = true
                    arraybuttonsyes[i].layoutIfNeeded()
                    arraybuttonsno[i].layoutIfNeeded()
                    
                    arraybuttonsyes[1].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                    arraybuttonsyes[1].isSelected = false
                    arraybuttonsno[1].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                    arraybuttonsno[1].isSelected = true
                    arraybuttonsyes[2].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                    arraybuttonsyes[2].isSelected = false
                    arraybuttonsno[2].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                    arraybuttonsno[2].isSelected = true
                    arraybuttonsyes[1].layoutIfNeeded()
                    arraybuttonsyes[2].layoutIfNeeded()
                    arraybuttonsno[1].layoutIfNeeded()
                    arraybuttonsno[2].layoutIfNeeded()
                    arraybuttonsyes[1].isUserInteractionEnabled = false
                    arraybuttonsyes[2].isUserInteractionEnabled = false
                } else {
                    arraybuttonsyes[1].isUserInteractionEnabled = true
                    arraybuttonsyes[2].isUserInteractionEnabled = true
                    arraybuttonsyes[i].setImage(UIImage(named: "OK-select.png"), for: UIControl.State())
                    arraybuttonsyes[i].isSelected = true
                    arraybuttonsno[i].setImage(UIImage(named: "Cancel_unSelected.png"), for: UIControl.State())
                    arraybuttonsno[i].isSelected = false
                    arraybuttonsyes[i].layoutIfNeeded()
                    arraybuttonsno[i].layoutIfNeeded()
                }
            }
            if i == 5 {
                if item == false {
                    arraybuttonsyes[i].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                    arraybuttonsyes[i].isSelected = false
                    arraybuttonsno[i].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                    arraybuttonsno[i].isSelected = true
                    arraybuttonsyes[i].layoutIfNeeded()
                    arraybuttonsno[i].layoutIfNeeded()
                    arraybuttonsyes[6].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                    arraybuttonsyes[6].isSelected = false
                    arraybuttonsno[6].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                    arraybuttonsno[6].isSelected = true
                    arraybuttonsyes[7].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                    arraybuttonsyes[7].isSelected = false
                    arraybuttonsno[7].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                    arraybuttonsno[7].isSelected = true
                    arraybuttonsyes[6].layoutIfNeeded()
                    arraybuttonsyes[7].layoutIfNeeded()
                    arraybuttonsno[7].layoutIfNeeded()
                    arraybuttonsno[6].layoutIfNeeded()
                    arraybuttonsyes[6].isUserInteractionEnabled = false
                    arraybuttonsyes[7].isUserInteractionEnabled = false
                    
                } else {
                    arraybuttonsyes[6].isUserInteractionEnabled = true
                    arraybuttonsyes[7].isUserInteractionEnabled = true
                    arraybuttonsyes[i].setImage(UIImage(named: "OK-select.png"), for: UIControl.State())
                    arraybuttonsyes[i].isSelected = true
                    arraybuttonsno[i].setImage(UIImage(named: "Cancel_unSelected.png"), for: UIControl.State())
                    arraybuttonsno[i].isSelected = false
                    arraybuttonsyes[i].layoutIfNeeded()
                    arraybuttonsno[i].layoutIfNeeded()
                }
            }
            
        }
    }
    
    func checkunckeckbtn(_ sender:UIButton, ISCHECK:Bool) {
        if ISCHECK == true {
            for item in arraybuttonsyes {
                if item == sender {
                    item.setImage(UIImage(named: "OK-select.png"), for: UIControl.State())
                    item.isSelected = true
                    item.setNeedsDisplay()
                    let myindex:Int = arraybuttonsyes.index(of: item)!
                    self.arrayvalues[myindex] = true
                    //we have some childs and case
                    switch (myindex) {
                    case 0: //this also selects subchilds
                        arraybuttonsyes[1].setImage(UIImage(named: "OK-select.png"), for: UIControl.State())
                        arraybuttonsyes[1].isSelected = true
                        arraybuttonsyes[2].setImage(UIImage(named: "OK-select.png"), for: UIControl.State())
                        arraybuttonsyes[2].isSelected = true
                        arraybuttonsno[1].setImage(UIImage(named: "Cancel_unSelected.png"), for: UIControl.State())
                        arraybuttonsno[1].isSelected = false
                        arraybuttonsno[2].setImage(UIImage(named: "Cancel_unSelected.png"), for: UIControl.State())
                        arraybuttonsno[2].isSelected = false
                        self.arrayvalues[1] = true
                        self.arrayvalues[2] = true
                        arraybuttonsno[1].setNeedsDisplay()
                        arraybuttonsno[2].setNeedsDisplay()
                        
                        
                    case 5: //this also selects subchilds
                        arraybuttonsyes[6].setImage(UIImage(named: "OK-select.png"), for: UIControl.State())
                        arraybuttonsyes[6].isSelected = true
                        arraybuttonsyes[7].setImage(UIImage(named: "OK-select.png"), for: UIControl.State())
                        arraybuttonsyes[7].isSelected = true
                        arraybuttonsno[6].setImage(UIImage(named: "Cancel_unSelected.png"), for: UIControl.State())
                        arraybuttonsno[6].isSelected = false
                        arraybuttonsno[7].setImage(UIImage(named: "Cancel_unSelected.png"), for: UIControl.State())
                        arraybuttonsno[7].isSelected = false
                        self.arrayvalues[6] = true
                        self.arrayvalues[7] = true
                        arraybuttonsno[6].setNeedsDisplay()
                        arraybuttonsno[7].setNeedsDisplay()
                    default:
                        print("ok")
                    }
                    
                    for itemx in arraybuttonsno {
                        if arraybuttonsno.index(of: itemx) == myindex {
                            itemx.setImage(UIImage(named: "Cancel_unSelected.png"), for: UIControl.State())
                            itemx.isSelected = false
                            itemx.setNeedsDisplay()
                        }
                    }
                    
                }
            }
        } else {
            for item in arraybuttonsno {
                if item == sender {
                    item.setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                    item.isSelected = true
                    item.setNeedsDisplay()
                    let myindex:Int = arraybuttonsno.index(of: item)!
                    self.arrayvalues[myindex] = false
                    switch (myindex) {
                    case 0: //this also unselects subchilds
                        arraybuttonsyes[1].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                        arraybuttonsyes[1].isSelected = false
                        arraybuttonsyes[2].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                        arraybuttonsyes[2].isSelected = false
                        arraybuttonsno[1].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                        arraybuttonsno[1].isSelected = true
                        
                        arraybuttonsno[2].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                        arraybuttonsno[2].isSelected = true
                        arraybuttonsno[1].setNeedsDisplay()
                        arraybuttonsno[2].setNeedsDisplay()
                        self.arrayvalues[1] = false
                        self.arrayvalues[2] = false
                    case 5: //this also unselects subchilds
                        arraybuttonsyes[6].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                        arraybuttonsyes[6].isSelected = false
                        arraybuttonsyes[7].setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                        arraybuttonsyes[7].isSelected = false
                        arraybuttonsno[6].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                        arraybuttonsno[6].isSelected = true
                        
                        arraybuttonsno[7].setImage(UIImage(named: "Cancel-select.png"), for: UIControl.State())
                        arraybuttonsno[7].isSelected = true
                        arraybuttonsno[6].setNeedsDisplay()
                        arraybuttonsno[7].setNeedsDisplay()
                        self.arrayvalues[6] = false
                        self.arrayvalues[7] = false
                    default:
                        print("ok")
                    }
                    for itemx in arraybuttonsyes {
                        if arraybuttonsyes.index(of: itemx) == myindex {
                            itemx.setImage(UIImage(named: "OK-strock-black"), for: UIControl.State())
                            itemx.isSelected = false
                            itemx.setNeedsDisplay()
                            
                        }
                    }
                    
                }
            }
        }
        
        //\\   self.arrayvaluesToButtons()
    }
    // Appointment check yes
    @IBAction func appointmentYesButton(_ sender: UIButton) {
        self.arrayvalues[0] = true
        self.arrayvaluesToButtons()
        
    }
    
    
    // Appointment check no
    @IBAction func appointmentNoButton(_ sender: UIButton) {
        self.arrayvalues[0] = false
        self.arrayvalues[1] = false
        self.arrayvalues[2] = false
        self.arrayvaluesToButtons()
        
        
    }
    
    
    // Incoming check yes
    @IBAction func incomingYesButton(_ sender: UIButton) {
        self.arrayvalues[1] = true
        self.arrayvaluesToButtons()
        
    }
    
    
    // Incoming check no
    @IBAction func incomingNoButton(_ sender: UIButton) {
        self.arrayvalues[1] = false
        self.arrayvaluesToButtons()
    }
    
    
    // Cancellation check yes
    @IBAction func cancellationYesButton(_ sender: UIButton) {
        self.arrayvalues[2] = true
        self.arrayvaluesToButtons()
    }
    
    
    // Cancellation check no
    @IBAction func cancellationNoButton(_ sender: UIButton) {
        self.arrayvalues[2] = false
        self.arrayvaluesToButtons()
    }
    
    
    // Minutes check yes
    @IBAction func minutesYesButton(_ sender: UIButton) {
        self.arrayvalues[3] = true
        self.arrayvaluesToButtons()
    }
    
    
    // Minutes check no
    @IBAction func minutesNoButton(_ sender: UIButton) {
        self.arrayvalues[3] = false
        self.arrayvaluesToButtons()    }
    
    
    // Customers check yes
    @IBAction func customersYesButton(_ sender: UIButton) {
        self.arrayvalues[4] = true
        self.arrayvaluesToButtons()
    }
    
    
    // Customers check no
    @IBAction func customersNoButton(_ sender: UIButton) {
        self.arrayvalues[4] = false
        self.arrayvaluesToButtons()
    }
    
    
    // Customers events check yes
    @IBAction func customersEventsYesButton(_ sender: UIButton) {
        self.arrayvalues[5] = true
        self.arrayvaluesToButtons()
    }
    
    
    // Customers events check no
    @IBAction func customersEventsNoButton(_ sender: UIButton) {
        self.arrayvalues[5] = false
        self.arrayvalues[6] = false
        self.arrayvalues[7] = false
        self.arrayvaluesToButtons()
    }
    
    
    // Birthday check yes
    @IBAction func birthdayYesButton(_ sender: UIButton) {
        self.arrayvalues[6] = true
        self.arrayvaluesToButtons()
    }
    
    
    // Birthday check no
    @IBAction func birthdayNoButton(_ sender: UIButton) {
        self.arrayvalues[6] = false
        self.arrayvaluesToButtons()
    }
    
    
    // Anniversary check yes
    @IBAction func anniversaryYesButton(_ sender: UIButton) {
        self.arrayvalues[7] = true
        self.arrayvaluesToButtons()
    }
    
    
    // Anniversary check no
    @IBAction func anniversaryNoButton(_ sender: UIButton) {
        self.arrayvalues[7] = false
        self.arrayvaluesToButtons()
    }
    
    
    // SupplierNotificationsViewController
    @IBAction func saveButton(_ sender: AnyObject) {
        print("notifsobj \(notifsobject.getDic())")
        /*
         UpdateSupplierAlertSettingsBySupplierId
         {
         "obj": {
         "iSupplierId": 630,
         "bIncomingAppointment": false,
         "bCancellation": true,
         "b10MinutesBeforeAppointment": true,
         "bCustomersFollowUp": false,
         "bBirthday": true,
         "bAnniversary": false
         }
         }
         */
        var mydictionary:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        notifsobject.bIncomingAppointment = self.arrayvalues[1]
        notifsobject.bCancellation = self.arrayvalues[2]
        notifsobject.b10MinutesBeforeAppointment = self.arrayvalues[3]
        notifsobject.bCustomersFollowUp = self.arrayvalues[4]
        notifsobject.bBirthday = self.arrayvalues[6]
        notifsobject.bAnniversary = self.arrayvalues[7]
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        notifsobject.iSupplierId = providerID
        mydictionary["obj"] = notifsobject.getDic() as AnyObject
        api.sharedInstance.UpdateSupplierAlertSettingsBySupplierId(mydictionary, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
            {
                 Alert.sharedInstance.showAlert("UPDATE_ALERTS_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                
                
            }
            else {
                Alert.sharedInstance.showAlert("CANNOT_UPDATE_SUPPLIER_ALERTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            }
                }
            }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                
                Alert.sharedInstance.showAlert("CANNOT_UPDATE_SUPPLIER_ALERTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        })
        
    }
    
    
    // Open menu
    @IBAction func plusButton(_ sender: AnyObject) {
        let storyBoard = UIStoryboard(name:"SupplierExist", bundle: nil)
        let viewCon:PLUSMENUSupplier = storyBoard.instantiateViewController(withIdentifier: "PLUSMENUSupplier") as! PLUSMENUSupplier
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        viewCon.delegate = self
        self.present(viewCon, animated: true, completion: nil)
    }
    
    
    // Open from plus menu
    func openFromMenu(_ con:UIViewController) {
        self.present(con, animated: true, completion: nil)
    }
    
}
