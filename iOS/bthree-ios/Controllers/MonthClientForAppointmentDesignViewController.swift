//
//  MonthClientForAppointmentDesignViewController.swift
//  Bthere
//
//  Created by User on 24.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


//תצוגת חודש של יומן ספק שהלקוח רואה

class MonthClientForAppointmentDesignViewController:UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,reloadTableFreeDaysDelegate,iCarouselDataSource, iCarouselDelegate{
    var ProviderServicesArray:Array<objProviderServices> = Array<objProviderServices>()
    var MyMonthsNames:NSArray = [ "January".localized(LanguageMain.sharedInstance.USERLANGUAGE), "February".localized(LanguageMain.sharedInstance.USERLANGUAGE), "March".localized(LanguageMain.sharedInstance.USERLANGUAGE), "April".localized(LanguageMain.sharedInstance.USERLANGUAGE), "May".localized(LanguageMain.sharedInstance.USERLANGUAGE), "June".localized(LanguageMain.sharedInstance.USERLANGUAGE), "July".localized(LanguageMain.sharedInstance.USERLANGUAGE), "August".localized(LanguageMain.sharedInstance.USERLANGUAGE), "September".localized(LanguageMain.sharedInstance.USERLANGUAGE), "October".localized(LanguageMain.sharedInstance.USERLANGUAGE), "November".localized(LanguageMain.sharedInstance.USERLANGUAGE),  "December".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var isfromSPECIALiCustomerUserId:Int = 0
    var isfromSPECIALSUPPLIER:Bool = false
    var bIsNext:Bool = false
    var ISNONEED:Bool = false
    var howmanytosend:Int = 0
    var whichindextosend:Int = 0
    var myarr:Array<OrderObj> = Array<OrderObj>()
    //MARK: - variables
    @IBOutlet var arrowleft: UIImageView!
    @IBOutlet var arrowright: UIImageView!
    var iMonth:Int = 0
    var iYear:Int = 0
    var iDay:Int = 0
    @IBOutlet var carousel: iCarousel!
    var selectedWorkerID:Int = 0
    var generic:Generic = Generic()
    @IBOutlet var btnBACK: UIButton!
    fileprivate let kKeychainItemName = "Google Calendar API"
    fileprivate let kClientID = "284147586677-69842kmfbfll1dmec57c9gklqnpa5n2u.apps.googleusercontent.com"

    var delegate:openMonthDelegte!=nil

    let output = UITextView()

    var today: Date = Date()

    var dateFormatter = DateFormatter()

    let language = Bundle.main.preferredLocalizations.first! as NSString
    var arrEventsCurrentDay:Array<EKEvent> = []

    var days:Array<Int> = []
    var numDaysInMonth:Int = 0
    var dateFirst:Date = Date()
    var dayInWeek:Int = 0
    var i = 1
    var dayToday:Int = 0
    var monthToday:Int = 0
    var monthTodayNotChanged:Int = 0
    var yearToday:Int = 0
    var hasEvent = false
    var moneForBackColor = 1//בשביל הימים שעברו(שקיפות כנראה) For the past days (apparently transparency)
    let calendar = Foundation.Calendar.current
    var titles : [String] = []
    var startDates : [Date] = []
    var endDates : [Date] = []

    let eventStore = EKEventStore()
    var shouldShowDaysOut = true
    var animationFinished = true
    var currentDate:Date = Date()
    var bthereEventDateDayInt:Array<Int> = Array<Int>()// ימים שיש בהם אירוע
    //MARK: - @IBOutlet
    @IBOutlet weak var tblWorkers: UITableView!

    @IBOutlet weak var lblDayOfWeek1: UILabel!

    @IBOutlet weak var lblDayOfWeek2: UILabel!

    @IBOutlet weak var lblDayOfWeek3: UILabel!

    @IBOutlet weak var lblDayOfWeek4: UILabel!

    @IBOutlet weak var lblDayOfWeek5: UILabel!

    @IBOutlet weak var lblDayOfWeek6: UILabel!

    @IBOutlet weak var lblDayOfWeek7: UILabel!

    @IBOutlet var collDays: UICollectionView!

    @IBOutlet var lblHebrewDate: UILabel!
    @IBOutlet var lblCurrentDate: UILabel!

    @IBOutlet weak var btnBefore: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewSync: UIView!

    @IBOutlet weak var btnSync: eyeSynCheckBox!
    //MARK: - @IBAction
    @IBAction func btnBACK(_ sender: AnyObject){
        if isfromSPECIALSUPPLIER == false {
            //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //
            //        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            //
            //        let vc = storyboard.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
            //        let viewCon = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as!  entranceCustomerViewController
            //        if Global.sharedInstance.currentUser.iUserId == 0 {
            //            frontviewcontroller?.pushViewController(vc, animated: false)
            //        } else {
            //            frontviewcontroller?.pushViewController(viewCon, animated: false)
            //        }
            //
            //        //initialize REAR View Controller- it is the LEFT hand menu.
            //
            //        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            //        let mainRevealController = SWRevealViewController()
            //
            //        mainRevealController.frontViewController = frontviewcontroller
            //        mainRevealController.rearViewController = rearViewController
            //        let window :UIWindow = UIApplication.shared.keyWindow!
            //        window.rootViewController = mainRevealController
            getProviderServicesForSupplierFunctoback()
        } else {
            Global.sharedInstance.whichReveal = true
            let frontviewcontroller:UINavigationController? = UINavigationController()
            let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
            isfromSPECIALSUPPLIER = false
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
    }


    @IBAction func btnSync(_ sender: eyeSynCheckBox) {
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            if (sender.isCecked == false) {
                Global.sharedInstance.getEventsFromMyCalendar()
                Global.sharedInstance.isSyncWithGoogleCalendarAppointment = true
                i = 1
                collDays.reloadData()
            } else {
                Global.sharedInstance.isSyncWithGoogleCalendarAppointment = false
                i = 1
                collDays.reloadData()
            }
        }
    }


    //func set prev date on click prev btn
    func hidetoast(){
        view.hideToastActivity()
    }

    func checknumberofweeks() -> Bool {
        var isoverweeks:Bool = false
        var weekstoshowandlimit:Int = 0
        let USERDEF = UserDefaults.standard
        if isfromSPECIALSUPPLIER == false {
            if Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS == false {
                if  USERDEF.object(forKey: "CALENDARWEEKSFORSUPPLIER") == nil {
                    USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
                    USERDEF.synchronize()
                    weekstoshowandlimit = USERDEF.integer(forKey: "CALENDARWEEKSFORSUPPLIER")
                }
                if USERDEF.object(forKey: "CALENDARWEEKSFORSUPPLIER") != nil {
                    let myweeks = USERDEF.integer(forKey: "CALENDARWEEKSFORSUPPLIER")
                    if myweeks == 0 {
                        USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
                    }
                    USERDEF.synchronize()
                    weekstoshowandlimit = USERDEF.integer(forKey: "CALENDARWEEKSFORSUPPLIER")
                }
                else {
                    USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
                    USERDEF.synchronize()
                }
                weekstoshowandlimit = USERDEF.integer(forKey: "CALENDARWEEKSFORSUPPLIER")
            } else {
                if USERDEF.object(forKey: "WEEKSFORSUPPLIER") != nil {
                    let myweeks = USERDEF.integer(forKey: "WEEKSFORSUPPLIER")
                    if myweeks == 0 {
                        USERDEF.set(52, forKey: "WEEKSFORSUPPLIER")
                    }
                    USERDEF.synchronize()
                    weekstoshowandlimit = USERDEF.integer(forKey: "WEEKSFORSUPPLIER")
                }
            }
        } else {
            weekstoshowandlimit = 52
            USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
            USERDEF.synchronize()
        }
        if weekstoshowandlimit == 0 {
            weekstoshowandlimit = 52
        }
        let flags = NSCalendar.Unit.weekOfYear
        let components = (calendar as NSCalendar).components(flags, from: Date(), to: Calendar.sharedInstance.carrentDate as Date, options: [])

        if components.weekOfYear! >= weekstoshowandlimit {
            isoverweeks = true
        }
        return isoverweeks
    }
    func getonlyorders() {
        print("no more show:")
        Global.sharedInstance.dateFreeDays = []
        print("Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")
        Global.sharedInstance.fromHourArray = []
        Global.sharedInstance.endHourArray = []
        Global.sharedInstance.dateFreeDays = []
        Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
        self.GetCustomerOrders()
    }
    @IBAction func btnBefore(_ sender: UIButton) {
        //currentDate =
        Calendar.sharedInstance.carrentDate = Calendar.sharedInstance.removeMonth(Calendar.sharedInstance.carrentDate)
        let componentsCurrentinus = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
        let monthtoaskq = componentsCurrentinus.month
        let yeartoaskq = componentsCurrentinus.year
        //\\  let daytoaskq = componentsCurrentinus.day

        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        let monthtoask = componentsCurrent.month
        let yeartoask = componentsCurrent.year
        let daytoask = componentsCurrent.day

        if monthtoaskq! < monthtoask! && yeartoaskq! <= yeartoask!  {
            Calendar.sharedInstance.carrentDate = Calendar.sharedInstance.addMonth(Calendar.sharedInstance.carrentDate)
            print("no more meetings in the past")
            self.view.makeToast(message: "DAY_PASSED".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })

        } else {
            numDaysInMonth = Calendar.sharedInstance.getNumsDays(Calendar.sharedInstance.carrentDate)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
            dateFirst = Calendar.sharedInstance.getFirstDay(Calendar.sharedInstance.carrentDate)//מחזירה את התאריך הראשון של החודש שנשלח
            dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!


            i = 1
            print("Calendar.sharedInstance.carrentDate before\(Calendar.sharedInstance.carrentDate)")
            moneForBackColor = 1
            iDay = 1
            if iMonth == 1 {
                //past year
                iMonth = 12
                iYear = iYear - 1
            }
            else if iMonth  <= 12  && iMonth != 1{
                iMonth = iMonth - 1
            }
            /*
             if iFilterByMonth == 12 {
             iFilterByMonth = 1
             iFilterByYear = iFilterByYear + 1
             iFilterByMonthEnd = 1
             iFilterByYearEnd = iFilterByYear
             } else if iFilterByMonth < 12 {
             iFilterByMonth = iFilterByMonth + 1
             iFilterByMonthEnd = iFilterByMonth
             iFilterByYearEnd = iFilterByYear
             }
             */
            let COMPOSEDONEDATE:String = String(iYear) + "-" + String(iMonth) + "-" + String(iDay) + " 03:00:00  +0000"
            let dateFormatterx = DateFormatter()
            dateFormatterx.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dates = dateFormatterx.date(from: COMPOSEDONEDATE)
            iFilterByMonth = iMonth
            iFilterByYear = iYear

            ///the case user comes back from -1 month of today
            if iMonth == monthtoask && iYear == yeartoask {
                iDay = daytoask!
                Calendar.sharedInstance.carrentDate = today
                if checknumberofweeks() == true {
                    getonlyorders()
                } else {
                    //\\    getFreeDaysForServiceProvider(false, NONEED: true)
                    GetFreeTimesForServiceProviderByDaysOrHoures()
                }
                numDaysInMonth = Calendar.sharedInstance.getNumsDays(Calendar.sharedInstance.carrentDate)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
                dateFirst = Calendar.sharedInstance.getFirstDay(Calendar.sharedInstance.carrentDate)//מחזירה את התאריך הראשון של החודש שנשלח
                dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!
            } else {
                numDaysInMonth = Calendar.sharedInstance.getNumsDays(dates!)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
                dateFirst = Calendar.sharedInstance.getFirstDay(dates!)//מחזירה את התאריך הראשון של החודש שנשלח
                dayInWeek = Calendar.sharedInstance.getDayOfWeek(dates!)!
                Calendar.sharedInstance.carrentDate = dates!
                if checknumberofweeks() == true {
                    getonlyorders()
                } else {
                    //\\    getFreeDaysForServiceProvider(true, NONEED: true)
                    GetFreeTimesForServiceProviderByDaysOrHoures()
                }

            }
        }
        print("Calendar.sharedInstance.carrentDate  before end\(Calendar.sharedInstance.carrentDate)")

    }
    //func set next date on click next btn

    @IBAction func btnNext(_ sender: UIButton) {


        i = 1
        moneForBackColor = 1
        //                //refresh bthere event when date selected change
        print("Calendar.sharedInstance.carrentDate  before next\(Calendar.sharedInstance.carrentDate)")
        iDay = 1
        if iMonth == 12 {
            iMonth = 1
            iYear = iYear + 1

        } else if iMonth < 12 {
            iMonth = iMonth + 1
        }
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        let monthtoask = componentsCurrent.month
        let yeartoask = componentsCurrent.year
        let daytoask = componentsCurrent.day

        let COMPOSEDONEDATE:String = String(iYear) + "-" + String(iMonth) + "-" + String(iDay) + " 03:00:00  +0000"
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dates = dateFormatterx.date(from: COMPOSEDONEDATE)
        iFilterByMonth = iMonth
        iFilterByYear = iYear

        ///the case user comes back from -1 month of today
        if iMonth == monthtoask && iYear == yeartoask {
            iDay = daytoask!
            Calendar.sharedInstance.carrentDate = today
            if checknumberofweeks() == true {
                getonlyorders()
            } else {
                //  getFreeDaysForServiceProvider(false, NONEED: true)
                GetFreeTimesForServiceProviderByDaysOrHoures()
            }
            numDaysInMonth = Calendar.sharedInstance.getNumsDays(Calendar.sharedInstance.carrentDate)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
            dateFirst = Calendar.sharedInstance.getFirstDay(Calendar.sharedInstance.carrentDate)//מחזירה את התאריך הראשון של החודש שנשלח
            dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!
        } else {
            if iMonth < monthtoask || iYear < yeartoask {
                numDaysInMonth = Calendar.sharedInstance.getNumsDays(dates!)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
                dateFirst = Calendar.sharedInstance.getFirstDay(dates!)//מחזירה את התאריך הראשון של החודש שנשלח
                dayInWeek = Calendar.sharedInstance.getDayOfWeek(dates!)!
                Calendar.sharedInstance.carrentDate = dates!
                if checknumberofweeks() == true {
                    getonlyorders()
                } else {
                    //  getFreeDaysForServiceProvider(true, NONEED: false)
                    GetFreeTimesForServiceProviderByDaysOrHoures()
                }
            }else {
                numDaysInMonth = Calendar.sharedInstance.getNumsDays(dates!)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
                dateFirst = Calendar.sharedInstance.getFirstDay(dates!)//מחזירה את התאריך הראשון של החודש שנשלח
                dayInWeek = Calendar.sharedInstance.getDayOfWeek(dates!)!
                Calendar.sharedInstance.carrentDate = dates!
                if checknumberofweeks() == true {
                    getonlyorders()
                } else {
                    //  getFreeDaysForServiceProvider(true, NONEED: true)
                    GetFreeTimesForServiceProviderByDaysOrHoures()
                }
            }

        }
        print("Calendar.sharedInstance.carrentDate  before next end\(Calendar.sharedInstance.carrentDate)")
       //   GENERATEORDERS()

    }
    func updatefornextbtn(_ bIsNext:Bool,ISNONEED:Bool){
        let COMPOSEDONEDATE:String = String(iYear) + "-" + String(iMonth) + "-" + String(iDay) + " 03:00:00  +0000"
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dates = dateFormatterx.date(from: COMPOSEDONEDATE)
        Calendar.sharedInstance.carrentDate  =  dates!
        print("Calendar.sharedInstance.carrentDate  perfect sense\(Calendar.sharedInstance.carrentDate)")
        setEventsArray()
        setEventBthereInMonth()
        let Mycalendar: Foundation.Calendar = Foundation.Calendar(identifier: .hebrew)
        print("whheck\( Calendar.sharedInstance.carrentDate)")
        changeLblDate()
        self.reloadTableFreeDays()
        //\\
    //  GENERATEORDERS()

    }

    //carousel

    func numberOfItems(in carousel: iCarousel) -> Int {
        if Global.sharedInstance.giveServicesArray.count > 0 {
            if Global.sharedInstance.giveServicesArray.count > 1 {
                carousel.type = .linear
            } else {
                carousel.type = .linear
                carousel.isUserInteractionEnabled = false
            }
        }

        print("self.arrayWorkers.count \(Global.sharedInstance.arrayWorkers.count)")
        print("array workers give count: \( Global.sharedInstance.giveServicesArray.count)")
        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 && Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil
        {
            return Global.sharedInstance.giveServicesArray.count
        }
        else
        {
            return Global.sharedInstance.arrayWorkers.count
        }
        
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {

        let  index:Int = carousel.currentItemIndex

        var workerid:Int = 0
        if  Global.sharedInstance.giveServicesArray.count > 0 {
            if let _:User = Global.sharedInstance.giveServicesArray[index] as? User {
                let MYD:User = Global.sharedInstance.giveServicesArray[index]

                if let _:Int =  MYD.iUserId
                {
                    workerid =  MYD.iUserId
                    Global.sharedInstance.defaults.set(workerid, forKey: "idSupplierWorker")
                    Global.sharedInstance.defaults.synchronize()
                    print("month item did change idSupplierWorker after picked: \(Global.sharedInstance.defaults.object(forKey: "idSupplierWorker"))")
                    if workerid > 0 {
                        Global.sharedInstance.idWorker = workerid
                        Global.sharedInstance.indexRowForIdGiveService = workerid
                    } else {
                        Global.sharedInstance.idWorker = -1
                        Global.sharedInstance.indexRowForIdGiveService = -1
                    }
                }
                //                let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
                //                let monthtoask = componentsCurrent.month
                //                let yeartoask = componentsCurrent.year
                //                let daytoask = componentsCurrent.day
                //                if iMonth == monthtoask && iYear == yeartoask {
                //                    iDay = daytoask
                //                    Calendar.sharedInstance.carrentDate = today
                print("workerid \(workerid) si \(index)")
                //      getFreeDaysForServiceProvider(false, NONEED: true)
                //                    GetFreeTimesForServiceProviderByDaysOrHoures()
                //                } else {
                //                    if iMonth < monthtoask || iYear < yeartoask {
                //              //          getFreeDaysForServiceProvider(true, NONEED: false)
                //                        GetFreeTimesForServiceProviderByDaysOrHoures()
                //                    } else {
                //                 //       getFreeDaysForServiceProvider(true, NONEED: true)
                if checknumberofweeks() == true {
                    getonlyorders()
                } else {
                    //  getFreeDaysForServiceProvider(true, NONEED: true)
                    GetFreeTimesForServiceProviderByDaysOrHoures()
                }
            }
            // }

        }


        if  Global.sharedInstance.giveServicesArray.count > 1 {
            for itemView in carousel.visibleItemViews {
                for subview in (itemView as AnyObject).subviews as [UIView] {
                    if let labelView = subview as? UILabel {
                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 16)
                        labelView.font = labelFont
                        let attr = NSMutableAttributedString(string: labelView.text!)
                        attr.removeAttribute(NSAttributedString.Key.underlineStyle, range: NSMakeRange(0, attr.length))
                        labelView.attributedText = attr
                    }
                }
            }

            if let _:UIView = carousel.currentItemView {
                let myview:UIView = carousel.currentItemView!
                for subview in myview.subviews as [UIView] {
                    if let labelView = subview as? UILabel {
                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
                        labelView.font = labelFont
                        let underlineAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSUnderlineStyle.single.rawValue]
                        let mylblString:String = labelView.text!
                        let underlineAttributedString = NSAttributedString(string:mylblString, attributes: convertToOptionalNSAttributedStringKeyDictionary(underlineAttribute))
                        labelView.attributedText = underlineAttributedString

                    }
                }
            }
        } else {
            if let _:UIView = carousel.currentItemView {
                let myview:UIView = carousel.currentItemView!
                for subview in myview.subviews as [UIView] {
                    if let labelView = subview as? UILabel {
                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
                        labelView.font = labelFont
                        let underlineAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSUnderlineStyle.single.rawValue]
                        let mylblString:String = labelView.text!
                        let underlineAttributedString = NSAttributedString(string:mylblString, attributes: convertToOptionalNSAttributedStringKeyDictionary(underlineAttribute))
                        labelView.attributedText = underlineAttributedString
                        //     labelView.minimumScaleFactor = 0.5
                        //    labelView.adjustsFontSizeToFitWidth = true
                    }
                }
            }
        }
        //\\ setEventBthereInMonth()
        self.carousel.setNeedsLayout()
    }



    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView

        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
            if Global.sharedInstance.giveServicesArray.count > 1 {
                for itemView in carousel.visibleItemViews {
                    for subview in (itemView as AnyObject).subviews as [UIView] {
                        if let labelView = subview as? UILabel {
                            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 16)
                            labelView.font = labelFont
                        }
                    }
                }
                if let _:UIView = carousel.currentItemView {
                    let myview:UIView = carousel.currentItemView!
                    for subview in myview.subviews as [UIView] {
                        if let labelView = subview as? UILabel {
                            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
                            labelView.font = labelFont

                        }
                    }

                }
            }
            else  {
                if let _:UIView = carousel.currentItemView {
                    let myview:UIView = carousel.currentItemView!
                    for subview in myview.subviews as [UIView] {
                        if let labelView = subview as? UILabel {
                            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
                            labelView.font = labelFont

                        }
                    }
                }
            }



            label = itemView.viewWithTag(1) as! UILabel
        } else {

            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later

            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: carousel.frame.size.width / 2.4  , height: 55))
            itemView.image = UIImage(named: "")
            itemView.contentMode = .scaleAspectFill
            itemView.backgroundColor = UIColor.clear
            label = UILabel(frame: CGRect(x: itemView.frame.origin.x , y: itemView.frame.origin.y + 1, width:itemView.frame.size.width, height: itemView.frame.size.height - 6))
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            //   label.font = label.font.fontWithSize(18)
            //            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 18)
            //            label.font = labelFont

            label.numberOfLines = 1
            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
            label.font = labelFont

            // label.minimumScaleFactor = 0.8
            //   label.adjustsFontSizeToFitWidth = true
            label.textColor = Colors.sharedInstance.color4
            label.tag = 1

            //            let mybluecircle:UIImageView = UIImageView()
            //            mybluecircle.frame = itemView.frame
            //            mybluecircle.frame.size = CGSize(width: itemView.frame.size.height/4, height: itemView.frame.size.height/4)
            //            mybluecircle.image = UIImage(named:"bluecircleon.png")
            //            mybluecircle.contentMode = .ScaleAspectFit
            //            mybluecircle.center.y = itemView.center.y
            //            mybluecircle.frame.origin.x = itemView.frame.origin.x + 12
            //  itemView.addSubview(mybluecircle)
            itemView.addSubview(label)
            //  itemView.bringSubviewToFront(mybluecircle)
        }

        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        //    if index > 0 {
        if let _:User = Global.sharedInstance.giveServicesArray[index] as? User {
            let MYD:User = Global.sharedInstance.giveServicesArray[index]
            var STRinvFirstName:String = ""
            if let somethingelse3:String =  MYD.nvFirstName
            {
                STRinvFirstName = somethingelse3
            }

            var STRnvLastName:String = ""
            if let somethingelse4:String =  MYD.nvLastName
            {
                STRnvLastName = somethingelse4
            }
            let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
            print("index name \(STRnvFullName) si \(index)")
            //  label.text = STRnvFullName
            let underlineAttributedString = NSAttributedString(string:STRinvFirstName.capitalized, attributes: nil)
            label.attributedText = underlineAttributedString
            //label.attributedText = STRinvFirstName.capitalizedString
        }
        //    }else {
        //        let STRnvFullName:String = "NOT_CARE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //        label.text = STRnvFullName
        //    }
        if Global.sharedInstance.giveServicesArray.count > 1 {
            for itemView in carousel.visibleItemViews {
                for subview in (itemView as AnyObject).subviews as [UIView] {
                    if let labelView = subview as? UILabel {
                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 16)
                        labelView.font = labelFont
                    }
                }
            }
            if let _:UIView = carousel.currentItemView {
                let myview:UIView = carousel.currentItemView!
                for subview in myview.subviews as [UIView] {
                    if let labelView = subview as? UILabel {
                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
                        labelView.font = labelFont

                    }
                }

            }
        }
        else  {


            if let _:UIView = carousel.currentItemView {
                let myview:UIView = carousel.currentItemView!
                for subview in myview.subviews as [UIView] {
                    if let labelView = subview as? UILabel {
                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
                        labelView.font = labelFont
                        labelView.setNeedsLayout()
                        labelView.setNeedsLayout()
                    }
                }
            }
            for itemView in carousel.visibleItemViews {
                for subview in (itemView as AnyObject).subviews as [UIView] {
                    if let labelView = subview as? UILabel {
                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
                        labelView.font = labelFont
                        labelView.setNeedsLayout()
                        labelView.setNeedsLayout()
                    }
                }
            }
        }




        return itemView

    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }

    //MARK: - Initials
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

        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            self.viewSync.isHidden = false
            self.btnSync.isHidden = false
        } else {
            self.viewSync.isHidden = true
            self.btnSync.isHidden = true
        }

        let leftarrowback = UIImage(named: "sageata2.png")

        self.btnBACK.setImage(leftarrowback, for: UIControl.State())
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)

        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnBACK.transform = scalingTransform
        }
        self.btnBACK.imageView!.contentMode = .scaleAspectFit

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        print("useridglobal \(isfromSPECIALiCustomerUserId)")
        print("e din suplier special \(isfromSPECIALSUPPLIER)")
        arrowleft.image =    UIImage(named: "arrow_left_J.png")
        arrowright.image =    UIImage(named: "arrow_right_J.png")
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
            arrowleft.transform = scalingTransform
            arrowright.transform = scalingTransform
        }
        arrowleft.contentMode = .scaleAspectFit
        arrowright.contentMode = .scaleAspectFit
        arrowleft.contentMode = .scaleAspectFit
        arrowright.contentMode = .scaleAspectFit
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let amonth = components.month
        let ayear = components.year
        let aday = components.day
        print("month ENGAGE  \(amonth) \(ayear) \(aday)")
        iMonth = amonth!
        iYear = ayear!
        iDay = aday!
        iFilterByMonth = iMonth
        iFilterByYear = iYear
        //        Global.sharedInstance.defaults.setInteger(1, forKey: "mustreloadprovider")
        //        Global.sharedInstance.defaults.synchronize()
        carousel.delegate = self
        carousel.dataSource = self
//        if Global.sharedInstance.giveServicesArray.count > 0 {
//            let id  = Global.sharedInstance.giveServicesArray[0].iUserId
//            if id > 0 {
//                Global.sharedInstance.idWorker = id
//                Global.sharedInstance.indexRowForIdGiveService = 0
//            } else {
//                Global.sharedInstance.idWorker = -1
//                Global.sharedInstance.indexRowForIdGiveService = -1
//            }
//            self.carousel.scrollToItem(at: 0, animated: true)
        
        print("idSupplierWorker in month: \(Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int)")
        if Global.sharedInstance.giveServicesArray.count > 0
        {
            var counter:Int = 0
            if let _ = Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as? Int
            {
                if Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int != -1 && Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int != 0
                {
                    var counter:Int = 0
                    for i:User in Global.sharedInstance.giveServicesArray
                    {
                        if i.iUserId == Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int
                        {
                            Global.sharedInstance.idWorker = i.iUserId
                            Global.sharedInstance.indexRowForIdGiveService = counter
                            
                            
                        }
                        counter += 1
                    }
                    counter = 0
                    self.carousel.scrollToItem(at: Global.sharedInstance.indexRowForIdGiveService, animated: true)
                }
                else
                {
                    self.carousel.scrollToItem(at: 0, animated: true)
                }
            }
            else
            {
                self.carousel.scrollToItem(at: 0, animated: true)
            }
        }
        else
        {
            self.carousel.scrollToItem(at: 0, animated: true)
        }
        carousel.currentItemIndex = Global.sharedInstance.indexRowForIdGiveService

        self.carouselCurrentItemIndexDidChange(self.carousel)
        if checknumberofweeks() == true {
            getonlyorders()
        } else {
            GetFreeTimesForServiceProviderByDaysOrHoures()
        }
        
 
//            loadfirsttime()


        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            lblCurrentDate.font = UIFont(name: lblCurrentDate.font.fontName, size: 20)
        }

        today = Date()
        Calendar.sharedInstance.carrentDate = Date()//check if  use

        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        monthTodayNotChanged = componentsCurrent.month!

        if Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true
        {
            btnSync.isCecked = true
            i = 1
            collDays.reloadData()
        }
        else
        {
            btnSync.isCecked = false
            i = 1
            collDays.reloadData()
        }

        Global.sharedInstance.designMonthAppointment = self
        var dateFormatterw = DateFormatter()
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatterw = DateFormatter()
            dateFormatterw.locale = Locale(identifier: "he_IL")

        } else {
            dateFormatterw = DateFormatter()
            dateFormatterw.locale = Locale(identifier: "en_US")


        }
        dateFormatterw.dateFormat = "dd/MM/yyyy"
        dateFormatter.dateFormat = "dd/MM/yyyy"
        lblDayOfWeek1.text = dateFormatterw.veryShortWeekdaySymbols[6]
        lblDayOfWeek2.text = dateFormatterw.veryShortWeekdaySymbols[5]
        lblDayOfWeek3.text = dateFormatterw.veryShortWeekdaySymbols[4]
        lblDayOfWeek4.text = dateFormatterw.veryShortWeekdaySymbols[3]
        lblDayOfWeek5.text = dateFormatterw.veryShortWeekdaySymbols[2]
        lblDayOfWeek6.text = dateFormatterw.veryShortWeekdaySymbols[1]
        lblDayOfWeek7.text = dateFormatterw.veryShortWeekdaySymbols[0]
        // Global.sharedInstance.currDateSelected = NSDate()

        // Menu delegate [Required]
        // Do any additional setup after loading the view.
        numDaysInMonth = Calendar.sharedInstance.getNumsDays(Date())//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
        dateFirst = Calendar.sharedInstance.getFirstDay(Date())//מחזירה את התאריך הראשון של החודש שנשלח
        dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!//מחזירה את היום בשבוע של הראשון בחודש
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)

    }
    func bestmode() {

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

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let leftarrowback = UIImage(named: "sageata2.png")

        self.btnBACK.setImage(leftarrowback, for: UIControl.State())

        btnBACK.imageView!.contentMode = .scaleAspectFit
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        btnBACK.imageView!.contentMode = .scaleAspectFit
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnBACK.transform = scalingTransform
        }

        print("useridglobal \(isfromSPECIALiCustomerUserId)")
        print("e din suplier special \(isfromSPECIALSUPPLIER)")
        arrowleft.image =    UIImage(named: "arrow_left_J.png")
        arrowright.image =    UIImage(named: "arrow_right_J.png")
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
            arrowleft.transform = scalingTransform
            arrowright.transform = scalingTransform
        }
        arrowleft.contentMode = .scaleAspectFit
        arrowright.contentMode = .scaleAspectFit
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let amonth = components.month
        let ayear = components.year
        let aday = components.day
        print("month ENGAGE  \(amonth) \(ayear) \(aday)")
        iMonth = amonth!
        iYear = ayear!
        iDay = aday!
        iFilterByMonth = iMonth
        iFilterByYear = iYear
        //        Global.sharedInstance.defaults.setInteger(1, forKey: "mustreloadprovider")
        //        Global.sharedInstance.defaults.synchronize()
        carousel.delegate = self
        carousel.dataSource = self
//        if Global.sharedInstance.giveServicesArray.count > 0 {
//            let id  = Global.sharedInstance.giveServicesArray[0].iUserId
//            if id > 0 {
//                Global.sharedInstance.idWorker = id
//                Global.sharedInstance.indexRowForIdGiveService = 0
//            } else {
//                Global.sharedInstance.idWorker = -1
//                Global.sharedInstance.indexRowForIdGiveService = -1
//            }
//            self.carousel.scrollToItem(at: 0, animated: true)
//            loadfirsttime()
//        }
        print("idSupplierWorker in month: \(Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int)")
        
        if Global.sharedInstance.giveServicesArray.count > 0
        {
            var counter:Int = 0
            if let _ = Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as? Int
            {
                if Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int != -1 && Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int != 0
                {
                    var counter:Int = 0
                    for i:User in Global.sharedInstance.giveServicesArray
                    {
                        if i.iUserId == Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int
                        {
                            Global.sharedInstance.idWorker = i.iUserId
                            Global.sharedInstance.indexRowForIdGiveService = counter
                            
                            
                        }
                        counter += 1
                    }
                    counter = 0
                    self.carousel.scrollToItem(at: Global.sharedInstance.indexRowForIdGiveService, animated: true)
                }
                else
                {
                    self.carousel.scrollToItem(at: 0, animated: true)
                }
            }
            else
            {
                self.carousel.scrollToItem(at: 0, animated: true)
            }
        }
        else
        {
            self.carousel.scrollToItem(at: 0, animated: true)
        }
        carousel.currentItemIndex = Global.sharedInstance.indexRowForIdGiveService
        self.carouselCurrentItemIndexDidChange(self.carousel)
        
        if checknumberofweeks() == true {
            getonlyorders()
        } else {
            GetFreeTimesForServiceProviderByDaysOrHoures()
        }


        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{

            lblCurrentDate.font = UIFont(name: lblCurrentDate.font.fontName, size: 20)
        }

        today = Date()
        Calendar.sharedInstance.carrentDate = Date()//check if  use

        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        monthTodayNotChanged = componentsCurrent.month!
        if Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true
        {
            btnSync.isCecked = true
            i = 1
            collDays.reloadData()
        }
        else
        {
            btnSync.isCecked = false
            i = 1
            collDays.reloadData()
        }

        Global.sharedInstance.designMonthAppointment = self
        var dateFormatterw = DateFormatter()
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatterw = DateFormatter()
            dateFormatterw.locale = Locale(identifier: "he_IL")

        } else {
            dateFormatterw = DateFormatter()
            dateFormatterw.locale = Locale(identifier: "en_US")


        }
        dateFormatterw.dateFormat = "dd/MM/yyyy"

        lblDayOfWeek1.text = dateFormatterw.veryShortWeekdaySymbols[6]
        lblDayOfWeek2.text = dateFormatterw.veryShortWeekdaySymbols[5]
        lblDayOfWeek3.text = dateFormatterw.veryShortWeekdaySymbols[4]
        lblDayOfWeek4.text = dateFormatterw.veryShortWeekdaySymbols[3]
        lblDayOfWeek5.text = dateFormatterw.veryShortWeekdaySymbols[2]
        lblDayOfWeek6.text = dateFormatterw.veryShortWeekdaySymbols[1]
        lblDayOfWeek7.text = dateFormatterw.veryShortWeekdaySymbols[0]

        numDaysInMonth = Calendar.sharedInstance.getNumsDays(Date())//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
        dateFirst = Calendar.sharedInstance.getFirstDay(Date())//מחזירה את התאריך הראשון של החודש שנשלח
        dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!//מחזירה את היום בשבוע של הראשון בחודש
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
        //len


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            self.GoogleAnalyticsSendEvent(x:15)
        }
       
        Global.sharedInstance.getEventsFromMyCalendar()
    }
    //set bthere event by month
    func setEventBthereInMonth()
    {
        self.bthereEventDateDayInt = []
        var orderDetailsObj:OrderDetailsObj =  OrderDetailsObj()
        //        var a:Int = Int()
        //        var b:Int = Int()
        //        var c:Int = Int()
        //        var d:Int = Int()
        if Global.sharedInstance.ordersOfClientsArray.count > 0
        {
            for item in Global.sharedInstance.ordersOfClientsArray
            {
                orderDetailsObj = item as  OrderDetailsObj
                print("full dateorder \(orderDetailsObj.dtDateOrder)")
                let COMPOSEDONEDATE:String = String(iYear) + "-" + String(iMonth) + "-" + String(iDay) + " 03:00:00  +0000"
                let dateFormatterx = DateFormatter()
                dateFormatterx.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let dates = dateFormatterx.date(from: COMPOSEDONEDATE)
                print("eeeee\(Calendar.sharedInstance.getMonth(orderDetailsObj.dtDateOrder, reduce: 0, add: 0))")
                if Calendar.sharedInstance.getMonth(orderDetailsObj.dtDateOrder, reduce: 0, add: 0) == Calendar.sharedInstance.getMonth(dates!
                    , reduce: 0, add: 0) &&  Calendar.sharedInstance.getYear(orderDetailsObj.dtDateOrder, reduce: 0, add: 0) == Calendar.sharedInstance.getYear( dates!
                        , reduce: 0, add: 0)
                {

                    bthereEventDateDayInt.append(Calendar.sharedInstance.getDay(orderDetailsObj.dtDateOrder, reduce: 0, add: 0))
                }


            }
        }
        collDays.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    // MARK: Optional methods

    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }

    //MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if (numDaysInMonth > 30 && dayInWeek == 6
            ) || (numDaysInMonth > 29 && dayInWeek == 7){
            return 42
        }
        return 35
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if (numDaysInMonth > 30 && dayInWeek == 6) || (numDaysInMonth > 29 && dayInWeek == 7)//if has 31 in month
        {
            return CGSize(width: view.frame.size.width / 7, height:  view.frame.size.width / 8.5)
        }
        return CGSize(width: view.frame.size.width / 7, height:  view.frame.size.width / 7)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //Aligning right to left on UICollectionView
        //        var scalingTransform : CGAffineTransform!
        //        scalingTransform = CGAffineTransformMakeScale(-1, 1)

        let cell:DayMonthCalendarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayMonthCalendarCollectionViewCell",for: indexPath) as! DayMonthCalendarCollectionViewCell

        //אם זה תחת מודל של יומן תורים מול לקוח
        cell.delegate = Global.sharedInstance.calendarAppointment
        cell.backgroundColor =  UIColor.clear
        cell.lblIsBthereEvent.isHidden = true

        cell.whichModelOpenMe = 2

        cell.imgToday.isHidden = true
        cell.lblDayDesc.alpha = 1.0
        cell.viewIsFree.backgroundColor = UIColor.clear
        //     var s =
        // var d:NSDate()
        cell.lblDayDesc.text = ""
        cell.lblDayDesc.textColor = Colors.sharedInstance.color1

        if moneForBackColor % 7 == 0{
            if Global.sharedInstance.whichReveal == false || self.isfromSPECIALSUPPLIER == true {
                //case is from supplier side
                cell.lblDayDesc.textColor = Colors.sharedInstance.color3

                cell.isShabat = true

            }
            else{
                cell.lblDayDesc.textColor = Colors.sharedInstance.color4
            }
        }
        moneForBackColor += 1
        if indexPath.row >= (dayInWeek - 1)  && indexPath.row < (numDaysInMonth + dayInWeek - 1 ){

            if bthereEventDateDayInt.contains(i)
            {
                cell.lblIsBthereEvent.isHidden = false
            }
            cell.setDisplayData(i)
            i += 1
        }
        else{
            cell.setNull()
            cell.btnEnterToDay.isEnabled = false
            cell.viewIsFree.backgroundColor =  UIColor.clear
        }
        //    if language == "he"
        //        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0
        //        {
        //            cell.transform = scalingTransform
        //        }
        var componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
        componentsCurrent.day = i


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


    }


    //MARK: - functions
    //bool func that  get date and check if has event in this date
    func ifHasEventInDayFunc( _ dt:Date)-> Bool
    {
        for  item in Global.sharedInstance.eventList
        {
            let event = item as! EKEvent

            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: dt)

            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: event.startDate)

            yearToday =  componentsCurrent.year!
            monthToday = componentsCurrent.month!
            dayToday = componentsCurrent.day!

            let yearEvent =  componentsEvent.year
            let monthEvent = componentsEvent.month
            let dayEvent = componentsEvent.day

            if yearEvent == yearToday && monthEvent == monthToday && dayEvent == dayToday
            {
                return true
            }
        }
        return false
    }
    //change the text on lblDate on prev or next click

    func changeLblDate(){

        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            lblCurrentDate.font = UIFont(name: lblCurrentDate.font.fontName, size: 20)
        }
        print("zzzzz Calendar.sharedInstance.carrentDate \(Calendar.sharedInstance.carrentDate)")
        print("ll \(Foundation.Calendar.current.startOfDay(for: Calendar.sharedInstance.carrentDate as Date))")
        var str:String = ""

        var s1 = dateFormatter.string(from: Calendar.sharedInstance.carrentDate as Date).components(separatedBy: "/")
        //var index:Int = 0
        if s1.count > 0 {
            print("s1is \(s1)")
            let characters = s1[1].characters.map { String($0) }
            if characters[0] == String(0){
                let whatmonthisminus:Int = Int(characters[1])! - 1
                print("si luna e \(Int(characters[1])! - 1)")
                str = MyMonthsNames.object(at: whatmonthisminus) as! String
            }
            else{
                let whatmonthisminus:Int = Int(s1[1])! - 1
                print("sau luna e \(Int(s1[1])! - 1)")
                str = MyMonthsNames.object(at: whatmonthisminus) as! String
            }
            //MyMonthsNames
            lblCurrentDate.text = str + " " + s1[2]
            lblCurrentDate.setNeedsLayout()
            lblCurrentDate.setNeedsDisplay()

        }
    }
    //set device event by month
    func setEventsArray()
    {
        arrEventsCurrentDay = []
        for  item in Global.sharedInstance.eventList
        {
            let event = item as! EKEvent
            //jmode fix prev today and next month
            let COMPOSEDONEDATE:String = String(iYear) + "-" + String(iMonth) + "-" + String(iDay) + " 03:00:00  +0000"
            let dateFormatterx = DateFormatter()
            dateFormatterx.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dates = dateFormatterx.date(from: COMPOSEDONEDATE)
            //\\    let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: Calendar.sharedInstance.carrentDate)
            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: dates!)
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: event.startDate)

            yearToday =  componentsCurrent.year!
            monthToday = componentsCurrent.month!
            dayToday = componentsCurrent.day!

            let yearEvent =  componentsEvent.year
            let monthEvent = componentsEvent.month

            if yearEvent == yearToday && monthEvent == monthToday
            {


                arrEventsCurrentDay.append(event)
                hasEvent = true
            }
        }

    }

    // When the view appears, ensure that the Google Calendar API service is authorized
    // and perform API calls


    //reloadTableFreeDaysDelegate

    func reloadTableFreeDays()  {
        i = 1
        collDays.reloadData()
        //   delegate.openMonthFromChooseWorker()
    }


    @objc func showSync()
    {
        if btnSync.isCecked == false
        {
            Global.sharedInstance.getEventsFromMyCalendar()
            btnSync.isCecked = true
            Global.sharedInstance.isSyncWithGoogleCalendarAppointment = true
            i = 1
            collDays.reloadData()
        }

        else
        {
            btnSync.isCecked = false
            Global.sharedInstance.isSyncWithGoogleCalendarAppointment = false
            i = 1
            collDays.reloadData()

        }
    }
    //we scroll the carousel but need to load data first time
    func loadfirsttime() {
        let  index:Int = 0

        var workerid:Int = 0
        if  Global.sharedInstance.giveServicesArray.count > 0 {
            if let _:User = Global.sharedInstance.giveServicesArray[index] {
                let MYD:User = Global.sharedInstance.giveServicesArray[index]

                if let _:Int =  MYD.iUserId
                {
                    workerid =  MYD.iUserId
                    Global.sharedInstance.defaults.set(workerid, forKey: "idSupplierWorker")
                    Global.sharedInstance.defaults.synchronize()
                    if workerid > 0 {
                        Global.sharedInstance.idWorker = workerid
                        Global.sharedInstance.indexRowForIdGiveService = workerid
                    } else {
                        Global.sharedInstance.idWorker = -1
                        Global.sharedInstance.indexRowForIdGiveService = -1
                    }
                }
                //    getFreeDaysForServiceProvider(false,NONEED: true)
                if checknumberofweeks() == true {
                    getonlyorders()
                } else {
                    GetFreeTimesForServiceProviderByDaysOrHoures()
                }

                print("workerid \(workerid) si \(index)")
            }
        }
    }



    func PREETYJSON_J(_ params:Dictionary<String,AnyObject>, pathofweb: String) {
        print("********************************* \(pathofweb) my data ********************\n")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print("\n********************************* END of \(pathofweb)  ********************\n")
    }
    func getFreeDaysForServiceProvider(_ bIsNext:Bool,NONEED:Bool){


        //compuse string date
        var monthneed:String = ""
        var yearneeded:String = ""
        var dayneeded:String = ""
        monthneed = String(iMonth)
        yearneeded = String(iYear)
        let MyBool:Bool = true
        self.ISNONEED = NONEED

        self.bIsNext = bIsNext


        var composedDATE:String = ""
        if bIsNext == false {
            dayneeded = String(iDay)
            let components = (calendar as NSCalendar).components([.year, .month], from: Calendar.sharedInstance.carrentDate as Date)
            let monthneeds = components.month
            let yearneeds = components.year
            monthneed = String(describing: monthneeds)
            yearneeded = String(describing: yearneeds)
            composedDATE = yearneeded + "-" + monthneed + "-\(dayneeded)"
        } else {
            dayneeded = "1"
            composedDATE = yearneeded + "-" + monthneed + "-\(dayneeded)"
        }


        print("composedDATE \(composedDATE)")
        Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
        Global.sharedInstance.arrayGiveServicesKods = []
        Global.sharedInstance.dateFreeDays = []

        if Global.sharedInstance.idWorker == -1//אם בחרו - לא משנה לי
        {
            for  item in Global.sharedInstance.giveServicesArray
            {
                Global.sharedInstance.arrayGiveServicesKods.append(item.iUserId)//אחסון כל הקודים של נותני השרות כי בחר - לא משנה לי
            }
        }
        else
        {

            //מערך שאוחסנו בו השעות של הימים הפנויים
            Global.sharedInstance.arrayGiveServicesKods.append(Global.sharedInstance.idWorker)
        }
        ////////\\\\\\lProviderServiceId
        Global.sharedInstance.dicGetFreeDaysForServiceProvider["bIsNext"] = MyBool as AnyObject
        Global.sharedInstance.dicGetFreeDaysForServiceProvider["lServiseProviderId"] = Global.sharedInstance.arrayGiveServicesKods as AnyObject

        Global.sharedInstance.dicGetFreeDaysForServiceProvider["lProviderServiceId"] = Global.sharedInstance.arrayServicesKodsToServer as AnyObject
        print("one code \(Global.sharedInstance.arrayServicesKodsToServer)")

        self.generic.showNativeActivityIndicator(self)


        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)

//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {

            //new 23-01-17
            Global.sharedInstance.dicGetFreeDaysForServiceProvider["nvDate"] = composedDATE as AnyObject
            print("Global.sharedInstance.dicGetFreeDaysForServiceProvider \(self.PREETYJSON_J(Global.sharedInstance.dicGetFreeDaysForServiceProvider, pathofweb: "cHOSEW"))")
            api.sharedInstance.GetFreeDaysForServiceProvider(Global.sharedInstance.dicGetFreeDaysForServiceProvider, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        print("what is gets \(responseObject)")

                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {

                            self.showAlertDelegateX("NO_FREE_HOURS_FOUND".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {

                            let ps:providerFreeDaysObj = providerFreeDaysObj()

                            Global.sharedInstance.getFreeDaysForService = ps.objFreeDaysToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            //איפוס המערך מנתונים ישנים
                            Global.sharedInstance.dateFreeDays = []
                            print("Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")
                            for i in 0 ..< Global.sharedInstance.getFreeDaysForService.count{
                                //                            if i == 0 {
                                //                            let dateDt = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate)
                                //                                  let provider:providerFreeDaysObj = Global.sharedInstance.getFreeDaysForService[i]
                                //                                let hourStart = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvFromHour)
                                //                                Global.sharedInstance.fromHourArray.append(hourStart)
                                //                                let hourEnd = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvToHour)
                                //                                Global.sharedInstance.endHourArray.append(hourEnd)
                                //
                                //                                Global.sharedInstance.dateFreeDays.append(dateDt)
                                //                            }
                                let dateDt = Calendar.sharedInstance.addDay(Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate))
                                let provider:providerFreeDaysObj = Global.sharedInstance.getFreeDaysForService[i]

                                let hourStart = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvFromHour)
                                Global.sharedInstance.fromHourArray.append(hourStart)
                                let hourEnd = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvToHour)
                                Global.sharedInstance.endHourArray.append(hourEnd)

                                Global.sharedInstance.dateFreeDays.append(dateDt)
                                print("ooo dateDt \(dateDt)")
                            }

                        }
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
                self.GetCustomerOrders()
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
        //}
    }
    func GetCustomerOrders()  {

        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            if isfromSPECIALSUPPLIER == false {
                dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
                self.isfromSPECIALiCustomerUserId = 0
                let USERDEF = Global.sharedInstance.defaults
                USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
                USERDEF.synchronize()
            } else {
                dic["iUserId"] = self.isfromSPECIALiCustomerUserId as AnyObject
                let USERDEF = Global.sharedInstance.defaults
                USERDEF.set(self.isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
                USERDEF.synchronize()
            }
            dic["iFilterByMonth"] = iFilterByMonth as AnyObject
            dic["iFilterByYear"] = iFilterByYear as AnyObject
            self.generic.hideNativeActivityIndicator(self)
            api.sharedInstance.GetCustomerOrdersNoLogo(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if RESPONSEOBJECT["Result"] != nil  || !(RESPONSEOBJECT["Result"] is NSNull)  {
                        if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                        //\\    print("what is getttt \(String(describing: RESPONSEOBJECT["Result"]))")
                            // regular customer
                            if self.isfromSPECIALSUPPLIER == false {
                                let ps:OrderDetailsObj = OrderDetailsObj()
                                Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                print(Global.sharedInstance.ordersOfClientsArray)

                            } else { //special customer id from My customers filter array by my providerid
                                var ARRAYoRDERSFORisfromSPECIALiCustomerUserId:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()
                                var providerID:Int = 0
                                if Global.sharedInstance.providerID == 0 {
                                    providerID = 0
                                    if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                                        providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

                                    }
                                } else {
                                    providerID = Global.sharedInstance.providerID
                                }

                                let ps:OrderDetailsObj = OrderDetailsObj()
                                ARRAYoRDERSFORisfromSPECIALiCustomerUserId = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                print("ARRAYoRDERSFORisfromSPECIALiCustomerUserId.count \(ARRAYoRDERSFORisfromSPECIALiCustomerUserId.count)")
                                Global.sharedInstance.ordersOfClientsArray =  Array<OrderDetailsObj>()
                                for item in ARRAYoRDERSFORisfromSPECIALiCustomerUserId {

                                    if item.iSupplierId == providerID {
                                 //\\       print("item to test \(item.getDic())")
                                        if !Global.sharedInstance.ordersOfClientsArray.contains(item) {
                                            Global.sharedInstance.ordersOfClientsArray.append(item)
                                        }
                                    }
                                }
                                print("Global.sharedInstance.ordersOfClientsArray.count \(Global.sharedInstance.ordersOfClientsArray.count)")
                            }
                        }
                    }
                }
                self.updatefornextbtn(self.bIsNext,ISNONEED:self.ISNONEED )

            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    //GetFreeDaysForServiceProvider is replaced by call to GetFreeTimesForServiceProviderByDaysOrHours
    func GetFreeTimesForServiceProviderByDaysOrHoures() {
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd"
        //compose with 1st day till end
        // Get first day of month
        let calendar = Foundation.Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month], from: Calendar.sharedInstance.carrentDate as Date)
        let startOfMonth = calendar.date(from: components)!
        print(dateFormatterx.string(from: startOfMonth))
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = (calendar as NSCalendar).date(byAdding: comps2, to: startOfMonth, options: [])!
        print(dateFormatterx.string(from: endOfMonth))
        let nvFromDate = dateFormatterx.string(from: startOfMonth)
        let nvToDate = dateFormatterx.string(from: endOfMonth)
        print("startOfMonth \(startOfMonth) endOfMonth \(endOfMonth)")
        Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
        Global.sharedInstance.arrayGiveServicesKods = []
        Global.sharedInstance.dateFreeDays = []

        if Global.sharedInstance.idWorker == -1
        {
            for  item in Global.sharedInstance.giveServicesArray
            {
                Global.sharedInstance.arrayGiveServicesKods.append(item.iUserId)
            }
        }
        else
        {
            Global.sharedInstance.arrayGiveServicesKods.append(Global.sharedInstance.idWorker)
        }

        Global.sharedInstance.dicGetFreeDaysForServiceProvider["bIsNext"] = true as AnyObject
        Global.sharedInstance.dicGetFreeDaysForServiceProvider["lServiseProviderId"] = Global.sharedInstance.arrayGiveServicesKods as AnyObject
        Global.sharedInstance.dicGetFreeDaysForServiceProvider["lProviderServiceId"] = Global.sharedInstance.arrayServicesKodsToServer as AnyObject
        print("one code \(Global.sharedInstance.arrayServicesKodsToServer)")
        self.generic.showNativeActivityIndicator(self)

        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)

//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            //new 14-02-2018
            Global.sharedInstance.dicGetFreeDaysForServiceProvider["nvFromDate"] = nvFromDate as AnyObject
            Global.sharedInstance.dicGetFreeDaysForServiceProvider["nvToDate"] = nvToDate as AnyObject
            Global.sharedInstance.dicGetFreeDaysForServiceProvider["bFreeDaysOnly"] = true as AnyObject //to get all days in month with free days set true
            print("Global.sharedInstance.dicGetFreeDaysForServiceProvider \(self.PREETYJSON_J(Global.sharedInstance.dicGetFreeDaysForServiceProvider, pathofweb: "cHOSEW"))")
            api.sharedInstance.GetFreeTimesForServiceProviderByDaysOrHoures(Global.sharedInstance.dicGetFreeDaysForServiceProvider, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift
                    print(RESPONSEOBJECT)
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            self.generic.hideNativeActivityIndicator(self)
                            self.showAlertDelegateX("NO_FREE_HOURS_FOUND".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            let ps:providerFreeDaysObj = providerFreeDaysObj()
                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                Global.sharedInstance.getFreeDaysForService = ps.objFreeDaysToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            }
                            //איפוס המערך מנתונים ישנים
                            Global.sharedInstance.dateFreeDays = []
                            //clean days older than today dtDate <  NSDate()
                            var getFreeDaysForServiceCLEAN:Array<providerFreeDaysObj> =  Array<providerFreeDaysObj>()
                            for i in 0 ..< Global.sharedInstance.getFreeDaysForService.count{
                                let dateDt = Calendar.sharedInstance.addDay(Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate))
                                if Date() > dateDt   {
                                    //do not add
                                } else {
                                    var weekstoshowandlimit:Int = 0
                                    let USERDEF = UserDefaults.standard
                                    if self.isfromSPECIALSUPPLIER == false {
                                        if Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS == false {
                                            if  USERDEF.object(forKey: "CALENDARWEEKSFORSUPPLIER") == nil {
                                                USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
                                                USERDEF.synchronize()
                                                weekstoshowandlimit = USERDEF.integer(forKey: "CALENDARWEEKSFORSUPPLIER")
                                            }
                                            if USERDEF.object(forKey: "CALENDARWEEKSFORSUPPLIER") != nil {
                                                let myweeks = USERDEF.integer(forKey: "CALENDARWEEKSFORSUPPLIER")
                                                if myweeks == 0 {
                                                    USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
                                                }
                                                USERDEF.synchronize()
                                                weekstoshowandlimit = USERDEF.integer(forKey: "CALENDARWEEKSFORSUPPLIER")
                                            }
                                            else {
                                                USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
                                                USERDEF.synchronize()
                                            }
                                            weekstoshowandlimit = USERDEF.integer(forKey: "CALENDARWEEKSFORSUPPLIER")
                                        } else {
                                            if USERDEF.object(forKey: "WEEKSFORSUPPLIER") != nil {
                                                let myweeks = USERDEF.integer(forKey: "WEEKSFORSUPPLIER")
                                                if myweeks == 0 {
                                                    USERDEF.set(52, forKey: "WEEKSFORSUPPLIER")
                                                }
                                                USERDEF.synchronize()
                                                weekstoshowandlimit = USERDEF.integer(forKey: "WEEKSFORSUPPLIER")
                                            }
                                        }
                                    } else {
                                        weekstoshowandlimit = 52
                                        USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
                                        USERDEF.synchronize()
                                    }
                                    if weekstoshowandlimit == 0 {
                                        weekstoshowandlimit = 52
                                    }
                                    let numberofdaystoadd = 7 * weekstoshowandlimit //+ 1 //to get last date where user can see free days in month based on weeks setup
                                    let cal = self.calendar
                                    let lastvisibleday = (cal as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: numberofdaystoadd, to: Date(), options: NSCalendar.Options.matchLast)
                                    print("lastvisibleday \(lastvisibleday) and diff \(dateDt)")

                                    if dateDt > lastvisibleday {
                                        print("over the top:)")
                                    } else {

                                        let itemx =  Global.sharedInstance.getFreeDaysForService[i]
                                        getFreeDaysForServiceCLEAN.append(itemx)
                                    }
                                }
                                print("ooo dateDt \(dateDt)")
                            }
                            Global.sharedInstance.getFreeDaysForService = getFreeDaysForServiceCLEAN

                            print("Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")
                            Global.sharedInstance.fromHourArray = []
                            Global.sharedInstance.endHourArray = []
                            for i in 0 ..< Global.sharedInstance.getFreeDaysForService.count{
                                let dateDt = Calendar.sharedInstance.addDay(Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate))
                                let provider:providerFreeDaysObj = Global.sharedInstance.getFreeDaysForService[i]

                                let hourStart = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvFromHour)
                                Global.sharedInstance.fromHourArray.append(hourStart)
                                let hourEnd = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvToHour)
                                Global.sharedInstance.endHourArray.append(hourEnd)

                                Global.sharedInstance.dateFreeDays.append(dateDt)
                                print("ooo dateDt \(dateDt)")
                            }

                        }
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
                self.GetCustomerOrders()



            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                print("Error \(Error)")

//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }


    }
    ////////////DEVELOPER ONLY TOOLS ->
    func GENERATEORDERS(){
        myarr = []
        /********************************* newOrder my data ********************

         {
         "orderObj" : {
         "iSupplierId" : 995,
         "nvFromHour" : "16:00",
         "iProviderServiceId" : [
         3377
         ],
         "iSupplierUserId" : [
         17431
         ],
         "iUserId" : 17441,
         "dtDateOrder" : "\/Date(1528329600000)\/",
         "nvToHour" : "",
         "nvComment" : ""
         }
         } */
        for item in Global.sharedInstance.getFreeDaysForService {

            let fromhh = item.objProviderHour.nvFromHour

            let hourStart = Global.sharedInstance.getStringFromDateString(fromhh)
            //(calendar as NSCalendar).components(flags, from: Date(), to: currentDate, options: [])
            let componentsEvent = (calendar as NSCalendar).components([.hour, .minute], from: hourStart)
            let shour:Int = componentsEvent.hour!
            let sminute:Int = componentsEvent.minute!
            var hourS_Show:String = shour.description
            var minuteS_Show:String = sminute.description
            if shour < 10
            {
                hourS_Show = "0\(shour)"
            }
            if sminute < 10
            {
                minuteS_Show = "0\(sminute)"
            }
            let Composedfromhour:String = hourS_Show + ":" + minuteS_Show

            let myarray          = [8407]
            var  secndarray =  myarray
            let myelem = secndarray[0]
            //shuffle and get elem
            let  order:OrderObj = OrderObj(_iSupplierId:2671, _iUserId: 30565, _iSupplierUserId: [30566], _iProviderServiceId: [myelem], _dtDateOrder: Global.sharedInstance.getStringFromDateString(item.dtDate), _nvFromHour:Composedfromhour, _nvComment: "",_nvToHour:"")


            myarr.append(order)
       //     self.sendneworderandkillserver(order)
            // }


        }
        sendorder()
    }
    func sendorder() {
        let x = self.whichindextosend
        if x < myarr.count {
            let myorder = myarr[x]
            sendneworderandkillserver(myorder)
        }
    }
    func sendneworderandkillserver(_ order:OrderObj) {
        whichindextosend = whichindextosend + 1
        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicOrderObj["orderObj"] = order.getDic() as AnyObject

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {


            api.sharedInstance.newOrder(dicOrderObj,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    print("kill ?  \(RESPONSEOBJECT)")
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//אם אין תור פנוי בזמן הזה
                    {
                        print("eroare in kill server")

                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1//הצליח
                    {
                        print("dezastru in kill server")


                    }
                        //in case of 2 no event can be save this is special case so he just recieve push from server
                        //in case of 3 customer was rejected and cannot make appointment
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 3 //
                    {
                        print("eroare in kill server")

                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//שגיאה
                    {
                        print("eroare in kill server")


                    }
                    self.sendorder()
                }
            },failure:
                {
                    (AFHTTPRequestOperation, NSError) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    print("eroare in kill server")
                    self.sendorder()
            })
        }
    }
    func getProviderServicesForSupplierFunctoback() {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject

        api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
            print("response for getProviderServicesForSupplier \(String(describing: responseObject))")
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if (RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3) {
                        Alert.sharedInstance.showAlertDelegate("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    } else if (RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1) {
                        if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                            let ps:objProviderServices = objProviderServices()
                            self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)

                            if (self.ProviderServicesArray.count == 0) {
                                Alert.sharedInstance.showAlertDelegate("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            } else {
                                if self.isfromSPECIALSUPPLIER == false {
                                    let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                                    let frontviewcontroller:UINavigationController? = UINavigationController()
                                    //   Global.sharedInstance.isProvider = false
                                    //     Global.sharedInstance.whichReveal = false
                                    Global.sharedInstance.arrayServicesKodsToServer = []
                                    Global.sharedInstance.arrayServicesKods = []
                                    Global.sharedInstance.viewCon = clientStoryBoard.instantiateViewController(withIdentifier: "ListServicesViewController") as?ListServicesViewController
                                    let  Anarray:Array<objProviderServices> = self.ProviderServicesArray
                                    Global.sharedInstance.viewCon?.ProviderServicesArray   = Anarray
                                    Global.sharedInstance.viewCon?.isfromSPECIALSUPPLIER = false
                                    let USERDEF = Global.sharedInstance.defaults
                                    USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
                                    USERDEF.synchronize()
                                    frontviewcontroller!.pushViewController(Global.sharedInstance.viewCon!, animated: false)
                                    //initialize REAR View Controller- it is the LEFT hand menu.
                                    let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                                    let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                    let mainRevealController = SWRevealViewController()
                                    mainRevealController.frontViewController = frontviewcontroller
                                    mainRevealController.rearViewController = rearViewController
                                    let window :UIWindow = UIApplication.shared.keyWindow!
                                    window.rootViewController = mainRevealController
                                    window.makeKeyAndVisible()
                                } else {
                                    let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                                    let frontviewcontroller:UINavigationController? = UINavigationController()
                                    Global.sharedInstance.isProvider = true
                                    Global.sharedInstance.whichReveal = true
                                    Global.sharedInstance.arrayServicesKodsToServer = []
                                    Global.sharedInstance.arrayServicesKods = []
                                    Global.sharedInstance.viewCon = clientStoryBoard.instantiateViewController(withIdentifier: "SupplierListServicesViewController") as?ListServicesViewController
                                    let USERDEF = Global.sharedInstance.defaults
                                    USERDEF.set(3,forKey: "backFromMyListServices")
                                    USERDEF.synchronize()
                                    let  Anarray:Array<objProviderServices> = self.ProviderServicesArray
                                    Global.sharedInstance.viewCon?.ProviderServicesArray   = Anarray
                                    Global.sharedInstance.viewCon?.isfromSPECIALSUPPLIER = true
                                    Global.sharedInstance.viewCon?.isfromSPECIALiCustomerUserId = self.isfromSPECIALiCustomerUserId
                                    print("zzzisfromSPECIALiCustomerUserId  \(self.isfromSPECIALiCustomerUserId)")
                                    USERDEF.set(self.isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
                                    USERDEF.synchronize()
                                    frontviewcontroller!.pushViewController(Global.sharedInstance.viewCon!, animated: false)
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
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in

        })
    }
}

//remove duplicate values from array
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


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
