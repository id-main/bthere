//
//  noTurnViewController.swift
//  Bthere
//
//  Created by User on 11.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//פופאפ אין תור פנוי התואם את בקשתך
class noTurnViewController: UIViewController {
    var isfromSPECIALiCustomerUserId:Int = 0
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    //MARK: - Properties
    
    var dtOrderTime:Date = Date()
    var orderObj:OrderObj?
    var generic:Generic = Generic()
    var delegate:OpenDetailsAppointmentDelegate!=nil
    var delegateDismiss:dismissDelegate!=nil
    var timer: Timer? = nil
    
    //MARK: - Outlet
    
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var dpChangeHour: UIDatePicker!
    @IBOutlet weak var lblNoAppointment: UILabel!
    
    @IBOutlet var btnClose: UIButton!
    //בלחיצה על האיקס
    @IBAction func btnCloseAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var btnOk: UIButton!
    ///בלחיצה על אישור
    @IBAction func btnOkAction(_ sender: AnyObject) {
        saveOrderTimeInString()
        
        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if orderObj?.iUserId == 134 {
            let USERDEF = UserDefaults.standard
            if  USERDEF.object(forKey: "numberdefaultForOcassional") != nil {
                if let _:String = USERDEF.value(forKey: "numberdefaultForOcassional") as? String {
                    let ceva:String = USERDEF.value(forKey: "numberdefaultForOcassional") as! String
                    orderObj?.nvComment = ceva
                }
            }
        }
        dicOrderObj["orderObj"] = orderObj!.getDic() as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            //מסיון לקבוע תור שוב
            api.sharedInstance.newOrder(dicOrderObj, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//אם אין תור פנוי בזמן הזה
                        {
                            self.showAlertDelegateX("ERR_FREE_H_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            
                            ///   AppDelegate.showAlertInAppDelegate = true
                            
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1//הצליח
                        {
                            // Check if calendar is synchronized
                            if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
                                Calendar.sharedInstance.saveEventInDeviceCalander()
                            }
                            self.showAlertDelegateX("NO_TURN".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            // AppDelegate.showAlertInAppDelegate = true
                            
                            self.dismiss(animated: true, completion:nil)
                            self.GetCustomerOrders()
                        }
                            //in case of 2 no event can be save this is special case so he just recieve push from server
                            //in case of 3 customer was rejected and cannot make appointment
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 3 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 4 //
                        {
                            self.dismiss(animated: true, completion:nil)
                            self.GetCustomerOrders()
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//שגיאה
                        {
                            self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                }
                if Global.sharedInstance.currentUser.iUserId != 0 {
                    api.sharedInstance.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                }
            },failure:
                {
                    (AFHTTPRequestOperation, NSError) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    if Global.sharedInstance.currentUser.iUserId != 0 {
                        api.sharedInstance.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                    }
            })
        }
    }
    
    @IBOutlet weak var lblWhatToDo: UILabel!
    //הכנס לרשימת המתנה
    @IBAction func btnGoToWaitingList(_ sender: AnyObject) {
        
        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicOrderObj["orderObj"] = orderObj!.getDic() as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.addUserToWaitingList(dicOrderObj, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1//הצליח
                        {
                            let alertController = UIAlertController(title: "", message: "SUCCESS_ADD_TO_WAIT_LIST".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            
                            self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.doDelayed), userInfo: nil, repeats: false)
                            
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                        {
                            self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
            })
        }
    }
    //פונקציה הנקראת לאחר שנגמר הטיימר
    @objc func doDelayed(_ t: Timer) {
        self.dismiss(animated: false, completion: nil)
        self.delegateDismiss.dismiss()
    }
    
    @IBOutlet weak var btnGoToWaitingList: UIButton!
    
    @IBOutlet weak var btnNearAppointments: UIButton!
    
    @IBAction func btnNearAppointments(_ sender: AnyObject)
    {
        
    }
    
    @IBOutlet weak var btnChangeDay: UIButton!
    //החלף יום
    @IBAction func btnChangeDay(_ sender: AnyObject) {
        showPicker(view,hidden: false)
    }
    
    @IBOutlet weak var btnOtherSupplier: UIButton!
    
    @IBAction func btnOtherSupplier(_ sender: AnyObject) {
    }
    
    //MARK:INITIAL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        if USERDEF.object(forKey: "isfromSPECIALiCustomerUserId") == nil {
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
        } else {
            if let _:Int = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as? Int {
                let myint = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as! Int
                self.isfromSPECIALiCustomerUserId = myint
            }
        }
        lblNoAppointment.text = "NO_TURN_AS_ASK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblWhatToDo.text = "WHAT_TO_DO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnOk.setTitle("OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnGoToWaitingList.setTitle("ENTER_TO_WAIT_LIST".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnNearAppointments.setTitle("NEAR_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnChangeDay.setTitle("CHANGE_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnOtherSupplier.setTitle("OTHER_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissx))
        view.addGestureRecognizer(tap)
        
        dpChangeHour.backgroundColor = Colors.sharedInstance.color6
        dpChangeHour.setValue(UIColor.white, forKeyPath: "textColor")
        dpChangeHour.setValue(0.8, forKeyPath: "alpha")
        dpChangeHour.datePickerMode = UIDatePicker.Mode.date
        dpChangeHour.setValue(false, forKey: "highlightsToday")
        dpChangeHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        dpChangeHour.backgroundColor = UIColor.black
        
        viewPicker.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //הצגת פחקר לבחירת תאריך אחר
    func showPicker(_ view: UIView,hidden:Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewPicker.isHidden = hidden
        }, completion: { _ in })
    }
    //בעת גלילת הפיקר
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        if sender == dpChangeHour
        {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "HH:mm:SS"
            dtOrderTime  = sender.date
        }
    }
    
    @objc func dismissx()
    {
        saveOrderTimeInString()
        showPicker(view,hidden: true)
    }
    //שמירת שעת הארוע בסטרינג
    func saveOrderTimeInString()
    {
        let calendar = Foundation.Calendar.current
        let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: dtOrderTime)
        
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
       
        
        let fullHourS = "\(hourS_Show):\(minuteS_Show)"
        orderObj?.nvFromHour = fullHourS
    }
    
    //קבלת הארועים ללקוח
    func GetCustomerOrders()
    {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        // var arr = NSArray()
        // dic["iUserId"] = Global.sharedInstance.currentUser.iUserId
        if self.isfromSPECIALiCustomerUserId != 0 {
            dic["iUserId"] = self.isfromSPECIALiCustomerUserId as AnyObject
        } else {
            dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        }
        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject
        
        if Reachability.isConnectedToNetwork() == false
        {
            
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomerOrdersNoLogo(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift
                    let ps:OrderDetailsObj = OrderDetailsObj()
                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                        Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    }
                }
                self.delegate.openDetailsAppointment()
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
}
