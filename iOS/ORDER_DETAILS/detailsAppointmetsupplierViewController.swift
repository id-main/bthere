//
//  detailsAppointmetsupplierViewController.swift
//  Bthere
//
//  Created by User on 11.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import MarqueeLabel

protocol openCustomerDelegate1 {
    func openCustomer()
    func openMycustomers()
    func openCalendar()
}

protocol getCustomerOrdersDelegate1 {
    func GetCustomerOrders()
}
//פרטי התור
class detailsAppointmetsupplierViewController: NavigationModelViewController,openCustomerDelegate1,openFromMenuDelegate,getCustomerOrdersDelegate1,UITextViewDelegate,UIGestureRecognizerDelegate{
    //JMODE
    var isOcasionalCustomer:Bool = false
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var isBLOCKED:Bool = false
    var isfromLIST:Bool = false
    var isfromWEEK:Bool = false
    var isFROMALLMEETINGS:Bool = false
    var APPOINMENT_DICT:NSDictionary = NSDictionary()
    var EVENT_DICT:allKindEventsForListDesign = allKindEventsForListDesign()
    var userAPPOINMENT_DICT:NSMutableDictionary = NSMutableDictionary()
    let calendar = Foundation.Calendar.current
    //MARK: - Outlet
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblSupllierName: UILabel!
    
    @IBOutlet weak var lblSupplierService: UILabel!
    
    @IBOutlet weak var imgPlusMenu: UIImageView!
    
    @IBOutlet weak var lblSupplierAddress: UILabel!
    
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblHour: UILabel!
    
    @IBOutlet weak var lblAdvertising: MarqueeLabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnCALL: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewCancel: UIView!
    //cancel popup
    var nvUsername = ""
    var dateTurn = ""
    var hourTurn = ""
    var dayweek = ""
    
    //MARK: - Outlet
    @IBOutlet weak var lblHourTurn: UILabel!
    @IBOutlet weak var titlescreen: UILabel!
    @IBOutlet weak var messagescreen: UILabel!
    @IBOutlet weak var lblDateTurn: UILabel!
    @IBOutlet weak var lbldayofweek: UILabel!
    @IBOutlet weak var btnClosePopup: UIButton!
    @IBOutlet weak var btncancelApp: UIButton!
    @IBOutlet weak var txtComment: UITextView!
    
    @IBAction func btnClose(_ sender: AnyObject) {
        if self.isfromWEEK == true {
            //  self.dismissViewControllerAnimated(true, completion: nil)
            openCalendar()
        } else
            if self.isfromLIST == false {
                openMycustomers()
            }
            else {
                openCalendar()
        }
    }
    @IBAction func btnCALL(_ sender: AnyObject) {
        let d:NSDictionary = self.userAPPOINMENT_DICT
        if let nvPhone:String = d.object(forKey: "nvPhone") as? String {
          print ("nvPhone \(nvPhone)")
            Global.sharedInstance.makeCall(nvPhone as NSString)
        }
        
    }
   
    //בלחיצה על ביטול
    @IBAction func btnCancel(_ sender: AnyObject) {
        
        //        Global.sharedInstance.isCancelAppointmentClick = true
        //        showDetailsAppointmentViewController = false
        //        //self.getFreeDaysForServiceProvider()//קבלת רשימת התורים הפנויים מעודכנת
        //
        //        let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        //        let frontviewcontroller:UINavigationController? = UINavigationController()
        //        let viewCon:CancelAppointmentViewController = supplierStoryBoard.instantiateViewControllerWithIdentifier("CancelAppointmentViewController") as! CancelAppointmentViewController
        //           if self.isfromLIST == false {
        //        viewCon.USERDICT = self.userAPPOINMENT_DICT
        //        viewCon.CANCEL_DICT = self.APPOINMENT_DICT
        //        viewCon.isfromLIST = false
        //        }  else {
        //            viewCon.USERDICT = self.userAPPOINMENT_DICT
        //            viewCon.EVENT_DICT = self.EVENT_DICT
        //            viewCon.isfromLIST = true
        //        }
        //        frontviewcontroller!.pushViewController(viewCon, animated: false)
        //        //initialize REAR View Controller- it is the LEFT hand menu.
        //        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        //        let rearViewController = storyboard1.instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
        //        let mainRevealController = SWRevealViewController()
        //        mainRevealController.frontViewController = frontviewcontroller
        //        mainRevealController.rearViewController = rearViewController
        //        let window :UIWindow = UIApplication.sharedApplication().keyWindow!
        //        window.rootViewController = mainRevealController
        if isBLOCKED == true
        {
           if isFROMALLMEETINGS == true
           {
                /*PPOINMENT_DICT.{
                    chServiceColor = "";
                    dtDateOrder = "/Date(1527454800000)/";
                    iCoordinatedServiceId = 1013936;
                    iCoordinatedServiceStatusType = 1;
                    iDayInWeek = 0;
                    iProviderUserId = 12036;
                    iSupplierId = 0;
                    iUserId = 0;
                    nvAddress = "";
                    nvComment = BlockedBySupplier;
                    nvFirstName = "";
                    nvFromHour = "15:00";
                    nvLogo = "";
                    nvSupplierName = "";
                    nvToHour = "17:30";
                    objProviderServiceDetails =     (
                    );
                    title = "";
                }*/
               
                print(APPOINMENT_DICT)
                let date = dateFormatter.string(from:  APPOINMENT_DICT.object(forKey: "dateEvent") as! Date)
                let hourS:String =  APPOINMENT_DICT.object(forKey: "nvFromHour") as! String
                let hourE:String = APPOINMENT_DICT.object(forKey: "nvToHour") as! String
                let iCoordinatedServiceId:Int = APPOINMENT_DICT.object(forKey: "iCoordinatedServiceId") as! Int
                let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                let viewpopupcancel = storyboardtest.instantiateViewController(withIdentifier: "CancelBlockHoursViewController") as! CancelBlockHoursViewController
                if self.iOS8
                {
                    viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                }
                else
                {
                    viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.currentContext
                }
                let onestr = "AT".localized(LanguageMain.sharedInstance.USERLANGUAGE) + "\n" + date
                viewpopupcancel.date = hourS + " - " + hourE + " " + onestr
                viewpopupcancel.iProviderUserId =  APPOINMENT_DICT.object(forKey: "iProviderUserId") as! Int
                viewpopupcancel.iServiceProviderCalendarId = iCoordinatedServiceId
                if let datestr:String  = APPOINMENT_DICT["dtDateOrder"] as? String
                {
                    let eventdateday:Date =   Global.sharedInstance.getStringFromDateString(datestr)
                    viewpopupcancel.dDate = Global.sharedInstance.convertNSDateToStringMore(eventdateday)
                }
                
                viewpopupcancel.ISFROMCALENDARVIEW = true
                viewpopupcancel.ISFROMBLOCKTABLE = false
                self.present(viewpopupcancel, animated: true, completion: nil)
                isFROMALLMEETINGS = false
           }
           else  if isfromWEEK == true || isfromLIST == false
           {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                print(APPOINMENT_DICT)
                let date = dateFormatter.string(from:  APPOINMENT_DICT.object(forKey: "dateEvent") as! Date)
                let hourS:String =  APPOINMENT_DICT.object(forKey: "fromHour") as! String
                let hourE:String = APPOINMENT_DICT.object(forKey: "toHour") as! String
                let iCoordinatedServiceId:Int = APPOINMENT_DICT.object(forKey: "iCoordinatedServiceId") as! Int
                let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                let viewpopupcancel = storyboardtest.instantiateViewController(withIdentifier: "CancelBlockHoursViewController") as! CancelBlockHoursViewController
                if self.iOS8
                {
                viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                }
                else
                {
                viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.currentContext
                }
                let onestr = "AT".localized(LanguageMain.sharedInstance.USERLANGUAGE) + "\n" + date
                viewpopupcancel.date = hourS + " - " + hourE + " " + onestr
                viewpopupcancel.iProviderUserId = EVENT_DICT.iProviderUserId
                viewpopupcancel.iServiceProviderCalendarId = iCoordinatedServiceId
                viewpopupcancel.dDate = Global.sharedInstance.convertNSDateToStringMore(APPOINMENT_DICT.object(forKey: "dateEvent") as! Date)
                viewpopupcancel.ISFROMCALENDARVIEW = true
                viewpopupcancel.ISFROMBLOCKTABLE = false
                self.present(viewpopupcancel, animated: true, completion: nil)
            }
             else
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.string(from:  EVENT_DICT.dateEvent as Date)
                let hourS:String = EVENT_DICT.fromHour
                let hourE:String = EVENT_DICT.toHour
                let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                let viewpopupcancel = storyboardtest.instantiateViewController(withIdentifier: "CancelBlockHoursViewController") as! CancelBlockHoursViewController
                if self.iOS8
                {
                    viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                }
                else
                {
                    viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.currentContext
                }
                let onestr = "AT".localized(LanguageMain.sharedInstance.USERLANGUAGE) + "\n" + date
                viewpopupcancel.date = hourS + " - " + hourE + " " + onestr
                viewpopupcancel.iProviderUserId = EVENT_DICT.iProviderUserId
                viewpopupcancel.iServiceProviderCalendarId = self.EVENT_DICT.iCoordinatedServiceId
                viewpopupcancel.dDate = Global.sharedInstance.convertNSDateToStringMore(EVENT_DICT.dateEvent)
                viewpopupcancel.ISFROMCALENDARVIEW = true
                viewpopupcancel.ISFROMBLOCKTABLE = false
                self.present(viewpopupcancel, animated: true, completion: nil)
 
            }
        }
        else
        {
            self.viewCancel.isHidden = false
        }
        
    }
    @IBAction func btnClosePopup(_ sender: AnyObject) {
        view.endEditing(true)
        viewCancel.isHidden = true
    }

    
    @IBAction func btncancelApp(_ sender: AnyObject) {
        btncancelApp.isUserInteractionEnabled = false
        var iCoordinatedServiceId:Int = 0
        if self.isfromLIST == false || self.isfromWEEK == true {
            if let _:Int =  APPOINMENT_DICT.object(forKey: "iCoordinatedServiceId") as? Int
            {
                iCoordinatedServiceId = APPOINMENT_DICT.object(forKey: "iCoordinatedServiceId") as! Int
            }
        } else {
            if let _:Int =  EVENT_DICT.iCoordinatedServiceId as Int?
            {
                iCoordinatedServiceId = EVENT_DICT.iCoordinatedServiceId
            }
        }
        
        print("iCoordinatedServiceId\(iCoordinatedServiceId)")
        if iCoordinatedServiceId != 0 {
                       self.cancelOrder(iCoordinatedServiceId)
            }
        
    }
    
    //לחיצה על אישור
   
    
    //MARK: - Properties
    
    var showDetailsAppointmentViewController:Bool = true
    var fromViewMode = false
    var generic:Generic = Generic()
    var delegateSetNewOrder:setNewOrderDelegate!=nil
    var clientStoryBoard:UIStoryboard?
    
    let dateFormatter = DateFormatter()
    let dateFormatter1 = DateFormatter()
    
    var dateEvent:Date = Date()
    var fromHour:String = ""
    var supplierName:String = ""
    var serviceName:String = ""
    var address:String = ""
    
    var didClickOK:Bool = false//מציין אם כבר לחצו על אישור פעם אחת כדי למנוע לחיצה כפולה
    
    var timer: Timer? = nil
    
    var storyboard1:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var tag:Int = 1//מציין האם הגיעו מלחיצה על תור פנוי או מלליצה על תור של ביזר תפוס,1=פנוי,2=תפוס
    
    //MARK: - Initial
    @objc func dismissKeyBoard() {
        
        view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:29) 
        self.getnews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.getnews()
        self.lblAdvertising.restartLabel()
        
        for key in APPOINMENT_DICT
        {
            print ("suppliers keys: \(key)")
        }
        
        let leftarrowback = UIImage(named: "sageata2.png")
        self.btnClose.setImage(leftarrowback, for: UIControl.State())
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        btnClose.imageView!.contentMode = .scaleAspectFit
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            btnClose.transform = scalingTransform
        }
        self.viewCancel.isHidden = true
        self.txtComment.delegate = self
        btncancelApp.setTitle("CONFIRM_BTN_DEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        self.titlescreen.text = "TITLE_CANCEL_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnCALL.setTitle("NEWCALL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        if isBLOCKED == true {
            btnCALL.isHidden = true
        }
        let DESCR:String = "DESCRIPTION_CANCEL_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.messagescreen.text = DESCR
        let tapKeyBoard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        tapKeyBoard.delegate = self
        viewCancel.addGestureRecognizer(tapKeyBoard)
        self.view.addGestureRecognizer(tapKeyBoard)
        print("APPOINMENT_DICT.object: \(String(describing: APPOINMENT_DICT))")
        print("EVENT_DICT.nvComment as? String: \(EVENT_DICT.nvComment as? String)")
        if self.isfromLIST == false || self.isfromWEEK == true {
            print("APPOINMENT_DICT a \(APPOINMENT_DICT) userdict \(self.userAPPOINMENT_DICT)")
            if isOcasionalCustomer == true  {
                if let _:String = APPOINMENT_DICT.object(forKey: "nvComment") as? String {
                    let myocassionalphone:String = APPOINMENT_DICT.object(forKey: "nvComment") as! String
                    userAPPOINMENT_DICT["nvPhone"] = myocassionalphone
                } else {
                    btnCALL.isHidden = true
                }
            }
        } else {
            print("EVENT_DICT a\(EVENT_DICT.getDic()) userdict \(self.userAPPOINMENT_DICT)")
            
            if isOcasionalCustomer == true {
                if let _:String = EVENT_DICT.nvComment as String? {
                    let myocassionalphone:String = EVENT_DICT.nvComment
                    userAPPOINMENT_DICT["nvPhone"] = myocassionalphone
                } else {
                btnCALL.isHidden = true
                }
            }
        }
    
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            imgPlusMenu.image = UIImage(named: "plus.png")
        }
        else
        {
            imgPlusMenu.image = UIImage(named: "plusEnglish.png")
        }
        
        lblTitle.text = "DETAILS_APPOINTMENT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        btnCancel.setTitle("CANCELLATION_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblAdvertising.text = "ADVERTISINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblSupllierName.font = UIFont(name: lblSupllierName.font.fontName, size: 17)
            lblSupplierService.font = UIFont(name: lblSupplierService.font.fontName, size: 17)
            lblSupplierAddress.font = UIFont(name: lblSupplierAddress.font.fontName, size: 17)
            lblDay.font = UIFont(name: lblDay.font.fontName, size: 14)
            lblDate.font = UIFont(name: lblDate.font.fontName, size: 14)
            lblHour.font = UIFont(name: lblHour.font.fontName, size: 14)
        }
        
        showDetailsAppointmentViewController = true
        
        clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        self.view.addBackground()
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(detailsAppointmetsupplierViewController.imageTapped))
        imgPlusMenu.isUserInteractionEnabled = false
        imgPlusMenu.isHidden = true
        imgPlusMenu.addGestureRecognizer(tapGestureRecognizer)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var STRdtDateOrder:Date = Date()
        if self.isfromWEEK == true {
            print("APPOINMENT_DICT b.\( APPOINMENT_DICT)")
            
            var descriere:String = ""
            var  nvSupplierName = ""
            var nvAddress = ""
            var orastart:String = ""
            var oraend:String = ""
            //  let event =  Global.sharedInstance.arrEvents[indexPathRow]
            
            orastart = APPOINMENT_DICT.object(forKey: "fromHour") as! String
            oraend =  APPOINMENT_DICT.object(forKey: "toHour") as! String
            
            let st =  "\(orastart) - \(oraend)"
            
            if let STRnvSupplierName =  APPOINMENT_DICT.object(forKey: "nvSupplierName") as? String
            {
                nvSupplierName = STRnvSupplierName
                print("STRnvSupplierName\(STRnvSupplierName)")
            }
            if let STRnvAddress =  APPOINMENT_DICT.object(forKey: "nvAddress") as? String
            {
                nvAddress = STRnvAddress
                print("STRnvAddress\(STRnvAddress)")
            }
            
            var descrierealong:String = ""
            var SimpleArrayOfServicesName:[String] = []
            var caterows:Int = 0
            if isOcasionalCustomer == true {
                if let _:String = APPOINMENT_DICT.object(forKey: "nvComment") as? String {
                    let myocassionalphone:String = APPOINMENT_DICT.object(forKey: "nvComment") as! String
                    userAPPOINMENT_DICT["nvPhone"] = myocassionalphone
                } else {
                    btnCALL.isHidden = true
                }
            }
            if isBLOCKED == true {
                descrierealong = "BlockedBySupplier"
                self.btnCALL.isHidden = true
            } else {
                if let objProviderServiceDetails =  APPOINMENT_DICT.object(forKey: "objProviderServiceDetails") as? NSArray
                {
                    caterows = objProviderServiceDetails.count
                    for i in 0 ..< caterows {
                        if let x:NSDictionary = objProviderServiceDetails[i] as? NSDictionary {
                            print("x.description \(x.description)")
                            if let _:String = x.object(forKey: "nvServiceName") as? String {
                                descriere = x.object(forKey: "nvServiceName") as! String
                                print("descriere 2\(descriere)")
                                if !SimpleArrayOfServicesName.contains(descriere) {
                                    SimpleArrayOfServicesName.append(descriere)
                                }
                            }
                        }
                    }
                }
                
                
                
                descrierealong = SimpleArrayOfServicesName.joined(separator: ", ")
                
            }
            
            
            lblTitle.text = "DETAILS_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            lblDate.text = dateFormatter.string(from: STRdtDateOrder)
            lblHour.text = st
            let dayWeek = Calendar.sharedInstance.getDayOfWeek(STRdtDateOrder)
            let str =   moreexactlocalizablestringsfordays(dayWeek! )
            lblDay.text = str
            if let _:String = APPOINMENT_DICT.object(forKey: "nvFullName") as? String {
                let customernvFullName:String = APPOINMENT_DICT.object(forKey: "nvFullName") as! String
                if customernvFullName != "" {
                     lblSupllierName.text = customernvFullName
                } else {
            lblSupllierName.text = nvSupplierName
                }
            } else {
              lblSupllierName.text = nvSupplierName
            }
            lblSupplierService.text = descrierealong
            lblSupplierAddress.text = nvAddress
            
            print("appoinment dict \(APPOINMENT_DICT)")
            print("nvSupplierName da da \(nvSupplierName)")
            
            self.view.addBackground2()
            didClickOK = false
            
        } else
            if self.isfromLIST == false   {
                if let ORDERDATE =  APPOINMENT_DICT.object(forKey: "dtDateOrder") as? String
                {
                    STRdtDateOrder = Global.sharedInstance.getStringFromDateString(ORDERDATE)
                    print("STRdtDateOrder\(STRdtDateOrder)")
                }
                var STRStartDate:Date = Date()
                var STREndDate:Date = Date()
                var descriere:String = ""
                var  nvSupplierName = ""
                var nvAddress = ""
                if let nvFromHour =  APPOINMENT_DICT.object(forKey: "nvFromHour") as? String
                {
                    STRStartDate = Global.sharedInstance.getStringFromDateString(nvFromHour)
                    print("STRStartDate\(STRStartDate)")
                }
                if let nvToHour =  APPOINMENT_DICT.object(forKey: "nvToHour") as? String
                {
                    STREndDate = Global.sharedInstance.getStringFromDateString(nvToHour)
                    print("STREndDate\(STREndDate)")
                }
                if let STRnvSupplierName =  APPOINMENT_DICT.object(forKey: "nvSupplierName") as? String
                {
                    nvSupplierName = STRnvSupplierName
                    print("STRnvSupplierName\(STRnvSupplierName)")
                }
                if let STRnvAddress =  APPOINMENT_DICT.object(forKey: "nvAddress") as? String
                {
                    nvAddress = STRnvAddress
                    print("STRnvAddress\(STRnvAddress)")
                }
                
                var descrierealong:String = ""
                var SimpleArrayOfServicesName:[String] = []
                var caterows:Int = 0
                if isOcasionalCustomer == true {
                    if let _:String = APPOINMENT_DICT.object(forKey: "nvComment") as? String {
                        let myocassionalphone:String = APPOINMENT_DICT.object(forKey: "nvComment") as! String
                        userAPPOINMENT_DICT["nvPhone"] = myocassionalphone
                    } else {
                        btnCALL.isHidden = true
                    }
                }
                if isBLOCKED == true {
                    descrierealong = "BlockedBySupplier"
                } else {
                    if let objProviderServiceDetails =  APPOINMENT_DICT.object(forKey: "objProviderServiceDetails") as? NSArray
                    {
                        caterows = objProviderServiceDetails.count
                        for i in 0 ..< caterows {
                            if let x:NSDictionary = objProviderServiceDetails[i] as? NSDictionary {
                                print("x.description \(x.description)")
                                if let _:String = x.object(forKey: "nvServiceName") as? String {
                                    descriere = x.object(forKey: "nvServiceName") as! String
                                    print("descriere 2\(descriere)")
                                    if !SimpleArrayOfServicesName.contains(descriere) {
                                        SimpleArrayOfServicesName.append(descriere)
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                    descrierealong = SimpleArrayOfServicesName.joined(separator: ", ")
                }
                let calendars = Foundation.Calendar.current
                let componentsStart = (calendars as NSCalendar).components([.hour, .minute], from: STRStartDate)
                let componentsEnd = (calendars as NSCalendar).components([.hour, .minute], from: STREndDate)
                let hourS = componentsStart.hour
                let minuteS = componentsStart.minute
                var hourS_Show:String = hourS!.description
                var minuteS_Show:String = minuteS!.description
                let hourE = componentsEnd.hour
                let minuteE = componentsEnd.minute
                var hourE_Show:String = hourE!.description
                var minuteE_Show:String = minuteE!.description
                if isBLOCKED == false {
                if hourS! < 10
                {
                    hourS_Show = "0" + hourS_Show
                }
                if hourE! < 10
                {
                    hourE_Show = "0" + hourE_Show
                }
                if minuteS! < 10
                {
                    minuteS_Show = "0" +   minuteS_Show
                }
                if minuteE! < 10 
                {
                    minuteE_Show = "0" + minuteE_Show
                }
                }
                let st =  "\(hourS_Show):\(minuteS_Show) - \(hourE_Show):\(minuteE_Show)"
                
                
                lblTitle.text = "DETAILS_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                lblDate.text = dateFormatter.string(from: STRdtDateOrder)
                lblHour.text = st
                let dayWeek = Calendar.sharedInstance.getDayOfWeek(STRdtDateOrder)
                
             //   let dayInWeek = DateFormatter().weekdaySymbols[dayWeek! - 1]
                let str =   moreexactlocalizablestringsfordays(dayWeek!)
                lblDay.text = str
           //     lblDay.text = dayInWeek
              //  lblSupllierName.text = nvSupplierName
                if let _:String = APPOINMENT_DICT.object(forKey: "nvFullName") as? String {
                    let customernvFullName:String = APPOINMENT_DICT.object(forKey: "nvFullName") as! String
                    if customernvFullName != "" {
                        lblSupllierName.text = customernvFullName
                    } else {
                        lblSupllierName.text = nvSupplierName
                    }
                }
                
                else if let nvFname:String = APPOINMENT_DICT.object(forKey: "nvFirstName") as? String
                {
                    if let nvLname:String = APPOINMENT_DICT.object(forKey: "nvLastName") as? String
                    {
                        if nvFname != "" {
                            lblSupllierName.text = nvFname + " " + nvLname
                        } else {
                            lblSupllierName.text = nvSupplierName
                        }
                    }

                }
                
                else if let nvNN:String = APPOINMENT_DICT.object(forKey: "nvNickName") as? String
                {
                    if nvNN != "" {
                        lblSupllierName.text = nvNN
                    } else {
                        lblSupllierName.text = nvSupplierName
                    }
                }
                    
                else {
                    lblSupllierName.text = nvSupplierName
                }
                lblSupplierService.text = descrierealong
                lblSupplierAddress.text = nvAddress
                
                print("appoinment dict \(APPOINMENT_DICT)")
                print("nvSupplierName da da \(nvSupplierName)")
                
                self.view.addBackground2()
                didClickOK = false
            } else {
                if isOcasionalCustomer == true {
                    if let _:String = EVENT_DICT.nvComment as String? {
                        let myocassionalphone:String = EVENT_DICT.nvComment
                        userAPPOINMENT_DICT["nvPhone"] = myocassionalphone
                    } else {
                        btnCALL.isHidden = true
                    }
                }

                var STRdtDateEvent = ""
                if let ORDERDATE:Date =  EVENT_DICT.dateEvent as Date?
                {
                    STRdtDateEvent = dateFormatter.string(from: ORDERDATE)
                    STRdtDateOrder = ORDERDATE
                    print("STRdtDateOrder\(STRdtDateEvent)")
                }
                
                var  ClientnvFullName = ""
                var nvAddress = ""
                var STRStartDate:String = ""
                var STREndDate = ""
                print("EVENT_DICT.fromHour\(EVENT_DICT.fromHour)")
                if let nvFromHour:String =  EVENT_DICT.fromHour as String?
                {
                    STRStartDate = nvFromHour
                    print("STRStartDate\(STRStartDate)")
                }
                if let nvToHour:String =  EVENT_DICT.toHour as String?
                {
                    STREndDate = nvToHour
                    print("STREndDate\(STREndDate)")
                    
                }
                
                if let STRnvAddress:String =  EVENT_DICT.nvAddress as String?
                {
                    nvAddress = STRnvAddress
                    print("STRnvAddress\(STRnvAddress)")
                }
                
                var descrierealong:String = ""
                if isBLOCKED == true {
                    descrierealong = "BlockedBySupplier"
                } else {
                    if let nvServiceName:String =  EVENT_DICT.nvServiceName as String?
                    {
                        descrierealong = nvServiceName
                    }
                }
                if let numeClient:String = EVENT_DICT.ClientnvFullName as String?
                {
                    ClientnvFullName = numeClient
                }
                
                let st = "\(STRStartDate) - \(STREndDate)"
                lblTitle.text = "DETAILS_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                lblDate.text = dateFormatter.string(from: STRdtDateOrder)
                lblHour.text = st
                let dayWeek = Calendar.sharedInstance.getDayOfWeek(STRdtDateOrder)
                let str =   moreexactlocalizablestringsfordays(dayWeek!)
                lblDay.text = str
                lblSupllierName.text = ClientnvFullName
                lblSupplierService.text = descrierealong
                lblSupplierAddress.text = nvAddress
                self.view.addBackground2()
                // Do any additional setup after loading the view.
                didClickOK = false
                
                
                
        }
        
            if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0
            {
                if self.isBLOCKED == true
                {
                   if Global.sharedInstance.employeesPermissionsArray.contains(5) == false
                   {
                    self.btnCancel.isHidden = true
                    self.btnCancel.isUserInteractionEnabled = true
                    }
                }
            }

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
        //\\  self.getFreeDaysForServiceProvider()//קבלת רשימת התורים הפנויים מעודכנת
    }
    
    //שמירת ארוע ביזר במכשיר
    func saveEventInDeviceCalander()
    {
    }
    
    //קבלת ימים פנויים לנותן שרות
    func getFreeDaysForServiceProvider(){
    }
    
    //פותחת את תפריט הפלוס הצידי
    @objc func imageTapped(){
        var clientStoryBoard2:UIStoryboard?
        clientStoryBoard2 = UIStoryboard(name: "Testing", bundle: nil)
        let viewCon:ClientNewEvent = clientStoryBoard2?.instantiateViewController(withIdentifier: "ClientNewEvent") as! ClientNewEvent
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }
    
    //פתיחת דף ראשי של לקוח קיים
    func openCustomer()
    {
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        
        //initialize REAR View Controller- it is the LEFT hand menu.
        
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
    
    
    func openCalendar() {
        
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
        self.view.window!.rootViewController = mainRevealController
        self.view.window?.makeKeyAndVisible()
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
    }
    
    func dismiss()
    {

          //  Global.sharedInstance.whichReveal = true

        if Global.sharedInstance.model == 2//יומן ספק שהלקוח רואה
        {
            Global.sharedInstance.isCancelAppointmentClick = true
            Calendar.sharedInstance.carrentDate = Date()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
            let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
            let modelclendar:ModelCalendarForAppointmentsViewController = clientStoryBoard.instantiateViewController(withIdentifier: "ModelCalendarForAppointments") as! ModelCalendarForAppointmentsViewController
            modelclendar.modalPresentationStyle = UIModalPresentationStyle.custom
            frontViewController.pushViewController(modelclendar, animated: false)
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontViewController
            mainRevealController.rearViewController = rearViewController
            self.view.window!.rootViewController = mainRevealController
            self.view.window?.makeKeyAndVisible()
        }
        else
        {
            Global.sharedInstance.isCancelAppointmentClick = true
            Calendar.sharedInstance.carrentDate = Date()
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
    
    @objc func dismissPopUp()
    {
        dismiss()
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
    
    func cancelOrder(_ idTurn:Int) {
        self.dismissKeyBoard()
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iSupplierId"] = Global.sharedInstance.providerID as AnyObject
        if Global.sharedInstance.providerID == 0 {
            dic["iSupplierId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dic["iSupplierId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            }
        } else {
            dic["iSupplierId"] = Global.sharedInstance.providerID as AnyObject
        }
        //send nvComment txtComment
        let nvComment = self.txtComment.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        dic["nvComment"] = nvComment as AnyObject
        dic["iCoordinatedServiceId"] = idTurn as AnyObject
        dic["iPhoneOsType"] = 1 as AnyObject
        api.sharedInstance.SupplierCancelOrder(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                print("cancel order  responseObject\( RESPONSEOBJECT.description)")
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                    
//                                self.showAlertDelegateX("SUCCESS_CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        
                        let alertController = UIAlertController(title: "", message: "SUCCESS_CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                        let alertAction = UIAlertAction( title : "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE) ,
                                                         style : UIAlertAction.Style.default)
                        {  UIAlertAction in
                            
//                        self.btncancelApp.isUserInteractionEnabled = true
                            
                        if self.isfromWEEK == true
                        {
                                self.openCalendar()
                        }
                        else if self.isfromLIST == false
                        {
                            self.openMycustomers()
                        }
                        else
                        {
                           self.openCalendar()
                        }
                          self.viewCancel.isHidden = true
                           
                        }
                        
                        
                        
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: false, completion: nil)
                        
                    }
                    else
                    {
                    
//                            self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        let alertController = UIAlertController(title: "", message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                        let alertAction = UIAlertAction( title : "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE) ,
                                                         style : UIAlertAction.Style.default)
                        {  UIAlertAction in
                            
//                            self.btncancelApp.isUserInteractionEnabled = true
                            
                            if self.isfromWEEK == true
                            {
                                self.openCalendar()
                            }
                            else if self.isfromLIST == false
                            {
                                self.openMycustomers()
                            }
                            else
                            {
                                self.openCalendar()
                            }
                            self.viewCancel.isHidden = true
                            
                        }
                        
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: false, completion: nil)
                        
                     
                        
                    }
                }
            }

        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
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
                            self.lblAdvertising.tag = 101
                            self.lblAdvertising.type = .continuous
                            self.lblAdvertising.animationCurve = .linear
                            self.lblAdvertising.type = .leftRight
                            self.lblAdvertising.text  = abcd
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
    
}
