
//
//  WeekDesignSupplierViewController.swift
//  Bthere
//
//  Created by User on 1.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//
import UIKit
import EventKit
import EventKitUI
import MessageUI
//ספק - תצוגת שבוע
class WeekDesignSupplierViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIGestureRecognizerDelegate,iCarouselDataSource, iCarouselDelegate, MFMailComposeViewControllerDelegate {
    //NEW DEVELOP
    var BlockHouresObjArray:Array<BlockHouresObj> =  Array<BlockHouresObj>()
    var intSuppliersecondID:Int = 0
    //END NEW
    //JMODE PLUS
    var MyWeekDayNames:NSArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var MyHebrewWeekDayNames:NSArray = ["יוֹם רִאשׁוֹן" ,"יוֹם שֵׁנִי‎","יוֹם שְׁלִישִׁי‎","יוֹם רְבִיעִי","יוֹם חֲמִישִׁי" ,"יוֹם שִׁישִּׁי" ,"יוֹם שַׁבָּת"]
    //    CalendarMatrix Int hour
    //    Array<Int>
    var column1:Array<Int> = []
    var column2:Array<Int> = []
    var column3:Array<Int> = []
    var column4:Array<Int> = []
    var column5:Array<Int> = []
    var column6:Array<Int> = []
    var column7:Array<Int> = []
    var NOLOAD:Bool = false
    var EMPLOYEISMANAGER:Bool = false
    var FROMPRINT:Bool = false
    var refreshControl: UIRefreshControl!
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    @IBOutlet var arrowleft: UIImageView!
    @IBOutlet var arrowright: UIImageView!
    var CalendarMatrix:[(Int,Int,Array<allKindEventsForListDesign>)] = [] //the start h , the day, the events
    var dtDateStart:Date = Date()
    var dtDateEnd:Date = Date()
    let dateFormatter = DateFormatter()
    var PERFECTSENSE:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
    var HOLLYDAYSSECTIONSFINAL:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
    var ALLSECTIONSFINAL:[(Int,Array<allKindEventsForListDesign>)] = [] //grouped array
    var ALLSECTIONSFINALFILTERED:[(Int,Array<allKindEventsForListDesign>)] = []
    var PLAYIT:weekdayevents = weekdayevents() //day, index, hour, array Int,Int,Int,Array<allKindEventsForListDesign>
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var iFilterByMonthEnd:Int = 0
    var iFilterByYearEnd:Int = 0
    var myArray : NSMutableArray = NSMutableArray()
    var myCustomersArray : NSMutableArray = []
    var arrayWorkers:  NSMutableArray = []
    var selectedWorker:Bool = false
    var selectedWorkerID:Int = 0
    var generic:Generic = Generic()
    // var idWorker:Int = -1
    var bthereEventDateDayInt:NSMutableArray = NSMutableArray()
    @IBOutlet var carousel: iCarousel!
    var yearEvent =  0
    var monthEvent = 0
    var dayEvent = 0
    //END PLUS
    var delegate:clickToDayInWeekDelegate!
    //MARK: - Outlet
    @IBOutlet var btnDay1: UIButton!
    @IBOutlet var btnDay2: UIButton!
    @IBOutlet var btnDay3: UIButton!
    @IBOutlet var btnDay4: UIButton!
    @IBOutlet var btnDay5: UIButton!
    @IBOutlet var btnDay6: UIButton!
    @IBOutlet var btnDay7: UIButton!
    var  arrayDays: NSMutableArray = NSMutableArray()
    var  arrayButtons: Array<UIButton> = Array<UIButton>()
    var  arrayLabelsDayNum: Array<UILabel> = Array<UILabel>()
    var  arrayLabelsdate: Array<UILabel> = Array<UILabel>()
    var monthArray:Array<Int> = Array<Int>()
    var datesInWeekArray:Array<Date> = Array<Date>()//array of nsdate in week
    var dicArrayEventsToShow:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var sortDicEvents:[(String,Array<allKindEventsForListDesign>)] = []

    var dicBthereEvent:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var sortDicBTHEREevent:[(String,Array<allKindEventsForListDesign>)] = []
    var sortDicBTHEREeventFiltered:[(String,Array<allKindEventsForListDesign>)] = []
    var isSyncCalendar: String = "1"


    @IBOutlet weak var ingTrailing: NSLayoutConstraint!

    @IBOutlet weak var imgCurrentDay: UIImageView!

    @IBOutlet weak var lblDay1: UILabel!

    @IBOutlet weak var lblDay2: UILabel!

    @IBOutlet weak var lblDay3: UILabel!

    @IBOutlet weak var lblDay4: UILabel!

    @IBOutlet weak var lblDay5: UILabel!

    @IBOutlet weak var lblDay6: UILabel!

    @IBOutlet weak var lblDay7: UILabel!


    @IBOutlet weak var lblDayOfWeek1: UILabel!

    @IBOutlet weak var lblDayOfWeek2: UILabel!

    @IBOutlet weak var lblDayOfWeek3: UILabel!

    @IBOutlet weak var lblDayOfWeek4: UILabel!

    @IBOutlet weak var lblDayOfWeek5: UILabel!

    @IBOutlet weak var lblDayOfWeek6: UILabel!

    @IBOutlet weak var lblDayOfWeek7: UILabel!


    @IBOutlet weak var lblDays: UILabel!

    // @IBOutlet weak var lblDate: UILabel!
    //MARK: - IBAction

    //enter to date in week
    @IBAction func btnEnterDateClick(_ sender: AnyObject) {

        let tag:Int = (sender as! UIButton).tag

        var componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)

        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        let td:Int =  arrayDays[tag] as! Int

        componentsCurrent.day = td
        let dateSelected = calendar.date(from: componentsCurrent)

        Global.sharedInstance.currDateSelected = dateSelected!
        Global.sharedInstance.dateDayClick = dateSelected!



        delegate.clickToDayInWeek()

    }

    //  aaa   //כפתור הקודם (לא הבא)
    @IBAction func btnPrevious(_ sender: AnyObject) {

        //בלחיצה על הקודם מוצגים הימים בשבוע הקודם

        hasEvent = false
        let day:Int = Calendar.sharedInstance.getDayOfWeek(currentDate)! - 1

        let otherDate:Date = currentDate

        //show month for each day in week
        lblDay1.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -1).description
        lblDay2.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -2).description
        lblDay3.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -3).description
        lblDay4.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -4).description
        lblDay5.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -5).description
        lblDay6.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -6).description
        lblDay7.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -7).description

        currentDate =  Calendar.sharedInstance.reduceAddDay_Date(otherDate, reduce: day, add: -7)
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        monthToday = componentsCurrent.month!

        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -1))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -2))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -3))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -4))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -5))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -6))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -7))
        print("monthArray \(monthArray)")
        // - long
        //NSDateFormatter().monthSymbols[monthToday - 1]

        //let dayName = NSDateFormatter().weekdaySymbols[day]

        //  lblDate.text = "\(monthName) \(yearToday)"

        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!

        //אתחול המערך של תאריכי השבוע
        datesInWeekArray = []
        for i in 0..<7
        {
            datesInWeekArray.append(
                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
        }

        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!

        var datesInWeekArraysorted = datesInWeekArray.sorted()
        dtDateStart = datesInWeekArraysorted[0]
        dtDateEnd = datesInWeekArraysorted[6]
        print("btn next datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
        var  isFindToday:Bool = false


        //בדיקה האם היום הנוכחי מוצג כעת
        for item in datesInWeekArray
        {

            let otherDay: DateComponents = (Foundation.Calendar.current as NSCalendar).components([.era, .year, .month, .day], from: item)

            let today: DateComponents = (Foundation.Calendar.current as NSCalendar).components([.era, .year, .month, .day], from: Date())
            if today.day == otherDay.day && today.month == otherDay.month && today.year == otherDay.year
            {
                isFindToday = true
            }

        }
        if isFindToday
        {

            imgCurrentDay.isHidden = false
            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(Date())!
            UIView.animate(withDuration: 1, animations: {
                self.ingTrailing.constant = /* self.ingTrailing.constant +*/ ((self.view.frame.width / 8) *
                    CGFloat(self.dayOfWeekToday))
            })
        }
        else
        {
            imgCurrentDay.isHidden = true
        }

        let componentsEventx = (calendar as NSCalendar).components([.day, .month, .year], from: dtDateStart)
        let componentsEndEventx = (calendar as NSCalendar).components([.day, .month, .year], from: dtDateEnd)
        var monthName:String = ""
        var endmonthName:String = ""
        var yearStart:String = ""
        var yearEnd:String = ""


        let yearEvent:Int = componentsEventx.year!


        let dateFormatter = DateFormatter()
        let dateFormatterYEAR = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatterYEAR.dateFormat = "yyyy"
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatter.locale = Locale(identifier: "he_IL")
        } else {
            dateFormatter.locale = Locale(identifier: "en_US")
        }

        monthName = dateFormatter.string(from: dtDateStart)
        endmonthName = dateFormatter.string(from: dtDateEnd)

        let yearEndEvent:Int = componentsEndEventx.year!


        yearStart = String(yearEvent)
        yearEnd = String(yearEndEvent)

        if yearStart != yearEnd {
            lblDays.text = "\(lblDay7.text!).\(monthName).\(yearStart) - \(lblDay1.text!) .\(endmonthName).\(yearEnd)"
        } else{
            if monthName != endmonthName {
                lblDays.text = "\(lblDay7.text!).\(monthName) - \(lblDay1.text!) .\(endmonthName).\(yearStart)"
            }
            else {
                lblDays.text = "\(lblDay7.text!) - \(lblDay1.text!) .\(monthName).\(yearStart)"
            }
        }

        //   lblDate.text = "\(monthName) \(yearToday)"
        //     get the month and day of week names - short

        if monthToday == 0
        {
            monthName = DateFormatter().shortStandaloneMonthSymbols[monthToday]
        }
        else
        {
            monthName = DateFormatter().shortStandaloneMonthSymbols[monthToday - 1]
        }

        CalendarMatrix = []
        for inthour in arrHoursInt {
            for intday in arrayDays {
                let ax:Int = intday as! Int
                let fullreservedids:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                CalendarMatrix.append((inthour,ax,fullreservedids))
            }
        }
        print("CalendarMatrix \(CalendarMatrix) and count \(CalendarMatrix.count)")
        //refresh event array
        //  setEventsArray(currentDate)
        arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]

        // GetCustomersOrdersByDateForSupplier()
        if self.EMPLOYEISMANAGER == true {
            GetCustomersOrdersByDateForSupplier()
        } else {
            //is employe non manager
            GetCustomersOrdersByDateForEmployeeId()
        }

        //   setDateEnablity()


    }

    @IBOutlet weak var btnNext: UIButton!

    @IBOutlet weak var btnPrevious: UIButton!

    //כפתור הבא (לא הקודם)
    @IBAction func btnNext(_ sender: AnyObject) {
        //בלחיצה על הבא מוצגים הימים בשבוע הבא

        hasEvent = false
        let day:Int = Calendar.sharedInstance.getDayOfWeek(currentDate)! - 1

        let otherDate:Date = currentDate

        //show month for each day in week
        lblDay1.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 13).description
        lblDay2.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 12).description
        lblDay3.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 11).description
        lblDay4.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 10).description
        lblDay5.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 9).description
        lblDay6.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 8).description
        lblDay7.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 7).description

        currentDate =  Calendar.sharedInstance.reduceAddDay_Date(otherDate, reduce: day, add: 13)

        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)

        monthToday = componentsCurrent.month!


        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 13))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 12))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 11))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 10))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 9))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 8))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 7))
        print("monthArray \(monthArray)")
        let componentsEventx = (calendar as NSCalendar).components([.day, .month, .year], from: dtDateStart)
        let componentsEndEventx = (calendar as NSCalendar).components([.day, .month, .year], from: dtDateEnd)
        var monthName:String = ""
        var endmonthName:String = ""
        var yearStart:String = ""
        var yearEnd:String = ""


        let yearEvent:Int = componentsEventx.year!


        let dateFormatter = DateFormatter()
        let dateFormatterYEAR = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatterYEAR.dateFormat = "yyyy"
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatter.locale = Locale(identifier: "he_IL")
        } else {
            dateFormatter.locale = Locale(identifier: "en_US")
        }

        monthName = dateFormatter.string(from: dtDateStart)
        endmonthName = dateFormatter.string(from: dtDateEnd)

        let yearEndEvent:Int = componentsEndEventx.year!


        yearStart = String(yearEvent)
        yearEnd = String(yearEndEvent)

        if yearStart != yearEnd {
            lblDays.text = "\(lblDay7.text!).\(monthName).\(yearStart) - \(lblDay1.text!) .\(endmonthName).\(yearEnd)"
        } else{
            if monthName != endmonthName {
                lblDays.text = "\(lblDay7.text!).\(monthName) - \(lblDay1.text!) .\(endmonthName).\(yearStart)"
            }
            else {
                lblDays.text = "\(lblDay7.text!) - \(lblDay1.text!) .\(monthName).\(yearStart)"
            }
        }

        // - long
        //NSDateFormatter().monthSymbols[monthToday - 1]

        //let dayName = NSDateFormatter().weekdaySymbols[day]

        //    lblDate.text = "\(monthName) \(yearToday)"

        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!

        //אתחול המערך של תאריכי השבוע
        datesInWeekArray = []
        for i in 0..<7
        {
            datesInWeekArray.append(
                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
        }
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        dtDateStart = datesInWeekArraysorted[0]
        dtDateEnd = datesInWeekArraysorted[6]
        print("btn prev datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!

        var  isFindToday:Bool = false

        //בדיקה האם היום הנוכחי מוצג כעת
        for item in datesInWeekArray
        {
            let otherDay: DateComponents = (Foundation.Calendar.current as NSCalendar).components([.era, .year, .month, .day], from: item)

            let today: DateComponents = (Foundation.Calendar.current as NSCalendar).components([.era, .year, .month, .day], from: Date())
            if today.day == otherDay.day && today.month == otherDay.month && today.year == otherDay.year
            {
                isFindToday = true
            }
        }

        if isFindToday
        {
            imgCurrentDay.isHidden = false
            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(Date())!
            UIView.animate(withDuration: 1, animations: {
                self.ingTrailing.constant = /* self.ingTrailing.constant +*/ ((self.view.frame.width / 8) *
                    CGFloat(self.dayOfWeekToday))
            })
        }
        else
        {
            imgCurrentDay.isHidden = true
        }
        print("btn back datesInWeekArray \(datesInWeekArray)")
        //  setEventsArray(currentDate)
        arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]

        //  setDateEnablity()
        //      GetCustomersOrdersByDateForSupplier()
        if self.EMPLOYEISMANAGER == true {
            GetCustomersOrdersByDateForSupplier()
        } else {
            //is employe non manager
            GetCustomersOrdersByDateForEmployeeId()
        }


    }


    @IBOutlet weak var collWeek: UICollectionView!

    //MARK: - Properties

    let language = Bundle.main.preferredLocalizations.first! as NSString
    var arrHoursInt:Array<Int> = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    var arrHours:Array<String> = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]

    var arrEventsCurrentDay:Array<allKindEventsForListDesign> = []
    var arrBThereEventsCurrentDay:Array<OrderDetailsObj> = []
    var flag = false
    var hasEvent = false
    var currentDate:Date = Date()
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    var dayOfWeekToday = 0


    @IBOutlet weak var viewSync: UIView!

    @IBOutlet weak var btnSyncWithGoogelSupplier: eyeSynCheckBox!
    //    @IBOutlet weak var btnSync: eyeSynCheckBox!
    //MARK: - Initial
    //func that get date to init the design by date
    func initDateOfWeek(_ date:Date)
    {
        datesInWeekArray = []
        currentDate = date
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!

        for i in 0..<7
        {
            datesInWeekArray.append(
                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
        }
        //\\    print("datesInWeekArray \(datesInWeekArray)")
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        dtDateStart = datesInWeekArraysorted[0]
        dtDateEnd = datesInWeekArraysorted[6]
        print("initinit datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
        if FROMPRINT == true {
            bestmode()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


    }
    var viewhelp : helpPpopup!
    func LOADHELPERS() {
        if self.isViewLoaded && (self.view.window != nil) {
            // viewController is visible

            var HELPSCREENKEYFORNSUSERDEFAULTS = ""
            let USERDEF = UserDefaults.standard
            var imagesarray:NSArray = NSArray()
            //     returnCURRENTHELPSCREENS() -> (HLPKEY:String, imgs:NSArray)
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            imagesarray = appDelegate.returnCURRENTHELPSCREENS()
            //  HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.HELPSCREENKEY
            HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.returnCURRENTKEY()
            if  imagesarray.count > 0 {
                let fullimgarr:NSMutableArray = imagesarray.mutableCopy() as! NSMutableArray
                print("aaa \(fullimgarr.description)")
                if let mydict:NSMutableDictionary = fullimgarr[10] as? NSMutableDictionary {
                    if mydict["seen"] as! Int == 1 { //was not seen
                        let changedictionary: NSMutableDictionary = NSMutableDictionary()
                        changedictionary["needimage"] = mydict["needimage"]
                        changedictionary["seen"] = 0 //seen
                        print("changedic \(changedictionary)")
                        fullimgarr[10] = changedictionary
                        print("fullimgarr \(fullimgarr.description)")
                        USERDEF.set(fullimgarr, forKey: HELPSCREENKEYFORNSUSERDEFAULTS)
                        USERDEF.synchronize()
                        print("USERDEF key arr \(String(describing: USERDEF.object(forKey: HELPSCREENKEYFORNSUSERDEFAULTS)))")
                        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                        viewhelp = storyboardtest.instantiateViewController(withIdentifier: "helpPpopup") as! helpPpopup
                        if self.iOS8 {
                            viewhelp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        } else {
                            viewhelp.modalPresentationStyle = UIModalPresentationStyle.currentContext
                        }
                        viewhelp.indexOfImg = 10
                        viewhelp.HELPSCREENKEYFORNSUSERDEFAULTS = HELPSCREENKEYFORNSUSERDEFAULTS
                        self.present(viewhelp, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:61)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        if let _:Int = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as? Int {
            let y = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as! Int
            if y == 0 {
                viewSync.isHidden = true
                btnSyncWithGoogelSupplier.isHidden = true
            } else if y == 1 {
                viewSync.isHidden = false
                btnSyncWithGoogelSupplier.isHidden = false
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true{
                    btnSyncWithGoogelSupplier.isCecked = true
                } else {
                    btnSyncWithGoogelSupplier.isCecked = false
                }
            }
        }
        //        if Global.sharedInstance.defaults.integerForKey("ismanager") == 0 {
        //            self.EMPLOYEISMANAGER = false
        //        } else {
        //            self.EMPLOYEISMANAGER = true
        //        }

        collWeek.backgroundColor = UIColor.clear

        initDateOfWeek(Calendar.sharedInstance.carrentDate as Date)
        if NOLOAD == false  {
            self.bestmode()
        }

        // Check if calendar is sync

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //   if Global.sharedInstance.rtl
        //            if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0
        //        {
        //            arrowleft.image =    UIImage(named: "sageata1.png")
        //            arrowright.image =    UIImage(named: "sageata2.png")
        //        }
        //        else
        //        {
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
        collWeek.backgroundView?.backgroundColor = .clear

    }

    func setDateEnablity()
    {
        for i in 0  ..< datesInWeekArray.count
        {
            if self.small(datesInWeekArray[i], rhs: Date())
            {
                (arrayButtons[6-i] as UIButton).isEnabled = false
                (arrayLabelsDayNum[6-i] as UILabel).textColor = Colors.sharedInstance.color7
                (arrayLabelsdate[6-i] as UILabel).textColor =  Colors.sharedInstance.color7
            }
                // - כדי שירענן את הכפתורים ולא ישאיר לפי הקודם
            else
            {
                (arrayButtons[6-i] as UIButton).isEnabled = true
                (arrayLabelsDayNum[6-i] as UILabel).textColor =  UIColor.white
                (arrayLabelsdate[6-i] as UILabel).textColor =  UIColor.white
            }
        }
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        dtDateStart = datesInWeekArraysorted[0]
        dtDateEnd = datesInWeekArraysorted[6]
        print("setdenab datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
        let componentsEventx = (calendar as NSCalendar).components([.day, .month, .year], from: dtDateStart)
        let componentsEndEventx = (calendar as NSCalendar).components([.day, .month, .year], from: dtDateEnd)
        var monthName:String = ""
        var endmonthName:String = ""
        var yearStart:String = ""
        var yearEnd:String = ""


        let yearEvent:Int = componentsEventx.year!


        let dateFormatter = DateFormatter()
        let dateFormatterYEAR = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatterYEAR.dateFormat = "yyyy"
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatter.locale = Locale(identifier: "he_IL")
        } else {
            dateFormatter.locale = Locale(identifier: "en_US")
        }

        monthName = dateFormatter.string(from: dtDateStart)
        endmonthName = dateFormatter.string(from: dtDateEnd)

        let yearEndEvent:Int = componentsEndEventx.year!


        yearStart = String(yearEvent)
        yearEnd = String(yearEndEvent)

        if yearStart != yearEnd {
            lblDays.text = "\(lblDay7.text!).\(monthName).\(yearStart) - \(lblDay1.text!) .\(endmonthName).\(yearEnd)"
        } else{
            if monthName != endmonthName {
                lblDays.text = "\(lblDay7.text!).\(monthName) - \(lblDay1.text!) .\(endmonthName).\(yearStart)"
            }
            else {
                lblDays.text = "\(lblDay7.text!) - \(lblDay1.text!) .\(monthName).\(yearStart)"
            }
        }


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func btnSyncWithGoogel(_ sender: eyeSynCheckBox) {
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            if (sender.isCecked == false) {
                Global.sharedInstance.getEventsFromMyCalendar()
                Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collWeek.reloadData()
                })
            } else {
                Global.sharedInstance.isSyncWithGoogelCalendarSupplier = false
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collWeek.reloadData()
                })
            }
        }
    }


    //MARK: - collectionView
    @objc func tapedinsidecell(_ sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        print("sender tag \(tag)")
        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
        myeventstoShow = self.CalendarMatrix[tag].2
        if myeventstoShow.count > 0 {
            var newarraywithuniquevals:Array<allKindEventsForListDesign> = []
            for item in myeventstoShow {
                if !newarraywithuniquevals.contains(item) {
                    newarraywithuniquevals.append(item)
                }
            }
            //\\print ("myeventstoShow.count \(newarraywithuniquevals.count)")
            if myeventstoShow.count > 0 {
                //\\print ("//////////////// found events ////////////// \n")
                for _ in myeventstoShow {
                    //\\print ("         \(event.getDic())          \n")
                }
                //\\print ("//////////////// end events ////////////// \n")
            }
            let USERDEF = UserDefaults.standard
            USERDEF.set(1 , forKey: "iFirstCalendarViewType") //week view
            USERDEF.synchronize()
            //   BthereEventListViewcontroller
            let viewCon = self.storyboard!.instantiateViewController(withIdentifier: "BthereEventListViewcontroller") as! BthereEventListViewcontroller
            viewCon.myArray = []
            viewCon.myArray = newarraywithuniquevals
            for item in newarraywithuniquevals {
                print("ce transmite \(item.getDic())")
            }

            if self.iOS8 {
                viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            } else {
                viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
            }
            viewCon.myCustomersArray = self.myCustomersArray
            self.present(viewCon, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {


    }

    //    func returnMINUSROW(myIndexPath:Int) -> Int {
    //        var i:Int = 0
    //        var ay:Int = 0
    //        let myarrofInts:NSArray = [9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,129,137,145,153,161,169,177,185,193] //24 begining cells
    //        let myarrofMinus:NSArray = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25] //what to substract 24 ints
    //        if myarrofInts.containsObject(i) {
    //
    //            let ax:Int = myarrofInts.indexOfObject(i)
    //            ay = myarrofMinus.objectAtIndex(ax) as! Int
    //        }
    //        return i
    //    }
    //this is function with long logic , please follow gently and carefully !
    //    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    //    {
    //        if !( indexPath.row == 0 || indexPath.row % 8 == 0)
    //        {
    //
    //         let cell:EventsWeekViewsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventsWeekViews",forIndexPath: indexPath) as! EventsWeekViewsCollectionViewCell
    //        cell.backgroundColor = UIColor.redColor()
    //        }
    //    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        // cell of content in hours where is event show
        //
        // let cell:EventsWeekViewsCollectionViewCell = collectionView.cell as! EventsWeekViewsCollectionViewCell
        // reset flags which view to show


        //
        //        cell.viewTopInTop.hidden = true
        //        cell.viewMiddleInTop.hidden = true
        //        cell.viewButtomInTop.hidden = true
        //        cell.viewButtominButtom.hidden = true
        //        cell.viewMiddleInButtom.hidden = true
        //        cell.viewTopInButtom.hidden = true
        let cell:EventsWeekViewsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsWeekViews",for: indexPath) as! EventsWeekViewsCollectionViewCell

        //  let cell = UINib(nibName: "EventsWeekViewsCollectionViewCell", bundle: self.nibBundle).instantiateWithOwner(nil, options: nil)[0] as! EventsWeekViewsCollectionViewCell
        //        cell.txtViewDescBottom.text = ""
        //        cell.viewBottom.backgroundColor = UIColor.clearColor()
        //        cell.viewTop.backgroundColor = UIColor.clearColor()
        // cell of hour in side of cell
        let cell1:HoursCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hours",for: indexPath) as! HoursCollectionViewCell
        //        var scalingTransform : CGAffineTransform!
        //
        //        scalingTransform = CGAffineTransformMakeScale(-1, 1)
        //
        ////        if Global.sharedInstance.rtl
        //        {
        //            cell.transform = scalingTransform
        //            cell1.transform = scalingTransform
        //        }


        column1 = generateMatrix(0)
        column2 = generateMatrix(1)
        column3 = generateMatrix(2)
        column4 = generateMatrix(3)
        column5 = generateMatrix(4)
        column6 = generateMatrix(5)
        column7 = generateMatrix(6)



        if indexPath.row == 0 || indexPath.row % 8 == 0
        {
            // set hours contex
            cell1.setDisplayData(arrHours[indexPath.row / 8])
            return cell1
        }
        else

        {


            cell.BthereImg.isHidden = true
            cell.eyeImg.isHidden = true
            cell.lineviewTop.isHidden = true
            cell.lineviewBottom.isHidden = true
            cell.lineviewLeft.isHidden = true
            cell.lineviewRight.isHidden = true

            if CalendarMatrix.count > 0 {
                //    print("xCalendar \(CalendarMatrix[indexPath.row])")
                var AI:Int = 0
                AI = (indexPath.row - 1)

                if indexPath.row % 9 == 0 ||  indexPath.row > 9  {
                    AI = (indexPath.row - 2)
                }

                if indexPath.row % 17 == 0  || indexPath.row > 17{
                    AI = (indexPath.row - 3)
                }

                if indexPath.row % 25 == 0 || indexPath.row > 25 {
                    AI = (indexPath.row - 4)
                }

                if indexPath.row % 33 == 0 || indexPath.row > 33 {
                    AI = (indexPath.row - 5)
                }

                if indexPath.row % 41 == 0  || indexPath.row > 41 {
                    AI = (indexPath.row - 6)
                }

                if indexPath.row % 49 == 0 || indexPath.row > 49 {
                    AI = (indexPath.row - 7)
                }

                if indexPath.row % 57 == 0 || indexPath.row > 57 {
                    AI = (indexPath.row - 8)
                }

                if indexPath.row % 65 == 0 || indexPath.row > 65  {
                    AI = (indexPath.row - 9)
                }

                if indexPath.row % 73 == 0 || indexPath.row > 73 {
                    AI = (indexPath.row - 10)
                }

                if indexPath.row % 81 == 0 || indexPath.row > 81 {
                    AI = (indexPath.row - 11)
                }

                if indexPath.row % 89 == 0 || indexPath.row > 89 {
                    AI = (indexPath.row - 12)
                }

                if indexPath.row % 97 == 0  || indexPath.row > 97 {
                    AI = (indexPath.row - 13)
                }

                if indexPath.row % 105 == 0 || indexPath.row > 105  {
                    AI = (indexPath.row - 14)
                }

                if indexPath.row % 113 == 0 || indexPath.row > 113 {
                    AI = (indexPath.row - 15)
                }

                if indexPath.row % 121 == 0 || indexPath.row > 121 {
                    AI = (indexPath.row - 16)
                }

                if indexPath.row % 129 == 0  || indexPath.row > 129{
                    AI = (indexPath.row - 17)
                }

                if indexPath.row % 137 == 0 || indexPath.row > 137 {
                    AI = (indexPath.row - 18)
                }

                if indexPath.row % 145 == 0 || indexPath.row > 145  {
                    AI = (indexPath.row - 19)
                }

                if indexPath.row % 153 == 0 || indexPath.row > 153{
                    AI = (indexPath.row - 20)
                }

                if indexPath.row % 161 == 0 || indexPath.row > 161 {
                    AI = (indexPath.row - 21)
                }

                if indexPath.row % 169 == 0 || indexPath.row > 169  {
                    AI = (indexPath.row - 22)
                }

                if indexPath.row % 177 == 0 || indexPath.row > 177 {
                    AI = (indexPath.row - 23)
                }

                if indexPath.row % 185 == 0 || indexPath.row > 185 {
                    AI = (indexPath.row - 24)
                }


                if indexPath.row % 193 == 0 ||  indexPath.row > 193  {
                    AI = (indexPath.row - 25)
                }

                // cell.txtviewDesc.text = String(AI)
                //               if  indexPath.row <= 191 {
                //
                //                    for item in CalendarMatrix[AI].2 {
                //                        if item.iCoordinatedServiceId > 0 {
                //                            cell.hasEventBthere = true
                //                            cell.BthereImg.hidden = false
                //                            break
                //                        }
                //                    }
                //                    for item in CalendarMatrix[AI].2 {
                //                        if item.iCoordinatedServiceId == 0 {
                //                            cell.hasEvent = true
                //                            cell.eyeImg.hidden = false
                //                            break
                //                        }
                //                }
                //                }
                //        for i = 1 to 168
                //        If CalendarMatrix[i-1].Object = Empty and CalendarMatrix[i].Object = NotEmpty then
                //        Draw (Min(CalendarMatrix[i].Object.StartHour))
                //         else
                //        If CalendarMatrix[i+1].Object = Empty and CalendarMatrix[i].Object = NotEmpty then
                //        Draw (Max(CalendarMatrix[i].EndHour))
                //       else
                //         Draw()
                //simple pregenerated arrays to draw the columns


                //[0, 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 112, 119, 126, 133, 140, 147, 154, 161]
                //   let myxedarray = [column1 , column2 , column3 , column4 , column5 , column6 , column7].flatten()







                //                    cell.lineviewTop.hidden = false
                //                    cell.lineviewBottom.hidden = false
                //                    cell.lineviewLeft.hidden = false
                //                    cell.lineviewRight.hidden = false
                //   }

                ///    print("INTindexPath.row \(indexPath.row) SI AI \(AI) si CalendarMatrix \(CalendarMatrix[AI])")
                let tapInsideCEll = UITapGestureRecognizer(target:self, action:#selector(self.tapedinsidecell(_:)))
                cell.tag = AI
                var MYFullAIMATRIX:Array<Int> = []
                for i:Int in column1 {
                    if !MYFullAIMATRIX.contains(i) {
                        MYFullAIMATRIX.append(i)
                    }
                }
                for i:Int in column2 {
                    if !MYFullAIMATRIX.contains(i) {
                        MYFullAIMATRIX.append(i)
                    }
                }
                for i:Int in column3 {
                    if !MYFullAIMATRIX.contains(i) {
                        MYFullAIMATRIX.append(i)
                    }
                }
                for i:Int in column4 {
                    if !MYFullAIMATRIX.contains(i) {
                        MYFullAIMATRIX.append(i)
                    }
                }
                for i:Int in column5 {
                    if !MYFullAIMATRIX.contains(i) {
                        MYFullAIMATRIX.append(i)
                    }
                }
                for i:Int in column6 {
                    if !MYFullAIMATRIX.contains(i) {
                        MYFullAIMATRIX.append(i)
                    }
                }
                cell.FIRSTLINE.isHidden = false
                cell.SECONDLINE.isHidden = false
                cell.THIRSLINE.isHidden = false
                cell.FOURTHLINE.isHidden = false
                cell.FIRSTLINE.backgroundColor = UIColor.clear
                cell.SECONDLINE.backgroundColor = UIColor.clear
                cell.THIRSLINE.backgroundColor = UIColor.clear
                cell.FOURTHLINE.backgroundColor = UIColor.clear


                if CalendarMatrix.count > 0 {
                    //        //old code do not delete!!! maybe one day you will return to it just make for all column1 to column7
                    //        for i:Int in column1  {
                    //            //case 1 previous cell has event
                    //            //first cell 0
                    //            let mainid:Int = column1.indexOf(i)!
                    //            if mainid == 0 && i <= 160 && cell.tag == i{
                    //                //cell.layer.addBorder(UIRectEdge.Top, color: UIColor.darkGrayColor(), thickness: 0.5)
                    //
                    //                if CalendarMatrix[i].2.count > 0 {
                    //                    cell.lineviewTop.hidden = false
                    //                    cell.lineviewLeft.hidden = false
                    //                    cell.lineviewRight.hidden = false
                    //                    hastop = true
                    //                    hasleft = true
                    //                    hasright = true
                    //                    for item in CalendarMatrix[i].2 {
                    //                        if item.iCoordinatedServiceId > 0 {
                    //                            cell.hasEventBthere = true
                    //                            cell.BthereImg.hidden = false
                    //                            break
                    //                        }
                    //                    }
                    //                    for item in CalendarMatrix[i].2 {
                    //                        if item.iCoordinatedServiceId == 0 {
                    //                            cell.hasEvent = true
                    //                            cell.eyeImg.hidden = false
                    //                            break
                    //                        }
                    //                    }
                    //
                    //                    if CalendarMatrix[i + 7].2.count > 0{
                    //                        cell.lineviewBottom.hidden = true
                    //                        hasbottom = false
                    //                    } else {
                    //                        //subcase 4 next cell has no event
                    //                        cell.lineviewBottom.hidden = false
                    //                        hasbottom = true
                    //                    }
                    //                }
                    //                // cell.setDisplayData(AI,events: CalendarMatrix[AI].2,_hastop: hastop, _hasbottom: hasbottom, _hasleft: hasleft, _hasright: hasright)
                    //            }
                    //            else if 0 < mainid && i <= 160 && cell.tag == i {
                    //                if CalendarMatrix[i].2.count > 0 {
                    //                    if CalendarMatrix[i - 7].2.count > 0{
                    //                        cell.lineviewTop.hidden = true
                    //                        hastop = false
                    //                        cell.BthereImg.hidden = true
                    //                        cell.eyeImg.hidden = true
                    //                    } else {
                    //                        //subcase 4 previous cell has no event
                    //                        cell.lineviewTop.hidden = false
                    //                        for item in CalendarMatrix[i].2 {
                    //                            if item.iCoordinatedServiceId > 0 {
                    //                                cell.hasEventBthere = true
                    //                                cell.BthereImg.hidden = false
                    //                                break
                    //                            }
                    //                        }
                    //                        for item in CalendarMatrix[i].2 {
                    //                            if item.iCoordinatedServiceId == 0 {
                    //                                cell.hasEvent = true
                    //                                cell.eyeImg.hidden = false
                    //                                break
                    //                            }
                    //                        }
                    //
                    //                        hastop = true
                    //                    }
                    //
                    //
                    //                    cell.lineviewLeft.hidden = false
                    //                    cell.lineviewRight.hidden = false
                    //                    hasleft = true
                    //                    hasright = true
                    //                    if CalendarMatrix[i + 7].2.count > 0{
                    //                        cell.lineviewBottom.hidden = true
                    //                        hasbottom = false
                    //                    } else {
                    //                        //subcase 4 next cell has no event
                    //                        cell.lineviewBottom.hidden = false
                    //                        hasbottom = true
                    //                    }
                    //                    //   cell.setDisplayData(AI,events: CalendarMatrix[AI].2,_hastop: hastop, _hasbottom: hasbottom, _hasleft: hasleft, _hasright: hasright)
                    //                }
                    //
                    //                else {
                    //                    cell.lineviewTop.hidden = true
                    //                    cell.lineviewLeft.hidden = true
                    //                    cell.lineviewRight.hidden = true
                    //                    cell.lineviewBottom.hidden = true
                    //
                    //                    cell.BthereImg.hidden = true
                    //                    cell.eyeImg.hidden = true
                    //                    hastop = false
                    //                    hasleft = false
                    //                    hasright = false
                    //                    hasbottom = false
                    //                    //   cell.setDisplayData(AI,events: CalendarMatrix[AI].2,_hastop: hastop, _hasbottom: hasbottom, _hasleft: hasleft, _hasright: hasright)
                    //                }
                    //
                    //            }
                    //
                    //
                    //            else if  0 < mainid && i > 160 {
                    //                // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
                    //                if CalendarMatrix[i].2.count > 0 && cell.tag == i {
                    //                    cell.lineviewBottom.hidden = false
                    //                    cell.lineviewLeft.hidden = false
                    //                    cell.lineviewRight.hidden = false
                    //                    hastop = true
                    //                    hasleft = true
                    //                    hasright = true
                    //                    //subcase 3 previous cell has event
                    //                    if CalendarMatrix[i - 7].2.count > 0{
                    //                        cell.lineviewTop.hidden = true
                    //                        cell.BthereImg.hidden = false
                    //                        cell.eyeImg.hidden = false
                    //                        hastop = false
                    //                    } else {
                    //                        //subcase 4 next cell has no event
                    //                        cell.lineviewTop.hidden = false
                    //                        cell.BthereImg.hidden = true
                    //                        cell.eyeImg.hidden = true
                    //                        hastop = true
                    //                    }
                    //
                    //                }
                    //                //  cell.setDisplayData(AI,events: CalendarMatrix[AI].2,_hastop: hastop, _hasbottom: hasbottom, _hasleft: hasleft, _hasright: hasright)
                    //            }
                    //        }
                    //        // end old code

                    //                    var hastop:Bool = false
                    //                    var hasleft:Bool = false
                    //                    var hasright:Bool = false
                    //                    var hasbottom:Bool = false
                    cell.lineviewTop.isHidden = true
                    cell.lineviewLeft.isHidden = true
                    cell.lineviewRight.isHidden = true
                    cell.lineviewBottom.isHidden = true
                    cell.BthereImg.isHidden = true
                    cell.eyeImg.isHidden = true
                    //                    hastop = false
                    //                    hasleft = false
                    //                    hasright = false
                    //                    hasbottom = false
                    var array4views:Array<UIView> = Array<UIView>()
                    array4views = []
                    array4views.append(cell.FIRSTLINE)
                    array4views.append(cell.SECONDLINE)
                    array4views.append(cell.THIRSLINE)
                    array4views.append(cell.FOURTHLINE)
                    var haseventx:Bool = false
                    for i:Int in column1  {
                        //case 1 previous cell has event
                        //first cell 0
                        let mainid:Int = column1.index(of: i)!
                        if mainid == 0 && i <= 160 && cell.tag == i{

                            if CalendarMatrix[i].2.count > 0 {
                                print("self.seeifhasPhoneEvent \(self.seeifhasPhoneEvent(i))")
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }

                            }
                        }
                        else if 0 < mainid && i <= 160 && cell.tag == i {
                            if CalendarMatrix[i].2.count > 0 {

                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()

                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }


                        else if  0 < mainid && i > 160 {
                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }
                    }
                    /// 2 3  ...7
                    for i:Int in column2  {
                        //case 1 previous cell has event
                        //first cell 0
                        let mainid:Int = column2.index(of: i)!
                        if mainid == 0 && i <= 160 && cell.tag == i{

                            if CalendarMatrix[i].2.count > 0 {
                                print("self.seeifhasPhoneEvent \(self.seeifhasPhoneEvent(i))")
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }

                            }
                        }
                        else if 0 < mainid && i <= 160 && cell.tag == i {
                            if CalendarMatrix[i].2.count > 0 {

                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()

                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }


                        else if  0 < mainid && i > 160 {
                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }
                    }

                    for i:Int in column3  {
                        //case 1 previous cell has event
                        //first cell 0
                        let mainid:Int = column3.index(of: i)!
                        if mainid == 0 && i <= 160 && cell.tag == i{

                            if CalendarMatrix[i].2.count > 0 {
                                print("self.seeifhasPhoneEvent \(self.seeifhasPhoneEvent(i))")
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }

                            }
                        }
                        else if 0 < mainid && i <= 160 && cell.tag == i {
                            if CalendarMatrix[i].2.count > 0 {

                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()

                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }


                        else if  0 < mainid && i > 160 {
                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }
                    }

                    for i:Int in column4  {
                        //case 1 previous cell has event
                        //first cell 0
                        let mainid:Int = column4.index(of: i)!
                        if mainid == 0 && i <= 160 && cell.tag == i{

                            if CalendarMatrix[i].2.count > 0 {
                                print("self.seeifhasPhoneEvent \(self.seeifhasPhoneEvent(i))")
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }

                            }
                        }
                        else if 0 < mainid && i <= 160 && cell.tag == i {
                            if CalendarMatrix[i].2.count > 0 {

                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()

                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }


                        else if  0 < mainid && i > 160 {
                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }
                    }
                    for i:Int in column5  {
                        //case 1 previous cell has event
                        //first cell 0
                        let mainid:Int = column5.index(of: i)!
                        if mainid == 0 && i <= 160 && cell.tag == i{

                            if CalendarMatrix[i].2.count > 0 {
                                print("self.seeifhasPhoneEvent \(self.seeifhasPhoneEvent(i))")
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }

                            }
                        }
                        else if 0 < mainid && i <= 160 && cell.tag == i {
                            if CalendarMatrix[i].2.count > 0 {

                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()

                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }


                        else if  0 < mainid && i > 160 {
                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }
                    }

                    for i:Int in column6  {
                        //case 1 previous cell has event
                        //first cell 0
                        let mainid:Int = column6.index(of: i)!
                        if mainid == 0 && i <= 160 && cell.tag == i{

                            if CalendarMatrix[i].2.count > 0 {
                                print("self.seeifhasPhoneEvent \(self.seeifhasPhoneEvent(i))")
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }

                            }
                        }
                        else if 0 < mainid && i <= 160 && cell.tag == i {
                            if CalendarMatrix[i].2.count > 0 {

                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()

                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }


                        else if  0 < mainid && i > 160 {
                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }
                    }

                    for i:Int in column7  {
                        //case 1 previous cell has event
                        //first cell 0
                        let mainid:Int = column7.index(of: i)!
                        if mainid == 0 && i <= 160 && cell.tag == i{

                            if CalendarMatrix[i].2.count > 0 {
                                print("self.seeifhasPhoneEvent \(self.seeifhasPhoneEvent(i))")
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }

                            }
                        }
                        else if 0 < mainid && i <= 160 && cell.tag == i {
                            if CalendarMatrix[i].2.count > 0 {

                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()

                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }


                        else if  0 < mainid && i > 160 {
                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
                                haseventx =  self.seeifhasPhoneEvent(i)
                                if haseventx == true {
                                    cell.eyeImg.isHidden = false
                                }
                                var MYARR:Array<UIColor> = Array<UIColor>()
                                MYARR = self.calculateColorsincell(i)
                                let countonarray:Int = MYARR.count
                                switch (countonarray) {
                                case 1:
                                    //one service // 1 views with  color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[0]
                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
                                //
                                case 2:
                                    //two services // 2 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[0]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
                                case 3:
                                    //three services // 3 views with different color
                                    //three services // 3 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[1]
                                    cell.FOURTHLINE.backgroundColor = MYARR[2]
                                case 4:
                                    //fours services // 4 views with different color
                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
                                    cell.SECONDLINE.backgroundColor = MYARR[1]
                                    cell.THIRSLINE.backgroundColor = MYARR[2]
                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
                                default:
                                    print("no service")
                                }
                            }
                        }
                    }
                }
                cell.patternImg.image = nil

                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                tapInsideCEll.delegate = self
                let myview:UIView = UIView()
                myview.frame = cell.contentView.frame
                myview.backgroundColor = UIColor.clear
                //    myview.backgroundColor = colorWithHexString( "#363636")
                //\\
                //\\ cell.eyeImg.hidden = hasEvent
                cell.bringSubviewToFront(cell.eyeImg)
                cell.addSubview(myview)
                myview.tag = cell.tag
                myview.addGestureRecognizer(tapInsideCEll)
                cell.bringSubviewToFront(myview)
                if self.FROMPRINT == true {

                    self.TRYPDFJUSTNOW()
                    self.FROMPRINT = false
                }


            }
        }
        return cell
    }
    func seeifhasPhoneEvent(_ i:Int) -> Bool {
        var hasEvent:Bool = false
        if CalendarMatrix[i].2.count > 0 {
            for j in 0..<CalendarMatrix[i].2.count {
                let myitem  = CalendarMatrix[i].2[j]

                if myitem.iCoordinatedServiceId == 0  {
                    print("myitem.iCoordinatedServiceId \(myitem.iCoordinatedServiceId)")
                    hasEvent = true
                    //   break
                }
            }
        }
        return hasEvent
    }
    func calculateColorsincell(_ i:Int) -> Array<UIColor> {
        var myarr:Array<UIColor> = Array<UIColor>()
        let howmanylinesinrow:Int = CalendarMatrix[i].2.count
        var alittlearray:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
        if howmanylinesinrow > 0 {
            for item in  CalendarMatrix[i].2 {
                if item.iCoordinatedServiceId > 0 {
                    if !alittlearray.contains(item) {
                        alittlearray.append(item)

                    }
                }
            }
        }
        let howmanybthereinroww:Int = alittlearray.count
        switch (howmanybthereinroww) {
        case 1:
            //one service so all views have same color
            for item in CalendarMatrix[i].2 {
                if item.chServiceColor != "" ||  item.chServiceColor != "<null>"  {

                    myarr.append(colorWithHexString(item.chServiceColor))
                    break
                } else {
                    myarr.append(colorWithHexString("#FF6666"))
                    break
                }
            }
        case 2:
            //two services // 2 views with different  colour
            for j in 0..<CalendarMatrix[i].2.count {
                let myitem  = CalendarMatrix[i].2[j]
                if myitem.iCoordinatedServiceId > 0 {
                    if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>" {
                        myarr.append(colorWithHexString(myitem.chServiceColor))

                    } else {
                        myarr.append(colorWithHexString("#FF6666"))
                    }
                }
            }
        case 3:
            for j in 0..<CalendarMatrix[i].2.count {
                let myitem  = CalendarMatrix[i].2[j]
                if myitem.iCoordinatedServiceId > 0 {
                    if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>" {
                        myarr.append(colorWithHexString(myitem.chServiceColor))

                    } else {
                        myarr.append(colorWithHexString("#FF6666"))
                    }
                }
            }
            //three services // 3 views with different color
            //            let myitem = CalendarMatrix[i].2[0]
            //            if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>"  {
            //                myarr.append(colorWithHexString(myitem.chServiceColor))
            //
            //            }
            //            let myitem2 = CalendarMatrix[i].2[1]
            //            if myitem2.chServiceColor != "" ||  myitem2.chServiceColor != "<null>"  {
            //                myarr.append(colorWithHexString(myitem2.chServiceColor))
            //            }
            //            let myitem3 = CalendarMatrix[i].2[2]
            //            if myitem3.chServiceColor != "" ||  myitem3.chServiceColor != "<null>"  {
            //                myarr.append(colorWithHexString(myitem3.chServiceColor))
            //
        //            }
        case 4:
            //fours services // 4 views with different color
            //            let myitem = CalendarMatrix[i].2[0]
            //            if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>"  {
            //                myarr.append(colorWithHexString(myitem.chServiceColor))
            //
            //            }
            //            let myitem2 = CalendarMatrix[i].2[1]
            //            if myitem2.chServiceColor != "" ||  myitem2.chServiceColor != "<null>"  {
            //                 myarr.append(colorWithHexString(myitem2.chServiceColor))
            //            }
            //            let myitem3 = CalendarMatrix[i].2[2]
            //            if myitem3.chServiceColor != "" ||  myitem3.chServiceColor != "<null>"  {
            //                myarr.append(colorWithHexString(myitem3.chServiceColor))
            //
            //            }
            //            let myitem4 = CalendarMatrix[i].2[3]
            //            if myitem4.chServiceColor != "" ||  myitem4.chServiceColor != "<null>"  {
            //                myarr.append(colorWithHexString(myitem4.chServiceColor))
            //            }
            for j in 0..<CalendarMatrix[i].2.count {
                let myitem  = CalendarMatrix[i].2[j]
                if myitem.iCoordinatedServiceId > 0 {
                    if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>" {
                        myarr.append(colorWithHexString(myitem.chServiceColor))

                    } else {
                        myarr.append(colorWithHexString("#FF6666"))
                    }
                }
            }
        default:
            print("no service")
        }
        return myarr
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 192//

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom

        switch (deviceIdiom)  {
        case .pad:
            // let widthScreen = UIScreen.mainScreen().bounds.size.width
            // let heightScreen  = UIScreen.mainScreen().bounds.size.height

            return CGSize(width: collWeek.frame.size.width / 8, height:  collWeek.frame.size.height / 9.3)
        // return CGSize(width: widthScreen / 8, height:  collWeek.frame.size.height / 9.3)
        default:
            return CGSize(width: collWeek.frame.size.width / 8, height:  collWeek.frame.size.width / 9)
        }

        return CGSize(width: collWeek.frame.size.width / 8, height:  collWeek.frame.size.width / 9)

    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, UIEdgeInsets indexPath: IndexPath) -> UIEdgeInsets {

        return UIEdgeInsets.init(top: 0, left: 0,bottom: 0,right: 0);
    }

    //MARK: - ScrollView


    func setDate()
    {
        //the day of week from date - (int)
        let day:Int = Calendar.sharedInstance.getDayOfWeek(currentDate)! - 1

        let otherDate:Date = currentDate

        //show month for each day in week
        lblDay1.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 6).description
        lblDay2.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 5).description
        lblDay3.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 4).description
        lblDay4.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 3).description
        lblDay5.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 2).description
        lblDay6.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 1).description
        lblDay7.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 0).description

        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 6))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 5))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 4))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 3))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 2))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 1))
        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 0))
        print("monthArray \(monthArray)")


        let componentsEventx = (calendar as NSCalendar).components([.day, .month, .year], from: dtDateStart)
        let componentsEndEventx = (calendar as NSCalendar).components([.day, .month, .year], from: dtDateEnd)
        var monthName:String = ""
        var endmonthName:String = ""
        var yearStart:String = ""
        var yearEnd:String = ""


        let yearEvent:Int = componentsEventx.year!


        let dateFormatter = DateFormatter()
        let dateFormatterYEAR = DateFormatter()

        dateFormatter.dateFormat = "MMM"
        dateFormatterYEAR.dateFormat = "yyyy"


        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatter.locale = Locale(identifier: "he_IL")
        } else {
            dateFormatter.locale = Locale(identifier: "en_US")
        }


        monthName = dateFormatter.string(from: dtDateStart)
        endmonthName = dateFormatter.string(from: dtDateEnd)

        let yearEndEvent:Int = componentsEndEventx.year!


        yearStart = String(yearEvent)
        yearEnd = String(yearEndEvent)

        if yearStart != yearEnd {
            lblDays.text = "\(lblDay7.text!).\(monthName).\(yearStart) - \(lblDay1.text!) .\(endmonthName).\(yearEnd)"
        } else{
            if monthName != endmonthName {
                lblDays.text = "\(lblDay7.text!).\(monthName) - \(lblDay1.text!) .\(endmonthName).\(yearStart)"
            }
            else {
                lblDays.text = "\(lblDay7.text!) - \(lblDay1.text!) .\(monthName).\(yearStart)"
            }
        }
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)

        yearToday =  components.year!
        // - long
        //NSDateFormatter().monthSymbols[monthToday - 1]
        //let dayName = NSDateFormatter().weekdaySymbols[day]

        //   lblDate.text = "\(monthName) \(yearToday)"
    }
    func getDateFromString(_ dateString: String)->Date

    {
        var datAMEA:Date = Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy"
        //\\  dateFormatter.dateStyle = .ShortStyle
        //        print("crASH \(dateString)")
        if let  _ = dateFormatter2.date(from: dateString) {
            datAMEA = dateFormatter2.date(from: dateString)!
            print("datestring \(getDateFromString) si data mea \(datAMEA)")
        }
        return datAMEA
    }

    func emptyCalendarMatrix(){
        arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]
        CalendarMatrix = []
        for inthour in arrHoursInt {
            for intday in arrayDays {
                let ax:Int = intday as! Int
                let fullreservedids:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                CalendarMatrix.append((inthour,ax,fullreservedids))
            }
        }
        print("CalendarMatrix \(CalendarMatrix) and count \(CalendarMatrix.count)")
    }

    func initALLSECTIONSFINAL() {
        print("arrayDays \( arrayDays)")
        ALLSECTIONSFINAL = []
        ALLSECTIONSFINALFILTERED = []

        // var CalendarMatrix:[(Int,Array<Int>)] = []
        for inthour in arrHoursInt {
            let onetoadd = (inthour,Array<allKindEventsForListDesign>())
            ALLSECTIONSFINAL.append(onetoadd)
            ALLSECTIONSFINALFILTERED.append(onetoadd)

        }
        CalendarMatrix = []
        for inthour in arrHoursInt {
            for intday in arrayDays {
                let ax:Int = intday as! Int
                let fullreservedids:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                CalendarMatrix.append((inthour, ax,fullreservedids))
            }
        }
        print("CalendarMatrix \(CalendarMatrix) and count \(CalendarMatrix.count)")
    }

    //    //set device event in array
    //    func setEventsArray(today:NSDate)
    //    {
    //        arrEventsCurrentDay = []
    //        for item in Global.sharedInstance.eventList
    //        {
    //            let event = item as! EKEvent
    //
    //            let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: today)
    //
    //            let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: event.startDate)
    //
    //            yearToday =  componentsCurrent.year
    //            monthToday = componentsCurrent.month
    //            dayToday = componentsCurrent.day
    //
    //            let yearEvent =  componentsEvent.year
    //            let monthEvent = componentsEvent.month
    //            let dayEvent = componentsEvent.day
    //
    //            if yearEvent == yearToday && monthEvent == monthToday && dayEvent == dayToday
    //            {
    //                arrEventsCurrentDay.append(event)
    //                hasEvent = true
    //            }
    //        }
    //        for itemx in PERFECTSENSE {
    //            let eventx = itemx as! allKindEventsForListDesign
    //
    //            let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: today)
    //
    //            let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: eventx.dtDateOrder)
    //
    //            yearToday =  componentsCurrent.year
    //            monthToday = componentsCurrent.month
    //            dayToday = componentsCurrent.day
    //
    //            let yearEvent =  componentsEvent.year
    //            let monthEvent = componentsEvent.month
    //            let dayEvent = componentsEvent.day
    //
    //            if yearEvent == yearToday && monthEvent == monthToday && dayEvent == dayToday
    //            {
    //                arrBThereEventsCurrentDay.append(eventx)
    //                hasEvent = true
    //            }
    //
    //        }
    //
    //    }
    func calculateDurationofEvent(_ Event: allKindEventsForListDesign)  -> Int {

        var minutesys:Int = 0
        print("ceva \(Event.fromHour) - \(Event.toHour) ") // 02:00 - 02:15
        let startDate = Event.fromHour
        let endDate = Event.toHour

        let startArray = startDate.components(separatedBy: ":") // ["23", "51"]
        let endArray = endDate.components(separatedBy: ":") // ["00", "01"]

        let startHours = Int(startArray[0])! * 60 // 1380
        let startMinutes = Int(startArray[1])! + startHours // 1431

        let endHours = Int(endArray[0])! * 60 // 0
        let endMinutes = Int(endArray[1])! + endHours // 1

        var timeDifference = endMinutes - startMinutes // -1430

        let day = 24 * 60 // 1440

        if timeDifference < 0 {
            timeDifference += day // 10
        }
        print("cc \(timeDifference)")
        //\\ let myarr =  gethoursandminuteforevent(Event)

        //\\   print("ceva \(gethoursandminuteforevent(Event)) ") // 02:00 - 02:15
        //        let hourS_Show = myarr[0]
        //        let hourE_Show = myarr[2]
        //        let minuteS_Show = myarr[1]
        //        let minuteE_Show = myarr[3]
        //         if hourS_Show == hourE_Show {
        //            minutesys = minuteE_Show - minuteS_Show
        //
        //        }
        //        if hourS_Show < hourE_Show {
        //            let HOURSdiff = hourE_Show - hourS_Show
        //            minutesys =  HOURSdiff * 60 + minuteE_Show + 60 - minuteS_Show
        //
        //        }
        print("cate minute  \(timeDifference)")
        return timeDifference


    }

    func gethourStartEnd(_ eventx: allKindEventsForListDesign) -> [Int] {

        //fromhour
        var eventHour:Int = 0
        var eventHourEnd:Int = 0
        var eventMinutesEnd:Int = 0
        if let a1:Character =  eventx.fromHour[eventx.fromHour.startIndex] {
            if a1 == "0" {
                //now get the real hour
                if let a2:Character =  eventx.fromHour[eventx.fromHour.characters.index(eventx.fromHour.startIndex, offsetBy: 1)]{
                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
                    if a2 == "0" {
                        //       print("ora1 0 add to 0")
                        eventHour = 0
                    }
                    else {
                        //      print("ora1 \(a2) add to \(a2)") //section
                        let str = String(a2)
                        let IntHOUR:Int = Int(str)!
                        eventHour = IntHOUR

                    }
                }
            }
            else { //full hour 2 chars
                let fullNameArr = eventx.fromHour.components(separatedBy: ":")
                let size = fullNameArr.count
                if(size > 1 ) {
                    if let _:String = fullNameArr[0]  {
                        let hourstring:String = fullNameArr[0]
                        let numberFromString:Int = Int(hourstring)!
                        eventHour = numberFromString
                    }
                }
            }
        }
        ////tohour
        if let a1:Character =  eventx.toHour[eventx.toHour.startIndex] {
            if a1 == "0" {
                //now get the real hour
                if let a2:Character =  eventx.toHour[eventx.toHour.characters.index(eventx.toHour.startIndex, offsetBy: 1)]{
                    if a2 == "0" {
                        //    print("ora1 0 add to 0")
                        eventHourEnd = 0
                    }
                    else {
                        //    print("ora1 \(a2) add to \(a2)") //section
                        let str = String(a2)
                        let IntHOUR:Int = Int(str)!
                        eventHourEnd = IntHOUR
                        let fullNameArr = eventx.toHour.components(separatedBy: ":")
                        let size = fullNameArr.count
                        if(size > 1 ) {
                            if let _:String = fullNameArr[1]  {
                                let minutesString:String = fullNameArr[1]
                                if minutesString != "00" {
                                    eventMinutesEnd = 1
                                }
                            }
                        }
                    }
                }
            }
            else { //full hour 2 chars
                let fullNameArr = eventx.toHour.components(separatedBy: ":")
                let size = fullNameArr.count
                if(size > 1 ) {
                    if let _:String = fullNameArr[0]  {
                        let hourstring:String = fullNameArr[0]
                        let numberFromString:Int = Int(hourstring)!
                        eventHourEnd = numberFromString
                    }
                    let fullNameArr = eventx.toHour.components(separatedBy: ":")
                    let size = fullNameArr.count
                    if(size > 1 ) {
                        if let _:String = fullNameArr[1]  {
                            let minutesString:String = fullNameArr[1]
                            if minutesString != "00" {
                                eventMinutesEnd = 1
                            }
                        }
                    }
                }
            }
        }
        return [eventHour,eventHourEnd,eventMinutesEnd]


    }

    func setEventsArray(_ today:Date)  {

    }
    func setEventsArrayx() {
        /*
         CalendarMatrix [(0, 18, []), (0, 17, []), (0, 16, []), (0, 15, []), (0, 14, []), (0, 13, []), (0, 12, []), (1, 18, []), (1, 17, []), (1, 16, []), (1, 15, []), (1, 14, []), (1, 13, []), (1, 12, []), (2, 18, []), (2, 17, []), (2, 16, []), (2, 15, []), (2, 14, []), (2, 13, []), (2, 12, []), (3, 18, []), (3, 17, []), (3, 16, []), (3, 15, []), (3, 14, []), (3, 13, []), (3, 12, []), (4, 18, []), (4, 17, []), (4, 16, []), (4, 15, []), (4, 14, []), (4, 13, []), (4, 12, []), (5, 18, []), (5, 17, []), (5, 16, []), (5, 15, []), (5, 14, []), (5, 13, []), (5, 12, []), (6, 18, []), (6, 17, []), (6, 16, []), (6, 15, []), (6, 14, []), (6, 13, []), (6, 12, []), (7, 18, []), (7, 17, []), (7, 16, []), (7, 15, []), (7, 14, []), (7, 13, []), (7, 12, []), (8, 18, []), (8, 17, []), (8, 16, []), (8, 15, []), (8, 14, []), (8, 13, []), (8, 12, []), (9, 18, []), (9, 17, []), (9, 16, []), (9, 15, []), (9, 14, []), (9, 13, []), (9, 12, []), (10, 18, []), (10, 17, []), (10, 16, []), (10, 15, []), (10, 14, []), (10, 13, []), (10, 12, []), (11, 18, []), (11, 17, []), (11, 16, []), (11, 15, []), (11, 14, []), (11, 13, []), (11, 12, []), (12, 18, []), (12, 17, []), (12, 16, []), (12, 15, []), (12, 14, []), (12, 13, []), (12, 12, []), (13, 18, []), (13, 17, []), (13, 16, []), (13, 15, []), (13, 14, []), (13, 13, []), (13, 12, []), (14, 18, []), (14, 17, []), (14, 16, []), (14, 15, []), (14, 14, []), (14, 13, []), (14, 12, []), (15, 18, []), (15, 17, []), (15, 16, []), (15, 15, []), (15, 14, []), (15, 13, []), (15, 12, []), (16, 18, []), (16, 17, []), (16, 16, []), (16, 15, []), (16, 14, []), (16, 13, []), (16, 12, []), (17, 18, []), (17, 17, []), (17, 16, []), (17, 15, []), (17, 14, []), (17, 13, []), (17, 12, []), (18, 18, []), (18, 17, []), (18, 16, []), (18, 15, []), (18, 14, []), (18, 13, []), (18, 12, []), (19, 18, []), (19, 17, []), (19, 16, []), (19, 15, []), (19, 14, []), (19, 13, []), (19, 12, []), (20, 18, []), (20, 17, []), (20, 16, []), (20, 15, []), (20, 14, []), (20, 13, []), (20, 12, []), (21, 18, []), (21, 17, []), (21, 16, []), (21, 15, []), (21, 14, []), (21, 13, []), (21, 12, []), (22, 18, []), (22, 17, []), (22, 16, []), (22, 15, []), (22, 14, []), (22, 13, []), (22, 12, []), (23, 18, []), (23, 17, []), (23, 16, []), (23, 15, []), (23, 14, []), (23, 13, []), (23, 12, [])
         //////////////////////////
         For CalendarMatrix=1 to 168
         {
         if OriginalMeetingsArray[i].StartHour>=CalendarMatrix[j].Hour     or  OriginalMeetingsArray[i].EndHour<=CalendarMatrix[j].Hour
         then Add(CalendarMatrix[j].Objects , OriginalMeetingsArray[i].ID)
         }
         }

         */
        emptyCalendarMatrix()



        //   var bthevent:allKindEventsForListDesign = allKindEventsForListDesign()
        arrEventsCurrentDay = []

        for i in 0..<7
        {
            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!

            let curentTempDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1)
            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: curentTempDate)
            //\\print ("curDate \(curentTempDate)")
            // let  yearTodayx =  componentsCurrent.year
            //  let monthTodayx = componentsCurrent.month
            let dayTodayx = componentsCurrent.day
            for itemx in PERFECTSENSE {
                let eventx = itemx
                let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: eventx.dateEvent as Date)
                //                            let yearEvent =  componentsEvent.year
                //                            let monthEvent = componentsEvent.month
                let dayEvent = componentsEvent.day


                //  //\\print ("curDate \(curentTempDate) yearTodayx \(yearTodayx) monthTodayx\(monthTodayx) dayTodayx \(dayTodayx) \n yearEvent\(yearEvent) monthEvent\(monthEvent) dayEvent\(dayEvent) ")
                //\\print ("curDate \(curentTempDate)  dayTodayx \(dayTodayx)  dayEvent\(dayEvent) ")
                if /*yearEvent == yearTodayx && monthEvent == monthTodayx   && */ dayEvent == dayTodayx {
                    for   j in 0 ..< CalendarMatrix.count {
                        if CalendarMatrix[j].1 == dayTodayx {
                            var eventHour:Int = 0
                            var eventHourEnd:Int = 0
                            var eventMinutesEnd:Int = 0
                            var  HoursArray = [Int]()
                            HoursArray = gethourStartEnd(eventx)
                            eventHour = HoursArray[0]
                            eventHourEnd = HoursArray[1]
                            eventMinutesEnd = HoursArray[2]
                            print("eventMinutesEnd\(eventMinutesEnd)")
                            //\\print ("eventHour \(eventHour) eventHourEnd \(eventHourEnd)")
                            //1 row
                            if  eventHour == CalendarMatrix[j].0 {  //hourstart only clear matrix ordered by start h
                                let ay:Int = eventx.iCoordinatedServiceId
                                let worker:Int = eventx.iProviderUserId
                                print("WEEK idSupplierWorker \(Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker"))")
                                if Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") == -1 {
                                    if !CalendarMatrix[j].2.contains(eventx) {
                                        CalendarMatrix[j].2.append(eventx)
                                        hasEvent = true
                                        //\\print ("common  \(ay ) eventx \(eventx)")
                                        if eventHour < eventHourEnd {
                                            //see if hour end has 00 minutes
                                            if eventMinutesEnd == 0   {
                                                for i:Int in eventHour..<eventHourEnd {
                                                    print("where i is needed \(i)")
                                                    for   j in 0 ..< CalendarMatrix.count {
                                                        if CalendarMatrix[j].1 == dayTodayx {
                                                            if CalendarMatrix[j].0 == i {
                                                                if !CalendarMatrix[j].2.contains(eventx) {
                                                                    CalendarMatrix[j].2.append(eventx)
                                                                    hasEvent = true
                                                                    //\\print ("added ending  \(ay ) eventx \(eventx)")
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            } else {
                                                //start else
                                                //start else
                                                for i:Int in eventHour...eventHourEnd {
                                                    print("where i is needed \(i)")
                                                    for   j in 0 ..< CalendarMatrix.count {
                                                        if CalendarMatrix[j].1 == dayTodayx {
                                                            if CalendarMatrix[j].0 == i {
                                                                if !CalendarMatrix[j].2.contains(eventx) {
                                                                    CalendarMatrix[j].2.append(eventx)
                                                                    hasEvent = true
                                                                    //\\print ("added ending  \(ay ) eventx \(eventx)")
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            //end else
                                        }
                                    }
                                    if eventx.iCoordinatedServiceId == 0 {
                                        if !CalendarMatrix[j].2.contains(eventx) {
                                            CalendarMatrix[j].2.append(eventx)
                                        }
                                    }

                                } else if Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") > 0 && worker == Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") {
                                    if !CalendarMatrix[j].2.contains(eventx) {
                                        CalendarMatrix[j].2.append(eventx)
                                        hasEvent = true
                                        //\\print ("common  \(ay ) eventx \(eventx)")
                                        if eventHour < eventHourEnd {
                                            //see if hour end has 00 minutes
                                            if eventMinutesEnd == 0   {
                                                for i:Int in eventHour..<eventHourEnd {
                                                    print("where i is needed \(i)")
                                                    for   j in 0 ..< CalendarMatrix.count {
                                                        if CalendarMatrix[j].1 == dayTodayx {
                                                            if CalendarMatrix[j].0 == i {
                                                                if !CalendarMatrix[j].2.contains(eventx) {
                                                                    CalendarMatrix[j].2.append(eventx)
                                                                    hasEvent = true
                                                                    //\\print ("added ending  \(ay ) eventx \(eventx)")
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            } else {
                                                //start else
                                                //start else
                                                for i:Int in eventHour...eventHourEnd {
                                                    print("where i is needed \(i)")
                                                    for   j in 0 ..< CalendarMatrix.count {
                                                        if CalendarMatrix[j].1 == dayTodayx {
                                                            if CalendarMatrix[j].0 == i {
                                                                if !CalendarMatrix[j].2.contains(eventx) {
                                                                    CalendarMatrix[j].2.append(eventx)
                                                                    hasEvent = true
                                                                    //\\print ("added ending  \(ay ) eventx \(eventx)")
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            //end else
                                        }
                                    }
                                } //add also user phone events
                                if eventx.iCoordinatedServiceId == 0 {
                                    if !CalendarMatrix[j].2.contains(eventx) {
                                        print("eventx  in phone \(eventx.title) si ora \(eventx.fromHour)")
                                        CalendarMatrix[j].2.append(eventx)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }



        print("End CalendarMatrix \(CalendarMatrix) si count \(CalendarMatrix.count)")
        //        if NOLOAD == true {
        //           NOLOAD = false


        // }
        sortandjoinarrays()

        //now add to hours interval beetwen start end



        //                                    if (CalendarMatrix[j].0 == 23 && eventHour >= CalendarMatrix[j].0 - 1 && eventHour <= CalendarMatrix[j].0) {
        //                                        let ay:Int = eventx.iCoordinatedServiceId
        //                                        if !CalendarMatrix[j].2.contains(eventx) {
        //                                            CalendarMatrix[j].2.append(eventx)
        //                                            hasEvent = true
        //                                            //\\print ("common ai hour 23 end 24 \(ay ) eventx \(eventx)")
        //                                        }
        //                                    }
        //                                    if (23 >= CalendarMatrix[j].0 > 0 && eventHour >= CalendarMatrix[j].0 && eventHourEnd <= CalendarMatrix[j].0 + 1) {
        //                                        let ay:Int = eventx.iCoordinatedServiceId
        //                                        if !CalendarMatrix[j].2.contains(eventx) {
        //                                            CalendarMatrix[j].2.append(eventx)
        //                                            hasEvent = true
        //                                            //\\print ("common ai hour inside 1 23 \(ay ) eventx \(eventx)")
        //                                        }
        //                                    }


        //
        //                                    if (eventHour >= CalendarMatrix[j].0 && eventHour <= CalendarMatrix[j].0)) ||  //On first cell checking only strating hour
        //                                        (j == CalendarMatrix.count-1 && (eventHourEnd <= CalendarMatrix[j].0 && eventHourEnd >= CalendarMatrix[j-7].0)) || // On last cell checking only ending hour
        //                                      (eventHour >= CalendarMatrix[j].0 && eventHour <= CalendarMatrix[j].0) || (eventHourEnd <= CalendarMatrix[j].0 && eventHourEnd >= CalendarMatrix[j].0 ) )//on every other cell checking both
        //                                    { //insertion
        //                                    let ay:Int = eventx.iCoordinatedServiceId
        //                                    if !CalendarMatrix[j].2.contains(eventx) {
        //                                        CalendarMatrix[j].2.append(eventx)
        //                                         hasEvent = true
        //                                        //\\print ("common ai \(ay ) eventx \(eventx)")
        //                                    }
        //                                    }


    }
    func sortandjoinarrays() {

        // dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.refreshControl.endRefreshing()
        //   })

        //  self.bubbleSort( arrEventsCurrentDay)
        DispatchQueue.main.async(execute: { () -> Void in

            self.collWeek.reloadData()
        })

        self.carousel.delegate = self
        self.carousel.dataSource = self
        // self.carousel.setNeedsLayout()
        if self.arrayWorkers.count > 1 {
            self.carousel.type = .linear
        } else {
            self.carousel.type = .linear
            self.carousel.isUserInteractionEnabled = false
        }

        if self.arrayWorkers.count > 0 {
            if Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") == -1 {

                DispatchQueue.main.async(execute: { () -> Void in
                    //   self.carousel.scrollToItemAtIndex(1, animated: true)

                    self.carousel.scrollToItem(at: 0, animated: true)

                    //  self.carouselCurrentItemIndexDidChange(self.carousel)
                })
            } else {
                //get previous selected worker from array
                var x:Int = 0
                let delucru:NSMutableArray =  self.arrayWorkers
                for item in delucru {
                    if let _:User = item as? User {
                        let workerdic:User = item as! User
                        let diciuserid:Int = workerdic.iUserId

                        print(" diciuserid\(diciuserid)")
                        let iuseridselect:Int = Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")
                        if diciuserid == iuseridselect {

                            x = delucru.index(of: workerdic)
                            print("week am gasit worker selectat anterior \(diciuserid) la index \(x)")

                            DispatchQueue.main.async(execute: { () -> Void in

                                self.carousel.scrollToItem(at: x, animated: true)

                                //        self.carouselCurrentItemIndexDidChange(self.carousel)
                            })



                        }
                    }
                }
            }
        }


    }
    func getEventsArray(_ today:Date)
    {
        arrEventsCurrentDay = []


        if   Global.sharedInstance.isSyncWithGoogelCalendarSupplier == false {
            PERFECTSENSE = Array<allKindEventsForListDesign>()
            for  itemx in sortDicBTHEREevent
            {
                print("myitemx now \(itemx)")
                if let _:String = itemx.0  {
                    let eventdate:String = itemx.0
                    var datesInWeekArraysorted = datesInWeekArray.sorted()
                    let mydtDateStart = datesInWeekArraysorted[0]
                    let mydtDateEnd = datesInWeekArraysorted[6]
                    let EVENTDATE:Date = getDateFromString(eventdate)
                    let calendar:Foundation.Calendar = Foundation.Calendar.current
                    let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: EVENTDATE)
                    let componentsStart = (calendar as NSCalendar).components([.day, .month, .year], from: mydtDateStart)
                    let componentsEnd = (calendar as NSCalendar).components([.day, .month, .year], from: mydtDateEnd)
                    let EVENTFINALDATE = (calendar as NSCalendar).date(from: componentsEvent)!
                    let RDAYSTART:Date = (calendar as NSCalendar).date(from: componentsStart)!
                    let RDAYEND:Date =  (calendar as NSCalendar).date(from: componentsEnd)!

                    if EVENTFINALDATE >= RDAYSTART && RDAYEND >= EVENTFINALDATE {
                        hasEvent = true
                        for myx in itemx.1 {
                            if !PERFECTSENSE.contains(myx) {
                                print("myx title \(myx.title)")
                                PERFECTSENSE.append(myx)
                            }
                        }
                        print("ce e in arie \(PERFECTSENSE.count)")
                    }
                }
            }
        } else {
            //sortDicBTHEREevent
            PERFECTSENSE = Array<allKindEventsForListDesign>()
            for  itemx in sortDicEvents
            {
                print("myitemx now \(itemx)")
                if let _:String = itemx.0  {
                    let eventdate:String = itemx.0
                    var datesInWeekArraysorted = datesInWeekArray.sorted()
                    let mydtDateStart = datesInWeekArraysorted[0]
                    let mydtDateEnd = datesInWeekArraysorted[6]
                    let EVENTDATE:Date = getDateFromString(eventdate)
                    let calendar:Foundation.Calendar = Foundation.Calendar.current
                    let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: EVENTDATE)
                    let componentsStart = (calendar as NSCalendar).components([.day, .month, .year], from: mydtDateStart)
                    let componentsEnd = (calendar as NSCalendar).components([.day, .month, .year], from: mydtDateEnd)
                    let EVENTFINALDATE = (calendar as NSCalendar).date(from: componentsEvent)!
                    let RDAYSTART:Date = (calendar as NSCalendar).date(from: componentsStart)!
                    let RDAYEND:Date =  (calendar as NSCalendar).date(from: componentsEnd)!

                    if EVENTFINALDATE >= RDAYSTART && RDAYEND >= EVENTFINALDATE {
                        hasEvent = true
                        for myx in itemx.1 {
                            if !PERFECTSENSE.contains(myx) {
                                print("myx title \(myx.title)")
                                PERFECTSENSE.append(myx)
                            }
                        }
                        print("ce e in arie \(PERFECTSENSE.count)")
                    }
                }
            }
        }
        initALLSECTIONSFINAL()
        setDate()
        setEventsArrayx()
        setDateEnablity()


    }


    //check which date is small
    internal func small(_ lhs: Date, rhs: Date) -> Bool {
        let calendar:Foundation.Calendar = Foundation.Calendar.current
        let isToday:Bool = calendar.isDateInToday(lhs);
        if isToday
        {
            return false
        }
        else
        {
            return lhs.compare(rhs) == .orderedAscending
        }
    }
    // if eye design is set on  need to show device event
    @objc func showSync()
    {
        if btnSyncWithGoogelSupplier.isCecked == false
        {
            Global.sharedInstance.getEventsFromMyCalendar()
            btnSyncWithGoogelSupplier.isCecked = true
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true
            DispatchQueue.main.async(execute: { () -> Void in
                self.getEventsArray(self.currentDate)

            })

        }
        else
        {
            btnSyncWithGoogelSupplier.isCecked = false
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = false
            DispatchQueue.main.async(execute: { () -> Void in
                self.getEventsArray(self.currentDate)

            })

        }

    }
    //JMODE CLEAN AND VERIFYED
    //GetCustomersOrdersByDateForSupplier(int iSupplierId, DateTime dtDateStart, DateTime dtDateEnd)
    func GetCustomersOrdersByDateForSupplier()
    {
        //     refreshControl.endRefreshing()
        self.myArray = []
        Global.sharedInstance.ordersOfClientsArray = []
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        //empty first

        //JMODE in order to get customer's appoinments for current provider and not all of them
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                //  Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        //we take data for 3 months
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        let mydtDateStart = datesInWeekArraysorted[0]
        let mydtDateEnd = datesInWeekArraysorted[6]
        dic["dtDateStart"] = Global.sharedInstance.convertNSDateToString(mydtDateStart) as AnyObject
        dic["dtDateEnd"] = Global.sharedInstance.convertNSDateToString(mydtDateEnd) as AnyObject
        print ("dtDateStart a \(dtDateStart) dtDateEnd \(dtDateEnd) ")
        dic["iSupplierId"] = providerID as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomersOrdersByDateForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>() //empty first
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
                    {
                        let ps:OrderDetailsObj = OrderDetailsObj()

                        ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    }
                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {

                        let REZULTATE:NSArray = RESPONSEOBJECT["Result"] as! NSArray
                        let newarray:NSMutableArray = REZULTATE.mutableCopy() as! NSMutableArray

                        //                    for item in REZULTATE {
                        //                        let d:NSDictionary = item as! NSDictionary
                        //                        //\\print ("AM GASIT \(d.description)")
                        //                    }
                        self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
                        //MYordersOfClientsArray

                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            })
        }
    }
    //GetCustomersOrdersByDateForEmployeeId(int iUserId, DateTime dtDateStart, DateTime dtDateEnd)
    func GetCustomersOrdersByDateForEmployeeId()
    {
        //    refreshControl.endRefreshing()
        self.myArray = []
        Global.sharedInstance.ordersOfClientsArray = []
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        //empty first

        //JMODE in order to get customer's appoinments for current provider and not all of them
        //we take data for 3 months

        var y:Int = 0
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        // Global.sharedInstance.defaults.integerForKey("idSupplierWorker")
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        let mydtDateStart = datesInWeekArraysorted[0]
        let mydtDateEnd = datesInWeekArraysorted[6]
        dic["dtDateStart"] = Global.sharedInstance.convertNSDateToString(mydtDateStart) as AnyObject
        dic["dtDateEnd"] = Global.sharedInstance.convertNSDateToString(mydtDateEnd) as AnyObject

        //\\print ("dtDateStart \(dtDateStart) dtDateEnd \(dtDateEnd) ")
        dic["iUserId"] = y as AnyObject
        //\\ NU UITA dic["iUserId"] = y
        /////  dic["iUserId"] = 235
        //        if Global.sharedInstance.defaults.integerForKey("idSupplierWorker") > 0 {
        //            dic["iUserId"] = Global.sharedInstance.defaults.integerForKey("idSupplierWorker")
        //        }
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomersOrdersByDateForEmployeeId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>() //empty first
                    if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
                    {
                        let ps:OrderDetailsObj = OrderDetailsObj()

                        ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    }
                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {

                        let REZULTATE:NSArray = RESPONSEOBJECT["Result"] as! NSArray
                        let newarray:NSMutableArray = REZULTATE.mutableCopy() as! NSMutableArray

                        //                for item in REZULTATE {
                        //                    let d:NSDictionary = item as! NSDictionary
                        //                    //\\print ("AM GASIT \(d.description)")
                        //                }
                        self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
                        //MYordersOfClientsArray

                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            })
        }
    }

    //    func GetCustomersOrdersForSupplier()
    //    {
    //
    //
    //
    //        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
    //        //empty first
    //
    //        //JMODE in order to get customer's appoinments for current provider and not all of them
    //        var providerID:Int = 0
    //        if Global.sharedInstance.providerID == 0 {
    //            providerID = 0
    //            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
    //                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
    //                //  Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
    //            }
    //        } else {
    //            providerID = Global.sharedInstance.providerID
    //        }
    //        //we take data for 3 months
    //
    //        if iFilterByMonth - 1 >= 0 {
    //            iFilterByMonth = iFilterByMonth - 1
    //           // iFilterByYear = year
    //        } else if iFilterByMonth - 1 == 0 {
    //            iFilterByMonth = 12
    //            iFilterByYear = iFilterByYear - 1
    //        } else {
    //            iFilterByMonth = 12 - 1 - iFilterByMonth
    //            iFilterByYear = iFilterByYear - 1
    //        }
    //        if iFilterByMonth + 1 <= 12 {
    //            iFilterByMonthEnd = iFilterByMonth + 2
    //            iFilterByYearEnd = iFilterByYear
    //        } else if iFilterByMonth + 1 > 12 {
    //            iFilterByMonthEnd = 1
    //            iFilterByYearEnd = iFilterByYear + 1
    //        }
    //
    //
    //        dic["iFilterByMonth"] = iFilterByMonth
    //        dic["iFilterByYear"] = iFilterByYear
    //        //on two months here
    //        dic["iFilterByMonthEnd"] = iFilterByMonthEnd
    //        dic["iFilterByYearEnd"] = iFilterByYearEnd
    //        //\\print ("iFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd)")
    //        //        dic["iFilterByMonth"] = 0
    //        //        dic["iFilterByYear"] = 0
    //
    //          print("Global.sharedInstance.providerID  \(Global.sharedInstance.providerID) ")
    //        dic["iSupplierId"] = providerID

    //        if Reachability.isConnectedToNetwork() == false
    //        {

    //            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
    //        }
    //        else
    //        {
    //            api.sharedInstance.GetCustomersOrdersForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
    //                //GENERIC DATA IF YOU WANT TO HAVE A JSON AND METHOD DID NOT WORK api.sharedInstance.GetCustomersOrdersForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
    //                  //\\print(responseObject["Result"])
    //                var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>() //empty first
    //                if let _: Array<Dictionary<String, AnyObject>> = responseObject["Result"] as?  Array<Dictionary<String, AnyObject>>
    //                {
    //                    let ps:OrderDetailsObj = OrderDetailsObj()
    //
    //                    ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(responseObject["Result"] as! Array<Dictionary<String,AnyObject>>)
    //                }
    //                if let _ = responseObject["Result"] as? NSArray {
    //
    //                    let REZULTATE:NSArray = responseObject["Result"] as! NSArray
    //                    let newarray:NSMutableArray = REZULTATE.mutableCopy() as! NSMutableArray
    //
    //                    //                for item in REZULTATE {
    //                    //                    let d:NSDictionary = item as! NSDictionary
    //                    //                    //\\print ("AM GASIT \(d.description)")
    //                    //                }
    //                    self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
    //                    //MYordersOfClientsArray
    //
    //                }
    //
    //
    //
    //                //                return
    //
    //                },failure: {(AFHTTPRequestOperation, Error) -> Void in
    //                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
    //            })
    //        }
    //    }
    func generateMatrix(_ valinput:Int) -> Array<Int> {

        var column1:Array<Int> = []
        if !column1.contains(valinput) {
            column1.append(valinput)
        }
        var y:Int = 0
        y = valinput + 7
        if !column1.contains(y) {
            column1.append(y)
        }
        while y < 168 {
            y = y + 7
            if y < 168 {
                if (y - valinput ) % 7 == 0 {
                    if !column1.contains(y) {
                        column1.append(y)
                    }
                }
            }

        }


        //     print("first matrix fixed \(column1)")
        return column1
    }
    func findCustomer(_ iuseridcautat:Int) -> NSDictionary {
        var gasit:NSDictionary = NSDictionary()
        for item in self.myCustomersArray {
            if let _:NSDictionary = item as? NSDictionary {
                let d:NSDictionary = item as! NSDictionary
                if let x:Int = d.object(forKey: "iCustomerUserId") as? Int{
                    if x == iuseridcautat {
                        gasit = d
                    }
                }
            }
        }
        //    print("gasit \(gasit.description)")
        return gasit
    }

    func initEvents()
    {
        Global.sharedInstance.setAllEventsArray()

        dicArrayEventsToShow.removeAll()

        dicBthereEvent.removeAll()
        dicArrayEventsToShow = Dictionary<String,Array<allKindEventsForListDesign>>()

        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"

        Global.sharedInstance.getEventsFromMyCalendar()

        //------------------אתחול המערכים להצגת הארועים בצורה ממויינת------------------------
        let dateToday = Date()


        //עובר על הארועים מהמכשיר
        for event in Global.sharedInstance.arrEvents
        {
            let dateEvent = event.startDate
            let calendar:Foundation.Calendar = Foundation.Calendar.current
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateEvent!)
            yearEvent =  componentsEvent.year!
            monthEvent = componentsEvent.month!
            dayEvent = componentsEvent.day!


            if !event.isAllDay {
                let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: event.startDate)
                let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: event.endDate)

                let hourS = componentsStart.hour
                let minuteS = componentsStart.minute

                let hourE = componentsEnd.hour
                let minuteE = componentsEnd.minute

                var hourS_Show:String = hourS!.description
                var hourE_Show:String = hourE!.description
                var minuteS_Show:String = minuteS!.description
                var minuteE_Show:String = minuteE!.description

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
                    minuteS_Show = "0" + minuteS_Show
                }
                if minuteE! < 10
                {
                    minuteE_Show = "0" + minuteE_Show
                }


                //ליצור אובקט

                //בדיקה אם קיים כזה קי(תאריך)
                var ARRAYiProviderUserId:Array<Int> = []
                var objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
                let eventPhone:allKindEventsForListDesign = allKindEventsForListDesign(
                    _dateEvent: event.startDate,
                    _title: event.title,
                    _fromHour: "\(hourS_Show):\(minuteS_Show)",
                    _toHour: "\(hourE_Show):\(minuteE_Show)",
                    _tag: 2,
                    _nvAddress: "",
                    _nvSupplierName: "",
                    _iDayInWeek: -1,
                    _nvServiceName: "",
                    _nvComment: "",
                    _iProviderUserId: 0,
                    _iUserId: 0,
                    _ClientnvFullName: "",
                    _iCoordinatedServiceId: 0,
                    _iCancelallCoordinatedServiceIds:[],
                    _iCancelalliUserId: [],
                    _isCancelGroup: false,
                    _specialDate: "",
                    _ARRAYiProviderUserId:ARRAYiProviderUserId,
                    _objProviderServiceDetails:objProviderServiceDetails,
                    _nvLogo: "",
                    _chServiceColor: "",
                    _viewsforweek: [],
                    _iCoordinatedServiceStatusType:  0,
                    _nvPhone: "",
                    _iSupplierId: 0
                )

                if dicArrayEventsToShow[dateFormatter.string(from: event.startDate)] != nil
                {
                    if yearEvent == yearToday && monthEvent == monthToday                 {

                        dicArrayEventsToShow[dateFormatter.string(from: event.startDate)]?.append(eventPhone)
                        hasEvent = true
                    }
                }
                else
                {

                    dicArrayEventsToShow[dateFormatter.string(from: event.startDate)] = Array<allKindEventsForListDesign>()
                    dicArrayEventsToShow[dateFormatter.string(from: event.startDate)]?.append(eventPhone)
                }
            }
        }

        //עובר על הארועים של ביזר
        // for eventBthere in Global.sharedInstance.ordersOfClientsArray

        if BlockHouresObjArray.count > 0 {
            for event in BlockHouresObjArray {
                /*
                 var iProviderUserId:Int = 0
                 var dDate:Date = Date()
                 var cDate:String = "'"
                 var iServiceProviderCalendarId:Int = 0
                 var tFromHoure:String = ""
                 var tToHoure:String = ""
                 */

                var blockeddate = Global.sharedInstance.getStringFromDateString(event.cDate)
                let mycorrecteddate = Global.sharedInstance.convertNSDateToStringMore(blockeddate)
                blockeddate =  Global.sharedInstance.getStringFromDateString(mycorrecteddate)
                let dateEvent = blockeddate
                let calendar:Foundation.Calendar = Foundation.Calendar.current
                let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateEvent)
                yearEvent =  componentsEvent.year!
                monthEvent = componentsEvent.month!
                dayEvent = componentsEvent.day!
                let myComponents = (calendar as NSCalendar).components(.weekday, from: dateEvent)
                let weekDay = myComponents.weekday
                var hourS = ""
                var minuteS = ""
                var hourE = ""
                var minuteE = ""

                let componentsStart = event.tFromHoure
                let componentsEnd = event.tToHoure
                let fullhstartArr = componentsStart.components(separatedBy: ":")
                if fullhstartArr.count == 2 {
                    hourS = fullhstartArr[0]
                    minuteS = fullhstartArr[1]
                }
                let fullhendArr = componentsEnd.components(separatedBy: ":")
                if fullhendArr.count == 2 {
                    hourE = fullhendArr[0]
                    minuteE = fullhendArr[1]
                }


                let hourS_Show:String = hourS
                let hourE_Show:String = hourE
                let minuteS_Show:String = minuteS
                let minuteE_Show:String = minuteE
                //
                //                if  Int(hourS)! < 10
                //                {
                //                    hourS_Show = "0" + hourS_Show
                //                }
                //                if Int(hourE)! < 10
                //                {
                //                    hourE_Show = "0" + hourE_Show
                //                }
                //                if Int(minuteS)! < 10
                //                {
                //                    minuteS_Show = "0" +   minuteS_Show
                //                }
                //                if Int(minuteE)! < 10
                //                {
                //                    minuteE_Show = "0" + minuteE_Show
                //                }
                //

                //ליצור אובקט
                //בדיקה אם קיים כזה קי(תאריך)
                let ARRAYiProviderUserId:Array<Int> = []
                let objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
                let eventblock:allKindEventsForListDesign = allKindEventsForListDesign(
                    _dateEvent: dateEvent,
                    _title: "BlockedBySupplier",
                    _fromHour: "\(hourS_Show):\(minuteS_Show)",
                    _toHour: "\(hourE_Show):\(minuteE_Show)",
                    _tag: 1,
                    _nvAddress: "",
                    _nvSupplierName: "",
                    _iDayInWeek: weekDay!,
                    _nvServiceName: "",
                    _nvComment: "BlockedBySupplier",
                    _iProviderUserId: event.iProviderUserId,
                    _iUserId: 0,
                    _ClientnvFullName: "",
                    _iCoordinatedServiceId: event.iServiceProviderCalendarId,
                    _iCancelallCoordinatedServiceIds:[],
                    _iCancelalliUserId: [],
                    _isCancelGroup: false,
                    _specialDate: "",
                    _ARRAYiProviderUserId : ARRAYiProviderUserId,
                    _objProviderServiceDetails:objProviderServiceDetails,
                    _nvLogo: "",
                    _chServiceColor: "F74B57",
                    _viewsforweek: [],
                    _iCoordinatedServiceStatusType: 1,
                    _nvPhone: "",
                    _iSupplierId: 0
                )

                if dicBthereEvent[dateFormatter.string(from: dateEvent)] != nil
                {
                    //                    if yearEvent == yearToday && monthEvent == monthToday
                    //                        //&& dayEvent == dayToday
                    //                    {

                    dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventblock)
                    //   }
                }
                else
                {

                    dicBthereEvent[dateFormatter.string(from: dateEvent)] = Array<allKindEventsForListDesign>()
                    dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventblock)
                }

                if dicArrayEventsToShow[dateFormatter.string(from: dateEvent)] != nil
                {
                    //             if yearEvent == yearToday && monthEvent == monthToday
                    //&& dayEvent == dayToday
                    //    {

                    dicArrayEventsToShow[dateFormatter.string(from: dateEvent)]?.append(eventblock)
                    //          }
                }
                else
                {
                    dicArrayEventsToShow[dateFormatter.string(from: dateEvent)] = Array<allKindEventsForListDesign>()
                    dicArrayEventsToShow[dateFormatter.string(from: dateEvent)]?.append(eventblock)
                }

            }
        }
        for item in self.myArray

        {
            var dateEvent:Date = Date()
            var hourStart = Date()
            var hourEnd = Date()
            if let _:NSDictionary = item as? NSDictionary {
                let eventBthere:NSDictionary = item as! NSDictionary
                print("test event \(eventBthere.description)")

                // let dateEvent = eventBthere.dtDateOrder
                if let ORDERDATE:String =  eventBthere.object(forKey: "dtDateOrder") as? String
                {
                    dateEvent = Global.sharedInstance.getStringFromDateString(ORDERDATE)
                    print("STRdtDateOrder\(dateEvent)")
                }
                //                if let _:NSDate = eventBthere.objectForKey("dtDateOrder") as? NSDate {
                //                 dateEvent = eventBthere.objectForKey("dtDateOrder") as! NSDate
                //                }
                let calendar:Foundation.Calendar = Foundation.Calendar.current
                let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateEvent)

                yearEvent =  componentsEvent.year!
                monthEvent = componentsEvent.month!
                dayEvent = componentsEvent.day!

                //אם בטווח של 5 חודשים מהיום

                if let asistart:String = eventBthere.object(forKey: "nvFromHour") as? String {
                    hourStart = Global.sharedInstance.getStringFromDateString(asistart)
                    print("getDateFromString nvFromHour \(getDateFromString(asistart))")
                }
                if let asiend:String = eventBthere.object(forKey: "nvToHour") as? String {
                    hourEnd = Global.sharedInstance.getStringFromDateString(asiend)
                    print("getDateFromString nvToHour \(getDateFromString(asiend))")
                }

                let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: hourStart)
                let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: hourEnd)

                let hourS = componentsStart.hour
                let minuteS = componentsStart.minute

                let hourE = componentsEnd.hour
                let minuteE = componentsEnd.minute

                var hourS_Show:String = hourS!.description
                var hourE_Show:String = hourE!.description
                var minuteS_Show:String = minuteS!.description
                var minuteE_Show:String = minuteE!.description

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
                var chServiceColor:String = ""


                var serviceName = ""
                if let myarrservices:NSArray =  eventBthere.object(forKey: "objProviderServiceDetails") as? NSArray {
                    for item in myarrservices {
                        if let servicedict:NSDictionary = item as? NSDictionary {
                            if serviceName == ""
                            {
                                if let _:String  = servicedict.object(forKey: "nvServiceName") as? String {
                                    serviceName = servicedict.object(forKey: "nvServiceName") as! String
                                }
                            } else {
                                serviceName = "\(serviceName),\(servicedict.object(forKey: "nvServiceName") as! String)"
                            }


                        }
                    }
                }

                var nvServiceName = ""
                if let myarrservices:NSArray =  eventBthere.object(forKey: "objProviderServiceDetails") as? NSArray {
                    for item in myarrservices {
                        if let servicedict:NSDictionary = item as? NSDictionary {
                            if nvServiceName == ""
                            {
                                if let _:String  = servicedict.object(forKey: "nvServiceName") as? String {
                                    nvServiceName = servicedict.object(forKey: "nvServiceName") as! String
                                }
                            }else {
                                nvServiceName = "\(nvServiceName),\(servicedict.object(forKey: "nvServiceName") as! String)"
                            }

                        }
                    }
                }

                if let myarrservices:NSArray =  eventBthere.object(forKey: "objProviderServiceDetails") as? NSArray {
                    for item in myarrservices {
                        if let servicedict:NSDictionary = item as? NSDictionary {
                            if let _:String  = servicedict.object(forKey: "chServiceColor") as? String {
                                chServiceColor = servicedict.object(forKey: "chServiceColor") as! String
                                break
                            }

                        }
                    }
                }



                var anyhow = 0
                if let xor:Int =  eventBthere.object(forKey: "iUserId") as? Int {
                    anyhow = xor
                }
                //                var ClientnvFullName:String = ""
                //                var emi:NSDictionary = NSDictionary()
                //                if self.findCustomer(anyhow) != NSDictionary() {
                //                    emi = self.findCustomer(anyhow)
                //                    if let _:String = emi.object(forKey: "nvFullName") as? String{
                //                        ClientnvFullName = emi.object(forKey: "nvFullName") as! String
                //                    }
                //                }
                var ClientnvFullName:String = ""
                var nvFirstName = ""
                var nvLastName = ""
                if let _:String = eventBthere.object(forKey: "nvFirstName") as? String{
                    nvFirstName = eventBthere.object(forKey: "nvFirstName") as! String
                }
                if let _:String = eventBthere.object(forKey: "nvLastName") as? String{
                    nvLastName = eventBthere.object(forKey: "nvLastName") as! String
                }
                ClientnvFullName = nvFirstName + " " + nvLastName
                var nvAddress:String = ""
                var nvSupplierName:String = ""
                var nvComment:String = ""

                if let _:String = eventBthere.object(forKey: "nvAddress") as? String{
                    nvAddress = eventBthere.object(forKey: "nvAddress") as! String
                }
                if let _:String = eventBthere.object(forKey: "nvSupplierName") as? String{
                    nvSupplierName = eventBthere.object(forKey: "nvSupplierName") as! String
                }
                if let _:String = eventBthere.object(forKey: "nvComment") as? String{
                    nvComment = eventBthere.object(forKey: "nvComment") as! String
                }

                var iDayInWeek:Int = 0
                if let _:Int = eventBthere.object(forKey: "iDayInWeek") as? Int{
                    iDayInWeek = eventBthere.object(forKey: "iDayInWeek") as! Int
                }
                var iProviderUserId:Int = 0
                if let _:Int = eventBthere.object(forKey: "iProviderUserId") as? Int{
                    iProviderUserId = eventBthere.object(forKey: "iProviderUserId") as! Int
                }
                var iUserId:Int = 0
                if let _:Int = eventBthere.object(forKey: "iUserId") as? Int{
                    iUserId = eventBthere.object(forKey: "iUserId") as! Int
                }
                var iCoordinatedServiceId:Int = 0
                if let _:Int = eventBthere.object(forKey: "iCoordinatedServiceId") as? Int{
                    iCoordinatedServiceId = eventBthere.object(forKey: "iCoordinatedServiceId") as! Int
                }
                var ARRAYiProviderUserId:Array<Int> = []
                var objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
                var nvPhone:String = ""
                if let _:String = eventBthere.object(forKey: "nvPhone") as? String{
                    nvPhone = eventBthere.object(forKey: "nvPhone") as! String
                }
                var iSupplierId:Int = 0
                if let _:Int = eventBthere.object(forKey: "iSupplierId") as? Int{
                    iSupplierId = eventBthere.object(forKey: "iSupplierId") as! Int
                }
                let eventBtheree:allKindEventsForListDesign = allKindEventsForListDesign(
                    _dateEvent: dateEvent,
                    ///// _title: "\(nvServiceName),\(eventBthere.nvSupplierName)",
                    _title: "\(nvServiceName)",
                    _fromHour: "\(hourS_Show):\(minuteS_Show)",
                    _toHour: "\(hourE_Show):\(minuteE_Show)",
                    _tag: 1,
                    _nvAddress: nvAddress,
                    _nvSupplierName: nvSupplierName,
                    _iDayInWeek: iDayInWeek,
                    _nvServiceName: serviceName,
                    _nvComment: nvComment,
                    _iProviderUserId: iProviderUserId,
                    _iUserId: iUserId,
                    _ClientnvFullName: ClientnvFullName,
                    _iCoordinatedServiceId: iCoordinatedServiceId,
                    _iCancelallCoordinatedServiceIds:[],
                    _iCancelalliUserId: [],
                    _isCancelGroup: false,
                    _specialDate: "",
                    _ARRAYiProviderUserId:ARRAYiProviderUserId,
                    _objProviderServiceDetails:objProviderServiceDetails,
                    _nvLogo: "",
                    _chServiceColor: chServiceColor,
                    _viewsforweek: [],
                    _iCoordinatedServiceStatusType:  0,
                    _nvPhone: nvPhone,
                    _iSupplierId: iSupplierId
                )

                //\\print( "eventBthere.iProviderUserId \(iProviderUserId)  _iUserId: \(iUserId) si string start \(hourStart) si string end \(hourEnd)")
                //\\print( "yearToday \(yearToday)  monthToday \(monthToday) si dayToday \(dayToday) ")
                if dicBthereEvent[dateFormatter.string(from: dateEvent)] != nil
                {
                    //    if yearEvent == yearToday && monthEvent == monthToday
                    //&& dayEvent == dayToday
                    //   {

                    dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                    //   }
                }
                else
                {

                    dicBthereEvent[dateFormatter.string(from: dateEvent)] = Array<allKindEventsForListDesign>()
                    dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                }

                if dicArrayEventsToShow[dateFormatter.string(from: dateEvent)] != nil
                {
                    //   if yearEvent == yearToday && monthEvent == monthToday
                    //&& dayEvent == dayToday
                    //    {

                    dicArrayEventsToShow[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                    //   }
                }
                else
                {
                    dicArrayEventsToShow[dateFormatter.string(from: dateEvent)] = Array<allKindEventsForListDesign>()
                    dicArrayEventsToShow[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                }



            }


        }
        sortDicEvents = [(String,Array<allKindEventsForListDesign>)]()
        sortDicEvents = dicArrayEventsToShow.sorted{ dateFormatter.date(from: $0.0)!.compare(dateFormatter.date(from: $1.0)!) == .orderedAscending}

        sortDicBTHEREevent = [(String,Array<allKindEventsForListDesign>)]()
        sortDicBTHEREevent = dicBthereEvent.sorted{ dateFormatter.date(from: $0.0)!.compare(dateFormatter.date(from: $1.0)!) == .orderedAscending}

        var i = 0
        for event in sortDicEvents
        {
            sortDicEvents[i].1.sort(by: { $0.dateEvent.compare($1.dateEvent as Date) == ComparisonResult.orderedAscending })

            i += 1
        }

        i = 0
        for event in sortDicBTHEREevent
        {
            sortDicBTHEREevent[i].1.sort(by: { $0.dateEvent.compare($1.dateEvent as Date) == ComparisonResult.orderedAscending })

            i += 1
        }

        getEventsArray(currentDate)
    }
    func hidetoast(){
        view.hideToastActivity()
    }


    func processMYARRAY (_ mycustomerorder: NSMutableArray , globalcustarray: Array<OrderDetailsObj>) {
        myArray = []
        let deadaugat:NSMutableArray = mycustomerorder
        for item in deadaugat {
            if !self.myArray.contains(item) {
                if let a:NSDictionary = item as? NSDictionary {
                    let b:NSDictionary = a
                    if let _:String = b["nvComment"] as? String {
                        let d:String = b["nvComment"] as! String
                        if d   == "BlockedBySupplier" {
                            //nothing
                        } else {

                            self.myArray.add(item)
                        }
                    }
                }
            }
        }
        var onearray:Array<OrderDetailsObj> = Array<OrderDetailsObj>()
        for item in globalcustarray {
            print("ceuserid \(item.iUserId)")
            if !onearray.contains(item) {
                if  item.nvComment  == "BlockedBySupplier" {
                    item.title = "BlockedBySupplier"
                }
                else {
                    onearray.append(item)
                }
            }
        }

        Global.sharedInstance.ordersOfClientsArray = []
        Global.sharedInstance.ordersOfClientsArray = onearray
        //        Global.sharedInstance.ordersOfClientsArray = []
        //        let globaldeadaugat: Array<OrderDetailsObj> = globalcustarray
        print("self.myArray.count FIRST\(self.myArray.count) ordersOfClientsArray \(onearray.count) ")
        if self.myArray.count == 0 {
            //  Alert.sharedInstance.showAlert("NO_APPOINMENTS_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            self.view.makeToast(message: "NO_APPOINMENTS_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })

        } else {

            print("ok appoi")
        }
        //\\ getCustomers()
        self.getServicesProviderForSupplierfunc()

    }
    func getCustomers()
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        // dic["iSupplierId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                //  Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        dic["iSupplierId"] = providerID as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomersBySupplierId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            print("eroare la getCustomers \(RESPONSEOBJECT["Error"])")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                self.generic.hideNativeActivityIndicator(self)
                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                        }
                        else
                        {
                            self.myCustomersArray = []
                            //client list comes here
                            //\\       print("ce astepta \(responseObject["Result"])")
                            //array (
                            if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
                            {

                                var ARRAYDELUCRU : Array<Dictionary<String, AnyObject>> = (RESPONSEOBJECT["Result"] as! Array<Dictionary<String, AnyObject>>)
                                //\\     print("ARRAYDELUCRU \(ARRAYDELUCRU)")
                                for item in ARRAYDELUCRU {
                                    let d:NSDictionary = (item as NSDictionary) as NSDictionary
                                    var MYmutableDictionary:NSMutableDictionary = [:]

                                    var STRbIsVip:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "bIsVip") as? Int
                                    {
                                        STRbIsVip = somethingelse
                                    } else if let somethingelse:Bool =  d.object(forKey: "bIsVip") as? Bool {

                                        if somethingelse == true {
                                            STRbIsVip = 1
                                        }
                                    }
                                    //   print("STRbIsVip \(STRbIsVip)")
                                    var STRiCustomerUserId:String = ""
                                    if let somethingelse2:Int =  d.object(forKey: "iCustomerUserId") as? Int
                                    {
                                        STRiCustomerUserId = String(somethingelse2)
                                    }
                                    //   print("STRiCustomerUserId \(STRiCustomerUserId)")
                                    var STRinvFirstName:String = ""
                                    if let somethingelse3 =  d.object(forKey: "nvFirstName") as? String
                                    {
                                        STRinvFirstName = somethingelse3
                                    }

                                    var STRnvLastName:String = ""
                                    if let somethingelse4 =  d.object(forKey: "nvLastName") as? String
                                    {
                                        STRnvLastName = somethingelse4
                                    }
                                    let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName

                                    var STRnvMail:String = ""
                                    if let somethingelse5 =  d.object(forKey: "nvMail") as? String
                                    {
                                        STRnvMail = somethingelse5
                                    }

                                    var STRnvPhone:String = ""
                                    if let somethingelse6 =  d.object(forKey: "nvPhone") as? String
                                    {
                                        STRnvPhone = somethingelse6
                                    }
                                    var STRnvImage:String = ""

                                    if let somethingelse =  d.object(forKey: "nvImage") as? String
                                    {
                                        STRnvImage = somethingelse
                                    }
                                    else
                                    {
                                        STRnvImage = ""
                                    }
                                    var STRnvSupplierNotes = ""
                                    if let nvSupplierRemark:String = d.object(forKey: "nvSupplierRemark") as? String {
                                        //\\print ("nvSupplierRemark \(nvSupplierRemark)")
                                        if(nvSupplierRemark.characters.count > 0) {
                                            STRnvSupplierNotes = nvSupplierRemark
                                        } else {
                                            STRnvSupplierNotes = ""
                                        }
                                    }
                                    //\\print ("STRnvSupplierNotes \(STRnvSupplierNotes)")
                                    var STRdBirthdate:Date = Date()

                                    if let somethingelse =  d.object(forKey: "dBirthdate") as? String
                                    {
                                        //  STRdBirthdate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 3, toDate: somethingelse
                                        //       , options: [])!
                                        STRdBirthdate = Global.sharedInstance.getStringFromDateString(somethingelse)
                                        //    print("STRdBirthdate\(STRdBirthdate)")
                                    } else {

                                        //  print("no birthdate")
                                        let dateString = "01/01/1901" // change to your date format
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat =  "dd/MM/yyyy"
                                        STRdBirthdate = dateFormatter.date(from: dateString)!

                                    }

                                    var INTiCustomerUserId:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "iCustomerUserId") as? Int
                                    {
                                        INTiCustomerUserId = somethingelse
                                    }
                                    var nvNickName:String = ""
                                    if let cnvNickName = d.object(forKey: "nvNickName") as? String {
                                        nvNickName = cnvNickName
                                    }
                                    MYmutableDictionary["bIsVip"] = STRbIsVip
                                    MYmutableDictionary["nvFirstName"] = STRinvFirstName
                                    MYmutableDictionary["nvLastName"] = STRnvLastName
                                    MYmutableDictionary["nvFullName"] = STRnvFullName
                                    MYmutableDictionary["nvMail"] = STRnvMail
                                    MYmutableDictionary["nvPhone"] = STRnvPhone
                                    MYmutableDictionary["nvImage"] = STRnvImage
                                    MYmutableDictionary["nvSupplierRemark"] = STRnvSupplierNotes
                                    MYmutableDictionary["dBirthdate"] = STRdBirthdate
                                    MYmutableDictionary["iCustomerUserId"] = INTiCustomerUserId
                                    MYmutableDictionary["nvNickName"] = nvNickName
                                    if !self.myCustomersArray.contains(MYmutableDictionary) {
                                        self.myCustomersArray.add(MYmutableDictionary)
                                    }
                                }
                                //\\    print("myCustomersArray \(self.myCustomersArray) si count \(self.myCustomersArray.count)  " )
                                //  self.myArray = ARRAYDELUCRU as! NSMutableArray
                                Global.sharedInstance.nameCostumersArray = []
                                Global.sharedInstance.searchCostumersArray = []
                                Global.sharedInstance.nameCostumersArray = self.myCustomersArray
                                Global.sharedInstance.searchCostumersArray = self.myCustomersArray
                                Global.sharedInstance.ISSEARCHINGCUSTOMER = false
                            }
                        }
                    }

                }

                self.generic.hideNativeActivityIndicator(self)
                DispatchQueue.main.async(execute: { () -> Void in

                    self.getServicesProviderForSupplierfunc()

                })
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }

    }
    func numberOfItems(in carousel: iCarousel) -> Int {
        print("self.arrayWorkers.count \(self.arrayWorkers.count)")
        if self.arrayWorkers.count > 0 {
            if self.arrayWorkers.count > 1 {
                self.carousel.type = .linear
            } else {
                self.carousel.type = .linear
                //  self.carousel.scrollEnabled = false
                self.carousel.isUserInteractionEnabled = false
            }
        }

        return self.arrayWorkers.count
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {

        let  index:Int = carousel.currentItemIndex
        // if index > 0 {
        var workerid:Int = 0
        if  self.arrayWorkers.count > 0 {
            if let _:User = self.arrayWorkers[index] as? User {
                let MYD:User = self.arrayWorkers[index] as! User

                if let _:Int =  MYD.iUserId
                {
                    workerid =  MYD.iUserId
                    Global.sharedInstance.defaults.set(workerid, forKey: "idSupplierWorker")
                    Global.sharedInstance.defaults.synchronize()
                }

                print("workerid \(workerid) si \(index)")
                self.selectedWorker = true
                self.selectedWorkerID = index


                self.setEventsArrayx()

            }
        }
        if self.arrayWorkers.count > 1 {
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
                        //     labelView.minimumScaleFactor = 0.5
                        //    labelView.adjustsFontSizeToFitWidth = true
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

        /// setEventBthereInMonth()

    }



    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView

        //reuse view if available, otherwise create a new view

        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
            if self.arrayWorkers.count > 1 {
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
            //\\    itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 2.4 , height: 55))
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.carousel.frame.size.width / 2.4  , height: 55))
            itemView.image = UIImage(named: "")
            itemView.contentMode = .scaleAspectFill
            itemView.backgroundColor = UIColor.clear
            //            if self.arrayWorkers.count > 1 {
            //            label = UILabel(frame: CGRect(x: itemView.frame.origin.x + 30, y: itemView.frame.origin.y + 1, width:itemView.frame.size.width, height: itemView.frame.size.height - 6))
            //            }
            //            else {
            label = UILabel(frame: CGRect(x: itemView.frame.origin.x , y: itemView.frame.origin.y + 1, width:itemView.frame.size.width, height: itemView.frame.size.height - 6))
            // }
            label.backgroundColor = UIColor.clear
            label.textAlignment = .left
            //   label.font = label.font.fontWithSize(18)
            //            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 18)
            //            label.font = labelFont

            label.numberOfLines = 1
            label.textAlignment = .center
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

            itemView.addSubview(label)
            //            if self.arrayWorkers.count > 1 {
            //                itemView.addSubview(mybluecircle)
            //                itemView.bringSubviewToFront(mybluecircle)
            //            }
        }

        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        //    if index > 0 {
        if let _:User = self.arrayWorkers[index] as? User {
            let MYD:User = self.arrayWorkers[index] as! User
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
        if self.arrayWorkers.count > 1 {
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



    func getServicesProviderForSupplierfunc()
    {
        Global.sharedInstance.giveServiceName = ""
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.providerID == 0 {
            dicSearch["iProviderId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            }
        } else {
            dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }

        var arrUsers:Array<User> = Array<User>()
        let temparrayWorkers:  NSMutableArray = []
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.getServicesProviderForSupplierfunc(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            self.showAlertDelegateX("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            let u:User = User()
                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                arrUsers = u.usersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            }
                            Global.sharedInstance.giveServicesArray = arrUsers

                            Global.sharedInstance.arrayGiveServicesKods = []
                            for  item in arrUsers{
                                Global.sharedInstance.arrayGiveServicesKods.append(item.iUserId)//אחסון הקודים של נותני השרות לצורך השליחה לשרת כדי לקבל את השעות הפנויות
                            }
                            Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
                            Global.sharedInstance.dicGetFreeDaysForServiceProvider["lServiseProviderId"] = Global.sharedInstance.arrayGiveServicesKods as AnyObject
                            //JMODE todo
                            if arrUsers.count == 0
                            {
                                Global.sharedInstance.CurrentProviderArrayWorkers = []
                                self.showAlertDelegateX("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                self.processworkers(temparrayWorkers)
                            }
                            else
                            {
                                Global.sharedInstance.CurrentProviderArrayWorkers = []
                                for u:User in arrUsers
                                {
                                    if  self.EMPLOYEISMANAGER == true {
                                        api.sharedInstance.PREETYJSON_J(u.getDic(), pathofweb: "worker details")
                                        temparrayWorkers.add(u)

                                    }
                                }
                                for u:User in arrUsers
                                {

                                    if  self.EMPLOYEISMANAGER == false {

                                        if u.iUserId == Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")  {

                                            temparrayWorkers.add(u)
                                        }
                                        print("u.iUserId \(u.iUserId) Global idSupplierWorker \(Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") )")
                                    }
                                }

                                self.processworkers(temparrayWorkers)
                            }

                        }

                    }
                }


            },failure: {(AFHTTPRequestOperation, Error) -> Void in

                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }

    }
    @objc func refreshTable(_ sender:AnyObject) {
        // Code to refresh table view
        print("merge")
        // GetCustomersOrdersByDateForSupplier()
        if self.EMPLOYEISMANAGER == true {
            GetCustomersOrdersByDateForSupplier()
        } else {
            //is employe non manager
            GetCustomersOrdersByDateForEmployeeId()
        }

    }
    func processworkers (_ myWorkers: NSMutableArray) {
        self.arrayWorkers = myWorkers
        Global.sharedInstance.CurrentProviderArrayWorkers = self.arrayWorkers
        print("Global.sharedInstance.CurrentProviderArrayWorkers \(Global.sharedInstance.CurrentProviderArrayWorkers)")
        //        refreshControl.endRefreshing()
        if self.arrayWorkers.count > 0 {
            if self.arrayWorkers.count > 1 {
                self.carousel.type = .linear
            } else {
                self.carousel.type = .linear
                //  self.carousel.scrollEnabled = false
                self.carousel.isUserInteractionEnabled = false
            }
        }
        tryGetSupplierCustomerUserIdByEmployeeId()


    }



    //magic thing filter mass array
    func bestmode(){
        //  let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        //   appDelegate.setHELPSCREENS()
        //   self.LOADHELPERS()
        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 {
            self.EMPLOYEISMANAGER = false
        } else {
            self.EMPLOYEISMANAGER = true
        }
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        refreshControl.addTarget(self, action: #selector(WeekDesignSupplierViewController.refreshTable(_:)), for: UIControl.Event.valueChanged)
        self.collWeek.addSubview(refreshControl)

        //    idWorker =  Global.sharedInstance.idSupplierWorker
        //        if Global.sharedInstance.rtl
        //        {
        //            arrowleft.image =    UIImage(named: "sageata1.png")
        //            arrowright.image =    UIImage(named: "sageata2.png")
        //        }
        //        else
        //   {
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
        //    }

        /////////////\\\\\\\\\
        imgCurrentDay.isHidden = true
        hasEvent = false
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        //        if Global.sharedInstance.rtl {
        //            collWeek.transform = scalingTransform
        //        }

        monthArray = []

        Global.sharedInstance.getEventsFromMyCalendar()

        if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
        {
            btnSyncWithGoogelSupplier.isCecked = true
        }

        var dateFormatterw = DateFormatter()
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatterw = DateFormatter()
            dateFormatterw.locale = Locale(identifier: "he_IL")

        } else {
            dateFormatterw = DateFormatter()
            dateFormatterw.locale = Locale(identifier: "en_US")


        }
        lblDayOfWeek1.text = dateFormatterw.veryShortWeekdaySymbols[6]
        lblDayOfWeek2.text = dateFormatterw.veryShortWeekdaySymbols[5]
        lblDayOfWeek3.text = dateFormatterw.veryShortWeekdaySymbols[4]
        lblDayOfWeek4.text = dateFormatterw.veryShortWeekdaySymbols[3]
        lblDayOfWeek5.text = dateFormatterw.veryShortWeekdaySymbols[2]
        lblDayOfWeek6.text = dateFormatterw.veryShortWeekdaySymbols[1]
        lblDayOfWeek7.text = dateFormatterw.veryShortWeekdaySymbols[0]


        hasEvent = false


        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        var isFindToday:Bool = false
        print("datesInWeekArray \(datesInWeekArray)")
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        dtDateStart = datesInWeekArraysorted[0]
        dtDateEnd = datesInWeekArraysorted[6]
        print("bestmode datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
        for item in datesInWeekArray
        {
            let otherDay: DateComponents = (Foundation.Calendar.current as NSCalendar).components([.era, .year, .month, .day], from: item)


            let today: DateComponents = (Foundation.Calendar.current as NSCalendar).components([.era, .year, .month, .day], from: Date())
            print("si item \(otherDay.day)")
            print("today === \(today.day)")
            if today.day == otherDay.day && today.month == otherDay.month && today.year == otherDay.year
            {
                isFindToday = true
            }

        }

        if isFindToday
        {
            imgCurrentDay.isHidden = false
            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(Date())!
            print("dayofww \(dayOfWeekToday)")
            UIView.animate(withDuration: 1, animations: {
                self.ingTrailing.constant = /* self.ingTrailing.constant +*/ ((self.view.frame.width / 8) *
                    CGFloat(self.dayOfWeekToday))
            })
        }
        else{
            imgCurrentDay.isHidden = true
        }

        //      setEventsArray(currentDate)
        setDate()
        //   arrayDays = [Int(lblDay1.text!)!,Int(lblDay2.text!)!,Int(lblDay3.text!)!,Int(lblDay4.text!)!,Int(lblDay5.text!)!,Int(lblDay6.text!)!,Int(lblDay7.text!)!]
        arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]
        arrayButtons.append(btnDay1)
        arrayButtons.append(btnDay2)
        arrayButtons.append(btnDay3)
        arrayButtons.append(btnDay4)
        arrayButtons.append(btnDay5)
        arrayButtons.append(btnDay6)
        arrayButtons.append(btnDay7)


        arrayLabelsDayNum.append(lblDayOfWeek1)
        arrayLabelsDayNum.append(lblDayOfWeek2)
        arrayLabelsDayNum.append(lblDayOfWeek3)
        arrayLabelsDayNum.append(lblDayOfWeek4)
        arrayLabelsDayNum.append(lblDayOfWeek5)
        arrayLabelsDayNum.append(lblDayOfWeek6)
        arrayLabelsDayNum.append(lblDayOfWeek7)

        arrayLabelsdate.append(lblDay1)
        arrayLabelsdate.append(lblDay2)
        arrayLabelsdate.append(lblDay3)
        arrayLabelsdate.append(lblDay4)
        arrayLabelsdate.append(lblDay5)
        arrayLabelsdate.append(lblDay6)
        arrayLabelsdate.append(lblDay7)
        setDateEnablity()
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
        let USERDEF = Global.sharedInstance.defaults
        if let _:Int = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as? Int {
            let y = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as! Int
            if y == 0 {
                viewSync.isHidden = true
                btnSyncWithGoogelSupplier.isHidden = true
            } else if y == 1 {
                viewSync.isHidden = false
                btnSyncWithGoogelSupplier.isHidden = false
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true{
                    btnSyncWithGoogelSupplier.isCecked = true
                } else {
                    btnSyncWithGoogelSupplier.isCecked = false
                }
            }
        }
        /////\\\\\\
        //        if Global.sharedInstance.rtl
        //        {
        //            arrowleft.image =    UIImage(named: "sageata1.png")
        //            arrowright.image =    UIImage(named: "sageata2.png")
        //        }
        //        else
        //        {
        //            arrowleft.image =    UIImage(named: "sageata2.png")
        //            arrowright.image =    UIImage(named: "sageata1.png")
        //        }
        //
        //frombestback = true
        //        self.myArray = []
        //        Global.sharedInstance.ordersOfClientsArray = []

        //     let todaybe:NSDate = NSDate()
        //   idWorker =  Global.sharedInstance.idSupplierWorker
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let day = components.day
        let month = components.month
        let year = components.year
        print("best d m y \(day) \(month) \(year)")
        //today = Calendar.sharedInstance.carrentDate
        monthToday = month!
        yearToday = year!
        iFilterByMonth = month!
        iFilterByYear = year!
        iFilterByMonthEnd = month!
        iFilterByYearEnd = year!
        if self.EMPLOYEISMANAGER == true {
            GetCustomersOrdersByDateForSupplier()
        } else {
            //is employe non manager
            GetCustomersOrdersByDateForEmployeeId()
        }


        print(" week idSupplierWorker \( Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker"))")
        //GetCustomersOrdersForSupplier()
    }
    func TRYPDFJUSTNOW() {

        let render = UIPrintPageRenderer()
        var html = ""

        var adate:Date = Date()
        html = html + "<table style=\"width:100%; border-collapse: collapse;\">"
        let composeddatefinal =  self.lblDays.text!
        if CalendarMatrix.count > 0 {


            var newarraywithuniquevals:Array<allKindEventsForListDesign> = []

            for i:Int in column1  {
                let mainid:Int = column1.index(of: i)!
                if mainid == 0 && i <= 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
                else if 0 < mainid && i <= 160  {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }


                else if  0 < mainid && i > 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            for i:Int in column2  {
                let mainid:Int = column2.index(of: i)!
                if mainid == 0 && i <= 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
                else if 0 < mainid && i <= 160  {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }


                else if  0 < mainid && i > 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            for i:Int in column3  {
                let mainid:Int = column3.index(of: i)!
                if mainid == 0 && i <= 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
                else if 0 < mainid && i <= 160  {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }


                else if  0 < mainid && i > 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            for i:Int in column4  {
                let mainid:Int = column4.index(of: i)!
                if mainid == 0 && i <= 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
                else if 0 < mainid && i <= 160  {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }


                else if  0 < mainid && i > 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            for i:Int in column5  {
                let mainid:Int = column5.index(of: i)!
                if mainid == 0 && i <= 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
                else if 0 < mainid && i <= 160  {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }


                else if  0 < mainid && i > 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            for i:Int in column6  {
                let mainid:Int = column6.index(of: i)!
                if mainid == 0 && i <= 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
                else if 0 < mainid && i <= 160  {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }


                else if  0 < mainid && i > 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            for i:Int in column7  {
                let mainid:Int = column7.index(of: i)!
                if mainid == 0 && i <= 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
                else if 0 < mainid && i <= 160  {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }


                else if  0 < mainid && i > 160 {
                    if CalendarMatrix[i].2.count > 0 {
                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
                        myeventstoShow = self.CalendarMatrix[i].2
                        if myeventstoShow.count > 0 {

                            for item in myeventstoShow {
                                if item.iCoordinatedServiceId > 0 {
                                    if !newarraywithuniquevals.contains(item) {
                                        newarraywithuniquevals.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align: right; background-color: #f39371; color: #fff; width: 100%;\"> \(composeddatefinal)</td></tr>"


            if newarraywithuniquevals.count > 0 {
                print("newarraywithuniquevals \(newarraywithuniquevals.count)")
                for item in newarraywithuniquevals {
                    print("item date \(item.dateEvent)")
                    let calendarx = Foundation.Calendar.current
                    let componentsEvent = (calendarx as NSCalendar).components([.day , .month , .year], from: item.dateEvent as Date)
                    let yearEvent =  componentsEvent.year
                    let monthEvent = componentsEvent.month
                    var dateFormatterx = DateFormatter()
                    if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                        dateFormatterx.locale = Locale(identifier: "he_IL")
                    } else {
                        dateFormatterx.locale = Locale(identifier: "en_US")
                    }
                    let monthName = dateFormatterx.shortStandaloneMonthSymbols[monthEvent! - 1]
                    let dayEvent = componentsEvent.day
                    let dayEventtext = "\(dayEvent ?? dayToday)"
                    let yearEventtext = "\(yearEvent ?? yearToday)"
                    let str =   dayEventtext + " " + String(monthName) + " " + yearEventtext
                    let composeddatefinal =  str
                    let hhours =  "\(item.fromHour) - \(item.toHour)"
                    let clientname = item.ClientnvFullName
                    let servicename = item.title
                    let composedstring = clientname + " - " + servicename
                    html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; width: 100%; \"> \(composeddatefinal)" + "  \(hhours)</td></tr>"
                    html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; width: 100%;border-bottom: 1px solid black;\">    \(composedstring)</td></tr>"
                }
            }
            html = html + "</table>"


            print("myhtml \(html)")
            let fmt = UIMarkupTextPrintFormatter(markupText: html)

            render.addPrintFormatter(fmt, startingAtPageAt: 0)

            // 3. Assign paperRect and printableRect

            let page = CGRect(x: 0, y: 0, width: 612, height: 792) // some defaults
            let printable = page.insetBy(dx: 0, dy: 0)

            render.setValue(NSValue(cgRect: page), forKey: "paperRect")
            render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

            // 4. Create PDF context and draw
            //let pointzero = CGPoint(x: 0,y :0)
            let rect = CGRect.zero
            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

            for i in 0..<render.numberOfPages {
                UIGraphicsBeginPDFPage();
                render.drawPage( at: i, in: UIGraphicsGetPDFContextBounds())
            }

            UIGraphicsEndPDFContext();

            // 5. Save PDF file
            var Timestamp: String {
                return "\(Date().timeIntervalSince1970 * 1000)"
            }
            let uniquefilename =  randomStringWithLength(6)
            let onestring =  Timestamp.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
            let fileNAMEFINAL: String = onestring + (uniquefilename as String) + ".pdf"


            print("fileNAMEFINAL\(fileNAMEFINAL)")

            let documents = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let tempDocumentsDirectory: AnyObject = documents[0] as AnyObject
            let tempDataPath = (tempDocumentsDirectory as! NSString).appendingPathComponent(fileNAMEFINAL)
            pdfData.write( toFile: tempDataPath, atomically: true)
            print("open \(tempDataPath)")

            //            let uniquefilename =  randomStringWithLength(6)
            //            let onestring =  Timestamp.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            //            let fileNAMEFINAL: String = onestring + (uniquefilename as String) + ".pdf"
            //            // let path = "\(NSTemporaryDirectory())sd.pdf"
            //          //  let path = "\(NSTemporaryDirectory())\(fileNAMEFINAL)"
            //            var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
            //            let path = paths[0] + "\\(fileNAMEFINAL)"
            //
            //            print("fileNAMEFINAL\(fileNAMEFINAL)")
            //            pdfData.writeToFile( path, atomically: true)
            // print("open \(path)")

            //   let fullURL = NSURL.fileURLWithPathComponents([directory, fileName])
            if( MFMailComposeViewController.canSendMail() )
            {
                print("Can send email.")

                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self

                //Set to recipients
                mailComposer.setToRecipients(["your email address heres"])

                //Set the subject
                mailComposer.setSubject("My list from Bthere app")

                //set mail body
                mailComposer.setMessageBody("My list from Bthere app", isHTML: true)

                if let filePath:String = tempDataPath

                {
                    print("File path loaded.")

                    if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath))
                    {
                        print("File data loaded.")
                        mailComposer.addAttachmentData(fileData, mimeType: "application/pdf", fileName: fileNAMEFINAL)

                    }
                }

                //this will compose and present mail to user
                self.present(mailComposer, animated: true, completion: nil)
            }
            else
            {
                print("email is not supported")
            }
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func gethoursandminuteforevent (_ itemx: allKindEventsForListDesign) -> [Int] {
        var arrayints:[Int]  = []
        var eventHour:Int = 0
        var eventMinutes:Int = 0
        //        var eventSecondHour:Int = 0
        //        var eventSecondMinutes:Int = 0

        if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
            if a1 == "0" {
                //now get the real hour
                if let a2:Character =  itemx.fromHour[itemx.fromHour.characters.index(itemx.fromHour.startIndex, offsetBy: 1)]{
                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
                    if a2 == "0" {
                        //    print("ora1 0 add to 0")
                        eventHour = 0
                    }
                    else {
                        //     print("ora1 \(a2) add to \(a2)") //section
                        let str = String(a2)
                        let IntHOUR:Int = Int(str)!
                        eventHour = IntHOUR

                    }
                }
            }
            else { //full hour 2 chars
                let fullNameArr = itemx.fromHour.components(separatedBy: ":")
                let size = fullNameArr.count
                if(size > 1 ) {
                    if let _:String = fullNameArr[0]  {
                        let hourstring:String = fullNameArr[0]
                        let numberFromString:Int = Int(hourstring)!
                        eventHour = numberFromString
                    }
                }
            }
        }


        //minutes compare
        let fullNameArr = itemx.fromHour.components(separatedBy: ":")
        let size = fullNameArr.count
        if(size > 1 ) {
            if let _:String = fullNameArr[1]  {
                let hourstring:String = fullNameArr[1]
                if let a1:Character =  hourstring[hourstring.startIndex] {
                    if a1 == "0" {
                        //now get the real minute
                        if let a2:Character =  hourstring[hourstring.characters.index(hourstring.startIndex, offsetBy: 1)]{
                            if a2 == "0" {
                                //     print("minutul 0 add to 0")
                                eventMinutes = 0
                            }
                            else {
                                //     print("minutul \(a2) add to \(a2)") //section
                                let str = String(a2)
                                let IntHOUR:Int = Int(str)!
                                eventMinutes = IntHOUR

                            }
                        }
                    }
                    else { //full minutes 2 chars
                        let fullNameArr = itemx.fromHour.components(separatedBy: ":")
                        let size = fullNameArr.count
                        if(size > 1 ) {
                            if let _:String = fullNameArr[1]  {
                                let hourstring:String = fullNameArr[1]
                                let numberFromString:Int = Int(hourstring)!
                                eventMinutes = numberFromString
                            }
                        }
                    }
                }
            }
        }
        arrayints.append(eventHour)
        arrayints.append(eventMinutes)

        if let a1:Character =  itemx.toHour[itemx.toHour.startIndex] {
            if a1 == "0" {
                //now get the real hour
                if let a2:Character =  itemx.toHour[itemx.toHour.characters.index(itemx.toHour.startIndex, offsetBy: 1)]{
                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
                    if a2 == "0" {
                        //    print("ora1 0 add to 0")
                        eventHour = 0
                    }
                    else {
                        //     print("ora1 \(a2) add to \(a2)") //section
                        let str = String(a2)
                        let IntHOUR:Int = Int(str)!
                        eventHour = IntHOUR

                    }
                }
            }
            else { //full hour 2 chars
                let fullNameArr = itemx.toHour.components(separatedBy: ":")
                let size = fullNameArr.count
                if(size > 1 ) {
                    if let _:String = fullNameArr[0]  {
                        let hourstring:String = fullNameArr[0]
                        let numberFromString:Int = Int(hourstring)!
                        eventHour = numberFromString
                    }
                }
            }
        }


        //minutes compare
        let fullNameArr2 = itemx.toHour.components(separatedBy: ":")
        let size2 = fullNameArr2.count
        if(size2 > 1 ) {
            if let _:String = fullNameArr2[1]  {
                let hourstring:String = fullNameArr2[1]
                if let a1:Character =  hourstring[hourstring.startIndex] {
                    if a1 == "0" {
                        //now get the real minute
                        if let a2:Character =  hourstring[hourstring.characters.index(hourstring.startIndex, offsetBy: 1)]{
                            if a2 == "0" {
                                //     print("minutul 0 add to 0")
                                eventMinutes = 0
                            }
                            else {
                                //     print("minutul \(a2) add to \(a2)") //section
                                let str = String(a2)
                                let IntHOUR:Int = Int(str)!
                                eventMinutes = IntHOUR

                            }
                        }
                    }
                    else { //full minutes 2 chars
                        let fullNameArr2 = itemx.toHour.components(separatedBy: ":")
                        let size = fullNameArr2.count
                        if(size > 1 ) {
                            if let _:String = fullNameArr2[1]  {
                                let hourstring:String = fullNameArr2[1]
                                let numberFromString:Int = Int(hourstring)!
                                eventMinutes = numberFromString
                            }
                        }
                    }
                }
            }
        }
        arrayints.append(eventHour)
        arrayints.append(eventMinutes)
        return arrayints
    }
    //NEW DEVELOP
    //1
    func tryGetSupplierCustomerUserIdByEmployeeId() {
        var y:Int = 0
        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
        if let x:Int = a.value(forKey: "currentUserId") as? Int{
            y = x
        }
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            dicuser["iUserId"] =  y as AnyObject
            api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    self.generic.hideNativeActivityIndicator(self)
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _:Int = RESPONSEOBJECT["Result"] as? Int
                    {
                        let myInt :Int = RESPONSEOBJECT["Result"] as! Int
                        print("sup id e ok ? " + myInt.description)
                        if myInt == 0 {
                            //NO EMPL NO BUSINESS
                        } else {
                            self.GetSecondUserIdByFirstUserId(myInt)
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))

                self.initEvents()

            })
        }
    }
    //2
    func GetSecondUserIdByFirstUserId(_ employeID:Int)  {

        var y:Int = 0
        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        y = employeID
        dicEMPLOYE["iUserId"] =  y as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            api.sharedInstance.GetSecondUserIdByFirstUserId(dicEMPLOYE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    self.generic.hideNativeActivityIndicator(self)
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            print("eroare la GetSecondUserIdByFirstUserId \(RESPONSEOBJECT["Error"] ?? -1 as AnyObject)")
                        }
                        else
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {

                                print("eroare la GetSecondUserIdByFirstUserId \(RESPONSEOBJECT["Error"] ?? -2 as AnyObject)")
                            }

                            else
                            {
                                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                {
                                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                    print("SECOND USER ID \(myInt)")
                                    if myInt > 0 {
                                        self.setupISupplierSecondID(myInt)
                                    }
                                }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.initEvents()
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))


            })
        }

    }
    //3
    func setupISupplierSecondID (_ ISupplierSecondID:Int){
        self.intSuppliersecondID = ISupplierSecondID
        print("self.intSuppliersecondID \(self.intSuppliersecondID)")
        GetBlockedHouresFromCalendar()

    }
    //4
    func GetBlockedHouresFromCalendar() {
        self.BlockHouresObjArray =  Array<BlockHouresObj>()
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var supplierID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                supplierID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            supplierID = Global.sharedInstance.providerID
        }

        dicSearch["iProviderUserId"] = self.intSuppliersecondID as AnyObject
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        let mydtDateStart = datesInWeekArraysorted[0]
        let mydtDateEnd = datesInWeekArraysorted[6]
        dicSearch["nvFromDate"] = Global.sharedInstance.convertNSDateToString(mydtDateStart) as AnyObject
        dicSearch["nvToDate"] = Global.sharedInstance.convertNSDateToString(mydtDateEnd) as AnyObject
        self.generic.showNativeActivityIndicator(self)
        print("aicie \(supplierID)")
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetBlockedHouresFromCalendar(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print(RESPONSEOBJECT)
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if  let _ = RESPONSEOBJECT["Result"] as? NSArray {
                                let ps:BlockHouresObj = BlockHouresObj()
                                self.BlockHouresObjArray = ps.dicToBlockHouresToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                print(self.BlockHouresObjArray)


                            }
                        } else {
                        }
                    }
                    self.generic.hideNativeActivityIndicator(self)

                }
                self.initEvents()
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.initEvents()
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))

            })
        }

    }


    //    func hourisless (itemx: allKindEventsForListDesign, itemy: allKindEventsForListDesign) -> Bool {
    //        var islessh:Bool  = false
    //        var eventHour:Int = 0
    //        var eventMinutes:Int = 0
    //        var eventSecondHour:Int = 0
    //        var eventSecondMinutes:Int = 0
    //        //   if itemx.iCoordinatedServiceId > 0 { don't care all events has starting and ending hours and hollydays are in separated array
    //        if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
    //            if a1 == "0" {
    //                //now get the real hour
    //                if let a2:Character =  itemx.fromHour[itemx.fromHour.startIndex.advancedBy(1)]{
    //                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
    //                    if a2 == "0" {
    //                        //    print("ora1 0 add to 0")
    //                        eventHour = 0
    //                    }
    //                    else {
    //                        //     print("ora1 \(a2) add to \(a2)") //section
    //                        let str = String(a2)
    //                        let IntHOUR:Int = Int(str)!
    //                        eventHour = IntHOUR
    //
    //                    }
    //                }
    //            }
    //            else { //full hour 2 chars
    //                let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
    //                let size = fullNameArr.count
    //                if(size > 1 ) {
    //                    if let _:String = fullNameArr[0]  {
    //                        let hourstring:String = fullNameArr[0]
    //                        let numberFromString:Int = Int(hourstring)!
    //                        eventHour = numberFromString
    //                    }
    //                }
    //            }
    //        }
    //        if let a2:Character =  itemy.fromHour[itemy.fromHour.startIndex] {
    //            if a2 == "0" {
    //                //now get the real hour
    //                if let a3:Character =  itemy.fromHour[itemy.fromHour.startIndex.advancedBy(1)]{
    //                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
    //                    if a3 == "0" {
    //                        //    print("orax1 0 add to 0")
    //                        eventHour = 0
    //                    }
    //                    else {
    //                        //     print("orax1 \(a2) add to \(a2)") //section
    //                        let str = String(a3)
    //                        let IntHOUR:Int = Int(str)!
    //                        eventSecondHour = IntHOUR
    //
    //                    }
    //                }
    //            }
    //            else { //full hour 2 chars
    //                let fullNameArr = itemy.fromHour.componentsSeparatedByString(":")
    //                let size = fullNameArr.count
    //                if(size > 1 ) {
    //                    if let _:String = fullNameArr[0]  {
    //                        let hourstring:String = fullNameArr[0]
    //                        let numberFromString:Int = Int(hourstring)!
    //                        eventSecondHour = numberFromString
    //                    }
    //                }
    //            }
    //        }
    //
    //
    //
    //
    //        if eventHour < eventSecondHour {
    //            islessh = true
    //        } else  if eventHour == eventSecondHour {
    //            //minutes compare
    //            let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
    //            let size = fullNameArr.count
    //            if(size > 1 ) {
    //                if let _:String = fullNameArr[1]  {
    //                    let hourstring:String = fullNameArr[1]
    //                    if let a1:Character =  hourstring[hourstring.startIndex] {
    //                        if a1 == "0" {
    //                            //now get the real minute
    //                            if let a2:Character =  hourstring[hourstring.startIndex.advancedBy(1)]{
    //                                if a2 == "0" {
    //                                    //     print("minutul 0 add to 0")
    //                                    eventMinutes = 0
    //                                }
    //                                else {
    //                                    //     print("minutul \(a2) add to \(a2)") //section
    //                                    let str = String(a2)
    //                                    let IntHOUR:Int = Int(str)!
    //                                    eventMinutes = IntHOUR
    //
    //                                }
    //                            }
    //                        }
    //                        else { //full minutes 2 chars
    //                            let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
    //                            let size = fullNameArr.count
    //                            if(size > 1 ) {
    //                                if let _:String = fullNameArr[1]  {
    //                                    let hourstring:String = fullNameArr[1]
    //                                    let numberFromString:Int = Int(hourstring)!
    //                                    eventMinutes = numberFromString
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //            let fullNameArr2 = itemy.fromHour.componentsSeparatedByString(":")
    //            let size2 = fullNameArr2.count
    //            if(size2 > 1 ) {
    //                if let _:String = fullNameArr2[1]  {
    //                    let hourstring:String = fullNameArr2[1]
    //                    if let a1:Character =  hourstring[hourstring.startIndex] {
    //                        if a1 == "0" {
    //                            //now get the real minute
    //                            if let a2:Character =  hourstring[hourstring.startIndex.advancedBy(1)]{
    //                                if a2 == "0" {
    //                                    //     print("minutulx 0 add to 0")
    //                                    eventSecondMinutes = 0
    //                                }
    //                                else {
    //                                    //     print("minutulx \(a2) add to \(a2)") //section
    //                                    let str = String(a2)
    //                                    let IntHOUR:Int = Int(str)!
    //                                    eventSecondMinutes = IntHOUR
    //
    //                                }
    //                            }
    //                        }
    //                        else { //full minutes 2 chars
    //                            let fullNameArr = itemy.fromHour.componentsSeparatedByString(":")
    //                            let size = fullNameArr.count
    //                            if(size > 1 ) {
    //                                if let _:String = fullNameArr[1]  {
    //                                    let hourstring:String = fullNameArr[1]
    //                                    let numberFromString:Int = Int(hourstring)!
    //                                    eventSecondMinutes = numberFromString
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //            if eventMinutes <= eventSecondMinutes {
    //                islessh = false //we need only hours
    //            } else {
    //                islessh = false
    //            }
    //
    //        }
    //        //        else {
    //        //            islessh = false
    //        //        }
    //        //\\print ("oraacum \(eventHour) - eventMinutes \(eventMinutes) si eventHour \(eventSecondHour)  eventMinutes \(eventSecondMinutes) ")
    //
    //        return islessh
    //    }
    //    func DAYEventstohours()
    //    {
    //        //we know we are in the same day so don't care anymore of datestring from arrEventsCurrentDay
    //        //clear all hours now
    //        //1.events for all day - have full hours and will be displayed above list
    //        //2.events in calendar with hours first in row
    //        //3.bthere with hours
    //        initALLSECTIONSFINAL()
    //        for  itemx in PERFECTSENSE
    //        {
    //              print(" aria  finala\(itemx.title)")
    //              print(" fromHour\(itemx.fromHour) tohour\(itemx.toHour)")
    //            /////1.
    //            //       if  itemx.dateEvent == currentDate {
    //            if itemx.fromHour == "00:00" && itemx.toHour == "23:59" {
    //                  print("allday ")
    //                //\\add to above table list
    //            }
    //            //    }
    //            //  else
    //            //           /////2.
    //            //\\print ("itemx.iCoordinatedServiceId \(itemx.iCoordinatedServiceId)")
    //            if itemx.iCoordinatedServiceId == 0  && itemx.fromHour != "00:00" && itemx.toHour != "23:59"{
    //                if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
    //                    if a1 == "0" {
    //                        //now get the real hour
    //                        if let a2:Character =  itemx.fromHour[itemx.fromHour.startIndex.advancedBy(1)]{
    //                            //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
    //                            if a2 == "0" {
    //                                //   print("ora1 0 add to 0")
    //                                for inthour in arrHoursInt {
    //                                    if inthour == 0 {
    //                                        ALLSECTIONSFINAL[0].1.append(itemx)
    //                                    }
    //                                }
    //                            }
    //                            else {
    //                                //     print("ora1 \(a2) add to \(a2)") //section
    //                                let str = String(a2)
    //                                let IntHOUR:Int = Int(str)!
    //                                for inthour in arrHoursInt {
    //                                    if inthour == IntHOUR {
    //                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                    else { //full hour 2 chars
    //                        let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
    //
    //                        let size = fullNameArr.count
    //                        if(size > 1 ) {
    //                            if let _:String = fullNameArr[0]  {
    //                                let hourstring:String = fullNameArr[0]
    //                                let numberFromString:Int = Int(hourstring)!
    //                                //     print("ora1 \(numberFromString) add to \(numberFromString)")
    //                                for inthour in arrHoursInt {
    //                                    if inthour == numberFromString {
    //                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //            /////3.
    //            if itemx.iCoordinatedServiceId > 0 {
    //                //                for ArwenEvenstar in PERFECTSENSE {
    //                //                    if itemx.fromHour == ArwenEvenstar.fromHour && itemx.toHour == ArwenEvenstar.toHour && itemx.title == ArwenEvenstar.title && itemx.iCoordinatedServiceId != ArwenEvenstar.iCoordinatedServiceId {
    //                //                          print("am gasit Arwen in LOTR")
    //                //                    } else {
    //                //                           print("wrong Arwen in LOTR")
    //                //                    }
    //                //                }
    //
    //                if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
    //                    if a1 == "0" {
    //                        //now get the real hour
    //                        if let a2:Character =  itemx.fromHour[itemx.fromHour.startIndex.advancedBy(1)]{
    //                            //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
    //                            if a2 == "0" {
    //                                //   print("ora1 0 add to 0")
    //                                for inthour in arrHoursInt {
    //                                    if inthour == 0 {
    //                                        ALLSECTIONSFINAL[0].1.append(itemx)
    //                                    }
    //                                }
    //                            }
    //                            else {
    //                                //    print("ora1 \(a2) add to \(a2)") //section
    //                                let str = String(a2)
    //                                let IntHOUR:Int = Int(str)!
    //                                for inthour in arrHoursInt {
    //                                    if inthour == IntHOUR {
    //                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                    else { //full hour 2 chars
    //                        let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
    //
    //                        let size = fullNameArr.count
    //                        if(size > 1 ) {
    //                            if let _:String = fullNameArr[0]  {
    //                                let hourstring:String = fullNameArr[0]
    //                                let numberFromString:Int = Int(hourstring)!
    //                                //     print("ora1 \(numberFromString) add to \(numberFromString)")
    //                                for inthour in arrHoursInt {
    //                                    if inthour == numberFromString {
    //                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //          print("ALLSECTIONSFINAL \(ALLSECTIONSFINAL) si count \(ALLSECTIONSFINAL.count)")
    //        ALLSECTIONSFINALFILTERED = ALLSECTIONSFINAL
    //
    //
    //    }


}
extension Array {

    func filterDuplicatesz(_ includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()

        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }

        return results
    }

}
public func ==(lhs: Date, rhs: Date) -> Bool {
    //  return (lhs == rhs)
    switch lhs.compare(rhs) {
    case .orderedSame :
        return true
    default:
        return false
    }
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}
func colorWithHexString (_ hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    print("cString \(cString)")
    if String(cString) == "#EAEAEA" || String(cString) == "EAEAEA" {

        cString = "#FF3300"
    }

    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substring(from: 1)
    }
    if (cString.characters.count != 6) {
        // return UIColor.grayColor()
        cString = "#E60073"
    }


    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)

    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)


    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}
//extension Date: Comparable { }
extension CALayer {

    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }

        border.backgroundColor = color.cgColor;

        self.addSublayer(border)
    }

}




//
////
////  WeekDesignSupplierViewController.swift
////  Bthere
////
////  Created by User on 1.9.2016.
////  Copyright © 2016 Webit. All rights reserved.
////
//import UIKit
//import EventKit
//import EventKitUI
//import MessageUI
////ספק - תצוגת שבוע
//class WeekDesignSupplierViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,iCarouselDataSource, iCarouselDelegate, MFMailComposeViewControllerDelegate {
//    //JMODE PLUS
//    //    CalendarMatrix Int hour
//    //    Array<Int>
//    var column1:Array<Int> = []
//    var column2:Array<Int> = []
//    var column3:Array<Int> = []
//    var column4:Array<Int> = []
//    var column5:Array<Int> = []
//    var column6:Array<Int> = []
//    var column7:Array<Int> = []
//    var NOLOAD:Bool = false
//    var EMPLOYEISMANAGER:Bool = false
//    var FROMPRINT:Bool = false
//    var refreshControl: UIRefreshControl!
//    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
//    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
//    @IBOutlet var arrowleft: UIImageView!
//    @IBOutlet var arrowright: UIImageView!
//    var CalendarMatrix:[(Int,Int,Array<allKindEventsForListDesign>)] = [] //the start h , the day, the events
//    var dtDateStart:NSDate = NSDate()
//    var dtDateEnd:NSDate = NSDate()
//    let dateFormatter = NSDateFormatter()
//    var PERFECTSENSE:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//    var HOLLYDAYSSECTIONSFINAL:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//    var ALLSECTIONSFINAL:[(Int,Array<allKindEventsForListDesign>)] = [] //grouped array
//    var ALLSECTIONSFINALFILTERED:[(Int,Array<allKindEventsForListDesign>)] = []
//    var PLAYIT:weekdayevents = weekdayevents() //day, index, hour, array Int,Int,Int,Array<allKindEventsForListDesign>
//    var iFilterByMonth:Int = 0
//    var iFilterByYear:Int = 0
//    var iFilterByMonthEnd:Int = 0
//    var iFilterByYearEnd:Int = 0
//    var myArray : NSMutableArray = NSMutableArray()
//    var myCustomersArray : NSMutableArray = []
//    var arrayWorkers:  NSMutableArray = []
//    var selectedWorker:Bool = false
//    var selectedWorkerID:Int = 0
//    var generic:Generic = Generic()
//    // var idWorker:Int = -1
//    var bthereEventDateDayInt:NSMutableArray = NSMutableArray()
//    @IBOutlet var carousel: iCarousel!
//    var yearEvent =  0
//    var monthEvent = 0
//    var dayEvent = 0
//    //END PLUS
//    var delegate:clickToDayInWeekDelegate!
//    //MARK: - Outlet
//    @IBOutlet var btnDay1: UIButton!
//    @IBOutlet var btnDay2: UIButton!
//    @IBOutlet var btnDay3: UIButton!
//    @IBOutlet var btnDay4: UIButton!
//    @IBOutlet var btnDay5: UIButton!
//    @IBOutlet var btnDay6: UIButton!
//    @IBOutlet var btnDay7: UIButton!
//    var  arrayDays: NSMutableArray = NSMutableArray()
//    var  arrayButtons: Array<UIButton> = Array<UIButton>()
//    var  arrayLabelsDayNum: Array<UILabel> = Array<UILabel>()
//    var  arrayLabelsdate: Array<UILabel> = Array<UILabel>()
//    var monthArray:Array<Int> = Array<Int>()
//    var datesInWeekArray:Array<NSDate> = Array<NSDate>()//array of nsdate in week
//    var dicArrayEventsToShow:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
//    var sortDicEvents:[(String,Array<allKindEventsForListDesign>)] = []
//
//    var dicBthereEvent:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
//    var sortDicBTHEREevent:[(String,Array<allKindEventsForListDesign>)] = []
//    var sortDicBTHEREeventFiltered:[(String,Array<allKindEventsForListDesign>)] = []
//    @IBOutlet weak var ingTrailing: NSLayoutConstraint!
//
//    @IBOutlet weak var imgCurrentDay: UIImageView!
//
//    @IBOutlet weak var lblDay1: UILabel!
//
//    @IBOutlet weak var lblDay2: UILabel!
//
//    @IBOutlet weak var lblDay3: UILabel!
//
//    @IBOutlet weak var lblDay4: UILabel!
//
//    @IBOutlet weak var lblDay5: UILabel!
//
//    @IBOutlet weak var lblDay6: UILabel!
//
//    @IBOutlet weak var lblDay7: UILabel!
//
//
//    @IBOutlet weak var lblDayOfWeek1: UILabel!
//
//    @IBOutlet weak var lblDayOfWeek2: UILabel!
//
//    @IBOutlet weak var lblDayOfWeek3: UILabel!
//
//    @IBOutlet weak var lblDayOfWeek4: UILabel!
//
//    @IBOutlet weak var lblDayOfWeek5: UILabel!
//
//    @IBOutlet weak var lblDayOfWeek6: UILabel!
//
//    @IBOutlet weak var lblDayOfWeek7: UILabel!
//
//
//    @IBOutlet weak var lblDays: UILabel!
//
//    // @IBOutlet weak var lblDate: UILabel!
//    //MARK: - IBAction
//
//    //enter to date in week
//    @IBAction func btnEnterDateClick(sender: AnyObject) {
//
//        let tag:Int = (sender as! UIButton).tag
//
//        let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
//
//        yearToday =  componentsCurrent.year
//        monthToday = componentsCurrent.month
//        dayToday = componentsCurrent.day
//        let td:Int =  arrayDays[tag] as! Int
//
//        componentsCurrent.day = td
//        let dateSelected = calendar.dateFromComponents(componentsCurrent)
//
//        Global.sharedInstance.currDateSelected = dateSelected!
//        Global.sharedInstance.dateDayClick = dateSelected!
//
//
//
//        delegate.clickToDayInWeek()
//
//    }
//
//    //כפתור הקודם (לא הבא)
//    @IBAction func btnPrevious(sender: AnyObject) {
//
//        //בלחיצה על הקודם מוצגים הימים בשבוע הקודם
//
//        hasEvent = false
//        let day:Int = Calendar.sharedInstance.getDayOfWeek(currentDate)! - 1
//
//        let otherDate:NSDate = currentDate
//
//        //show month for each day in week
//        lblDay1.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -1).description
//        lblDay2.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -2).description
//        lblDay3.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -3).description
//        lblDay4.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -4).description
//        lblDay5.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -5).description
//        lblDay6.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -6).description
//        lblDay7.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: -7).description
//
//        currentDate =  Calendar.sharedInstance.reduceAddDay_Date(otherDate, reduce: day, add: -7)
//        let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
//        monthToday = componentsCurrent.month
//
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -1))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -2))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -3))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -4))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -5))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -6))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: -7))
//        print("monthArray \(monthArray)")
//        // - long
//        //NSDateFormatter().monthSymbols[monthToday - 1]
//
//        //let dayName = NSDateFormatter().weekdaySymbols[day]
//
//        //  lblDate.text = "\(monthName) \(yearToday)"
//
//        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
//
//        //אתחול המערך של תאריכי השבוע
//        datesInWeekArray = []
//        for i in 0..<7
//        {
//            datesInWeekArray.append(
//                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
//        }
//
//        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
//
//        var datesInWeekArraysorted = datesInWeekArray.sort()
//        dtDateStart = datesInWeekArraysorted[0]
//        dtDateEnd = datesInWeekArraysorted[6]
//        print("btn next datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
//        var  isFindToday:Bool = false
//
//
//        //בדיקה האם היום הנוכחי מוצג כעת
//        for item in datesInWeekArray
//        {
//
//            let otherDay: NSDateComponents = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day], fromDate: item)
//
//            let today: NSDateComponents = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day], fromDate: NSDate())
//            if today.day == otherDay.day && today.month == otherDay.month && today.year == otherDay.year
//            {
//                isFindToday = true
//            }
//
//        }
//        if isFindToday
//        {
//
//            imgCurrentDay.hidden = false
//            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(NSDate())!
//            UIView.animateWithDuration(1, animations: {
//                self.ingTrailing.constant = /* self.ingTrailing.constant +*/ ((self.view.frame.width / 8) *
//                    CGFloat(self.dayOfWeekToday))
//            })
//        }
//        else
//        {
//            imgCurrentDay.hidden = true
//        }
//
//        let componentsEventx = calendar.components([.Day, .Month, .Year], fromDate: dtDateStart)
//        let componentsEndEventx = calendar.components([.Day, .Month, .Year], fromDate: dtDateEnd)
//        var monthName:String = ""
//        var endmonthName:String = ""
//        var yearStart:String = ""
//        var yearEnd:String = ""
//
//
//        let yearEvent:Int = componentsEventx.year
//
//
//        let dateFormatter = NSDateFormatter()
//        let dateFormatterYEAR = NSDateFormatter()
//        dateFormatter.dateFormat = "MMM"
//        dateFormatterYEAR.dateFormat = "yyyy"
//        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
//            dateFormatter.locale = NSLocale(localeIdentifier: "he_IL")
//        } else {
//            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
//        }
//
//        monthName = dateFormatter.stringFromDate(dtDateStart)
//        endmonthName = dateFormatter.stringFromDate(dtDateEnd)
//
//        let yearEndEvent:Int = componentsEndEventx.year
//
//
//        yearStart = String(yearEvent)
//        yearEnd = String(yearEndEvent)
//
//        if yearStart != yearEnd {
//            lblDays.text = "\(lblDay7.text!).\(monthName).\(yearStart) - \(lblDay1.text!) .\(endmonthName).\(yearEnd)"
//        } else{
//            if monthName != endmonthName {
//                lblDays.text = "\(lblDay7.text!).\(monthName) - \(lblDay1.text!) .\(endmonthName).\(yearStart)"
//            }
//            else {
//                lblDays.text = "\(lblDay7.text!) - \(lblDay1.text!) .\(monthName).\(yearStart)"
//            }
//        }
//
//        //   lblDate.text = "\(monthName) \(yearToday)"
//        //     get the month and day of week names - short
//
//        if monthToday == 0
//        {
//            monthName = NSDateFormatter().shortStandaloneMonthSymbols[monthToday]
//        }
//        else
//        {
//            monthName = NSDateFormatter().shortStandaloneMonthSymbols[monthToday - 1]
//        }
//
//        CalendarMatrix = []
//        for inthour in arrHoursInt {
//            for intday in arrayDays {
//                let ax:Int = intday as! Int
//                let fullreservedids:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                CalendarMatrix.append(inthour,ax,fullreservedids)
//            }
//        }
//        print("CalendarMatrix \(CalendarMatrix) and count \(CalendarMatrix.count)")
//        //refresh event array
//        //  setEventsArray(currentDate)
//        arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]
//
//        // GetCustomersOrdersByDateForSupplier()
//        if self.EMPLOYEISMANAGER == true {
//            GetCustomersOrdersByDateForSupplier()
//        } else {
//            //is employe non manager
//            GetCustomersOrdersByDateForEmployeeId()
//        }
//
//        //   setDateEnablity()
//
//
//    }
//
//    @IBOutlet weak var btnNext: UIButton!
//
//    @IBOutlet weak var btnPrevious: UIButton!
//
//    //כפתור הבא (לא הקודם)
//    @IBAction func btnNext(sender: AnyObject) {
//        //בלחיצה על הבא מוצגים הימים בשבוע הבא
//
//        hasEvent = false
//        let day:Int = Calendar.sharedInstance.getDayOfWeek(currentDate)! - 1
//
//        let otherDate:NSDate = currentDate
//
//        //show month for each day in week
//        lblDay1.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 13).description
//        lblDay2.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 12).description
//        lblDay3.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 11).description
//        lblDay4.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 10).description
//        lblDay5.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 9).description
//        lblDay6.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 8).description
//        lblDay7.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 7).description
//
//        currentDate =  Calendar.sharedInstance.reduceAddDay_Date(otherDate, reduce: day, add: 13)
//
//        let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
//
//        monthToday = componentsCurrent.month
//
//
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 13))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 12))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 11))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 10))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 9))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 8))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 7))
//        print("monthArray \(monthArray)")
//        let componentsEventx = calendar.components([.Day, .Month, .Year], fromDate: dtDateStart)
//        let componentsEndEventx = calendar.components([.Day, .Month, .Year], fromDate: dtDateEnd)
//        var monthName:String = ""
//        var endmonthName:String = ""
//        var yearStart:String = ""
//        var yearEnd:String = ""
//
//
//        let yearEvent:Int = componentsEventx.year
//
//
//        let dateFormatter = NSDateFormatter()
//        let dateFormatterYEAR = NSDateFormatter()
//        dateFormatter.dateFormat = "MMM"
//        dateFormatterYEAR.dateFormat = "yyyy"
//        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
//            dateFormatter.locale = NSLocale(localeIdentifier: "he_IL")
//        } else {
//            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
//        }
//
//        monthName = dateFormatter.stringFromDate(dtDateStart)
//        endmonthName = dateFormatter.stringFromDate(dtDateEnd)
//
//        let yearEndEvent:Int = componentsEndEventx.year
//
//
//        yearStart = String(yearEvent)
//        yearEnd = String(yearEndEvent)
//
//        if yearStart != yearEnd {
//            lblDays.text = "\(lblDay7.text!).\(monthName).\(yearStart) - \(lblDay1.text!) .\(endmonthName).\(yearEnd)"
//        } else{
//            if monthName != endmonthName {
//                lblDays.text = "\(lblDay7.text!).\(monthName) - \(lblDay1.text!) .\(endmonthName).\(yearStart)"
//            }
//            else {
//                lblDays.text = "\(lblDay7.text!) - \(lblDay1.text!) .\(monthName).\(yearStart)"
//            }
//        }
//
//        // - long
//        //NSDateFormatter().monthSymbols[monthToday - 1]
//
//        //let dayName = NSDateFormatter().weekdaySymbols[day]
//
//        //    lblDate.text = "\(monthName) \(yearToday)"
//
//        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
//
//        //אתחול המערך של תאריכי השבוע
//        datesInWeekArray = []
//        for i in 0..<7
//        {
//            datesInWeekArray.append(
//                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
//        }
//        var datesInWeekArraysorted = datesInWeekArray.sort()
//        dtDateStart = datesInWeekArraysorted[0]
//        dtDateEnd = datesInWeekArraysorted[6]
//        print("btn prev datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
//        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
//
//        var  isFindToday:Bool = false
//
//        //בדיקה האם היום הנוכחי מוצג כעת
//        for item in datesInWeekArray
//        {
//            let otherDay: NSDateComponents = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day], fromDate: item)
//
//            let today: NSDateComponents = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day], fromDate: NSDate())
//            if today.day == otherDay.day && today.month == otherDay.month && today.year == otherDay.year
//            {
//                isFindToday = true
//            }
//        }
//
//        if isFindToday
//        {
//            imgCurrentDay.hidden = false
//            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(NSDate())!
//            UIView.animateWithDuration(1, animations: {
//                self.ingTrailing.constant = /* self.ingTrailing.constant +*/ ((self.view.frame.width / 8) *
//                    CGFloat(self.dayOfWeekToday))
//            })
//        }
//        else
//        {
//            imgCurrentDay.hidden = true
//        }
//        print("btn back datesInWeekArray \(datesInWeekArray)")
//        //  setEventsArray(currentDate)
//        arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]
//
//        //  setDateEnablity()
//        //      GetCustomersOrdersByDateForSupplier()
//        if self.EMPLOYEISMANAGER == true {
//            GetCustomersOrdersByDateForSupplier()
//        } else {
//            //is employe non manager
//            GetCustomersOrdersByDateForEmployeeId()
//        }
//
//
//    }
//
//
//    @IBOutlet weak var collWeek: UICollectionView!
//
//    //MARK: - Properties
//
//    let language = NSBundle.mainBundle().preferredLocalizations.first! as NSString
//    var arrHoursInt:Array<Int> = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
//    var arrHours:Array<String> = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]
//
//    var arrEventsCurrentDay:Array<allKindEventsForListDesign> = []
//    var arrBThereEventsCurrentDay:Array<OrderDetailsObj> = []
//    var flag = false
//    var hasEvent = false
//    var currentDate:NSDate = NSDate()
//    let calendar = NSCalendar.currentCalendar()
//    var dayToday:Int = 0
//    var monthToday:Int = 0
//    var yearToday:Int = 0
//    var dayOfWeekToday = 0
//
//
//    @IBOutlet weak var viewSync: UIView!
//
//    @IBOutlet weak var btnSyncWithGoogelSupplier: eyeSynCheckBox!
//    //    @IBOutlet weak var btnSync: eyeSynCheckBox!
//    //MARK: - Initial
//    //func that get date to init the design by date
//    func initDateOfWeek(date:NSDate)
//    {
//        datesInWeekArray = []
//        currentDate = date
//        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
//
//        for i in 0..<7
//        {
//            datesInWeekArray.append(
//                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
//        }
//        //\\    print("datesInWeekArray \(datesInWeekArray)")
//        var datesInWeekArraysorted = datesInWeekArray.sort()
//        dtDateStart = datesInWeekArraysorted[0]
//        dtDateEnd = datesInWeekArraysorted[6]
//        print("initinit datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
//        if FROMPRINT == true {
//            bestmode()
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //        if Global.sharedInstance.defaults.integerForKey("ismanager") == 0 {
//        //            self.EMPLOYEISMANAGER = false
//        //        } else {
//        //            self.EMPLOYEISMANAGER = true
//        //        }
//        initDateOfWeek(Calendar.sharedInstance.carrentDate)
//        if NOLOAD == false  {
//            self.bestmode()
//        }
//    }
//
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        //   if Global.sharedInstance.rtl
//        //            if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0
//        //        {
//        //            arrowleft.image =    UIImage(named: "sageata1.png")
//        //            arrowright.image =    UIImage(named: "sageata2.png")
//        //        }
//        //        else
//        //        {
//        arrowleft.image =    UIImage(named: "arrow_left_J.png")
//        arrowright.image =    UIImage(named: "arrow_right_J.png")
//        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
//            var scalingTransform : CGAffineTransform!
//            scalingTransform = CGAffineTransformMakeScale(-1, 1)
//            arrowleft.transform = scalingTransform
//            arrowright.transform = scalingTransform
//        }
//        arrowleft.contentMode = .ScaleAspectFit
//        arrowright.contentMode = .ScaleAspectFit
//    }
//
//    func setDateEnablity()
//    {
//        for i in 0  ..< datesInWeekArray.count
//        {
//            if self.small(datesInWeekArray[i], rhs: NSDate())
//            {
//                (arrayButtons[6-i] as UIButton).enabled = false
//                (arrayLabelsDayNum[6-i] as UILabel).textColor = Colors.sharedInstance.color7
//                (arrayLabelsdate[6-i] as UILabel).textColor =  Colors.sharedInstance.color7
//            }
//                // - כדי שירענן את הכפתורים ולא ישאיר לפי הקודם
//            else
//            {
//                (arrayButtons[6-i] as UIButton).enabled = true
//                (arrayLabelsDayNum[6-i] as UILabel).textColor =  UIColor.whiteColor()
//                (arrayLabelsdate[6-i] as UILabel).textColor =  UIColor.whiteColor()
//            }
//        }
//        var datesInWeekArraysorted = datesInWeekArray.sort()
//        dtDateStart = datesInWeekArraysorted[0]
//        dtDateEnd = datesInWeekArraysorted[6]
//        print("setdenab datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
//        let componentsEventx = calendar.components([.Day, .Month, .Year], fromDate: dtDateStart)
//        let componentsEndEventx = calendar.components([.Day, .Month, .Year], fromDate: dtDateEnd)
//        var monthName:String = ""
//        var endmonthName:String = ""
//        var yearStart:String = ""
//        var yearEnd:String = ""
//
//
//        let yearEvent:Int = componentsEventx.year
//
//
//        let dateFormatter = NSDateFormatter()
//        let dateFormatterYEAR = NSDateFormatter()
//        dateFormatter.dateFormat = "MMM"
//        dateFormatterYEAR.dateFormat = "yyyy"
//        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
//            dateFormatter.locale = NSLocale(localeIdentifier: "he_IL")
//        } else {
//            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
//        }
//
//        monthName = dateFormatter.stringFromDate(dtDateStart)
//        endmonthName = dateFormatter.stringFromDate(dtDateEnd)
//
//        let yearEndEvent:Int = componentsEndEventx.year
//
//
//        yearStart = String(yearEvent)
//        yearEnd = String(yearEndEvent)
//
//        if yearStart != yearEnd {
//            lblDays.text = "\(lblDay7.text!).\(monthName).\(yearStart) - \(lblDay1.text!) .\(endmonthName).\(yearEnd)"
//        } else{
//            if monthName != endmonthName {
//                lblDays.text = "\(lblDay7.text!).\(monthName) - \(lblDay1.text!) .\(endmonthName).\(yearStart)"
//            }
//            else {
//                lblDays.text = "\(lblDay7.text!) - \(lblDay1.text!) .\(monthName).\(yearStart)"
//            }
//        }
//
//
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    @IBAction func btnSyncWithGoogel(sender: eyeSynCheckBox) {
//        if sender.isCecked == false
//        {
//            Global.sharedInstance.getEventsFromMyCalendar()
//            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.collWeek.reloadData()
//            })
//
//        }
//        else
//        {
//            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = false
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.collWeek.reloadData()
//            })
//
//        }
//    }
//    //MARK: - collectionView
//    func tapedinsidecell(sender: UITapGestureRecognizer) {
//        let tag = sender.view!.tag
//        print("sender tag \(tag)")
//        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//        myeventstoShow = self.CalendarMatrix[tag].2
//        if myeventstoShow.count > 0 {
//            var newarraywithuniquevals:Array<allKindEventsForListDesign> = []
//            for item in myeventstoShow {
//                if !newarraywithuniquevals.contains(item) {
//                    print("exactviews \(item.viewsforweek)")
//                    newarraywithuniquevals.append(item)
//                }
//            }
//            //\\print ("myeventstoShow.count \(newarraywithuniquevals.count)")
//            if myeventstoShow.count > 0 {
//                //\\print ("//////////////// found events ////////////// \n")
//                for event in myeventstoShow {
//                    //\\print ("         \(event.getDic())          \n")
//                }
//                //\\print ("//////////////// end events ////////////// \n")
//            }
//            //   BthereEventListViewcontroller
//            let viewCon = self.storyboard!.instantiateViewControllerWithIdentifier("BthereEventListViewcontroller") as! BthereEventListViewcontroller
//            viewCon.myArray = []
//            viewCon.myArray = newarraywithuniquevals
//            if self.iOS8 {
//                viewCon.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//            } else {
//                viewCon.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
//            }
//            viewCon.myCustomersArray = self.myCustomersArray
//            self.presentViewController(viewCon, animated: true, completion: nil)
//        }
//    }
//    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//
//
//    }
//
//    func returnMINUSROW(myIndexPath:Int) -> Int {
//        var i:Int = 0
//        var ay:Int = 0
//        let myarrofInts:NSArray = [9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,129,137,145,153,161,169,177,185,193] //24 begining cells
//        let myarrofMinus:NSArray = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25] //what to substract 24 ints
//        if myarrofInts.containsObject(i) {
//
//            let ax:Int = myarrofInts.indexOfObject(i)
//            ay = myarrofMinus.objectAtIndex(ax) as! Int
//        }
//        return i
//    }
//    //this is function with long logic , please follow gently and carefully !
//    //    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
//    //    {
//    //        if !( indexPath.row == 0 || indexPath.row % 8 == 0)
//    //        {
//    //
//    //         let cell:EventsWeekViewsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventsWeekViews",forIndexPath: indexPath) as! EventsWeekViewsCollectionViewCell
//    //        cell.backgroundColor = UIColor.redColor()
//    //        }
//    //    }
//
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//
//
//        // cell of content in hours where is event show
//        //
//        // let cell:EventsWeekViewsCollectionViewCell = collectionView.cell as! EventsWeekViewsCollectionViewCell
//        // reset flags which view to show
//
//
//        //
//        //        cell.viewTopInTop.hidden = true
//        //        cell.viewMiddleInTop.hidden = true
//        //        cell.viewButtomInTop.hidden = true
//        //        cell.viewButtominButtom.hidden = true
//        //        cell.viewMiddleInButtom.hidden = true
//        //        cell.viewTopInButtom.hidden = true
//        let cell:EventsWeekViewsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventsWeekViews",forIndexPath: indexPath) as! EventsWeekViewsCollectionViewCell
//
//        //  let cell = UINib(nibName: "EventsWeekViewsCollectionViewCell", bundle: self.nibBundle).instantiateWithOwner(nil, options: nil)[0] as! EventsWeekViewsCollectionViewCell
//        //        cell.txtViewDescBottom.text = ""
//        //        cell.viewBottom.backgroundColor = UIColor.clearColor()
//        //        cell.viewTop.backgroundColor = UIColor.clearColor()
//        // cell of hour in side of cell
//        let cell1:HoursCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Hours",forIndexPath: indexPath) as! HoursCollectionViewCell
//        //        var scalingTransform : CGAffineTransform!
//        //
//        //        scalingTransform = CGAffineTransformMakeScale(-1, 1)
//        //
//        ////        if Global.sharedInstance.rtl
//        //        {
//        //            cell.transform = scalingTransform
//        //            cell1.transform = scalingTransform
//        //        }
//
//
//        column1 = generateMatrix(0)
//        column2 = generateMatrix(1)
//        column3 = generateMatrix(2)
//        column4 = generateMatrix(3)
//        column5 = generateMatrix(4)
//        column6 = generateMatrix(5)
//        column7 = generateMatrix(6)
//
//
//
//        if indexPath.row == 0 || indexPath.row % 8 == 0
//        {
//            // set hours contex
//            cell1.setDisplayData(arrHours[indexPath.row / 8])
//            return cell1
//        }
//        else
//
//        {
//
//
//            cell.BthereImg.hidden = true
//            cell.eyeImg.hidden = true
//            cell.lineviewTop.hidden = true
//            cell.lineviewBottom.hidden = true
//            cell.lineviewLeft.hidden = true
//            cell.lineviewRight.hidden = true
//
//            if CalendarMatrix.count > 0 {
//                //    print("xCalendar \(CalendarMatrix[indexPath.row])")
//                var AI:Int = 0
//                AI = (indexPath.row - 1)
//
//                if indexPath.row % 9 == 0 ||  indexPath.row > 9  {
//                    AI = (indexPath.row - 2)
//                }
//
//                if indexPath.row % 17 == 0  || indexPath.row > 17{
//                    AI = (indexPath.row - 3)
//                }
//
//                if indexPath.row % 25 == 0 || indexPath.row > 25 {
//                    AI = (indexPath.row - 4)
//                }
//
//                if indexPath.row % 33 == 0 || indexPath.row > 33 {
//                    AI = (indexPath.row - 5)
//                }
//
//                if indexPath.row % 41 == 0  || indexPath.row > 41 {
//                    AI = (indexPath.row - 6)
//                }
//
//                if indexPath.row % 49 == 0 || indexPath.row > 49 {
//                    AI = (indexPath.row - 7)
//                }
//
//                if indexPath.row % 57 == 0 || indexPath.row > 57 {
//                    AI = (indexPath.row - 8)
//                }
//
//                if indexPath.row % 65 == 0 || indexPath.row > 65  {
//                    AI = (indexPath.row - 9)
//                }
//
//                if indexPath.row % 73 == 0 || indexPath.row > 73 {
//                    AI = (indexPath.row - 10)
//                }
//
//                if indexPath.row % 81 == 0 || indexPath.row > 81 {
//                    AI = (indexPath.row - 11)
//                }
//
//                if indexPath.row % 89 == 0 || indexPath.row > 89 {
//                    AI = (indexPath.row - 12)
//                }
//
//                if indexPath.row % 97 == 0  || indexPath.row > 97 {
//                    AI = (indexPath.row - 13)
//                }
//
//                if indexPath.row % 105 == 0 || indexPath.row > 105  {
//                    AI = (indexPath.row - 14)
//                }
//
//                if indexPath.row % 113 == 0 || indexPath.row > 113 {
//                    AI = (indexPath.row - 15)
//                }
//
//                if indexPath.row % 121 == 0 || indexPath.row > 121 {
//                    AI = (indexPath.row - 16)
//                }
//
//                if indexPath.row % 129 == 0  || indexPath.row > 129{
//                    AI = (indexPath.row - 17)
//                }
//
//                if indexPath.row % 137 == 0 || indexPath.row > 137 {
//                    AI = (indexPath.row - 18)
//                }
//
//                if indexPath.row % 145 == 0 || indexPath.row > 145  {
//                    AI = (indexPath.row - 19)
//                }
//
//                if indexPath.row % 153 == 0 || indexPath.row > 153{
//                    AI = (indexPath.row - 20)
//                }
//
//                if indexPath.row % 161 == 0 || indexPath.row > 161 {
//                    AI = (indexPath.row - 21)
//                }
//
//                if indexPath.row % 169 == 0 || indexPath.row > 169  {
//                    AI = (indexPath.row - 22)
//                }
//
//                if indexPath.row % 177 == 0 || indexPath.row > 177 {
//                    AI = (indexPath.row - 23)
//                }
//
//                if indexPath.row % 185 == 0 || indexPath.row > 185 {
//                    AI = (indexPath.row - 24)
//                }
//
//
//                if indexPath.row % 193 == 0 ||  indexPath.row > 193  {
//                    AI = (indexPath.row - 25)
//                }
//
//                // cell.txtviewDesc.text = String(AI)
//                //               if  indexPath.row <= 191 {
//                //
//                //                    for item in CalendarMatrix[AI].2 {
//                //                        if item.iCoordinatedServiceId > 0 {
//                //                            cell.hasEventBthere = true
//                //                            cell.BthereImg.hidden = false
//                //                            break
//                //                        }
//                //                    }
//                //                    for item in CalendarMatrix[AI].2 {
//                //                        if item.iCoordinatedServiceId == 0 {
//                //                            cell.hasEvent = true
//                //                            cell.eyeImg.hidden = false
//                //                            break
//                //                        }
//                //                }
//                //                }
//                //        for i = 1 to 168
//                //        If CalendarMatrix[i-1].Object = Empty and CalendarMatrix[i].Object = NotEmpty then
//                //        Draw (Min(CalendarMatrix[i].Object.StartHour))
//                //         else
//                //        If CalendarMatrix[i+1].Object = Empty and CalendarMatrix[i].Object = NotEmpty then
//                //        Draw (Max(CalendarMatrix[i].EndHour))
//                //       else
//                //         Draw()
//                //simple pregenerated arrays to draw the columns
//
//
//                //[0, 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 112, 119, 126, 133, 140, 147, 154, 161]
//                //   let myxedarray = [column1 , column2 , column3 , column4 , column5 , column6 , column7].flatten()
//
//
//
//
//
//
//
//                //                    cell.lineviewTop.hidden = false
//                //                    cell.lineviewBottom.hidden = false
//                //                    cell.lineviewLeft.hidden = false
//                //                    cell.lineviewRight.hidden = false
//                //   }
//
//                ///    print("INTindexPath.row \(indexPath.row) SI AI \(AI) si CalendarMatrix \(CalendarMatrix[AI])")
//                let tapInsideCEll = UITapGestureRecognizer(target:self, action:#selector(self.tapedinsidecell(_:)))
//                cell.tag = AI
//                var MYFullAIMATRIX:Array<Int> = []
//                for i:Int in column1 {
//                    if !MYFullAIMATRIX.contains(i) {
//                        MYFullAIMATRIX.append(i)
//                    }
//                }
//                for i:Int in column2 {
//                    if !MYFullAIMATRIX.contains(i) {
//                        MYFullAIMATRIX.append(i)
//                    }
//                }
//                for i:Int in column3 {
//                    if !MYFullAIMATRIX.contains(i) {
//                        MYFullAIMATRIX.append(i)
//                    }
//                }
//                for i:Int in column4 {
//                    if !MYFullAIMATRIX.contains(i) {
//                        MYFullAIMATRIX.append(i)
//                    }
//                }
//                for i:Int in column5 {
//                    if !MYFullAIMATRIX.contains(i) {
//                        MYFullAIMATRIX.append(i)
//                    }
//                }
//                for i:Int in column6 {
//                    if !MYFullAIMATRIX.contains(i) {
//                        MYFullAIMATRIX.append(i)
//                    }
//                }
//                cell.FIRSTLINE.hidden = false
//                cell.SECONDLINE.hidden = false
//                cell.THIRSLINE.hidden = false
//                cell.FOURTHLINE.hidden = false
//                cell.FIRSTLINE.backgroundColor = UIColor.clearColor()
//                cell.SECONDLINE.backgroundColor = UIColor.clearColor()
//                cell.THIRSLINE.backgroundColor = UIColor.clearColor()
//                cell.FOURTHLINE.backgroundColor = UIColor.clearColor()
//
//
//                if CalendarMatrix.count > 0 {
//                    //        //old code do not delete!!! maybe one day you will return to it just make for all column1 to column7
//                    //        for i:Int in column1  {
//                    //            //case 1 previous cell has event
//                    //            //first cell 0
//                    //            let mainid:Int = column1.indexOf(i)!
//                    //            if mainid == 0 && i <= 160 && cell.tag == i{
//                    //                //cell.layer.addBorder(UIRectEdge.Top, color: UIColor.darkGrayColor(), thickness: 0.5)
//                    //
//                    //                if CalendarMatrix[i].2.count > 0 {
//                    //                    cell.lineviewTop.hidden = false
//                    //                    cell.lineviewLeft.hidden = false
//                    //                    cell.lineviewRight.hidden = false
//                    //                    hastop = true
//                    //                    hasleft = true
//                    //                    hasright = true
//                    //                    for item in CalendarMatrix[i].2 {
//                    //                        if item.iCoordinatedServiceId > 0 {
//                    //                            cell.hasEventBthere = true
//                    //                            cell.BthereImg.hidden = false
//                    //                            break
//                    //                        }
//                    //                    }
//                    //                    for item in CalendarMatrix[i].2 {
//                    //                        if item.iCoordinatedServiceId == 0 {
//                    //                            cell.hasEvent = true
//                    //                            cell.eyeImg.hidden = false
//                    //                            break
//                    //                        }
//                    //                    }
//                    //
//                    //                    if CalendarMatrix[i + 7].2.count > 0{
//                    //                        cell.lineviewBottom.hidden = true
//                    //                        hasbottom = false
//                    //                    } else {
//                    //                        //subcase 4 next cell has no event
//                    //                        cell.lineviewBottom.hidden = false
//                    //                        hasbottom = true
//                    //                    }
//                    //                }
//                    //                // cell.setDisplayData(AI,events: CalendarMatrix[AI].2,_hastop: hastop, _hasbottom: hasbottom, _hasleft: hasleft, _hasright: hasright)
//                    //            }
//                    //            else if 0 < mainid && i <= 160 && cell.tag == i {
//                    //                if CalendarMatrix[i].2.count > 0 {
//                    //                    if CalendarMatrix[i - 7].2.count > 0{
//                    //                        cell.lineviewTop.hidden = true
//                    //                        hastop = false
//                    //                        cell.BthereImg.hidden = true
//                    //                        cell.eyeImg.hidden = true
//                    //                    } else {
//                    //                        //subcase 4 previous cell has no event
//                    //                        cell.lineviewTop.hidden = false
//                    //                        for item in CalendarMatrix[i].2 {
//                    //                            if item.iCoordinatedServiceId > 0 {
//                    //                                cell.hasEventBthere = true
//                    //                                cell.BthereImg.hidden = false
//                    //                                break
//                    //                            }
//                    //                        }
//                    //                        for item in CalendarMatrix[i].2 {
//                    //                            if item.iCoordinatedServiceId == 0 {
//                    //                                cell.hasEvent = true
//                    //                                cell.eyeImg.hidden = false
//                    //                                break
//                    //                            }
//                    //                        }
//                    //
//                    //                        hastop = true
//                    //                    }
//                    //
//                    //
//                    //                    cell.lineviewLeft.hidden = false
//                    //                    cell.lineviewRight.hidden = false
//                    //                    hasleft = true
//                    //                    hasright = true
//                    //                    if CalendarMatrix[i + 7].2.count > 0{
//                    //                        cell.lineviewBottom.hidden = true
//                    //                        hasbottom = false
//                    //                    } else {
//                    //                        //subcase 4 next cell has no event
//                    //                        cell.lineviewBottom.hidden = false
//                    //                        hasbottom = true
//                    //                    }
//                    //                    //   cell.setDisplayData(AI,events: CalendarMatrix[AI].2,_hastop: hastop, _hasbottom: hasbottom, _hasleft: hasleft, _hasright: hasright)
//                    //                }
//                    //
//                    //                else {
//                    //                    cell.lineviewTop.hidden = true
//                    //                    cell.lineviewLeft.hidden = true
//                    //                    cell.lineviewRight.hidden = true
//                    //                    cell.lineviewBottom.hidden = true
//                    //
//                    //                    cell.BthereImg.hidden = true
//                    //                    cell.eyeImg.hidden = true
//                    //                    hastop = false
//                    //                    hasleft = false
//                    //                    hasright = false
//                    //                    hasbottom = false
//                    //                    //   cell.setDisplayData(AI,events: CalendarMatrix[AI].2,_hastop: hastop, _hasbottom: hasbottom, _hasleft: hasleft, _hasright: hasright)
//                    //                }
//                    //
//                    //            }
//                    //
//                    //
//                    //            else if  0 < mainid && i > 160 {
//                    //                // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
//                    //                if CalendarMatrix[i].2.count > 0 && cell.tag == i {
//                    //                    cell.lineviewBottom.hidden = false
//                    //                    cell.lineviewLeft.hidden = false
//                    //                    cell.lineviewRight.hidden = false
//                    //                    hastop = true
//                    //                    hasleft = true
//                    //                    hasright = true
//                    //                    //subcase 3 previous cell has event
//                    //                    if CalendarMatrix[i - 7].2.count > 0{
//                    //                        cell.lineviewTop.hidden = true
//                    //                        cell.BthereImg.hidden = false
//                    //                        cell.eyeImg.hidden = false
//                    //                        hastop = false
//                    //                    } else {
//                    //                        //subcase 4 next cell has no event
//                    //                        cell.lineviewTop.hidden = false
//                    //                        cell.BthereImg.hidden = true
//                    //                        cell.eyeImg.hidden = true
//                    //                        hastop = true
//                    //                    }
//                    //
//                    //                }
//                    //                //  cell.setDisplayData(AI,events: CalendarMatrix[AI].2,_hastop: hastop, _hasbottom: hasbottom, _hasleft: hasleft, _hasright: hasright)
//                    //            }
//                    //        }
//                    //        // end old code
//
//                    var hastop:Bool = false
//                    var hasleft:Bool = false
//                    var hasright:Bool = false
//                    var hasbottom:Bool = false
//                    cell.lineviewTop.hidden = true
//                    cell.lineviewLeft.hidden = true
//                    cell.lineviewRight.hidden = true
//                    cell.lineviewBottom.hidden = true
//                    cell.BthereImg.hidden = true
//                    cell.eyeImg.hidden = true
//                    hastop = false
//                    hasleft = false
//                    hasright = false
//                    hasbottom = false
//                    var array4views:Array<UIView> = Array<UIView>()
//                    array4views = []
//                    array4views.append(cell.FIRSTLINE)
//                    array4views.append(cell.SECONDLINE)
//                    array4views.append(cell.THIRSLINE)
//                    array4views.append(cell.FOURTHLINE)
//                    var haseventx:Bool = false
//                    for i:Int in column1  {
//                        //case 1 previous cell has event
//                        //first cell 0
//                        let mainid:Int = column1.indexOf(i)!
//                        if mainid == 0 && i <= 160 && cell.tag == i{
//
//                            if CalendarMatrix[i].2.count > 0 {
//                                print("self.seeifhasPhoneEvent \(self.seeifhasPhoneEvent(i))")
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//                        else if 0 < mainid && i <= 160 && cell.tag == i {
//                            if CalendarMatrix[i].2.count > 0 {
//
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//
//
//                        else if  0 < mainid && i > 160 {
//                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
//                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//                    }
//                    /// 2 3  ...7
//                    for i:Int in column2  {
//                        //case 1 previous cell has event
//                        //first cell 0
//                        let mainid:Int = column2.indexOf(i)!
//                        if mainid == 0 && i <= 160 && cell.tag == i{
//
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//                        else if 0 < mainid && i <= 160 && cell.tag == i {
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//
//
//                        else if  0 < mainid && i > 160 {
//                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
//                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//                    }
//                    for i:Int in column3  {
//                        //case 1 previous cell has event
//                        //first cell 0
//                        let mainid:Int = column3.indexOf(i)!
//                        if mainid == 0 && i <= 160 && cell.tag == i{
//
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
////                                    //one service // 1 views with  color
//                                            cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                            cell.SECONDLINE.backgroundColor = MYARR[0]
//                                            cell.THIRSLINE.backgroundColor = MYARR[0]
//                                            cell.FOURTHLINE.backgroundColor = MYARR[0]
////
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//                        else if 0 < mainid && i <= 160 && cell.tag == i {
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//
//
//                        else if  0 < mainid && i > 160 {
//                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
//                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//                    }
//                    for i:Int in column4  {
//                        //case 1 previous cell has event
//                        //first cell 0
//                        let mainid:Int = column4.indexOf(i)!
//                        if mainid == 0 && i <= 160 && cell.tag == i{
//
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//                        else if 0 < mainid && i <= 160 && cell.tag == i {
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//
//
//                        else if  0 < mainid && i > 160 {
//                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
//                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//                    }
//                    for i:Int in column5  {
//                        //case 1 previous cell has event
//                        //first cell 0
//                        let mainid:Int = column5.indexOf(i)!
//                        if mainid == 0 && i <= 160 && cell.tag == i{
//                            haseventx =  self.seeifhasPhoneEvent(i)
//                            if haseventx == true {
//                                cell.eyeImg.hidden = false
//                            }
//                            if CalendarMatrix[i].2.count > 0 {
//
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//                        else if 0 < mainid && i <= 160 && cell.tag == i {
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//
//
//                        else if  0 < mainid && i > 160 {
//                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
//                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//                    }
//                    for i:Int in column6  {
//                        //case 1 previous cell has event
//                        //first cell 0
//                        let mainid:Int = column6.indexOf(i)!
//                        if mainid == 0 && i <= 160 && cell.tag == i{
//
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//                        else if 0 < mainid && i <= 160 && cell.tag == i {
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//
//
//                        else if  0 < mainid && i > 160 {
//                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
//                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                    //two services // 2 views with different color
//                                       case 2:
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//                    }
//                    for i:Int in column7  {
//                        //case 1 previous cell has event
//                        //first cell 0
//                        let mainid:Int = column7.indexOf(i)!
//                        if mainid == 0 && i <= 160 && cell.tag == i{
//
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//                        else if 0 < mainid && i <= 160 && cell.tag == i {
//                            if CalendarMatrix[i].2.count > 0 {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                    //one service // 1 views with  color
//                                case 1:
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//
//                            }
//                        }
//
//
//                        else if  0 < mainid && i > 160 {
//                            // cell.layer.addBorder(UIRectEdge.Bottom, color: UIColor.darkGrayColor(), thickness: 0.5)
//                            if CalendarMatrix[i].2.count > 0 && cell.tag == i {
//                                haseventx =  self.seeifhasPhoneEvent(i)
//                                if haseventx == true {
//                                    cell.eyeImg.hidden = false
//                                }
//                                var MYARR:Array<UIColor> = Array<UIColor>()
//                                MYARR = self.calculateColorsincell(i)
//                                let countonarray:Int = MYARR.count
//                                switch (countonarray) {
//                                case 1:
//                                    //one service // 1 views with  color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[0]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[0]
//                                    //
//                                case 2:
//                                    //two services // 2 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[0]
//                                    cell.THIRSLINE.backgroundColor = MYARR[1]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[1]
//                                case 3:
//                                    //three services // 3 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                case 4:
//                                    //fours services // 4 views with different color
//                                    cell.FIRSTLINE.backgroundColor = MYARR[0]
//                                    cell.SECONDLINE.backgroundColor = MYARR[1]
//                                    cell.THIRSLINE.backgroundColor = MYARR[2]
//                                    cell.FOURTHLINE.backgroundColor = MYARR[3]
//                                default:
//                                    print("no service")
//                                }
//                            }
//                        }
//                    }
//
//                }
//                cell.patternImg.image = nil
//
//                cell.layer.shouldRasterize = true
//                cell.layer.rasterizationScale = UIScreen.mainScreen().scale
//                tapInsideCEll.delegate = self
//                let myview:UIView = UIView()
//                myview.frame = cell.contentView.frame
//                myview.backgroundColor = UIColor.clearColor()
//                //    myview.backgroundColor = colorWithHexString( "#363636")
//                //\\
//                //\\ cell.eyeImg.hidden = hasEvent
//                cell.bringSubviewToFront(cell.eyeImg)
//                cell.addSubview(myview)
//                myview.tag = cell.tag
//                myview.addGestureRecognizer(tapInsideCEll)
//                cell.bringSubviewToFront(myview)
//
//
//            }
//        }
//        return cell
//    }
//    func seeifhasPhoneEvent(i:Int) -> Bool {
//        var hasEvent:Bool = false
//        if CalendarMatrix[i].2.count > 0 {
//            for j in 0..<CalendarMatrix[i].2.count {
//                let myitem  = CalendarMatrix[i].2[j]
//
//                if myitem.iCoordinatedServiceId == 0  {
//                    print("myitem.iCoordinatedServiceId \(myitem.iCoordinatedServiceId)")
//                    hasEvent = true
//                    //   break
//                }
//            }
//        }
//        return hasEvent
//    }
//    func calculateColorsincell(i:Int) -> Array<UIColor> {
//        var myarr:Array<UIColor> = Array<UIColor>()
//        let howmanylinesinrow:Int = CalendarMatrix[i].2.count
//        var alittlearray:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//        if howmanylinesinrow > 0 {
//            for item in  CalendarMatrix[i].2 {
//                if item.iCoordinatedServiceId > 0 {
//                    if !alittlearray.contains(item) {
//                        alittlearray.append(item)
//
//                    }
//                }
//            }
//        }
//        let howmanybthereinroww:Int = alittlearray.count
//        switch (howmanybthereinroww) {
//        case 1:
//            //one service so all views have same color
//            for item in CalendarMatrix[i].2 {
//                if item.chServiceColor != "" ||  item.chServiceColor != "<null>"  {
//
//                    myarr.append(colorWithHexString(item.chServiceColor))
//                    break
//                }
//            }
//        case 2:
//            //two services // 2 views with different  colour
//            for j in 0..<CalendarMatrix[i].2.count {
//                let myitem  = CalendarMatrix[i].2[j]
//                if myitem.iCoordinatedServiceId > 0 {
//                    if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>" {
//                        myarr.append(colorWithHexString(myitem.chServiceColor))
//
//                    }
//                }
//            }
//        case 3:
//            for j in 0..<CalendarMatrix[i].2.count {
//                let myitem  = CalendarMatrix[i].2[j]
//                if myitem.iCoordinatedServiceId > 0 {
//                    if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>" {
//                        myarr.append(colorWithHexString(myitem.chServiceColor))
//
//                    }
//                }
//            }
//            //three services // 3 views with different color
//            //            let myitem = CalendarMatrix[i].2[0]
//            //            if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>"  {
//            //                myarr.append(colorWithHexString(myitem.chServiceColor))
//            //
//            //            }
//            //            let myitem2 = CalendarMatrix[i].2[1]
//            //            if myitem2.chServiceColor != "" ||  myitem2.chServiceColor != "<null>"  {
//            //                myarr.append(colorWithHexString(myitem2.chServiceColor))
//            //            }
//            //            let myitem3 = CalendarMatrix[i].2[2]
//            //            if myitem3.chServiceColor != "" ||  myitem3.chServiceColor != "<null>"  {
//            //                myarr.append(colorWithHexString(myitem3.chServiceColor))
//            //
//        //            }
//        case 4:
//            //fours services // 4 views with different color
//            //            let myitem = CalendarMatrix[i].2[0]
//            //            if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>"  {
//            //                myarr.append(colorWithHexString(myitem.chServiceColor))
//            //
//            //            }
//            //            let myitem2 = CalendarMatrix[i].2[1]
//            //            if myitem2.chServiceColor != "" ||  myitem2.chServiceColor != "<null>"  {
//            //                 myarr.append(colorWithHexString(myitem2.chServiceColor))
//            //            }
//            //            let myitem3 = CalendarMatrix[i].2[2]
//            //            if myitem3.chServiceColor != "" ||  myitem3.chServiceColor != "<null>"  {
//            //                myarr.append(colorWithHexString(myitem3.chServiceColor))
//            //
//            //            }
//            //            let myitem4 = CalendarMatrix[i].2[3]
//            //            if myitem4.chServiceColor != "" ||  myitem4.chServiceColor != "<null>"  {
//            //                myarr.append(colorWithHexString(myitem4.chServiceColor))
//            //            }
//            for j in 0..<CalendarMatrix[i].2.count {
//                let myitem  = CalendarMatrix[i].2[j]
//                if myitem.iCoordinatedServiceId > 0 {
//                    if myitem.chServiceColor != "" ||  myitem.chServiceColor != "<null>" {
//                        myarr.append(colorWithHexString(myitem.chServiceColor))
//
//                    }
//                }
//            }
//        default:
//            print("no service")
//        }
//        return myarr
//    }
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return 192//
//
//    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0,0,0,0)
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let deviceIdiom = UIScreen.mainScreen().traitCollection.userInterfaceIdiom
//
//        switch (deviceIdiom)  {
//        case .Pad:
//            let widthScreen = UIScreen.mainScreen().bounds.size.width
//            // let heightScreen  = UIScreen.mainScreen().bounds.size.height
//
//            return CGSize(width: collWeek.frame.size.width / 8, height:  collWeek.frame.size.height / 9.3)
//        // return CGSize(width: widthScreen / 8, height:  collWeek.frame.size.height / 9.3)
//        default:
//            return CGSize(width: collWeek.frame.size.width / 8, height:  collWeek.frame.size.width / 9)
//        }
//
//        return CGSize(width: collWeek.frame.size.width / 8, height:  collWeek.frame.size.width / 9)
//
//    }
//    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, UIEdgeInsets indexPath: NSIndexPath) -> UIEdgeInsets {
//
//        return UIEdgeInsetsMake(0, 0,0,0);
//    }
//
//    //MARK: - ScrollView
//
//
//    func setDate()
//    {
//        //the day of week from date - (int)
//        let day:Int = Calendar.sharedInstance.getDayOfWeek(currentDate)! - 1
//
//        let otherDate:NSDate = currentDate
//
//        //show month for each day in week
//        lblDay1.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 6).description
//        lblDay2.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 5).description
//        lblDay3.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 4).description
//        lblDay4.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 3).description
//        lblDay5.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 2).description
//        lblDay6.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 1).description
//        lblDay7.text = Calendar.sharedInstance.reduceAddDay(otherDate, reduce: day, add: 0).description
//
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 6))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 5))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 4))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 3))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 2))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 1))
//        monthArray.append(Calendar.sharedInstance.getMonth(otherDate, reduce: day, add: 0))
//        print("monthArray \(monthArray)")
//
//
//        let componentsEventx = calendar.components([.Day, .Month, .Year], fromDate: dtDateStart)
//        let componentsEndEventx = calendar.components([.Day, .Month, .Year], fromDate: dtDateEnd)
//        var monthName:String = ""
//        var endmonthName:String = ""
//        var yearStart:String = ""
//        var yearEnd:String = ""
//
//
//        let yearEvent:Int = componentsEventx.year
//
//
//        let dateFormatter = NSDateFormatter()
//        let dateFormatterYEAR = NSDateFormatter()
//
//        dateFormatter.dateFormat = "MMM"
//        dateFormatterYEAR.dateFormat = "yyyy"
//
//
//        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
//            dateFormatter.locale = NSLocale(localeIdentifier: "he_IL")
//        } else {
//            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
//        }
//
//
//        monthName = dateFormatter.stringFromDate(dtDateStart)
//        endmonthName = dateFormatter.stringFromDate(dtDateEnd)
//
//        let yearEndEvent:Int = componentsEndEventx.year
//
//
//        yearStart = String(yearEvent)
//        yearEnd = String(yearEndEvent)
//
//        if yearStart != yearEnd {
//            lblDays.text = "\(lblDay7.text!).\(monthName).\(yearStart) - \(lblDay1.text!) .\(endmonthName).\(yearEnd)"
//        } else{
//            if monthName != endmonthName {
//                lblDays.text = "\(lblDay7.text!).\(monthName) - \(lblDay1.text!) .\(endmonthName).\(yearStart)"
//            }
//            else {
//                lblDays.text = "\(lblDay7.text!) - \(lblDay1.text!) .\(monthName).\(yearStart)"
//            }
//        }
//        let components = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
//
//        yearToday =  components.year
//        // - long
//        //NSDateFormatter().monthSymbols[monthToday - 1]
//        //let dayName = NSDateFormatter().weekdaySymbols[day]
//
//        //   lblDate.text = "\(monthName) \(yearToday)"
//    }
//    func getDateFromString(dateString: String)->NSDate
//
//    {
//        var datAMEA:NSDate = NSDate()
//        let dateFormatter2 = NSDateFormatter()
//        dateFormatter2.dateFormat = "dd/MM/yyyy"
//        //\\  dateFormatter.dateStyle = .ShortStyle
//        print("crASH \(dateString)")
//        if let  _ = dateFormatter2.dateFromString(dateString) {
//            datAMEA = dateFormatter2.dateFromString(dateString)!
//            print("datestring \(getDateFromString) si data mea \(datAMEA)")
//        }
//        return datAMEA
//    }
//
//    func emptyCalendarMatrix(){
//        arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]
//        CalendarMatrix = []
//        for inthour in arrHoursInt {
//            for intday in arrayDays {
//                let ax:Int = intday as! Int
//                let fullreservedids:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                CalendarMatrix.append(inthour,ax,fullreservedids)
//            }
//        }
//        print("CalendarMatrix \(CalendarMatrix) and count \(CalendarMatrix.count)")
//    }
//
//    func initALLSECTIONSFINAL() {
//        print("arrayDays \( arrayDays)")
//        ALLSECTIONSFINAL = []
//        ALLSECTIONSFINALFILTERED = []
//
//        // var CalendarMatrix:[(Int,Array<Int>)] = []
//        for inthour in arrHoursInt {
//            ALLSECTIONSFINAL.append(inthour,Array<allKindEventsForListDesign>() )
//            ALLSECTIONSFINALFILTERED.append(inthour,Array<allKindEventsForListDesign>() )
//
//        }
//        CalendarMatrix = []
//        for inthour in arrHoursInt {
//            for intday in arrayDays {
//                let ax:Int = intday as! Int
//                let fullreservedids:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                CalendarMatrix.append(inthour, ax,fullreservedids)
//            }
//        }
//        print("CalendarMatrix \(CalendarMatrix) and count \(CalendarMatrix.count)")
//    }
//
//
//    func calculateDurationofEvent(Event: allKindEventsForListDesign)  -> Int {
//        print("ceva \(Event.fromHour) - \(Event.toHour) ") // 02:00 - 02:15
//        let startDate = Event.fromHour
//        let endDate = Event.toHour
//
//        let startArray = startDate.componentsSeparatedByString(":") // ["23", "51"]
//        let endArray = endDate.componentsSeparatedByString(":") // ["00", "01"]
//
//        let startHours = Int(startArray[0])! * 60 // 1380
//        let startMinutes = Int(startArray[1])! + startHours // 1431
//
//        let endHours = Int(endArray[0])! * 60 // 0
//        let endMinutes = Int(endArray[1])! + endHours // 1
//
//        var timeDifference = endMinutes - startMinutes // -1430
//
//        let day = 24 * 60 // 1440
//
//        if timeDifference < 0 {
//            timeDifference += day // 10
//        }
//        print("cc \(timeDifference)")
//
//        print("cate minute  \(timeDifference)")
//        return timeDifference
//
//
//    }
//
//    func gethourStartEnd(eventx: allKindEventsForListDesign) -> [Int] {
//
//        //fromhour
//        var eventHour:Int = 0
//        var eventHourEnd:Int = 0
//        if let a1:Character =  eventx.fromHour[eventx.fromHour.startIndex] {
//            if a1 == "0" {
//                //now get the real hour
//                if let a2:Character =  eventx.fromHour[eventx.fromHour.startIndex.advancedBy(1)]{
//                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
//                    if a2 == "0" {
//                        //       print("ora1 0 add to 0")
//                        eventHour = 0
//                    }
//                    else {
//                        //      print("ora1 \(a2) add to \(a2)") //section
//                        let str = String(a2)
//                        let IntHOUR:Int = Int(str)!
//                        eventHour = IntHOUR
//
//                    }
//                }
//            }
//            else { //full hour 2 chars
//                let fullNameArr = eventx.fromHour.componentsSeparatedByString(":")
//                let size = fullNameArr.count
//                if(size > 1 ) {
//                    if let _:String = fullNameArr[0]  {
//                        let hourstring:String = fullNameArr[0]
//                        let numberFromString:Int = Int(hourstring)!
//                        eventHour = numberFromString
//                    }
//                }
//            }
//        }
//        ////tohour
//        if let a1:Character =  eventx.toHour[eventx.toHour.startIndex] {
//            if a1 == "0" {
//                //now get the real hour
//                if let a2:Character =  eventx.toHour[eventx.toHour.startIndex.advancedBy(1)]{
//                    if a2 == "0" {
//                        //    print("ora1 0 add to 0")
//                        eventHourEnd = 0
//                    }
//                    else {
//                        //    print("ora1 \(a2) add to \(a2)") //section
//                        let str = String(a2)
//                        let IntHOUR:Int = Int(str)!
//                        eventHourEnd = IntHOUR
//
//                    }
//                }
//            }
//            else { //full hour 2 chars
//                let fullNameArr = eventx.toHour.componentsSeparatedByString(":")
//                let size = fullNameArr.count
//                if(size > 1 ) {
//                    if let _:String = fullNameArr[0]  {
//                        let hourstring:String = fullNameArr[0]
//                        let numberFromString:Int = Int(hourstring)!
//                        eventHourEnd = numberFromString
//                    }
//                }
//            }
//        }
//        return [eventHour,eventHourEnd]
//
//
//    }
//
//    func setEventsArray(today:NSDate)  {
//
//    }
//    func setEventsArrayx() {
//        /*
//         CalendarMatrix [(0, 18, []), (0, 17, []), (0, 16, []), (0, 15, []), (0, 14, []), (0, 13, []), (0, 12, []), (1, 18, []), (1, 17, []), (1, 16, []), (1, 15, []), (1, 14, []), (1, 13, []), (1, 12, []), (2, 18, []), (2, 17, []), (2, 16, []), (2, 15, []), (2, 14, []), (2, 13, []), (2, 12, []), (3, 18, []), (3, 17, []), (3, 16, []), (3, 15, []), (3, 14, []), (3, 13, []), (3, 12, []), (4, 18, []), (4, 17, []), (4, 16, []), (4, 15, []), (4, 14, []), (4, 13, []), (4, 12, []), (5, 18, []), (5, 17, []), (5, 16, []), (5, 15, []), (5, 14, []), (5, 13, []), (5, 12, []), (6, 18, []), (6, 17, []), (6, 16, []), (6, 15, []), (6, 14, []), (6, 13, []), (6, 12, []), (7, 18, []), (7, 17, []), (7, 16, []), (7, 15, []), (7, 14, []), (7, 13, []), (7, 12, []), (8, 18, []), (8, 17, []), (8, 16, []), (8, 15, []), (8, 14, []), (8, 13, []), (8, 12, []), (9, 18, []), (9, 17, []), (9, 16, []), (9, 15, []), (9, 14, []), (9, 13, []), (9, 12, []), (10, 18, []), (10, 17, []), (10, 16, []), (10, 15, []), (10, 14, []), (10, 13, []), (10, 12, []), (11, 18, []), (11, 17, []), (11, 16, []), (11, 15, []), (11, 14, []), (11, 13, []), (11, 12, []), (12, 18, []), (12, 17, []), (12, 16, []), (12, 15, []), (12, 14, []), (12, 13, []), (12, 12, []), (13, 18, []), (13, 17, []), (13, 16, []), (13, 15, []), (13, 14, []), (13, 13, []), (13, 12, []), (14, 18, []), (14, 17, []), (14, 16, []), (14, 15, []), (14, 14, []), (14, 13, []), (14, 12, []), (15, 18, []), (15, 17, []), (15, 16, []), (15, 15, []), (15, 14, []), (15, 13, []), (15, 12, []), (16, 18, []), (16, 17, []), (16, 16, []), (16, 15, []), (16, 14, []), (16, 13, []), (16, 12, []), (17, 18, []), (17, 17, []), (17, 16, []), (17, 15, []), (17, 14, []), (17, 13, []), (17, 12, []), (18, 18, []), (18, 17, []), (18, 16, []), (18, 15, []), (18, 14, []), (18, 13, []), (18, 12, []), (19, 18, []), (19, 17, []), (19, 16, []), (19, 15, []), (19, 14, []), (19, 13, []), (19, 12, []), (20, 18, []), (20, 17, []), (20, 16, []), (20, 15, []), (20, 14, []), (20, 13, []), (20, 12, []), (21, 18, []), (21, 17, []), (21, 16, []), (21, 15, []), (21, 14, []), (21, 13, []), (21, 12, []), (22, 18, []), (22, 17, []), (22, 16, []), (22, 15, []), (22, 14, []), (22, 13, []), (22, 12, []), (23, 18, []), (23, 17, []), (23, 16, []), (23, 15, []), (23, 14, []), (23, 13, []), (23, 12, [])
//         //////////////////////////
//         For CalendarMatrix=1 to 168
//         {
//         if OriginalMeetingsArray[i].StartHour>=CalendarMatrix[j].Hour     or  OriginalMeetingsArray[i].EndHour<=CalendarMatrix[j].Hour
//         then Add(CalendarMatrix[j].Objects , OriginalMeetingsArray[i].ID)
//         }
//         }
//
//         */
//        emptyCalendarMatrix()
//
//
//
//        //   var bthevent:allKindEventsForListDesign = allKindEventsForListDesign()
//        arrEventsCurrentDay = []
//
//        for i in 0..<7
//        {
//            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
//
//            let curentTempDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1)
//            let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: curentTempDate)
//            //\\print ("curDate \(curentTempDate)")
//            // let  yearTodayx =  componentsCurrent.year
//            //  let monthTodayx = componentsCurrent.month
//            let dayTodayx = componentsCurrent.day
//            for itemx in PERFECTSENSE {
//                let eventx = itemx
//                let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: eventx.dateEvent)
//                //                            let yearEvent =  componentsEvent.year
//                //                            let monthEvent = componentsEvent.month
//                let dayEvent = componentsEvent.day
//
//
//                //  //\\print ("curDate \(curentTempDate) yearTodayx \(yearTodayx) monthTodayx\(monthTodayx) dayTodayx \(dayTodayx) \n yearEvent\(yearEvent) monthEvent\(monthEvent) dayEvent\(dayEvent) ")
//                //\\print ("curDate \(curentTempDate)  dayTodayx \(dayTodayx)  dayEvent\(dayEvent) ")
//                if /*yearEvent == yearTodayx && monthEvent == monthTodayx   && */ dayEvent == dayTodayx {
//                    for   j in 0 ..< CalendarMatrix.count {
//                        if CalendarMatrix[j].1 == dayTodayx {
//                            var eventHour:Int = 0
//                            var eventHourEnd:Int = 0
//                            var  HoursArray = [Int]()
//                            HoursArray = gethourStartEnd(eventx)
//                            eventHour = HoursArray[0]
//                            eventHourEnd = HoursArray[1]
//                            //\\print ("eventHour \(eventHour) eventHourEnd \(eventHourEnd)")
//                            //1 row
//                            if  eventHour == CalendarMatrix[j].0 {  //hourstart only clear matrix ordered by start h
//                                let ay:Int = eventx.iCoordinatedServiceId
//                                let worker:Int = eventx.iProviderUserId
//                                print("WEEK idSupplierWorker \(Global.sharedInstance.defaults.integerForKey("idSupplierWorker"))")
//                                if Global.sharedInstance.defaults.integerForKey("idSupplierWorker") == -1 {
//                                    if !CalendarMatrix[j].2.contains(eventx) {
//                                        if eventHour == eventHourEnd {
//
//                                            let howmanyminutesstart = self.gethoursandminuteforevent(eventx)[1]
//                                            let howmanyminuteend = self.gethoursandminuteforevent(eventx)[3]
//                                            if howmanyminutesstart >= 0 &&  howmanyminuteend <= 15 {
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [1]
//                                                eventx.viewsforweek.append(e)
//                                                //     print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if ( howmanyminutesstart > 15 &&  howmanyminuteend <= 30 ){
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [2]
//                                                eventx.viewsforweek.append(e)
//                                                //      print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if ( howmanyminutesstart > 30 &&  howmanyminuteend <= 45 ){
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [3]
//                                                eventx.viewsforweek.append(e)
//                                                //     print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if ( howmanyminutesstart > 45 &&  howmanyminuteend <= 60 ){
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [4]
//                                                eventx.viewsforweek.append(e)
//                                                //    print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//
//                                            if howmanyminutesstart >= 0  &&  howmanyminuteend <= 30 {
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [1,2]
//                                                eventx.viewsforweek.append(e)
//
//                                                //  print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if howmanyminutesstart >= 0  &&  howmanyminuteend <= 45 {
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [1,2,3]
//                                                eventx.viewsforweek.append(e)
//
//                                                //   print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if howmanyminutesstart >= 0  &&  howmanyminuteend <= 60 {
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [1,2,3,4]
//                                                eventx.viewsforweek.append(e)
//
//                                                //  print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//
//                                        }
//
//                                        CalendarMatrix[j].2.append(eventx)
//
//                                        hasEvent = true
//                                        //\\print ("common  \(ay ) eventx \(eventx)")
//                                        if eventHour < eventHourEnd {
//                                            for z:Int in eventHour...eventHourEnd {
//                                                print("where i is needed \(i)")
//                                                for   j in 0 ..< CalendarMatrix.count {
//                                                    if CalendarMatrix[j].1 == dayTodayx {
//                                                        if CalendarMatrix[j].0 == z {
//
//
//                                                            //conditions for views here
//                                                            if  z == eventHour {
//
//                                                                let howmanyminutesstart = self.gethoursandminuteforevent(eventx)[1]
//                                                                if howmanyminutesstart >= 0 &&  howmanyminutesstart <= 15 {
//                                                                    var e:Array<Int> = Array<Int>()
//                                                                    e = [1,2,3,4]
//                                                                    eventx.viewsforweek.append(e)
//
//                                                                    print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                    break
//                                                                }
//                                                                if ( howmanyminutesstart > 15 &&  howmanyminutesstart <= 30 ){
//                                                                    var e:Array<Int> = Array<Int>()
//                                                                    e = [2,3,4]
//                                                                    eventx.viewsforweek.append(e)
//
//                                                                    print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                    break
//                                                                }
//                                                                if ( howmanyminutesstart > 30 &&  howmanyminutesstart <= 45 ){
//                                                                    var e:Array<Int> = Array<Int>()
//                                                                    e = [3,4]
//                                                                    eventx.viewsforweek.append(e)
//
//                                                                    print(" eventx.viewsforweek \( eventx.viewsforweek)")
//
//                                                                    break
//                                                                }
//                                                                if ( howmanyminutesstart > 45 &&  howmanyminutesstart <= 60 ){
//                                                                    var e:Array<Int> = Array<Int>()
//                                                                    e = [4]
//                                                                    eventx.viewsforweek.append(e)
//                                                                    print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                    break
//                                                                }
//
//                                                                if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 30 {
//                                                                    var e:Array<Int> = Array<Int>()
//                                                                    e = [1,2]
//                                                                    eventx.viewsforweek.append(e)
//
//                                                                    print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                    break
//                                                                }
//                                                                if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 45 {
//                                                                    var e:Array<Int> = Array<Int>()
//                                                                    e = [1,2,3]
//                                                                    eventx.viewsforweek.append(e)
//
//                                                                    print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                    break
//                                                                }
//                                                                if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 60 {
//                                                                    var e:Array<Int> = Array<Int>()
//                                                                    e = [1,2,3,4]
//                                                                    eventx.viewsforweek.append(e)
//
//                                                                    print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                    break
//                                                                }
//                                                                //                                                                        if !CalendarMatrix[j].2.contains(eventx) {
//                                                                //                                                                            CalendarMatrix[j].2.append(eventx)
//                                                                //                                                                            hasEvent = true
//                                                                //
//                                                                //                                                                        }
//                                                            } else
//                                                                if  z == eventHourEnd {
//
//                                                                    print("this is the end h \(eventx.toHour)")
//                                                                    let howmanyminutesstart = self.gethoursandminuteforevent(eventx)[3]
//                                                                    if howmanyminutesstart >= 0 &&  howmanyminutesstart <= 15 {
//                                                                        var e:Array<Int> = Array<Int>()
//                                                                        e = [1]
//                                                                        eventx.viewsforweek.append(e)
//                                                                        print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                        break
//                                                                    }
//
//
//                                                                    if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 30 {
//                                                                        var e:Array<Int> = Array<Int>()
//                                                                        e = [1,2]
//                                                                        eventx.viewsforweek.append(e)
//
//                                                                        print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                        break
//                                                                    }
//                                                                    if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 45 {
//                                                                        var e:Array<Int> = Array<Int>()
//                                                                        e = [1,2,3]
//                                                                        eventx.viewsforweek.append(e)
//
//                                                                        print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                        break
//                                                                    }
//                                                                    if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 60 {
//                                                                        var e:Array<Int> = Array<Int>()
//                                                                        e = [1,2,3,4]
//                                                                        eventx.viewsforweek.append(e)
//
//                                                                        print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                        break
//                                                                    }
//                                                                    //                                                                            if !CalendarMatrix[j].2.contains(eventx) {
//                                                                    //                                                                                CalendarMatrix[j].2.append(eventx)
//                                                                    //                                                                                hasEvent = true
//                                                                    //
//                                                                    //                                                                            }
//                                                                } else { //betweenhours are full
//                                                                    var e:Array<Int> = Array<Int>()
//                                                                    e = [1,2,3,4]
//                                                                    eventx.viewsforweek.append(e)
//                                                                    print(" eventx.viewsforweek all four \( eventx.viewsforweek)")
//                                                                    //                                                                            if !CalendarMatrix[j].2.contains(eventx) {
//                                                                    //                                                                                CalendarMatrix[j].2.append(eventx)
//                                                                    //                                                                                hasEvent = true
//                                                                    //
//                                                                    //}
//                                                            }
//
//                                                            CalendarMatrix[j].2.append(eventx)
//                                                            hasEvent = true
//                                                            //\\print ("added ending  \(ay ) eventx \(eventx)")
//
//                                                            //dele before
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }
//
//                                    if eventx.iCoordinatedServiceId == 0 {
//                                        if !CalendarMatrix[j].2.contains(eventx) {
//                                            CalendarMatrix[j].2.append(eventx)
//                                        }
//                                    }
//
//                                } else if Global.sharedInstance.defaults.integerForKey("idSupplierWorker") > 0 && worker == Global.sharedInstance.defaults.integerForKey("idSupplierWorker") {
//
//                                    if !CalendarMatrix[j].2.contains(eventx) {
//                                        if eventHour == eventHourEnd {
//
//                                            let howmanyminutesstart = self.gethoursandminuteforevent(eventx)[1]
//                                            let howmanyminuteend = self.gethoursandminuteforevent(eventx)[3]
//                                            if howmanyminutesstart >= 0 &&  howmanyminuteend <= 15 {
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [1]
//                                                eventx.viewsforweek.append(e)
//                                           //     print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if ( howmanyminutesstart > 15 &&  howmanyminuteend <= 30 ){
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [2]
//                                                eventx.viewsforweek.append(e)
//                                          //      print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if ( howmanyminutesstart > 30 &&  howmanyminuteend <= 45 ){
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [3]
//                                                eventx.viewsforweek.append(e)
//                                           //     print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if ( howmanyminutesstart > 45 &&  howmanyminuteend <= 60 ){
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [4]
//                                                eventx.viewsforweek.append(e)
//                                            //    print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//
//                                            if howmanyminutesstart >= 0  &&  howmanyminuteend <= 30 {
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [1,2]
//                                                eventx.viewsforweek.append(e)
//
//                                              //  print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if howmanyminutesstart >= 0  &&  howmanyminuteend <= 45 {
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [1,2,3]
//                                                eventx.viewsforweek.append(e)
//
//                                             //   print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//                                            if howmanyminutesstart >= 0  &&  howmanyminuteend <= 60 {
//                                                var e:Array<Int> = Array<Int>()
//                                                e = [1,2,3,4]
//                                                eventx.viewsforweek.append(e)
//
//                                              //  print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                break
//                                            }
//
//                                        }
//
//                                        CalendarMatrix[j].2.append(eventx)
//
//                                        hasEvent = true
//                                        //\\print ("common  \(ay ) eventx \(eventx)")
//                                        if eventHour < eventHourEnd {
//                                            for z:Int in eventHour...eventHourEnd {
//                                                print("where i is needed \(i)")
//                                                for   j in 0 ..< CalendarMatrix.count {
//                                                    if CalendarMatrix[j].1 == dayTodayx {
//                                                        if CalendarMatrix[j].0 == z {
//
//
//                                                                    //conditions for views here
//                                                                    if  z == eventHour {
//
//                                                                        let howmanyminutesstart = self.gethoursandminuteforevent(eventx)[1]
//                                                                        if howmanyminutesstart >= 0 &&  howmanyminutesstart <= 15 {
//                                                                            var e:Array<Int> = Array<Int>()
//                                                                            e = [1,2,3,4]
//                                                                            eventx.viewsforweek.append(e)
//
//                                                                              print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                            break
//                                                                        }
//                                                                        if ( howmanyminutesstart > 15 &&  howmanyminutesstart <= 30 ){
//                                                                            var e:Array<Int> = Array<Int>()
//                                                                            e = [2,3,4]
//                                                                            eventx.viewsforweek.append(e)
//
//                                                                              print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                            break
//                                                                        }
//                                                                        if ( howmanyminutesstart > 30 &&  howmanyminutesstart <= 45 ){
//                                                                            var e:Array<Int> = Array<Int>()
//                                                                            e = [3,4]
//                                                                            eventx.viewsforweek.append(e)
//
//                                                                              print(" eventx.viewsforweek \( eventx.viewsforweek)")
//
//                                                                            break
//                                                                        }
//                                                                        if ( howmanyminutesstart > 45 &&  howmanyminutesstart <= 60 ){
//                                                                            var e:Array<Int> = Array<Int>()
//                                                                            e = [4]
//                                                                            eventx.viewsforweek.append(e)
//                                                                              print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                            break
//                                                                        }
//
//                                                                        if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 30 {
//                                                                            var e:Array<Int> = Array<Int>()
//                                                                            e = [1,2]
//                                                                            eventx.viewsforweek.append(e)
//
//                                                                              print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                            break
//                                                                        }
//                                                                        if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 45 {
//                                                                            var e:Array<Int> = Array<Int>()
//                                                                            e = [1,2,3]
//                                                                            eventx.viewsforweek.append(e)
//
//                                                                              print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                            break
//                                                                        }
//                                                                        if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 60 {
//                                                                            var e:Array<Int> = Array<Int>()
//                                                                            e = [1,2,3,4]
//                                                                            eventx.viewsforweek.append(e)
//
//                                                                              print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                            break
//                                                                        }
////                                                                        if !CalendarMatrix[j].2.contains(eventx) {
////                                                                            CalendarMatrix[j].2.append(eventx)
////                                                                            hasEvent = true
////
////                                                                        }
//                                                                    } else
//                                                                        if  z == eventHourEnd {
//
//                                                                            print("this is the end h \(eventx.toHour)")
//                                                                            let howmanyminutesstart = self.gethoursandminuteforevent(eventx)[3]
//                                                                            if howmanyminutesstart >= 0 &&  howmanyminutesstart <= 15 {
//                                                                                var e:Array<Int> = Array<Int>()
//                                                                                e = [1]
//                                                                                eventx.viewsforweek.append(e)
//                                                                                  print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                                break
//                                                                            }
//
//
//                                                                            if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 30 {
//                                                                                var e:Array<Int> = Array<Int>()
//                                                                                e = [1,2]
//                                                                                eventx.viewsforweek.append(e)
//
//                                                                                  print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                                break
//                                                                            }
//                                                                            if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 45 {
//                                                                                var e:Array<Int> = Array<Int>()
//                                                                                e = [1,2,3]
//                                                                                eventx.viewsforweek.append(e)
//
//                                                                                  print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                                break
//                                                                            }
//                                                                            if howmanyminutesstart >= 0  &&  howmanyminutesstart <= 60 {
//                                                                                var e:Array<Int> = Array<Int>()
//                                                                                e = [1,2,3,4]
//                                                                                eventx.viewsforweek.append(e)
//
//                                                                                  print(" eventx.viewsforweek \( eventx.viewsforweek)")
//                                                                                break
//                                                                            }
////                                                                            if !CalendarMatrix[j].2.contains(eventx) {
////                                                                                CalendarMatrix[j].2.append(eventx)
////                                                                                hasEvent = true
////
////                                                                            }
//                                                                        } else { //betweenhours are full
//                                                                            var e:Array<Int> = Array<Int>()
//                                                                            e = [1,2,3,4]
//                                                                            eventx.viewsforweek.append(e)
//                                                                            print(" eventx.viewsforweek all four \( eventx.viewsforweek)")
////                                                                            if !CalendarMatrix[j].2.contains(eventx) {
////                                                                                CalendarMatrix[j].2.append(eventx)
////                                                                                hasEvent = true
////
//                                                                            //}
//                                                            }
//
//                                                                CalendarMatrix[j].2.append(eventx)
//                                                                hasEvent = true
//                                                                //\\print ("added ending  \(ay ) eventx \(eventx)")
//
//                                                       //dele before
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }
//                                } //add also user phone events
//                                if eventx.iCoordinatedServiceId == 0 {
//                                    if !CalendarMatrix[j].2.contains(eventx) {
//                                        print("eventx  in phone \(eventx.title) si ora \(eventx.fromHour)")
//                                        CalendarMatrix[j].2.append(eventx)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//
//
//        print("End CalendarMatrix \(CalendarMatrix) si count \(CalendarMatrix.count)")
//        //        if NOLOAD == true {
//        //           NOLOAD = false
//
//        if self.FROMPRINT == true {
//
//            self.TRYPDFJUSTNOW()
//            self.FROMPRINT = false
//        }
//        // }
//        sortandjoinarrays()
//
//        //now add to hours interval beetwen start end
//
//
//
//        //                                    if (CalendarMatrix[j].0 == 23 && eventHour >= CalendarMatrix[j].0 - 1 && eventHour <= CalendarMatrix[j].0) {
//        //                                        let ay:Int = eventx.iCoordinatedServiceId
//        //                                        if !CalendarMatrix[j].2.contains(eventx) {
//        //                                            CalendarMatrix[j].2.append(eventx)
//        //                                            hasEvent = true
//        //                                            //\\print ("common ai hour 23 end 24 \(ay ) eventx \(eventx)")
//        //                                        }
//        //                                    }
//        //                                    if (23 >= CalendarMatrix[j].0 > 0 && eventHour >= CalendarMatrix[j].0 && eventHourEnd <= CalendarMatrix[j].0 + 1) {
//        //                                        let ay:Int = eventx.iCoordinatedServiceId
//        //                                        if !CalendarMatrix[j].2.contains(eventx) {
//        //                                            CalendarMatrix[j].2.append(eventx)
//        //                                            hasEvent = true
//        //                                            //\\print ("common ai hour inside 1 23 \(ay ) eventx \(eventx)")
//        //                                        }
//        //                                    }
//
//
//        //
//        //                                    if (eventHour >= CalendarMatrix[j].0 && eventHour <= CalendarMatrix[j].0)) ||  //On first cell checking only strating hour
//        //                                        (j == CalendarMatrix.count-1 && (eventHourEnd <= CalendarMatrix[j].0 && eventHourEnd >= CalendarMatrix[j-7].0)) || // On last cell checking only ending hour
//        //                                      (eventHour >= CalendarMatrix[j].0 && eventHour <= CalendarMatrix[j].0) || (eventHourEnd <= CalendarMatrix[j].0 && eventHourEnd >= CalendarMatrix[j].0 ) )//on every other cell checking both
//        //                                    { //insertion
//        //                                    let ay:Int = eventx.iCoordinatedServiceId
//        //                                    if !CalendarMatrix[j].2.contains(eventx) {
//        //                                        CalendarMatrix[j].2.append(eventx)
//        //                                         hasEvent = true
//        //                                        //\\print ("common ai \(ay ) eventx \(eventx)")
//        //                                    }
//        //                                    }
//
//
//    }
//    func sortandjoinarrays() {
//
//        // dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        self.refreshControl.endRefreshing()
//        //   })
//
//        //  self.bubbleSort( arrEventsCurrentDay)
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//
//            self.collWeek.reloadData()
//
//        })
//
//        self.carousel.delegate = self
//        self.carousel.dataSource = self
//        // self.carousel.setNeedsLayout()
//        if self.arrayWorkers.count > 1 {
//            self.carousel.type = .Linear
//        } else {
//            self.carousel.type = .Linear
//            self.carousel.userInteractionEnabled = false
//        }
//
//        if self.arrayWorkers.count > 0 {
//            if Global.sharedInstance.defaults.integerForKey("idSupplierWorker") == -1 {
//
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    //   self.carousel.scrollToItemAtIndex(1, animated: true)
//
//                    self.carousel.scrollToItemAtIndex(0, animated: true)
//
//                    //  self.carouselCurrentItemIndexDidChange(self.carousel)
//                })
//            } else {
//                //get previous selected worker from array
//                var x:Int = 0
//                let delucru:NSMutableArray =  self.arrayWorkers
//                for item in delucru {
//                    if let _:User = item as? User {
//                        let workerdic:User = item as! User
//                        let diciuserid:Int = workerdic.iUserId
//
//                        print(" diciuserid\(diciuserid)")
//                        let iuseridselect:Int = Global.sharedInstance.defaults.integerForKey("idSupplierWorker")
//                        if diciuserid == iuseridselect {
//
//                            x = delucru.indexOfObject(workerdic)
//                            print("week am gasit worker selectat anterior \(diciuserid) la index \(x)")
//
//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//
//                                self.carousel.scrollToItemAtIndex(x, animated: true)
//
//                                //        self.carouselCurrentItemIndexDidChange(self.carousel)
//                            })
//
//
//
//                        }
//                    }
//                }
//            }
//        }
//
//
//    }
//    func getEventsArray(today:NSDate)
//    {
//        arrEventsCurrentDay = []
//
//
//        if   Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true {
//            PERFECTSENSE = Array<allKindEventsForListDesign>()
//            for  item in sortDicEvents
//            {
//
//
//                print("myitem now \(item)")
//                //30/11/2016", [<Bthere.allKindEventsForListDesign: 0x1701ffd00>]
//                if let _:String = item.0  {
//                    let eventdate:String = item.0
//
//                    if  let EVENTDATE:NSDate = getDateFromString(eventdate) {
//                        let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
//
//                        let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: EVENTDATE)
//
//                        yearToday =  componentsCurrent.year
//                        monthToday = componentsCurrent.month
//                        dayToday = componentsCurrent.day
//
//                        let yearEvent =  componentsEvent.year
//                        let monthEvent = componentsEvent.month
//                        //     let dayEvent = componentsEvent.day
//
//                        if yearEvent == yearToday && monthEvent == monthToday                         {
//                            //     arrEventsCurrentDay.append(item)
//                            for myx in item.1 {
//                                if !PERFECTSENSE.contains(myx) {
//
//                                    print("myx title \(myx.title)")
//                                    PERFECTSENSE.append(myx)
//
//                                }
//
//                            }
//                            hasEvent = true
//                        }
//                    }
//                }
//
//            }
//        }else {
//            //sortDicBTHEREevent
//            PERFECTSENSE = Array<allKindEventsForListDesign>()
//            for  itemx in sortDicBTHEREevent
//            {
//                // for event in sortDicEvents//כל הארועים
//                print("myitemx now \(itemx)")
//                //30/11/2016", [<Bthere.allKindEventsForListDesign: 0x1701ffd00>]
//                if let _:String = itemx.0  {
//                    let eventdate:String = itemx.0
//
//                    if  let EVENTDATE:NSDate = getDateFromString(eventdate)  {
//
//
//                        let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
//
//                        let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: EVENTDATE)
//
//                        yearToday =  componentsCurrent.year
//                        monthToday = componentsCurrent.month
//                        dayToday = componentsCurrent.day
//
//                        let yearEvent =  componentsEvent.year
//                        let monthEvent = componentsEvent.month
//                        //     let dayEvent = componentsEvent.day
//
//                        //                        if yearEvent == yearToday  && monthEvent == monthToday
//                        //                        {
//                        // arrEventsCurrentDay.append(itemx)
//                        hasEvent = true
//                        for myx in itemx.1 {
//                            if !PERFECTSENSE.contains(myx) {
//
//                                print("myx title \(myx.title)")
//                                PERFECTSENSE.append(myx)
//
//                            }
//                            //  }
//                        }
//                        print("ce e in arie \(PERFECTSENSE.count)")
//                    }
//                }
//            }
//        }
//
//        // DAYEventstohours()
//
//        initALLSECTIONSFINAL()
//        setDate()
//        setEventsArrayx()
//        setDateEnablity()
//
//
//    }
//
//
//    //check which date is small
//    internal func small(lhs: NSDate, rhs: NSDate) -> Bool {
//        let calendar:NSCalendar = NSCalendar.currentCalendar()
//        let isToday:Bool = calendar.isDateInToday(lhs);
//        if isToday
//        {
//            return false
//        }
//        else
//        {
//            return lhs.compare(rhs) == .OrderedAscending
//        }
//    }
//    // if eye design is set on  need to show device event
//    func showSync()
//    {
//        if btnSyncWithGoogelSupplier.isCecked == false
//        {
//            Global.sharedInstance.getEventsFromMyCalendar()
//            btnSyncWithGoogelSupplier.isCecked = true
//            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.getEventsArray(self.currentDate)
//
//            })
//
//        }
//        else
//        {
//            btnSyncWithGoogelSupplier.isCecked = false
//            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = false
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.getEventsArray(self.currentDate)
//
//            })
//
//        }
//
//    }
//    //JMODE CLEAN AND VERIFYED
//    //GetCustomersOrdersByDateForSupplier(int iSupplierId, DateTime dtDateStart, DateTime dtDateEnd)
//    func GetCustomersOrdersByDateForSupplier()
//    {
//        //     refreshControl.endRefreshing()
//        self.myArray = []
//        Global.sharedInstance.ordersOfClientsArray = []
//        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
//        //empty first
//
//        //JMODE in order to get customer's appoinments for current provider and not all of them
//        var providerID:Int = 0
//        if Global.sharedInstance.providerID == 0 {
//            providerID = 0
//            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
//                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//                //  Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//            }
//        } else {
//            providerID = Global.sharedInstance.providerID
//        }
//        //we take data for 3 months
//
//        dic["dtDateStart"] = Global.sharedInstance.convertNSDateToString(dtDateStart)
//        dic["dtDateEnd"] = Global.sharedInstance.convertNSDateToString(dtDateEnd)
//        print ("dtDateStart a \(dtDateStart) dtDateEnd \(dtDateEnd) ")
//        dic["iSupplierId"] = providerID
//        self.generic.showNativeActivityIndicator(self)
//        if Reachability.isConnectedToNetwork() == false
//        {
//            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//        }
//        else
//        {
//            api.sharedInstance.GetCustomersOrdersByDateForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
//                //GENERIC DATA IF YOU WANT TO HAVE A JSON AND METHOD DID NOT WORK api.sharedInstance.GetCustomersOrdersForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                //\\print(responseObject["Result"])
//                var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>() //empty first
//                if let _: Array<Dictionary<String, AnyObject>> = responseObject["Result"] as?  Array<Dictionary<String, AnyObject>>
//                {
//                    let ps:OrderDetailsObj = OrderDetailsObj()
//
//                    ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(responseObject["Result"] as! Array<Dictionary<String,AnyObject>>)
//                }
//                if let _ = responseObject["Result"] as? NSArray {
//
//                    let REZULTATE:NSArray = responseObject["Result"] as! NSArray
//                    let newarray:NSMutableArray = REZULTATE.mutableCopy() as! NSMutableArray
//
//                    for item in REZULTATE {
//                        let d:NSDictionary = item as! NSDictionary
//                        //\\print ("AM GASIT \(d.description)")
//                    }
//                    self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
//                    //MYordersOfClientsArray
//
//                }
//
//
//
//                //                return
//
//                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//            })
//        }
//    }
//    //GetCustomersOrdersByDateForEmployeeId(int iUserId, DateTime dtDateStart, DateTime dtDateEnd)
//    func GetCustomersOrdersByDateForEmployeeId()
//    {
//        //    refreshControl.endRefreshing()
//        self.myArray = []
//        Global.sharedInstance.ordersOfClientsArray = []
//        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
//        //empty first
//
//        //JMODE in order to get customer's appoinments for current provider and not all of them
//        //we take data for 3 months
//
//        var y:Int = 0
//        let a:NSDictionary = (Global.sharedInstance.defaults.objectForKey("currentUserId") as? NSDictionary)!
//        if let x:Int = a.valueForKey("currentUserId") as? Int{
//            y = x
//        }
//        // Global.sharedInstance.defaults.integerForKey("idSupplierWorker")
//        dic["dtDateStart"] = Global.sharedInstance.convertNSDateToString(dtDateStart)
//        dic["dtDateEnd"] = Global.sharedInstance.convertNSDateToString(dtDateEnd)
//        //\\print ("dtDateStart \(dtDateStart) dtDateEnd \(dtDateEnd) ")
//        dic["iUserId"] = y
//        //\\ NU UITA dic["iUserId"] = y
//        /////  dic["iUserId"] = 235
//        //        if Global.sharedInstance.defaults.integerForKey("idSupplierWorker") > 0 {
//        //            dic["iUserId"] = Global.sharedInstance.defaults.integerForKey("idSupplierWorker")
//        //        }
//        self.generic.showNativeActivityIndicator(self)
//        if Reachability.isConnectedToNetwork() == false
//        {
//            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//        }
//        else
//        {
//            api.sharedInstance.GetCustomersOrdersByDateForEmployeeId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
//                //GENERIC DATA IF YOU WANT TO HAVE A JSON AND METHOD DID NOT WORK api.sharedInstance.GetCustomersOrdersForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                //\\print(responseObject["Result"])
//                var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>() //empty first
//                if let _: Array<Dictionary<String, AnyObject>> = responseObject["Result"] as?  Array<Dictionary<String, AnyObject>>
//                {
//                    let ps:OrderDetailsObj = OrderDetailsObj()
//
//                    ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(responseObject["Result"] as! Array<Dictionary<String,AnyObject>>)
//                }
//                if let _ = responseObject["Result"] as? NSArray {
//
//                    let REZULTATE:NSArray = responseObject["Result"] as! NSArray
//                    let newarray:NSMutableArray = REZULTATE.mutableCopy() as! NSMutableArray
//
//                    //                for item in REZULTATE {
//                    //                    let d:NSDictionary = item as! NSDictionary
//                    //                    //\\print ("AM GASIT \(d.description)")
//                    //                }
//                    self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
//                    //MYordersOfClientsArray
//
//                }
//
//
//
//                //                return
//
//                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//            })
//        }
//    }
//
//    //    func GetCustomersOrdersForSupplier()
//    //    {
//    //
//    //
//    //
//    //        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
//    //        //empty first
//    //
//    //        //JMODE in order to get customer's appoinments for current provider and not all of them
//    //        var providerID:Int = 0
//    //        if Global.sharedInstance.providerID == 0 {
//    //            providerID = 0
//    //            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
//    //                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//    //                //  Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//    //            }
//    //        } else {
//    //            providerID = Global.sharedInstance.providerID
//    //        }
//    //        //we take data for 3 months
//    //
//    //        if iFilterByMonth - 1 >= 0 {
//    //            iFilterByMonth = iFilterByMonth - 1
//    //           // iFilterByYear = year
//    //        } else if iFilterByMonth - 1 == 0 {
//    //            iFilterByMonth = 12
//    //            iFilterByYear = iFilterByYear - 1
//    //        } else {
//    //            iFilterByMonth = 12 - 1 - iFilterByMonth
//    //            iFilterByYear = iFilterByYear - 1
//    //        }
//    //        if iFilterByMonth + 1 <= 12 {
//    //            iFilterByMonthEnd = iFilterByMonth + 2
//    //            iFilterByYearEnd = iFilterByYear
//    //        } else if iFilterByMonth + 1 > 12 {
//    //            iFilterByMonthEnd = 1
//    //            iFilterByYearEnd = iFilterByYear + 1
//    //        }
//    //
//    //
//    //        dic["iFilterByMonth"] = iFilterByMonth
//    //        dic["iFilterByYear"] = iFilterByYear
//    //        //on two months here
//    //        dic["iFilterByMonthEnd"] = iFilterByMonthEnd
//    //        dic["iFilterByYearEnd"] = iFilterByYearEnd
//    //        //\\print ("iFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd)")
//    //        //        dic["iFilterByMonth"] = 0
//    //        //        dic["iFilterByYear"] = 0
//    //
//    //          print("Global.sharedInstance.providerID  \(Global.sharedInstance.providerID) ")
//    //        dic["iSupplierId"] = providerID
//
//    //        if Reachability.isConnectedToNetwork() == false
//    //        {
//
//    //            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//    //        }
//    //        else
//    //        {
//    //            api.sharedInstance.GetCustomersOrdersForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//    //                //GENERIC DATA IF YOU WANT TO HAVE A JSON AND METHOD DID NOT WORK api.sharedInstance.GetCustomersOrdersForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//    //                  //\\print(responseObject["Result"])
//    //                var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>() //empty first
//    //                if let _: Array<Dictionary<String, AnyObject>> = responseObject["Result"] as?  Array<Dictionary<String, AnyObject>>
//    //                {
//    //                    let ps:OrderDetailsObj = OrderDetailsObj()
//    //
//    //                    ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(responseObject["Result"] as! Array<Dictionary<String,AnyObject>>)
//    //                }
//    //                if let _ = responseObject["Result"] as? NSArray {
//    //
//    //                    let REZULTATE:NSArray = responseObject["Result"] as! NSArray
//    //                    let newarray:NSMutableArray = REZULTATE.mutableCopy() as! NSMutableArray
//    //
//    //                    //                for item in REZULTATE {
//    //                    //                    let d:NSDictionary = item as! NSDictionary
//    //                    //                    //\\print ("AM GASIT \(d.description)")
//    //                    //                }
//    //                    self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
//    //                    //MYordersOfClientsArray
//    //
//    //                }
//    //
//    //
//    //
//    //                //                return
//    //
//    //                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//    //                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//    //            })
//    //        }
//    //    }
//    func generateMatrix(valinput:Int) -> Array<Int> {
//
//        var column1:Array<Int> = []
//        if !column1.contains(valinput) {
//            column1.append(valinput)
//        }
//        var y:Int = 0
//        y = valinput + 7
//        if !column1.contains(y) {
//            column1.append(y)
//        }
//        while y < 168 {
//            y = y + 7
//            if y < 168 {
//                if (y - valinput ) % 7 == 0 {
//                    if !column1.contains(y) {
//                        column1.append(y)
//                    }
//                }
//            }
//
//        }
//
//
//        //     print("first matrix fixed \(column1)")
//        return column1
//    }
//    func findCustomer(iuseridcautat:Int) -> NSDictionary {
//        var gasit:NSDictionary = NSDictionary()
//        for item in self.myCustomersArray {
//            if let _:NSDictionary = item as? NSDictionary {
//                let d:NSDictionary = item as! NSDictionary
//                if let x:Int = d.objectForKey("iCustomerUserId") as? Int{
//                    if x == iuseridcautat {
//                        gasit = d
//                    }
//                }
//            }
//        }
//        //    print("gasit \(gasit.description)")
//        return gasit
//    }
//
//    func initEvents()
//    {
//        Global.sharedInstance.setAllEventsArray()
//
//        dicArrayEventsToShow.removeAll()
//
//        dicBthereEvent.removeAll()
//        dicArrayEventsToShow = Dictionary<String,Array<allKindEventsForListDesign>>()
//
//        dateFormatter.timeStyle = .NoStyle
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//
//        Global.sharedInstance.getEventsFromMyCalendar()
//
//        //------------------אתחול המערכים להצגת הארועים בצורה ממויינת------------------------
//        let dateToday = NSDate()
//
//
//        //עובר על הארועים מהמכשיר
//        for event in Global.sharedInstance.arrEvents
//        {
//            let dateEvent = event.startDate
//            let calendar:NSCalendar = NSCalendar.currentCalendar()
//            let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: dateEvent)
//            yearEvent =  componentsEvent.year
//            monthEvent = componentsEvent.month
//            dayEvent = componentsEvent.day
//
//
//            if !event.allDay {
//                let componentsStart = calendar.components([.Hour, .Minute], fromDate: event.startDate)
//                let componentsEnd = calendar.components([.Hour, .Minute], fromDate: event.endDate)
//
//                let hourS = componentsStart.hour
//                let minuteS = componentsStart.minute
//
//                let hourE = componentsEnd.hour
//                let minuteE = componentsEnd.minute
//
//                var hourS_Show:String = hourS.description
//                var hourE_Show:String = hourE.description
//                var minuteS_Show:String = minuteS.description
//                var minuteE_Show:String = minuteE.description
//
//                if hourS < 10
//                {
//                    hourS_Show = "0\(hourS)"
//                }
//                if hourE < 10
//                {
//                    hourE_Show = "0\(hourE)"
//                }
//                if minuteS < 10
//                {
//                    minuteS_Show = "0\(minuteS)"
//                }
//                if minuteE < 10
//                {
//                    minuteE_Show = "0\(minuteE)"
//                }
//
//
//                //ליצור אובקט
//
//                //בדיקה אם קיים כזה קי(תאריך)
//                var ARRAYiProviderUserId:Array<Int> = []
//                var objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
//                let eventPhone:allKindEventsForListDesign = allKindEventsForListDesign(
//                    _dateEvent: event.startDate,
//                    _title: event.title,
//                    _fromHour: "\(hourS_Show):\(minuteS_Show)",
//                    _toHour: "\(hourE_Show):\(minuteE_Show)",
//                    _tag: 2,
//                    _nvAddress: "",
//                    _nvSupplierName: "",
//                    _iDayInWeek: -1,
//                    _nvServiceName: "",
//                    _nvComment: "",
//                    _iProviderUserId: 0,
//                    _iUserId: 0,
//                    _ClientnvFullName: "",
//                    _iCoordinatedServiceId: 0,
//                    _iCancelallCoordinatedServiceIds:[],
//                    _iCancelalliUserId: [],
//                    _isCancelGroup: false,
//                    _specialDate: "",
//                    _ARRAYiProviderUserId:ARRAYiProviderUserId,
//                    _objProviderServiceDetails:objProviderServiceDetails,
//                    _nvLogo: "",
//                    _chServiceColor: "",
//                    _viewsforweek:  []
//                )
//
//                if dicArrayEventsToShow[dateFormatter.stringFromDate(event.startDate)] != nil
//                {
//                    if yearEvent == yearToday && monthEvent == monthToday                 {
//
//                        dicArrayEventsToShow[dateFormatter.stringFromDate(event.startDate)]?.append(eventPhone)
//                        hasEvent = true
//                    }
//                }
//                else
//                {
//
//                    dicArrayEventsToShow[dateFormatter.stringFromDate(event.startDate)] = Array<allKindEventsForListDesign>()
//                    dicArrayEventsToShow[dateFormatter.stringFromDate(event.startDate)]?.append(eventPhone)
//                }
//            }
//        }
//
//        //עובר על הארועים של ביזר
//        // for eventBthere in Global.sharedInstance.ordersOfClientsArray
//        for item in self.myArray
//
//        {
//            var dateEvent:NSDate = NSDate()
//            var hourStart = NSDate()
//            var hourEnd = NSDate()
//            if let _:NSDictionary = item as? NSDictionary {
//                let eventBthere:NSDictionary = item as! NSDictionary
//                print("test event \(eventBthere.description)")
//
//                // let dateEvent = eventBthere.dtDateOrder
//                if let ORDERDATE:String =  eventBthere.objectForKey("dtDateOrder") as? String
//                {
//                    dateEvent = Global.sharedInstance.getStringFromDateString(ORDERDATE)
//                    print("STRdtDateOrder\(dateEvent)")
//                }
//                //                if let _:NSDate = eventBthere.objectForKey("dtDateOrder") as? NSDate {
//                //                 dateEvent = eventBthere.objectForKey("dtDateOrder") as! NSDate
//                //                }
//                let calendar:NSCalendar = NSCalendar.currentCalendar()
//                let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: dateEvent)
//
//                yearEvent =  componentsEvent.year
//                monthEvent = componentsEvent.month
//                dayEvent = componentsEvent.day
//
//                //אם בטווח של 5 חודשים מהיום
//
//                if let asistart:String = eventBthere.objectForKey("nvFromHour") as? String {
//                    hourStart = Global.sharedInstance.getStringFromDateString(asistart)
//                    print("getDateFromString nvFromHour \(getDateFromString(asistart))")
//                }
//                if let asiend:String = eventBthere.objectForKey("nvToHour") as? String {
//                    hourEnd = Global.sharedInstance.getStringFromDateString(asiend)
//                    print("getDateFromString nvToHour \(getDateFromString(asiend))")
//                }
//
//                let componentsStart = calendar.components([.Hour, .Minute], fromDate: hourStart)
//                let componentsEnd = calendar.components([.Hour, .Minute], fromDate: hourEnd)
//
//                let hourS = componentsStart.hour
//                let minuteS = componentsStart.minute
//
//                let hourE = componentsEnd.hour
//                let minuteE = componentsEnd.minute
//
//                var hourS_Show:String = hourS.description
//                var hourE_Show:String = hourE.description
//                var minuteS_Show:String = minuteS.description
//                var minuteE_Show:String = minuteE.description
//
//                if hourS < 10
//                {
//                    hourS_Show = "0\(hourS)"
//                }
//                if hourE < 10
//                {
//                    hourE_Show = "0\(hourE)"
//                }
//                if minuteS < 10
//                {
//                    minuteS_Show = "0\(minuteS)"
//                }
//                if minuteE < 10
//                {
//                    minuteE_Show = "0\(minuteE)"
//                }
//                var chServiceColor:String = ""
//
//
//                var serviceName = ""
//                if let myarrservices:NSArray =  eventBthere.objectForKey("objProviderServiceDetails") as? NSArray {
//                    for item in myarrservices {
//                        if let servicedict:NSDictionary = item as? NSDictionary {
//                            if serviceName == ""
//                            {
//                                if let _:String  = servicedict.objectForKey("nvServiceName") as? String {
//                                    serviceName = servicedict.objectForKey("nvServiceName") as! String
//                                } else {
//                                    serviceName = "\(serviceName),\(servicedict.objectForKey("nvServiceName") as! String)"
//                                }
//                            }
//                        }
//                    }
//                }
//                if let myarrservices:NSArray =  eventBthere.objectForKey("objProviderServiceDetails") as? NSArray {
//                    for item in myarrservices {
//                        if let servicedict:NSDictionary = item as? NSDictionary {
//                            if let _:String  = servicedict.objectForKey("chServiceColor") as? String {
//                                chServiceColor = servicedict.objectForKey("chServiceColor") as! String
//                                break
//                            }
//
//                        }
//                    }
//                }
//
//
//                var nvServiceName = ""
//                if let myarrservices:NSArray =  eventBthere.objectForKey("objProviderServiceDetails") as? NSArray {
//                    for item in myarrservices {
//                        if let servicedict:NSDictionary = item as? NSDictionary {
//                            if nvServiceName == ""
//                            {
//                                if let _:String  = servicedict.objectForKey("nvServiceName") as? String {
//                                    nvServiceName = servicedict.objectForKey("nvServiceName") as! String
//                                } else {
//                                    nvServiceName = "\(nvServiceName),\(servicedict.objectForKey("nvServiceName") as! String)"
//                                }
//                            }
//
//                        }
//                    }
//                }
//
//                var anyhow = 0
//                if let xor:Int =  eventBthere.objectForKey("iUserId") as? Int {
//                    anyhow = xor
//                }
//                var ClientnvFullName:String = ""
//                var emi:NSDictionary = NSDictionary()
//                if self.findCustomer(anyhow) != NSDictionary() {
//                    emi = self.findCustomer(anyhow)
//                    if let _:String = emi.objectForKey("nvFullName") as? String{
//                        ClientnvFullName = emi.objectForKey("nvFullName") as! String
//                    }
//                }
//                var nvAddress:String = ""
//                var nvSupplierName:String = ""
//                var nvComment:String = ""
//
//                if let _:String = eventBthere.objectForKey("nvAddress") as? String{
//                    nvAddress = eventBthere.objectForKey("nvAddress") as! String
//                }
//                if let _:String = eventBthere.objectForKey("nvSupplierName") as? String{
//                    nvSupplierName = eventBthere.objectForKey("nvSupplierName") as! String
//                }
//                if let _:String = eventBthere.objectForKey("nvComment") as? String{
//                    nvComment = eventBthere.objectForKey("nvComment") as! String
//                }
//
//                var iDayInWeek:Int = 0
//                if let _:Int = eventBthere.objectForKey("iDayInWeek") as? Int{
//                    iDayInWeek = eventBthere.objectForKey("iDayInWeek") as! Int
//                }
//                var iProviderUserId:Int = 0
//                if let _:Int = eventBthere.objectForKey("iProviderUserId") as? Int{
//                    iProviderUserId = eventBthere.objectForKey("iProviderUserId") as! Int
//                }
//                var iUserId:Int = 0
//                if let _:Int = eventBthere.objectForKey("iUserId") as? Int{
//                    iUserId = eventBthere.objectForKey("iUserId") as! Int
//                }
//                var iCoordinatedServiceId:Int = 0
//                if let _:Int = eventBthere.objectForKey("iCoordinatedServiceId") as? Int{
//                    iCoordinatedServiceId = eventBthere.objectForKey("iCoordinatedServiceId") as! Int
//                }
//                var ARRAYiProviderUserId:Array<Int> = []
//                var objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
//                let eventBtheree:allKindEventsForListDesign = allKindEventsForListDesign(
//                    _dateEvent: dateEvent,
//                    ///// _title: "\(nvServiceName),\(eventBthere.nvSupplierName)",
//                    _title: "\(nvServiceName)",
//                    _fromHour: "\(hourS_Show):\(minuteS_Show)",
//                    _toHour: "\(hourE_Show):\(minuteE_Show)",
//                    _tag: 1,
//                    _nvAddress: nvAddress,
//                    _nvSupplierName: nvSupplierName,
//                    _iDayInWeek: iDayInWeek,
//                    _nvServiceName: serviceName,
//                    _nvComment: nvComment,
//                    _iProviderUserId: iProviderUserId,
//                    _iUserId: iUserId,
//                    _ClientnvFullName: ClientnvFullName,
//                    _iCoordinatedServiceId: iCoordinatedServiceId,
//                    _iCancelallCoordinatedServiceIds:[],
//                    _iCancelalliUserId: [],
//                    _isCancelGroup: false,
//                    _specialDate: "",
//                    _ARRAYiProviderUserId:ARRAYiProviderUserId,
//                    _objProviderServiceDetails:objProviderServiceDetails,
//                    _nvLogo: "",
//                    _chServiceColor: chServiceColor,
//                    _viewsforweek:  []
//                )
//
//                //\\print( "eventBthere.iProviderUserId \(iProviderUserId)  _iUserId: \(iUserId) si string start \(hourStart) si string end \(hourEnd)")
//                //\\print( "yearToday \(yearToday)  monthToday \(monthToday) si dayToday \(dayToday) ")
//                if dicBthereEvent[dateFormatter.stringFromDate(dateEvent)] != nil
//                {
//                    if yearEvent == yearToday && monthEvent == monthToday
//                        //&& dayEvent == dayToday
//                    {
//
//                        dicBthereEvent[dateFormatter.stringFromDate(dateEvent)]?.append(eventBtheree)
//                    }
//                }
//                else
//                {
//
//                    dicBthereEvent[dateFormatter.stringFromDate(dateEvent)] = Array<allKindEventsForListDesign>()
//                    dicBthereEvent[dateFormatter.stringFromDate(dateEvent)]?.append(eventBtheree)
//                }
//
//                if dicArrayEventsToShow[dateFormatter.stringFromDate(dateEvent)] != nil
//                {
//                    if yearEvent == yearToday && monthEvent == monthToday
//                        //&& dayEvent == dayToday
//                    {
//
//                        dicArrayEventsToShow[dateFormatter.stringFromDate(dateEvent)]?.append(eventBtheree)
//                    }
//                }
//                else
//                {
//                    dicArrayEventsToShow[dateFormatter.stringFromDate(dateEvent)] = Array<allKindEventsForListDesign>()
//                    dicArrayEventsToShow[dateFormatter.stringFromDate(dateEvent)]?.append(eventBtheree)
//                }
//
//
//
//            }
//
//
//        }
//        sortDicEvents = [(String,Array<allKindEventsForListDesign>)]()
//        sortDicEvents = dicArrayEventsToShow.sort{ dateFormatter.dateFromString($0.0)!.compare(dateFormatter.dateFromString($1.0)!) == .OrderedAscending}
//
//        sortDicBTHEREevent = [(String,Array<allKindEventsForListDesign>)]()
//        sortDicBTHEREevent = dicBthereEvent.sort{ dateFormatter.dateFromString($0.0)!.compare(dateFormatter.dateFromString($1.0)!) == .OrderedAscending}
//
//        var i = 0
//        for event in sortDicEvents
//        {
//            sortDicEvents[i].1.sortInPlace({ $0.dateEvent.compare($1.dateEvent) == NSComparisonResult.OrderedAscending })
//
//            i += 1
//        }
//
//        i = 0
//        for event in sortDicBTHEREevent
//        {
//            sortDicBTHEREevent[i].1.sortInPlace({ $0.dateEvent.compare($1.dateEvent) == NSComparisonResult.OrderedAscending })
//
//            i += 1
//        }
//
//        getEventsArray(currentDate)
//    }
//    func hidetoast(){
//        view.hideToastActivity()
//    }
//
//
//    func processMYARRAY (mycustomerorder: NSMutableArray , globalcustarray: Array<OrderDetailsObj>) {
//        let deadaugat:NSMutableArray = mycustomerorder
//        myArray = []
//        for item in deadaugat {
//            if !self.myArray.containsObject(item) {
//                self.myArray.addObject(item)
//            }
//        }
//        var onearray:Array<OrderDetailsObj> = Array<OrderDetailsObj>()
//        for item in globalcustarray {
//            if !onearray.contains(item) {
//                if  item.nvComment  == "BlockedBySupplier" {
//                    item.title = "BlockedBySupplier"
//                }
//                onearray.append(item)
//            }
//        }
//
//        Global.sharedInstance.ordersOfClientsArray = []
//        Global.sharedInstance.ordersOfClientsArray = onearray
//        //        Global.sharedInstance.ordersOfClientsArray = []
//        //        let globaldeadaugat: Array<OrderDetailsObj> = globalcustarray
//        print("self.myArray.count FIRST\(self.myArray.count) ordersOfClientsArray \(onearray.count) ")
//        if self.myArray.count == 0 {
//            //  Alert.sharedInstance.showAlert("NO_APPOINMENTS_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//            self.view.makeToast(message: "NO_APPOINMENTS_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
//            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
//            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
//                self.hidetoast()
//            })
//
//        } else {
//
//            print("ok appoi")
//        }
//        getCustomers()
//
//    }
//    func getCustomers()
//    {
//        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        // dic["iSupplierId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//        var providerID:Int = 0
//        if Global.sharedInstance.providerID == 0 {
//            providerID = 0
//            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
//                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//                //  Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//            }
//        } else {
//            providerID = Global.sharedInstance.providerID
//        }
//        dic["iSupplierId"] = providerID
//        //  dic["iSupplierId"] = 7450
//        //\\   print("now verifica \(dic)")
//        if Reachability.isConnectedToNetwork() == false
//        {
//            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//        }
//        else
//        {
//            api.sharedInstance.GetCustomersBySupplierId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                //\\print(responseObject)
//                self.generic.hideNativeActivityIndicator(self)
//                if responseObject["Error"]!!["ErrorCode"] as! Int != 1
//                {
//                    print("eroare la getCustomers \(responseObject["Error"])")
//                    if responseObject["Error"]!!["ErrorCode"] as! Int == -3
//                    {
//                        showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    }
//                }
//                else
//                {
//                    self.myCustomersArray = []
//                    //client list comes here
//                    //\\       print("ce astepta \(responseObject["Result"])")
//                    //array (
//                    if let _: Array<Dictionary<String, AnyObject>> = responseObject["Result"] as?  Array<Dictionary<String, AnyObject>>
//                    {
//
//                        var ARRAYDELUCRU : Array<Dictionary<String, AnyObject>> = (responseObject["Result"] as! Array<Dictionary<String, AnyObject>>)
//                        print("ARRAYDELUCRU \(ARRAYDELUCRU)")
//                        for item in ARRAYDELUCRU {
//                            let d:NSDictionary = (item as NSDictionary) as NSDictionary
//                            var MYmutableDictionary:NSMutableDictionary = [:]
//
//                            var STRbIsVip:Int = 0
//                            if let somethingelse:Int =  d.objectForKey("bIsVip") as? Int
//                            {
//                                STRbIsVip = somethingelse
//                            }
//                            print("STRbIsVip \(STRbIsVip)")
//                            var STRiCustomerUserId:String = ""
//                            if let somethingelse2:Int =  d.objectForKey("iCustomerUserId") as? Int
//                            {
//                                STRiCustomerUserId = String(somethingelse2)
//                            }
//                            print("STRiCustomerUserId \(STRiCustomerUserId)")
//                            var STRinvFirstName:String = ""
//                            if let somethingelse3 =  d.objectForKey("nvFirstName") as? String
//                            {
//                                STRinvFirstName = somethingelse3
//                            }
//
//                            var STRnvLastName:String = ""
//                            if let somethingelse4 =  d.objectForKey("nvLastName") as? String
//                            {
//                                STRnvLastName = somethingelse4
//                            }
//                            let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
//
//                            var STRnvMail:String = ""
//                            if let somethingelse5 =  d.objectForKey("nvMail") as? String
//                            {
//                                STRnvMail = somethingelse5
//                            }
//
//                            var STRnvPhone:String = ""
//                            if let somethingelse6 =  d.objectForKey("nvPhone") as? String
//                            {
//                                STRnvPhone = somethingelse6
//                            }
//                            var STRnvImage:String = ""
//
//                            if let somethingelse =  d.objectForKey("nvImage") as? String
//                            {
//                                STRnvImage = somethingelse
//                            }
//                            else
//                            {
//                                STRnvImage = ""
//                            }
//                            var STRnvSupplierNotes = ""
//                            if let nvSupplierRemark:String = d.objectForKey("nvSupplierRemark") as? String {
//                                //\\print ("nvSupplierRemark \(nvSupplierRemark)")
//                                if(nvSupplierRemark.characters.count > 0) {
//                                    STRnvSupplierNotes = nvSupplierRemark
//                                } else {
//                                    STRnvSupplierNotes = ""
//                                }
//                            }
//                            //\\print ("STRnvSupplierNotes \(STRnvSupplierNotes)")
//                            var STRdBirthdate:NSDate = NSDate()
//
//                            if let somethingelse =  d.objectForKey("dBirthdate") as? String
//                            {
//                                //  STRdBirthdate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 3, toDate: somethingelse
//                                //       , options: [])!
//                                STRdBirthdate = Global.sharedInstance.getStringFromDateString(somethingelse)
//                                print("STRdBirthdate\(STRdBirthdate)")
//                            } else {
//
//                                print("no birthdate")
//                                let dateString = "01/01/1901" // change to your date format
//                                let dateFormatter = NSDateFormatter()
//                                dateFormatter.dateFormat =  "dd/MM/yyyy"
//                                STRdBirthdate = dateFormatter.dateFromString(dateString)!
//
//                            }
//
//                            var INTiCustomerUserId:Int = 0
//                            if let somethingelse:Int =  d.objectForKey("iCustomerUserId") as? Int
//                            {
//                                INTiCustomerUserId = somethingelse
//                            }
//                            MYmutableDictionary["bIsVip"] = STRbIsVip
//                            MYmutableDictionary["nvFirstName"] = STRinvFirstName
//                            MYmutableDictionary["nvLastName"] = STRnvLastName
//                            MYmutableDictionary["nvFullName"] = STRnvFullName
//                            MYmutableDictionary["nvMail"] = STRnvMail
//                            MYmutableDictionary["nvPhone"] = STRnvPhone
//                            MYmutableDictionary["nvImage"] = STRnvImage
//                            MYmutableDictionary["nvSupplierRemark"] = STRnvSupplierNotes
//                            MYmutableDictionary["dBirthdate"] = STRdBirthdate
//                            MYmutableDictionary["iCustomerUserId"] = INTiCustomerUserId
//                            if !self.myCustomersArray.containsObject(MYmutableDictionary) {
//                                self.myCustomersArray.addObject(MYmutableDictionary)
//                            }
//                        }
//                        print("myCustomersArray \(self.myCustomersArray) si count \(self.myCustomersArray.count)  " )
//                        //  self.myArray = ARRAYDELUCRU as! NSMutableArray
//                        Global.sharedInstance.nameCostumersArray = []
//                        Global.sharedInstance.searchCostumersArray = []
//                        Global.sharedInstance.nameCostumersArray = self.myCustomersArray
//                        Global.sharedInstance.searchCostumersArray = self.myCustomersArray
//                        Global.sharedInstance.ISSEARCHINGCUSTOMER = false
//
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//
//                            self.getServicesProviderForSupplierfunc()
//
//                        })
//
//
//                    }
//                }
//
//
//                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    self.generic.hideNativeActivityIndicator(self)
//                    showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//            })
//        }
//
//    }
//    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
//        print("self.arrayWorkers.count \(self.arrayWorkers.count)")
//        if self.arrayWorkers.count > 0 {
//            if self.arrayWorkers.count > 1 {
//                self.carousel.type = .Linear
//            } else {
//                self.carousel.type = .Linear
//                //  self.carousel.scrollEnabled = false
//                self.carousel.userInteractionEnabled = false
//            }
//        }
//
//        return self.arrayWorkers.count
//    }
//    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
//
//        let  index:Int = carousel.currentItemIndex
//        // if index > 0 {
//        var workerid:Int = 0
//        if  self.arrayWorkers.count > 0 {
//            if let _:User = self.arrayWorkers[index] as? User {
//                let MYD:User = self.arrayWorkers[index] as! User
//
//                if let _:Int =  MYD.iUserId
//                {
//                    workerid =  MYD.iUserId
//                    Global.sharedInstance.defaults.setInteger(workerid, forKey: "idSupplierWorker")
//                    Global.sharedInstance.defaults.synchronize()
//                }
//
//                print("workerid \(workerid) si \(index)")
//                self.selectedWorker = true
//                self.selectedWorkerID = index
//
//
//                self.setEventsArrayx()
//
//            }
//        }
//        if self.arrayWorkers.count > 1 {
//            for itemView in carousel.visibleItemViews {
//                for subview in itemView.subviews as [UIView] {
//                    if let labelView = subview as? UILabel {
//                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 16)
//                        labelView.font = labelFont
//                        var attr = NSMutableAttributedString(string: labelView.text!)
//                        attr.removeAttribute(NSUnderlineStyleAttributeName, range: NSMakeRange(0, attr.length))
//                        labelView.attributedText = attr
//                    }
//                }
//            }
//
//            if let _:UIView = carousel.currentItemView {
//                let myview:UIView = carousel.currentItemView!
//                for subview in myview.subviews as [UIView] {
//                    if let labelView = subview as? UILabel {
//                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
//                        labelView.font = labelFont
//                        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
//                        let mylblString:String = labelView.text!
//                        let underlineAttributedString = NSAttributedString(string:mylblString, attributes: underlineAttribute)
//                        labelView.attributedText = underlineAttributedString
//                        //     labelView.minimumScaleFactor = 0.5
//                        //    labelView.adjustsFontSizeToFitWidth = true
//                    }
//                }
//            }
//        } else {
//            if let _:UIView = carousel.currentItemView {
//                let myview:UIView = carousel.currentItemView!
//                for subview in myview.subviews as [UIView] {
//                    if let labelView = subview as? UILabel {
//                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
//                        labelView.font = labelFont
//                        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
//                        let mylblString:String = labelView.text!
//                        let underlineAttributedString = NSAttributedString(string:mylblString, attributes: underlineAttribute)
//                        labelView.attributedText = underlineAttributedString
//                        //     labelView.minimumScaleFactor = 0.5
//                        //    labelView.adjustsFontSizeToFitWidth = true
//                    }
//                }
//            }
//        }
//
//        /// setEventBthereInMonth()
//
//    }
//
//
//
//    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
//        var label: UILabel
//        var itemView: UIImageView
//
//        //reuse view if available, otherwise create a new view
//
//        if let view = view as? UIImageView {
//            itemView = view
//            //get a reference to the label in the recycled view
//            if self.arrayWorkers.count > 1 {
//                for itemView in carousel.visibleItemViews {
//                    for subview in itemView.subviews as [UIView] {
//                        if let labelView = subview as? UILabel {
//                            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 16)
//                            labelView.font = labelFont
//                        }
//                    }
//                }
//                if let _:UIView = carousel.currentItemView {
//                    let myview:UIView = carousel.currentItemView!
//                    for subview in myview.subviews as [UIView] {
//                        if let labelView = subview as? UILabel {
//                            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
//                            labelView.font = labelFont
//
//                        }
//                    }
//
//                }
//            }
//            else  {
//                if let _:UIView = carousel.currentItemView {
//                    let myview:UIView = carousel.currentItemView!
//                    for subview in myview.subviews as [UIView] {
//                        if let labelView = subview as? UILabel {
//                            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
//                            labelView.font = labelFont
//
//                        }
//                    }
//                }
//            }
//
//
//
//
//
//            label = itemView.viewWithTag(1) as! UILabel
//        } else {
//
//            //don't do anything specific to the index within
//            //this `if ... else` statement because the view will be
//            //recycled and used with other index values later
//            //\\    itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 2.4 , height: 55))
//            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.carousel.frame.size.width / 2.4  , height: 55))
//            itemView.image = UIImage(named: "")
//            itemView.contentMode = .ScaleAspectFill
//            itemView.backgroundColor = UIColor.clearColor()
//            //            if self.arrayWorkers.count > 1 {
//            //            label = UILabel(frame: CGRect(x: itemView.frame.origin.x + 30, y: itemView.frame.origin.y + 1, width:itemView.frame.size.width, height: itemView.frame.size.height - 6))
//            //            }
//            //            else {
//            label = UILabel(frame: CGRect(x: itemView.frame.origin.x , y: itemView.frame.origin.y + 1, width:itemView.frame.size.width, height: itemView.frame.size.height - 6))
//            // }
//            label.backgroundColor = UIColor.clearColor()
//            label.textAlignment = .Left
//            //   label.font = label.font.fontWithSize(18)
//            //            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 18)
//            //            label.font = labelFont
//
//            label.numberOfLines = 1
//            label.textAlignment = .Center
//            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
//            label.font = labelFont
//            // label.minimumScaleFactor = 0.8
//            //   label.adjustsFontSizeToFitWidth = true
//            label.textColor = Colors.sharedInstance.color4
//            label.tag = 1
//
//            //            let mybluecircle:UIImageView = UIImageView()
//            //            mybluecircle.frame = itemView.frame
//            //            mybluecircle.frame.size = CGSize(width: itemView.frame.size.height/4, height: itemView.frame.size.height/4)
//            //            mybluecircle.image = UIImage(named:"bluecircleon.png")
//            //            mybluecircle.contentMode = .ScaleAspectFit
//            //            mybluecircle.center.y = itemView.center.y
//            //            mybluecircle.frame.origin.x = itemView.frame.origin.x + 12
//
//            itemView.addSubview(label)
//            //            if self.arrayWorkers.count > 1 {
//            //                itemView.addSubview(mybluecircle)
//            //                itemView.bringSubviewToFront(mybluecircle)
//            //            }
//        }
//
//        //set item label
//        //remember to always set any properties of your carousel item
//        //views outside of the `if (view == nil) {...}` check otherwise
//        //you'll get weird issues with carousel item content appearing
//        //in the wrong place in the carousel
//        //    if index > 0 {
//        if let _:User = self.arrayWorkers[index] as? User {
//            let MYD:User = self.arrayWorkers[index] as! User
//            var STRinvFirstName:String = ""
//            if let somethingelse3:String =  MYD.nvFirstName
//            {
//                STRinvFirstName = somethingelse3
//            }
//
//            var STRnvLastName:String = ""
//            if let somethingelse4:String =  MYD.nvLastName
//            {
//                STRnvLastName = somethingelse4
//            }
//            let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
//            print("index name \(STRnvFullName) si \(index)")
//            //  label.text = STRnvFullName
//            let underlineAttributedString = NSAttributedString(string:STRinvFirstName.capitalizedString, attributes: nil)
//            label.attributedText = underlineAttributedString
//            //label.attributedText = STRinvFirstName.capitalizedString
//        }
//        //    }else {
//        //        let STRnvFullName:String = "NOT_CARE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        //        label.text = STRnvFullName
//        //    }
//        if self.arrayWorkers.count > 1 {
//            for itemView in carousel.visibleItemViews {
//                for subview in itemView.subviews as [UIView] {
//                    if let labelView = subview as? UILabel {
//                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 16)
//                        labelView.font = labelFont
//                    }
//                }
//            }
//            if let _:UIView = carousel.currentItemView {
//                let myview:UIView = carousel.currentItemView!
//                for subview in myview.subviews as [UIView] {
//                    if let labelView = subview as? UILabel {
//                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
//                        labelView.font = labelFont
//
//                    }
//                }
//
//            }
//        }
//        else  {
//
//
//            if let _:UIView = carousel.currentItemView {
//                let myview:UIView = carousel.currentItemView!
//                for subview in myview.subviews as [UIView] {
//                    if let labelView = subview as? UILabel {
//                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
//                        labelView.font = labelFont
//                        labelView.setNeedsLayout()
//                        labelView.setNeedsLayout()
//                    }
//                }
//            }
//            for itemView in carousel.visibleItemViews {
//                for subview in itemView.subviews as [UIView] {
//                    if let labelView = subview as? UILabel {
//                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
//                        labelView.font = labelFont
//                        labelView.setNeedsLayout()
//                        labelView.setNeedsLayout()
//                    }
//                }
//            }
//        }
//
//        return itemView
//
//    }
//
//
//    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        if (option == .Spacing) {
//            return value * 1.1
//        }
//        return value
//    }
//
//
//
//    func getServicesProviderForSupplierfunc()
//    {
//        Global.sharedInstance.giveServiceName = ""
//        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        if Global.sharedInstance.providerID == 0 {
//            dicSearch["iProviderId"] = 0
//            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
//                dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//            }
//        } else {
//            dicSearch["iProviderId"] = Global.sharedInstance.providerID
//        }
//
//        var arrUsers:Array<User> = Array<User>()
//
//        self.generic.showNativeActivityIndicator(self)
//        if Reachability.isConnectedToNetwork() == false
//        {
//            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//        }
//        else
//        {
//            api.sharedInstance.getServicesProviderForSupplierfunc(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
//                if responseObject["Error"]!!["ErrorCode"] as! Int == -3
//                {
//                    showAlertDelegateX("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                }
//                else if responseObject["Error"]!!["ErrorCode"] as! Int == 1
//                {
//                    var Arr:NSArray = NSArray()
//
//                    Arr = responseObject["Result"] as! NSArray
//                    let u:User = User()
//                    arrUsers = u.usersToArray(responseObject["Result"] as! Array<Dictionary<String,AnyObject>>)
//                    Global.sharedInstance.giveServicesArray = arrUsers
//
//                    Global.sharedInstance.arrayGiveServicesKods = []
//                    for  item in arrUsers{
//                        //\\print ("ce am \(item.description)")
//                        Global.sharedInstance.arrayGiveServicesKods.append(item.iUserId)//אחסון הקודים של נותני השרות לצורך השליחה לשרת כדי לקבל את השעות הפנויות
//                    }
//                    Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
//                    Global.sharedInstance.dicGetFreeDaysForServiceProvider["lServiseProviderId"] = Global.sharedInstance.arrayGiveServicesKods
//                    //JMODE todo
//                    var temparrayWorkers:  NSMutableArray = []
//
//                    if arrUsers.count == 0
//                    {
//                        Global.sharedInstance.CurrentProviderArrayWorkers = []
//                        showAlertDelegateX("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        self.processworkers(temparrayWorkers)
//                    }
//                    else
//                    {
//                        Global.sharedInstance.CurrentProviderArrayWorkers = []
//
//                        for u:User in arrUsers
//                        {
//                            if  self.EMPLOYEISMANAGER == true {
//                                api.sharedInstance.PREETYJSON_J(u.getDic(), pathofweb: "worker details")
//                                temparrayWorkers.addObject(u)
//
//                            }
//                        }
//                        var y:Int = 0
//                        let a:NSDictionary = (Global.sharedInstance.defaults.objectForKey("currentUserId") as? NSDictionary)!
//                        if let x:Int = a.valueForKey("currentUserId") as? Int{
//                            y = x
//                        }
//
//                        for u:User in arrUsers
//                        {
//
//                            if  self.EMPLOYEISMANAGER == false {
//                                //\\ NU UITA    if u.iUserId == y {
//                                //  if u.iUserId == 235 {
//                                if u.iUserId == Global.sharedInstance.defaults.integerForKey("idSupplierWorker")  {
//
//                                    temparrayWorkers.addObject(u)
//                                }
//                                print("u.iUserId \(u.iUserId) Global idSupplierWorker \(Global.sharedInstance.defaults.integerForKey("idSupplierWorker") )")
//                            }
//                        }
//                        //   temparrayWorkers.insertObject("NOT_CARE".localized(LanguageMain.sharedInstance.USERLANGUAGE), atIndex: 0)
//                        self.processworkers(temparrayWorkers)
//                    }
//
//                }
//
//                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//
//                    self.generic.hideNativeActivityIndicator(self)
//                    showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//            })
//        }
//
//    }
//    func refreshTable(sender:AnyObject) {
//        // Code to refresh table view
//        print("merge")
//        // GetCustomersOrdersByDateForSupplier()
//        if self.EMPLOYEISMANAGER == true {
//            GetCustomersOrdersByDateForSupplier()
//        } else {
//            //is employe non manager
//            GetCustomersOrdersByDateForEmployeeId()
//        }
//
//    }
//    func processworkers (myWorkers: NSMutableArray) {
//        self.arrayWorkers = myWorkers
//        Global.sharedInstance.CurrentProviderArrayWorkers = self.arrayWorkers
//        print("Global.sharedInstance.CurrentProviderArrayWorkers \(Global.sharedInstance.CurrentProviderArrayWorkers)")
//        //        refreshControl.endRefreshing()
//        if self.arrayWorkers.count > 0 {
//            if self.arrayWorkers.count > 1 {
//                self.carousel.type = .Linear
//            } else {
//                self.carousel.type = .Linear
//                //  self.carousel.scrollEnabled = false
//                self.carousel.userInteractionEnabled = false
//            }
//        }
//
//        self.initEvents()
//
//    }
//
//
//
//    //magic thing filter mass array
//    func bestmode(){
//        if Global.sharedInstance.defaults.integerForKey("ismanager") == 0 {
//            self.EMPLOYEISMANAGER = false
//        } else {
//            self.EMPLOYEISMANAGER = true
//        }
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//        refreshControl.addTarget(self, action: #selector(WeekDesignSupplierViewController.refreshTable(_:)), forControlEvents: UIControlEvents.ValueChanged)
//        self.collWeek.addSubview(refreshControl)
//
//        //    idWorker =  Global.sharedInstance.idSupplierWorker
//        //        if Global.sharedInstance.rtl
//        //        {
//        //            arrowleft.image =    UIImage(named: "sageata1.png")
//        //            arrowright.image =    UIImage(named: "sageata2.png")
//        //        }
//        //        else
//        //   {
//        arrowleft.image =    UIImage(named: "arrow_left_J.png")
//        arrowright.image =    UIImage(named: "arrow_right_J.png")
//        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
//            var scalingTransform : CGAffineTransform!
//            scalingTransform = CGAffineTransformMakeScale(-1, 1)
//            arrowleft.transform = scalingTransform
//            arrowright.transform = scalingTransform
//        }
//        arrowleft.contentMode = .ScaleAspectFit
//        arrowright.contentMode = .ScaleAspectFit
//        //    }
//
//        /////////////\\\\\\\\\
//        imgCurrentDay.hidden = true
//        hasEvent = false
//        var scalingTransform : CGAffineTransform!
//        scalingTransform = CGAffineTransformMakeScale(-1, 1)
//        //        if Global.sharedInstance.rtl {
//        //            collWeek.transform = scalingTransform
//        //        }
//
//        monthArray = []
//
//        Global.sharedInstance.getEventsFromMyCalendar()
//
//        if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
//        {
//            btnSyncWithGoogelSupplier.isCecked = true
//        }
//
//        var dateFormatter = NSDateFormatter()
//        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
//            dateFormatter = NSDateFormatter()
//            dateFormatter.locale = NSLocale(localeIdentifier: "he_IL")
//
//        } else {
//            dateFormatter = NSDateFormatter()
//            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
//
//
//        }
//        lblDayOfWeek1.text = dateFormatter.veryShortWeekdaySymbols[6]
//        lblDayOfWeek2.text = dateFormatter.veryShortWeekdaySymbols[5]
//        lblDayOfWeek3.text = dateFormatter.veryShortWeekdaySymbols[4]
//        lblDayOfWeek4.text = dateFormatter.veryShortWeekdaySymbols[3]
//        lblDayOfWeek5.text = dateFormatter.veryShortWeekdaySymbols[2]
//        lblDayOfWeek6.text = dateFormatter.veryShortWeekdaySymbols[1]
//        lblDayOfWeek7.text = dateFormatter.veryShortWeekdaySymbols[0]
//
//
//
//        //        lblDayOfWeek1.text = NSDateFormatter().veryShortWeekdaySymbols[6]
//        //        lblDayOfWeek2.text = NSDateFormatter().veryShortWeekdaySymbols[5]
//        //        lblDayOfWeek3.text = NSDateFormatter().veryShortWeekdaySymbols[4]
//        //        lblDayOfWeek4.text = NSDateFormatter().veryShortWeekdaySymbols[3]
//        //        lblDayOfWeek5.text = NSDateFormatter().veryShortWeekdaySymbols[2]
//        //        lblDayOfWeek6.text = NSDateFormatter().veryShortWeekdaySymbols[1]
//        //        lblDayOfWeek7.text = NSDateFormatter().veryShortWeekdaySymbols[0]
//
//        hasEvent = false
//
//
//        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
//        var isFindToday:Bool = false
//        print("datesInWeekArray \(datesInWeekArray)")
//        var datesInWeekArraysorted = datesInWeekArray.sort()
//        dtDateStart = datesInWeekArraysorted[0]
//        dtDateEnd = datesInWeekArraysorted[6]
//        print("bestmode datesInWeekArraysorted \(datesInWeekArraysorted) dtDateStart\(dtDateStart) dtDateEnd\(dtDateEnd) ")
//        for item in datesInWeekArray
//        {
//            let otherDay: NSDateComponents = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day], fromDate: item)
//
//
//            let today: NSDateComponents = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day], fromDate: NSDate())
//            print("si item \(otherDay.day)")
//            print("today === \(today.day)")
//            if today.day == otherDay.day && today.month == otherDay.month && today.year == otherDay.year
//            {
//                isFindToday = true
//            }
//
//        }
//
//        if isFindToday
//        {
//            imgCurrentDay.hidden = false
//            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(NSDate())!
//            print("dayofww \(dayOfWeekToday)")
//            UIView.animateWithDuration(1, animations: {
//                self.ingTrailing.constant = /* self.ingTrailing.constant +*/ ((self.view.frame.width / 8) *
//                    CGFloat(self.dayOfWeekToday))
//            })
//        }
//        else{
//            imgCurrentDay.hidden = true
//        }
//
//        //      setEventsArray(currentDate)
//        setDate()
//        //   arrayDays = [Int(lblDay1.text!)!,Int(lblDay2.text!)!,Int(lblDay3.text!)!,Int(lblDay4.text!)!,Int(lblDay5.text!)!,Int(lblDay6.text!)!,Int(lblDay7.text!)!]
//        arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]
//        arrayButtons.append(btnDay1)
//        arrayButtons.append(btnDay2)
//        arrayButtons.append(btnDay3)
//        arrayButtons.append(btnDay4)
//        arrayButtons.append(btnDay5)
//        arrayButtons.append(btnDay6)
//        arrayButtons.append(btnDay7)
//
//
//        arrayLabelsDayNum.append(lblDayOfWeek1)
//        arrayLabelsDayNum.append(lblDayOfWeek2)
//        arrayLabelsDayNum.append(lblDayOfWeek3)
//        arrayLabelsDayNum.append(lblDayOfWeek4)
//        arrayLabelsDayNum.append(lblDayOfWeek5)
//        arrayLabelsDayNum.append(lblDayOfWeek6)
//        arrayLabelsDayNum.append(lblDayOfWeek7)
//
//        arrayLabelsdate.append(lblDay1)
//        arrayLabelsdate.append(lblDay2)
//        arrayLabelsdate.append(lblDay3)
//        arrayLabelsdate.append(lblDay4)
//        arrayLabelsdate.append(lblDay5)
//        arrayLabelsdate.append(lblDay6)
//        arrayLabelsdate.append(lblDay7)
//        setDateEnablity()
//        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
//        viewSync.addGestureRecognizer(tapSync)
//
//        /////\\\\\\
//        //        if Global.sharedInstance.rtl
//        //        {
//        //            arrowleft.image =    UIImage(named: "sageata1.png")
//        //            arrowright.image =    UIImage(named: "sageata2.png")
//        //        }
//        //        else
//        //        {
//        //            arrowleft.image =    UIImage(named: "sageata2.png")
//        //            arrowright.image =    UIImage(named: "sageata1.png")
//        //        }
//        //
//        //frombestback = true
//        //        self.myArray = []
//        //        Global.sharedInstance.ordersOfClientsArray = []
//
//        //     let todaybe:NSDate = NSDate()
//        //   idWorker =  Global.sharedInstance.idSupplierWorker
//        let todaybe:NSDate = Calendar.sharedInstance.carrentDate
//        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: todaybe)
//        let day = components.day
//        let month = components.month
//        let year = components.year
//        print("best d m y \(day) \(month) \(year)")
//        //today = Calendar.sharedInstance.carrentDate
//        iFilterByMonth = month
//        iFilterByYear = year
//        iFilterByMonthEnd = month
//        iFilterByYearEnd = year
//        if self.EMPLOYEISMANAGER == true {
//            GetCustomersOrdersByDateForSupplier()
//        } else {
//            //is employe non manager
//            GetCustomersOrdersByDateForEmployeeId()
//        }
//
//
//        print(" week idSupplierWorker \( Global.sharedInstance.defaults.integerForKey("idSupplierWorker"))")
//        //GetCustomersOrdersForSupplier()
//    }
//    func TRYPDFJUSTNOW() {
//
//        let render = UIPrintPageRenderer()
//        var html = ""
//
//        var adate:NSDate = NSDate()
//        html = html + "<table style=\"width:100%; border-collapse: collapse;\">"
//        let composeddatefinal =  self.lblDays.text!
//        if CalendarMatrix.count > 0 {
//
//
//            var newarraywithuniquevals:Array<allKindEventsForListDesign> = []
//
//            for i:Int in column1  {
//                let mainid:Int = column1.indexOf(i)!
//                if mainid == 0 && i <= 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                else if 0 < mainid && i <= 160  {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//
//                else if  0 < mainid && i > 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            for i:Int in column2  {
//                let mainid:Int = column2.indexOf(i)!
//                if mainid == 0 && i <= 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                else if 0 < mainid && i <= 160  {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//
//                else if  0 < mainid && i > 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            for i:Int in column3  {
//                let mainid:Int = column3.indexOf(i)!
//                if mainid == 0 && i <= 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                else if 0 < mainid && i <= 160  {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//
//                else if  0 < mainid && i > 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//
//            for i:Int in column4  {
//                let mainid:Int = column4.indexOf(i)!
//                if mainid == 0 && i <= 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                else if 0 < mainid && i <= 160  {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//
//                else if  0 < mainid && i > 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            for i:Int in column5  {
//                let mainid:Int = column5.indexOf(i)!
//                if mainid == 0 && i <= 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                else if 0 < mainid && i <= 160  {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//
//                else if  0 < mainid && i > 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            for i:Int in column6  {
//                let mainid:Int = column6.indexOf(i)!
//                if mainid == 0 && i <= 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                else if 0 < mainid && i <= 160  {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//
//                else if  0 < mainid && i > 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            for i:Int in column7  {
//                let mainid:Int = column7.indexOf(i)!
//                if mainid == 0 && i <= 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                else if 0 < mainid && i <= 160  {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//
//                else if  0 < mainid && i > 160 {
//                    if CalendarMatrix[i].2.count > 0 {
//                        var myeventstoShow:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
//                        myeventstoShow = self.CalendarMatrix[i].2
//                        if myeventstoShow.count > 0 {
//
//                            for item in myeventstoShow {
//                                if item.iCoordinatedServiceId > 0 {
//                                    if !newarraywithuniquevals.contains(item) {
//                                        newarraywithuniquevals.append(item)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//
//            html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align: right; background-color: #f39371; color: #fff; width: 100%;\"> \(composeddatefinal)</td></tr>"
//
//
//            if newarraywithuniquevals.count > 0 {
//                print("newarraywithuniquevals \(newarraywithuniquevals.count)")
//                for item in newarraywithuniquevals {
//                    print("item date \(item.dateEvent)")
//                    let calendarx = NSCalendar.currentCalendar()
//                    let components = calendarx.components([.Day , .Month , .Year], fromDate: item.dateEvent)
//                    let year =  components.year
//                    let month = components.month
//                    let day = components.day
//                    let dateofevent =   String(day) + "-" + String(month) + "-" + String(year)
//                    let hhours =  "\(item.fromHour) - \(item.toHour)"
//                    let clientname = item.ClientnvFullName
//                    let servicename = item.title
//                    let composedstring = clientname + " - " + servicename
//                    html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; width: 100%; \"> \(dateofevent)" + "  \(hhours)</td></tr>"
//
//                    html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; width: 100%;border-bottom: 1px solid black;\">    \(composedstring)</td></tr>"
//                }
//            }
//            html = html + "</table>"
//
//
//            print("myhtml \(html)")
//            let fmt = UIMarkupTextPrintFormatter(markupText: html)
//
//            render.addPrintFormatter(fmt, startingAtPageAtIndex: 0)
//
//            // 3. Assign paperRect and printableRect
//
//            let page = CGRect(x: 0, y: 0, width: 612, height: 792) // some defaults
//            let printable = page.insetBy(dx: 0, dy: 0)
//
//            render.setValue(NSValue(CGRect: page), forKey: "paperRect")
//            render.setValue(NSValue(CGRect: printable), forKey: "printableRect")
//
//            // 4. Create PDF context and draw
//            //let pointzero = CGPoint(x: 0,y :0)
//            let rect = CGRect.zero
//            let pdfData = NSMutableData()
//            UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
//
//            for i in 0..<render.numberOfPages {
//                UIGraphicsBeginPDFPage();
//                render.drawPageAtIndex( i, inRect: UIGraphicsGetPDFContextBounds())
//            }
//
//            UIGraphicsEndPDFContext();
//
//            // 5. Save PDF file
//            var Timestamp: String {
//                return "\(NSDate().timeIntervalSince1970 * 1000)"
//            }
//            let uniquefilename =  randomStringWithLength(6)
//            let onestring =  Timestamp.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
//            let fileNAMEFINAL: String = onestring + (uniquefilename as String) + ".pdf"
//            // let path = "\(NSTemporaryDirectory())sd.pdf"
//            let path = "\(NSTemporaryDirectory())\(fileNAMEFINAL)"
//            print("fileNAMEFINAL\(fileNAMEFINAL)")
//            pdfData.writeToFile( path, atomically: true)
//            print("open \(path)")
//
//            //   let fullURL = NSURL.fileURLWithPathComponents([directory, fileName])
//            if( MFMailComposeViewController.canSendMail() )
//            {
//                print("Can send email.")
//
//                let mailComposer = MFMailComposeViewController()
//                mailComposer.mailComposeDelegate = self
//
//                //Set to recipients
//                mailComposer.setToRecipients(["your email address heres"])
//
//                //Set the subject
//                mailComposer.setSubject("My list from Bthere app")
//
//                //set mail body
//                mailComposer.setMessageBody("My list from Bthere app", isHTML: true)
//
//                if let filePath = path as? String
//
//                {
//                    print("File path loaded.")
//
//                    if let fileData = NSData(contentsOfFile: filePath)
//                    {
//                        print("File data loaded.")
//                        mailComposer.addAttachmentData(fileData, mimeType: "application/pdf", fileName: fileNAMEFINAL)
//
//                    }
//                }
//
//                //this will compose and present mail to user
//                self.presentViewController(mailComposer, animated: true, completion: nil)
//            }
//            else
//            {
//                print("email is not supported")
//            }
//        }
//    }
//    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
//    {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    func gethoursandminuteforevent (itemx: allKindEventsForListDesign) -> [Int] {
//        var arrayints:[Int]  = []
//        var eventHour:Int = 0
//        var eventMinutes:Int = 0
//        var eventSecondHour:Int = 0
//        var eventSecondMinutes:Int = 0
//
//        if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
//            if a1 == "0" {
//                //now get the real hour
//                if let a2:Character =  itemx.fromHour[itemx.fromHour.startIndex.advancedBy(1)]{
//                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
//                    if a2 == "0" {
//                        //    print("ora1 0 add to 0")
//                        eventHour = 0
//                    }
//                    else {
//                        //     print("ora1 \(a2) add to \(a2)") //section
//                        let str = String(a2)
//                        let IntHOUR:Int = Int(str)!
//                        eventHour = IntHOUR
//
//                    }
//                }
//            }
//            else { //full hour 2 chars
//                let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
//                let size = fullNameArr.count
//                if(size > 1 ) {
//                    if let _:String = fullNameArr[0]  {
//                        let hourstring:String = fullNameArr[0]
//                        let numberFromString:Int = Int(hourstring)!
//                        eventHour = numberFromString
//                    }
//                }
//            }
//        }
//
//
//        //minutes compare
//        let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
//        let size = fullNameArr.count
//        if(size > 1 ) {
//            if let _:String = fullNameArr[1]  {
//                let hourstring:String = fullNameArr[1]
//                if let a1:Character =  hourstring[hourstring.startIndex] {
//                    if a1 == "0" {
//                        //now get the real minute
//                        if let a2:Character =  hourstring[hourstring.startIndex.advancedBy(1)]{
//                            if a2 == "0" {
//                                //     print("minutul 0 add to 0")
//                                eventMinutes = 0
//                            }
//                            else {
//                                //     print("minutul \(a2) add to \(a2)") //section
//                                let str = String(a2)
//                                let IntHOUR:Int = Int(str)!
//                                eventMinutes = IntHOUR
//
//                            }
//                        }
//                    }
//                    else { //full minutes 2 chars
//                        let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
//                        let size = fullNameArr.count
//                        if(size > 1 ) {
//                            if let _:String = fullNameArr[1]  {
//                                let hourstring:String = fullNameArr[1]
//                                let numberFromString:Int = Int(hourstring)!
//                                eventMinutes = numberFromString
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        arrayints.append(eventHour)
//        arrayints.append(eventMinutes)
//
//        if let a1:Character =  itemx.toHour[itemx.toHour.startIndex] {
//            if a1 == "0" {
//                //now get the real hour
//                if let a2:Character =  itemx.toHour[itemx.toHour.startIndex.advancedBy(1)]{
//                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
//                    if a2 == "0" {
//                        //    print("ora1 0 add to 0")
//                        eventHour = 0
//                    }
//                    else {
//                        //     print("ora1 \(a2) add to \(a2)") //section
//                        let str = String(a2)
//                        let IntHOUR:Int = Int(str)!
//                        eventHour = IntHOUR
//
//                    }
//                }
//            }
//            else { //full hour 2 chars
//                let fullNameArr = itemx.toHour.componentsSeparatedByString(":")
//                let size = fullNameArr.count
//                if(size > 1 ) {
//                    if let _:String = fullNameArr[0]  {
//                        let hourstring:String = fullNameArr[0]
//                        let numberFromString:Int = Int(hourstring)!
//                        eventHour = numberFromString
//                    }
//                }
//            }
//        }
//
//
//        //minutes compare
//        let fullNameArr2 = itemx.toHour.componentsSeparatedByString(":")
//        let size2 = fullNameArr2.count
//        if(size2 > 1 ) {
//            if let _:String = fullNameArr2[1]  {
//                let hourstring:String = fullNameArr2[1]
//                if let a1:Character =  hourstring[hourstring.startIndex] {
//                    if a1 == "0" {
//                        //now get the real minute
//                        if let a2:Character =  hourstring[hourstring.startIndex.advancedBy(1)]{
//                            if a2 == "0" {
//                                //     print("minutul 0 add to 0")
//                                eventMinutes = 0
//                            }
//                            else {
//                                //     print("minutul \(a2) add to \(a2)") //section
//                                let str = String(a2)
//                                let IntHOUR:Int = Int(str)!
//                                eventMinutes = IntHOUR
//
//                            }
//                        }
//                    }
//                    else { //full minutes 2 chars
//                        let fullNameArr2 = itemx.toHour.componentsSeparatedByString(":")
//                        let size = fullNameArr2.count
//                        if(size > 1 ) {
//                            if let _:String = fullNameArr2[1]  {
//                                let hourstring:String = fullNameArr2[1]
//                                let numberFromString:Int = Int(hourstring)!
//                                eventMinutes = numberFromString
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        arrayints.append(eventHour)
//        arrayints.append(eventMinutes)
//        return arrayints
//    }
//
//    //    func hourisless (itemx: allKindEventsForListDesign, itemy: allKindEventsForListDesign) -> Bool {
//    //        var islessh:Bool  = false
//    //        var eventHour:Int = 0
//    //        var eventMinutes:Int = 0
//    //        var eventSecondHour:Int = 0
//    //        var eventSecondMinutes:Int = 0
//    //        //   if itemx.iCoordinatedServiceId > 0 { don't care all events has starting and ending hours and hollydays are in separated array
//    //        if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
//    //            if a1 == "0" {
//    //                //now get the real hour
//    //                if let a2:Character =  itemx.fromHour[itemx.fromHour.startIndex.advancedBy(1)]{
//    //                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
//    //                    if a2 == "0" {
//    //                        //    print("ora1 0 add to 0")
//    //                        eventHour = 0
//    //                    }
//    //                    else {
//    //                        //     print("ora1 \(a2) add to \(a2)") //section
//    //                        let str = String(a2)
//    //                        let IntHOUR:Int = Int(str)!
//    //                        eventHour = IntHOUR
//    //
//    //                    }
//    //                }
//    //            }
//    //            else { //full hour 2 chars
//    //                let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
//    //                let size = fullNameArr.count
//    //                if(size > 1 ) {
//    //                    if let _:String = fullNameArr[0]  {
//    //                        let hourstring:String = fullNameArr[0]
//    //                        let numberFromString:Int = Int(hourstring)!
//    //                        eventHour = numberFromString
//    //                    }
//    //                }
//    //            }
//    //        }
//    //        if let a2:Character =  itemy.fromHour[itemy.fromHour.startIndex] {
//    //            if a2 == "0" {
//    //                //now get the real hour
//    //                if let a3:Character =  itemy.fromHour[itemy.fromHour.startIndex.advancedBy(1)]{
//    //                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
//    //                    if a3 == "0" {
//    //                        //    print("orax1 0 add to 0")
//    //                        eventHour = 0
//    //                    }
//    //                    else {
//    //                        //     print("orax1 \(a2) add to \(a2)") //section
//    //                        let str = String(a3)
//    //                        let IntHOUR:Int = Int(str)!
//    //                        eventSecondHour = IntHOUR
//    //
//    //                    }
//    //                }
//    //            }
//    //            else { //full hour 2 chars
//    //                let fullNameArr = itemy.fromHour.componentsSeparatedByString(":")
//    //                let size = fullNameArr.count
//    //                if(size > 1 ) {
//    //                    if let _:String = fullNameArr[0]  {
//    //                        let hourstring:String = fullNameArr[0]
//    //                        let numberFromString:Int = Int(hourstring)!
//    //                        eventSecondHour = numberFromString
//    //                    }
//    //                }
//    //            }
//    //        }
//    //
//    //
//    //
//    //
//    //        if eventHour < eventSecondHour {
//    //            islessh = true
//    //        } else  if eventHour == eventSecondHour {
//    //            //minutes compare
//    //            let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
//    //            let size = fullNameArr.count
//    //            if(size > 1 ) {
//    //                if let _:String = fullNameArr[1]  {
//    //                    let hourstring:String = fullNameArr[1]
//    //                    if let a1:Character =  hourstring[hourstring.startIndex] {
//    //                        if a1 == "0" {
//    //                            //now get the real minute
//    //                            if let a2:Character =  hourstring[hourstring.startIndex.advancedBy(1)]{
//    //                                if a2 == "0" {
//    //                                    //     print("minutul 0 add to 0")
//    //                                    eventMinutes = 0
//    //                                }
//    //                                else {
//    //                                    //     print("minutul \(a2) add to \(a2)") //section
//    //                                    let str = String(a2)
//    //                                    let IntHOUR:Int = Int(str)!
//    //                                    eventMinutes = IntHOUR
//    //
//    //                                }
//    //                            }
//    //                        }
//    //                        else { //full minutes 2 chars
//    //                            let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
//    //                            let size = fullNameArr.count
//    //                            if(size > 1 ) {
//    //                                if let _:String = fullNameArr[1]  {
//    //                                    let hourstring:String = fullNameArr[1]
//    //                                    let numberFromString:Int = Int(hourstring)!
//    //                                    eventMinutes = numberFromString
//    //                                }
//    //                            }
//    //                        }
//    //                    }
//    //                }
//    //            }
//    //            let fullNameArr2 = itemy.fromHour.componentsSeparatedByString(":")
//    //            let size2 = fullNameArr2.count
//    //            if(size2 > 1 ) {
//    //                if let _:String = fullNameArr2[1]  {
//    //                    let hourstring:String = fullNameArr2[1]
//    //                    if let a1:Character =  hourstring[hourstring.startIndex] {
//    //                        if a1 == "0" {
//    //                            //now get the real minute
//    //                            if let a2:Character =  hourstring[hourstring.startIndex.advancedBy(1)]{
//    //                                if a2 == "0" {
//    //                                    //     print("minutulx 0 add to 0")
//    //                                    eventSecondMinutes = 0
//    //                                }
//    //                                else {
//    //                                    //     print("minutulx \(a2) add to \(a2)") //section
//    //                                    let str = String(a2)
//    //                                    let IntHOUR:Int = Int(str)!
//    //                                    eventSecondMinutes = IntHOUR
//    //
//    //                                }
//    //                            }
//    //                        }
//    //                        else { //full minutes 2 chars
//    //                            let fullNameArr = itemy.fromHour.componentsSeparatedByString(":")
//    //                            let size = fullNameArr.count
//    //                            if(size > 1 ) {
//    //                                if let _:String = fullNameArr[1]  {
//    //                                    let hourstring:String = fullNameArr[1]
//    //                                    let numberFromString:Int = Int(hourstring)!
//    //                                    eventSecondMinutes = numberFromString
//    //                                }
//    //                            }
//    //                        }
//    //                    }
//    //                }
//    //            }
//    //            if eventMinutes <= eventSecondMinutes {
//    //                islessh = false //we need only hours
//    //            } else {
//    //                islessh = false
//    //            }
//    //
//    //        }
//    //        //        else {
//    //        //            islessh = false
//    //        //        }
//    //        //\\print ("oraacum \(eventHour) - eventMinutes \(eventMinutes) si eventHour \(eventSecondHour)  eventMinutes \(eventSecondMinutes) ")
//    //
//    //        return islessh
//    //    }
//    //    func DAYEventstohours()
//    //    {
//    //        //we know we are in the same day so don't care anymore of datestring from arrEventsCurrentDay
//    //        //clear all hours now
//    //        //1.events for all day - have full hours and will be displayed above list
//    //        //2.events in calendar with hours first in row
//    //        //3.bthere with hours
//    //        initALLSECTIONSFINAL()
//    //        for  itemx in PERFECTSENSE
//    //        {
//    //              print(" aria  finala\(itemx.title)")
//    //              print(" fromHour\(itemx.fromHour) tohour\(itemx.toHour)")
//    //            /////1.
//    //            //       if  itemx.dateEvent == currentDate {
//    //            if itemx.fromHour == "00:00" && itemx.toHour == "23:59" {
//    //                  print("allday ")
//    //                //\\add to above table list
//    //            }
//    //            //    }
//    //            //  else
//    //            //           /////2.
//    //            //\\print ("itemx.iCoordinatedServiceId \(itemx.iCoordinatedServiceId)")
//    //            if itemx.iCoordinatedServiceId == 0  && itemx.fromHour != "00:00" && itemx.toHour != "23:59"{
//    //                if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
//    //                    if a1 == "0" {
//    //                        //now get the real hour
//    //                        if let a2:Character =  itemx.fromHour[itemx.fromHour.startIndex.advancedBy(1)]{
//    //                            //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
//    //                            if a2 == "0" {
//    //                                //   print("ora1 0 add to 0")
//    //                                for inthour in arrHoursInt {
//    //                                    if inthour == 0 {
//    //                                        ALLSECTIONSFINAL[0].1.append(itemx)
//    //                                    }
//    //                                }
//    //                            }
//    //                            else {
//    //                                //     print("ora1 \(a2) add to \(a2)") //section
//    //                                let str = String(a2)
//    //                                let IntHOUR:Int = Int(str)!
//    //                                for inthour in arrHoursInt {
//    //                                    if inthour == IntHOUR {
//    //                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
//    //                                    }
//    //                                }
//    //                            }
//    //                        }
//    //                    }
//    //                    else { //full hour 2 chars
//    //                        let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
//    //
//    //                        let size = fullNameArr.count
//    //                        if(size > 1 ) {
//    //                            if let _:String = fullNameArr[0]  {
//    //                                let hourstring:String = fullNameArr[0]
//    //                                let numberFromString:Int = Int(hourstring)!
//    //                                //     print("ora1 \(numberFromString) add to \(numberFromString)")
//    //                                for inthour in arrHoursInt {
//    //                                    if inthour == numberFromString {
//    //                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
//    //                                    }
//    //                                }
//    //                            }
//    //                        }
//    //                    }
//    //                }
//    //            }
//    //            /////3.
//    //            if itemx.iCoordinatedServiceId > 0 {
//    //                //                for ArwenEvenstar in PERFECTSENSE {
//    //                //                    if itemx.fromHour == ArwenEvenstar.fromHour && itemx.toHour == ArwenEvenstar.toHour && itemx.title == ArwenEvenstar.title && itemx.iCoordinatedServiceId != ArwenEvenstar.iCoordinatedServiceId {
//    //                //                          print("am gasit Arwen in LOTR")
//    //                //                    } else {
//    //                //                           print("wrong Arwen in LOTR")
//    //                //                    }
//    //                //                }
//    //
//    //                if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
//    //                    if a1 == "0" {
//    //                        //now get the real hour
//    //                        if let a2:Character =  itemx.fromHour[itemx.fromHour.startIndex.advancedBy(1)]{
//    //                            //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
//    //                            if a2 == "0" {
//    //                                //   print("ora1 0 add to 0")
//    //                                for inthour in arrHoursInt {
//    //                                    if inthour == 0 {
//    //                                        ALLSECTIONSFINAL[0].1.append(itemx)
//    //                                    }
//    //                                }
//    //                            }
//    //                            else {
//    //                                //    print("ora1 \(a2) add to \(a2)") //section
//    //                                let str = String(a2)
//    //                                let IntHOUR:Int = Int(str)!
//    //                                for inthour in arrHoursInt {
//    //                                    if inthour == IntHOUR {
//    //                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
//    //                                    }
//    //                                }
//    //                            }
//    //                        }
//    //                    }
//    //                    else { //full hour 2 chars
//    //                        let fullNameArr = itemx.fromHour.componentsSeparatedByString(":")
//    //
//    //                        let size = fullNameArr.count
//    //                        if(size > 1 ) {
//    //                            if let _:String = fullNameArr[0]  {
//    //                                let hourstring:String = fullNameArr[0]
//    //                                let numberFromString:Int = Int(hourstring)!
//    //                                //     print("ora1 \(numberFromString) add to \(numberFromString)")
//    //                                for inthour in arrHoursInt {
//    //                                    if inthour == numberFromString {
//    //                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
//    //                                    }
//    //                                }
//    //                            }
//    //                        }
//    //                    }
//    //                }
//    //            }
//    //        }
//    //          print("ALLSECTIONSFINAL \(ALLSECTIONSFINAL) si count \(ALLSECTIONSFINAL.count)")
//    //        ALLSECTIONSFINALFILTERED = ALLSECTIONSFINAL
//    //
//    //
//    //    }
//
//
//}
//extension Array {
//
//    func filterDuplicatesz(@noescape includeElement: (lhs:Element, rhs:Element) -> Bool) -> [Element]{
//        var results = [Element]()
//
//        forEach { (element) in
//            let existingElements = results.filter {
//                return includeElement(lhs: element, rhs: $0)
//            }
//            if existingElements.count == 0 {
//                results.append(element)
//            }
//        }
//
//        return results
//    }
//
//}
//public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
//    return lhs.isEqualToDate(rhs)
//}
//
//public func <(lhs: NSDate, rhs: NSDate) -> Bool {
//    return lhs.compare(rhs) == .OrderedAscending
//}
//func colorWithHexString (hex:String) -> UIColor {
//    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
//    print("cString \(cString)")
//    if String(cString) == "#EAEAEA" || String(cString) == "EAEAEA" {
//
//        cString = "#FF3300"
//    }
//
//    if (cString.hasPrefix("#")) {
//        cString = (cString as NSString).substringFromIndex(1)
//    }
//    if (cString.characters.count != 6) {
//        // return UIColor.grayColor()
//        cString = "#E60073"
//    }
//
//
//    var rString = (cString as NSString).substringToIndex(2)
//    var gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
//    var bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
//
//    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
//    NSScanner(string: rString).scanHexInt(&r)
//    NSScanner(string: gString).scanHexInt(&g)
//    NSScanner(string: bString).scanHexInt(&b)
//
//
//    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
//}
//extension NSDate: Comparable { }
//extension CALayer {
//
//    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
//
//        var border = CALayer()
//
//        switch edge {
//        case UIRectEdge.Top:
//            border.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), thickness)
//            break
//        case UIRectEdge.Bottom:
//            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, UIScreen.mainScreen().bounds.width, thickness)
//            break
//        case UIRectEdge.Left:
//            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
//            break
//        case UIRectEdge.Right:
//            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
//            break
//        default:
//            break
//        }
//
//        border.backgroundColor = color.CGColor;
//
//        self.addSublayer(border)
//    }
//
//}
//
//
//

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
