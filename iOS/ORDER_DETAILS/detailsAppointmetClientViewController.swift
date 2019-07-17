//
//  detailsAppointmetClientViewController.swift
//  Bthere
//
//  Created by User on 11.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import MarqueeLabel
import Kronos


protocol openCustomerDelegate {
    func openCustomer()
    func openMycustomers()
}

protocol getCustomerOrdersDelegate {
    func GetCustomerOrders()
}
//פרטי התור
class detailsAppointmetClientViewController: NavigationModelViewController,openCustomerDelegate,openFromMenuDelegate,getCustomerOrdersDelegate,UITextViewDelegate,UIGestureRecognizerDelegate{
    //MARK: - Properties
    var iHoursForPreCancelServiceByCustomer = 0
    var bIsAvailableForNewCustomer = 0
    @IBOutlet weak var CentralButton:UIView!
    @IBOutlet weak var  CentralButtonImg:UIImageView!
    @IBOutlet weak var butonwidth: NSLayoutConstraint!
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var tag:Int = 0//מציין האם הגיעו מלחיצה על תור פנוי או מלליצה על תור של ביזר תפוס,1=פנוי,2=תפוס
    var isfromSPECIALSUPPLIER:Bool = false
    var isfromSPECIALiCustomerUserId:Int = 0
    var currentDate:Date = Date()
    let calendar = Foundation.Calendar.current
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var cancelOrderID:Int = 0
    var viewpop: PopUpGenericViewController!
    var showDetailsAppointmentViewController:Bool = true
    var fromViewMode = false
    var generic:Generic = Generic()
    var delegateSetNewOrder:setNewOrderDelegate!=nil
    var clientStoryBoard:UIStoryboard?
    var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    let dateFormatter = DateFormatter()
    let dateFormatter1 = DateFormatter()
    var iSupplierId:Int = 0
    var nvPhone:String = ""
    var dateEvent:Date = Date()
    var fromHour:String = ""
    var hourFreeEventEnd:String = ""
    var supplierName:String = ""
    var serviceName:String = ""
    var address:String = ""
    var appointmentTime:String = ""
    var appointmentLocation: String = ""

    var didClickOK:Bool = false//מציין אם כבר לחצו על אישור פעם אחת כדי למנוע לחיצה כפולה

    var timer: Timer? = nil
    var isFromMyAppointments = false
    var currentSupplierId:Int = -1
    var nrOrders = -1
    var isPastAppointment:Bool = false

    var storyboard1:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //MARK: - Outlet

    var specialdateEvent:Date = Date()
    @IBOutlet var newsDealsLabel: MarqueeLabel!
    @IBOutlet weak var lblSupllierName: UILabel!
    @IBOutlet weak var lblSupplierService: UILabel!
    @IBOutlet weak var imgPlusMenu: UIImageView!
    @IBOutlet weak var englishPlusMenu: UIImageView!
    @IBOutlet weak var lblSupplierAddress: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    // @IBOutlet weak var lblAdvertising: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    //בלחיצה על ביטול
    @IBAction func btnCancel(_ sender: AnyObject) {
        Global.sharedInstance.isCancelAppointmentClick = true
        showDetailsAppointmentViewController = false
        DispatchQueue.main.async {
            self.GetCustomerOrders()
        }
        print("cancel btn cel bun")
    }
    @IBOutlet weak var btncancelORDER: UIButton!  //only on existing bthere event
    @IBOutlet weak var btnClose: UIButton! //back arrow
    @IBOutlet weak var btnBACKARROW: UIButton! // back arrow screen
    @IBOutlet weak var viewCancel: UIView! //cancel existing bthere event
    @IBOutlet weak var lblTitle: UILabel! //title screen
    @IBOutlet weak var titlescreen: UILabel!
    @IBOutlet weak var messagescreen: UILabel!
    @IBOutlet weak var btnClosePopup: UIButton!
    @IBOutlet weak var btncancelApp: UIButton!  //only on existing bthere event
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet var shortDelayButton: UIButton!
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var topViewConstraint: NSLayoutConstraint!


    @IBAction func btnClosePopup(_ sender: AnyObject) {
        view.endEditing(true)
        viewCancel.isHidden = true
    }


    @IBAction func btnBACKARROW(_ sender: UIButton) {
        dismiss()
    }
    @IBAction func btncancelORDER(_ sender: UIButton) {
        print("cancelation btn")
        //SEE IF PROVIDER BLOCKED 24 H
        GetProviderSettingsForCalendarmanagement(_ORDERPROVIDERID: self.iSupplierId)
        // Show pop out for cancel





    }


    // Show Short Delay view
    @IBAction func shortDelayButton(_ sender: AnyObject) {

        let clientStoryBoard2 = UIStoryboard(name: "ClientExist", bundle: nil)
        let viewCon:slaightLateViewController = clientStoryBoard2.instantiateViewController(withIdentifier: "slaightLateViewController") as! slaightLateViewController
        viewCon.iCoordinatedServiceId = Global.sharedInstance.orderDetailsFoBthereEvent.iCoordinatedServiceId
        viewCon.service = lblSupplierService.text!
        viewCon.serviceName = lblSupllierName.text!
        Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName = viewCon.serviceName
        viewCon.date = lblDate.text!
        viewCon.hour = lblHour.text!
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)

    }




    @objc func openPlusMenuNewCustomer(){
        if let _ =  Bundle.main.loadNibNamed("PlusMenu3CirclesNewCustomer", owner: self, options: nil)?.first as? PlusMenuNewCustomer
        {
            let openpopmenu = Bundle.main.loadNibNamed("PlusMenu3CirclesNewCustomer", owner: self, options: nil)?.first as! PlusMenuNewCustomer
            openpopmenu.frame = self.view.frame
            self.view.addSubview(openpopmenu)
            self.view.bringSubviewToFront(openpopmenu)
        }
    }
    @objc func openPlusMenuNewProvider(){
        if let _ =  Bundle.main.loadNibNamed("PlusMenuNewSupplier", owner: self, options: nil)?.first as? PlusMenuNewSupplier
        {
            let openpopmenu = Bundle.main.loadNibNamed("PlusMenuNewSupplier", owner: self, options: nil)?.first as! PlusMenuNewSupplier
            openpopmenu.frame = self.view.frame
            self.view.addSubview(openpopmenu)
            self.view.bringSubviewToFront(openpopmenu)
        }
    }



    @IBAction func btncancelApp(_ sender: UIButton) {

        btncancelApp.isUserInteractionEnabled = false
        cancelOrder(cancelOrderID)
    }
    //לחיצה על אישור
    @IBAction func btnOk(_ sender: UIButton) {

        let USERDEF = Global.sharedInstance.defaults
        print("aici userdef: \(USERDEF.value(forKey: "isfromSPECIALiCustomerUserId"))")

        if didClickOK == false
        {
            didClickOK = true
            let uniqueVals = uniq(Global.sharedInstance.arrayServicesKodsToServer)
            var sumofservicetime:Int = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices.count > 0 {
                for service in Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices {
                    print(service.getDic())
                    let idservice = service.iProviderServiceId
                    if uniqueVals.contains(idservice) {
                        let servicetime = service.iTimeOfService
                        sumofservicetime = sumofservicetime + servicetime
                    }
                }
            }
            print("sumofservicetime\(sumofservicetime)")
            print(Global.sharedInstance.iServiceTimeSUM)
            if sumofservicetime == 0 {
                sumofservicetime = 2 //just to make sure end date si greater than start date
            }

            var dateToServer = Global.sharedInstance.dateDayClick

            //אם מתצוגת שבוע הוספתי יום- כי התאריך שהתקבל הוא מיום קודם
            if Global.sharedInstance.whichDesignOpenDetailsAppointment == 2
            {
                dateToServer = Calendar.sharedInstance.addDay(Global.sharedInstance.dateDayClick)
            }
            //mass MOD
            var order:OrderObj = OrderObj()
            if self.isfromSPECIALiCustomerUserId != 0 {
                order = OrderObj(_iSupplierId: Global.sharedInstance.providerID, _iUserId: self.isfromSPECIALiCustomerUserId, _iSupplierUserId: Global.sharedInstance.arrayGiveServicesKods, _iProviderServiceId:uniqueVals /*Global.sharedInstance.arrayServicesKodsToServer*/, _dtDateOrder:dateToServer,_nvFromHour: Global.sharedInstance.hourFreeEvent, _nvComment: "",_nvToHour:"")
            } else {
                order = OrderObj(_iSupplierId: Global.sharedInstance.providerID, _iUserId: Global.sharedInstance.currentUser.iUserId, _iSupplierUserId: Global.sharedInstance.arrayGiveServicesKods, _iProviderServiceId:uniqueVals /*Global.sharedInstance.arrayServicesKodsToServer*/, _dtDateOrder:dateToServer,_nvFromHour: Global.sharedInstance.hourFreeEvent, _nvComment: "",_nvToHour:"")
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
            var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

            //\\print(Global.sharedInstance.dateDayClick.description)
            dicOrderObj["orderObj"] = order.getDic() as AnyObject

            if tag != 4//לא מתור חדש
            {
                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)
                    //                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                }
                else
                {


                    api.sharedInstance.newOrder(dicOrderObj, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            print("neworder RESPONSEOBJECT \(RESPONSEOBJECT)")
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {


                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//אם אין תור פנוי בזמן הזה
                                {
                                    if self.fromViewMode == true
                                    {
                                        let alert = UIAlertController(title: "", message: "THX_REGISTERED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                                        self.present(alert, animated: true, completion: nil)
                                        // change to desired number of seconds (in this case 6 seconds)
                                        let when = DispatchTime.now() + 1
                                        DispatchQueue.main.asyncAfter(deadline: when){
                                            // your code with delay
                                            alert.dismiss(animated: true, completion: nil)
                                            self.doDelayed()
                                        }
                                        //                                self.showAlertDelegateX("THX_REGISTERED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                        //
                                        //                               self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.doDelayed), userInfo: nil, repeats: false)
                                    }
                                    else
                                    {
                                        let alert = UIAlertController(title: "", message: "ERR_FREE_H_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                                        self.present(alert, animated: true, completion: nil)
                                        // change to desired number of seconds (in this case 6 seconds)
                                        let when = DispatchTime.now() + 3
                                        DispatchQueue.main.asyncAfter(deadline: when){
                                            // your code with delay
                                            alert.dismiss(animated: true, completion: nil)
                                            self.dismiss()

                                        }
                                    }
                                }
                                else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1//הצליח
                                {
                                    print("Global.sharedInstance.currentUser.bIsGoogleCalendarSync: \(Global.sharedInstance.currentUser.bIsGoogleCalendarSync)")
                                    // Check if calendar is synchronized
                                    if let _ = dicOrderObj["orderObj"]?["iSupplierId"] as? Int
                                    {
                                        print ( "id supplier \(String(describing: dicOrderObj["orderObj"]!["iSupplierId"]))")
                                        self.currentSupplierId = dicOrderObj["orderObj"]?["iSupplierId"] as! Int
                                        print ("supplier name: \(Global.sharedInstance.currentProviderToCustomer.nvProviderName)")
                                    }

                                    if let _ = RESPONSEOBJECT["nrOrders"] as? Int
                                    {
                                        self.nrOrders = RESPONSEOBJECT["nrOrders"] as! Int
                                    }
                                    //                            self.nrOrders = 3


                                    if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true)
                                    {

                                        Global.sharedInstance.eventBthereDateStart = order.dtDateOrder
                                        //     Global.sharedInstance.eventBthereDateEnd =   Calendar.sharedInstance.addDay(Global.sharedInstance.eventBthereDateStart)
                                        self.saveEventInDeviceCalander(addminutes: Global.sharedInstance.iServiceTimeSUM)
                                    }
                                    else
                                    {

                                    }
                                    if Global.sharedInstance.currentUser.iUserId != 0 {
                                        self.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                                    }
                                    DispatchQueue.main.async {
                                        self.GetCustomerOrders()
                                    }

                                }
                                    //in case of 2 no event can be save this is special case so he just recieve push from server
                                    //in case of 3 customer was rejected and cannot make appointment
                                else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 3  || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 4 //
                                {
                                    self.showDetailsAppointmentViewController = false
                                    DispatchQueue.main.async {
                                        self.GetCustomerOrders()
                                    }
                                }
                                else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//שגיאה
                                {
                                    Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                }
                                else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3//שגיאה
                                {
                                    Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                }
                            }
                        }

                    },failure: {
                        (AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        //                            if Global.sharedInstance.currentUser.iUserId != 0 {
                        //                                api.sharedInstance.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                        //                            }
                        //                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    })
                }
            }
            else//מתור חדש
            {
                Global.sharedInstance.nameOfCustomer = ""
                delegateSetNewOrder.setNewOrder()
            }
        }
    }




    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    //MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Global.sharedInstance.isInMeetingProcess = 1
        GoogleAnalyticsSendEvent(x:28)
        

        self.getnews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global.sharedInstance.isInMeetingProcess = 0
    }
    func getnews(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //    dic["iLanguageId"] = finalIntforlang

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
                            self.newsDealsLabel.tag = 101
                            self.newsDealsLabel.type = .continuous
                            self.newsDealsLabel.animationCurve = .linear
                            self.newsDealsLabel.type = .leftRight
                            self.newsDealsLabel.text  = abcd
                            self.newsDealsLabel.restartLabel()
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
    func moreexactlocalizablestringsfordays(_ day:Int) -> String {
        switch day {
        case 1:
            return "SUNDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 2:
            return "MONDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 3:
            return "TUESDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 4:
            return "WEDNSDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 5:
            return "THIRTHDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 6:
            return "FRIDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 7:
            return "SHABAT_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        default:
            return "SUNDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("iSupplierId iustin: \(iSupplierId)")
        print("nvPhone \(nvPhone)")
        print("serviceName: \(serviceName)")
        print("cancelOrderID: \(cancelOrderID)")
        print("supplierName: \(supplierName)")
        print("fromHour: \(fromHour)")

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
        if UIDevice.current.userInterfaceIdiom == .pad {
            butonwidth.constant = 80
        } else {
            butonwidth.constant = 70
        }
        self.getnews()
        self.newsDealsLabel.restartLabel()

        //    newsDealsLabel.text = Global.sharedInstance.newslabel


        if (isFromMyAppointments == true) {
            // Hide plus menu

            if (UIDevice.current.userInterfaceIdiom != .pad) {
                topViewConstraint.constant = 64
            }

            imgPlusMenu.isHidden = true
            newsDealsLabel.isHidden = true
        }


        btncancelORDER.isHidden = true
        shortDelayButton.isHidden = true


        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        btnBACKARROW.imageView!.contentMode = .scaleAspectFit
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            btnBACKARROW.transform = scalingTransform
            backImage.transform = scalingTransform
        }

        if isfromSPECIALSUPPLIER == true {
            Global.sharedInstance.canselectmultiple = true
            let USERDEF = UserDefaults.standard
            USERDEF.set(1, forKey: "isfromSPECIALSUPPLIER")
            USERDEF.synchronize()
            let tapOpenPlusMenuNewProvider:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewProvider))
            tapOpenPlusMenuNewProvider.delegate = self
            CentralButton.addGestureRecognizer(tapOpenPlusMenuNewProvider)
            CentralButtonImg.image = UIImage(named: "Plus menu icon - Supplier")
        } else {
            let USERDEF = UserDefaults.standard
            USERDEF.set(0, forKey: "isfromSPECIALSUPPLIER")
            USERDEF.synchronize()
            let tapOpenPlusMenuNewCustomer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewCustomer))
            tapOpenPlusMenuNewCustomer.delegate = self
            CentralButton.addGestureRecognizer(tapOpenPlusMenuNewCustomer)
            CentralButtonImg.image = UIImage(named: "Plus menu icon - Customer")
        }

        //     let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(detailsAppointmetClientViewController.imageTapped))
        //
        //        if isfromSPECIALSUPPLIER == true {
        //            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        //            {
        //
        //                imgPlusMenu.image = UIImage(named: "plushebrewsupplier.png")
        //                imgPlusMenu.isHidden = false
        //                imgPlusMenu.isUserInteractionEnabled = true
        //                englishPlusMenu.isHidden = true
        //                englishPlusMenu.isUserInteractionEnabled = false
        //                imgPlusMenu.addGestureRecognizer(tapGestureRecognizer)
        //
        //            }
        //            else
        //            {
        //                englishPlusMenu.image = UIImage(named: "plushebrewsupplier.png")
        //                englishPlusMenu.isHidden = false
        //                englishPlusMenu.isUserInteractionEnabled = true
        //                imgPlusMenu.isHidden = true
        //                imgPlusMenu.isUserInteractionEnabled = true
        //                englishPlusMenu.addGestureRecognizer(tapGestureRecognizer)
        //
        //            }
        //        } else {
        //        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        //        {
        //
        //            imgPlusMenu.image = UIImage(named: "plushebrewcustomer.png")
        //            imgPlusMenu.isHidden = false
        //            imgPlusMenu.isUserInteractionEnabled = true
        //            englishPlusMenu.isHidden = true
        //            englishPlusMenu.isUserInteractionEnabled = false
        //            imgPlusMenu.addGestureRecognizer(tapGestureRecognizer)
        //
        //        }
        //        else
        //        {
        //            englishPlusMenu.image = UIImage(named: "plushebrewcustomer.png")
        //            englishPlusMenu.isHidden = false
        //            englishPlusMenu.isUserInteractionEnabled = true
        //            imgPlusMenu.isHidden = true
        //            imgPlusMenu.isUserInteractionEnabled = true
        //            englishPlusMenu.addGestureRecognizer(tapGestureRecognizer)
        //
        //        }
        //        }





        let tapKeyBoard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        tapKeyBoard.delegate = self

        self.view.addGestureRecognizer(tapKeyBoard)

        lblTitle.text = "DETAILS_APPOINTMENT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnOk.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnCancel.setTitle("CANCELLATION_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btncancelORDER.setTitle("CANCELLATION_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        shortDelayButton.setTitle("SLAIGHT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())

        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblSupllierName.font = UIFont(name: lblSupllierName.font.fontName, size: 17)
            lblSupplierService.font = UIFont(name: lblSupplierService.font.fontName, size: 17)
            lblSupplierAddress.font = UIFont(name: lblSupplierAddress.font.fontName, size: 17)
            lblDay.font = UIFont(name: lblDay.font.fontName, size: 17)
            lblDate.font = UIFont(name: lblDate.font.fontName, size: 17)
            lblHour.font = UIFont(name: lblHour.font.fontName, size: 17)
        }

        showDetailsAppointmentViewController = true

        clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)

        //  self.view.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        // self.view.addBackground()


        dateFormatter.dateFormat = "dd/MM/yyyy"
        print("and the tag is \(tag)")
        if tag == 1//מתור פנוי new order
        {

            // hidded cancel button for tag 1

            btnCancel.isHidden = true
            btnCancel.isUserInteractionEnabled = false

            lblTitle.text = "DETAILS_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            lblDate.text = dateFormatter.string(from: Global.sharedInstance.dateDayClick as Date)
            lblHour.text = Global.sharedInstance.hourFreeEvent
            lblDay.text = Global.sharedInstance.dayFreeEvent

            if Global.sharedInstance.nameOfCustomer != ""
            {
                lblSupllierName.text = Global.sharedInstance.nameOfCustomer
            }
            else
            {
                lblSupllierName.text = Global.sharedInstance.currentProviderToCustomer.nvProviderName
            }

            var serviceName = ""


            for item in Global.sharedInstance.multipleServiceName
            {
                if serviceName == ""
                {
                    serviceName = item
                }
                else
                {
                    serviceName = "\(serviceName),\(item)"
                }
            }

            lblSupplierService.text = serviceName
            lblSupplierAddress.text = Global.sharedInstance.currentProviderToCustomer.nvAdress

            btnOk.isHidden = false
            //            btnCancel.isHidden = false
        }
        else if tag == 2//מתור תפוס
        {
            lblTitle.text = "DETAILS_MEETING".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            lblDate.text = dateFormatter.string(from: Global.sharedInstance.dateEventBthereClick as Date)
            lblHour.text = Global.sharedInstance.hourBthereEvent  + " - " + Global.sharedInstance.hourBthereEventEnd
            lblDay.text = Global.sharedInstance.dayFreeEvent
            lblSupllierName.text = Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName
            var serviceName = ""


            for item in Global.sharedInstance.orderDetailsFoBthereEvent.objProviderServiceDetails
            {
                if serviceName == ""
                {
                    serviceName = item.nvServiceName
                }
                else
                {
                    serviceName = "\(serviceName),\(item.nvServiceName)"
                }
            }
            if serviceName == "" {

                lblSupplierService.text = Global.sharedInstance.serviceName
            } else {
                lblSupplierService.text = serviceName
            }
            lblSupplierAddress.text = Global.sharedInstance.orderDetailsFoBthereEvent.nvAddress

            var bthereevent:OrderDetailsObj = OrderDetailsObj()
            bthereevent =  Global.sharedInstance.orderDetailsFoBthereEvent
            let eventdateday:Date = bthereevent.dtDateOrder as Date
            let componentsCurrent = (self.calendar as NSCalendar).components([.day, .month, .year], from: Date())
            let monthtoask = componentsCurrent.month
            let yeartoask = componentsCurrent.year
            let daytoask = componentsCurrent.day
            let componentsCurrentev = (self.calendar as NSCalendar).components([.day, .month, .year], from: eventdateday)
            let monthtoaskv = componentsCurrentev.month
            let yeartoaskv = componentsCurrentev.year
            let daytoaskv = componentsCurrentev.day
            //bthere events here existing order has iDayInWeek != 1000 neworder has iDayInWeek = 1000
            //hour an date is past -> cannot be cancelled anymode
            if (monthtoask == monthtoaskv && yeartoask == yeartoaskv && daytoask == daytoaskv && bthereevent.iDayInWeek != 1000 && self.hourislessProviderHour(bthereevent) == true )   ||  Date() > eventdateday   {
                btnOk.isHidden = true
                btnCancel.isHidden = true
                let datetoadd10minutes = eventdateday.addingTimeInterval(10.0 * 60.0) //10 minutes from event start hour
                if  datetoadd10minutes >= Date() {
                    let comparDateInSeconds = datetoadd10minutes.timeIntervalSince(Date())
                    let secondsasint = (comparDateInSeconds / 60).rounded(.up)
                    print(secondsasint)
                    shortDelayButton.isHidden = false
                    shortDelayButton.isHidden = false
                }

            }
            // hours and date > nsdate -> can  be canceled button cancel -> opens are you sure you want to cancel popup
            if (monthtoask == monthtoaskv && yeartoask == yeartoaskv && daytoask == daytoaskv && bthereevent.iDayInWeek != 1000 && self.hourislessProviderHour(bthereevent) == false )   || eventdateday >=  Date() {
                cancelOrderID = Global.sharedInstance.orderDetailsFoBthereEvent.iCoordinatedServiceId
                btnOk.isHidden = true
                btnCancel.isHidden = true
                btncancelORDER.isHidden = false
                let datetoadd10minutes = eventdateday.addingTimeInterval(10.0 * 60.0) //10 minutes from event start hour
                if  datetoadd10minutes >= Date() {
                    let comparDateInSeconds = datetoadd10minutes.timeIntervalSince(Date())
                    let secondsasint = (comparDateInSeconds / 60).rounded(.up)
                    print(secondsasint)
                    shortDelayButton.isHidden = false
                }

            }
            //this is new appoinment cancellation -> close screen , ok -> make new order
            if  eventdateday >=  Date() && bthereevent.iDayInWeek == 1000{
                btnOk.isHidden = false
                btnCancel.isHidden = false

            }
            //            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
            //            view.addGestureRecognizer(tap)
        }
        else if tag == 3//מתצוגת רשימה מיומן לקוח
        {
            lblDate.text = dateFormatter.string(from: Global.sharedInstance.dateEventBthereClick as Date)
            lblHour.text = Global.sharedInstance.hourBthereEvent
            lblDay.text = Global.sharedInstance.dayFreeEvent
            lblSupllierName.text = Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName
            lblSupplierService.text = Global.sharedInstance.serviceName
            lblSupplierAddress.text = Global.sharedInstance.orderDetailsFoBthereEvent.nvAddress

            btnOk.isHidden = true
            btnCancel.isHidden = true
            //            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
            //            view.addGestureRecognizer(tap)
        }
        else if tag == 4//מתור חדש
        {
            lblDate.text = dateFormatter.string(from: dateEvent)
            lblHour.text = fromHour
            lblDay.text = moreexactlocalizablestringsfordays(Calendar.sharedInstance.getDayOfWeek(dateEvent)!)
            lblSupllierName.text = supplierName
            lblSupplierService.text = serviceName
            lblSupplierAddress.text = address
        }
        //     self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Search Result Hairdresser.jpg")!)
        // self.view.addBackground2()
        // Do any additional setup after loading the view.
        didClickOK = false

        // Check if is from my appointments
        if (isFromMyAppointments == true) {
            lblTitle.text = "DETAILS_MEETING".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            lblSupllierName.text = supplierName
            lblSupplierService.text = serviceName
            lblHour.text = fromHour
            lblDate.text = dateFormatter.string(from: dateEvent)
            lblDay.text = getDayOfWeekString(dateFormatter.string(from: dateEvent)) // NSDateFormatter().weekdaySymbols[event.iDayInWeek - 1] //convertDays(Calendar.sharedInstance.getDayOfWeek(dateEvent)!)

            if isPastAppointment
            {
                btncancelORDER.isHidden = true
                //                btnCancel.isHidden = true
            }
            else
            {
                btncancelORDER.isHidden = false
            }


            btnOk.isHidden = true
            btnCancel.isHidden = true

            lblSupplierAddress.text = appointmentLocation
            //            let comparDateInSeconds = specialdateEvent.timeIntervalSince(Date()) + 6000 //plus 10 minutes
            //            print(comparDateInSeconds)
            //            if comparDateInSeconds <= 0 {
            //                let secondsasint = (comparDateInSeconds / 60).rounded(.up)
            //
            //                print(secondsasint)
            //                if secondsasint <= 10 {
            //                    shortDelayButton.isHidden = false
            //                }
            //            }
            let datetoadd10minutes = specialdateEvent.addingTimeInterval(10.0 * 60.0) //10 minutes from event start hour
            if  datetoadd10minutes >= Date() {
                let comparDateInSeconds = datetoadd10minutes.timeIntervalSince(Date())
                let secondsasint = (comparDateInSeconds / 60).rounded(.up)
                print(secondsasint)
                shortDelayButton.isHidden = false

            }
        }
//        lblSupplierService.sizeToFit()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //פונקציה שנקראת לאחר ההשהיה של הטיימר בשביל הצגת הפופאפ
    func doDelayed()
    {
        Global.sharedInstance.isCancelAppointmentClick = true
        showDetailsAppointmentViewController = false
        DispatchQueue.main.async {
            self.GetCustomerOrders()
        }

    }

    //שמירת ארוע ביזר במכשיר
    func saveEventInDeviceCalander(addminutes:Int)
    {
        let whattoadd = self.lblSupplierService.text as! String
        let eventStore : EKEventStore = EKEventStore()

        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil)
            {
                let event = EKEvent(eventStore: eventStore)
                var myname:String = ""
                if Global.sharedInstance.nameOfCustomer != ""
                {
                    myname = Global.sharedInstance.nameOfCustomer
                }
                else
                {
                    myname = Global.sharedInstance.currentProviderToCustomer.nvProviderName
                }

                let serviceName =  "\(myname) : \(whattoadd)"
                print("Global.sharedInstance.hourFreeEvent \(Global.sharedInstance.hourFreeEvent)")
                print(self.hoursminutesfromString(hminutes: Global.sharedInstance.hourFreeEvent))
                let myarr = self.hoursminutesfromString(hminutes: Global.sharedInstance.hourFreeEvent)
                event.notes = "Bthere"
                event.title = serviceName
                event.isAllDay = false
                var ondedate = Global.sharedInstance.eventBthereDateStart as Date
                //                let componentsEvent = (self.calendar as NSCalendar).components([.day, .month, .year], from: ondedate)
                //                let gregorian = Foundation.Calendar(identifier: .gregorian)
                ////
                //                if  let _ = gregorian.date(from: componentsEvent) as Date?
                //                {
                //                    ondedate = gregorian.date(from: componentsEvent)!
                //                }
                //                if let _ = (self.calendar as NSCalendar).date(byAdding: .day, value: 1, to: ondedate) as Date?
                //                {
                //                    ondedate = (self.calendar as NSCalendar).date(byAdding: .day, value: 1, to: ondedate)!
                //                }

                //take off 3 hours because it adds 3 quick fix

                var htoadd:Int = 0
                var mintoadd:Int = 0

                if myarr.count == 2 {
                    htoadd = myarr[0]
                    mintoadd = myarr[1]
                }
                if Global.sharedInstance.iServiceTimeSUM <= 0 {
                    Global.sharedInstance.iServiceTimeSUM = 2
                }
                //                var  timeZoneOffset = 0
                //                let NTPDATE = Clock.now
                //                let timeZone = NSTimeZone.system
                //                timeZoneOffset = timeZone.secondsFromGMT(for: NTPDATE!) / 3600
                //                print(timeZoneOffset, "hours offset for timezone", timeZone)
                //                print(-timeZoneOffset)
                //                if timeZoneOffset >= 0 {
                //                    timeZoneOffset = -timeZoneOffset
                //                } else {
                //                    //nothing
                //                }

                ondedate =  self.calendar.date(byAdding: .hour, value: htoadd, to:ondedate)!
                ondedate =  self.calendar.date(byAdding: .minute, value: mintoadd, to: ondedate)!
                let componentsmStart1 = (self.calendar as NSCalendar).components([.year,.month,.day], from: ondedate)


                let gregorian = Foundation.Calendar(identifier: .gregorian)
                let eventDate = gregorian.date(from: componentsmStart1)!

                print(eventDate)
                var finaleventDate = self.calendar.date(byAdding: .hour, value:htoadd, to: eventDate )
                finaleventDate = self.calendar.date(byAdding: .minute, value:mintoadd, to: finaleventDate! )

                event.startDate =  finaleventDate! //ondedate.getrealdate(x:ondedate)
            //    print("eventBthereDateStart \( event.startDate)")
                let enddate = self.calendar.date(byAdding: .minute, value: Global.sharedInstance.iServiceTimeSUM, to: event.startDate )

                event.endDate = enddate!
                event.calendar = eventStore.defaultCalendarForNewEvents
                DispatchQueue.global(qos: .background).async {

                    do
                    {
                        try eventStore.save(event, span: .thisEvent)
                        print("success - " + event.title)
                    }
                    catch let e as NSError
                    {
                        print(e)
                        return
                    }
                }
            }
            else
            {
                let alert = UIAlertController(title: nil, message: "REQUEST_CALENDAR_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
                })
                self.present(alert, animated: true, completion: nil)
            }
        })
    }


   @objc  func imageTapped(){
        if self.isfromSPECIALSUPPLIER {
            let storyBoard = UIStoryboard(name:"SupplierExist", bundle: nil)
            let viewCon:PLUSMENUSupplier = storyBoard.instantiateViewController(withIdentifier: "PLUSMENUSupplier") as! PLUSMENUSupplier
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            viewCon.delegate = self
            self.present(viewCon, animated: true, completion: nil)
        } else {
            let viewCon:MenuPlusViewController = storyboard1.instantiateViewController(withIdentifier: "MenuPlusViewController") as! MenuPlusViewController
            viewCon.delegate = self
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(viewCon, animated: true, completion: nil)
        }
    }


    func openCustomer()
    {

        Calendar.sharedInstance.carrentDate = Date()
        //  let myday = Date()
        //  Calendar.sharedInstance.carrentDate = myday.getrealdate()
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController

    }


    func openMycustomers() {
        Global.sharedInstance.whichReveal = true
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
        Global.sharedInstance.isProvider = true
        frontviewcontroller!.pushViewController(viewCon, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController

    }



    func openFromMenu(_ con:UIViewController)
    {
        self.present(con, animated: true, completion: nil)
    }

    //ממין מערך שלא יהיה עם ערכים כפולים
    func uniq<S : Sequence, T : Hashable>(_ source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }

    //קבלת רשימת התורים של לקוח בביזר
    func GetCustomerOrders()
    {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()

        if self.isfromSPECIALiCustomerUserId != 0 {
            dic["iUserId"] = self.isfromSPECIALiCustomerUserId as AnyObject
        } else {
            dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        }
        //fix this for sending 0 0 in monthToday and iFilterByYear whcih leads to "infinite" loading
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        let yearToday =  componentsCurrent.year!
        let monthToday = componentsCurrent.month!
        iFilterByMonth = monthToday
        iFilterByYear = yearToday

        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject

        self.generic.showNativeActivityIndicator(self)

        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            //            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomerOrdersNoLogo(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if RESPONSEOBJECT["Result"] != nil {
                        let ps:OrderDetailsObj = OrderDetailsObj()
                        if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                            Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                        }
                        self.generic.hideNativeActivityIndicator(self)
                        if self.showDetailsAppointmentViewController == true
                        {
                            Global.sharedInstance.nameOfCustomer = ""
                            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                            self.viewpop = storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as? PopUpGenericViewController
                            if self.iOS8 {
                                self.viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            } else {
                                self.viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
                            }
                            self.viewpop.isfromWhichScreen = 2
                            self.viewpop.nrOrders = self.nrOrders
                            self.viewpop.supplierName = Global.sharedInstance.currentProviderToCustomer.nvProviderName
                            self.viewpop.supplierId = self.currentSupplierId

                            self.present(self.viewpop, animated: true, completion: nil)
                        }
                        else
                        {
                            Global.sharedInstance.nameOfCustomer = ""
                            self.dismiss()
                        }
                    }
                }
                else
                {
                    Global.sharedInstance.nameOfCustomer = ""
                    self.dismiss()
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                //                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }


    func dismiss() {
        // Check if is from my appointments list
        if (isFromMyAppointments == true) {

            self.dismiss(animated: true, completion: nil)
        } else {

            if Global.sharedInstance.model == 2//יומן ספק שהלקוח רואה
            {

                //   isfromSPECIALSUPPLIER
                //    if isfromSPECIALSUPPLIER == false {
                if self.isfromSPECIALSUPPLIER == true {
                    Global.sharedInstance.whichReveal = true
                }
                Global.sharedInstance.isCancelAppointmentClick = true
                Calendar.sharedInstance.carrentDate = Date()
                //    let myday = Date()
                //     Calendar.sharedInstance.carrentDate = myday.getrealdate()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                let modelclendar:ModelCalendarForAppointmentsViewController = clientStoryBoard.instantiateViewController(withIdentifier: "ModelCalendarForAppointments") as! ModelCalendarForAppointmentsViewController
                modelclendar.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
                modelclendar.modalPresentationStyle = UIModalPresentationStyle.custom
                frontViewController.pushViewController(modelclendar, animated: false)
                let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                let mainRevealController = SWRevealViewController()
                mainRevealController.frontViewController = frontViewController
                mainRevealController.rearViewController = rearViewController
                self.view.window!.rootViewController = mainRevealController
                self.view.window?.makeKeyAndVisible()
                //                } else {
                //                    openMycustomers()
                //                }
            }
            else
            {
                if isfromSPECIALSUPPLIER == false {
                    Global.sharedInstance.isCancelAppointmentClick = true
                    Calendar.sharedInstance.carrentDate = Date()
                    // let myday = Date()
                    // Calendar.sharedInstance.carrentDate = myday.getrealdate()
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
                } else {
                    openMycustomers()
                }
            }
        }
    }

    @objc func dismissPopUp()
    {
        dismiss()
    }
    //magic thing filter mass array
    func hourislessProviderHour (_ itemx: OrderDetailsObj) -> Bool {


        print("ce analizeaza \(itemx.getDic())")

        var islessh:Bool  = false
        var eventHour:Int = 0
        var eventMinutes:Int = 0
        //   if itemx.iCoordinatedServiceId > 0 { don't care all events has starting and ending hours and hollydays are in separated array
        if let a1:Character =  itemx.nvFromHour[itemx.nvFromHour.startIndex] as Character? {
            if a1 == "0" {
                //now get the real hour
                if let a2:Character =  itemx.nvFromHour[itemx.nvFromHour.index(itemx.nvFromHour.startIndex, offsetBy: 1)] as Character? {
                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
                    if a2 == "0" {
                        print("ora1 0 add to 0")
                        eventHour = 0
                    }
                    else {
                        print("ora1 \(a2) add to \(a2)") //section
                        let str = String(a2)
                        let IntHOUR:Int = Int(str)!
                        eventHour = IntHOUR

                    }
                }
            }
            else { //full hour 2 chars
                let fullNameArr = itemx.nvFromHour.components(separatedBy: ":")
                let size = fullNameArr.count
                if(size > 1 ) {
                    if let _:String = fullNameArr[0] as String? {
                        let hourstring:String = fullNameArr[0]
                        let numberFromString:Int = Int(hourstring)!
                        eventHour = numberFromString
                    }
                }
            }
        }
        // }
        let componentsToday = (calendar as NSCalendar).components([.hour, .minute], from: Date())
        let minutulacum = componentsToday.minute
        let oraacum = componentsToday.hour

        if eventHour < oraacum! {
            islessh = true
        } else  if eventHour == oraacum {
            //minutes compare
            let fullNameArr = itemx.nvFromHour.components(separatedBy: ":")
            let size = fullNameArr.count
            if(size > 1 ) {
                if let _:String = fullNameArr[1] as String?  {
                    let hourstring:String = fullNameArr[1]
                    if let a1:Character =  hourstring[hourstring.startIndex] as Character? {
                        if a1 == "0" {
                            //now get the real minute
                            if let a2:Character =  hourstring[hourstring.index(hourstring.startIndex, offsetBy: 1)] as Character? {
                                if a2 == "0" {
                                    print("minutul 0 add to 0")
                                    eventMinutes = 0
                                }
                                else {
                                    print("minutul \(a2) add to \(a2)") //section
                                    let str = String(a2)
                                    let IntHOUR:Int = Int(str)!
                                    eventMinutes = IntHOUR

                                }
                            }
                        }
                        else { //full minutes 2 chars
                            let fullNameArr = itemx.nvFromHour.components(separatedBy: ":")
                            let size = fullNameArr.count
                            if(size > 1 ) {
                                if let _:String = fullNameArr[1]  as String? {
                                    let hourstring:String = fullNameArr[1]
                                    let numberFromString:Int = Int(hourstring)!
                                    eventMinutes = numberFromString
                                }
                            }
                        }
                    }
                }
            }
            if eventMinutes < minutulacum! {
                islessh = true
            } else {
                islessh = false
            }
        }


        else {
            islessh = false
        }
        //\\print ("oraacum \(oraacum) - minutulacum \(minutulacum) si eventHour \(eventHour)  eventMinutes \(eventMinutes) ")

        return islessh
    }
    func cancelOrder(_ idTurn:Int) {
        self.dismissKeyBoard()
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iCoordinatedServiceId"] = idTurn as AnyObject
        api.sharedInstance.CancelOrder(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                print("cancel order  responseObject\( RESPONSEOBJECT.description)")
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.showAlertDelegateX("SUCCESS_CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        })
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        })
                    }
                }
            }
            self.dismiss()
            if Global.sharedInstance.currentUser.iUserId != 0 {
                self.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
            }


        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            //            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            self.btncancelApp.isUserInteractionEnabled = true
            if Global.sharedInstance.currentUser.iUserId != 0 {
                self.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
            }
        })

    }


    //convert day from int to string
    //get int day and returns itws string value

    func convertDays(_ day:Int) -> String {

        switch day {
        case 1:
            return "FIRST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 2:
            return "SECOND".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 3:
            return "THIRD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 4:
            return "FOURTH".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 5:
            return "FIFTH".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 6:
            return "SIX".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 7:
            return "SEVEN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        default:
            return "FIRST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
    }


    func getDayOfWeekString(_ today:String)->String {
        let formatter  = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let todayDate = formatter.date(from: today)!
        let myCalendar = Foundation.Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        switch weekDay {
        case 1:
            return "SUNDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 2:
            return "MONDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 3:
            return "TUESDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 4:
            return "WEDNSDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 5:
            return "THIRTHDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 6:
            return "FRIDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 7:
            return "SHABAT_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        default:
            return ""
        }
    }
    func hoursminutesfromString(hminutes: String) -> Array<Int> {
        var myarr =  Array<Int> ()
        var numHOURS:Int = 0
        var numMINUTES:Int = 0
        let hourminString = hminutes
        if hourminString.contains(":") {
            let splited = hourminString.components(separatedBy: ":")
            if splited.count == 2 {
                if splited[0].count == 2 &&  splited[1].count == 2 {

                    // 1. first clean hours
                    let a1 =  splited[0].substring(to: 1)
                    if a1 == "0" {
                        //now get the real hour
                        let a2 =  splited[0].substring(from: 0)
                        if a2 == "0" {
                            numHOURS = 0
                        }
                        else {
                            let IntHOUR:Int = Int(a2)!
                            numHOURS = IntHOUR
                        }
                    }
                    else {
                        let a3 = splited[0]
                        let IntHOUR:Int = Int(a3)!
                        numHOURS = IntHOUR
                    }
                    //second clean minutes
                    let a4 =  splited[1].substring(to: 1)
                    if a4 == "0" {
                        //now get the real hour
                        let a5 =  splited[1].substring(from: 0)
                        if a5 == "0" {
                            numMINUTES = 0
                        }
                        else {
                            let IntMINUTES:Int = Int(a5)!
                            numMINUTES = IntMINUTES
                        }
                    }
                    else {
                        let a5 = splited[1]
                        let IntMINUTES:Int = Int(a5)!
                        numMINUTES = IntMINUTES
                    }

                    //all logic in this condition
                    myarr.append(numHOURS)
                    myarr.append(numMINUTES)
                }
            }
        }



        return myarr
    }
    func getProviderAllDetails(_ iUserId:Int)       //invoke server function to get provider details
    {
        Global.sharedInstance.FREEDAYSALLWORKERS = []
        Global.sharedInstance.NOWORKINGDAYS = []

        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicUserId["iUserId"] = iUserId as AnyObject
        api.sharedInstance.getProviderAllDetails(dicUserId, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                    {
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                    {
                        UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")
                    }
                    else
                    {
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                            //\\   print("crash 1 \(String(describing: RESPONSEOBJECT["Result"]))")

                            Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                            // print ("exact \( Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.description)")
                            let mydic :Dictionary<String,AnyObject> = (RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!

                            //IMPORTANT THIS FIX PROVIDERID AFTER SETTING ORDER TO ANOTHER ONE.
                            if let onedic:Dictionary<String,AnyObject> = mydic["objProviderProfile"] as? Dictionary<String,AnyObject> {
                                if let Iprov:Int = onedic["iProviderUserId"] as? Int {
                                    print("dupaget \(Iprov)")
                                    if Iprov != 0 {
                                        Global.sharedInstance.providerID = Iprov
                                    } else {
                                        api.sharedInstance.trytogetProviderdata()
                                    }
                                }
                                //BLOCKED DAYS ARE GENERAL FOR PROVIDER AND
                                // 1. SEPARATE FOR EVERY WORKER IF HE HAS bSameWH = 0
                                // 2. SAME AS PROVIDER IF WORKER has bSameWH = 1
                                let anotherarray:NSMutableArray = NSMutableArray()
                                if let onearray:NSArray = onedic["objWorkingHours"] as? NSArray {

                                    for item in onearray {
                                        if let mydicfast:NSDictionary = item as? NSDictionary {
                                            if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                if !anotherarray.contains(MYDAYINTS) {
                                                    anotherarray.add(MYDAYINTS)
                                                }
                                            }
                                        }
                                    }
                                    //       Global.sharedInstance.FREEDAYSSUPPLIER
                                    let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                    for item in FIXEDNUMBERS {
                                        if !anotherarray.contains(item) {
                                            if !Global.sharedInstance.NOWORKINGDAYS.contains(item) {
                                                Global.sharedInstance.NOWORKINGDAYS.add(item)
                                            }
                                        }
                                    }
                                }
                                print("NOWORKINGDAYS \(Global.sharedInstance.NOWORKINGDAYS)")
                            }

                            if let seconddic:Dictionary<String,AnyObject> = mydic["objProviderGeneralDetails"] as? Dictionary<String,AnyObject> {
                                if let onearray:NSArray = seconddic["objServiceProviders"] as? NSArray
                                {
                                    for item in onearray {
                                        let freedaysworkersrarray:NSMutableArray = NSMutableArray()
                                        let blockdaysworkersrarray:NSMutableArray = NSMutableArray()
                                        let USERX:NSMutableDictionary = NSMutableDictionary()
                                        if let mydicfast:NSDictionary = item as? NSDictionary {
                                            if let MYDAYINTS:Int = mydicfast["bSameWH"] as? Int {
                                                var miUSERID:Int = 0
                                                if let mydicuser:NSDictionary = mydicfast["objUsers"] as? NSDictionary {
                                                    if let _:Int = mydicuser["iUserId"] as? Int {
                                                        miUSERID = mydicuser["iUserId"] as! Int
                                                    }
                                                }
                                                if MYDAYINTS == 1 {
                                                    //same hours as provider
                                                    USERX["bSameWH"] = MYDAYINTS
                                                    USERX["WORKERID"] = miUSERID
                                                    USERX["FREEDAYS"] = Global.sharedInstance.NOWORKINGDAYS
                                                    if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                        Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                    }
                                                } else {
                                                    //custom hours
                                                    if let workerhoursarraay:NSArray = mydicfast["objWorkingHours"] as? NSArray {
                                                        for item in workerhoursarraay {
                                                            if let mydicfast:NSDictionary = item as? NSDictionary {
                                                                if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                                    if !freedaysworkersrarray.contains(MYDAYINTS) {
                                                                        freedaysworkersrarray.add(MYDAYINTS)
                                                                        print("MYDAYINTS \(MYDAYINTS)")
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        //       Global.sharedInstance.FREEDAYSSUPPLIER
                                                        let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                                        for item in FIXEDNUMBERS {
                                                            if !freedaysworkersrarray.contains(item) {
                                                                if !blockdaysworkersrarray.contains(item) {
                                                                    blockdaysworkersrarray.add(item)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    USERX["bSameWH"] = MYDAYINTS
                                                    USERX["WORKERID"] = miUSERID
                                                    USERX["FREEDAYS"] = blockdaysworkersrarray
                                                    if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                        Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            print("Global.sharedInstance.FREEDAYSALLWORKERS \(Global.sharedInstance.FREEDAYSALLWORKERS)")
                            //שמירת שם העסק במכשיר
                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")
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
                        }
                    }
                }
            }

        },failure: {(AFHTTPRequestOperation, Error) -> Void in

            //            if AppDelegate.showAlertInAppDelegate == false
            //            {
            //                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            //                AppDelegate.showAlertInAppDelegate = true
            //            }
        })
    }
    //CLIENT CANNOT CANCEL 24 H BEFORE MEETING
    func GetProviderSettingsForCalendarmanagement(_ORDERPROVIDERID:Int) {
        var providerID:Int = 0
   
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        self.generic.showNativeActivityIndicator(self)
        dicSearch["iProviderId"] = _ORDERPROVIDERID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            self.iHoursForPreCancelServiceByCustomer = 0
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    self.generic.hideNativeActivityIndicator(self)
                    print("responseObject \(responseObject ??  1 as AnyObject)")
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                let possiblerezult:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                if let _:Bool = possiblerezult["bIsAvailableForNewCustomer"] as? Bool {
                                    let myint:Bool =  possiblerezult["bIsAvailableForNewCustomer"] as! Bool
                                    if myint == true {
                                        self.bIsAvailableForNewCustomer = 1
                                    } else {
                                        self.bIsAvailableForNewCustomer = 0
                                    }
                                }
                                if let _:Int = possiblerezult["iHoursForPreCancelServiceByCustomer"] as? Int {
                                    let myint:Int =  possiblerezult["iHoursForPreCancelServiceByCustomer"] as! Int
                                    if myint == 1 {
                                        self.iHoursForPreCancelServiceByCustomer = 1
                                    } else {
                                        self.iHoursForPreCancelServiceByCustomer = 0
                                    }
                                } else {
                                    self.iHoursForPreCancelServiceByCustomer = 0
                                }

                                self.calculatetime24hoursfromorder()
                            }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.iHoursForPreCancelServiceByCustomer = 0

            })
        }
    }
    func calculatetime24hoursfromorder() {
        print("tag cancel \(tag)")
        if  self.iHoursForPreCancelServiceByCustomer == 1 {
            //CALCULATE 24 H
            if tag == 2 {
                var bthereevent:OrderDetailsObj = OrderDetailsObj()
                bthereevent =  Global.sharedInstance.orderDetailsFoBthereEvent
                let eventdateday:Date = bthereevent.dtDateOrder as Date
                let distanceBetweenDates: TimeInterval? = eventdateday.timeIntervalSince(Date())
                let secondsInAnHour: Double = 3600
                let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
                print(hoursBetweenDates,"hours")//120 hours
                if hoursBetweenDates < 24 {
                    let newlistservices = UIStoryboard(name: "newlistservices", bundle: nil)
                    let viewCon:PopUp24HoursViewController = newlistservices.instantiateViewController(withIdentifier: "PopUp24HoursViewController") as! PopUp24HoursViewController
                    viewCon.nvPhone = self.nvPhone
                    viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                    self.present(viewCon, animated: true, completion: nil)
                } else {
                    continuecancellation()
                }

            }
            if tag == 3 {
                let eventdateday:Date = Global.sharedInstance.dateEventBthereClick as Date
                let distanceBetweenDates: TimeInterval? = eventdateday.timeIntervalSince(Date())
                let secondsInAnHour: Double = 3600
                let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
                print(hoursBetweenDates,"hours")//120 hours
                if hoursBetweenDates < 24 {
                    let newlistservices = UIStoryboard(name: "newlistservices", bundle: nil)
                    let viewCon:PopUp24HoursViewController = newlistservices.instantiateViewController(withIdentifier: "PopUp24HoursViewController") as! PopUp24HoursViewController
                    viewCon.nvPhone = self.nvPhone
                    viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                    self.present(viewCon, animated: true, completion: nil)
                } else {
                    continuecancellation()
                }

            }
            //comes from menu plus
            if tag == 0  {
                let eventdateday:Date = specialdateEvent as Date
                let distanceBetweenDates: TimeInterval? = eventdateday.timeIntervalSince(Date())
                let secondsInAnHour: Double = 3600
                let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
                print(hoursBetweenDates,"hours")//120 hours
                if hoursBetweenDates < 24 {
                    let newlistservices = UIStoryboard(name: "newlistservices", bundle: nil)
                    let viewCon:PopUp24HoursViewController = newlistservices.instantiateViewController(withIdentifier: "PopUp24HoursViewController") as! PopUp24HoursViewController
                    viewCon.nvPhone = self.nvPhone
                    viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                    self.present(viewCon, animated: true, completion: nil)
                } else {
                    continuecancellation()
                }

            }
        } else {
            continuecancellation()
        }
    }


        func continuecancellation() {
            if (isFromMyAppointments == false) {
                self.dismiss(animated: false, completion: nil)
                let clientStoryBoard2 = UIStoryboard(name: "ClientExist", bundle: nil)
                let viewCon:CancelAppointmentClientViewController = clientStoryBoard2.instantiateViewController(withIdentifier: "CancelAppointmentClientViewController") as! CancelAppointmentClientViewController
                viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                let event = Global.sharedInstance.orderDetailsFoBthereEvent
                viewCon.appointmentID = event.iCoordinatedServiceId
                viewCon.service = lblSupplierService.text!
                viewCon.providername = lblSupllierName.text!
                Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName = viewCon.providername
                self.present(viewCon, animated: true, completion: nil)
            } else {
                let clientStoryBoard2 = UIStoryboard(name: "ClientExist", bundle: nil)
                let viewCon:CancelAppointmentClientViewController = clientStoryBoard2.instantiateViewController(withIdentifier: "CancelAppointmentClientViewController") as! CancelAppointmentClientViewController
                viewCon.service = lblSupplierService.text!
                viewCon.providername = lblSupllierName.text!
                Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName = viewCon.providername
                viewCon.appointmentTime = appointmentTime
                viewCon.isFromMyMeetings = true
                viewCon.date = dateFormatter.string(from: dateEvent)
                viewCon.appointmentID = cancelOrderID
                viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                self.present(viewCon, animated: true, completion: nil)
            }

        }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        lblSupplierService.frame.size.height = lblSupplierService.optimalHeight
//        lblSupplierService.lineBreakMode = .byWordWrapping
//    }
}

