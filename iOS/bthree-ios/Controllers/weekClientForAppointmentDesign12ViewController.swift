//
//  weekClientForAppointmentDesign12ViewController.swift
//  Bthere
//
//  Created by User on 15.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
//תצוגת שבוע של יומן ספק שהלקוח רואה

protocol enterOnDayDelegate {
    func enterOnDay(_ tag:Int)
}

class weekClientForAppointmentDesign12ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,enterOnDayDelegate,iCarouselDataSource,iCarouselDelegate {
    //JMODE PLUS
    var ProviderServicesArray:Array<objProviderServices> = Array<objProviderServices>()
    @IBOutlet var btnBACK: UIButton!
    @IBOutlet var carousel: iCarousel!
    var dtDateStart:Date = Date()
    var dtDateEnd:Date = Date()
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var isfromSPECIALiCustomerUserId:Int = 0
    var isfromSPECIALSUPPLIER:Bool = false
    var bIsNext:Bool = false
    var ISNONEED:Bool = false
    var iMonth:Int = 0
    var iYear:Int = 0
    var iDay:Int = 0
    //END JMODE
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
    let generic:Generic = Generic()
    var firstViewInFreeHour:Int = -1//הטג של הויו הראשון בשעה פנויה, עליו נציג את השעות
    
    var hightCell:CGFloat = 0
    var hightViewBlue:CGFloat = 0//גובה של הוי הצבוע שמראה על התור הפנוי
    var hightViewClear:CGFloat = 0
    var minute:Int = 0
    var minute1:Int = 0
    var isShowFreeDay:Int = 0//flag to know if there isnt any free hour in that hour
    
    
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
    
  //  @IBOutlet weak var lblDate: UILabel!
    @IBAction func btnBACK(_ sender: AnyObject){
        if self.isfromSPECIALSUPPLIER == false {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//            let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
//
//            let vc = storyboard.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
//            let viewCon = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as!  entranceCustomerViewController
//            if Global.sharedInstance.currentUser.iUserId == 0 {
//                frontviewcontroller?.pushViewController(vc, animated: false)
//            } else {
//                frontviewcontroller?.pushViewController(viewCon, animated: false)
//            }
//
//            //initialize REAR View Controller- it is the LEFT hand menu.
//
//            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//            let mainRevealController = SWRevealViewController()
//
//            mainRevealController.frontViewController = frontviewcontroller
//            mainRevealController.rearViewController = rearViewController
//            let window :UIWindow = UIApplication.shared.keyWindow!
//            window.rootViewController = mainRevealController
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

    
    // If eye design is set on  need to show device event
    @IBAction func btnSync(_ sender: eyeSynCheckBox) {
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            if (sender.isCecked == false) {
                Global.sharedInstance.getEventsFromMyCalendar()
                Global.sharedInstance.isSyncWithGoogleCalendarAppointment = true
                collWeek.reloadData()
            } else {
                Global.sharedInstance.isSyncWithGoogleCalendarAppointment = false
                collWeek.reloadData()
            }
        }
    }
    
    
    // onClick on the spech day in week
    @IBAction func btnEnterDateClick(_ sender: AnyObject) {
        //enterOnDay(sender.tag)
     //   @IBAction func btnEnterDateClick(sender: AnyObject) {
            print("sender.tag \(sender.tag)")
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
   // }
    
    
    //הקודם  (ולא הבא)
    @IBAction func btnPrevious(_ sender: AnyObject) {
        //בלחיצה על הקודם מוצגים הימים בשבוע הקודם
        checkDevice()
        hasEvent = false
        /////////////
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
        
  arrayDays = [Int(lblDay1.text!)!,Int(lblDay2.text!)!,Int(lblDay3.text!)!,Int(lblDay4.text!)!,Int(lblDay5.text!)!,Int(lblDay6.text!)!,Int(lblDay7.text!)!]
        //        lblDate.text = "\(monthName) \(yearToday)"
        
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        
        //אתחול המערך של תאריכי השבוע
        datesInWeekArray = []
        for i in 0..<7
        {
            datesInWeekArray.append(
                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
        }
        
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        //אתחול מערך השעות הפנויות לשבוע
        self.generic.showNativeActivityIndicator(self)
        
        for i in 0 ..< 7 {
            
            let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i + 1)
            
            Global.sharedInstance.setFreeHours(curDate, dayOfWeek: i)
            Global.sharedInstance.getBthereEvents(curDate, dayOfWeek: i)
        }
        
        self.generic.hideNativeActivityIndicator(self)
        
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
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        dtDateStart = datesInWeekArraysorted[0]
        dtDateEnd = datesInWeekArraysorted[6]
        
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
        
        ////////////
        iYear =  componentsEventx.year!
        iMonth = componentsEventx.month!
        iDay = componentsEventx.day!
        iFilterByMonth = iMonth
        iFilterByYear = iYear
   //     getFreeDaysForServiceProvider(true, NONEED: true)
        GetFreeTimesForServiceProviderByDaysOrHoures()
        //////////////

        setDateEnablity()
        
        collWeek.reloadData()
    }
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    

    @IBAction func btnNext(_ sender: AnyObject) {
     
        hasEvent = false
        /////////////
        checkDevice()
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
        

          arrayDays = [Int(lblDay1.text!)!,Int(lblDay2.text!)!,Int(lblDay3.text!)!,Int(lblDay4.text!)!,Int(lblDay5.text!)!,Int(lblDay6.text!)!,Int(lblDay7.text!)!]
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        
        //אתחול המערך של תאריכי השבוע
        datesInWeekArray = []
        for i in 0..<7
        {
            datesInWeekArray.append(
                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
        }
        
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        //אתחול מערך השעות הפנויות לשבוע
        self.generic.showNativeActivityIndicator(self)
        for i in 0 ..< 7 {
            
            let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i + 1)
            
            Global.sharedInstance.setFreeHours(curDate, dayOfWeek: i)
            Global.sharedInstance.getBthereEvents(curDate, dayOfWeek: i)
        }
        self.generic.hideNativeActivityIndicator(self)
        
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
        else{
            imgCurrentDay.isHidden = true
        }
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        dtDateStart = datesInWeekArraysorted[0]
        dtDateEnd = datesInWeekArraysorted[6]
        
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
     ////////////
        iYear =  componentsEventx.year!
        iMonth = componentsEventx.month!
        iDay = componentsEventx.day!
        iFilterByMonth = iMonth
        iFilterByYear = iYear
     //   getFreeDaysForServiceProvider(true, NONEED: true)
        GetFreeTimesForServiceProviderByDaysOrHoures()
        //////////////
        setEventsArray(currentDate)// set all event in spech date
        setDateEnablity() //set enabelity design if date passed
        collWeek.reloadData() //refresh
    }
    
    @IBOutlet weak var collWeek: UICollectionView!
    
    //MARK: - Properties
    
    let language = Bundle.main.preferredLocalizations.first! as NSString
    var arrHoursInt:Array<Int> = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    var arrHours:Array<String> = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","7:00","8:00",
                                  "9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]
    
    var arrEventsCurrentDay:Array<EKEvent> = []
    var flag = false
    var hasEvent = false
    var currentDate:Date = Date()
    var calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    var dayOfWeekToday = 0
    var datesInWeekArray:Array<Date> = Array<Date>()//array of nsdate in week
    
    @IBOutlet weak var viewSync: UIView!
    
    @IBOutlet weak var btnSync: eyeSynCheckBox!
    
    //MARK: - Initial
    //func that get date to init the design by date
    func initDateOfWeek(_ date:Date)
    {
        datesInWeekArray = []
        currentDate = date
        
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        
        for  i in 0..<7
        {
            datesInWeekArray.append(
                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
        }
    }
    func bestmode() {
//   
//        iMonth = 7
//        iDay = 31
//        iYear = 2017
         calendar.timeZone = TimeZone(abbreviation: "GMT+02")!
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
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let day = components.day
        let month = components.month
        let year = components.year
        print("best d m y \(String(describing: day)) \(String(describing: month)) \(year)")
        //today = Calendar.sharedInstance.carrentDate
        iDay = day!
        iFilterByMonth = month!
        iFilterByYear = year!
 
       // getFreeDaysForServiceProvider(false, NONEED: true)
        GetFreeTimesForServiceProviderByDaysOrHoures()
        monthArray = []
        Global.sharedInstance.getEventsFromMyCalendar()
        let leftarrowback = UIImage(named: "sageata2.png")
        
        self.btnBACK.setImage(leftarrowback, for: UIControl.State())
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnBACK.transform = scalingTransform
        }
        btnBACK.imageView!.contentMode = .scaleAspectFit
        if Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true
        {
            btnSync.isCecked = true
        }
        else
        {
            btnSync.isCecked = false
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
        setEventsArray(currentDate)
        setDate()
      arrayDays = [Int(lblDay1.text!)!,Int(lblDay2.text!)!,Int(lblDay3.text!)!,Int(lblDay4.text!)!,Int(lblDay5.text!)!,Int(lblDay6.text!)!,Int(lblDay7.text!)!]
    //     arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]
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
        
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        var  isFindToday:Bool = false
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
        else{
            imgCurrentDay.isHidden = true
        }
        carousel.delegate = self
        carousel.dataSource = self
        if Global.sharedInstance.giveServicesArray.count > 0 {
            let id  = Global.sharedInstance.giveServicesArray[0].iUserId
            if id > 0 {
                Global.sharedInstance.idWorker = id
                Global.sharedInstance.indexRowForIdGiveService = 0
            } else {
                Global.sharedInstance.idWorker = -1
                Global.sharedInstance.indexRowForIdGiveService = -1
            }
            self.carousel.scrollToItem(at: 0, animated: true)
    }
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        let  index:Int = carousel.currentItemIndex
        
        var workerid:Int = 0
        if  Global.sharedInstance.giveServicesArray.count > 0 {
            if let _:User = Global.sharedInstance.giveServicesArray[index]  {
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
//                let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
//                let monthtoask = componentsCurrent.month
//                let yeartoask = componentsCurrent.year
//                let daytoask = componentsCurrent.day
//                if iMonth == monthtoask && iYear == yeartoask {
//                    iDay = daytoask
//                    Calendar.sharedInstance.carrentDate = currentDate
//                    print("workerid \(workerid) si \(index)")
//                    getFreeDaysForServiceProvider(false, NONEED: true)
//                } else {
//                    if iMonth < monthtoask || iYear < yeartoask {
//                        getFreeDaysForServiceProvider(true, NONEED: false)
//                    } else {
//                        getFreeDaysForServiceProvider(true, NONEED: true)
//                    }
//                }
                GetFreeTimesForServiceProviderByDaysOrHoures()
                
            }
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

                    }
                }
            }
        }

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
            label.numberOfLines = 1
            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
            label.font = labelFont
            label.textColor = Colors.sharedInstance.color4
            label.tag = 1
            itemView.addSubview(label)
           
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        //    if index > 0 {
        if let _:User = Global.sharedInstance.giveServicesArray[index] {
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
    
            let underlineAttributedString = NSAttributedString(string:STRinvFirstName.capitalized, attributes: nil)
            label.attributedText = underlineAttributedString
          
        }
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

    // set enable design if date passed
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
                //st - כדי שירענן את הכפתורים ולא ישאיר לפי הקודם
            else
            {
                (arrayButtons[6-i] as UIButton).isEnabled = true
                (arrayLabelsDayNum[6-i] as UILabel).textColor =  UIColor.white
                (arrayLabelsdate[6-i] as UILabel).textColor =  UIColor.white
            }
        }
        
        
    }
    //MARK: - Initials Function
    override func viewDidLoad() {
        super.viewDidLoad()
         calendar.timeZone = TimeZone(abbreviation: "GMT+02")!
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
        // Check if calendar is sync
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
        btnBACK.imageView!.contentMode = .scaleAspectFit
        
        checkDevice()

        hasEvent = false
        
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        
        
           imgCurrentDay.isHidden = true
        
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
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
         arrayDays = [Int(lblDay1.text!)!,Int(lblDay2.text!)!,Int(lblDay3.text!)!,Int(lblDay4.text!)!,Int(lblDay5.text!)!,Int(lblDay6.text!)!,Int(lblDay7.text!)!]
    }
     @IBOutlet var arrowleft: UIImageView!
    @IBOutlet var arrowright: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:14)
        calendar.timeZone = TimeZone(abbreviation: "GMT+02")!
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        monthArray = []
        Global.sharedInstance.getEventsFromMyCalendar()
        
        if Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true
        {
            btnSync.isCecked = true
        }
        else
        {
            btnSync.isCecked = false
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
//        lblDayOfWeek7.text = "S_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        lblDayOfWeek6.text = "M_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        lblDayOfWeek5.text = "T_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        lblDayOfWeek4.text = "W_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        lblDayOfWeek3.text = "THIR_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        lblDayOfWeek2.text = "F_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        lblDayOfWeek1.text = "SHT_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //        }
        
        hasEvent = false
        
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        
        setEventsArray(currentDate)
        setDate()
       arrayDays = [Int(lblDay1.text!)!,Int(lblDay2.text!)!,Int(lblDay3.text!)!,Int(lblDay4.text!)!,Int(lblDay5.text!)!,Int(lblDay6.text!)!,Int(lblDay7.text!)!]
      // arrayDays = [Int(lblDay7.text!)!, Int(lblDay6.text!)!,Int(lblDay5.text!)!,Int(lblDay4.text!)!,Int(lblDay3.text!)!,Int(lblDay2.text!)!,Int(lblDay1.text!)!]
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
        
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        var  isFindToday:Bool = false
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
        else{
            imgCurrentDay.isHidden = true
        }
    }
    // set enable design if date passed
    
    //MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
        isShowFreeDay = 0
        
        let cell:EventsForWeek12ViewsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsForWeek12ViewsCollectionViewCell",for: indexPath) as! EventsForWeek12ViewsCollectionViewCell
        
        cell.indexDayOfWeek = indexPath.row % 8 - 1
        cell.indexHourOfDay = indexPath.row / 8
        
        cell.view0to5.backgroundColor = UIColor.clear
        cell.view5to10.backgroundColor = UIColor.clear
        cell.view10to15.backgroundColor = UIColor.clear
        cell.view15to20.backgroundColor = UIColor.clear
        cell.view20to25.backgroundColor = UIColor.clear
        cell.view25to30.backgroundColor = UIColor.clear
        cell.view30to35.backgroundColor = UIColor.clear
        cell.view35to40.backgroundColor = UIColor.clear
        cell.view40to45.backgroundColor = UIColor.clear
        cell.view45to50.backgroundColor = UIColor.clear
        cell.view50to55.backgroundColor = UIColor.clear
        cell.view55to60.backgroundColor = UIColor.clear
        
        cell.delegateRegister = Global.sharedInstance.calendarAppointment
        
        
        for view in cell.view0to5.subviews
        {
            if view as? UILabel != cell.lblHours1
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view5to10.subviews
        {
            if view as? UILabel != cell.lblHours2
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view10to15.subviews
        {
            if view as? UILabel != cell.lblHours3
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view15to20.subviews
        {
            if view as? UILabel != cell.lblHours4
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view20to25.subviews
        {
            if view as? UILabel != cell.lblHours5
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view25to30.subviews
        {
            if view as? UILabel != cell.lblHours6
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view30to35.subviews
        {
            if view as? UILabel != cell.lblHours7
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view35to40.subviews
        {
            if view as? UILabel != cell.lblHours8
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view40to45.subviews
        {
            if view as? UILabel != cell.lblHours9
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view45to50.subviews
        {
            if view as? UILabel != cell.lblHours10
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view50to55.subviews
        {
            if view as? UILabel != cell.lblHours11
            {
                view.removeFromSuperview()
            }
        }
        for view in cell.view55to60.subviews
        {
            if view as? UILabel != cell.lblHours12
            {
                view.removeFromSuperview()
            }
        }
        
        cell.viewTopInTop.isHidden = true
        cell.viewMiddleInTop.isHidden = true
        cell.viewButtomInTop.isHidden = true
        cell.viewButtominButtom.isHidden = true
        cell.viewMiddleInButtom.isHidden = true
        cell.viewTopInButtom.isHidden = true
        
        
        cell.lblHours1.text = ""
        cell.lblHours2.text = ""
        cell.lblHours3.text = ""
        cell.lblHours4.text = ""
        cell.lblHours5.text = ""
        cell.lblHours6.text = ""
        cell.lblHours7.text = ""
        cell.lblHours8.text = ""
        cell.lblHours9.text = ""
        cell.lblHours10.text = ""
        cell.lblHours11.text = ""
        cell.lblHours12.text = ""
        cell.lblHours1.backgroundColor = UIColor.clear
        cell.lblHours2.backgroundColor = UIColor.clear
        cell.lblHours3.backgroundColor = UIColor.clear
        cell.lblHours4.backgroundColor = UIColor.clear
        cell.lblHours5.backgroundColor = UIColor.clear
        cell.lblHours6.backgroundColor = UIColor.clear
        cell.lblHours7.backgroundColor = UIColor.clear
        cell.lblHours8.backgroundColor = UIColor.clear
        cell.lblHours9.backgroundColor = UIColor.clear
        cell.lblHours10.backgroundColor = UIColor.clear
        cell.lblHours11.backgroundColor = UIColor.clear
        cell.lblHours12.backgroundColor = UIColor.clear
        
        
        
        
        cell.hasEvent =  false
        cell.hasBthereEvent = false
        cell.txtviewDesc.text = ""
        cell.txtViewDescBottom.text = ""
        cell.viewBottom.backgroundColor = UIColor.clear
        cell.viewTop.backgroundColor = UIColor.clear
        
        cell.delegateClickOnDay = self
        cell.delegate = Global.sharedInstance.calendarAppointment
        
        let cell1:HoursCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hours",for: indexPath) as! HoursCollectionViewCell
        
        
     if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
        
       //     cell.transform = scalingTransform
       //     cell1.transform = scalingTransform
        }
        
        
        if indexPath.row == 0 || indexPath.row % 8 == 0
        {
            cell1.setDisplayData(arrHours[indexPath.row / 8])
            return cell1
        }
        else
        {
            
            var index:Int = 0
            hasEvent = false
            
            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
            
            let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: indexPath.row % 8)
            
            setEventsArray(curDate)
            
            //מעבר על השעות הפנויות בשבוע זה
            for var item in Global.sharedInstance.freeHoursForWeek[(indexPath.row % 8) - 1]
            {
                firstViewInFreeHour = -1
                
                let hourStart = Global.sharedInstance.getStringFromDateString(item.objProviderHour.nvFromHour)
                
                let hourEnd = Global.sharedInstance.getStringFromDateString(item.objProviderHour.nvToHour)
                
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
                
                if arrHoursInt[indexPath.row / 8] == hourS//אם שעת ההתחלה שווה לשעה המוצגת
                {
                    if hourE == hourS{//אם גם שעת הסיום שווה לשעה המוצגת
                        
                        showView(cell.view0to5, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view5to10, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view10to15, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view15to20, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view20to25, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view25to30, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view30to35, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view35to40, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view40to45, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view45to50, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view50to55, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view55to60, from: minuteS!, to: minuteE!, param: 0, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    }
                        
                        
                    else//שעת סיום שונה משעת ההתחלה
                    {
                        showView(cell.view0to5, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view5to10, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view10to15, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view15to20, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view20to25, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view25to30, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view30to35, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view35to40, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view40to45, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view45to50, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view50to55, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        showView(cell.view55to60, from: minuteS!, to: minuteE!, param: 1, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                        
                    }
                    isShowFreeDay = 1
                    //cell.hourFree = hourS_Show + ":" + minuteS_Show
                }
                else if arrHoursInt[indexPath.row / 8] > hourS! && arrHoursInt[indexPath.row / 8] < hourE!//אם הוא באמצע הארוע ז״א ששעת התחלה  קטנה מהשעה  המוצגת ושעת הסיום גדולה ש
                {
                    cell.view0to5.backgroundColor = Colors.sharedInstance.color4
                    cell.view0to5.alpha = 0.5
                    cell.lblHours1.tag = index
                    
                    cell.view5to10.backgroundColor = Colors.sharedInstance.color4
                    cell.view5to10.alpha = 0.5
                    cell.lblHours2.tag = index
                    
                    cell.view10to15.backgroundColor = Colors.sharedInstance.color4
                    cell.view10to15.alpha = 0.5
                    cell.lblHours3.tag = index
                    
                    cell.view15to20.backgroundColor = Colors.sharedInstance.color4
                    cell.view15to20.alpha = 0.5
                    cell.lblHours4.tag = index
                    
                    cell.view20to25.backgroundColor = Colors.sharedInstance.color4
                    cell.view20to25.alpha = 0.5
                    cell.lblHours5.tag = index
                    
                    cell.view25to30.backgroundColor = Colors.sharedInstance.color4
                    cell.view25to30.alpha = 0.5
                    cell.lblHours6.tag = index
                    
                    cell.view30to35.backgroundColor = Colors.sharedInstance.color4
                    cell.view30to35.alpha = 0.5
                    cell.lblHours7.tag = index
                    
                    cell.view35to40.backgroundColor = Colors.sharedInstance.color4
                    cell.view35to40.alpha = 0.5
                    cell.lblHours8.tag = index
                    
                    cell.view40to45.backgroundColor = Colors.sharedInstance.color4
                    cell.view40to45.alpha = 0.5
                    cell.lblHours9.tag = index
                    
                    cell.view45to50.backgroundColor = Colors.sharedInstance.color4
                    cell.view45to50.alpha = 0.5
                    cell.lblHours10.tag = index
                    
                    cell.view50to55.backgroundColor = Colors.sharedInstance.color4
                    cell.view50to55.alpha = 0.5
                    cell.lblHours11.tag = index
                    
                    cell.view55to60.backgroundColor = Colors.sharedInstance.color4
                    cell.view55to60.alpha = 0.5
                    cell.lblHours12.tag = index
                    
                    cell.indexDayOfWeek = (indexPath.row % 8) - 1
                    
                    isShowFreeDay = 1
                }
                else if arrHoursInt[indexPath.row / 8] == hourE//שעת סיום שווה לשעה המוצגת
                    
                {
                    showView(cell.view0to5, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view5to10, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view10to15, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view15to20, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view20to25, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view25to30, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view30to35, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view35to40, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view40to45, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view45to50, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view50to55, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    showView(cell.view55to60, from: 0, to: minuteE!, param: 2, index: index, cell: cell, indexDayOfWeek: indexPath.row % 8)
                    isShowFreeDay = 1
                }
                index += 1
            }
            //מעבר על האירועים של ביזר
            //////////////////
            for btEvent in Global.sharedInstance.bthereEventsForWeek[(indexPath.row % 8) - 1]
            {
                cell.hasBthereEvent = true
                
                var str = ""
               
                    for item in btEvent.objProviderServiceDetails {
                    if str == ""
                            {
                                if let _:String  = item.nvServiceName {
                                    str = item.nvServiceName 
                                }
                            } else {
                                str = "\(str),\(item.nvServiceName )"
                            }
                            
                        
                        
                }
            
            
              
                
             //   let str:String = btEvent.objProviderServiceDetails[0].nvServiceName
                firstViewInFreeHour = -1
                
                let hourStart = Global.sharedInstance.getStringFromDateString(btEvent.nvFromHour)
                
                let hourEnd = Global.sharedInstance.getStringFromDateString(btEvent.nvToHour)
                
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
                
                if arrHoursInt[indexPath.row / 8] == hourS//אם שעת ההתחלה שווה לשעה המוצגת
                {
                    if hourE == hourS{//אם גם שעת הסיום שווה לשעה המוצגת
                        
                        if minuteS! < 5
                        {
                            
                            cell.setDisplayData(1, isTop: true, description: str,descTop: true, isBthereEvent: true)
                        }
                        else if minuteS! < 40
                        {
                            cell.setDisplayData(1, isTop: false, description: str,descTop: false, isBthereEvent: true)
                        }
                        addBorderToBtEvent(cell.view0to5, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view5to10, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view10to15, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view15to20, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view20to25, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view25to30, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view30to35, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view35to40, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view40to45, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view45to50, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view5to10, from: minuteS!, to: minuteE!, param: 0)
                        addBorderToBtEvent(cell.view55to60, from: minuteS!, to: minuteE!, param: 0)
                    }
                        
                        
                    else//שעת סיום שונה משעת ההתחלה
                    {
                        if minuteS! < 5
                        {
                            
                            cell.setDisplayData(1, isTop: true, description: str,descTop: true, isBthereEvent: true)
                        }
                        else if minuteS! < 40
                        {
                            cell.setDisplayData(1, isTop: false, description: str,descTop: false, isBthereEvent: true)
                        }
                        addBorderToBtEvent(cell.view0to5, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view5to10, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view10to15, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view15to20, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view20to25, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view25to30, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view30to35, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view35to40, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view40to45, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view45to50, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view50to55, from: minuteS!, to: minuteE!, param: 1)
                        addBorderToBtEvent(cell.view55to60, from: minuteS!, to: minuteE!, param: 1)
                        
                        
                    }
                    isShowFreeDay = 1
                    //cell.hourFree = hourS_Show + ":" + minuteS_Show
                }
                else if arrHoursInt[indexPath.row / 8] > hourS! && arrHoursInt[indexPath.row / 8] < hourE!//אם הוא באמצע הארוע ז״א ששעת התחלה  קטנה מהשעה  המוצגת ושעת הסיום גדולה ש
                {
                    if minuteS! > 40
                    {
                        cell.setDisplayData(1, isTop: true, description: str,descTop: true, isBthereEvent: true)
                    }
                    
                    addRightLeftBorder(cell.view0to5)
                    addRightLeftBorder(cell.view5to10)
                    addRightLeftBorder(cell.view10to15)
                    addRightLeftBorder(cell.view15to20)
                    addRightLeftBorder(cell.view20to25)
                    addRightLeftBorder(cell.view25to30)
                    addRightLeftBorder(cell.view30to35)
                    addRightLeftBorder(cell.view35to40)
                    addRightLeftBorder(cell.view40to45)
                    addRightLeftBorder(cell.view45to50)
                    addRightLeftBorder(cell.view50to55)
                    addRightLeftBorder(cell.view55to60)
                    
                }
                else if arrHoursInt[indexPath.row / 8] == hourE//שעת סיום שווה לשעה המוצגת
                    
                {
                    if hourS! == hourE! - 1 && minuteS! > 40
                    {
                        cell.setDisplayData(1, isTop: true, description: str,descTop: true, isBthereEvent: true)
                    }
                    
                    
                    
                    addBorderToBtEvent(cell.view0to5, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view5to10, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view10to15, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view15to20, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view20to25, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view25to30, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view30to35, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view35to40, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view40to45, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view45to50, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view50to55, from: minuteS!, to: minuteE!, param: 2)
                    addBorderToBtEvent(cell.view55to60, from: minuteS!, to: minuteE!, param: 2)
                }
                index += 1
            }
            //////////////////
            //אירועים של המכשיר
            
            if hasEvent == true
            {
                //cell.hasEvent =  true
                
                dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
                
                let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: indexPath.row % 8)
                
                
                setEventsArray(curDate)
                
                if hasEvent == true && Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true
                {
                    //מעבר על האירועים של המכשיר
                    for eve in arrEventsCurrentDay
                        
                    {
                        cell.hasBthereEvent = false
                        let str:String = eve.title
                        firstViewInFreeHour = -1
                        
                        let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: eve.startDate)
                        
                        let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: eve.endDate)
                        
                        let hourS = componentsStart.hour //hour start
                        let minuteS = componentsStart.minute// minute start
                        
                        let hourE = componentsEnd.hour//hour end
                        
                        let minuteE = componentsEnd.minute//minute end
                        
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
                        
                        if arrHoursInt[indexPath.row / 8] == hourS//אם שעת ההתחלה שווה לשעה המוצגת
                        {
                            if hourE == hourS{//אם גם שעת הסיום שווה לשעה המוצגת
                                
                                if minuteS! < 5
                                {
                                    
                                    cell.setDisplayData(1, isTop: true, description: str,descTop: true, isBthereEvent: false)
                                }
                                else if minuteS! < 40
                                {
                                    cell.setDisplayData(1, isTop: false, description: str,descTop: false, isBthereEvent: false)
                                }
                                addBorderToBtEvent(cell.view0to5, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view5to10, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view10to15, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view15to20, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view20to25, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view25to30, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view30to35, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view35to40, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view40to45, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view45to50, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view5to10, from: minuteS!, to: minuteE!, param: 0)
                                addBorderToBtEvent(cell.view55to60, from: minuteS!, to: minuteE!, param: 0)
                            }
                                
                                
                            else//שעת סיום שונה משעת ההתחלה
                            {
                                if minuteS! < 5
                                {
                                    
                                    cell.setDisplayData(1, isTop: true, description: str,descTop: true, isBthereEvent: false)
                                }
                                else if minuteS! < 40
                                {
                                    cell.setDisplayData(1, isTop: false, description: str,descTop: false, isBthereEvent: false)
                                }
                                addBorderToBtEvent(cell.view0to5, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view5to10, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view10to15, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view15to20, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view20to25, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view25to30, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view30to35, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view35to40, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view40to45, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view45to50, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view50to55, from: minuteS!, to: minuteE!, param: 1)
                                addBorderToBtEvent(cell.view55to60, from: minuteS!, to: minuteE!, param: 1)
                                
                                
                            }
                            isShowFreeDay = 1
                            //cell.hourFree = hourS_Show + ":" + minuteS_Show
                        }
                        else if arrHoursInt[indexPath.row / 8] > hourS! && arrHoursInt[indexPath.row / 8] < hourE!//אם הוא באמצע הארוע ז״א ששעת התחלה  קטנה מהשעה  המוצגת ושעת הסיום גדולה ש
                        {
                            if minuteS! > 40
                            {
                                cell.setDisplayData(1, isTop: true, description: str,descTop: true, isBthereEvent: false)
                            }
                            
                            addRightLeftBorder(cell.view0to5)
                            addRightLeftBorder(cell.view5to10)
                            addRightLeftBorder(cell.view10to15)
                            addRightLeftBorder(cell.view15to20)
                            addRightLeftBorder(cell.view20to25)
                            addRightLeftBorder(cell.view25to30)
                            addRightLeftBorder(cell.view30to35)
                            addRightLeftBorder(cell.view35to40)
                            addRightLeftBorder(cell.view40to45)
                            addRightLeftBorder(cell.view45to50)
                            addRightLeftBorder(cell.view50to55)
                            addRightLeftBorder(cell.view55to60)
                            
                        }
                        else if arrHoursInt[indexPath.row / 8] == hourE//שעת סיום שווה לשעה המוצגת
                            
                        {
                            if hourS! == hourE! - 1 && minuteS! > 40
                            {
                                cell.setDisplayData(1, isTop: true, description: str,descTop: true, isBthereEvent: false)
                            }
                            
                            
                            
                            addBorderToBtEvent(cell.view0to5, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view5to10, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view10to15, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view15to20, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view20to25, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view25to30, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view30to35, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view35to40, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view40to45, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view45to50, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view50to55, from: minuteS!, to: minuteE!, param: 2)
                            addBorderToBtEvent(cell.view55to60, from: minuteS!, to: minuteE!, param: 2)
                        }
                        index += 1
                    }
                    
                    
                    
                }
            }
            else if isShowFreeDay == 0
            {
                
                cell.setDisplayData(0, isTop: false,description: "",descTop: true, isBthereEvent: false)
                
                return cell
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 192//8*24
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.size.width / 8, height:  view.frame.size.width / 9)
        
    }
    
    //MARK: - ScrollView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //       collWeek.reloadData()
        // flag = true
        
    }
    
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
        if datesInWeekArray.count == 0 {
            
            datesInWeekArray = []
            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
            
            for i in 0..<7
            {
                datesInWeekArray.append(
                    Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
            }

        }
        var datesInWeekArraysorted = datesInWeekArray.sorted()
        dtDateStart = datesInWeekArraysorted[0]
        dtDateEnd = datesInWeekArraysorted[6]
        
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
        
        
        
        
        //  lblDays.text = "\(lblDay7.text!) - \(lblDay1.text!)"//change 13.10.2016
        
        
        //get the month and day of week names - short
        if monthToday == 0
        {
            monthName = DateFormatter().shortStandaloneMonthSymbols[monthToday]
        }
        else
        {
            monthName = DateFormatter().shortStandaloneMonthSymbols[monthToday - 1]
        }
    
        // - long
        //NSDateFormatter().monthSymbols[monthToday - 1]
        //let dayName = NSDateFormatter().weekdaySymbols[day]
        
        //fix it
    //    lblDate.text = ""//"\(monthName) \(yearToday)"
    }
    
    
    
    
    //פונקציה הבודקת האם לצבוע את הויו אותו היא מקבלת
    //מקבלת:
    //view: הויו אותו יש לצבוע
    //from,to:לשם הבדיקה האם נמצא בטווח של שעה פנויה - האם לצבוע
    //param: כאשר הוא 0 נבדוק האם נמצא בטווח של הדקות,
    //כאשר הוא 1 נבדוק האם גדול מ from
    //וכאשר הוא 2 נבדוק האם קטן מ to
    //index: המיקום של השעה הפנויה במערך
    
    func showView(_ view:UIView,from:Int,to:Int,param:Int, index:Int,cell:EventsForWeek12ViewsCollectionViewCell,indexDayOfWeek:Int)
    {
        cell.indexDayOfWeek = indexDayOfWeek - 1
        if param == 0
        {
            if view.tag >= from && view.tag <= to
            {
                view.backgroundColor = Colors.sharedInstance.color4
                view.alpha = 0.5
                
                saveFreeHourForView(view.tag, index: index, cell: cell)
                
                if firstViewInFreeHour == -1
                {
                    firstViewInFreeHour = view.tag
                }
            }
        }
        else if param == 1
        {
            if view.tag >= from
            {
                view.backgroundColor = Colors.sharedInstance.color4
                view.alpha = 0.5
                
                saveFreeHourForView(view.tag, index: index, cell: cell)
                
                if firstViewInFreeHour == -1
                {
                    firstViewInFreeHour = view.tag
                }
            }
        }
        else if param == 2
        {
            if view.tag <= to
            {
                view.backgroundColor = Colors.sharedInstance.color4
                view.alpha = 0.5
                saveFreeHourForView(view.tag, index: index, cell: cell)
            }
        }
    }
    
    func addBorderToBtEvent(_ view:UIView,from:Int,to:Int,param:Int)
    {
        if param == 0//בשעת התחלה הזהה לש.סיום
        {
            if view.tag >= from && view.tag <= to
            {
                addRightLeftBorder(view)
                
                if firstViewInFreeHour == -1
                {
                    firstViewInFreeHour = view.tag
                    addTopBorder(view)
                }
            }
        }
        else if param == 1//בשעת התחלה השונה משעת סיום
        {
            if view.tag >= from
            {
                addRightLeftBorder(view)
                
                if firstViewInFreeHour == -1
                {
                    firstViewInFreeHour = view.tag
                    addTopBorder(view)
                    
                }
            }
        }
        else if param == 2//בשעת סיום
        {
            if view.tag <= to
            {
                addRightLeftBorder(view)
                if view.tag == to || (view.tag < to && (view.tag + 5) > to)
                {
                    addBottomBorder(view)
                }
            }
        }
    }
    
    //פונקציה זו שומרת בטג של הלייבל (1 מתוך 12) את המיקום במערך של השעה הפנויה בה הוא נמצא.
    //הפונקציה מקבלת טג של הויו כדי לזהות את הליבל וכן אינדקס של המערך.
    func saveFreeHourForView(_ tag:Int,index:Int, cell:EventsForWeek12ViewsCollectionViewCell)
    {
        switch tag {
        case 0:
            cell.lblHours1.tag = index
        case 5:
            cell.lblHours2.tag = index
        case 10:
            cell.lblHours3.tag = index
        case 15:
            cell.lblHours4.tag = index
        case 20:
            cell.lblHours5.tag = index
        case 25:
            cell.lblHours6.tag = index
        case 30:
            cell.lblHours7.tag = index
        case 35:
            cell.lblHours8.tag = index
        case 40:
            cell.lblHours9.tag = index
        case 45:
            cell.lblHours10.tag = index
        case 50:
            cell.lblHours11.tag = index
        case 55:
            cell.lblHours12.tag = index
            
        default:
            cell.lblHours1.tag = index
        }
        
    }
    
    func setEventsArray(_ today:Date)
    {
        arrEventsCurrentDay = []
        for item in Global.sharedInstance.eventList
        {
            let event = item as! EKEvent
            
            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: today)
            
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: event.startDate)
            
            yearToday =  componentsCurrent.year!
            monthToday = componentsCurrent.month!
            dayToday = componentsCurrent.day!
            
            let yearEvent =  componentsEvent.year
            let monthEvent = componentsEvent.month
            let dayEvent = componentsEvent.day
            
            if yearEvent == yearToday && monthEvent == monthToday  && dayEvent == dayToday
            {
                arrEventsCurrentDay.append(event)
                hasEvent = true
            }
        }
        
    }
    
    //check which date is prev
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
    //MARK: - Delegate To Enter date
    func enterOnDay(_ tag:Int)
    {
        var componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        let td:Int =  arrayDays[tag] as! Int
        componentsCurrent.day = td
        
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        
        let dateSelected = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday , add: 7 - tag)
        
        Global.sharedInstance.currDateSelected = dateSelected
        Global.sharedInstance.dateDayClick = dateSelected
        delegate.clickToDayInWeek()
    }
    // if eye design is set on  need to show device event
    
    @objc func showSync()
    {
        if btnSync.isCecked == false
        {
            Global.sharedInstance.getEventsFromMyCalendar()
            btnSync.isCecked = true
            Global.sharedInstance.isSyncWithGoogleCalendarAppointment = true
            collWeek.reloadData()
        }
        else
        {
            btnSync.isCecked = false
            Global.sharedInstance.isSyncWithGoogleCalendarAppointment = false
            collWeek.reloadData()
        }
    }
    //change design if devise is smaller than 6
    func checkDevice()
    {
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            lblDays.font = UIFont(name: lblDays.font.fontName, size: 22)
            }
    }
    
    //MARK: - borders
    //הוספת מסגרת לאירוע
    
    func addRightLeftBorder(_ myView:UIView)
    {
        let leftBorder = UIView()
        leftBorder.frame = CGRect(x: 0, y: 0, width: 2, height: myView.frame.size.height)
        leftBorder.backgroundColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)//Colors.sharedInstance.color1
        myView.addSubview(leftBorder)
        
        let rightBorder = UIView()
        rightBorder.frame = CGRect(x: view.frame.size.width / 8 - 2, y: 0, width: 2, height: myView.frame.size.height)
        rightBorder.backgroundColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)//Colors.sharedInstance.color1
        myView.addSubview(rightBorder)
    }
    
    func addBottomBorder(_ myView:UIView)
    {
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)//Colors.sharedInstance.color1
        bottomBorder.frame = CGRect(x: 0, y: myView.frame.size.height - 2, width: view.frame.size.width - (view.frame.size.width / 8), height: 2)
        myView.addSubview(bottomBorder)
        
    }
    
    func addTopBorder(_ myView:UIView)
    {
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)//Colors.sharedInstance.color1
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.size.width - (view.frame.size.width / 8), height: 2)
        myView.addSubview(topBorder)
        
        
    }
    //JMODE CLEAN AND VERIFYED
    func numberOfItems(in carousel: iCarousel) -> Int {
        if  Global.sharedInstance.giveServicesArray.count > 0 {
            if  Global.sharedInstance.giveServicesArray.count > 1 {
                self.carousel.type = .linear
            } else {
                self.carousel.type = .linear
                //  self.carousel.scrollEnabled = false
                self.carousel.isUserInteractionEnabled = false
            }
        }
        return  Global.sharedInstance.giveServicesArray.count
    }

    
    func getFreeDaysForServiceProvider(_ bIsNext:Bool,NONEED:Bool){
        //        var dicGetFreeDaysForServiceProvider:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        //compuse string date
        var monthneed:String = ""
        var yearneeded:String = ""
        var dayneeded:String = ""
        monthneed = String(iMonth)
        yearneeded = String(iYear)
        let MyBool:Bool = true
        self.ISNONEED = NONEED
        self.bIsNext = bIsNext
        if NONEED == false {
            //just get customer orders no need for freedays since month is in past
            Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
            Global.sharedInstance.arrayGiveServicesKods = []
            Global.sharedInstance.dateFreeDays = []
          //  self.GetCustomerOrders()
        } else {
            
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
                
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                //new 23-01-17
                Global.sharedInstance.dicGetFreeDaysForServiceProvider["nvDate"] = composedDATE as AnyObject
            //    print("Global.sharedInstance.dicGetFreeDaysForServiceProvider \(self.PREETYJSON_J(Global.sharedInstance.dicGetFreeDaysForServiceProvider, pathofweb: "cHOSEW"))")
                api.sharedInstance.GetFreeDaysForServiceProvider(Global.sharedInstance.dicGetFreeDaysForServiceProvider, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                    {
                        
                //        showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        
                        let ps:providerFreeDaysObj = providerFreeDaysObj()
                        
                        Global.sharedInstance.getFreeDaysForService = ps.objFreeDaysToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                        //איפוס המערך מנתונים ישנים
                        Global.sharedInstance.dateFreeDays = []
                        print("Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")
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
                       self.GetCustomerOrders()
                
                    }
                    
                    
                    
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                })
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
    //GetFreeDaysForServiceProvider is replaced by call to GetFreeTimesForServiceProviderByDaysOrHours
    func GetFreeTimesForServiceProviderByDaysOrHoures() {
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd"
        //compose with 1st day of week till end from datesInWeekArray
        // Get first day of month
        let nvFromDate = dateFormatterx.string(from: datesInWeekArray[0])
        let nvToDate = dateFormatterx.string(from: datesInWeekArray[6])
        
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
            Global.sharedInstance.dicGetFreeDaysForServiceProvider["bFreeDaysOnly"] = true as AnyObject //to get all days in month with free days
          
            print("Global.sharedInstance.dicGetFreeDaysForServiceProvider \(self.PREETYJSON_J(Global.sharedInstance.dicGetFreeDaysForServiceProvider, pathofweb: "cHOSEW"))")
            api.sharedInstance.GetFreeTimesForServiceProviderByDaysOrHoures(Global.sharedInstance.dicGetFreeDaysForServiceProvider, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                
                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                {
                    self.generic.hideNativeActivityIndicator(self)
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
                    print("Error \(String(describing: Error))")
             
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
        
        
    }

    func GetCustomerOrders()  {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        _ = NSArray()
        
        
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
                     //\\   print("what is getttt \(String(describing: RESPONSEOBJECT["Result"]))")
                        //  arr = responseObject["Result"] as! NSArray
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
                                //\\    print("item to test \(item.getDic())")
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
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
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
                             //   Global.sharedInstance.whichReveal = false
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
                                    USERDEF.set(self.isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
                                    USERDEF.synchronize()
                                    print("zzzisfromSPECIALiCustomerUserId  \(self.isfromSPECIALiCustomerUserId)")
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
