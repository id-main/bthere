//GlobalDataViewController.swift
import UIKit

protocol validDataDelegate{
    func validData()
}

protocol reloadTblDelegate {
    func reloadTbl()
    func beginHeightUpdate()
    func reloadHeight()
}

protocol scrollOnEditDelegate {
    func scrollOnEdit(_ keyBoardSize:CGRect,textField:UITextField)
    func scrollOnEndEdit(_ keyBoardSize:CGRect)
}
protocol saveDataToWorkerDelegate {
    func  saveDataToWorker()->Bool
}
protocol closeLastCellSelegate {
    func closeCellFromOtherCell()
}
protocol closeLastCellSelegate1 {
    func closeCellFromOtherCell()
}
protocol genericDelegate {
    func showGeneric()
    func hideGeneric()
}
//דף 2 בהרשמה נתונים כלליים
class GlobalDataViewController: UIViewController, UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate ,ReloadCollectionDelegate ,ReloadTableDelegate,UIGestureRecognizerDelegate,addRowForSection3Delegate,reloadTableForSaveDelegate,putSubDelegate,ReloadTableWorkersDelegate,reloadTableForNewWorkerDelegate,editServiceDelegate,reloadServicesTableDelegate,reloadTableForNewServiceDelegate,editWorkerDelegate,dismiss,viewErrorForFirstSectionDelegate,validSection1Delegate,validDataDelegate,scrollOnEditDelegate,reloadTblDelegate,closeLastCellSelegate,closeLastCellSelegate1,genericDelegate{
    
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var backroundImage: UIImageView!
    @IBOutlet var variableConstraint: NSLayoutConstraint!
    var isupdate:Bool = false
    var tapopen:UIGestureRecognizer = UIGestureRecognizer()
    //MARK: - Properties
    var variableInt: Int = 0
    var generic:Generic = Generic()

    var delegateDP:setDatePickerRestDelegate!=nil
    var delegateTableAddress:tableViewAddressDelegate!=nil
    var delegateEnabledBtnDays:enabledBtnDaysDelegate!=nil

    var x  = 0
    var isOpen:Bool = false
    var a:Array<Bool> = []
    var flagsHelp:Array<Bool> = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,]
    //למקרה שסוגרים את העובד החדש ע״י לחיצה על סל אחר
    var newWorkerIsClose = false
    var newServiceIsClose = false

    var WorkersTbl:UITableView = UITableView()
    var ServicesTbl:UITableView = UITableView()
    var daysTbl:UITableView = UITableView()
    var hoursTbl:UITableView = UITableView()

    var indexPathWithRow:IndexPath = IndexPath(row: 0, section: 0)
    var indexPathWithRowRest:IndexPath = IndexPath(row: 0, section: 0)

    var days:Array<String> = ["SUNDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MONDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"TUESDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"WEDNSDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"THIRTHDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"FRIDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SHABAT_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    var indexPathCalendar:IndexPath = IndexPath(row: 0, section: 5)

    var headersCell:Array<String> =
        ["DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE),"HOURS_ACTIVITY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ADD_WORKERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SERVICE_PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"TURN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    var selectedCellForEdit:Array<Bool> = []//מערך זה מיצג האם הסל פתוח או סגור
    var cellOpenForEdit:Dictionary<Int,Int> = [0:2,1:2,2:2,3:2,4:2,5:2]
    var notificationsRowsInSection:Dictionary<Int,Int> = [0:2,1:2,2:2,3:2,4:2]

    var flags:Array<Bool> = []

    var delegateLineForLabel:lineCountForLabelDelegate!=nil
    var delegateSaveWorker:saveDataToWorkerDelegate!=nil
    var delegateSaveBussines:saveDataToWorkerDelegate!=nil
    var delegateSaveCalendar:saveDataToWorkerDelegate!=nil
    var delegateActiveHours:hoursActiveDelegate!=nil

    //popUpWorkingHours
    var attemptsToOpenActiveHoursCount:Int = 0
    var popUpWorkingHours:PopUpWorkingHours!
    var ExplainWorkingHoursPopUP:ExplainWorkingHoursPopUP!
    @IBOutlet weak var hightTbl: NSLayoutConstraint!
    @IBOutlet weak var hightWorkingHours: NSLayoutConstraint!
    @IBOutlet weak var extTbl: UITableView!
    @IBOutlet weak var bottomSAVEview: UIView!
    @IBOutlet weak var constHight: NSLayoutConstraint!
    var lastIndex:IndexPath = IndexPath(row: -1, section: 0)

    //  var ISFROMSETTINGS:Bool = false
    @IBOutlet weak var HEIGHTtopTABLE: NSLayoutConstraint!
    @IBOutlet weak var HEIGHTbottomview: NSLayoutConstraint!
    @IBOutlet weak var titleofScreen: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBAction func btnClose(_ sender: AnyObject) {


        nowinitalldatatodefault()
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        frontviewcontroller!.pushViewController(viewcon, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController


    }
    @IBOutlet weak var BTNSETUPWORKINHOURS: UIButton!
    @IBAction   func BTNSETUPWORKINHOURS(_ sender: AnyObject) {
            let mainstoryb = UIStoryboard(name: "NewDevel", bundle: nil)
            let viewSettingsSetupWorkingHours: SettingsSetupWorkingHours = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupWorkingHours")as! SettingsSetupWorkingHours
            viewSettingsSetupWorkingHours.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
            viewSettingsSetupWorkingHours.modalPresentationStyle = .custom
            self.present(viewSettingsSetupWorkingHours, animated: true, completion: nil)
    }
    @IBOutlet weak var BTNSAVEANDUPDATE: UIButton!
    @IBAction   func BTNSAVEANDUPDATE(_ sender: AnyObject) {


        tryGetSupplierCustomerUserIdByEmployeeId()


    }

    func tryGetSupplierCustomerUserIdByEmployeeId() {
        var y:Int = 0
        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        dicuser["iUserId"] =  y as AnyObject
        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                {
                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                    print("sup id e ok ? " + myInt.description)
                    if myInt == 0 {
                        //NO EMPL NO BUSINESS
                        //   self.setupdefaults(0)
                        //\\print ("no business")
                    } else {
                        //self.setupdefaults(myInt)
                        self.GetSecondUserIdByFirstUserId(myInt)
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
    //2
    func GetSecondUserIdByFirstUserId(_ employeID:Int)  {

        var y:Int = 0
        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        y = employeID
        dicEMPLOYE["iUserId"] =  y as AnyObject
        print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
        //        let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicEMPLOYE, options: NSJSONWritingOptions.PrettyPrinted)
        //        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        //        print(jsonString)
        if Reachability.isConnectedToNetwork() == false
        {
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
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
                                    print("SECOND USER ID \(myInt)")
                                    if myInt > 0 {
                                        self.updatenow(myInt)
                                    }
                                }
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
    //now update
    func updatenow(_ iUserID:Int) {
        closeCellFromOtherCell()
        var dicAddProviderDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

        isupdate = true

        //        //UpdProviderBuisnessDetails(int iFieldId, CalendarPropertiesObj objCalProp, int iProviderId)
        //        dicAddProviderDetails["iFieldId"] = Global.sharedInstance.generalDetails.iFieldId
        //        dicAddProviderDetails["objCalProp"] = Global.sharedInstance.generalDetails.calendarProperties.getDic()
        //     //  dicAddProviderDetails["iProviderId"] = Global.sharedInstance.providerID
        //       dicAddProviderDetails["iProviderId"] = 312
        //           print("changed? \(Global.sharedInstance.generalDetails.iFieldId)")
        //
        //
        //
        //

        //
        //        if Reachability.isConnectedToNetwork() == false
        //        {

        //            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        //        }
        //        else
        //        {
        //            api.sharedInstance.UpdProviderBuisnessDetails(dicAddProviderDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) -> Void in
        //                  print("eroare sau nu \(responseObject)")
        //                if responseObject["Error"]!["ErrorCode"] as! Int == 1 {
        //                    self.rereadPROVIDERDETAILS()
        //                }
        //                else
        //                {
        //                    showAlertDelegateX("ERROR_UPDATE_GENERAL_DETAILS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        //                }
        //                },failure: {(AFHTTPRequestOperation, Error) -> Void in
        //                    if AppDelegate.showAlertInAppDelegate == false
        //                    {
        //                        showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        //                        AppDelegate.showAlertInAppDelegate = true
        //                    }
        //            })
        //        }
        //
        //    }
        //        ce a ramaas wh ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 1]
        //        ce a ramaas wh ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 2]
        //        ce a ramaas wh ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 3]
        //        ce a ramaas wh ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 4]
        //        ce a ramaas wh ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 5]
        //        ce a ramaas wh ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 6]
        //        ce a ramaas wh ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 7]
        //        rh ce ramane ["nvFromHour": 10:30:00, "nvToHour": 11:00:00, "iDayInWeekType": 1]
        //        rh ce ramane ["nvFromHour": 00:00:00, "nvToHour": 00:00:00, "iDayInWeekType": 2]
        //        rh ce ramane ["nvFromHour": 00:00:00, "nvToHour": 00:00:00, "iDayInWeekType": 3]
        //        rh ce ramane ["nvFromHour": 00:00:00, "nvToHour": 00:00:00, "iDayInWeekType": 4]
        //        rh ce ramane ["nvFromHour": 00:00:00, "nvToHour": 00:00:00, "iDayInWeekType": 5]
        //        rh ce ramane ["nvFromHour": 00:00:00, "nvToHour": 00:00:00, "iDayInWeekType": 6]
        //        rh ce ramane ["nvFromHour": 00:00:00, "nvToHour": 00:00:00, "iDayInWeekType": 7]
        Global.sharedInstance.generalDetails.arrObjWorkingHours = Array<objWorkingHours>() //empty before mix the working and rest
        //IN CASE YOU WANT TO TEST OR CLEAR PREVIOUS BAD SAVED DATA USE FROM HERE ====>
        //    var workingHours:objWorkingHours = objWorkingHours()
        //      var workingHoursTEST:objWorkingHours = objWorkingHours()
        //            workingHours = objWorkingHours(
        //                _iDayInWeekType: 1,
        //                _nvFromHour: "10:30:00",
        //                _nvToHour: "11:00:00")
        //        workingHoursTEST = objWorkingHours(
        //            _iDayInWeekType: 1,
        //            _nvFromHour: "12:30:00",
        //            _nvToHour: "19:00:00")
        //        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
        //        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHoursTEST)
        //   <==== <====<====<====<====<====<====<====<====<==== to here AND COMMENT BELLOW
        var mymixedarray:Array<objWorkingHours> = Array<objWorkingHours>()
/////JMODE 0.01.2019
        ////////Global.sharedInstance.arrWorkHours
        for x in Global.sharedInstance.arrWorkHours {
            print("ce a ramaas wh \(x.getDic())")
            var workingHours:objWorkingHours = objWorkingHours()
            if x.iDayInWeekType != 0 && !(x.nvToHour == "00:00:00"){
                workingHours = objWorkingHours(
                    _iDayInWeekType: x.iDayInWeekType,
                    _nvFromHour: x.nvFromHour,
                    _nvToHour: x.nvToHour)
                if !mymixedarray.contains(workingHours) {
                    mymixedarray.append(workingHours)
                }
            }
        }
        for h in mymixedarray
        {
            print("mixedArray print1: \(h.getDic())")
        }
        //   print("Global.sharedInstance.arrWorkHoursRest \(Global.sharedInstance.arrWorkHoursRest)")
//        for x in Global.sharedInstance.arrWorkHoursRest {
//            print("rh ce ramane \(x.getDic())")
//            var workingHours:objWorkingHours = objWorkingHours()
//            if x.iDayInWeekType != 0 &&  !(x.nvToHour == "00:00:00") {
//                workingHours = objWorkingHours(
//                    _iDayInWeekType: x.iDayInWeekType,
//                    _nvFromHour: x.nvFromHour,
//                    _nvToHour: x.nvToHour)
//                if !mymixedarray.contains(workingHours) {
//                    mymixedarray.append(workingHours)
//                }
//            }
//        }
        for h in mymixedarray
        {
            print("mixedArray print2: \(h.getDic())")
        }
        print("mym \(mymixedarray.count)")
        if mymixedarray.count > 0 {
            for i in 1...7 {
                var hoursinday:Array<objWorkingHours> = []
                for z in 0..<mymixedarray.count {
                    let arie:objWorkingHours = mymixedarray[z]
                    let ay = arie.iDayInWeekType
                    if ay == i {
                        hoursinday.append(arie)
                    }
                }
                print("////////// \(i)")
                if hoursinday.count == 0 {
                    print("no working hours ")
                } else  if hoursinday.count == 1 && hoursinday[0].iDayInWeekType == i {
                    print("onele \(hoursinday[0].getDic())")
                    //\\      print("no cathch")
                    let oneelement:objWorkingHours = hoursinday[0]
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(oneelement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(oneelement)
                    }
                } else    if hoursinday.count == 2 && hoursinday[0].iDayInWeekType == i && hoursinday[1].iDayInWeekType == i {
                    print("onelex \(hoursinday[0].getDic())")
                    print("secondx \(hoursinday[1].getDic())")
                    //                    onelex ["nvFromHour": 10:30:00, "nvToHour": 20:00:00, "iDayInWeekType": 1]
                    //                    secondx ["nvFromHour": 11:00:00, "nvToHour": 12:00:00, "iDayInWeekType": 1]
                    let firstelement:objWorkingHours = hoursinday[0]
                    let secondelement:objWorkingHours = hoursinday[1]
                    let workelement:objWorkingHours = objWorkingHours()
                    let restlement:objWorkingHours = objWorkingHours()
                    workelement.iDayInWeekType = i
                    restlement.iDayInWeekType = i
                    workelement.nvFromHour = firstelement.nvFromHour
                    workelement.nvToHour = secondelement.nvFromHour
                    restlement.nvFromHour = secondelement.nvToHour
                    restlement.nvToHour = firstelement.nvToHour
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(workelement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workelement)
                    }
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(restlement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(restlement)
                    }
                }
            }
        }

        /////////till HERE
        for nextw in Global.sharedInstance.generalDetails.arrObjWorkingHours {
            print("nextw \(nextw.getDic())")
        }

        //        nextw ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 1]
        //        nextw ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 2]
        //        nextw ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 3]
        //        nextw ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 4]
        //        nextw ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 5]
        //        nextw ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 6]
        //        nextw ["nvFromHour": 06:00:00, "nvToHour": 22:30:00, "iDayInWeekType": 7]
        //        nextw ["nvFromHour": 10:30:00, "nvToHour": 11:00:00, "iDayInWeekType": 1]
        //        // for it in Global.sharedInstance.arrWorkHours
        //        {
        //            dic = it.getDic()
        //            if it.nvFromHour != "00:00:00" && it.nvToHour != "00:00:00" && it.nvFromHour != "" &&  it.nvToHour != "" &&  it.iDayInWeekType != 0 {
        //                arr.append(dic)
        //            }
        //        }
        //        for it in Global.sharedInstance.arrWorkHoursRest
        //        {
        //            dic = it.getDic()
        //            if it.nvFromHour != "00:00:00" && it.nvToHour != "00:00:00" && it.nvFromHour != "" &&  it.nvToHour != "" &&  it.iDayInWeekType != 0 {
        //                arr.append(dic)
        //            }
        //        }
        //


   //     dicAddProviderDetails["obj"] = Global.sharedInstance.generalDetails.getSecondDic(iUserID,iFieldId: Global.sharedInstance.generalDetails.iFieldId) as AnyObject
        dicAddProviderDetails["obj"] = Global.sharedInstance.generalDetails.geMASTERSecondDic(iUserID,iFieldId: Global.sharedInstance.generalDetails.iFieldId) as AnyObject

        dicAddProviderDetails["iSupplierServiceIdForDeleteUserPermission"] = Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.UpdateProviderGeneralDetails(dicAddProviderDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        print("eroare sau nu \(RESPONSEOBJECT)")
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                            self.rereadPROVIDERDETAILS()
                        }
                        else
                        {
                            self.showAlertDelegateX("ERROR_UPDATE_GENERAL_DETAILS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
    }



    func rereadPROVIDERDETAILS() {
        var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
                dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
                api.sharedInstance.getProviderAllDetails(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
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
                                //\\    print("responseee \(responseObject["Result"] )")
                                if let _ = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                                    Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                }
                                //\\print ("1 -> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName)")
                                //\\print ("2-> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress)")
                                //\\print ("3 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen)")
                                //  //\\print ("4 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage)")
                                self.nowinitalldatatodefault()
                                self.generic.hideNativeActivityIndicator(self)
                                let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
                                let frontviewcontroller:UINavigationController? = UINavigationController()
                                let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
                                frontviewcontroller!.pushViewController(viewcon, animated: false)
                                //initialize REAR View Controller- it is the LEFT hand menu.
                                let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                                let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
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
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
                })
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        print("global data isservice good \(Global.sharedInstance.isValidServiceName)")

        Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission = []
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 0 {
            nowinitalldatatodefault()
            backroundImage.isHidden = true
        }
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                btnClose.transform = scalingTransform
                self.backImg.transform = scalingTransform
            }
            btnClose.imageView!.contentMode = .scaleAspectFit
            self.navigationController?.isNavigationBarHidden = true
            self.view.backgroundColor = UIColor.white
            self.HEIGHTtopTABLE.constant = 52
            self.titleofScreen.text = "GLOBAL_DATA".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.titleofScreen.isHidden = false
            self.btnClose.isHidden = false
            self.backImg.isHidden = false
            self.btnClose.isUserInteractionEnabled = true
            //BTNSAVEANDUPDATE
            bottomSAVEview.isHidden = false
            self.view.bringSubviewToFront(bottomSAVEview)
            bottomSAVEview.bringSubviewToFront(BTNSAVEANDUPDATE)
            self.BTNSAVEANDUPDATE.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
            self.BTNSAVEANDUPDATE.isHidden = false
            self.BTNSAVEANDUPDATE.isUserInteractionEnabled = true
            self.BTNSETUPWORKINHOURS.setTitle("SET_WORKING_HOURS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
            self.BTNSETUPWORKINHOURS.isHidden = false
            self.BTNSETUPWORKINHOURS.isUserInteractionEnabled = true

            print("bottomSAVEview.frame.origin.y \(self.bottomSAVEview.frame.origin.y)")
            print("self.view.frame.size.width \(self.view.frame.size.width)")
            print("self.view.frame.size.height \(self.view.frame.size.height)")
        } else {
            self.navigationController?.isNavigationBarHidden = true
            self.HEIGHTtopTABLE.constant =  40
            self.titleofScreen.isHidden = true
            self.titleofScreen.text = ""
            self.btnClose.isHidden = true
            self.backImg.isHidden = true
            self.btnClose.isUserInteractionEnabled = false
            bottomSAVEview.isHidden = true
            self.BTNSAVEANDUPDATE.isHidden = true
            self.BTNSAVEANDUPDATE.isUserInteractionEnabled = false
            self.BTNSAVEANDUPDATE.setTitle("", for: UIControl.State())
            self.BTNSETUPWORKINHOURS.isHidden = true
            self.BTNSETUPWORKINHOURS.isUserInteractionEnabled = false
            self.BTNSETUPWORKINHOURS.setTitle("", for: UIControl.State())
            
        }
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
            setPropertiesOfHoursActiveToReread()
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:49)
        Global.sharedInstance.defaults.set(0, forKey: "firsttimecell")
        Global.sharedInstance.defaults.synchronize()
        self.navigationController?.isNavigationBarHidden = true
        self.delegateSaveWorker = Global.sharedInstance.WorkerCell
        a = flagsHelp

        WorkersTbl.isScrollEnabled = false



        if  DeviceType.IS_IPHONE_6P {
            Global.sharedInstance.heightForCell = 60
        }
        else{
            if    DeviceType.IS_IPHONE_6 {
                Global.sharedInstance.heightForCell = 54.5
            }
            else{
                if DeviceType.IS_IPHONE_5{
                    Global.sharedInstance.heightForCell = 46
                }
                else{
                    Global.sharedInstance.heightForCell = 39.1
                }
            }
        }

        Global.sharedInstance.helperTable = extTbl
        extTbl.separatorStyle = .none
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GlobalDataViewController.dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)

        daysTbl.alwaysBounceVertical = false
        hoursTbl.alwaysBounceVertical = false

        Global.sharedInstance.GlobalDataVC = self
        Global.sharedInstance.delegateValidData = self
        Global.sharedInstance.rgisterModelViewController?.delegateCloseLast = self

        Global.sharedInstance.isValidServiceName = true

    }
    func nowinitalldatatodefault() {
        Global.sharedInstance.GlobalDataVC = self
        Global.sharedInstance.delegateValidData = self
        setPropertiesOfHoursActiveToDefult()
        //אפוס נתונים
        Global.sharedInstance.hoursForWorker = false
        Global.sharedInstance.headersCellRequired = [false,false,true,false,true]
        Global.sharedInstance.currentEditCellOpen = -1
        Global.sharedInstance.isContinuPressed = false
        AppDelegate.countCellEditOpenService = 0
        Global.sharedInstance.selectedCellForEditService = []
        Global.sharedInstance.fromEdit = false
        Global.sharedInstance.countCellEditOpen = 0
        Global.sharedInstance.countCellHoursOpenFromEdit = 0
        Global.sharedInstance.ifOpenCell = false
        Global.sharedInstance.isClickEqual = false
        Global.sharedInstance.isClickNoEqual = false
        Global.sharedInstance.isOpenHours = false
        Global.sharedInstance.fSection5 = false
        Global.sharedInstance.isOpenWorker = false
        Global.sharedInstance.isOpenNewWorker = false
        Global.sharedInstance.isOpenHoursForPlus = false
        Global.sharedInstance.isOpenHoursForNewWorker = false
        Global.sharedInstance.isServiceProviderEditOpen = false
        Global.sharedInstance.isAllFlagsFalse = false
        Global.sharedInstance.isOpenHoursForPlusAction = false
        Global.sharedInstance.isNewService = false
        Global.sharedInstance.domainBuisness = ""
        Global.sharedInstance.generalDetails.arrObjServiceProviders = []
        Global.sharedInstance.generalDetails.arrObjProviderServices = []
        Global.sharedInstance.isFromFirstSave = false
        Global.sharedInstance.isFromSave = false

        ///----------------------------------------
        Global.sharedInstance.selectedCell = [false,false,false,false,false,false]
        ///----------------------------------------



        //\\print(Global.sharedInstance.generalDetails)

        if Global.sharedInstance.isFirst == true
        {
            Global.sharedInstance.isFirst = false
        }
        if Global.sharedInstance.isFirstBussinesServices == true
        {
            Global.sharedInstance.isFirstBussinesServices = false
        }
        if Global.sharedInstance.isFirstCalenderSetting == true
        {
            Global.sharedInstance.isFirstCalenderSetting = false
        }
        else
        {
            extTbl.reloadData()
        }


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }

    //MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        switch (tableView){
        case extTbl:
            return 5 // 1. business type 2.business h working h 3. employes 4.services 5. appoinment settings
        case daysTbl:
            return 1
        case hoursTbl:
            return 1
        case WorkersTbl:
            return Global.sharedInstance.generalDetails.arrObjServiceProviders.count
        case ServicesTbl:
            return Global.sharedInstance.generalDetails.arrObjProviderServices.count
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == extTbl
        {
            if section == 1//שעות פעילות
            {
                if Global.sharedInstance.selectedCell[section] == true//פתוח
                {
                    //אם לא נבחרו שעות
                    if Global.sharedInstance.hourShow == "" && Global.sharedInstance.hourShowRecess == ""
                    {
                        Global.sharedInstance.isReturn2RowsForHours = false
                        return 3//שעות פעילות,דייט פיקר,הפסקות
                    }
                    else
                    {
                        Global.sharedInstance.isReturn2RowsForHours = false
                        return 4//שעות פעילות,דייט פיקר,הפסקות,הצגת השעות
                    }
                }
                else// Global.sharedInstance.selectedCell[section] = false
                {
                    //אם לא נבחרו שעות
                    if Global.sharedInstance.hourShow == "" && Global.sharedInstance.hourShowRecess == ""
                    {
                        Global.sharedInstance.isReturn2RowsForHours = false
                        return 1//רק את השעות פעילות
                    }
                    else
                    {
                        Global.sharedInstance.isReturn2RowsForHours = true
                        return 2//שעות פעילות + הצגת השעות שנבחרו
                    }
                }
            }
            if Global.sharedInstance.isFromSave == true && section == 2 && Global.sharedInstance.isOpenNewWorker == true && Global.sharedInstance.isOpenHoursForPlusAction == false//בפעם הראשונה כל פתיחת הוספת עובדים
            {
                return 4
            }
            if section == 2 && Global.sharedInstance.isOpenHoursForPlusAction == true//מלחיצה על הפלוס של הוספת עובד חדש
            {
                return 6
            }
            if Global.sharedInstance.isFromFirstSave == true && section == 3 && Global.sharedInstance.isNewService == true
            {
                return 4
            }
            if Global.sharedInstance.isFromFirstSave == true && section == 3 {
                return 3
            }
            if Global.sharedInstance.isFromSave == true && section == 2
            {
                return 3
            }
            if section == 2 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.hourShowFirstWorker == ""
            {
                return 4
            }
            else if section == 2 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.hourShowFirstWorker != ""
            {
                return 5
            }
            if Global.sharedInstance.selectedCell[section] == true
            {
                return notificationsRowsInSection[section]!
            }
            return 1
        }
        else if tableView == daysTbl{
            return days.count
        }
        else if tableView == hoursTbl{
            return days.count
        }
        else if tableView == WorkersTbl
        {
            if flagsHelp.count > 0
            {
                if selectedCellForEdit[section] == true && ( flagsHelp[section] == false || Global.sharedInstance.isOpenHoursForNewWorker == false) && Global.sharedInstance.isClickNoEqual == false{
                    return 2
                }
                if ( flagsHelp[section] == true  && selectedCellForEdit[section] == true
                    && Global.sharedInstance.isOpenHoursForNewWorker == true) || (Global.sharedInstance.isClickNoEqual == true && selectedCellForEdit[section] == true){
                    return 4
                }
            }
            else{
                if selectedCellForEdit[section] == true {
                    return 2
                }
            }
            return 1
        }
        else if tableView == ServicesTbl{
            if Global.sharedInstance.selectedCellForEditService[section] == true{
                return 2
            }
            return 1
        }
        return 0
    }
    //Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == extTbl
        {
            Global.sharedInstance.indexPathNew = indexPath
            switch (indexPath.row)
            {
            case 0:
                let cell:MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell")as!MainTableViewCell
                cell.tag = indexPath.section
                cell.delegateKbCalendar = Global.sharedInstance.calendarSetting
                cell.selectionStyle = UITableViewCell.SelectionStyle.none

                //            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                //                cell.lblDesc.textAlignment = .right
                //            } else {
                ////                cell.lblDesc.textAlignment = .left
                //            }

                if indexPath.section == Global.sharedInstance.currentEditCellOpen
                {
                    cell.setDisplayData(headersCell[indexPath.section],hidden: Global.sharedInstance.headersCellRequired[indexPath.section],imageArrow: "generaldatadown.png",textArrow: "")
                }
                else
                {
                    //JMODE       cell.setDisplayData(headersCell[indexPath.section],hidden: Global.sharedInstance.headersCellRequired[indexPath.section],imageArrow: "",textArrow: "<")
                    cell.setDisplayData(headersCell[indexPath.section],hidden: Global.sharedInstance.headersCellRequired[indexPath.section],imageArrow: "generaldataleft.png",textArrow: "")
                }
                if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
                    if indexPath.section == 2 {
                        //JMODE DISABLE ADD EMPLOYE 26.07.2018
                        if Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 0 {
                            cell.setDisplayData(headersCell[indexPath.section],hidden: Global.sharedInstance.headersCellRequired[indexPath.section],imageArrow: "generaldatadown.png",textArrow: "")
                        } else {
                            //END JMODE
                            cell.setDisplayData(headersCell[indexPath.section],hidden: Global.sharedInstance.headersCellRequired[indexPath.section],imageArrow: "generaldataleft.png",textArrow: "")
                        }
                    }
                    if indexPath.section == 3 {
                        if Global.sharedInstance.generalDetails.arrObjProviderServices.count > 0 {
                            cell.setDisplayData(headersCell[indexPath.section],hidden: Global.sharedInstance.headersCellRequired[indexPath.section],imageArrow: "generaldatadown.png",textArrow: "")
                        } else {
                            cell.setDisplayData(headersCell[indexPath.section],hidden: Global.sharedInstance.headersCellRequired[indexPath.section],imageArrow: "generaldataleft.png",textArrow: "")
                        }
                    }
                }
                if indexPath.section == 0
                {
                    cell.viewtop.isHidden = false
                    //בשביל ה-placeHolder
                    cell.txtHolder.isHidden = false
                    cell.txtHolder.isUserInteractionEnabled = false
                    cell.txtHolder.attributedPlaceholder = NSAttributedString(string:headersCell[indexPath.section], attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 17)!]))
                    if Global.sharedInstance.domainBuisness != ""
                    {
                        cell.txtHolder.text = Global.sharedInstance.domainBuisness
                    }
                    else
                    {
                        cell.txtHolder.text = ""
                    }
                    cell.txtSub.isHidden = true
                    cell.lblDesc.isHidden = true
                    if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                        cell.txtHolder.textAlignment = .right
                    }

                }
                else
                {
                    cell.txtSub.isEnabled = false
                    cell.txtHolder.isHidden = true
                    cell.txtSub.isHidden = true
                    cell.lblDesc.isHidden = false
                    cell.viewtop.isHidden = true
                    if indexPath.section != 1
                    {
                        cell.txtSub.text = ""
                    }
                }
                if Global.sharedInstance.isContinuPressed == true
                {
                    if Global.sharedInstance.isFirstSectionValid == false && indexPath.section == 0 {
                        cell.lblMessageError.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        cell.lblMessageError.textColor = UIColor.red
                        Global.sharedInstance.isFirstSectionValid = true
                    }
                    else if !Global.sharedInstance.isHoursSelected.contains(true) && indexPath.section == 1
                    {
                        if Global.sharedInstance.isFirst == false
                        {
                            cell.lblMessageError.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            cell.lblMessageError.textColor = UIColor.red
                        }
                        else
                        {
                            cell.lblMessageError.textColor = UIColor.clear
                        }
                    }
                    else if !Global.sharedInstance.isValidHours && indexPath.section == 1
                    {
                        cell.lblMessageError.text = "ILLEGAL_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        cell.lblMessageError.textColor = UIColor.red
                    }
                    else if (
                        Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0
                            && indexPath.section == 3) || (Global.sharedInstance.fIsSaveConBussinesServicesPressed == false && indexPath.section == 3)
                    {
                        if Global.sharedInstance.isFirstBussinesServices == false
                        {
                            cell.lblMessageError.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            cell.lblMessageError.textColor = UIColor.red
                        }
                        else
                        {
                            cell.lblMessageError.textColor = UIColor.clear
                        }
                    }
                    else{
                        cell.lblMessageError.text = ""
                    }
                }
                else
                {
                    cell.lblMessageError.textColor = UIColor.clear
                }
                if cell.txtSub.text != ""{
                    cell.lblMessageError.textColor = UIColor.clear
                }
                if indexPath.section == 1
                {
                    if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 0 {
                        tapopen = UITapGestureRecognizer(target: self, action: #selector(self.openPopupHours))
                        tapopen.delegate = self

                        cell.addGestureRecognizer(tapopen)
                    }

                    if Global.sharedInstance.hourShow == "" && Global.sharedInstance.hourShowRecess == ""
                    {
                        cell.viewButtom.isHidden = false
                    }
                    else
                    {
                        cell.viewButtom.isHidden = true
                    }
                }
                else
                {
                    cell.viewButtom.isHidden = false
                }
                return cell
            //אם לחצו עליו
            default:
                if Global.sharedInstance.fSection5 == true
                {
                    Global.sharedInstance.indexPathNew = IndexPath(row: Global.sharedInstance.indexPathNew!.row, section: 5)
                }
                switch(indexPath.section)
                {
                //תחום העסק
                case(0):
                    let cell:Section2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Section2TableViewCell")as!Section2TableViewCell
                    cell.delegat = self
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.setDisplayData()
                    return cell
                case (1)://שעות פעילות

                    if Global.sharedInstance.addRecess == false//לא לחצו על הוסף הפסקות
                    {
                        if Global.sharedInstance.hourShow == "" && Global.sharedInstance.hourShowRecess == ""
                        {
                            if indexPath.row == 1
                            {
                                //שעות פעילות חדש
                                let cell:HoursActiveTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delagetReloadHeight = self
                                cell.viewBottom.isHidden = true
                                cell.dtFromHour.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .year, value: -16, to: Date(), options: [])
                                cell.dtToHour.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .year, value: -16, to: Date(), options: [])
                                Global.sharedInstance.hoursActive = cell
                                return cell
                            }
                            else
                            {
                                //סל של הפסקות
                                let cell:RecessesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delegateReloadTbl = self
                                cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                                cell.viewBottom.isHidden = false
                                return cell
                            }
                        }
                        else//צריך להציג גם את הסל של הצגת השעות שנבחרו
                        {
                            if indexPath.row == 1
                            {
                                let cell:SelectedHoursTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "SelectedHoursTableViewCell") as? SelectedHoursTableViewCell)!
                                cell.delegateReloadTbl = self
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                if Global.sharedInstance.isReturn2RowsForHours == true
                                {
                                    cell.viewBottom.isHidden = false
                                }
                                else
                                {
                                    cell.viewBottom.isHidden = true
                                }
                                cell.lineForLabels()
                                //    cell.delegateReloadTbl?.reloadHeight()
                                return cell
                            }
                            if indexPath.row == 2
                            {
                                //שעות פעילות חדש
                                let cell:HoursActiveTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delagetReloadHeight = self
                                cell.viewBottom.isHidden = true
                                cell.btnSelectAllDays.tag = 1
                                cell.dtFromHour.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .year, value: -16, to: Date(), options: [])
                                cell.dtToHour.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .year, value: -16, to: Date(), options: [])
                                Global.sharedInstance.hoursActive = cell
                                return cell
                            }
                            else
                            {
                                //סל של הפסקות
                                let cell:RecessesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delegateReloadTbl = self
                                cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                                cell.viewBottom.isHidden = false
                                return cell
                            }
                        }
                    }
                    else//לחצו על הוסף הפסקות
                    {
                        if Global.sharedInstance.hourShow == "" && Global.sharedInstance.hourShowRecess == ""
                        {
                            if indexPath.row == 1//הצגת הסל של הוסף הפסקות
                            {
                                let cell:RecessesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delegateReloadTbl = self
                                cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                                cell.viewBottom.isHidden = true
                                return cell
                            }
                            else//הצגת השעות
                            {
                                let cell:HoursActiveTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delagetReloadHeight = self
                                cell.viewBottom.isHidden = false
                                Global.sharedInstance.hoursActive = cell
                                return cell
                            }
                        }
                        else
                        {
                            if indexPath.row == 1//הצגת השעות שנבחרו
                            {
                                let cell:SelectedHoursTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "SelectedHoursTableViewCell") as? SelectedHoursTableViewCell)!
                                cell.delegateReloadTbl = self
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.viewBottom.isHidden = true
                                cell.lineForLabels()
                                cell.delegateReloadTbl?.reloadHeight()
                                return cell
                            }
                            if indexPath.row == 2//הצגת הסל של הוסף הפסקות
                            {
                                let cell:RecessesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delegateReloadTbl = self
                                cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                                cell.viewBottom.isHidden = true
                                return cell
                            }
                            else//הצגת השעות
                            {
                                let cell:HoursActiveTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delagetReloadHeight = self
                                cell.viewBottom.isHidden = false
                                Global.sharedInstance.hoursActive = cell
                                return cell
                            }
                        }
                    }
                case (2):
                    if Global.sharedInstance.isFromSave == false && Global.sharedInstance.isReloadForEdit == false
                    {
                        if indexPath.row == 1
                        {
                            let cell:ItemInSection3TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemInSection3TableViewCell")as!ItemInSection3TableViewCell
                            cell.delegateGeneric = self
                            Global.sharedInstance.cutrrentRowForAddress = indexPath.row
                            cell.delegateKbBusiness = Global.sharedInstance.businessService
                            if Global.sharedInstance.isOpenHoursForPlusAction == false && Global.sharedInstance.fromEdit == false && Global.sharedInstance.isOpenWorker == false
                            {
                                cell.setDisplayDataNull()
                                Global.sharedInstance.isSetDataNull = false
                                Global.sharedInstance.item3 = cell
                            }
                            Global.sharedInstance.itemInSection3TableViewCell = cell
                            cell.delegate = self
                            cell.delegateSave = self
                            cell.delegateScroll = self
                            cell.selectionStyle = UITableViewCell.SelectionStyle.none
                            cell.tag = indexPath.section
                            cell.indexCell = indexPath.row
                            if Global.sharedInstance.item3 != nil
                            {
                                return Global.sharedInstance.item3!
                            }
                            else//פעם ראשונה שלא שמור כלום בגלובל
                            {
                                Global.sharedInstance.item3 = cell
                                cell.setDisplayDataNull()
                                return cell
                            }
                        }
                        if Global.sharedInstance.hoursForWorker == true && Global.sharedInstance.hourShowFirstWorker == ""
                        {
                            if indexPath.row == 2{     //שעות פעילות
                                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                let cell:HoursActiveTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delagetReloadHeight = self
                                cell.viewBottom.isHidden = true
                                Global.sharedInstance.hoursActive = cell
                                return cell
                            }
                            //סל של הפסקות
                            let cell:RecessesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                            cell.selectionStyle = UITableViewCell.SelectionStyle.none
                            cell.delegateReloadTbl = self
                            cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                            cell.viewBottom.isHidden = false
                            return cell
                        }
                        else if Global.sharedInstance.hourShowFirstWorker != "" && Global.sharedInstance.hoursForWorker == true
                        {
                            if indexPath.row == 2
                            {
                                let cell:SelectedHoursTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "SelectedHoursTableViewCell") as? SelectedHoursTableViewCell)!
                                cell.delegateReloadTbl = self
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                if Global.sharedInstance.isReturn2RowsForHours == true
                                {
                                    cell.viewBottom.isHidden = false
                                }
                                else
                                {
                                    cell.viewBottom.isHidden = true
                                }
                                return cell
                            }
                            else  if indexPath.row == 3{     //שעות פעילות חדש
                                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                let cell:HoursActiveTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delagetReloadHeight = self
                                cell.viewBottom.isHidden = true
                                Global.sharedInstance.hoursActive = cell
                                return cell
                            }
                            //סל של הפסקות
                            let cell:RecessesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                            cell.selectionStyle = UITableViewCell.SelectionStyle.none
                            cell.delegateReloadTbl = self
                            cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                            cell.viewBottom.isHidden = false
                            return cell
                        }
                        else if Global.sharedInstance.recessForWorker == true
                        {
                            if indexPath.row == 2//הצגת הסל של הוסף הפסקות
                            {
                                let cell:RecessesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delegateReloadTbl = self
                                cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                                cell.viewBottom.isHidden = true
                                return cell
                            }
                            else//הצגת השעות
                            {
                                let cell:HoursActiveTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delagetReloadHeight = self
                                cell.viewBottom.isHidden = false
                                Global.sharedInstance.hoursActive = cell
                                return cell
                            }
                        }
                    }
                    else if Global.sharedInstance.isFromSave == true
                    {
                        if indexPath.row == 1{
                            Global.sharedInstance.isAddWorker = true
                            let cell:ListWorkersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListWorkersTableViewCell")as!ListWorkersTableViewCell
                            cell.delegate = self
                            cell.selectionStyle = UITableViewCell.SelectionStyle.none
                            cell.delegate = self
                            cell.setDispalyData()
                            return cell
                        }
                        else if indexPath.row == 2
                        {
                            let cell:NewWorkerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewWorkerTableViewCell")as!NewWorkerTableViewCell
                            cell.selectionStyle = UITableViewCell.SelectionStyle.none
                            cell.delegate = self
                            cell.tag = indexPath.section
                            isOpen = cell.isOpen
                            return cell
                        }
                        else if indexPath.row == 3 && isOpen == true//+
                        {
                            let cell:ItemInSection3TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemInSection3TableViewCell")as!ItemInSection3TableViewCell
                            cell.delegateGeneric = self
                            Global.sharedInstance.cutrrentRowForAddress = indexPath.row
                            cell.delegateKbBusiness = Global.sharedInstance.businessService
                            Global.sharedInstance.isOpenHoursForPlus = true
                            if Global.sharedInstance.isOpenHoursForPlusAction == false && Global.sharedInstance.fromEdit == false && Global.sharedInstance.isOpenWorker == false
                            {
                                //כדי שלא יציג את הנתונים לפי הקודם
                                cell.setDisplayDataNull()
                            }
                            Global.sharedInstance.itemInSection3TableViewCell = cell
                            Global.sharedInstance.indexForArr = -11
                            cell.delegate = self
                            cell.selectionStyle = UITableViewCell.SelectionStyle.none
                            cell.delegateSave = self
                            cell.delegateScroll = self
                            cell.tag = indexPath.section
                            Global.sharedInstance.fromEdit = false
                            Global.sharedInstance.selectedCell[indexPath.section] = true
                            Global.sharedInstance.currentEditCellOpen = indexPath.section
                            return cell
                        }
                        else if Global.sharedInstance.isOpenHoursForPlusAction == true
                        {
                            //שעות פעילות לעובד בלחיצה על פלוס
                            if Global.sharedInstance.hoursForWorkerFromPlus == true
                            {
                                if indexPath.row == 4//שעות פעילות חדש
                                {
                                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                    let cell:HoursActiveTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                    cell.delagetReloadHeight = self
                                    cell.viewBottom.isHidden = true
                                    Global.sharedInstance.hoursActive = cell
                                    return cell
                                }
                                //סל של הפסקות
                                let cell:RecessesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                cell.delegateReloadTbl = self
                                cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                                cell.viewBottom.isHidden = false
                                return cell
                            }
                            else{
                                if indexPath.row == 4//הצגת הסל של הוסף הפסקות
                                {
                                    let cell:RecessesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                    cell.delegateReloadTbl = self
                                    cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                                    cell.viewBottom.isHidden = true
                                    return cell
                                }
                                else//הצגת השעות
                                {
                                    let cell:HoursActiveTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                    cell.delagetReloadHeight = self
                                    cell.viewBottom.isHidden = false
                                    Global.sharedInstance.hoursActive = cell
                                    return cell
                                }
                            }
                        }
                    }
                    else if Global.sharedInstance.isReloadForEdit == true{
                        if indexPath.row == 1{
                        }
                    }
                case (3):
                    if Global.sharedInstance.isFromFirstSave == false{
                        let cell:BussinesServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BussinesServicesTableViewCell")as!BussinesServicesTableViewCell
                        cell.delegateKb = Global.sharedInstance.itemInSection3TableViewCell
                        cell.delegateScroll = self
                        cell.delegateSave = self
                        cell.closeCellDelegate = self
                        cell.selectionStyle = UITableViewCell.SelectionStyle.none
                        if Global.sharedInstance.isNewServicePlusOpen == false
                        {
                            cell.setDisplayDataNull()
                        }
                        cell.tag = indexPath.section
                        return cell
                    }
                    if indexPath.row == 1{
                        let cell:ListServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListServicesTableViewCell")as!ListServicesTableViewCell
                        cell.delegate = self
                        cell.selectionStyle = UITableViewCell.SelectionStyle.none
                        cell.setDisplayData()
                        cell.tag = indexPath.section
                        return cell
                    }
                    else if indexPath.row == 2{
                        let cell:AddNewServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddNewServiceTableViewCell")as!AddNewServiceTableViewCell
                        cell.selectionStyle = UITableViewCell.SelectionStyle.none
                        cell.delegate = self
                        // cell.delegate = self
                        cell.tag = indexPath.section
                        return cell
                    }
                    else//מלחיצה על פלוס
                    {
                        if indexPath.row == 0 {
                            //\\print(  "waaa")
                        }
                        let cell:BussinesServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BussinesServicesTableViewCell")as!BussinesServicesTableViewCell
                        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                        if Global.sharedInstance.isNewServicePlusOpen == false
                        {
                            cell.setDisplayDataNull()
                        }
                        cell.txtPrice.tag = -11
                        cell.tag = -20
                        cell.delegateKb = Global.sharedInstance.itemInSection3TableViewCell
                        cell.delegateSave = self
                        cell.delegateScroll = self
                        cell.closeCellDelegate = self
                        cell.selectionStyle = UITableViewCell.SelectionStyle.none
                        //cell.tag = indexPath.section
                        Global.sharedInstance.currentEditCellOpen = indexPath.section
                        cell.setindexPathnumber(_myindexrow: 1) //just because
                        return cell
                    }
                case (4):
                    let cell:CalenderSettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CalenderSettingTableViewCell")as!CalenderSettingTableViewCell
                    Global.sharedInstance.fromCalendar = true
                    Global.sharedInstance.businessService?.delegateKbCalendar = cell
                    Global.sharedInstance.itemInSection3TableViewCell?.delegateKbCalendar = cell
                    cell.delegateSave = self
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.tag = indexPath.section
                    cell.delegate = self
                    cell.delegateScroll = self
                    cell.delegateKb = Global.sharedInstance.itemInSection3TableViewCell
                    cell.delegateKbBusiness = Global.sharedInstance.businessService
                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)

                    if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 0 {
                        Global.sharedInstance.isSelected = true
                  } else
                        if Global.sharedInstance.generalDetails.calendarProperties.bLimitSeries == false {
                            Global.sharedInstance.isSelected = false
                        } else {
                            Global.sharedInstance.isSelected = true
                    }
                    return cell
                case (5):
                    let cell:SimpleCell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell")as!SimpleCell
                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                    return cell
                default:
                    let cell:Section2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Section2TableViewCell")as!Section2TableViewCell
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.delegat = self
                    cell.setDisplayData()
                    return cell
                }
            }
        }
        else if tableView == WorkersTbl
        {
            if indexPath.row == 0
            {
                let cell:WorkerInListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WorkerInListTableViewCell")as! WorkerInListTableViewCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.tag = indexPath.section
                cell.delegate = self
                let Fname = Global.sharedInstance.generalDetails.arrObjServiceProviders[indexPath.section].objsers.nvFirstName
                let Lname =  Global.sharedInstance.generalDetails.arrObjServiceProviders[indexPath.section].objsers.nvLastName
                let name = "\(Fname) \(Lname)"

                cell.setDisplayData(name)
                if Global.sharedInstance.generalDetails.arrObjServiceProviders[indexPath.section].bSameWH == false && (Global.sharedInstance.generalDetails.arrObjServiceProviders[indexPath.section].objsers.iUserStatusType == 25 || Global.sharedInstance.generalDetails.arrObjServiceProviders[indexPath.section].objsers.iUserStatusType == 24) {
                    flags[indexPath.section] = true
                    flagsHelp[indexPath.section] = true
                }
                else
                {
                    flags[indexPath.section] = false
                    flagsHelp[indexPath.section] = false
                }
                if Global.sharedInstance.isClickNoEqual == false && Global.sharedInstance.isClickEqual == false && Global.sharedInstance.clickNoCalendar == false
                {
                    if flags[indexPath.section] == true{
                        if Global.sharedInstance.isOpenHoursForNewWorker == false
                        {
                            Global.sharedInstance.isOpenHoursForNewWorker = true
                        }
                    }
                    else
                    {
                        Global.sharedInstance.isOpenHoursForNewWorker = false
                    }
                }
                if Global.sharedInstance.ifOpenCell == false{ Global.sharedInstance.fromEdit = false
                }
                return cell
            }
            else if indexPath.row == 1//מעריכה
            {
                let cell:ItemInSection3TableViewCell = extTbl.dequeueReusableCell(withIdentifier: "ItemInSection3TableViewCell")as!ItemInSection3TableViewCell
                cell.delegateGeneric = self
                Global.sharedInstance.cutrrentRowForAddress = indexPath.row
                Global.sharedInstance.fromEdit = true
                Global.sharedInstance.itemInSection3TableViewCell = cell
                Global.sharedInstance.indexForArr = indexPath.section
                cell.delegateKbBusiness = Global.sharedInstance.businessService
                cell.delegate = self
                cell.delegateZeroMaxMin = Global.sharedInstance.hoursActive
                Global.sharedInstance.isOwner = false
                cell.delegateSave = self
                cell.delegateScroll = self
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                if Global.sharedInstance.defaults.integer(forKey: "firsttimecell") == 0 {
                    if Global.sharedInstance.generalDetails.arrObjServiceProviders[indexPath.section].bSameWH == false {
                        Global.sharedInstance.isClickNoEqual = true
                        Global.sharedInstance.isClickEqual = false
                    } else {
                        Global.sharedInstance.isClickNoEqual = false
                        Global.sharedInstance.isClickEqual = true
                    }
                }
                cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjServiceProviders[indexPath.section].objsers,bsameW: Global.sharedInstance.generalDetails.arrObjServiceProviders[indexPath.section].bSameWH)
                cell.tag = -30
                let index = IndexPath(row: 1, section: 2)
                if Global.sharedInstance.addRecess == false
                {
                    extTbl.scrollToRow(at: index, at: UITableView.ScrollPosition.top, animated: true)
                }
                Global.sharedInstance.currentEditCellOpen = 2
                Global.sharedInstance.selectedCell[2] = true
                return cell
            }
            //--------------------------------
            if Global.sharedInstance.hoursForWorkerFromEdit == true
            {
                if indexPath.row == 2
                {
                    //שעות פעילות חדש
                    let cell:HoursActiveTableViewCell = (extTbl.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.delagetReloadHeight = self
                    cell.viewBottom.isHidden = true
                    Global.sharedInstance.hoursActive = cell
                    return cell
                }
                else
                {
                    //סל של הפסקות
                    let cell:RecessesTableViewCell = (extTbl.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.viewBottom.isHidden = true
                    cell.delegateReloadTbl = self
                    cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                    return cell
                }
            }
            else if Global.sharedInstance.recessForWorkerFromEdit == true
            {
                if indexPath.row == 2
                {
                    //סל של הפסקות
                    let cell:RecessesTableViewCell = (extTbl.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.viewBottom.isHidden = true
                    cell.delegateReloadTbl = self
                    cell.delgateEnabledDays = Global.sharedInstance.hoursActive
                    return cell
                }
                else
                {
                    //שעות פעילות חדש
                    let cell:HoursActiveTableViewCell = (extTbl.dequeueReusableCell(withIdentifier: "HoursActiveTableViewCell") as? HoursActiveTableViewCell)!
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.delagetReloadHeight = self
                    cell.viewBottom.isHidden = true
                    Global.sharedInstance.hoursActive = cell
                    return cell
                }
            }
            let cell:RecessesTableViewCell = (extTbl.dequeueReusableCell(withIdentifier: "RecessesTableViewCell") as? RecessesTableViewCell)!
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.viewBottom.isHidden = true
            cell.delegateReloadTbl = self
            cell.delgateEnabledDays = Global.sharedInstance.hoursActive
            return cell
        }
        else
        {
            if indexPath.row == 0
            {
                let cell:ServiceInListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ServiceInListTableViewCell")as! ServiceInListTableViewCell
                cell.delegate = self
                cell.tag = indexPath.section
                cell.setDispalyData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.section].nvServiceName)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
            else//מעריכה
            {
                let cell:BussinesServicesTableViewCell = extTbl.dequeueReusableCell(withIdentifier: "BussinesServicesTableViewCell")as!BussinesServicesTableViewCell
                cell.delegateKb = Global.sharedInstance.itemInSection3TableViewCell
                cell.delegateSave = self
                cell.delegateScroll = self
                cell.closeCellDelegate = self
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.section])
                cell.tag = indexPath.section
                cell.txtPrice.tag = indexPath.section
                ////////////////////////
                Global.sharedInstance.currentEditCellOpen = 3
                Global.sharedInstance.selectedCell[3] = true
                ////////////////////////
                let index = IndexPath(row: 1, section: 3)
                extTbl.scrollToRow(at: index, at: UITableView.ScrollPosition.top, animated: true)
                return cell
            }
        }
        if isupdate == false {
            let cell:ServiceInListTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "ServiceInListTableViewCell")as! ServiceInListTableViewCell

            cell.setDispalyData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.section].nvServiceName)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            return cell
        } else {
            let cellx = UITableViewCell()
            return cellx
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        if indexPath.row == 0
        {

            if Global.sharedInstance.selectedCell[indexPath.section] == true{//האם הלחיצה היא בשביל סגירה צריך להפעיל בדיקות תקינות ובמידה שזה תקין לבצע שמירה
                switch indexPath.section {
                case 0:
                    if indexPath.row == 0
                    {
                        if indexPath.section != 2{
                            if Global.sharedInstance.selectedCell[indexPath.section] == false
                            {
                                if indexPath.section == 0
                                {
                                    if AppDelegate.arrDomains.count > 0
                                    {
                                        Global.sharedInstance.selectedCell[indexPath.section] = true
                                    }
                                }
                                else
                                {
                                    Global.sharedInstance.selectedCell[indexPath.section] = true
                                }
                            }
                            else
                            {
                                Global.sharedInstance.selectedCell[indexPath.section] = false
                                if Global.sharedInstance.currentEditCellOpen == indexPath.section
                                {
                                    Global.sharedInstance.currentEditCellOpen = -1
                                }
                            }
                            tableView.reloadData()
                            if Global.sharedInstance.selectedCell[indexPath.section] == true
                            {
                                Global.sharedInstance.fSection5 = true
                                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                            }
                        }
                        else{
                            if Global.sharedInstance.selectedCell[indexPath.section] == false
                            {
                                if indexPath.section != 2{
                                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                    Global.sharedInstance.selectedCell[indexPath.section] = true
                                }
                                else{
                                    if Global.sharedInstance.isFromSave == false{
                                        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                        Global.sharedInstance.selectedCell[indexPath.section] = true
                                    }
                                }
                            }
                            else
                            {
                                Global.sharedInstance.selectedCell[indexPath.section] = false
                                Global.sharedInstance.isOpenHours = false
                                AppDelegate.isBtnCheck = true
                            }
                            tableView.reloadData()
                            if Global.sharedInstance.selectedCell[indexPath.section] == true
                            {
                                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                            }
                        }
                    }

                case 1:///שעות פעילות
                    //שמירת הנתונים בגלובל שיהיו מוכנים לשליחה לשרת
                    //iustin

                    //                                if self.attemptsToOpenActiveHoursCount == 0
                    //                                {
                    ////                                    DispatchQueue.main.async
                    ////                                    {
                    //
                    //                                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    //                                    self.popUpWorkingHours = storyboardtest.instantiateViewController(withIdentifier: "PopUpWorkingHours") as! PopUpWorkingHours
                    //                                    self.present(self.popUpWorkingHours, animated: true, completion: nil)
                    //                                    self.attemptsToOpenActiveHoursCount += 1
                    //                                  //  }
                    //                                }

                    var workingHours:objWorkingHours = objWorkingHours()
                    Global.sharedInstance.generalDetails.arrObjWorkingHours = Array<objWorkingHours>()
                    //עובר על השעות של כל הימים בשבוע של הספק
                    for i in 0 ..< Global.sharedInstance.arrWorkHours.count {
                        //יש הפסקות
                        if Global.sharedInstance.isHoursSelectedRest[i]
                        {
                            Global.sharedInstance.GlobalDataVC!.delegateActiveHours?.checkValidityHours(i)
                            if Global.sharedInstance.fIsValidHours[i] == true && Global.sharedInstance.fIsValidRest[i] == true//רק אם תקין
                            {
                                //שמירת הנתונים
                                workingHours = objWorkingHours(
                                    _iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                                    _nvFromHour: Global.sharedInstance.arrWorkHours[i].nvFromHour,
                                    _nvToHour: Global.sharedInstance.arrWorkHoursRest[i].nvFromHour)
                                Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
                                //---------------------------
                                workingHours = objWorkingHours(
                                    _iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                                    _nvFromHour: Global.sharedInstance.arrWorkHoursRest[i].nvToHour,
                                    _nvToHour: Global.sharedInstance.arrWorkHours[i].nvToHour)
                                Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
                            }
                        }
                        else //אין הפסקות
                        {
                            print("i \(i)")

                            Global.sharedInstance.GlobalDataVC!.delegateActiveHours?.checkValidityHours(i)
                            if Global.sharedInstance.fIsValidHours[i] == true
                            {
                                workingHours = objWorkingHours(
                                    _iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                                    _nvFromHour: Global.sharedInstance.arrWorkHours[i].nvFromHour,
                                    _nvToHour: Global.sharedInstance.arrWorkHours[i].nvToHour)
                                if Global.sharedInstance.isHoursSelected[i] == true
                                {
                                    Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
                                }
                            }
                        }
                    }
                    //עובר על כל השעות ובודק האם יש יום שהשעות לא חוקיות
//                    var isBreak = false
//                    for bool in Global.sharedInstance.fIsValidHours
//                    {
//                        if bool == false
//                        {
//                            Global.sharedInstance.isValidHours = false
//                            isBreak = true
//                            break
//                        }
//                    }
//                    if Global.sharedInstance.isValidHours == false
//                        && isBreak == true
//                    {
//
//                    }
//                    else
//                    {
//                        Global.sharedInstance.isValidHours = true
//                    }
                    Global.sharedInstance.isValidHours = false
                    for bool in Global.sharedInstance.fIsValidHours
                    {
                        if bool == true
                        {
                            Global.sharedInstance.isValidHours = true

                            break
                        }

                    }

                    
                    
                    Global.sharedInstance.selectedCell[indexPath.section] = false
                    if Global.sharedInstance.addRecess != false//אם פתחו בכלל את ההפסקות ויש צורך להפעיל(גם כדי למנוע קריסה)
                    {
                        Global.sharedInstance.GlobalDataVC!.delegateEnabledBtnDays.enabledTrueBtnDays()
                    }
                    Global.sharedInstance.addRecess = false
                    if indexPath.section == Global.sharedInstance.currentEditCellOpen
                    {
                        Global.sharedInstance.currentEditCellOpen = -1//הכל סגור
                    }
                    for  item in Global.sharedInstance.fIsValidHours
                    {
                        if item == true{
                            Global.sharedInstance.isHoursSelectedItem = true
                        }
                    }
                    extTbl.reloadData()

                    //                if self.attemptsToOpenActiveHoursCount == 0
                    //                {
                    //                    DispatchQueue.main.async
                    //                        {
                    //
                    //                            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    //                            self.popUpWorkingHours = storyboardtest.instantiateViewController(withIdentifier: "PopUpWorkingHours") as! PopUpWorkingHours
                    //                            self.present(self.popUpWorkingHours, animated: true, completion: nil)
                    //                            self.attemptsToOpenActiveHoursCount += 1
                    //                    }
                    //                }

                case 2:
                    //     print("delegateSaveWorker.saveDataToWorker \(delegateSaveWorker?.saveDataToWorker())")
                    if  (delegateSaveWorker?.saveDataToWorker() == true || delegateSaveWorker?.saveDataToWorker() == nil ) && Global.sharedInstance.fisValidWorker == true{
                        if indexPath.row == 0
                        {
                            if indexPath.section != 2{
                                if Global.sharedInstance.selectedCell[indexPath.section] == false
                                {
                                    if indexPath.section == 0
                                    {
                                        if AppDelegate.arrDomains.count > 0
                                        {
                                            Global.sharedInstance.selectedCell[indexPath.section] = true
                                        }
                                    }
                                    else
                                    {
                                        Global.sharedInstance.selectedCell[indexPath.section] = true
                                    }
                                }
                                else
                                {
                                    Global.sharedInstance.selectedCell[indexPath.section] = false
                                }
                                tableView.reloadData()
                                if Global.sharedInstance.selectedCell[indexPath.section] == true
                                {
                                    Global.sharedInstance.fSection5 = true
                                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                }
                            }
                            else
                            {
                                if Global.sharedInstance.selectedCell[indexPath.section] == false
                                {
                                    if indexPath.section != 2{
                                        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                        Global.sharedInstance.selectedCell[indexPath.section] = true
                                    }
                                    else
                                    {
                                        Global.sharedInstance.isServiceProviderEditOpen = false
                                        if Global.sharedInstance.isFromSave == false
                                        {
                                            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                            Global.sharedInstance.selectedCell[indexPath.section] = true
                                        }
                                        else
                                        {
                                            Global.sharedInstance.currentEditCellOpen = -1
                                            Global.sharedInstance.isOpenWorker = false
                                            if Global.sharedInstance.isFromSave == true
                                            {
                                                if selectedCellForEdit.contains(true)//אם יש עובד הפתוח בעריכה
                                                {
                                                    Global.sharedInstance.hoursForWorkerFromEdit = false
                                                    for i in 0 ..< selectedCellForEdit.count{
                                                        if selectedCellForEdit[i] == true
                                                        {
                                                            let index:IndexPath = IndexPath(row: 0, section: i)
                                                            let cellMy = (WorkersTbl.cellForRow(at: index) as! WorkerInListTableViewCell)
                                                            cellMy.isOpen = false
                                                            cellMy.isEdit = 0
                                                            selectedCellForEdit[i] = false
                                                            if Global.sharedInstance.countCellEditOpen > 0{
                                                                Global.sharedInstance.countCellEditOpen -= 1
                                                            }
                                                            Global.sharedInstance.ifOpenCell = false
                                                            Global.sharedInstance.currentEditCellOpen = -1
                                                            Global.sharedInstance.selectedCell[2] = false
                                                            if flags[i] == true{
                                                                if Global.sharedInstance.countCellHoursOpenFromEdit > 0{
                                                                    Global.sharedInstance.countCellHoursOpenFromEdit = 0
                                                                }
                                                                Global.sharedInstance.isOpenHoursForNewWorker = false
                                                            }
                                                            break
                                                            selectedCellForEdit[i] = false
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    let index:IndexPath = IndexPath(row: 2, section: 2)
                                                    if extTbl.cellForRow(at: index) != nil
                                                    {
                                                        (extTbl.cellForRow(at: index) as! NewWorkerTableViewCell).isOpen = false
                                                        Global.sharedInstance.isOpenNewWorker = false
                                                        Global.sharedInstance.isOpenHoursForPlusAction = false
                                                        Global.sharedInstance.currentEditCellOpen = -1
                                                        Global.sharedInstance.selectedCell[indexPath.section] = false
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    Global.sharedInstance.selectedCell[indexPath.section] = false
                                    Global.sharedInstance.isOpenHours = false
                                    AppDelegate.isBtnCheck = true
                                }
                                tableView.reloadData()
                                if Global.sharedInstance.selectedCell[indexPath.section] == true
                                {
                                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                }
                            }
                        }
                    }
                    else
                    {
                        Global.sharedInstance.selectedCell[indexPath.section] = false
                        if Global.sharedInstance.currentEditCellOpen == indexPath.section
                        { Global.sharedInstance.isOpenHours = false
                            Global.sharedInstance.isOpenHoursForPlusAction = false
                            Global.sharedInstance.isOpenWorker = false
                            Global.sharedInstance.isOpenNewWorker = false
                            newWorkerIsClose = true
                            Global.sharedInstance.currentEditCellOpen = -1
                            Global.sharedInstance.isValidWorkerDetails = true
                        }
                        if Global.sharedInstance.generalDetails.arrObjServiceProviders.count == 0
                        {
                            Global.sharedInstance.isFromSave = false
                        }
                        extTbl.reloadData()
                    }
                case 3:
                    print("g delegateSaveBussines.saveDataToWorker \(delegateSaveBussines?.saveDataToWorker())")
                    if    Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
                        print("Global.sharedInstance.currentEditCellOpen\(Global.sharedInstance.currentEditCellOpen)")
                        if indexPath.section == Global.sharedInstance.currentEditCellOpen
                        {
                            Global.sharedInstance.currentEditCellOpen = -1//הכל סגור
                            if Global.sharedInstance.generalDetails.arrObjProviderServices.count > 0 {
                                Global.sharedInstance.isFromFirstSave = true }
                            else {
                                Global.sharedInstance.isFromFirstSave = false
                            }
                            // Global.sharedInstance.isFromFirstSave = false
                            //                            var estesaunu:Bool = false
                            //                            estesaunu =  Global.sharedInstance.selectedCell[indexPath.section]
                            //                            estesaunu = !estesaunu
                            //                            Global.sharedInstance.selectedCell[indexPath.section] = estesaunu
                            //
                        } else {
                            Global.sharedInstance.selectedCell[indexPath.section] = true
                            Global.sharedInstance.currentEditCellOpen = indexPath.section
                            if Global.sharedInstance.generalDetails.arrObjProviderServices.count > 0 {
                                Global.sharedInstance.isFromFirstSave = true }
                            else {
                                Global.sharedInstance.isFromFirstSave = false
                            }
                        }
                        extTbl.reloadData()
                        tableView.reloadData()
                        //    return
                    }
                    if delegateSaveBussines?.saveDataToWorker() == true{
                        Global.sharedInstance.currentEditCellOpen = -1
                        if indexPath.row == 0
                        {
                            if indexPath.section != 2{
                                if Global.sharedInstance.selectedCell[indexPath.section] == false
                                {
                                    if indexPath.section == 0
                                    {
                                        if AppDelegate.arrDomains.count > 0
                                        {
                                            Global.sharedInstance.selectedCell[indexPath.section] = true
                                        }
                                    }
                                    else{
                                        Global.sharedInstance.selectedCell[indexPath.section] = true
                                        //}
                                    }
                                }
                                else
                                {
                                    if Global.sharedInstance.currentEditCellOpen == indexPath.section//אם סגרתי את עריכת מוצר בשדה שרותים או מוצרים - בעצמו.
                                    {
                                        Global.sharedInstance.currentEditCellOpen = -1
                                        Global.sharedInstance.isNewServicePlusOpen = false
                                    }
                                    if Global.sharedInstance.selectedCellForEditService.contains(true)//אם יש שרות הפתוח בעריכה
                                    {
                                        for i in 0 ..< Global.sharedInstance.selectedCellForEditService.count{//מחפש את הסל שבעריכה וסוגר אותו
                                            if Global.sharedInstance.selectedCellForEditService[i] == true{
                                                if delegateSaveBussines.saveDataToWorker() == true{
                                                    let index:IndexPath = IndexPath(row: 0, section: i)
                                                    let cellMy = ServicesTbl.cellForRow(at: index) as! ServiceInListTableViewCell
                                                    cellMy.isOpen = false
                                                    cellMy.isEdit = 0
                                                    Global.sharedInstance.selectedCellForEditService[i] = false
                                                    Global.sharedInstance.isFromEditService = false
                                                    Global.sharedInstance.currentEditCellOpen = -1
                                                    Global.sharedInstance.selectedCell[3] = false
                                                    if AppDelegate.countCellEditOpenService > 0{
                                                        AppDelegate.countCellEditOpenService -= 1
                                                    }
                                                    break
                                                }
                                            }
                                        }
                                    }
                                    Global.sharedInstance.selectedCell[indexPath.section] = false
                                    Global.sharedInstance.isNewServicePlusOpen = false
                                }
                                tableView.reloadData()
                                if Global.sharedInstance.selectedCell[indexPath.section] == true
                                {
                                    Global.sharedInstance.fSection5 = true
                                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                }
                            }
                            else
                            {
                                if Global.sharedInstance.selectedCell[indexPath.section] == false
                                {
                                    if indexPath.section != 2{
                                        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                        Global.sharedInstance.selectedCell[indexPath.section] = true
                                    }
                                    else{
                                        if Global.sharedInstance.isFromSave == false{
                                            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                            Global.sharedInstance.selectedCell[indexPath.section] = true
                                        }
                                    }
                                }
                                else
                                {
                                    Global.sharedInstance.selectedCell[indexPath.section] = false
                                    Global.sharedInstance.isOpenHours = false
                                    AppDelegate.isBtnCheck = true
                                }
                                tableView.reloadData()
                                if Global.sharedInstance.selectedCell[indexPath.section] == true
                                {
                                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                }
                            }
                        }
                    }
                    else
                    {
                        Global.sharedInstance.selectedCell[indexPath.section] = false
                        if Global.sharedInstance.currentEditCellOpen == indexPath.section
                        {
                            Global.sharedInstance.isNewServicePlusOpen = false
                            Global.sharedInstance.currentEditCellOpen = -1
                        }
                        if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0
                        {
                            extTbl.reloadData()
                        }
                    }
                case 4:
                    if delegateSaveCalendar.saveDataToWorker() == true {
                        if indexPath.row == 0
                        {
                            if indexPath.section != 2{
                                if Global.sharedInstance.selectedCell[indexPath.section] == false
                                {
                                    if indexPath.section == 0
                                    {
                                        if AppDelegate.arrDomains.count > 0
                                        {
                                            Global.sharedInstance.selectedCell[indexPath.section] = true
                                        }
                                    }
                                    else{
                                        if indexPath.section != 4{//לא יודעת למה השורה הזו מה שקרה שהוא הגיע כפולס ולכן הוא תמיד נכנס לפה לכן כתבתי שונה מארבע סוג של עקיפה אבל יש פה בעיה
                                            Global.sharedInstance.selectedCell[indexPath.section] = true
                                        }
                                    }
                                }
                                else
                                {
                                    Global.sharedInstance.selectedCell[indexPath.section] = false
                                }
                                tableView.reloadData()
                                if Global.sharedInstance.selectedCell[indexPath.section] == true {
                                    Global.sharedInstance.fSection5 = true
                                    //      tableView.reloadData()
                                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                }
                            }
                            else{
                                if Global.sharedInstance.selectedCell[indexPath.section] == false
                                {
                                    if indexPath.section != 2{
                                        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                        Global.sharedInstance.selectedCell[indexPath.section] = true
                                    }
                                    else{
                                        if Global.sharedInstance.isFromSave == false{
                                            if indexPath.section != 4{
                                                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                            }
                                            Global.sharedInstance.selectedCell[indexPath.section] = true
                                        }
                                    }
                                }
                                else
                                {
                                    Global.sharedInstance.selectedCell[indexPath.section] = false
                                    Global.sharedInstance.isOpenHours = false
                                    AppDelegate.isBtnCheck = true
                                }
                                tableView.reloadData()
                                if Global.sharedInstance.selectedCell[indexPath.section] == true
                                {
                                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                                }
                            }
                        }
                        if Global.sharedInstance.currentEditCellOpen == indexPath.section
                        {
                            Global.sharedInstance.currentEditCellOpen = -1
                        }
                    } else {
                        Global.sharedInstance.selectedCell[indexPath.section] = false
                        Global.sharedInstance.fSection5 = false
                        if Global.sharedInstance.currentEditCellOpen == indexPath.section
                        {
                            Global.sharedInstance.currentEditCellOpen = -1
                        }
                         tableView.reloadData()
                    }
                default:
                    return
                }
            }
            else{//אם זה true-הלחיצה בשביל פתיחה
                if Global.sharedInstance.currentEditCellOpen != -1
                {
                    closeCellFromOtherCell()
                }
                if  Global.sharedInstance.currentEditCellOpen != indexPath.section && (Global.sharedInstance.currentEditCellOpen == -1 || Global.sharedInstance.selectedCell[Global.sharedInstance.currentEditCellOpen] == false)
                {
                    if indexPath.row == 0
                    {
                        if Global.sharedInstance.selectedCell[indexPath.section] == false
                        {
                            if indexPath.section == 0//תחום
                            {
                                if AppDelegate.arrDomains.count > 0
                                {
                                    Global.sharedInstance.currentEditCellOpen = indexPath.section
                                    Global.sharedInstance.selectedCell[indexPath.section] = true
                                }
                            }
                            else if indexPath.section == 1//שעות פעילות
                            {
                                Global.sharedInstance.currentEditCellOpen = indexPath.section
                                Global.sharedInstance.selectedCell[indexPath.section] = true
                                Global.sharedInstance.onOpenTimeOpenHours = true
                            }
                            else
                            {
                                if Global.sharedInstance.isFromSave == true && indexPath.section == 2//  אם כבר נוסף עובד
                                {
                                    Global.sharedInstance.currentEditCellOpen = -1
                                    Global.sharedInstance.selectedCell[indexPath.section] = false
                                }
                                else if Global.sharedInstance.generalDetails.arrObjProviderServices.count != 0  && indexPath.section == 3//אם כבר נוסף שרות
                                {
                                    Global.sharedInstance.currentEditCellOpen = -1
                                    Global.sharedInstance.selectedCell[indexPath.section] = false
                                }
                                else
                                {
                                    //להוסיף בדיקה
                                    Global.sharedInstance.currentEditCellOpen = indexPath.section
                                    Global.sharedInstance.selectedCell[indexPath.section] = true
                                }
                            }
                        }
                        else
                        {
                            Global.sharedInstance.selectedCell[indexPath.section] = false
                        }
                        tableView.reloadData()
                        if Global.sharedInstance.selectedCell[indexPath.section] == true {
                            Global.sharedInstance.fSection5 = true
                            //      tableView.reloadData()
                            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                        }
                    }
                }
                else if Global.sharedInstance.currentEditCellOpen == indexPath.section
                {
                    Global.sharedInstance.currentEditCellOpen = -1
                    extTbl.reloadData()
                }
            }
        }

        switch (tableView)
        {
        case extTbl: break
        default: return
        }
    }
    //        func tableView(tableView: UITableView,
    //                       heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //        {
    //
    //            return UITableViewAutomaticDimension
    //        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var font = UIFont()
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            font = UIFont(name: "OpenSansHebrew-Bold", size: 15)!
            font = UIFont(name: "OpenSansHebrew-Bold", size: 15)!
        } else {
            font = UIFont(name: "OpenSansHebrew-Bold", size: 17)!
            font = UIFont(name: "OpenSansHebrew-Bold", size: 17)!
        }
        let labeltoshow:UILabel = UILabel()
        let labeltoshowrecess:UILabel = UILabel()
        labeltoshow.font = font
        labeltoshowrecess.font = font

        if tableView == extTbl
        {
            switch (indexPath.section)
            {
            /// 0. business type 1.business h working h 2. employes 3.services 4. appoinment settings
            case 0:
                // BUSINESS TYPE
                if indexPath.row != 0
                {
                    return view.frame.size.height * 0.5111
                }
            //BUSINESS WORKING AND BREAKS HOURS
            case 1:
                return 0
//                print("oooooo  \( Global.sharedInstance.hourShow) aaaaa  \(Global.sharedInstance.hourShowRecess)")
//
//                if Global.sharedInstance.addRecess == false     //no click on add breaks
//                {
//                    if Global.sharedInstance.hourShow == "" && Global.sharedInstance.hourShowRecess == ""   //no hours selected at all
//
//                    {
//                        if indexPath.row == 1   //  display the picker
//                        {
//                            // return view.frame.size.height * 0.70
//                            return 416
//                        }
//                        else if indexPath.row == 2  // button add breaks
//                        {
//                            return  50
//                        }
//                    }
//                    else    //working hours
//                    {
//                        if indexPath.row == 1   //Displays the label of the selected hours
//                        {
//                            if Global.sharedInstance.GlobalDataVC!.delegateLineForLabel != nil
//                            {
//                                Global.sharedInstance.GlobalDataVC!.delegateLineForLabel.lineForLabels()
//                            }
//
//                            if Global.sharedInstance.hourShowRecess == ""   // we have only working hours selected no pauses
//                            {
//                                //       return view.frame.size.height * 0.04 * CGFloat(Global.sharedInstance.numbersOfLineInLblHours)
//                                let height1 = heightForView(Global.sharedInstance.hourShow, font: font, width: self.view.frame.size.width - 20)
//                                let height2 = heightForView(Global.sharedInstance.hourShowRecess, font: font, width: self.view.frame.size.width - 20)
//                                return height1 + height2 + 25
//                            }
//                            else    //both working and breaks are selected
//                            {
//                                //on enter in screen see if we have both texts hourShow hourShowRecess
//                                print("Global.sharedInstance.numbersOfLineInLblHours \(Global.sharedInstance.numbersOfLineInLblHours)")
//                                print("Global.sharedInstance.numbersOfLineInLblRest \(Global.sharedInstance.numbersOfLineInLblRest)")
//                                let height1 = heightForView(Global.sharedInstance.hourShow, font: font, width: self.view.frame.size.width - 20)
//                                let height2 = heightForView(Global.sharedInstance.hourShowRecess, font: font, width: self.view.frame.size.width - 20)
//                                return height1 + height2 + 25
//                                //   return view.frame.size.height * 0.0875 * (CGFloat(Global.sharedInstance.numbersOfLineInLblHours) + CGFloat(Global.sharedInstance.numbersOfLineInLblRest))
//                            }
//                        }
//                        if indexPath.row == 2   //show picker
//                        {
//                            //   return view.frame.size.height * 0.70
//                            return 416
//                        }
//                        else if indexPath.row == 3  //button add breaks
//                        {
//                            return  50
//
//                        }
//                    }
//                }
//                else    // click on add recesses
//                {
//                    if Global.sharedInstance.hourShow == "" && Global.sharedInstance.hourShowRecess == ""
//                    {
//                        if indexPath.row == 1  //button add breaks
//                        {
//                            return 0
//                        }
//                        else if indexPath.row == 2  //show picker
//                        {
//                            //  return view.frame.size.height * 0.70
//                            return 416
//                        }
//                    }
//                    else
//                    {
//                        if Global.sharedInstance.GlobalDataVC!.delegateLineForLabel != nil
//                        {
//                            Global.sharedInstance.GlobalDataVC!.delegateLineForLabel.lineForLabels()
//                        }
//
//                        if indexPath.row == 1       //selected hours
//                        {
//                            //                            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
//                            //                            {
//                            //                                return view.frame.size.height *  0.04 * (CGFloat(Global.sharedInstance.numbersOfLineInLblHours) + CGFloat(Global.sharedInstance.numbersOfLineInLblRest))
//                            //                            }
//
//                            //       return view.frame.size.height * 0.0575 * (CGFloat(Global.sharedInstance.numbersOfLineInLblHours) + CGFloat(Global.sharedInstance.numbersOfLineInLblRest))
//                            let height1 = heightForView(Global.sharedInstance.hourShow, font: font, width: self.view.frame.size.width - 20)
//                            let height2 = heightForView(Global.sharedInstance.hourShowRecess, font: font, width: self.view.frame.size.width - 20)
//                            return height1 + height2 + 25
//                        }
//                        else if indexPath.row == 2// button add breaks
//                        {
//                            return 0
//                        }
//                        else if indexPath.row == 3 ////show picker
//                        {
//                            //                            return view.frame.size.height * 0.70
//                            return 416
//                        }
//                    }
//                }
            case 2:
                /// HERE IS A WRONG CALCULATION OR THIS
               // COMMENTED OUT ON 26.07.2018 HIDE ADD EMPLOYE
                 if Global.sharedInstance.isFromSave == true && Global.sharedInstance.isOpenNewWorker == false
                 {
                 if indexPath.row == 0 {
                 return Global.sharedInstance.heightForCell
                 }
                 else if indexPath.row == 1
                 {
                 if Global.sharedInstance.ifOpenCell == false && Global.sharedInstance.countCellEditOpen == 0
                 {
                 //simple worker
                 return view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjServiceProviders.count)
                 }
                 let acalculate =   (view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjServiceProviders.count)) + (view.frame.size.height * 0.69 * CGFloat(Global.sharedInstance.countCellEditOpen)) //+   (Global.sharedInstance.heightForCell * CGFloat(Global.sharedInstance.countCellEditOpen))//בגלל שביטלו את השמור והמשך צריך לא לחשבן את הגובה של הסל הזה

                 let calculate =   (CGFloat( Global.sharedInstance.countCellHoursOpenFromEdit) * view.frame.size.height * 0.9375 - (Global.sharedInstance.heightForCell * CGFloat(Global.sharedInstance.countCellHoursOpenFromEdit)))

                 if (flagsHelp.contains(true) && Global.sharedInstance.isOpenHoursForNewWorker == true) || Global.sharedInstance.isClickNoEqual == true{
                 return acalculate + calculate + view.frame.size.height * 0.08//כדי להקטין את הגודל
                 }
                 return acalculate + calculate
                 }

                 else if indexPath.row == 2{
                 return view.frame.size.height * 0.09
                 }

                 return Global.sharedInstance.heightForCell * CGFloat(Global.sharedInstance.generalDetails.arrObjServiceProviders.count)
                 }
                 /////// PLUS WAS SELECTED
                 //
                 if Global.sharedInstance.isOpenNewWorker == true
                 {
                 //This is header in big table
                 if indexPath.row == 0 {
                 return Global.sharedInstance.heightForCell
                 }
                 else if indexPath.row == 1{
                 //HERE IS EXISTING EMPLOYES LIST
                 if Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 5{
                 return view.frame.size.height * 0.45
                 }
                 return view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjServiceProviders.count)

                 }
                 else  if indexPath.row == 2
                 {
                 //here is row  ADD EMPLOYE
                 return view.frame.size.height * 0.09

                 }
                 else  if indexPath.row == 3
                 {
                 //ROW WITH NAME EMAIL PHONE
                 return view.frame.size.height * 0.75
                 }
                 else if Global.sharedInstance.isOpenHoursForPlusAction == false{
                 return Global.sharedInstance.heightForCell
                 }

                 // BUTTON ADD BREAKS
                 else if indexPath.row == 5 && Global.sharedInstance.hoursForWorkerFromPlus == true{
                 return 50

                 }
                 //ROW WITH  WORKING HOURS FOR NEW WORKER
                 else if Global.sharedInstance.hoursForWorkerFromPlus
                 {
                 if Global.sharedInstance.hourShowChild == "" && Global.sharedInstance.hourShowRecessChild == ""   { //no working breaks hours selected
                 return 416 }
                 else {
                 //                            let height1 = heightForView(Global.sharedInstance.hourShowChild, font: font, width: self.view.frame.size.width - 20)
                 //                            let height2 = heightForView(Global.sharedInstance.hourShowRecessChild, font: font, width: self.view.frame.size.width - 20)
                 //                            labeltoshow.text = Global.sharedInstance.hourShowChild
                 //                            labeltoshow.frame = CGRectMake(0,0, self.view.frame.size.width - 20, height1)
                 //                            let nrlines1:Int = 8 * lineCountForLabel(labeltoshow)
                 //                            labeltoshowrecess.text = Global.sharedInstance.hourShowRecessChild
                 //                            labeltoshowrecess.frame = CGRectMake(0,0, self.view.frame.size.width - 20, height2)
                 //                            let nrlines2:Int = 8 * lineCountForLabel(labeltoshowrecess)
                 //                            let subtotal:CGFloat = CGFloat(nrlines1) + CGFloat(nrlines2)
                 //                            return  height1 + height2  + 416 + subtotal // with picker
                 return view.frame.size.height * 0.85
                 }
                 }
                 //ROW WITH  BREAKS  FOR NEW WORKER
                 else if indexPath.row == 5 && Global.sharedInstance.recessForWorkerFromPlus == true{
                 // return view.frame.size.height * 0.65
                 if Global.sharedInstance.hourShowChild == "" && Global.sharedInstance.hourShowRecessChild == ""   { //no working breaks hours selected
                 return 416 }
                 else {
                 //                            let height1 = heightForView(Global.sharedInstance.hourShowChild, font: font, width: self.view.frame.size.width - 20)
                 //                            let height2 = heightForView(Global.sharedInstance.hourShowRecessChild, font: font, width: self.view.frame.size.width - 20)
                 //                            labeltoshow.text = Global.sharedInstance.hourShowChild
                 //                            labeltoshow.frame = CGRectMake(0,0, self.view.frame.size.width - 20, height1)
                 //                            let nrlines1:Int = 8 * lineCountForLabel(labeltoshow)
                 //                            labeltoshowrecess.text = Global.sharedInstance.hourShowRecessChild
                 //                            labeltoshowrecess.frame = CGRectMake(0,0, self.view.frame.size.width - 20, height2)
                 //                            let nrlines2:Int = 8 * lineCountForLabel(labeltoshowrecess)
                 //                            let subtotal:CGFloat = CGFloat(nrlines1) + CGFloat(nrlines2)
                 //                            return  height1 + height2  + 416 + subtotal // with picker
                 return view.frame.size.height * 0.85
                 }
                 }
                 else if Global.sharedInstance.recessForWorkerFromPlus{
                 //no need for button add breaks when opened breaks
                 //return view.frame.size.height * 0.13
                 return 0
                 }
                 }
                 //HERE ARE THE HEIGHTS FOR register EMPLOYE
                 //THIS ???
                 if indexPath.row == 1 {
                 if UIDevice.current.userInterfaceIdiom == .pad {
                 return view.frame.size.height * 0.65
                 }
                 else {
                 return 360
                 }

                 // return view.frame.size.height * 0.65
                 //  return 416
                 }
                 else if indexPath.row == 2 && Global.sharedInstance.isOpenHours == false{
                 return Global.sharedInstance.heightForCell
                 }
                 else if indexPath.row == 2 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.hoursForWorker == true
                 {
                 return view.frame.size.height * 0.85

                 }
                 //BUTTON ADD BREAKS
                 else if indexPath.row == 3 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.hoursForWorker == true{
                 //return view.frame.size.height * 0.13
                 return 50
                 }
                 else if indexPath.row == 2 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.recessForWorker == true
                 {
                 //no neeed for button on add breaks
                 //  return view.frame.size.height * 0.13
                 return 0
                 }
                 else if indexPath.row == 3 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.recessForWorker == true
                 {
                 return view.frame.size.height * 0.85
                 }
                 //            case 2:
                 //                //2. EMPLOYES
                 //                if Global.sharedInstance.isFromSave == true && Global.sharedInstance.isOpenNewWorker == false
                 //                {
                 //                    if indexPath.row == 0 {
                 //                        return Global.sharedInstance.heightForCell
                 //                    }
                 //                    else if indexPath.row == 1
                 //                    {
                 //                        if Global.sharedInstance.ifOpenCell == false && Global.sharedInstance.countCellEditOpen == 0
                 //                        {
                 //                            return view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjServiceProviders.count)
                 //                        }
                 //                        let acalculate =   (view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjServiceProviders.count)) + (view.frame.size.height * 0.88 * CGFloat(Global.sharedInstance.countCellEditOpen)) //+   (Global.sharedInstance.heightForCell * CGFloat(Global.sharedInstance.countCellEditOpen))//בגלל שביטלו את השמור והמשך צריך לא לחשבן את הגובה של הסל הזה
                 //
                 //                        let calculate =   (CGFloat( Global.sharedInstance.countCellHoursOpenFromEdit) * view.frame.size.height * 0.9375 - (Global.sharedInstance.heightForCell * CGFloat(Global.sharedInstance.countCellHoursOpenFromEdit)))
                 //
                 //                        if (flagsHelp.contains(true) && Global.sharedInstance.isOpenHoursForNewWorker == true) || Global.sharedInstance.isClickNoEqual == true{
                 //                            return acalculate + calculate + view.frame.size.height * 0.07//כדי להקטין את הגודל
                 //                        }
                 //                        return acalculate + calculate
                 //                    }
                 //                    else if indexPath.row == 2{
                 //                        return view.frame.size.height * 0.09
                 //                    }
                 //
                 //                    return Global.sharedInstance.heightForCell * CGFloat(Global.sharedInstance.generalDetails.arrObjServiceProviders.count)
                 //                }
                 //                if Global.sharedInstance.isOpenNewWorker == true
                 //                {
                 //                    if indexPath.row == 0 {
                 //                        return Global.sharedInstance.heightForCell
                 //                    }
                 //                    else if indexPath.row == 1{
                 //                        if Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 5{
                 //                            return view.frame.size.height * 0.45
                 //                        }
                 //                        return view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjServiceProviders.count)
                 //
                 //                    }
                 //                    else  if indexPath.row == 2
                 //                    {
                 //                        return view.frame.size.height * 0.09
                 //                    }
                 //                    else  if indexPath.row == 3
                 //                    {
                 //                       return view.frame.size.height * 0.75
                 //
                 //                    }
                 //                    else if Global.sharedInstance.isOpenHoursForPlusAction == false{
                 //                        return Global.sharedInstance.heightForCell
                 //                    }
                 //
                 //
                 //                    else if indexPath.row == 5 && Global.sharedInstance.hoursForWorkerFromPlus == true{
                 //                        return view.frame.size.height * 0.13
                 //
                 //                    }
                 //                    else if Global.sharedInstance.hoursForWorkerFromPlus
                 //                    {
                 //                        return view.frame.size.height * 0.75
                 //
                 //                    }
                 //                    else if indexPath.row == 5 && Global.sharedInstance.recessForWorkerFromPlus == true{
                 //                        return view.frame.size.height * 0.75
                 //
                 //                    }
                 //                    else if Global.sharedInstance.recessForWorkerFromPlus{
                 //                        return view.frame.size.height * 0.13
                 //                    }
                 //
                 //                }
                 //                if indexPath.row == 1 {
                 //                    return view.frame.size.height * 0.78
                 //                }
                 //                else if indexPath.row == 2 && Global.sharedInstance.isOpenHours == false{
                 //                    return Global.sharedInstance.heightForCell
                 //                }
                 //                else if indexPath.row == 2 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.hoursForWorker == true
                 //                {
                 //                    return view.frame.size.height * 0.88
                 //
                 //                }
                 //
                 //                else if indexPath.row == 3 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.hoursForWorker == true{
                 //                    return view.frame.size.height * 0.16// הפסקות
                 //                }
                 //                else if indexPath.row == 2 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.recessForWorker == true
                 //                {
                 //                    return view.frame.size.height * 0.88
                 //                }
                 //                else if indexPath.row == 3 && Global.sharedInstance.isOpenHours == true && Global.sharedInstance.recessForWorker == true
                 //                {
                 //                    return view.frame.size.height * 0.88
                 //                }

              //  return 0

            case 3:
                ///// return 100
                if Global.sharedInstance.isFromFirstSave == false{
                    if indexPath.row != 0{
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            return view.frame.size.height * 0.80
                        }
                        else {
                            return 570
                        }
                    }
                }
                else  {
                    if indexPath.row == 0{
                        return Global.sharedInstance.heightForCell
                    }
                    else if indexPath.row == 1{

                        if AppDelegate.countCellEditOpenService == 0{
                            return view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjProviderServices.count)

                        }
                        print("mmm")
                        // here is edit existing service - avoid clear spaces between rows
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            return view.frame.size.height * 0.75 + view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjProviderServices.count)
                        }
                        else {
                            return 570  + view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjProviderServices.count)
                        }
                    }
                    else if indexPath.row == 3
                    {
                        //\\ has one service // 2 is add service // 3 is edit service
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            return view.frame.size.height * 0.80
                        }
                        else {
                            return 570
                        }
                    }
                    return view.frame.size.height * 0.09

                }
            case 4:
                if indexPath.row != 0{
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        return view.frame.size.height * 0.45
                    }
                    else {
                        return 320
                    }
                }
            default:

                return Global.sharedInstance.heightForCell
            }
            //  var height = 60 / Global.sharedInstance.heightModel
            return Global.sharedInstance.heightForCell
            //return 60.0
        }
        if tableView == WorkersTbl{
            // must calculate if working hours and breaks are visible because they are also in picker row
            // Global.sharedInstance.hourShowChild
            // Global.sharedInstance.hourShowRecessChild
            if indexPath.row == 0{
                return (view.frame.size.height * 0.45)/5

            }
                //HERE IS ROW WITH NAME EMAIL PHONE
            else if indexPath.row == 1{
                //   return view.frame.size.height * 0.65
                if UIDevice.current.userInterfaceIdiom == .pad {
                    return view.frame.size.height * 0.65
                }
                else {
                    return 360
                }
            }
                //HERE IS THE EDITING EMPLOYE WORKING HOURS
            else if Global.sharedInstance.isOpenHoursForNewWorker == true && indexPath.row == 2 && Global.sharedInstance.hoursForWorkerFromEdit == true
            {
                if Global.sharedInstance.hourShowChild == "" && Global.sharedInstance.hourShowRecessChild == ""   { //no working breaks hours selected
                    return 416 }
                else {
                    return view.frame.size.height * 0.85
                }
            }
                //HERE IS BUTTON ADD BREAKS UNDER WORKING HOURS FOR EMPLOYE IN EDIT MODE
            else if indexPath.row == 3 && Global.sharedInstance.hoursForWorkerFromEdit == true{
                //  return view.frame.size.height * 0.13
                return 50
            }
            else if Global.sharedInstance.isOpenHoursForNewWorker == true && indexPath.row == 2 && Global.sharedInstance.recessForWorkerFromEdit == true{
                //BUTTON ADD BREAKS height must be 0 to hide it
                return 0
            }
                //HERE ARE BREAKS FOR EXISTING WORKER IN EDIT MODE
            else if indexPath.row == 3 && Global.sharedInstance.recessForWorkerFromEdit == true{

                return view.frame.size.height * 0.85
                //
            }

            return Global.sharedInstance.heightForCell
        }
        if tableView == daysTbl
        {
            return daysTbl.layer.frame.height / 7
        }
        if tableView == hoursTbl
        {
            return hoursTbl.layer.frame.height / 7
        }

        if tableView == ServicesTbl{
            if indexPath.row == 0{
                return (view.frame.size.height * 0.45)/5
            }
            else if indexPath.row == 1{
                if UIDevice.current.userInterfaceIdiom == .pad {
                    return view.frame.size.height * 0.80
                }
                else {
                    return 570 + view.frame.size.height * 0.09 * CGFloat(Global.sharedInstance.generalDetails.arrObjProviderServices.count)
                }
                //  return view.frame.size.height * 0.75
            }
            return 50
        }
        return 50
    }

    //MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return AppDelegate.arrDomainFilter.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        //Aligning right to left on UICollectionView
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)

        let cell:ItemInCollectionInSection1CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemInCollectionInSection1CollectionViewCell",for: indexPath) as! ItemInCollectionInSection1CollectionViewCell
        cell.transform = scalingTransform
        cell.lblDescSubject.textAlignment = .left
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            cell.lblDescSubject.textAlignment = .right

        }

        cell.btnCheck.isCecked = false
        if Global.sharedInstance.domainBuisness != ""
        {
            if Global.sharedInstance.domainBuisness == AppDelegate.arrDomainFilter[indexPath.row].nvCategoryName
            {
                cell.btnCheck.isCecked = true
                cell.contentView.backgroundColor =  UIColor(red:145/255.0, green: 201/255.0, blue: 214/255.0, alpha: 1.0)
                cell.lblDescSubject.textColor = UIColor.black
            }
            else{
                cell.btnCheck.isCecked = false
                cell.contentView.backgroundColor =  UIColor.clear
                cell.lblDescSubject.textColor = UIColor.white
            }
        }
        else{
            cell.btnCheck.isCecked = false
            cell.contentView.backgroundColor =  UIColor.clear
            cell.lblDescSubject.textColor = UIColor.white
        }
        cell.setDisplayData(AppDelegate.arrDomainFilter[indexPath.row].nvCategoryName)

        cell.delegate = self
        cell.btnCheck.tag = indexPath.row

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //JMODE 28.12.2016    return CGSize(width: view.frame.size.width/2, height: view.frame.size.height * 0.4111/4)
        return CGSize(width: view.frame.size.width, height: view.frame.size.height * 0.4111/4) //ONE PER ROW
    }

    //MARK: - gestureRecognizer for dismissKeyboard
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        if gestureRecognizer == tapopen {
            self.openPopupHours()
            for cell in self.extTbl.visibleCells
            {
                cell.removeGestureRecognizer(tapopen)
            }
            return true
        } else {
            dismissKeyboard()
            return false
        }
    }
    @objc func openPopupHours(){
        if self.attemptsToOpenActiveHoursCount == 0 {

            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
            // let aaa:PopUpWorkingHours = storyboardtest.instantiateViewController(withIdentifier: "PopUpWorkingHours") as! PopUpWorkingHours

            let aaa:ExplainWorkingHoursPopUP = storyboardtest.instantiateViewController(withIdentifier: "ExplainWorkingHoursPopUP") as! ExplainWorkingHoursPopUP
            let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)

            if iOS8 == true {
                aaa.modalPresentationStyle = UIModalPresentationStyle.custom
            } else {
                aaa.modalPresentationStyle = UIModalPresentationStyle.custom
            }
            self.present(aaa, animated: true, completion: nil)
            self.attemptsToOpenActiveHoursCount += 1

        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    //MARK: - ReloadCollectionDelegate
    func ReloadCollection(_ collImages:UICollectionView){
        collImages.reloadData()
    }

    //MARK: - addRowForSection3Delegate
    func addRow(_ tag: Int, row:Int) {

        if Global.sharedInstance.isOpenHoursForPlusAction == true{//לחיצה על איקס בשעות פעילות שונות בהוסף עובד
            extTbl.reloadData()
        }
        else if tag == -50{
            Global.sharedInstance.isOpenHours = false//סגירת שעות פעילות של הפעם הראשונה
            extTbl.reloadData()
        }
        else if tag == -90{//לחיצה על איקס של יומן אישי בעריכה
            Global.sharedInstance.isOpenHoursForNewWorker = false
            extTbl.reloadData()
            self.WorkersTbl.reloadData()
            if Global.sharedInstance.countCellHoursOpenFromEdit > 0{
                Global.sharedInstance.countCellHoursOpenFromEdit = 0
            }
        }
        else if tag == -70{//איקס בשעות פעילות של עריכה
            Global.sharedInstance.isClickNoEqual = true
            extTbl.reloadData()
            Global.sharedInstance.isClickNoEqual = true
            self.WorkersTbl.reloadData()
            Global.sharedInstance.countCellHoursOpenFromEdit = 1
        }
        else if tag == -80{//ןי בשעות פעילות של עריכה
            if Global.sharedInstance.countCellHoursOpenFromEdit > 0{
                Global.sharedInstance.countCellHoursOpenFromEdit = 0
            }
            extTbl.reloadData()
            self.WorkersTbl.reloadData()
        }
        else  if tag != -30{//לחיצה על איקס של עובד אישי//או על וי בשעות זהות בהוסף עובד
            Global.sharedInstance.isOpenHours = true
            extTbl.reloadData()
        }
        else{
            extTbl.reloadData()
        }
    }

    //MARK: - ReloadTableDelegate
    func ReloadTable(_ tblHoursActive:UITableView,tblHoursRest:UITableView)
    {
        daysTbl = tblHoursActive
        hoursTbl = tblHoursRest
        self.daysTbl.reloadData()
        hoursTbl.reloadData()
    }

    //MARK: - reloadTableForSaveDelegate
    func reloadTableForSave(_ tag:Int, btnTag:Int){//פונקציה זו נקראת בד״כ כשלאחר שמירה התצוגה משתנית


        if tag == -100 && btnTag == 3
        {
            Global.sharedInstance.selectedCell[btnTag] = false
            extTbl.reloadData()
        }
        else if tag == -10 || btnTag == -10{//לחצו על השמירה של פרטי עובד לאחר לחיצה על כפתור פלוס להוספת עובד
            Global.sharedInstance.isFromSave = true
            Global.sharedInstance.isOpenNewWorker = false
            if btnTag == -10{
                Global.sharedInstance.isOpenHoursForPlus = false
                Global.sharedInstance.isOpenHoursForPlusAction = false
            }
            extTbl.reloadData()
        }
        else if tag == -20{//לחצו על השמירה של פרטי שרות לאחר לחיצה על כפתור פלוס להוספת שרות
            Global.sharedInstance.isNewService = false
            Global.sharedInstance.isFromFirstSave = true
            //            Global.sharedInstance.currentEditCellOpen = -1
            extTbl.reloadData()
        }
        else if btnTag == -1 {// שמור והמשך של שעות פעילות שבתוך עריכת עובד
            selectedCellForEdit[tag] = false
            let index:IndexPath = IndexPath(row: 0, section: tag)
            let cell = WorkersTbl.cellForRow(at: index) as! WorkerInListTableViewCell
            let index1:IndexPath = IndexPath(row: 2, section: tag)
            let cell1 = WorkersTbl.cellForRow(at: index1) as? ItemInSection2TableViewCell
            //flags[tag] = 0
            if let a = cell1{
                cell1?.isOpen = false
                Global.sharedInstance.countCellHoursOpenFromEdit = 0//מס׳ שעות פעילות בתוך עריכה פתוחים לצורך חישוב הגובה של הסל החיצוני
            }
            cell.isOpen = false
            Global.sharedInstance.countCellEditOpen -= 1// מס׳ שורות של עריכה פתוחות לצורך חישוב הגובה של הסל החיצוני
            Global.sharedInstance.isOpenHoursForNewWorker = false
            Global.sharedInstance.ifOpenCell = false
            extTbl.reloadData()
            self.WorkersTbl.reloadData()
            return
        }
        else if btnTag == -2 {
            Global.sharedInstance.selectedCellForEditService[tag] = false
            AppDelegate.countCellEditOpenService -= 1
            let index:IndexPath = IndexPath(row: 0, section: tag)
            let cell = ServicesTbl.cellForRow(at: index) as! ServiceInListTableViewCell
            cell.isOpen = false
            extTbl.reloadData()
            ServicesTbl.reloadData()
            return
        }
        else if tag == 2 && Global.sharedInstance.currentEditCellOpen == 2{//שמירה של עובד בפעם הראשונה
            Global.sharedInstance.selectedCell[tag] = false
            Global.sharedInstance.isFromSave = true
            extTbl.reloadData()
        }
        else  if tag  == 3 && Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0{//שמירה של שרות בפעם הראשונה
            if Global.sharedInstance.isFromFirstSave == false
            {
                Global.sharedInstance.isFromFirstSave = true
            }
            else
            {
                Global.sharedInstance.isFromFirstSave = false
            }
            extTbl.reloadData()
        }
        else    if tag == 1 || tag == 4 {
            Global.sharedInstance.selectedCell[tag] = false
            if tag == 1{
                for  item in Global.sharedInstance.fIsValidHours{
                    if item == true{
                        Global.sharedInstance.isHoursSelectedItem = true
                    }
                }
                // isHoursSelected
            }
            extTbl.reloadData()
        }
        else if tag == -200
        {
            let index:IndexPath = IndexPath(row: 2, section: 2)
            Global.sharedInstance.isOpenNewWorker = false
            extTbl.reloadData()
            let cell = extTbl.cellForRow(at: index) as! NewWorkerTableViewCell
            cell.isOpen = false
        }
        else if tag == -1{
            Global.sharedInstance.selectedCell[2] = false
            extTbl.reloadData()
        }
        else {
            notificationsRowsInSection[2] = 2
            extTbl.reloadData()
        }
    }

    //MARK: - putSubDelegate
    func scrollTotop()
    {
        extTbl.setContentOffset(CGPoint.zero, animated:true)
    }

    //לאחר בחירת התחום יוצג התחום שנבחר בסל שמעליו
    func putSub(_ tag:Int){
        print("ce tag \(AppDelegate.arrDomainFilter[tag].iCategoryRowId)")
        let indexTxtSub:IndexPath = IndexPath(row: 0, section: 0)//מיקום של השורה הראשונה שלשם תכנס התחום שבחר
        let indexItemInCollection:IndexPath = IndexPath(row: tag, section: 0)//מיקום של איבר באוסף
        let indexItemDepenExtTabl:IndexPath = IndexPath(row: 1, section: 0)
        let cellCollection = extTbl.cellForRow(at: indexItemDepenExtTabl) as! Section2TableViewCell

        extTbl.reloadSections(IndexSet(integer: 0), with: .fade)

        let cell = cellCollection.collSubject.cellForItem(at: indexItemInCollection) as! ItemInCollectionInSection1CollectionViewCell
        let str =  cell.lblDescSubject.text
        //Global.sharedInstance.itemInCol = cell
        Global.sharedInstance.domainBuisness = str!


        (extTbl.cellForRow(at: indexTxtSub) as! MainTableViewCell).txtSub.text = str
        Global.sharedInstance.headersCellRequired[0] = true//בשביל הסתרת השדה כוכבית
        ///שמירת  האיידי של שדה התחום שנבחר ע״מ שיהיה מוכן לשליחה לשרת
        Global.sharedInstance.generalDetails.iFieldId = AppDelegate.arrDomainFilter[tag].iCategoryRowId
        print(" Global.sharedInstance.generalDetails.iFieldId \( Global.sharedInstance.generalDetails.iFieldId)")
        extTbl.reloadData()

    }

    //MARK: - ReloadTableWorkersDelegate
    func ReloadTableWorkers(_ workersTbl:UITableView){
        if Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 0{
            if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
            } else {

                if let _:IndexPath = IndexPath(row: 2, section: 3) {
                    let index:IndexPath = IndexPath(row: 2, section: 3)

                    if let _ = extTbl.cellForRow(at: index) as? NewWorkerTableViewCell {
                        let cell = extTbl.cellForRow(at: index) as? NewWorkerTableViewCell
                        if cell != nil{
                            cell!.isOpen = false
                        }

                    }
                }
            }
        }

        // flagsHelp = flags
        flags = []

        WorkersTbl = workersTbl

        for _ in Global.sharedInstance.generalDetails.arrObjServiceProviders{
            selectedCellForEdit.append(false)
            flags.append(false)
        }

        self.WorkersTbl.reloadData()

    }
    //פתיחה או סגירה של השעות פעילות
    //MARK: - reloadTableForNewWorkerDelegate
    func reloadTableForNewWorker(_ cell:NewWorkerTableViewCell){

        if cell.isOpen == false
        {
            Global.sharedInstance.isOpenNewWorker = true
        }
        if Global.sharedInstance.currentEditCellOpen != -1
        {
            closeCellFromOtherCell()
        }
        if cell.tag == Global.sharedInstance.currentEditCellOpen
        {
            Global.sharedInstance.currentEditCellOpen = -1
            cell.isOpen = false
            extTbl.reloadData()
        }
        else if Global.sharedInstance.currentEditCellOpen == -1 || Global.sharedInstance.selectedCell[Global.sharedInstance.currentEditCellOpen] == false
        {
            if cell.isOpen == false || cell.isOpen == true && newWorkerIsClose == true
            {
                Global.sharedInstance.isServiceProviderEditOpen = false
                Global.sharedInstance.hoursForWorkerFromEdit = false
                isOpen = true
                Global.sharedInstance.isOpenWorker = false
                Global.sharedInstance.fromEdit = false
                Global.sharedInstance.currentEditCellOpen = cell.tag
                cell.isOpen = true
                newWorkerIsClose = false
                Global.sharedInstance.hoursForWorkerFromPlus = true
                Global.sharedInstance.isOpenNewWorker = true
                extTbl.reloadData()
                let index:IndexPath = IndexPath(row: 2, section: 2)
                extTbl.scrollToRow(at: index, at: UITableView.ScrollPosition.top, animated: true)
                flagsHelp = a
                //x1 = 0//נסוי לשיים פה אולי זה יעזור שהתחומיים יפתחו אחרי עריכה הוסף לחיצה על תחומים
            }
            else{
                if delegateSaveWorker.saveDataToWorker() == true{
                    Global.sharedInstance.hoursForWorkerFromPlus = false
                    cell.isOpen = false
                    Global.sharedInstance.isOpenNewWorker = false
                    Global.sharedInstance.isOpenHoursForPlus = false
                    extTbl.reloadData()
                }
            }
        }
    }

    //MARK: - reloadServicesTableDelegate
    func reloadServicesTable(_ tbl:UITableView){
        if Global.sharedInstance.isFromSave == true{
            let index:IndexPath = IndexPath(row: 2, section: 4)
            let cell = extTbl.cellForRow(at: index) as? NewWorkerTableViewCell
            if cell != nil
            {
                cell!.isOpen = false
            }
        }
        ServicesTbl = tbl
        for _ in Global.sharedInstance.generalDetails.arrObjProviderServices{
            Global.sharedInstance.selectedCellForEditService.append(false)
        }
        ServicesTbl.reloadData()
    }

    //MARK: - reloadTableForNewServiceDelegate
    func reloadTableForNewService(_ cell:AddNewServiceTableViewCell){

        if Global.sharedInstance.currentEditCellOpen != -1
        {
            closeCellFromOtherCell()
        }
        if cell.isOpen == false
        {
            Global.sharedInstance.isNewService = true
        }
        if Global.sharedInstance.currentEditCellOpen == -1 || Global.sharedInstance.selectedCell[Global.sharedInstance.currentEditCellOpen] == false
        {
            if cell.isOpen == false || newServiceIsClose == true{
                if cell.tag == Global.sharedInstance.currentEditCellOpen//סגירת השרות בלחיצה על פלוס (שממנו גם פתחו)
                {
                    cell.isOpen = false
                    newServiceIsClose = true
                    Global.sharedInstance.isNewService = false
                    Global.sharedInstance.currentEditCellOpen = -1
                }
                else
                {
                    cell.isOpen = true
                    newServiceIsClose = false
                    Global.sharedInstance.isNewService = true
                }
            }
            else{
                if delegateSaveBussines.saveDataToWorker() == true{
                    cell.isOpen = false
                    Global.sharedInstance.isNewService = false
                }
            }
            extTbl.reloadData()
        }
    }

    //MARK: - editWorkerDelegate

    //נקראת בעת פתיחת או סגירת עריכה
    func reloadTableForEdit(_ tag:Int,my:WorkerInListTableViewCell)
    {
        if Global.sharedInstance.addRecess == true//נבחרו הפסקות
        {
            Global.sharedInstance.GlobalDataVC!.delegateEnabledBtnDays.enabledTrueBtnDays()
        }

        Global.sharedInstance.addRecess = false

        if my.isEdit == 1//מעריכה
        {Global.sharedInstance.isClickNoEqual = false
            if(Global.sharedInstance.currentEditCellOpen != -1 && Global.sharedInstance.selectedCell[2] == false) //|| x1 == 1
                //לסגירת סל אחר בשביל לפתוח את עריכה
            {
                closeCellFromOtherCell()
            }
            if (Global.sharedInstance.currentEditCellOpen != -1 && Global.sharedInstance.selectedCell[Global.sharedInstance.currentEditCellOpen] == false && Global.sharedInstance.currentEditCellOpen != 2)/*לפתיחת עריכה לאחר סגירת סקשין אחר*/
                || (Global.sharedInstance.currentEditCellOpen == 2 && Global.sharedInstance.selectedCell[2] == true /*&& Global.sharedInstance.isOpenNewWorker == false*/)/*לסגירת העריכה בלחיצה על סל אחר או בלחיצה נוספת על ערוך*/
                || (Global.sharedInstance.currentEditCellOpen == -1 && Global.sharedInstance.selectedCell[2] == false)//פתיחת העריכה בלחיצה על ערוך אחר שסגרתי בערוך או בפעם הראשונה שלחצו לפתיחת עריכה
            {
                Global.sharedInstance.isOpenNewWorker = false//בינתיים שמתי פה לא ברור אם תמיד צריך אותו
                Global.sharedInstance.isOpenHoursForPlusAction = false
                Global.sharedInstance.isOpenHoursForPlus = false
                flagsHelp = a
                let indexCell:IndexPath = IndexPath(row: 2, section: 2)
                if extTbl.cellForRow(at: indexCell) != nil
                {
                    // האם ההוסף עובד פתוח
                    if  (extTbl.cellForRow(at: indexCell)as!NewWorkerTableViewCell).isOpen == true && newWorkerIsClose == false
                    {
                        if delegateSaveWorker.saveDataToWorker() == true
                        {
                            Global.sharedInstance.hoursForWorkerFromPlus = false
                            (extTbl.cellForRow(at: indexCell)as!NewWorkerTableViewCell).isOpen = false
                        }
                    }
                }
                if  selectedCellForEdit[tag] == false//אם לפתוח את עריכה
                {
                    Global.sharedInstance.isServiceProviderEditOpen = true
                    Global.sharedInstance.hoursForWorkerFromEdit = true
                    Global.sharedInstance.hoursForWorkerFromPlus = false
                    if Global.sharedInstance.generalDetails.arrObjServiceProviders[tag].bSameWH == false && (Global.sharedInstance.generalDetails.arrObjServiceProviders[tag].objsers.iUserStatusType == 25 || Global.sharedInstance.generalDetails.arrObjServiceProviders[tag].objsers.iUserStatusType == 24)
                    {
                        Global.sharedInstance.countCellHoursOpenFromEdit = 1
                        flags[tag] = true
                        flagsHelp[tag] = true
                        Global.sharedInstance.isOpenHoursForNewWorker = true
                        Global.sharedInstance.onOpenTimeOpenHours = true
                    }
                    else
                    {
                        Global.sharedInstance.isOpenHoursForNewWorker = false
                    }
                    my.isOpen = true
                    my.isEdit = 1
                    for i in 0 ..< selectedCellForEdit.count{
                        if i != tag &&  selectedCellForEdit[i] == true{
                            if delegateSaveWorker.saveDataToWorker() == true{
                                let index:IndexPath = IndexPath(row: 0, section: i)
                                let cellMy = (WorkersTbl.cellForRow(at: index) as! WorkerInListTableViewCell)
                                cellMy.isOpen = false
                                cellMy.isEdit = 0
                                selectedCellForEdit[i] = false
                                if Global.sharedInstance.countCellEditOpen > 0{
                                    Global.sharedInstance.countCellEditOpen -= 1
                                }
                                Global.sharedInstance.ifOpenCell = false
                                Global.sharedInstance.currentEditCellOpen = -1
                                Global.sharedInstance.selectedCell[2] = false
                                Global.sharedInstance.countCellHoursOpenFromEdit = 0
                                if flags[i] == true{
                                    if Global.sharedInstance.countCellHoursOpenFromEdit > 0{
                                        Global.sharedInstance.countCellHoursOpenFromEdit = 0
                                    }
                                    Global.sharedInstance.isOpenHoursForNewWorker = false
                                }
                            }
                            selectedCellForEdit[i] = false
                            break
                        }
                    }
                    Global.sharedInstance.selectedCellEdit = tag
                    //בעת פתיחת העריכה -אתחול המערכים ששומרים באופן זמני את השעות פעילות לפי מה שכבר נבחר כדי שגם אם לא גוללים הנתונים לא יתאפסו וכן כדי למזג בין הנתונים כשגוללים,וכן אתחול המשתנים של בחירת הסמן את כל הימים
                    //אתחול בשביל שעות
                    print("Global.sharedInstance.selectedCellEdit \(Global.sharedInstance.selectedCellEdit) si cati \( Global.sharedInstance.arrObjServiceProvidersForEdit.count)")
                    Global.sharedInstance.arrWorkHoursChild = Global.sharedInstance.arrObjServiceProvidersForEdit[Global.sharedInstance.selectedCellEdit].arrObjWorkingHours
                    Global.sharedInstance.isSelectAllHoursChild = Global.sharedInstance.arrObjServiceProvidersForEdit[Global.sharedInstance.selectedCellEdit].isSelectAllHours
                    Global.sharedInstance.isHoursSelectedChild = Global.sharedInstance.arrObjServiceProvidersForEdit[Global.sharedInstance.selectedCellEdit].isHoursSelected
                    print("xzzz.bSameWH \(Global.sharedInstance.arrObjServiceProvidersForEdit[Global.sharedInstance.selectedCellEdit].bSameWH)")
                    for itemx in Global.sharedInstance.arrObjServiceProvidersForEdit {
                        print(" ob edit \(itemx.objsers.getDic())")
                    }
                    for item in Global.sharedInstance.arrWorkHoursChild {
                        print("hhchild \(item.getDic())")
                    }
                    print("Global.sharedInstance.isHoursSelectedChild \(Global.sharedInstance.isHoursSelectedChild)")
                    print("Global.sharedInstance.isSelectAllHoursChild \(Global.sharedInstance.isSelectAllHoursChild)")
                    //אתחול בשביל הפסקות
                    Global.sharedInstance.arrWorkHoursRestChild = Global.sharedInstance.arrObjServiceProvidersForEdit[Global.sharedInstance.selectedCellEdit].arrObjWorkingRest
                    Global.sharedInstance.isSelectAllRestChild = Global.sharedInstance.arrObjServiceProvidersForEdit[Global.sharedInstance.selectedCellEdit].isSelectAllRecess
                    Global.sharedInstance.isHoursSelectedRestChild = Global.sharedInstance.arrObjServiceProvidersForEdit[Global.sharedInstance.selectedCellEdit].isHoursSelectedRest
                    if flags[tag] == true
                    {
                        Global.sharedInstance.countCellHoursOpenFromEdit = 1
                        Global.sharedInstance.isOpenHoursForNewWorker = true
                    }
                    selectedCellForEdit[tag] = true
                    Global.sharedInstance.fromEdit = true
                    Global.sharedInstance.countCellEditOpen = 1
                    Global.sharedInstance.ifOpenCell = true
                }
                else//סגירת עריכה
                {
                    if delegateSaveWorker.saveDataToWorker() == true{
                        my.isOpen = false
                        selectedCellForEdit[tag] = false
                        if Global.sharedInstance.countCellEditOpen > 0{
                            Global.sharedInstance.countCellEditOpen -= 1
                        }
                        Global.sharedInstance.ifOpenCell = false
                        Global.sharedInstance.currentEditCellOpen = -1
                        Global.sharedInstance.selectedCell[2] = false
                        Global.sharedInstance.countCellHoursOpenFromEdit = 0
                        flagsHelp = a
                        Global.sharedInstance.flagIsClickOnNoSameHour = true
                        if flags[tag] == true{
                            if Global.sharedInstance.countCellHoursOpenFromEdit > 0{
                                Global.sharedInstance.countCellHoursOpenFromEdit = 0
                            }
                            my.isOpenHours = false
                            Global.sharedInstance.isOpenHoursForNewWorker = false
                        }
                    }
                    Global.sharedInstance.hoursForWorkerFromEdit = false
                    Global.sharedInstance.isServiceProviderEditOpen = false
                }
            }
            extTbl.reloadData()
            WorkersTbl.reloadData()
            extTbl.reloadData()
        }
        else if my.isEdit == 0//ממחיקה
        {
            if selectedCellForEdit[tag] == true{
                if Global.sharedInstance.countCellEditOpen > 0{
                    Global.sharedInstance.countCellEditOpen -= 1
                    if Global.sharedInstance.countCellEditOpen == 0{
                        Global.sharedInstance.selectedCell[2] = false
                        Global.sharedInstance.fromEdit = false
                        Global.sharedInstance.currentEditCellOpen = -1
                    }
                }
                Global.sharedInstance.ifOpenCell = false
                selectedCellForEdit.remove(at: tag)
                my.isOpen = false
                if flags[tag] == true{
                    if    Global.sharedInstance.countCellHoursOpenFromEdit > 0{
                        Global.sharedInstance.countCellHoursOpenFromEdit = 0
                    }
                    my.isOpenHours = false
                    Global.sharedInstance.isOpenHoursForNewWorker = false
                }
            }
            extTbl.reloadData()
            WorkersTbl.reloadData()
            extTbl.reloadData()
        }
        else {
            if selectedCellForEdit[tag] == true{
                Global.sharedInstance.countCellEditOpen -= 1
                Global.sharedInstance.ifOpenCell = false
                selectedCellForEdit.remove(at: tag)
                my.isOpen = false
                if flags[tag] == true{
                    if Global.sharedInstance.countCellHoursOpenFromEdit > 0{
                        Global.sharedInstance.countCellHoursOpenFromEdit = 0
                    }
                    my.isOpenHours = false
                    Global.sharedInstance.isOpenHoursForNewWorker = false
                }
            }
            else{
                selectedCellForEdit.remove(at: tag)
            }
            extTbl.reloadData()
            WorkersTbl.reloadData()
            extTbl.reloadData()
        }

    }

    //MARK: - editServiceDelegate

    func reloadTableForEditService(_ tag:Int,my:ServiceInListTableViewCell){
        let indexCell:IndexPath = IndexPath(row: 2, section: 3)
        var cell:AddNewServiceTableViewCell!
        if extTbl.cellForRow(at: indexCell) != nil{
            cell = extTbl.cellForRow(at: indexCell) as! AddNewServiceTableViewCell
        }

        //iustin edit



        if my.isEdit == 1{//פתיחה וסגירה של עריכה

            if Global.sharedInstance.currentEditCellOpen != -1 && Global.sharedInstance.selectedCell[3] == false//לסגירת סל אחר בשביל לפתוח את עריכה
            {
                closeCellFromOtherCell()
            }
            if (Global.sharedInstance.currentEditCellOpen != -1 && Global.sharedInstance.selectedCell[Global.sharedInstance.currentEditCellOpen] == false && Global.sharedInstance.currentEditCellOpen != 3)/*לפתיחת עריכה לאחר סגירת סל אחר*/
                || (Global.sharedInstance.currentEditCellOpen == 3 && Global.sharedInstance.selectedCell[3] == true)/*לסגירת העריכה בלחיצה על סל אחר או בלחיצה נוספת על ערוך*/
                || (Global.sharedInstance.currentEditCellOpen == -1 && Global.sharedInstance.selectedCell[3] == false)//פתיחת העריכה בלחיצה על ערוך אחר שסגרתי בערוך
                || Global.sharedInstance.isNewService == true || cell.isOpen == true
            { //cell closed, edit is opening + opened already
                Global.sharedInstance.isNewService = false
                let indexCell:IndexPath = IndexPath(row: 2, section: 3)
                if extTbl.cellForRow(at: indexCell) != nil
                { //cell closed, edit is opening
                    if  (extTbl.cellForRow(at: indexCell)as!AddNewServiceTableViewCell).isOpen == true
                    {
                        (extTbl.cellForRow(at: indexCell)as!AddNewServiceTableViewCell).isOpen = false
                    }
                }
                if Global.sharedInstance.selectedCellForEditService[tag] == false//
                { //cell closed, edit is opening + opened already
                    my.isOpen = true
                    my.isEdit = 1
                    for i in 0 ..< Global.sharedInstance.selectedCellForEditService.count{
                        if i != tag &&  Global.sharedInstance.selectedCellForEditService[i] == true{
                            if delegateSaveBussines.saveDataToWorker() == true{
                                let index:IndexPath = IndexPath(row: 0, section: i)
                                let cellMy = ServicesTbl.cellForRow(at: index) as! ServiceInListTableViewCell
                                cellMy.isOpen = false
                                cellMy.isEdit = 0
                                Global.sharedInstance.selectedCellForEditService[i] = false
                                Global.sharedInstance.isFromEditService = false
                                Global.sharedInstance.currentEditCellOpen = -1
                                Global.sharedInstance.selectedCell[3] = false
                                if AppDelegate.countCellEditOpenService > 0{
                                    AppDelegate.countCellEditOpenService -= 1
                                }
                                break
                            }
                        }
                    }
                    Global.sharedInstance.selectedCellForEditService[tag] = true
                    AppDelegate.countCellEditOpenService += 1
                    Global.sharedInstance.isFromEditService = true
                }
                else{

                    //                    print("delegateSaveBussines.saveDataToWorker(): \(delegateSaveBussines.saveDataToWorker())")

                    if delegateSaveBussines.saveDataToWorker() == true{
                        my.isOpen = false
                        Global.sharedInstance.selectedCellForEditService[tag] = false
                        Global.sharedInstance.isFromEditService = false
                        Global.sharedInstance.currentEditCellOpen = -1
                        Global.sharedInstance.selectedCell[3] = false
                        if AppDelegate.countCellEditOpenService > 0{
                            AppDelegate.countCellEditOpenService -= 1
                        }
                    }
                }
            }
            extTbl.reloadData()
            ServicesTbl.reloadData()


        }
        else if my.isEdit == 0{//מחיקה אם יש רק איבר אחד
            if Global.sharedInstance.selectedCellForEditService[tag] == true{
                if AppDelegate.countCellEditOpenService > 0{
                    AppDelegate.countCellEditOpenService -= 1
                }
                Global.sharedInstance.selectedCellForEditService.remove(at: tag)
                my.isOpen = false
            }
            else{
                Global.sharedInstance.selectedCellForEditService.remove(at: tag)
            }
            extTbl.reloadData()
            ServicesTbl.reloadData()
            ServicesTbl.reloadData()
            extTbl.reloadData()
        }
        else
        {
            if Global.sharedInstance.selectedCellForEditService[tag] == true{
                if  AppDelegate.countCellEditOpenService > 0{
                    AppDelegate.countCellEditOpenService -= 1
                }
                Global.sharedInstance.selectedCellForEditService.remove(at: tag)
                my.isOpen = false
            }
            else
            {
                Global.sharedInstance.selectedCellForEditService.remove(at: tag)
            }
            extTbl.reloadData()
            ServicesTbl.reloadData()
            extTbl.reloadData()
        }

    }

    func dismmissKeybourd(){
        view.endEditing(true)
    }

    func viewErrorForFirstSection(){
        Global.sharedInstance.isFirstSectionValid = false

        Global.sharedInstance.helperTable?.reloadData()
    }

    func validSection1(){

        Global.sharedInstance.flagIsSecond1Valid = false

        Global.sharedInstance.helperTable?.reloadData()
    }

    func validData() {
        extTbl.reloadData()
    }


    func scrollOnEdit(_ keyBoardSize:CGRect,textField:UITextField)
    {
        var frame = self.extTbl.frame
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)
        frame.size.height -= keyBoardSize.height - 110
        self.extTbl.frame = frame
        let rect = self.extTbl.convert(textField.bounds, from: textField)
        self.extTbl.scrollRectToVisible(rect, animated: false)
        UIView.commitAnimations()
    }

    func scrollOnEndEdit(_ keyBoardSize:CGRect)
    {
        var frame = self.extTbl.frame
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)

        if keyBoardSize.height != 0
        {
            frame.size.height += keyBoardSize.height - 110
        }
        else{
            frame.size.height += 216 - 110
        }
        self.extTbl.frame = frame
        UIView.commitAnimations()
    }
    //commit
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if Global.sharedInstance.GlobalDataVC!.delegateTableAddress != nil
        {
            Global.sharedInstance.GlobalDataVC!.delegateTableAddress.tableViewAddress(extTbl.contentOffset.y)
        }

    }

    func closeCellFromOtherCell()//סגירת סל בעת פתיחת סל אחר
    {
        //סגירת הסל שהיה פתוח גם אם אינן תקין
        if Global.sharedInstance.currentEditCellOpen == 0 //|| x1 == 1 //תחומים
        {
            Global.sharedInstance.selectedCell[0] = false
        }
        else if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
        {
            //שמירת הנתונים בגלובל שיהיו מוכנים לשליחה לשרת
            var workingHours:objWorkingHours = objWorkingHours()
            Global.sharedInstance.generalDetails.arrObjWorkingHours = Array<objWorkingHours>()
            //עובר על השעות של כל הימים בשבוע של הספק
            for i in 0 ..< Global.sharedInstance.arrWorkHours.count {
                //יש הפסקות
                if Global.sharedInstance.isHoursSelectedRest[i]
                {
                    print("crssss \(Global.sharedInstance.GlobalDataVC)")

                    Global.sharedInstance.GlobalDataVC!.delegateActiveHours?.checkValidityHours(i)
                    if Global.sharedInstance.fIsValidHours[i] == true && Global.sharedInstance.fIsValidRest[i] == true//רק אם תקין
                    {
                        //שמירת הנתונים
                        workingHours = objWorkingHours(
                            _iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                            _nvFromHour: Global.sharedInstance.arrWorkHours[i].nvFromHour,
                            _nvToHour: Global.sharedInstance.arrWorkHoursRest[i].nvFromHour)
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
                        //---------------------------
                        workingHours = objWorkingHours(
                            _iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                            _nvFromHour: Global.sharedInstance.arrWorkHoursRest[i].nvToHour,
                            _nvToHour: Global.sharedInstance.arrWorkHours[i].nvToHour)
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
                        //   Global.sharedInstance.arrIsRestChecked[i] = false //איפוס המשתנה
                    }
                }
                else //אין הפסקות
                {
                    Global.sharedInstance.GlobalDataVC!.delegateActiveHours?.checkValidityHours(i)
                    if Global.sharedInstance.fIsValidHours[i] == true
                    {
                        workingHours = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                                                       _nvFromHour: Global.sharedInstance.arrWorkHours[i].nvFromHour,
                                                       _nvToHour: Global.sharedInstance.arrWorkHours[i].nvToHour)
                        if Global.sharedInstance.isHoursSelected[i] == true
                        {
                            Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
                        }
                    }
                }
            }
            //עובר על כל השעות ובודק האם יש יום שהשעות לא חוקיות
            Global.sharedInstance.isValidHours = false
            for bool in Global.sharedInstance.fIsValidHours
            {
                if bool == true
                {
                    Global.sharedInstance.isValidHours = true

                    break
                }

            }

            for item in Global.sharedInstance.fIsValidHours{
                if item == true{
                    Global.sharedInstance.isHoursSelectedItem = true
                }
            }
            Global.sharedInstance.selectedCell[1] = false
            if Global.sharedInstance.addRecess != false//אם פתחו בכלל את ההפסקות ויש צורך להפעיל(גם כדי למנוע קריסה)
            {
                Global.sharedInstance.GlobalDataVC!.delegateEnabledBtnDays.enabledTrueBtnDays()
            }
            Global.sharedInstance.addRecess = false
        }
        else if Global.sharedInstance.currentEditCellOpen == 2//עובדים
        {
            if selectedCellForEdit.contains(true)//אם יש עובד הפתוח בעריכה
            {
                Global.sharedInstance.hoursForWorkerFromEdit = false
                for i in 0 ..< selectedCellForEdit.count{
                    if selectedCellForEdit[i] == true{
                        if delegateSaveWorker.saveDataToWorker() == true
                        {
                            flagsHelp = a
                            let index:IndexPath = IndexPath(row: 0, section: i)
                            let cellMy:WorkerInListTableViewCell = (WorkersTbl.cellForRow(at: index) as! WorkerInListTableViewCell)
                            //   let cellMy = (WorkersTbl.cellForRow(at: index) as! WorkerInListTableViewCell)
                            cellMy.isOpen = false
                            cellMy.isEdit = 0
                            selectedCellForEdit[i] = false
                            if Global.sharedInstance.countCellEditOpen > 0{
                                Global.sharedInstance.countCellEditOpen -= 1
                            }
                            Global.sharedInstance.ifOpenCell = false
                            Global.sharedInstance.currentEditCellOpen = -1
                            Global.sharedInstance.selectedCell[2] = false
                            if flags[i] == true{
                                if Global.sharedInstance.countCellHoursOpenFromEdit > 0{
                                    Global.sharedInstance.countCellHoursOpenFromEdit = 0
                                }
                                Global.sharedInstance.isOpenHoursForNewWorker = false
                            }
                        }
                        selectedCellForEdit[i] = false
                        break
                    }
                }
                Global.sharedInstance.isServiceProviderEditOpen = false
            }
            else
            {
                if isOpen == true//הוספת עובד
                {
                    Global.sharedInstance.isOpenNewWorker = false
                }
                if delegateSaveWorker?.saveDataToWorker() == true
                {
                    //אם הגיע מפלוס
                    if isOpen == true//הוספת עובד +
                    {
                        Global.sharedInstance.isOpenHoursForPlusAction = false
                        isOpen = false
                        Global.sharedInstance.hoursForWorkerFromPlus = false
                        newWorkerIsClose = true
                        Global.sharedInstance.isOpenHoursForPlus = false
                        Global.sharedInstance.isFromSave = true
                        flagsHelp = a
                    }
                    else//עובדים בפעם הראשונה
                    {
                        Global.sharedInstance.isOpenHours = false
                        AppDelegate.isBtnCheck = true
                        if Global.sharedInstance.fisValidWorker == true
                        {
                            Global.sharedInstance.isFromSave = true
                        }
                        else
                        {
                            Global.sharedInstance.isValidWorkerDetails = true
                            Global.sharedInstance.isFromSave = false
                        }
                    }
                    Global.sharedInstance.selectedCell[2] = false
                    Global.sharedInstance.isOpenWorker = false
                    Global.sharedInstance.isOpenNewWorker = false
                }
            }
        }
        else if Global.sharedInstance.currentEditCellOpen == 3//שרותים ומוצרים
        {
            if Global.sharedInstance.selectedCellForEditService.contains(true)//אם יש שרות הפתוח בעריכה
            {
                for i in 0 ..< Global.sharedInstance.selectedCellForEditService.count{//מחפש את הסל שבעריכה וסוגר אותו
                    if Global.sharedInstance.selectedCellForEditService[i] == true{
                        if delegateSaveBussines.saveDataToWorker() == true{
                            let index:IndexPath = IndexPath(row: 0, section: i)
                            let cellMy = ServicesTbl.cellForRow(at: index) as! ServiceInListTableViewCell
                            cellMy.isOpen = false
                            cellMy.isEdit = 0
                            Global.sharedInstance.selectedCellForEditService[i] = false
                            Global.sharedInstance.isFromEditService = false
                            Global.sharedInstance.currentEditCellOpen = -1
                            Global.sharedInstance.selectedCell[3] = false
                            if AppDelegate.countCellEditOpenService > 0{
                                AppDelegate.countCellEditOpenService -= 1
                            }
                            break
                        }
                    }
                }
            }
            else if delegateSaveBussines?.saveDataToWorker() == true//שמירת השרות חדש מ+ ומהפעם הראשונה
            {
                //אם תקין
                Global.sharedInstance.isNewServicePlusOpen = false
                Global.sharedInstance.selectedCell[3] = false
                newServiceIsClose = true
                Global.sharedInstance.isFromFirstSave = true
                Global.sharedInstance.currentEditCellOpen = -1
            }
            else//לא תקין
            {
                if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0
                {
                    Global.sharedInstance.isFromFirstSave = false
                }
                else
                {
                    Global.sharedInstance.isFromFirstSave = true
                }
                Global.sharedInstance.selectedCell[3] = false
                newServiceIsClose = true
                Global.sharedInstance.isNewService = false
                Global.sharedInstance.isNewServicePlusOpen = false
            }
        }
        else if Global.sharedInstance.currentEditCellOpen == 4//הגדרות יומנים
        {

            if delegateSaveCalendar.saveDataToWorker() == true
            {
                Global.sharedInstance.selectedCell[4] = false
            } else {
                Global.sharedInstance.selectedCell[4] = false

        }

        }
    }

    //reload external table
    func reloadTbl()
    {
        self.extTbl.reloadData()
    }

    func reloadHeight()
    {
        //  self.extTbl.endUpdates()
    }
    func beginHeightUpdate() {
        self.extTbl.beginUpdates()
        self.extTbl.endUpdates()
    }
    //איפוס הנתונים השייכים לשעות פעילות
    func setPropertiesOfHoursActiveToDefult()
    {
        Global.sharedInstance.arrWorkHours = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.isHoursSelected = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRest = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRestChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.workingHoursRest = objWorkingHours()
        Global.sharedInstance.arrWorkHoursRest = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.currentBtnDayTag = -1
        Global.sharedInstance.lastBtnDayTag = -1
        Global.sharedInstance.currentBtnDayTagRest = -1
        Global.sharedInstance.lastBtnDayTagRest = -1
        Global.sharedInstance.numbersOfLineInLblHours = 1
        Global.sharedInstance.numbersOfLineInLblRest = 1
        Global.sharedInstance.isBreak = false
        Global.sharedInstance.addRecess = false
        Global.sharedInstance.onOpenTimeOpenHours = false
        Global.sharedInstance.onOpenRecessHours = false
        Global.sharedInstance.isFirstHoursOpen = false
        Global.sharedInstance.isFirstRecessHoursOpen = false
        Global.sharedInstance.isSelectAllHours = false
        Global.sharedInstance.isSelectAllRest = false
        Global.sharedInstance.isSelectAllHoursChild = false
        Global.sharedInstance.isSelectAllRestChild = false
        Global.sharedInstance.isRest = false
        Global.sharedInstance.workingHours = objWorkingHours()
        Global.sharedInstance.hourShow = ""
        Global.sharedInstance.hourShowRecess = ""
        Global.sharedInstance.hourShowChild = ""
        Global.sharedInstance.hourShowRecessChild = ""
        Global.sharedInstance.isHourScrolled = false
        Global.sharedInstance.hourShowFirstWorker = ""
        Global.sharedInstance.hourShowRecessFirstWorker = ""
        Global.sharedInstance.lastLblHoursHeight = 0.0
        Global.sharedInstance.currentLblHoursHeight = 0.0
        Global.sharedInstance.lastLblRestHeight = 0.0
        Global.sharedInstance.currentLblRestHeight = 0.0
        Global.sharedInstance.workingHoursChild = objWorkingHours()
        Global.sharedInstance.arrWorkHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.workingHoursRestChild = objWorkingHours()
        Global.sharedInstance.arrWorkHoursRestChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]

        Global.sharedInstance.currentBtnDayTagChild = -1
        Global.sharedInstance.lastBtnDayTagChild = -1
        Global.sharedInstance.currentBtnDayTagRestChild = -1
        Global.sharedInstance.lastBtnDayTagRestChild = -1
    }

    func showGeneric()
    {
        self.generic.showNativeActivityIndicator(self)
    }

    func hideGeneric()
    {
        self.generic.hideNativeActivityIndicator(self)
    }
    func setPropertiesOfHoursActiveToReread()
    {
        Global.sharedInstance.GlobalDataVC = self
        Global.sharedInstance.delegateValidData = self
        print("aaa \(Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.getDicServiceProviders())")
        ///////////////////////// 1. DOMAIN BUSINESS  ////////////////////////////////////////////////////////////////////////////////////////////////////
        Global.sharedInstance.domainBuisness = ""
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.getDic()
        if let _:Int = dic["iFieldId"]  as? Int{
            let dicgeneraliFieldId:Int = dic["iFieldId"]  as! Int
            //\\print ("dicgen business type id \(dicgeneraliFieldId)")
            Global.sharedInstance.generalDetails.iFieldId = dicgeneraliFieldId
            // AppDelegate.arrDomainFilter[indexPath.row].nvCategoryName
            for i in 0..<AppDelegate.arrDomainFilter.count {
                var domain:Domain = Domain()
                domain = AppDelegate.arrDomainFilter[i]
                if domain.iCategoryRowId == dicgeneraliFieldId {
                    Global.sharedInstance.domainBuisness = domain.nvCategoryName
                    print("Global.sharedInstance.domainBuisness \(Global.sharedInstance.domainBuisness)")
                }
            }
        }
        print("|Global.sharedInstance.generalDetails.iFieldId\(Global.sharedInstance.generalDetails.iFieldId)")
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        Global.sharedInstance.generalDetails.arrObjServiceProviders = []
        Global.sharedInstance.arrObjServiceProvidersForEdit = []
        Global.sharedInstance.generalDetails.arrObjServiceProviders = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjServiceProviders

        print("  arrObjServiceProviders employes\( Global.sharedInstance.generalDetails.arrObjServiceProviders.count )")
        Global.sharedInstance.generalDetails.arrObjProviderServices = []
        Global.sharedInstance.generalDetails.arrObjProviderServices = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices
        print(" arrObjProviderServices servicii  \( Global.sharedInstance.generalDetails.arrObjProviderServices.count )")
        Global.sharedInstance.selectedCellForEditService = []
        Global.sharedInstance.fromEdit = false
        Global.sharedInstance.currentEditCellOpen = -1
        Global.sharedInstance.countCellHoursOpenFromEdit = 0
        Global.sharedInstance.ifOpenCell = false
        Global.sharedInstance.isClickEqual = false
        Global.sharedInstance.isClickNoEqual = false
        Global.sharedInstance.isOpenHours = false
        Global.sharedInstance.fSection5 = false
        Global.sharedInstance.isOpenWorker = false
        Global.sharedInstance.isOpenNewWorker = false
        Global.sharedInstance.isOpenHoursForPlus = false
        Global.sharedInstance.isOpenHoursForNewWorker = false
        Global.sharedInstance.isServiceProviderEditOpen = false
        Global.sharedInstance.isAllFlagsFalse = false
        Global.sharedInstance.isOpenHoursForPlusAction = false
        Global.sharedInstance.isNewService = false
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count > 0 {
            Global.sharedInstance.isFromFirstSave = true
        }
        else {
            Global.sharedInstance.isFromFirstSave = false
        }

        if Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 0 {
            Global.sharedInstance.isFromSave  = true
        }
        else {
            Global.sharedInstance.isFromSave = false
        }



        ////////////////////////////////////////////////////////////////////////////////////////////////////
        Global.sharedInstance.isHoursSelected = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRest = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRestChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.arrWorkHours  = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.isHoursSelected = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRest = [false,false,false,false,false,false,false]
        Global.sharedInstance.hourShow = ""
        Global.sharedInstance.hourShowRecess = ""
        Global.sharedInstance.generalDetails.arrObjWorkingHours = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.arrWorkHoursRest = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        print("si orele \( Global.sharedInstance.generalDetails.arrObjWorkingHours)")
        print("testing \(Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.count)")
        //fast parse of iDayInWeekType
        if Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.count == 0 {
            for i in 1...7 {
                //\\  print("no reg ")
                let emptyelement:objWorkingHours = objWorkingHours()
                emptyelement.iDayInWeekType = i
                emptyelement.nvFromHour = "00:00:00"
                emptyelement.nvToHour = "00:00:00"
                Global.sharedInstance.arrWorkHoursRest[i-1] = emptyelement
                Global.sharedInstance.generalDetails.arrObjWorkingHours[i-1] = emptyelement
            }
        } else {
            for i in 1...7 {
                var hoursinday:Array<objWorkingHours> = []
                for z in 0..<Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.count {
                    //\\    print("aria gasita \(Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours[z].getDic())")
                    let arie:objWorkingHours = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours[z]
                    let ay = arie.iDayInWeekType
                    if ay == i {
                        hoursinday.append(arie)
                    }
                    if hoursinday.count == 0 {
                        //\\     print("no reg ")
                        let emptyelement:objWorkingHours = objWorkingHours()
                        emptyelement.iDayInWeekType = i
                        emptyelement.nvFromHour = "00:00:00"
                        emptyelement.nvToHour = "00:00:00"
                        Global.sharedInstance.arrWorkHoursRest[i-1] = emptyelement
                        Global.sharedInstance.generalDetails.arrObjWorkingHours[i-1] = emptyelement
                    } else  if hoursinday.count == 1 {
                        //\\      print("no cathch")
                        let oneelement:objWorkingHours = hoursinday[0]
                        Global.sharedInstance.generalDetails.arrObjWorkingHours[i-1] = oneelement
                        let emptyelement:objWorkingHours = objWorkingHours()
                        emptyelement.iDayInWeekType = i
                        emptyelement.nvFromHour = "00:00:00"
                        emptyelement.nvToHour = "00:00:00"
                        Global.sharedInstance.arrWorkHoursRest[i-1] = emptyelement
                    } else    if hoursinday.count == 2 {

                        let firstelement:objWorkingHours = hoursinday[0]
                        let secondelement:objWorkingHours = hoursinday[1]
                        let workelement:objWorkingHours = objWorkingHours()
                        let restlement:objWorkingHours = objWorkingHours()
                        workelement.iDayInWeekType = i
                        restlement.iDayInWeekType = i
                        workelement.nvFromHour = firstelement.nvFromHour
                        workelement.nvToHour = secondelement.nvToHour
                        restlement.nvFromHour = firstelement.nvToHour
                        restlement.nvToHour = secondelement.nvFromHour
                        Global.sharedInstance.generalDetails.arrObjWorkingHours[i - 1] = workelement
                        Global.sharedInstance.arrWorkHoursRest[i - 1] = restlement
                    }
                }
            }
        }
        //        for item in Global.sharedInstance.generalDetails.arrObjWorkingHours {
        //              print("nowis \(item.description)")
        //        }
        //        for itemz in Global.sharedInstance.arrWorkHoursRest {
        //              print("noweeeis \(itemz.description)")
        //        }

        Global.sharedInstance.isSelectAllHours = false
        Global.sharedInstance.isSelectAllRest = false
        var simplearr:Array<Int> = []
        for y in 1...7 {
            for i in 0..<Global.sharedInstance.generalDetails.arrObjWorkingHours.count {
                let arie:objWorkingHours = Global.sharedInstance.generalDetails.arrObjWorkingHours[i]
                let ay = arie.iDayInWeekType
                let fromh:String =  arie.nvFromHour
                let toh:String = arie.nvToHour
                if ay == y  {
                    if fromh == "00:00:00" && toh == "00:00:00" {
                        //nothing fill empty
                        Global.sharedInstance.arrWorkHours[y - 1] = arie
                        simplearr.append(y)
                    }else {
                        Global.sharedInstance.arrWorkHours[y - 1] = arie
                        Global.sharedInstance.isHoursSelected[y - 1] = true
                    }
                }
            }
        }
        if simplearr.count > 0 {
            Global.sharedInstance.isSelectAllHours = false
        } else {
            Global.sharedInstance.isSelectAllHours = true
        }
        simplearr = []
        Global.sharedInstance.isRest = false
        for y in 1...7 {
            for i in 0..<Global.sharedInstance.arrWorkHoursRest.count {
                let arie:objWorkingHours = Global.sharedInstance.arrWorkHoursRest[i]
                let ay = arie.iDayInWeekType
                let fromh:String =  arie.nvFromHour
                let toh:String = arie.nvToHour
                if ay == y  {
                    if fromh == "00:00:00" && toh == "00:00:00" {
                        //nothing
                        simplearr.append(y)
                    }else {
                        Global.sharedInstance.isHoursSelectedRest[y - 1] = true
                        Global.sharedInstance.isRest = true
                    }
                }
            }
        }
        if simplearr.count > 0 {
            Global.sharedInstance.isSelectAllRest = false
        } else {
            Global.sharedInstance.isSelectAllRest = true
        }


        Global.sharedInstance.workingHoursRest = objWorkingHours()
        //        for i in 0..<Global.sharedInstance.arrWorkHours.count {
        //            let arrWorkHours:objWorkingHours = Global.sharedInstance.arrWorkHours[i]
        //            //\\print ("arrWorkHours \(arrWorkHours.getDic())")
        //        }
        //        for i in 0..<Global.sharedInstance.arrWorkHoursRest.count {
        //            let arrWorkHours:objWorkingHours = Global.sharedInstance.arrWorkHoursRest[i]
        //            //\\print ("arrWorkHoursRest \(arrWorkHours.getDic())")
        //        }

        //
        var DayFlagArr = [0,0,0,0,0,0,0]
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelected[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHours[i].nvFromHour != "" && !(Global.sharedInstance.arrWorkHours[i].nvFromHour == "00:00:00" && Global.sharedInstance.arrWorkHours[i].nvToHour == "00:00:00")
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelected[j] == true
                            {
                                if Global.sharedInstance.arrWorkHours[i].nvFromHour == Global.sharedInstance.arrWorkHours[j].nvFromHour &&
                                    Global.sharedInstance.arrWorkHours[i].nvToHour == Global.sharedInstance.arrWorkHours[j].nvToHour
                                {
                                    Global.sharedInstance.hourShow = "\(Global.sharedInstance.hourShow) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShow = String(Global.sharedInstance.hourShow.characters.dropLast())
                        Global.sharedInstance.hourShow = "\(Global.sharedInstance.hourShow) - "
                        if Global.sharedInstance.isHoursSelected[i] == true
                        {
                            Global.sharedInstance.hourShow = "\(Global.sharedInstance.hourShow) \(cutHour(Global.sharedInstance.arrWorkHours[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHours[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShow = String(Global.sharedInstance.hourShow.characters.dropLast())


        Global.sharedInstance.hourShowRecess = ""
        DayFlagArr = [0,0,0,0,0,0,0]
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedRest[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHoursRest[i].nvFromHour != "" && !(Global.sharedInstance.arrWorkHoursRest[i].nvFromHour == "00:00:00" && Global.sharedInstance.arrWorkHoursRest[i].nvToHour == "00:00:00")
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelectedRest[j] == true
                            {
                                if Global.sharedInstance.arrWorkHoursRest[i].nvFromHour == Global.sharedInstance.arrWorkHoursRest[j].nvFromHour && Global.sharedInstance.arrWorkHoursRest[i].nvToHour == Global.sharedInstance.arrWorkHoursRest[j].nvToHour
                                {
                                    Global.sharedInstance.hourShowRecess = "\(Global.sharedInstance.hourShowRecess) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShowRecess = String(Global.sharedInstance.hourShowRecess.characters.dropLast())
                        Global.sharedInstance.hourShowRecess = "\(Global.sharedInstance.hourShowRecess) - "
                        if Global.sharedInstance.isHoursSelectedRest[i] == true
                        {
                            Global.sharedInstance.hourShowRecess = "\(Global.sharedInstance.hourShowRecess) \(cutHour(Global.sharedInstance.arrWorkHoursRest[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHoursRest[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShowRecess = String(Global.sharedInstance.hourShowRecess.characters.dropLast())

        if Global.sharedInstance.hourShowRecess != ""
        {
            Global.sharedInstance.hourShowRecess = "\("RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)):\(Global.sharedInstance.hourShowRecess)"
        }
        print(") Global.sharedInstance.hourShowRecess \(Global.sharedInstance.hourShowRecess)")

        //rest h

        //\\  print(") Global.sharedInstance.NOWORKINGDAYS \(Global.sharedInstance.NOWORKINGDAYS)")
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        ///////////////////////// 3. EMPLOYES WORKING AND REST HOURS CHILD     ////////////////////////////////////////////////////////////////////////////////////////////////////
        Global.sharedInstance.isHoursSelectedChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRestChild = [false,false,false,false,false,false,false]

        Global.sharedInstance.isClickNoEqual = false
        Global.sharedInstance.isClickEqual = false
        Global.sharedInstance.clickNoCalendar = false




        Global.sharedInstance.currentBtnDayTag = -1
        Global.sharedInstance.lastBtnDayTag = -1
        Global.sharedInstance.currentBtnDayTagRest = -1
        Global.sharedInstance.lastBtnDayTagRest = -1
        Global.sharedInstance.numbersOfLineInLblHours = 1
        Global.sharedInstance.numbersOfLineInLblRest = 1
        Global.sharedInstance.isBreak = false
        Global.sharedInstance.addRecess = false
        Global.sharedInstance.onOpenTimeOpenHours = false


        Global.sharedInstance.isFirstHoursOpen = false

        Global.sharedInstance.workingHours = objWorkingHours()
        Global.sharedInstance.isSelectAllHoursChild = false
        Global.sharedInstance.isSelectAllRestChild = false
        Global.sharedInstance.workingHoursChild = objWorkingHours()
        Global.sharedInstance.arrWorkHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.workingHoursRestChild = objWorkingHours()
        Global.sharedInstance.arrWorkHoursRestChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.currentBtnDayTagChild = -1
        Global.sharedInstance.lastBtnDayTagChild = -1
        Global.sharedInstance.currentBtnDayTagRestChild = -1
        Global.sharedInstance.lastBtnDayTagRestChild = -1

        if  Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 0 {
            for i in 0..<Global.sharedInstance.generalDetails.arrObjServiceProviders.count {
                let ax = Global.sharedInstance.generalDetails.arrObjServiceProviders[i]
                var arrObjWorkingHoursChild:Array<objWorkingHours> = Array<objWorkingHours>()
                var arrObjRestHoursChild:Array<objWorkingHours> = Array<objWorkingHours>()
                arrObjWorkingHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
                arrObjRestHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
                var ish = [false, false, false, false, false, false, false]
                var ishrest = [false, false, false, false, false, false, false]
                if ax.arrObjWorkingHours.count == 0 {
                    for i in 1...7 {
                        //\\   print("no reg ")
                        let emptyelement:objWorkingHours = objWorkingHours()
                        emptyelement.iDayInWeekType = i
                        emptyelement.nvFromHour = "00:00:00"
                        emptyelement.nvToHour = "00:00:00"
                        arrObjWorkingHoursChild[i-1] = emptyelement
                        arrObjRestHoursChild[i-1] = emptyelement
                    }
                } else {
                    for i in 1...7 {
                        var hoursinday:Array<objWorkingHours> = []
                        for z in 0..<ax.arrObjWorkingHours.count {
                            //\\     print("aria gasita 111 \(ax.arrObjWorkingHours[z].getDic())")
                            let arie:objWorkingHours = ax.arrObjWorkingHours[z]
                            let ay = arie.iDayInWeekType
                            if ay == i {
                                hoursinday.append(arie)
                            }
                            if hoursinday.count == 0 {
                                //\\      print("no reg 111")
                                let emptyelement:objWorkingHours = objWorkingHours()
                                emptyelement.iDayInWeekType = i
                                emptyelement.nvFromHour = "00:00:00"
                                emptyelement.nvToHour = "00:00:00"
                                arrObjWorkingHoursChild[i-1] = emptyelement
                                arrObjRestHoursChild[i-1] = emptyelement
                            } else  if hoursinday.count == 1 {
                                //\\      print("no cathch 1111")
                                let oneelement:objWorkingHours = hoursinday[0]
                                arrObjWorkingHoursChild[i-1] = oneelement
                                let emptyelement:objWorkingHours = objWorkingHours()
                                emptyelement.iDayInWeekType = i
                                emptyelement.nvFromHour = "00:00:00"
                                emptyelement.nvToHour = "00:00:00"
                                arrObjRestHoursChild[i-1] = emptyelement
                            } else    if hoursinday.count == 2 {
                                //\\    print("this cathch 1111")
                                let firstelement:objWorkingHours = hoursinday[0]
                                let secondelement:objWorkingHours = hoursinday[1]
                                let workelement:objWorkingHours = objWorkingHours()
                                let restlement:objWorkingHours = objWorkingHours()
                                workelement.iDayInWeekType = i
                                restlement.iDayInWeekType = i
                                //bug in employe
                                //
                                //                                workelement.nvFromHour = firstelement.nvFromHour
                                //                                workelement.nvToHour = firstelement.nvToHour
                                //                                restlement.nvFromHour = secondelement.nvFromHour
                                //                                restlement.nvToHour = secondelement.nvToHour
                                //bellow shall fix read
                                workelement.nvFromHour = firstelement.nvFromHour
                                workelement.nvToHour = secondelement.nvToHour
                                restlement.nvFromHour = firstelement.nvToHour
                                restlement.nvToHour = secondelement.nvFromHour
                                arrObjWorkingHoursChild[i - 1] = workelement
                                arrObjRestHoursChild[i - 1] = restlement
                            }
                        }
                    }
                }
                for z in 0..<arrObjWorkingHoursChild.count {
                    print("aria gasita worker \(arrObjWorkingHoursChild[z].getDic())")
                }
                for z in 0..<arrObjRestHoursChild.count {
                    print("aria gasita rest worker \(arrObjRestHoursChild[z].getDic())")
                }
                var isSelectAllHours:Bool = false
                var isSelectAllRecess:Bool = false
                var simplearr:Array<Int> = []
                for y in 1...7 {
                    for i in 0..<arrObjWorkingHoursChild.count {
                        let arie:objWorkingHours = arrObjWorkingHoursChild[i]
                        let ay = arie.iDayInWeekType
                        let fromh:String =  arie.nvFromHour
                        let toh:String = arie.nvToHour
                        if ay == y  {
                            if fromh == "00:00:00" && toh == "00:00:00" {
                                //nothing fill empty
                                ish[y - 1] = false
                                simplearr.append(y)
                            }else {
                                ish[y - 1] = true
                            }
                        }
                    }
                }
                if simplearr.count > 0 {
                    isSelectAllHours = false
                } else {
                    isSelectAllHours = true
                }
                simplearr = []
                for y in 1...7 {
                    for i in 0..<arrObjRestHoursChild.count {
                        let arie:objWorkingHours = arrObjRestHoursChild[i]
                        let ay = arie.iDayInWeekType
                        let fromh:String =  arie.nvFromHour
                        let toh:String = arie.nvToHour
                        if ay == y  {
                            if fromh == "00:00:00" && toh == "00:00:00" {
                                //nothing
                                simplearr.append(y)
                            }else {
                                ishrest[y - 1] = true
                                //\\
                            }
                        }
                    }
                }
                if simplearr.count > 0 {
                    isSelectAllRecess = false
                } else {
                    isSelectAllRecess = true
                }
                //\\    print("x.bSameWH \(ax.bSameWH)")
                let serviceProvidersForEdit = objServiceProvidersForEdit(
                    _objsers: ax.objsers,
                    _arrObjWorkingHours: arrObjWorkingHoursChild,
                    _arrObjWorkingRest: arrObjRestHoursChild,
                    _isHoursSelected: ish,
                    _isHoursSelectedRest:ishrest,
                    _isSelectAllHours: isSelectAllHours,
                    _isSelectAllRecess: isSelectAllRecess,
                    _bSameWH: ax.bSameWH)
                Global.sharedInstance.arrObjServiceProvidersForEdit.append(serviceProvidersForEdit)
            }
        }

        Global.sharedInstance.hourShowFirstWorker = ""
        Global.sharedInstance.hoursForWorkerFromEdit = false
        if  Global.sharedInstance.arrObjServiceProvidersForEdit.count > 0 {
            let ax = Global.sharedInstance.arrObjServiceProvidersForEdit[0]
            if ax.bSameWH == false {
                Global.sharedInstance.isClickNoEqual = true
                Global.sharedInstance.isClickEqual  = false
                Global.sharedInstance.clickNoCalendar = false
            }
            else {
                Global.sharedInstance.isClickNoEqual = false
                Global.sharedInstance.isClickEqual  = true
                Global.sharedInstance.clickNoCalendar = false
            }
            //now first worker hours and rest
            DayFlagArr = [0,0,0,0,0,0,0]
            for i in 0 ..< 7
            {
                if ax.isHoursSelected[i] == true
                {
                    if DayFlagArr[i] != 1
                    {
                        if ax.arrObjWorkingHours[i].nvFromHour != "" && !(ax.arrObjWorkingHours[i].nvFromHour == "00:00:00" && ax.arrObjWorkingHours[i].nvToHour == "00:00:00")
                        {
                            for j in 0 ..< 7
                            {
                                if ax.isHoursSelected[j] == true
                                {
                                    if ax.arrObjWorkingHours[i].nvFromHour == ax.arrObjWorkingHours[j].nvFromHour &&
                                        ax.arrObjWorkingHours[i].nvToHour == ax.arrObjWorkingHours[j].nvToHour
                                    {
                                        Global.sharedInstance.hourShowFirstWorker = "\(Global.sharedInstance.hourShowFirstWorker) \(convertDays(j)),"
                                        DayFlagArr[j] = 1
                                    }
                                }
                            }
                            Global.sharedInstance.hourShowFirstWorker = String(Global.sharedInstance.hourShowFirstWorker.characters.dropLast())
                            Global.sharedInstance.hourShowFirstWorker = "\(Global.sharedInstance.hourShowFirstWorker) - "
                            if ax.isHoursSelected[i] == true
                            {
                                Global.sharedInstance.hourShowFirstWorker = "\( Global.sharedInstance.hourShowFirstWorker) \(cutHour(ax.arrObjWorkingHours[i].nvFromHour))-\(cutHour(ax.arrObjWorkingHours[i].nvToHour)),"
                            }
                        }
                    }
                }
            }
        }
        print(")  Global.sharedInstance.hourShowFirstWorker \( Global.sharedInstance.hourShowFirstWorker)")
        Global.sharedInstance.hoursForWorker = false
        //rest h first worker
        Global.sharedInstance.hourShowRecessFirstWorker = ""
        if  Global.sharedInstance.arrObjServiceProvidersForEdit.count > 0 {
            let ax = Global.sharedInstance.arrObjServiceProvidersForEdit[0]
            DayFlagArr = [0,0,0,0,0,0,0]
            for i in 0 ..< 7
            {
                if ax.isHoursSelectedRest[i] == true
                {
                    if DayFlagArr[i] != 1
                    {
                        if ax.arrObjWorkingRest[i].nvFromHour != "" && !(ax.arrObjWorkingRest[i].nvFromHour == "00:00:00" && ax.arrObjWorkingRest[i].nvToHour == "00:00:00")
                        {
                            for j in 0 ..< 7
                            {
                                if ax.isHoursSelectedRest[j] == true
                                {
                                    if ax.arrObjWorkingRest[i].nvFromHour == ax.arrObjWorkingRest[j].nvFromHour && ax.arrObjWorkingRest[i].nvToHour == ax.arrObjWorkingRest[j].nvToHour
                                    {
                                        Global.sharedInstance.hourShowRecessFirstWorker = "\(Global.sharedInstance.hourShowRecessFirstWorker) \(convertDays(j)),"
                                        DayFlagArr[j] = 1
                                    }
                                }
                            }
                            Global.sharedInstance.hourShowRecessFirstWorker = String(Global.sharedInstance.hourShowRecessFirstWorker.characters.dropLast())
                            Global.sharedInstance.hourShowRecessFirstWorker = "\(Global.sharedInstance.hourShowRecessFirstWorker) - "
                            if ax.isHoursSelectedRest[i] == true
                            {
                                Global.sharedInstance.hourShowRecessFirstWorker = "\(Global.sharedInstance.hourShowRecessFirstWorker) \(cutHour(ax.arrObjWorkingRest[i].nvFromHour))-\(cutHour(ax.arrObjWorkingRest[i].nvToHour)),"
                            }
                        }
                    }
                }
            }
            Global.sharedInstance.hourShowRecessFirstWorker = String(Global.sharedInstance.hourShowRecessFirstWorker.characters.dropLast())
            if Global.sharedInstance.hourShowRecessFirstWorker != ""
            {
                Global.sharedInstance.hourShowRecessFirstWorker = "\("RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)):\(Global.sharedInstance.hourShowRecessFirstWorker)"
            }
        }
        print(")   Global.sharedInstance.hourShowRecessFirstWorker \(  Global.sharedInstance.hourShowRecessFirstWorker)")
        Global.sharedInstance.isHourScrolled = false
        Global.sharedInstance.lastLblHoursHeight = 0.0
        Global.sharedInstance.currentLblHoursHeight = 0.0
        Global.sharedInstance.lastLblRestHeight = 0.0
        Global.sharedInstance.currentLblRestHeight = 0.0
        Global.sharedInstance.selectedCell = [false,false,  false, false,false,false]
        newWorkerIsClose = true
        newServiceIsClose = true
        Global.sharedInstance.isFirst = false
        Global.sharedInstance.isFirstBussinesServices = false
        Global.sharedInstance.isFirstCalenderSetting = false
        if Global.sharedInstance.isHoursSelectedRest.contains(true) {
            Global.sharedInstance.onOpenRecessHours = true
            Global.sharedInstance.isFirstRecessHoursOpen = true
        } else {
            Global.sharedInstance.onOpenRecessHours = false
            Global.sharedInstance.isFirstRecessHoursOpen = false
        }
        for a in Global.sharedInstance.isHoursSelectedRest {
            print("4444422hselectedrest \(a)")
        }
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        ///////////////////////// 4. SERVICES  ////////////////////////////////////////////////////////////////////////////////////////////////////


        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        ///////////////////////// 5. APPOINTMENTS SETTING  ////////////////////////////////////////////////////////////////////////////////////////////////////

        print("calendarset \(  Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties.getDic())")
        Global.sharedInstance.generalDetails.calendarProperties = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties


        self.reloadServicesTable(self.ServicesTbl)
        self.daysTbl.reloadData()
        self.hoursTbl.reloadData()
        self.ReloadTableWorkers(self.WorkersTbl)
        self.WorkersTbl.reloadData()
        extTbl.reloadData()

        for a in Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours {
    print(a.getDic())
        }
        Global.sharedInstance.NEWARRAYOBJWORKINGHOURS = Array<objWorkingHours>()
        Global.sharedInstance.NEWARRAYOBJWORKINGHOURS  = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours


    }

    func cutHour(_ hour:String) -> String {
        var fixedHour = String(hour.characters.dropLast())
        fixedHour = String(fixedHour.characters.dropLast())
        fixedHour = String(fixedHour.characters.dropLast())
        return fixedHour
    }

    func convertDays(_ day:Int) -> String {
        switch day {
        case 0:
            return "SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 1:
            return "MONDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 2:
            return "TUESDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 3:
            return "WEDNSDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 4:
            return "THIRTHDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 5:
            return "FRIDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 6:
            return "SHABAT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        default:
            return "SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
    }
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        print("label.frame.height \(label.frame.height)")
        return label.frame.height
    }
    func lineCountForLabel(_ label:UILabel) -> Int
    {
        var lineCount: Int = 0
        let labelSize:CGSize = CGSize(width:label.frame.size.width, height: label.frame.size.height)
        let requiredSize: CGRect = label.text!.boundingRect(with: labelSize, options: .usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): label.font]), context: nil)

        let charSize = lroundf(Float(label.font.lineHeight));
        let rHeight: Int = lroundf(Float(requiredSize.height))
        lineCount = rHeight / charSize

        return lineCount
    }


}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
