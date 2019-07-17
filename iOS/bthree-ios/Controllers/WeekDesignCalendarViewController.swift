//
//  WeekDesignCalendarViewController.swift
//  bthree-ios
//
//  Created by User on 16.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

protocol clickToDayInWeekDelegate {
    func clickToDayInWeek()
    
}

//לקוח - תצוגת שבוע
class WeekDesignCalendarViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,enterOnDayDelegate {
    var dtDateStart:Date = Date()
    var dtDateEnd:Date = Date()
    @IBOutlet var arrowleft: UIImageView!
    @IBOutlet var arrowright: UIImageView!
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
    
    
    @IBAction func btnSync(_ sender: eyeSynCheckBox) {
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            if (sender.isCecked == false) {
                Global.sharedInstance.getEventsFromMyCalendar()
                Global.sharedInstance.isSyncWithGoogelCalendar = true
                collWeek.reloadData()
            } else {
                Global.sharedInstance.isSyncWithGoogelCalendar = false
                collWeek.reloadData()
            }
        }
    }
    
    
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
    
    @IBOutlet weak var lblDate: UILabel!
    
//    @IBAction func btnEnterDateClick(sender: AnyObject) {
//        enterOnDay(sender.tag)
//    }
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

    

    //הקודם  (ולא הבא)
   
  
           @IBAction func btnNext(_ sender: AnyObject) {
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

        //        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
        //            let fontSize:CGFloat = self.lblDays.font.pointSize;//16
        //            lblDays.font = UIFont(name: lblDays.font.fontName, size: 14)
        //{
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
        setEventsArray(currentDate)
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
        setDateEnablity()
        
        collWeek.reloadData()
    }
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    
    //הבא (ולא הקודם)
  @IBAction func btnPrevious(_ sender: AnyObject) {
        //בלחיצה על הבא מוצגים הימים בשבוע הבא
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

        setEventsArray(currentDate)
        //fix it
       // lblDate.text = ""//"\(monthName) \(yearToday)"
        setDateEnablity()
        collWeek.reloadData()
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
    let calendar = Foundation.Calendar.current
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
        
        for i in 0..<7
        {
            datesInWeekArray.append(
                Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i+1))
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
    }
    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bestmode()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:9)
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
                //st - כדי שירענן את הכפתורים ולא ישאיר לפי הקודם
            else
            {
                (arrayButtons[6-i] as UIButton).isEnabled = true
                (arrayLabelsDayNum[6-i] as UILabel).textColor =  UIColor.white
                (arrayLabelsdate[6-i] as UILabel).textColor =  UIColor.white
            }
        }

        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:EventsForWeek12ViewsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsForWeek12ViewsCollectionViewCell",for: indexPath) as! EventsForWeek12ViewsCollectionViewCell
        cell.indexDayOfWeek = indexPath.row % 8 - 1
        cell.indexHourOfDay = indexPath.row / 8
        cell.IsToppTop = false
        cell.IsMiddleeTop = false
        cell.IsButtomTop = false
        cell.IsToppButtom = false
        cell.IsMiddleeButtom = false
        cell.IsButtomButtom = false
        
        cell.viewTopInTop.isHidden = true
        cell.viewMiddleInTop.isHidden = true
        cell.viewButtomInTop.isHidden = true
        cell.viewButtominButtom.isHidden = true
        cell.viewMiddleInButtom.isHidden = true
        cell.viewTopInButtom.isHidden = true
        
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
        cell.delegate = Global.sharedInstance.calendarClient
        
        let cell1:HoursCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hours",for: indexPath) as! HoursCollectionViewCell
        
        //   if Global.sharedInstance.rtl
//        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0
//        {
//            cell.transform = scalingTransform
//            cell1.transform = scalingTransform
//        }
        
        
        if indexPath.row == 0 || indexPath.row % 8 == 0
        {
            cell1.setDisplayData(arrHours[indexPath.row / 8])
            return cell1
        }
        else
        {
            hasEvent = false
            
            dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
            
            let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: indexPath.row % 8)
            
            setEventsArray(curDate)
            
            //מעבר על האירועים של ביזר
            
            for btEvent in Global.sharedInstance.bthereEventsForWeek[(indexPath.row % 8) - 1]
                
            {
                cell.hasBthereEvent = true
                let str:String = btEvent.objProviderServiceDetails[0].nvServiceName
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
                    if hourS == hourE! - 1 && minuteS! > 40
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
            }
            
            
            //אירועים של המכשיר
            if hasEvent == true
            {
                cell.hasEvent =  true
                
                dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
                
                let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: indexPath.row % 8)
                
                
                setEventsArray(curDate)
                
                if hasEvent == true && Global.sharedInstance.isSyncWithGoogelCalendar == true
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
                        
                    }
                    
                    
                }
            }
            else
            {
                
                
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
            
            if yearEvent == yearToday && monthEvent == monthToday && dayEvent == dayToday
            {
                arrEventsCurrentDay.append(event)
                hasEvent = true
            }
        }
        
    }
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
    
    @objc func showSync()
    {
        if btnSync.isCecked == false
        {
            Global.sharedInstance.getEventsFromMyCalendar()
            btnSync.isCecked = true
            Global.sharedInstance.isSyncWithGoogelCalendar = true
            collWeek.reloadData()
        }
        else
        {
            btnSync.isCecked = false
            Global.sharedInstance.isSyncWithGoogelCalendar = false
            collWeek.reloadData()
        }
    }
    func checkDevice()
    {
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            lblDays.font = UIFont(name: lblDays.font.fontName, size: 22)
           
            
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
    func  bestmode() {
        
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            self.viewSync.isHidden = false
            self.btnSync.isHidden = false
        } else {
            self.viewSync.isHidden = true
            self.btnSync.isHidden = true
        }
        checkDevice()
        imgCurrentDay.isHidden = true
        if Global.sharedInstance.isSyncWithGoogelCalendar == true
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
        imgCurrentDay.isHidden = true
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
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
        dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
        
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
                self.ingTrailing.constant =  ((self.view.frame.width / 8) *
                    CGFloat(self.dayOfWeekToday))
            })
        }
        else{
            imgCurrentDay.isHidden = true
        }

    }
    
}
