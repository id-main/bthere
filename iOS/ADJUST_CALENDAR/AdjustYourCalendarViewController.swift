//
//  AdjustYourCalendarViewController.swift
//  Bthere
//
//  Created by Iustin Bthere on 12/19/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit


protocol didSelectContact
{
    func setContact()
}

class AdjustYourCalendarViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,didSelectContact {
    //date
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var viewPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var popUpView: UIView!
    
    //time
    @IBOutlet weak var timePickerView: UIView!
    @IBOutlet weak var timePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    //service
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var serviceTable: UITableView!
    @IBOutlet weak var serviceViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var serviceBtn: UIButton!
    @IBOutlet weak var customerBtn: UIButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var serviceTextField: UITextField!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var saveAndFinishBtn: UIButton!
    @IBOutlet weak var saveAndAddAnotherBtn: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var appTimeLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    
    
    var arrayForPermissionsIustin:NSMutableArray = []
    var ProviderServicesArray:Array<objProviderServices> = Array<objProviderServices>()
    var checksArray:Array<Bool> = Array<Bool>()
    var isfromSPECIALiCustomerUserId:Int = 0
    var generic:Generic = Generic()
    var pickedDate:Date = Date()
    var servicesIDsArray:Array<Int> = Array<Int>()
    var isFromCustomersMenu:Bool = false
    var newiUserStatusType:Int = 26
    var newiCreatedByUserId:Int = 0
    var PROVIDERID:Int = 0
    var secondUserID:Int = 0
    
    var permissionsArray : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //date init
        myDatePicker.backgroundColor = Colors.sharedInstance.color1
        myDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            myDatePicker.locale = Locale(identifier: "he_IL")
        } else {
            // English
            myDatePicker.locale = Locale(identifier: "en_GB")
        }
        
        //time init
        timePicker.backgroundColor = Colors.sharedInstance.color1
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")

//        let nib = UINib.init(nibName: "AdjustCalendarServicesCustomCell", bundle: nil)
//        serviceTable.register(nib, forCellReuseIdentifier: "AdjustCalendarCell")
        serviceTable.register(UINib(nibName: "AdjustCalendarServicesCustomCell", bundle: nil), forCellReuseIdentifier: "AdjustCalendarCell")

        serviceTable.separatorStyle = .none
        self.serviceTable.isScrollEnabled = false

        self.serviceTable.backgroundColor = .black
        
         myDatePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
         timePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        
        if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
        {
            GetSecondUserIDByFirst()
            
        }
        else
        {
            getProviderServicesForSupplierFunc()
        }
        
        
        Global.sharedInstance.adjustCalendarUserInfo = Dictionary<String,AnyObject>()

//        api.sharedInstance.getServicesProviderForSupplierfuncdoi()
        
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            dateTextField.textAlignment = .right
            timeTextField.textAlignment = .right
            serviceTextField.textAlignment = .right
            customerTextField.textAlignment = .right
            
        }
        else // if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 1
        {
            dateTextField.textAlignment = .left
            timeTextField.textAlignment = .left
            serviceTextField.textAlignment = .left
            customerTextField.textAlignment = .left
        }

        
        dateLabel.text = "DATE_ADJUST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        appTimeLabel.text = "APPOINTMENT_TIME_ADJUST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        serviceLabel.text = "SERVICE_ADJUST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        customerLabel.text = "CUSTOMER_ADJUST".localized(LanguageMain.sharedInstance.USERLANGUAGE)


        saveAndFinishBtn.setTitle("SAVE_AND_FINISH_ADJUST".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
        saveAndAddAnotherBtn.setTitle("SAVE_AND_ADD_ANOTHER".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)

        titleLabel.text = "ADJUST_CALENDAR_MAIN_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        if Global.sharedInstance.providerID == 0 {
            PROVIDERID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                PROVIDERID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            PROVIDERID = Global.sharedInstance.providerID
        }
        newiCreatedByUserId = PROVIDERID
        
        
    }
    
    func GetServicesPermissionForUsersBySupplier() {
        var dicToSendToServer:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        ////  self.myArray = [] //empty first
        /////  //JMODE in order to get services permissions for current provider and not all of them
        var providerID:Int = 0
            dicToSendToServer["iSupplierId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as Int
            }
            else {
                providerID = Global.sharedInstance.providerID as Int
            }

        print("providerIDzzzz \(Global.sharedInstance.providerID)")
        
        print("provider id to send: \(providerID)")
        dicToSendToServer["iSupplierId"] = providerID as AnyObject
        //        dic["iSupplierId"] = 28877 as AnyObject
        api.sharedInstance.GetServicesPermissionForUsersBySupplier(dicToSendToServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                            let resultsArray:NSArray = RESPONSEOBJECT["Result"] as! NSArray
                            print("services permissions result: \(resultsArray)")
                            self.procesxsMYARRAY(resultsArray)
                        }
                    } else {
                        self.view.makeToast(message: "NO_PERMISSION_FOR_SERVICES_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                            self.hidetoast()
                        })
                        let resultsArray:NSArray = NSArray()
                        self.procesxsMYARRAY(resultsArray)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            let resultsArray:NSArray = NSArray()
            self.procesxsMYARRAY(resultsArray)
        })
    }
    
    
//    func checkIfSpecial()
//    {
//        let USERDEF = Global.sharedInstance.defaults
//        if USERDEF.object(forKey: "isfromSPECIALiCustomerUserId") == nil {
//            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
//            USERDEF.synchronize()
//        } else {
//            if let _:Int = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as? Int {
//                let myint = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as! Int
//                self.isfromSPECIALiCustomerUserId = myint
//            }
//        }
//    }
    
   func setContact()
   {
    if let _ = Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as? String
    {
        self.customerTextField.text = limitCharactersNumbers(stringToBeLimited: (Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as! String))
    }
    else
    {
        self.customerTextField.text = ""
    }
    
    print("name: \(String(describing: Global.sharedInstance.adjustCalendarUserInfo["nvContactName"]))")
    print("phone number: \(String(describing: Global.sharedInstance.adjustCalendarUserInfo["nvPhoneNumber"]))")
    print("user id: \(String(describing: Global.sharedInstance.adjustCalendarUserInfo["userID"]))")
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
//        if let _ = Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as? String
//        {
//            self.customerTextField.text = limitCharactersNumbers(stringToBeLimited: (Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as! String))
//        }
//        else
//        {
//            self.customerTextField.text = ""
//        }
//
//        print("name: \(String(describing: Global.sharedInstance.adjustCalendarUserInfo["nvContactName"]))")
//        print("phone number: \(String(describing: Global.sharedInstance.adjustCalendarUserInfo["nvPhoneNumber"]))")
//        print("user id: \(String(describing: Global.sharedInstance.adjustCalendarUserInfo["userID"]))")
    }
    
//    override func viewWillAppear(_ animated: Bool)
//    {
//        super.viewWillAppear(true)
//        if let _ = Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as? String
//        {
//            if Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as! String == ""
//            {
//                customerTextField.text = ""
//            }
//        }
//        else
//        {
//            customerTextField.text = ""
//        }
//
//
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
// 0 is bad and dismiss, 1 is good and dismiss, 2 is bad and reset, 3 is good and reset
    
        if AppDelegate.shouldDismissVC
        {
            if isFromCustomersMenu
            {
                self.dismiss(animated: false, completion:
                    {
                        AppDelegate.tagPopUp = -1
                        AppDelegate.shouldDismissVC = false
                })
            }
            else
            {
                self.dismiss(animated: false, completion:
                    {
                        AppDelegate.tagPopUp = -1
                        AppDelegate.shouldDismissVC = false
                        self.rereadcalendar()
                })
            }

        }
        
    }
    
    override func viewDidLayoutSubviews()
    {
        let USERDEF = UserDefaults.standard
        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            timePicker.locale = Locale(identifier: "he_IL") //  set datePicker to 24 format without am/pm
        } else {
            timePicker.locale = Locale(identifier: "en_GB") //  set datePicker to 24 format without am/pm
        }
        for view in timePicker.subviews {
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                view.semanticContentAttribute = .forceRightToLeft

            } else {
                //this must fix uipicker being flipped
                view.semanticContentAttribute = .forceLeftToRight
            }
        }
    }
    
    func resetFields()
    {
        dateTextField.text = ""
        pickedDate = Date()
        timeTextField.text = ""
        serviceTextField.text = ""
        for i in 0..<checksArray.count
        {
            checksArray[i] = false
            
        }
        serviceTable.reloadData()
        customerTextField.text = ""
        Global.sharedInstance.adjustCalendarUserInfo = Dictionary<String,AnyObject>()
    }
    
    @IBAction func backAction(_ sender: Any)
    {
                let popUpAlert = Bundle.main.loadNibNamed("AdjustCalendarExitPopUp", owner: self, options: nil)?.first as! AdjustCalendarExitPopUp
                popUpAlert.frame = self.view.frame
                self.view.addSubview(popUpAlert)
    }
    
    
    @IBAction func dateAction(_ sender: UIButton)
    {
        if timeBtn.tag == 1
        {
            appointmentTimeAction(timeBtn)
        }
        if serviceBtn.tag == 1
        {
            serviceAction(serviceBtn)
        }
        hideAndShow(heightConstraint: self.viewPickerHeight, heightPercentValue: 0.6, buttonPressed: sender)
        if dateTextField.text == ""
        {
//            date
            //iustin
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateTextField.textColor = .black
            dateTextField.text = dateFormatter.string(from: myDatePicker.date)
            pickedDate = myDatePicker.date
            timeTextField.text = ""
        }
        
    }
    
    @IBAction func appointmentTimeAction(_ sender: UIButton)
    {
        print("date text field: \(String(describing: dateTextField.text))")
        if dateTextField.text == ""
        {
//            Alert.sharedInstance.showAlert("DAY_PASSED_BLOCK".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            Alert.sharedInstance.showAlert("SELECT_DATE_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
        else
        {
            if dateBtn.tag == 1
            {
                dateAction(dateBtn)
            }
            if serviceBtn.tag == 1
            {
                serviceAction(serviceBtn)
            }
            
            hideAndShow(heightConstraint: self.timePickerHeight, heightPercentValue: 0.5, buttonPressed: sender)
        }

    }
    
    @IBAction func serviceAction(_ sender: UIButton)
    {
        if timeTextField.text == ""
        {
            Alert.sharedInstance.showAlert("SELECT_APPOINTMENT_TIME_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
        else
        {
            if dateBtn.tag == 1
            {
                dateAction(dateBtn)
            }
            if timeBtn.tag == 1
            {
                appointmentTimeAction(timeBtn)
            }
            
            if sender.tag == 0
            {
                
                if CGFloat(self.ProviderServicesArray.count * 30) <= 120
                {
                    self.serviceViewHeight.constant = CGFloat(self.ProviderServicesArray.count * 30)
                }
                else
                {
                    self.serviceTable.isScrollEnabled = true
                    self.serviceViewHeight.constant = 120
                }
                sender.tag = 1
                
                
            }
            else
            {
                self.serviceViewHeight.constant = 0
                sender.tag = 0
                
                
            }
        }


    }
    
    @IBAction func customerAction(_ sender: UIButton)
    {
        // to be implemented something
        if checksArray.contains(true)
        {
            
            if dateBtn.tag == 1
            {
                dateAction(dateBtn)
            }
            if timeBtn.tag == 1
            {
                appointmentTimeAction(timeBtn)
            }
            if serviceBtn.tag == 1
            {
                serviceAction(serviceBtn)
            }
            //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let storyboardone = UIStoryboard(name: "NewImplementations", bundle: nil)
            //        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
            let viewCon = storyboardone.instantiateViewController(withIdentifier: "AdjustCalendarSyncContacts") as!  AdjustCalendarSyncContacts
            viewCon.view.frame = CGRect(x: 0, y:64, width:self.view.frame.size.width, height: self.view.frame.size.height - 64)
            viewCon.myDelegate = self
            self.present(viewCon, animated: true, completion:nil)
            
            ////        viewCon.isfromcustomer = true
            //        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            //        frontViewController.pushViewController(viewCon, animated: false)
            //        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            //        let mainRevealController = SWRevealViewController()
            //        mainRevealController.frontViewController = frontViewController
            //        mainRevealController.rearViewController = rearViewController
            //        let window :UIWindow = UIApplication.shared.keyWindow!
            //        window.rootViewController = mainRevealController
            
            
        }
        else
        {
            Alert.sharedInstance.showAlert("SELECT_SERVICE_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }

    }
    
    
    // hide or show the elements after pressing the buttons placed on the textFields
    func hideAndShow(heightConstraint:NSLayoutConstraint,heightPercentValue:CGFloat, buttonPressed:UIButton )
    {
        if buttonPressed.tag == 0
        {
                heightConstraint.constant = self.popUpView.frame.size.height * heightPercentValue
                buttonPressed.tag = 1

        }
        else
        {

                heightConstraint.constant = 0
                buttonPressed.tag = 0
                
 
        }
    }
    @IBAction func saveAndAddAnotherAction(_ sender: UIButton)
    {
        chekcIfIsGood(btn: sender)
    }
    @IBAction func saveAndFinishAction(_ sender: UIButton)
    {
        chekcIfIsGood(btn: sender)
    }

    func chekcIfIsGood(btn:UIButton)
    {
        if dateBtn.tag == 1
        {
            dateAction(dateBtn)
        }
        if timeBtn.tag == 1
        {
            appointmentTimeAction(timeBtn)
        }
        if serviceBtn.tag == 1
        {
            serviceAction(serviceBtn)
        }

        if dateTextField.text == ""
        {
            Alert.sharedInstance.showAlert("SELECT_DATE_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
        else if timeTextField.text == ""
        {
            Alert.sharedInstance.showAlert("SELECT_APPOINTMENT_TIME_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
        else if serviceTextField.text == ""
        {
            Alert.sharedInstance.showAlert("SELECT_SERVICE_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
        else if customerTextField.text == ""
        {
            Alert.sharedInstance.showAlert("SELECT_A_CUSTOMER_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
        else
        {
//            newOrder(sender: btn)
            
            checkCustomerExist(sender: btn)
        }
    }
    
    
    
    func newOrder(sender:UIButton)
    {
        let USERDEF = Global.sharedInstance.defaults
        print("aici userdef: \(String(describing: USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")))")

        servicesIDsArray = Array<Int>()
        for i in 0..<checksArray.count
        {
            if checksArray[i] == true
            {
                servicesIDsArray.append(ProviderServicesArray[i].iProviderServiceId)
            }
        }
        servicesIDsArray = uniq(servicesIDsArray)
        
        

        var order:OrderObj = OrderObj()
        
        var temporaryArrayWithSupplierIDs:Array<Int> = Array<Int>()
        if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1 && self.secondUserID != 0
        {
            temporaryArrayWithSupplierIDs.append(self.secondUserID)
        }
        else
        {
            temporaryArrayWithSupplierIDs = Global.sharedInstance.arrayGiveServicesKods
        }
        
        if self.isfromSPECIALiCustomerUserId != 0 {
            order = OrderObj(_iSupplierId: Global.sharedInstance.providerID, _iUserId: self.isfromSPECIALiCustomerUserId, _iSupplierUserId: temporaryArrayWithSupplierIDs, _iProviderServiceId:servicesIDsArray /*Global.sharedInstance.arrayServicesKodsToServer*/, _dtDateOrder:pickedDate,_nvFromHour: timeTextField.text!, _nvComment: "",_nvToHour:"")
        } else {
            order = OrderObj(_iSupplierId: Global.sharedInstance.providerID, _iUserId: Global.sharedInstance.adjustCalendarUserInfo["userID"] as! Int, _iSupplierUserId: temporaryArrayWithSupplierIDs, _iProviderServiceId:servicesIDsArray /*Global.sharedInstance.arrayServicesKodsToServer*/, _dtDateOrder:pickedDate,_nvFromHour: timeTextField.text!, _nvComment: "",_nvToHour:"")
        }

        if order.iUserId == 134 {
            let USERDEF = UserDefaults.standard
            if  USERDEF.object(forKey: "numberdefaultForOcassional") != nil {
                if let _:String = USERDEF.value(forKey: "numberdefaultForOcassional") as? String {
                    let ceva:String = USERDEF.value(forKey: "numberdefaultForOcassional") as! String
                    order.nvComment = ceva
                }
            }
        }

        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

        //\\print(Global.sharedInstance.dateDayClick.description)
        dictionaryForServer["orderObj"] = order.getDic() as AnyObject

            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {


                api.sharedInstance.newOrder(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        print("neworder RESPONSEOBJECT \(RESPONSEOBJECT)")
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {


                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//אם אין תור פנוי בזמן הזה
                            {

//                                let alert = UIAlertController(title: "", message: "ERR_FREE_H_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
//                                self.present(alert, animated: true, completion: nil)
//                                // change to desired number of seconds (in this case 6 seconds)
//                                let when = DispatchTime.now() + 6
//                                DispatchQueue.main.asyncAfter(deadline: when){
//                                    // your code with delay
//                                    alert.dismiss(animated: true, completion: nil)
//
//                                   self.resetFields()
//                                }
                                
                                if let _ =  Bundle.main.loadNibNamed("AdjustCalendarPopUp", owner: self, options: nil)?.first as? AdjustCalendarPopUp
                                {
                                    if sender == self.saveAndAddAnotherBtn
                                    {
                                        AppDelegate.tagPopUp = 2
                                        let popUpAlert = Bundle.main.loadNibNamed("AdjustCalendarPopUp", owner: self, options: nil)?.first as! AdjustCalendarPopUp
                                        popUpAlert.frame = self.view.frame
                                        self.view.addSubview(popUpAlert)
//                                        self.resetFields()
                                        
                                    }
                                    else if sender == self.saveAndFinishBtn
                                    {
                                        AppDelegate.tagPopUp = 3
                                        let popUpAlert = Bundle.main.loadNibNamed("AdjustCalendarPopUp", owner: self, options: nil)?.first as! AdjustCalendarPopUp
                                        popUpAlert.frame = self.view.frame
                                        self.view.addSubview(popUpAlert)
                                        
                                    }
                                }


                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1//הצליח
                            {
  
                                if let _ =  Bundle.main.loadNibNamed("AdjustCalendarPopUp", owner: self, options: nil)?.first as? AdjustCalendarPopUp
                                {
                                    if sender == self.saveAndAddAnotherBtn
                                    {
                                        AppDelegate.tagPopUp = 0
                                        let popUpAlert = Bundle.main.loadNibNamed("AdjustCalendarPopUp", owner: self, options: nil)?.first as! AdjustCalendarPopUp
                                        popUpAlert.frame = self.view.frame
                                        self.view.addSubview(popUpAlert)
                                        self.resetFields()
                                        

                                    }
                                    else if sender == self.saveAndFinishBtn
                                    {
                                        AppDelegate.tagPopUp = 1
                                        let popUpAlert = Bundle.main.loadNibNamed("AdjustCalendarPopUp", owner: self, options: nil)?.first as! AdjustCalendarPopUp
                                        popUpAlert.frame = self.view.frame
                                        self.view.addSubview(popUpAlert)
                                        
                                    }

                                    
                                }


                            }
                                //in case of 2 no event can be save this is special case so he just recieve push from server
                                //in case of 3 customer was rejected and cannot make appointment
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 3  || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 4 //
                            {
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                                self.resetFields()
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//שגיאה
                            {
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                                self.resetFields()
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3//שגיאה
                            {
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                                self.resetFields()
                            }
                        }
                    }
//                    if Global.sharedInstance.currentUser.iUserId != 0 {
//                        api.sharedInstance.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
//                    }
                },failure: {
                    (AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    self.resetFields()
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                })
            }
    }
    
    func rereadcalendar() {
        Global.sharedInstance.isProvider = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        let viewCon = SupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as!  CalendarSupplierViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        frontViewController.pushViewController(viewCon, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
    
    func limitCharactersNumbers(stringToBeLimited:String) -> String
    {
        if stringToBeLimited.count > 15
        {
            var composerString:String = ""
            composerString = stringToBeLimited.substring(to: stringToBeLimited.index(stringToBeLimited.startIndex, offsetBy: 15)) + "..."
            return composerString
            
        }
        else
        {
           return stringToBeLimited
        }

    }
    
    //services table
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        return ProviderServicesArray.count
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let cell: AdjustCalendarServicesCustomCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdjustCalendarCell") else {
                return AdjustCalendarServicesCustomCell(style: .default, reuseIdentifier: "AdjustCalendarCell")
            }
            return cell as! AdjustCalendarServicesCustomCell
        }()
        var canbecheckedFix:Bool = false
        if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
        {
            print("PERMISSIONSArray ius: \(arrayForPermissionsIustin)")
            var whatservice:objProviderServices = objProviderServices()
            whatservice = ProviderServicesArray[indexPath.row]
            print("asdasdasd: \(whatservice.getDic())")
            if arrayForPermissionsIustin.count > 0 {
                for permission in arrayForPermissionsIustin {
                    if let _:NSDictionary = permission as? NSDictionary {
                        let currentPermission = permission as! NSDictionary
                        if let _:Int = currentPermission["iSupplierServiceId"] as? Int {
                            let permissionServiceID = currentPermission["iSupplierServiceId"] as! Int
                            print("permission service id \(permissionServiceID) and provider serviceid \(whatservice.iProviderServiceId)")
                            if  whatservice.iProviderServiceId == permissionServiceID  {
                                canbecheckedFix = true
                                break
                            } else {
                                canbecheckedFix = false
                            }
                        }
                    }
                }
            }
        }
        else
        {
            canbecheckedFix = true
        }
        

        if canbecheckedFix == false
        {
            cell.isUserInteractionEnabled = false
            cell.inputView?.isUserInteractionEnabled = false
        }
        else
        {
            cell.isUserInteractionEnabled = true
            cell.inputView?.isUserInteractionEnabled = true
        }
        
                    cell.selectionStyle = .none
                    if checksArray[indexPath.row] == false
                    {
                        cell.serviceImg.image = nil
                    }
                    else
                    {
                        cell.serviceImg.image = UIImage(named: "v1.png")
                    }
        
                    cell.serviceName.text = ProviderServicesArray[indexPath.row].nvServiceName
                    return cell


//        cell.contentView.frame = CGRect(x: 0, y: 0, width: serviceView.frame.width, height: 20)

    }
    
    
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        if let _ = tableView.cellForRow(at: indexPath) as? AdjustCalendarServicesCustomCell
        {
            let cell = tableView.cellForRow(at: indexPath) as! AdjustCalendarServicesCustomCell
            cell.serviceImg.image = UIImage(named: "v1.png")
            checksArray[indexPath.row] = true
            var stringComposer = ""
            var servicesCount:Int = 0
            
            for i in 0..<checksArray.count
            {
                if checksArray[i] == true
                {
                    
                    stringComposer = stringComposer + ProviderServicesArray[i].nvServiceName + ","
                    servicesCount += 1
                }
                
            }
            if servicesCount > 0
            {
                // we delete that , character if it's only one service
                stringComposer.remove(at: stringComposer.index(before: stringComposer.endIndex))
            }
            
            serviceTextField.text = limitCharactersNumbers(stringToBeLimited: stringComposer)
        }

    }
    
    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath)
    {
        if let _  = tableView.cellForRow(at: indexPath) as? AdjustCalendarServicesCustomCell
        {
            let cell = tableView.cellForRow(at: indexPath) as! AdjustCalendarServicesCustomCell
            cell.serviceImg.image = nil
            checksArray[indexPath.row] = false
            
            var stringComposer = ""
            var servicesCount:Int = 0
            for i in 0..<checksArray.count
            {
                if checksArray[i] == true
                {
                    
                    stringComposer = stringComposer + ProviderServicesArray[i].nvServiceName + ","
                    servicesCount += 1

                }
                
            }
            if servicesCount > 0
            {
                // we delete that , character if it's only one service
                stringComposer.remove(at: stringComposer.index(before: stringComposer.endIndex))
            }

            
            
            serviceTextField.text = limitCharactersNumbers(stringToBeLimited: stringComposer)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 30
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        if sender == myDatePicker
        {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let someDate = dateFormatter.string(from: sender.date)
            let daycompare = dateFormatter.date(from: someDate)
            let todayDate = dateFormatter.string(from: Date())
            let daycomparetoday = dateFormatter.date(from: todayDate)
            
            if (daycompare! as NSDate).timeIntervalSince(daycomparetoday!).sign == .minus {
                //someDate is berofe than today
                Alert.sharedInstance.showAlert("DAY_PASSED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                myDatePicker.date = Date()
                dateTextField.text = dateFormatter.string(from: myDatePicker.date)
                pickedDate = myDatePicker.date
                timeTextField.text = ""
            } else {
                //someDate is equal or after than today
                dateTextField.textColor = .black
                dateTextField.text = dateFormatter.string(from: sender.date)
                pickedDate = myDatePicker.date
                timeTextField.text = ""
            }
        }
        else if sender == timePicker
        {
//            var hourstart = ""
//                // Hebrew language
//                let dateFormatter = DateFormatter()
//                dateFormatter.timeStyle = .none
//                dateFormatter.dateFormat = "HH:mm"
//                hourstart = dateFormatter.string(from: sender.date)
//                timeTextField.textColor = .black
//                timeTextField.text = hourstart
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let _ = dateTextField.text
            {
                let daycompare = dateFormatter.date(from: dateTextField.text!)
                let todayDate = dateFormatter.string(from: Date())
                let daycomparetoday = dateFormatter.date(from: todayDate)
//                if (daycompare! as NSDate).timeIntervalSince(daycomparetoday!).sign == .minus
                    if daycompare == daycomparetoday
                {
                    //someDate is berofe than today
//                    Alert.sharedInstance.showAlert("DAY_PASSED_BLOCK".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                    let calendar = Foundation.Calendar.current
                    let minutesNow = calendar.component(.minute, from: Date())
                    let roundedMinutesNow = roundToFive(value: minutesNow)
                    let intervalToAdd = roundedMinutesNow - roundedMinutesNow
                    timePicker.minimumDate = calendar.date(byAdding: .minute, value: intervalToAdd + 5, to: Date())
//                    timePicker.date = timePicker.minimumDate!
//                    timePicker.reloadInputViews()
                    var hourstart = ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"
                    hourstart = dateFormatter.string(from: sender.date)
//                    var minutes = calendar.component(.minute, from: sender.date)
//                    if minutes > 55
//                    {
//                        minutes += 5
//                    }
                    timeTextField.textColor = .black
                    timeTextField.text = hourstart
                } else {
                    //someDate is equal or after than today

                        
                    var hourstart = ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"
                    let min = dateFormatter.date(from: "00:00")!
                    timePicker.minimumDate = min
                    hourstart = dateFormatter.string(from: sender.date)
                    timeTextField.textColor = .black
                    timeTextField.text = hourstart
                }
            }
 
        }
        
        ////asdasda


        ///asdasdasd
    }
    

    func checkCustomerExist(sender:UIButton)
        {
                            var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dictionaryForServer["nvPhone"] = Global.sharedInstance.adjustCalendarUserInfo["nvPhoneNumber"] as AnyObject
                            //                dicPhone["nvPhone"] = "0501111111" as AnyObject
                            // 7399
        
                            //not get iuserid by phone
                            if Reachability.isConnectedToNetwork() == false//if there is connection
                            {
                                self.generic.hideNativeActivityIndicator(self)
//                                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else
                            {
                                api.sharedInstance.CheckCustomerExistByPhone(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                                    self.generic.hideNativeActivityIndicator(self)
                                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                        if let _ = RESPONSEOBJECT["Result"] as? Int {
                                            print("numar verifica \(String(describing: RESPONSEOBJECT["Result"]))")
        
                                            if RESPONSEOBJECT["Result"] as! Int == 0//phone not found
                                            {
                                                //user is not in dataBase, we need to Add him/her as a new customer
                                                self.addNewCustomer(sender: sender)
        
                                            } else
                                            {
                                                //number exists in database
                                                Global.sharedInstance.adjustCalendarUserInfo["userID"] = RESPONSEOBJECT["Result"] as AnyObject
                                                self.getCustomerDetails(sender: sender)
//
//                                                self.newOrder(sender: sender)
        
                                            }
                                        }
                                    }
                                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                                    print("Error: ", Error!.localizedDescription)
                                    self.generic.hideNativeActivityIndicator(self)
//                                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                })
        
                            }
    }
    
    func addNewCustomer(sender:UIButton)
    {
        if Reachability.isConnectedToNetwork() == false
        {
//            DispatchQueue.main.async(execute: { () -> Void in
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//            })
            
        }
        else {
            var  user:User = User()
            let base64 = ""
            var nvNickName:String = ""
            
            let dateString = "01/01/1901" // change to your date format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "dd/MM/yyyy"
            let hardCodedBirthday:Date = dateFormatter.date(from: dateString)!
            
            nvNickName = Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as! String
            user = User(_iUserId: 0,
                        _nvUserName: "",
                        _nvFirstName: "",
                        _nvLastName: "",
                        //_nvSupplierNotes: self.txtViewComments.text,
                _dBirthdate: hardCodedBirthday,//txtDate,
                _nvMail: "",
                //   _nvAdress: "",
                _iCityType: 1,
                _nvPhone: Global.sharedInstance.adjustCalendarUserInfo["nvPhoneNumber"] as! String,
                _nvPassword: "",
                _nvVerification: "",
                _bAutomaticUpdateApproval: true,//אם סימן אני מאשר
                _bDataDownloadApproval: true,//?
                _bAdvertisingApproval: false,//אם סימן קראתי את התקנון
                _bTermOfUseApproval: true,//תמיד
                // _iUserStatusType: 24, //or 26 - non active
                _iUserStatusType : newiUserStatusType, //KEEP IN MIND 25 is for non active else 24 is allready active
                _bIsGoogleCalendarSync: true,
                _nvImage:base64,
                //   _iCreatedByUserId: 1,//?
                _iCreatedByUserId :newiCreatedByUserId,
                _iLastModifyUserId: 1,//?
                _iSysRowStatus: 1,//?
                _bIsManager: 0,
                _nvDeviceToken: "",
                _iStatus:  1,
                _nvNickName: nvNickName
            )
            var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            
            //NEWVIPANDNOTES on server side
            var providerCustomersObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            
            providerCustomersObj["bIsVip"] = false as AnyObject
            
            providerCustomersObj["nvSupplierRemark"] = "" as AnyObject
            
            var providerID:Int = 0
            if Global.sharedInstance.providerID == 0 {
                providerID = 0
                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                    providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                    
                }
            } else {
                providerID = Global.sharedInstance.providerID
            }
            dictionaryForServer["iSupplierId"] = providerID as AnyObject
            //JMODE bIsCreatedBySupplierId
            
            dictionaryForServer["bIsCreatedBySupplierId"] = false as AnyObject
            if self.newiCreatedByUserId != self.PROVIDERID {
                dictionaryForServer["bIsCreatedBySupplierId"] = false as AnyObject
            } else {
                dictionaryForServer["bIsCreatedBySupplierId"] = true as AnyObject
            }
            dictionaryForServer["bIsCreatedBySupplierId"] = false as AnyObject
            
            dictionaryForServer["nvNickName"] = nvNickName as AnyObject
            var dictionaryObjectUser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dictionaryObjectUser = user.getDic()
            //(UserObj objUser, int iSupplierId)
            dictionaryForServer["objUser"] = dictionaryObjectUser as AnyObject
            dictionaryForServer["providerCustomersObj"] = providerCustomersObj as AnyObject
            print("what to send \(dictionaryForServer)")
            
            
            print("\n********************************* add new customer  ********************\n")
            //\\ let jsonData = try! NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
            //\\ let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            //\\ print(jsonString)
            
            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                DispatchQueue.main.async(execute: { () -> Void in
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                })
                
            }
            else
            {
                api.sharedInstance.SupplierAddCustomer(dictionaryForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            //   print("ce astepta \(RESPONSEOBJECT["Result"])")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                            {
                                print("eroare la add new \(String(describing: RESPONSEOBJECT["Error"]))")
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                print("eroare la add new \(String(describing: RESPONSEOBJECT["Error"]))")
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            }
                            else
                            {
                                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                {
                                    let integerResult :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                    print("response request supplier add customer \(RESPONSEOBJECT)")
                                    if integerResult > 0 {
                                        self.generic.hideNativeActivityIndicator(self)
                                        
//                                        Global.sharedInstance.adjustCalendarUserInfo["nvPhoneNumber"] = self.modifiedPhoneNumber as AnyObject
//                                        Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] = self.contactList[self.lastChecked].nvContactName as AnyObject
                                        Global.sharedInstance.adjustCalendarUserInfo["userID"] = RESPONSEOBJECT["Result"] as AnyObject
                                        self.newOrder(sender: sender)
                                        
                                        
                                        
                                    }
                                    else
                                    {
//                                        DispatchQueue.main.async(execute: { () -> Void in
//                                            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                                        })
                                    }
                                    
                                }
                                else {
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        Alert.sharedInstance.showAlert("ERROR_ADD_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                    })
                                }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if AppDelegate.showAlertInAppDelegate == false
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            Alert.sharedInstance.showAlert("ERROR_ADD_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        })
                    }
                })
            }
        }
    }
    
    

    func addNewExistingCustomer(existingCustomerDetails:Dictionary<String,AnyObject>, sender:UIButton)
    {
//        print("existingCustomerDetails: \(existingCustomerDetails)")
        if Reachability.isConnectedToNetwork() == false
        {
//            DispatchQueue.main.async(execute: { () -> Void in
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//            })
            
        }
        else {
            let user:User = User()
            var nvNickName:String = ""
            if let _ = Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as? String
            {
                nvNickName = Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as! String
            }
            if let _ = existingCustomerDetails["iUserId"] as? Int
            {
                user.iUserId = existingCustomerDetails["iUserId"] as! Int
            }
            if let _ = existingCustomerDetails["nvUserName"] as? String
            {
                user.nvUserName = existingCustomerDetails["nvUserName"] as! String
            }
            if let _ = existingCustomerDetails["nvFirstName"] as? String
            {
                user.nvFirstName = existingCustomerDetails["nvFirstName"] as! String
            }
            if let _ = existingCustomerDetails["nvLastName"] as? String
            {
                user.nvLastName = existingCustomerDetails["nvLastName"] as! String
            }
            if let _ = existingCustomerDetails["nvMail"] as? String
            {
                user.nvMail = existingCustomerDetails["nvMail"] as! String
            }
            if let _ = existingCustomerDetails["iCityType"] as? Int
            {
                user.iCityType = existingCustomerDetails["iCityType"] as! Int
            }
            if let _ = existingCustomerDetails["nvPhone"] as? String
            {
                user.nvPhone = existingCustomerDetails["nvPhone"] as! String
            }
            if let _ = existingCustomerDetails["nvPassword"] as? String
            {
                user.nvPassword = existingCustomerDetails["nvPassword"] as! String
            }
            if let _ = existingCustomerDetails["nvVerification"] as? String
            {
                user.nvVerification = existingCustomerDetails["nvVerification"] as! String
            }
            if let _ = existingCustomerDetails["bAutomaticUpdateApproval"] as? Int
            {
                if existingCustomerDetails["bAutomaticUpdateApproval"] as! Int == 0
                {
                    user.bAutomaticUpdateApproval = false
                    
                }
                else if existingCustomerDetails["bAutomaticUpdateApproval"] as! Int == 1
                {
                    user.bAutomaticUpdateApproval = true
                }
                
            }
            if let _ = existingCustomerDetails["bDataDownloadApproval"] as? Int
            {
                if existingCustomerDetails["bDataDownloadApproval"] as! Int == 0
                {
                    user.bDataDownloadApproval = false
                    
                }
                else if existingCustomerDetails["bDataDownloadApproval"] as! Int == 1
                {
                    user.bDataDownloadApproval = true
                }
            }
            if let _ = existingCustomerDetails["bAdvertisingApproval"] as? Int
            {
                if existingCustomerDetails["bAdvertisingApproval"] as! Int == 0
                {
                    user.bAdvertisingApproval = false
                    
                }
                else if existingCustomerDetails["bAdvertisingApproval"] as! Int == 1
                {
                    user.bAdvertisingApproval = true
                }
            }
            if let _ = existingCustomerDetails["bTermOfUseApproval"] as? Int
            {
                if existingCustomerDetails["bTermOfUseApproval"] as! Int == 0
                {
                    user.bTermOfUseApproval = false
                    
                }
                else if existingCustomerDetails["bTermOfUseApproval"] as! Int == 1
                {
                    user.bTermOfUseApproval = true
                }
            }
            if let _ = existingCustomerDetails["iUserStatusType"] as? Int
            {
                user.iUserStatusType = existingCustomerDetails["iUserStatusType"] as! Int
            }
            if let _ = existingCustomerDetails["bIsGoogleCalendarSync"] as? Int
            {
                if existingCustomerDetails["bIsGoogleCalendarSync"] as! Int == 0
                {
                    user.bIsGoogleCalendarSync = false
                    
                }
                else if existingCustomerDetails["bIsGoogleCalendarSync"] as! Int == 1
                {
                    user.bIsGoogleCalendarSync = true
                }
            }
            if let _ = existingCustomerDetails["nvImage"] as? String
            {
                user.nvImage = existingCustomerDetails["nvImage"] as! String
            }
            if let _ = existingCustomerDetails["iCreatedByUserId"] as? Int
            {
                user.iCreatedByUserId = existingCustomerDetails["iCreatedByUserId"] as! Int
            }
            if let _ = existingCustomerDetails["iLastModifyUserId"] as? Int
            {
                user.iLastModifyUserId = existingCustomerDetails["iLastModifyUserId"] as! Int
            }
            if let _ = existingCustomerDetails["iSysRowStatus"] as? Int
            {
                user.iSysRowStatus = existingCustomerDetails["iSysRowStatus"] as! Int
            }
            if let _ = existingCustomerDetails["bIsManager"] as? Int
            {
                user.bIsManager = existingCustomerDetails["bIsManager"] as! Int
            }
            if let _ = existingCustomerDetails["bIsManager"] as? String
            {
                user.nvDeviceToken = existingCustomerDetails["bIsManager"] as! String
            }
            
            user.iStatus = 1
            
            if let _ = existingCustomerDetails["nvNickName"] as? String
            {
                user.nvNickName = existingCustomerDetails["nvNickName"] as! String
            }
            else if let _ = Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as? String
            {
                user.nvNickName = Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] as! String
            }
            
//            user = User(_iUserId: 0,
//                        _nvUserName: "",
//                        _nvFirstName: "",
//                        _nvLastName: "",
//                        //_nvSupplierNotes: self.txtViewComments.text,
//                _dBirthdate: STRdBirthdate,//txtDate,
//                _nvMail: "",
//                //   _nvAdress: "",
//                _iCityType: 1,
//                _nvPhone: Global.sharedInstance.adjustCalendarUserInfo["nvPhoneNumber"] as! String,
//                _nvPassword: "",
//                _nvVerification: "",
//                _bAutomaticUpdateApproval: true,//אם סימן אני מאשר
//                _bDataDownloadApproval: true,//?
//                _bAdvertisingApproval: false,//אם סימן קראתי את התקנון
//                _bTermOfUseApproval: true,//תמיד
//                // _iUserStatusType: 24, //or 26 - non active
//                _iUserStatusType : newiUserStatusType, //KEEP IN MIND 25 is for non active else 24 is allready active
//                _bIsGoogleCalendarSync: true,
//                _nvImage:base64,
//                //   _iCreatedByUserId: 1,//?
//                _iCreatedByUserId :newiCreatedByUserId,
//                _iLastModifyUserId: 1,//?
//                _iSysRowStatus: 1,//?
//                _bIsManager: 0,
//                _nvDeviceToken: "",
//                _iStatus:  1,
//                _nvNickName: nvNickName
//            )
            var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            
            //NEWVIPANDNOTES on server side
            var providerCustomersObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            
            providerCustomersObj["bIsVip"] = false as AnyObject
            
            providerCustomersObj["nvSupplierRemark"] = "" as AnyObject
            
            var providerID:Int = 0
            if Global.sharedInstance.providerID == 0 {
                providerID = 0
                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                    providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                    
                }
            } else {
                providerID = Global.sharedInstance.providerID
            }
            dictionaryForServer["iSupplierId"] = providerID as AnyObject
            //JMODE bIsCreatedBySupplierId
            
            dictionaryForServer["bIsCreatedBySupplierId"] = false as AnyObject
            if self.newiCreatedByUserId != self.PROVIDERID {
                dictionaryForServer["bIsCreatedBySupplierId"] = false as AnyObject
            } else {
                dictionaryForServer["bIsCreatedBySupplierId"] = true as AnyObject
            }
            dictionaryForServer["bIsCreatedBySupplierId"] = false as AnyObject
            
            dictionaryForServer["nvNickName"] = nvNickName as AnyObject
            var dictionaryUserObject:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dictionaryUserObject = user.getDic()
            //(UserObj objUser, int iSupplierId)
            dictionaryForServer["objUser"] = dictionaryUserObject as AnyObject
            dictionaryForServer["providerCustomersObj"] = providerCustomersObj as AnyObject
            print("what to send \(dictionaryForServer)")
            
            
            print("\n********************************* add new customer  ********************\n")
            //\\ let jsonData = try! NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
            //\\ let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            //\\ print(jsonString)
            
            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                DispatchQueue.main.async(execute: { () -> Void in
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                })
                
            }
            else
            {
                api.sharedInstance.SupplierAddCustomer(dictionaryForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            //   print("ce astepta \(RESPONSEOBJECT["Result"])")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                            {
                                print("eroare la add new \(String(describing: RESPONSEOBJECT["Error"]))")
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                print("eroare la add new \(String(describing: RESPONSEOBJECT["Error"]))")
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            }
                            else
                            {
                                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                {
                                    let integerResult :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                    print("response request supplier add customer \(RESPONSEOBJECT)")
                                    if integerResult > 0 {
                                        self.generic.hideNativeActivityIndicator(self)
                                        
                                        //                                        Global.sharedInstance.adjustCalendarUserInfo["nvPhoneNumber"] = self.modifiedPhoneNumber as AnyObject
                                        //                                        Global.sharedInstance.adjustCalendarUserInfo["nvContactName"] = self.contactList[self.lastChecked].nvContactName as AnyObject
                                        Global.sharedInstance.adjustCalendarUserInfo["userID"] = RESPONSEOBJECT["Result"] as AnyObject
                                        self.newOrder(sender: sender)
                                        
                                        
                                        
                                    }
                                    else
                                    {
                                        self.generic.hideNativeActivityIndicator(self)
//                                        DispatchQueue.main.async(execute: { () -> Void in
//                                            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                                        })
                                    }
                                    
                                }
                                else {
                                    self.generic.hideNativeActivityIndicator(self)
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        Alert.sharedInstance.showAlert("ERROR_ADD_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                    })
                                }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if AppDelegate.showAlertInAppDelegate == false
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            Alert.sharedInstance.showAlert("ERROR_ADD_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        })
                    }
                })
            }
        }
    }
    
    func getCustomerDetails(sender:UIButton)
    {
        var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetCustomerDetails["iUserId"] = Global.sharedInstance.adjustCalendarUserInfo["userID"] as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
        api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            self.generic.hideNativeActivityIndicator(self)
            //                  print("aici doi \(responseObject ?? "" as AnyObject)")
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                
                if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                {
              //\\      print("response getCustomerDetails: \(RESPONSEOBJECT["Result"])")
                    if let _ = RESPONSEOBJECT["Result"]!["iCreatedByUserId"] as? Int
                    {
                        if RESPONSEOBJECT["Result"]!["iCreatedByUserId"] as! Int == Global.sharedInstance.providerID
                        {
                            self.newOrder(sender: sender)
                        }
                        else
                        {
                            self.addNewExistingCustomer(existingCustomerDetails: RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>,sender: sender)
                        }
                    }
                    else
                    {
                        self.addNewExistingCustomer(existingCustomerDetails: RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>,sender: sender)
                    }

                    
                    
                }
                else
                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            self.generic.hideNativeActivityIndicator(self)

//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))

        })
        }
    }
    
    func roundToFive(value: Int) -> Int{
        var fractionNum = Double(value) / 5.0
        let roundedNum = Int(ceil(fractionNum))
        return roundedNum * 5
    }
    
    //get services from server
    func getProviderServicesForSupplierFunc()
    {
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
            dictionaryForServer["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            
        } else {
            dictionaryForServer["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }
        print("CEEE Global.sharedInstance.providerID \(Global.sharedInstance.providerID)")
        
        api.sharedInstance.getProviderServicesForSupplier(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        
                        let providerServicesObjects:objProviderServices = objProviderServices()
                        if let _:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String,AnyObject>>
                        {
                            print("aaaaaaaa \(RESPONSEOBJECT["Result"] ?? 1 as AnyObject)")
                            self.ProviderServicesArray = providerServicesObjects.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            if self.ProviderServicesArray.count == 0
                            {
                                self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else
                            {
//                                for item in self.ProviderServicesArray {
//                                    print("self.ProviderServicesArray \(item.description)")
//                                }
                                for _ in self.ProviderServicesArray
                                {
                                    self.checksArray.append(false)
                                }
                                    self.serviceTable.reloadData()
                    
                                
                            }
                            
                        } else {
                            self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            
        })
    }
    
    func procesxsMYARRAY(_ REZULTATE:NSArray) {
        self.permissionsArray  = REZULTATE.mutableCopy() as! NSMutableArray
        print("PERMISSIONSArray \(permissionsArray)")
        
        
        
        if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1 && self.secondUserID != 0 
        {
            arrayForPermissionsIustin = []
            for permission in permissionsArray {
                if let _:NSDictionary = permission as? NSDictionary {
                    let mydictionary = permission as! NSDictionary
                    if let _:Int = mydictionary["iUserId"] as? Int {
                        let iUserID = mydictionary["iUserId"] as! Int
                        if iUserID == self.secondUserID {
                            arrayForPermissionsIustin.add(mydictionary)
                        }
                    }
                }
            }
        }
        else
        {
            arrayForPermissionsIustin = permissionsArray
        }
        
        getProviderServicesForSupplierFunc()
        
        
    }
    
    
    func GetSecondUserIDByFirst()  {
        
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var userID:Int = 0
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let userIdDictionary:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let userIdInteger:Int = userIdDictionary.value(forKey: "currentUserId") as? Int{
                userID = userIdInteger
            }
        }
        if userID != 0
        {
            dictionaryForServer["iUserId"] =  userID as AnyObject
            print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
            if Reachability.isConnectedToNetwork() == false
            {
                
            }
            else
            {
                api.sharedInstance.GetSecondUserIdByFirstUserId(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                                        let integerResult :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                        print("SECOND USER ID adjustCalendar: \(integerResult)")
                                        if integerResult > 0 {
                                            self.secondUserID = integerResult
                                            self.GetServicesPermissionForUsersBySupplier()
//                                            self.GetCustomerActiveOrdersBySupplier()
//                                            self.GetProviderSettingsForCalendarmanagement()
                                        }
                                    }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    
                })
            }
        }
        
        
    }
    
    
    func hidetoast()
    {
        view.hideToastActivity()
    }
}
