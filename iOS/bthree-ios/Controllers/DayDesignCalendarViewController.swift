//
//  DayDesignCalendarViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 24.9.2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI


class DayDesignCalendarViewController: UIViewController,setDateDelegate,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource{
    //MARK: - Properties JMODE START
    var HOLLYDAYSSECTIONSFINAL:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
    let pinchRecognizer = UIPinchGestureRecognizer()
    var pinchInProgress = false
    var pointOneLast:CGPoint = CGPoint()
    var pointOne:CGPoint = CGPoint()
    var pointTwo:CGPoint = CGPoint()
    var isexpanded:Bool = false
    var ProviderServicesArray:Array<objProviderServices> = Array<objProviderServices>()
    var bLimitSeries:Bool = false
    var iMaxServiceForCustomer:Int = 0
    var iCustomerViewLimit:Int = 0
    var monthchanged:Int = 0
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var isfromSPECIALiCustomerUserId:Int = 0
    var isfromSPECIALSUPPLIER:Bool = false
    var bIsNext:Bool = false
    var ISNONEED:Bool = false
    var iMonth:Int = 0
    var iYear:Int = 0
    var iDay:Int = 0
    var selectedWorkerID:Int = 0
    var generic:Generic = Generic()
    //end one
    @IBOutlet weak var FULLDAYTABLEVIEW: UITableView!
    var ALLSECTIONSFINAL:[(Int,Array<allKindEventsForListDesign>)] = []
    var PERFECTSENSE:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>() //this is our entire array of calendar events with hours full , bhtere events and also free hours
    var dicArrayEventsToShow:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var dicBthereEvent:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var sortDicBTHEREevent:[(String,Array<allKindEventsForListDesign>)] = []
    var sortDicBTHEREeventFiltered:[(String,Array<allKindEventsForListDesign>)] = []
    var sortDicEvents:[(String,Array<allKindEventsForListDesign>)] = []
    var todayfinalunu: Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
    var yearEvent =  0
    var monthEvent = 0
    var dayEvent = 0
    var myCustomersArray : NSMutableArray = []
    let dateFormatter = DateFormatter()
    var iPeriodInWeeksForMaxServices:Int = 0
    @IBOutlet var arrowleft: UIImageView!
    @IBOutlet var arrowright: UIImageView!
    @IBOutlet var btnBACK: UIButton!
    @IBAction func btnBACK(_ sender: AnyObject){
            Global.sharedInstance.isProvider = false
            Global.sharedInstance.whichReveal = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            let vc = storyboard.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
            let viewCon = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as!  entranceCustomerViewController
            if Global.sharedInstance.currentUser.iUserId == 0 {
                frontviewcontroller?.pushViewController(vc, animated: false)
            } else {
                frontviewcontroller?.pushViewController(viewCon, animated: false)
            }
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
    }
    //end JMODE
    var fIsBig = false
    var firstViewInFreeHour:Int = -1
    var selectedCellIndexPath: IndexPath?
    var currentIndexPath:IndexPath?
    var hightCell:CGFloat = 0
    var hightViewBlue:CGFloat = 0
    var hightViewClear:CGFloat = 0
    var minute:Int = 0
    var minute1:Int = 0
    let language = Bundle.main.preferredLocalizations.first! as NSString
    var arrHoursInt:Array<Int> = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    var arrHours:Array<String> = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00",
                                  "09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]
    var arrEventsCurrentDay:Array<EKEvent> = []
    var arrBThereEventsCurrentDay:Array<OrderDetailsObj> = []
    
    var flag = false
    var hasEvent = false
    var currentDate:Date = Date()
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    
    @IBOutlet weak var btnSuny: eyeSynCheckBox!
    
    @IBOutlet weak var imgCircleToday: UIImageView!
    
    @IBOutlet weak var viewSync: UIView!
    
    
    @IBAction func btnSync(_ sender: eyeSynCheckBox) {
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            if (sender.isCecked == false) {
                Global.sharedInstance.getEventsFromMyCalendar()
                Global.sharedInstance.isSyncWithGoogleCalendarAppointment = true
                initEvents()
            } else {
                Global.sharedInstance.isSyncWithGoogleCalendarAppointment = false
                initEvents()
            }
        }
    }
    
    
    //MARK: - Outlet
    //@IBOutlet weak var colDay: UICollectionView!
    @IBOutlet weak var lblDayOfMonth: UILabel!
    @IBOutlet weak var lblDayOfWeek: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBefore: UIButton!
    @IBAction func btnBefore(_ sender: AnyObject){
        print("go back \(currentDate)")
        Global.sharedInstance.freeHoursForCurrentDay = []
        hasEvent = false
        currentDate =  Calendar.sharedInstance.reduceDay(currentDate)
        Global.sharedInstance.currDateSelected = currentDate
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        if iFilterByMonth > monthToday {
            iFilterByMonth = monthToday
            if iFilterByYear > yearToday {
                iFilterByYear = yearToday
            }
        } else {
            iFilterByMonth = monthToday
            iFilterByYear = yearToday
        }
        
        arrBThereEventsCurrentDay = []
        ALLSECTIONSFINAL = []
        for inthour in arrHoursInt {
            let onetoadd = (inthour,Array<allKindEventsForListDesign>())
            ALLSECTIONSFINAL.append(onetoadd)
        }
        self.FULLDAYTABLEVIEW.reloadData()
        let hourx = componentsCurrent.hour
        if hourx != nil {
            if arrHoursInt.contains(hourx!) {
                let indexsection = arrHoursInt.index(of: hourx!)
                let numberOfRows = self.FULLDAYTABLEVIEW.numberOfRows(inSection: indexsection!)
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: indexsection!)
                    self.FULLDAYTABLEVIEW.scrollToRow(at: indexPath,
                                                      at: UITableView.ScrollPosition.top, animated: true)
                }
            }
        }
        self.GetCustomerOrders()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date1String = dateFormatter.string(from: currentDate)
        let date2String = dateFormatter.string(from: Date())
        if date1String == date2String {
            imgCircleToday.isHidden = false
        }
        else
        {
            imgCircleToday.isHidden = true
        }
        Global.sharedInstance.dateDayClick = currentDate
        Global.sharedInstance.currDateSelected = currentDate
        setDateClick(currentDate)
        setDate()
    }
    @IBAction func btnNext(_ sender: AnyObject){
        
        Global.sharedInstance.freeHoursForCurrentDay = []
        hasEvent = false
        currentDate =  Calendar.sharedInstance.addDay(currentDate)
        let componentsCurrent2222 = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        let monthtoask1 = componentsCurrent2222.month
        let yeartoask1 = componentsCurrent2222.year
        
        iMonth = monthtoask1!
        iYear = yeartoask1!
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd"
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        Global.sharedInstance.currDateSelected = currentDate
        if iFilterByMonth < monthToday {
            iFilterByMonth = monthToday
            
            if iFilterByYear < yearToday {
                iFilterByYear = yearToday
            }
        } else {
            iFilterByMonth = monthToday
            iFilterByYear = yearToday
        }
        arrBThereEventsCurrentDay = []
        ALLSECTIONSFINAL = []
        for inthour in arrHoursInt {
            let onetoadd = (inthour,Array<allKindEventsForListDesign>())
            ALLSECTIONSFINAL.append(onetoadd)
        }
        self.FULLDAYTABLEVIEW.reloadData()
        let hourx = componentsCurrent.hour
        if hourx != nil {
            if arrHoursInt.contains(hourx!) {
                let indexsection = arrHoursInt.index(of: hourx!)
                let numberOfRows = self.FULLDAYTABLEVIEW.numberOfRows(inSection: indexsection!)
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: indexsection!)
                    self.FULLDAYTABLEVIEW.scrollToRow(at: indexPath,
                                                      at: UITableView.ScrollPosition.top, animated: true)
                }
            }
        }
        self.GetCustomerOrders()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date1String = dateFormatter.string(from: currentDate)
        let date2String = dateFormatter.string(from: Date())
        if date1String == date2String {
            imgCircleToday.isHidden = false
        }
        else
        {
            imgCircleToday.isHidden = true
        }
        Global.sharedInstance.dateDayClick = currentDate
        Global.sharedInstance.currDateSelected = currentDate
        setDateClick(currentDate)
        setDate()
     
    }
    
    
    func hidetoast(){
        view.hideToastActivity()
    }
    //JMODE table -> REPLACES COLLECTIONVIEW
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
        return 32
        } else {
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 24 + 1 //hollydays section
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let cell:LineHoursTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LineHoursTableViewCell")as!LineHoursTableViewCell
        if section != 0 {

        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        if let _:String = arrHours[section - 1] {
            let oraafisata:String = arrHours[section - 1]
            cell.setDisplayData(oraafisata)
        }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var ARRAYNUMBER:Array<AnyObject> = Array<AnyObject>()
        var expint:Int = 0
        if section == 0 {
            //holydays
            expint = HOLLYDAYSSECTIONSFINAL.count
            return expint
        } else {
            /* old bad code
        for i in 0..<arrHoursInt.count {
            if section == arrHoursInt[i] - 1 {
                for item in ALLSECTIONSFINAL{
                    if item.0 == section - 1 && item.1.count > 0 {
                        let myeventArray:Array<allKindEventsForListDesign> = item.1
                        for myevent in myeventArray {
                            ARRAYNUMBER.append(myevent)
                        }
                    }
                }
            }
        }
 */
            for item in ALLSECTIONSFINAL{
                if item.0 == section - 1 && item.1.count > 0 {
                    let myeventArray:Array<allKindEventsForListDesign> = item.1
                    for myevent in myeventArray {
                        ARRAYNUMBER.append(myevent)
                    }
                }
            }
 return ARRAYNUMBER.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

          if indexPath.section != 0 {
 let cell: ClientDayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ClientDayTableViewCell") as! ClientDayTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.delegateRegister = Global.sharedInstance.calendarAppointment
        cell.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
        var WHATEVENTISNOW:allKindEventsForListDesign = allKindEventsForListDesign()
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        for item in ALLSECTIONSFINAL {
            if item.0 == indexPath.section - 1 && item.1.count > 0 {
                WHATEVENTISNOW =  ALLSECTIONSFINAL[indexPath.section - 1].1[indexPath.row]
                cell.setEventData(WHATEVENTISNOW)
            }
        }
        return cell
          } else {
            //holydays and other
            let cell:HollydaysTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HollydaysTableViewCell")as!HollydaysTableViewCell

            var event = allKindEventsForListDesign()
            event = HOLLYDAYSSECTIONSFINAL[indexPath.row]
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setDisplayData(event.title)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            //holydays
            return 25
        } else {
        if isexpanded == false {
            return 35
        }
        return 70
        }
    }

        
        func bestmode() {
        pinchRecognizer.addTarget(self, action: #selector(self.handlePinch(_:)))
        FULLDAYTABLEVIEW.addGestureRecognizer(pinchRecognizer)
        FULLDAYTABLEVIEW.delegate = self
     //       FULLDAYTABLEVIEW.separatorStyle = .none
        monthchanged = 0
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
            let mys = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")
            print("FINDisfromSPECIALiCustomerUserId \(mys)")
        print("useridglobal \(isfromSPECIALiCustomerUserId)")
        print("e din suplier special \(isfromSPECIALSUPPLIER)")
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let amonth = components.month
        let ayear = components.year
        let aday = components.day
     //  print("day ENGAGE  \(amonth) \(ayear) \(aday)")
        iMonth = amonth!
        iYear = ayear!
        iDay = aday!
        iFilterByMonth = iMonth
        iFilterByYear = iYear
        
        FULLDAYTABLEVIEW.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
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
        let leftarrowback = UIImage(named: "sageata2.png")
        
        self.btnBACK.setImage(leftarrowback, for: UIControl.State())
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnBACK.transform = scalingTransform
        }
        btnBACK.imageView!.contentMode = .scaleAspectFit
        
        
        checkDevice()
        Global.sharedInstance.datDesigncalendar = self
        fIsBig = false
        
        if Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true
        {
            btnSuny.isCecked = true
        }
        else
        {
            btnSuny.isCecked = false
        }
        
        hightCell = view.frame.size.width / 8
        
        view.sendSubviewToBack(lblDay)
        
        hasEvent = false
        arrEventsCurrentDay = []
        setDate()
        
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
       

        self.FULLDAYTABLEVIEW.separatorStyle = .none
        self.btnequal(btnNext)
    }
  
    
    //MARK: - Initial
    
    func initDate(_ date:Date)
    {
        currentDate = date
    }
    
    override func viewDidLoad()
    {
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
         Global.sharedInstance.datDesigncalendar = self
        pinchRecognizer.addTarget(self, action: #selector(self.handlePinch(_:)))
        FULLDAYTABLEVIEW.addGestureRecognizer(pinchRecognizer)
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            self.viewSync.isHidden = false
            self.btnSuny.isHidden = false
        } else {
            self.viewSync.isHidden = true
            self.btnSuny.isHidden = true
        }
        
        monthchanged = 0
        print("useridglobal \(isfromSPECIALiCustomerUserId)")
        print("e din suplier special \(isfromSPECIALSUPPLIER)")
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let amonth = components.month
        let ayear = components.year
        let aday = components.day
    //    print("day ENGAGE  \(amonth) \(ayear) \(aday)")
        iMonth = amonth!
        iYear = ayear!
        iDay = aday!
        iFilterByMonth = iMonth
        iFilterByYear = iYear
        
        FULLDAYTABLEVIEW.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
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
        
        let leftarrowback = UIImage(named: "sageata2.png")
        
        self.btnBACK.setImage(leftarrowback, for: UIControl.State())
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnBACK.transform = scalingTransform
        }
        btnBACK.imageView!.contentMode = .scaleAspectFit
        
        checkDevice()
        fIsBig = false
        
        if Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true
        {
            btnSuny.isCecked = true
        }
        else
        {
            btnSuny.isCecked = false
        }
        
        hightCell = view.frame.size.width / 8
        
        view.sendSubviewToBack(lblDay)
        
        hasEvent = false
        arrEventsCurrentDay = []
        setDate()
        
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            self.GoogleAnalyticsSendEvent(x:8)
        }

        fIsBig = false
        Global.sharedInstance.freeHoursForCurrentDay = []
        if Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true
        {
            btnSuny.isCecked = true
        }
        else
        {
            btnSuny.isCecked = false
        }
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date1String = dateFormatter.string(from: currentDate)
        let date2String = dateFormatter.string(from: Date())
        if date1String == date2String {
            imgCircleToday.isHidden = false
        }
        else
        {
            imgCircleToday.isHidden = true
        }
        fIsBig = false
        Global.sharedInstance.getEventsFromMyCalendar()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDateClick(_ date:Date){// take a date save in global when day in month clicked and show the date in day design
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from:date)
        //Global.sharedInstance.dateDayClick)
        
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        
        
        //the day of week from date - (int)
        let day:Int = Calendar.sharedInstance.getDayOfWeek(date)! - 1
        
        //the day of week from date - (letter - string)
        lblDayOfWeek.text = DateFormatter().veryShortWeekdaySymbols[day]
        Global.sharedInstance.dayFreeEvent = DateFormatter().weekdaySymbols[day]
        //lblDayOfWeek.text!
        
        //the day of month from date - (int)
        lblDayOfMonth.text = dayToday.description
        
        //get the month and day of week names - short
        
        if monthToday == 0 {
            monthToday = 1
        }
        
        var monthName = DateFormatter().shortStandaloneMonthSymbols[monthToday - 1]
        let dateFormatter = DateFormatter()
        let dateFormatterYEAR = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatterYEAR.dateFormat = "yyyy"
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatter.locale = Locale(identifier: "he_IL")
        } else {
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        monthName = dateFormatter.shortStandaloneMonthSymbols[monthToday - 1]
        let dayName = dateFormatter.weekdaySymbols[day]
        //cut the word "יום" from the string
        let myLongDay: String = dayName
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            var myShortDay = myLongDay.components(separatedBy: " ")
            lblDay.text = myShortDay[1]
        } else {
            lblDay.text = myLongDay
        }
        lblDate.text = "\(dayToday) \(monthName) \(yearToday)"
        initEvents()
        
    }
    func setDate()
    {
        //the day of week from date - (int)
        let day:Int = Calendar.sharedInstance.getDayOfWeek(currentDate)! - 1
        
        //the day of week from date - (letter - string)
        lblDayOfWeek.text = DateFormatter().veryShortWeekdaySymbols[day]
        
        //the day of month from date - (int)
        lblDayOfMonth.text = dayToday.description
        
        //get the month and day of week names - short
        
        if monthToday == 0 {
            monthToday = 1
        }
        var monthName = DateFormatter().shortStandaloneMonthSymbols[monthToday - 1]
        
        let dateFormatter = DateFormatter()
        let dateFormatterYEAR = DateFormatter()
        
        dateFormatter.dateFormat = "MMM"
        dateFormatterYEAR.dateFormat = "yyyy"
        
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatter.locale = Locale(identifier: "he_IL")
        } else {
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        
        
        
        monthName = dateFormatter.shortStandaloneMonthSymbols[monthToday - 1]
        
        let dayName = dateFormatter.weekdaySymbols[day]
        let myLongDay: String = dayName
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            var myShortDay = myLongDay.components(separatedBy: " ")
            lblDay.text = myShortDay[1]
        } else {
            lblDay.text = myLongDay
        }
        lblDate.text = "\(dayToday) \(monthName) \(yearToday)"
    }
    
    
    var isShowFreeDay:Int = 0//flag to know if there isnt any free hour in that hour
    
    
    override func viewWillLayoutSubviews() {
        if Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true{
            btnSuny.isCecked = true
        }else{
            btnSuny.isCecked = false
        }
        
    }
    
    
    
    //func set sync design if eye is set on
    @objc func showSync()
    {
        if btnSuny.isCecked == false
        {
            Global.sharedInstance.getEventsFromMyCalendar()
            btnSuny.isCecked = true
            Global.sharedInstance.isSyncWithGoogleCalendarAppointment = true
            //            colDay.reloadData()
            //            FULLDAYTABLEVIEW.reloadData()
            initEvents()
        }
        else
        {
            btnSuny.isCecked = false
            Global.sharedInstance.isSyncWithGoogleCalendarAppointment = false
            //            colDay.reloadData()
            //             FULLDAYTABLEVIEW.reloadData()
            initEvents()
        }
        
    }
    
    
    func checkDevice()
    {
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            
            
            lblDay.font = UIFont(name: lblDay.font.fontName, size: 20)
            lblDate.font = UIFont(name: lblDate.font.fontName, size: 13)
            
        }
        
    }
    //MARK: borders
    //הוספת מסגרת לאירוע
    
    
    //JMODE UNIFY EVENTS
    func initEvents()
    {
        ALLSECTIONSFINAL = []
        HOLLYDAYSSECTIONSFINAL = []
        for inthour in arrHoursInt {
            let onetoadd = (inthour,Array<allKindEventsForListDesign>())
            ALLSECTIONSFINAL.append(onetoadd)
        }
        Global.sharedInstance.getEventsFromMyCalendar()
        arrEventsCurrentDay = []
        
        for item in Global.sharedInstance.eventList
        {
            let event = item as! EKEvent
            
            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
            
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

        
        arrBThereEventsCurrentDay = []
        print("Global.sharedInstance.ordersOfClientsArray \(Global.sharedInstance.ordersOfClientsArray.count)")
        
        for item in Global.sharedInstance.ordersOfClientsArray
        {
           //\\ print("item \(item.getDic())")
            let btEvent = item
            
            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
            
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: btEvent.dtDateOrder as Date)
            
            yearToday =  componentsCurrent.year!
            monthToday = componentsCurrent.month!
            dayToday = componentsCurrent.day!
            
            let yearEvent =  componentsEvent.year
            let monthEvent = componentsEvent.month
            let dayEvent = componentsEvent.day
            
            if yearEvent == yearToday && monthEvent == monthToday && dayEvent == dayToday
            {
                if btEvent.nvComment == "BlockedBySupplier" {
                    ///no add
                    btEvent.title = "BlockedBySupplier"
                    
                }
                
                arrBThereEventsCurrentDay.append(btEvent)
                hasEvent = true
            }
        }
        
        dicArrayEventsToShow.removeAll()
        dicBthereEvent.removeAll()
        dicArrayEventsToShow = Dictionary<String,Array<allKindEventsForListDesign>>()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        

        if  Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true {
            for event in arrEventsCurrentDay
            {
                let dateEvent = event.startDate
                let calendar:Foundation.Calendar = Foundation.Calendar.current
                let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateEvent!)
                yearEvent =  componentsEvent.year!
                monthEvent = componentsEvent.month!
                dayEvent = componentsEvent.day!
                
                
                
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
                    minuteS_Show = "0" +   minuteS_Show
                }
                if minuteE! < 10
                {
                    minuteE_Show = "0" + minuteE_Show
                }
                
                
                
                let ARRAYiProviderUserId:Array<Int> = []
                let objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
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
                    _ARRAYiProviderUserId : ARRAYiProviderUserId,
                    _objProviderServiceDetails:objProviderServiceDetails,
                    _nvLogo: "",
                    _chServiceColor: "",
                    _viewsforweek: [],
                    _iCoordinatedServiceStatusType:  0,
                    _nvPhone: "",
                    _iSupplierId: 0
                )
                print("eventPhone \(eventPhone.getDic())")

                if (eventPhone.fromHour == "00:00" && eventPhone.toHour == "23:59" && eventPhone.iProviderUserId == 0 &&  eventPhone.iUserId == 0 && eventPhone.iDayInWeek == -1 && eventPhone.nvComment != "BlockedBySupplier") {
                    print("allday ")
                        if !HOLLYDAYSSECTIONSFINAL.contains(eventPhone) {
                            HOLLYDAYSSECTIONSFINAL.append(eventPhone)
                            hasEvent = true
                        }
                    }
             else {
                if dicArrayEventsToShow[dateFormatter.string(from: event.startDate)] != nil
                {
                    print("xyearEvent \(yearEvent) xyearToday \(yearToday) xmonthEvent\(monthEvent) xmonthToday\(monthToday) xdayevent \(dayEvent) xdaytoday\(dayToday)")
                    
                    dicArrayEventsToShow[dateFormatter.string(from: event.startDate)]?.append(eventPhone)
                    hasEvent = true
                    
                }
                else
                {
                    
                    dicArrayEventsToShow[dateFormatter.string(from: event.startDate)] = Array<allKindEventsForListDesign>()
                    dicArrayEventsToShow[dateFormatter.string(from: event.startDate)]?.append(eventPhone)
                }
            }
        }
        }
        
        // for eventBthere in Global.sharedInstance.ordersOfClientsArray
        for item in arrBThereEventsCurrentDay
            
        {
            print("ce a gasit \(item.getDic())")
            var dateEvent:Date = Date()
            var hourStart = Date()
            var hourEnd = Date()
            
            
            if let _:NSDictionary = item.getDic() as NSDictionary  {
                let eventBthere:NSDictionary = item.getDic() as NSDictionary
                print("test event \(eventBthere.description)")
                
                // let dateEvent = eventBthere.dtDateOrder
                if let ORDERDATE:String =  eventBthere.object(forKey: "dtDateOrder") as? String
                {
                    dateEvent = Global.sharedInstance.getStringFromDateString(ORDERDATE)
                    print("STRdtDateOrder\(dateEvent)")
                }
                let calendar:Foundation.Calendar = Foundation.Calendar.current
                let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateEvent)
                
                yearEvent =  componentsEvent.year!
                monthEvent = componentsEvent.month!
                dayEvent = componentsEvent.day!
                
                
                
                if let asistart:String = eventBthere.object(forKey: "nvFromHour") as? String {
                    hourStart = Global.sharedInstance.getStringFromDateString(asistart)
                }
                if let asiend:String = eventBthere.object(forKey: "nvToHour") as? String {
                    hourEnd = Global.sharedInstance.getStringFromDateString(asiend)
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
                var chfinalcolor:String = ""
                var chServiceColor:String = ""
                var serviceName = ""
                if let myarrservicesx:Array<ProviderServiceDetailsObj> =  eventBthere.object(forKey: "objProviderServiceDetails") as? Array<ProviderServiceDetailsObj> {
                    for item in myarrservicesx {
                        if let servicedictch:NSDictionary = item.getDic() as? NSDictionary {
                            if let _:String = servicedictch.object(forKey: "chServiceColor") as? String{
                                chServiceColor = servicedictch.object(forKey: "chServiceColor") as! String
                            }
                            
                            print("chServiceColor \(chServiceColor)")
                            
                            if chServiceColor != ""  {
                                chfinalcolor = chServiceColor
                                
                            } else {
                                chfinalcolor = "#FF6666"
                            }
                            break
                        }
                    }
                }
                if let myarrservices:Array<ProviderServiceDetailsObj> =  eventBthere.object(forKey: "objProviderServiceDetails") as? Array<ProviderServiceDetailsObj> {
                    for item in myarrservices {
                        if let servicedict:NSDictionary = item.getDic() as? NSDictionary {
                            
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
                var anyhow = 0
                if let xor:Int =  eventBthere.object(forKey: "iUserId") as? Int {
                    anyhow = xor
                }
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
                var nvPhone:String = ""
                if let _:String = eventBthere.object(forKey: "nvPhone") as? String{
                    nvPhone = eventBthere.object(forKey: "nvPhone") as! String
                }

                 var iSupplierId:Int = 0
                if let _:Int = eventBthere.object(forKey: "iSupplierId") as? Int{
                    iSupplierId = eventBthere.object(forKey: "iSupplierId") as! Int
                }
                let ARRAYiProviderUserId:Array<Int> = []
                let bewarr = item.objProviderServiceDetails.unique
                let eventBtheree:allKindEventsForListDesign = allKindEventsForListDesign(
                    _dateEvent: dateEvent,
                    _title: "\(serviceName)",
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
                    _ARRAYiProviderUserId : ARRAYiProviderUserId,
                    _objProviderServiceDetails:bewarr,
                    _nvLogo: item.nvLogo,
                    _chServiceColor: chfinalcolor,
                    _viewsforweek: [],
                    _iCoordinatedServiceStatusType:  0,
                    _nvPhone: nvPhone,
                    _iSupplierId: iSupplierId
                )
                print("eventBtheree \(eventBtheree.getDic())")
       
                if dicArrayEventsToShow[dateFormatter.string(from: dateEvent)] != nil
                {
                    print("xyearEvent \(yearEvent) xyearToday \(yearToday) xmonthEvent\(monthEvent) xmonthToday\(monthToday) xdayevent \(dayEvent) xdaytoday\(dayToday)")
                    
                    dicArrayEventsToShow[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                    hasEvent = true
                    
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
        
        
        var i = 0
        
        for _ in sortDicEvents
        {
            
            sortDicEvents[i].1.sort(by: { $0.fromHour .compare($1.fromHour) == ComparisonResult.orderedAscending })
            i += 1
        }
        
        todayfinalunu = []
        print("sortDicEvents \(sortDicEvents.description)")
        if sortDicEvents.count > 0 {
            
            todayfinalunu = sortDicEvents[0].1
            if todayfinalunu.count > 0 {
                for i in 0..<todayfinalunu.count {
                    let item = todayfinalunu[i]
                    //  if item.iProviderUserId > 0 {
                    print("happy cloud \(item.fromHour) -> \(item.iDayInWeek)")
                }
            }
        }
        ///start full array
        if todayfinalunu.count > 0 {
            for itemx in todayfinalunu {
                if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
                    if a1 == "0" {
                        //now get the real hour
                        if let a2:Character =  itemx.fromHour[itemx.fromHour.characters.index(itemx.fromHour.startIndex, offsetBy: 1)]{
                            //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
                            if a2 == "0" {
                                print("ora1 0 add to 0")
                                for inthour in arrHoursInt {
                                    if inthour == 0 {
                                        ALLSECTIONSFINAL[0].1.append(itemx)
                                    }
                                }
                            }
                            else {
                                print("ora1 \(a2) add to \(a2)") //section
                                let str = String(a2)
                                let IntHOUR:Int = Int(str)!
                                for inthour in arrHoursInt {
                                    if inthour == IntHOUR {
                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
                                    }
                                }
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
                                print("ora1 \(numberFromString) add to \(numberFromString)")
                                for inthour in arrHoursInt {
                                    if inthour == numberFromString {
                                        ALLSECTIONSFINAL[inthour].1.append(itemx)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        print("ALLSECTIONSFINAL \(ALLSECTIONSFINAL.description)")
        ////end full array
        
        
        

        self.FULLDAYTABLEVIEW.reloadData()
        //
        
        //\\print ("scrolling to bottom row \(numberOfRows)")
        
        let componentsCurrent = (calendar as NSCalendar).components([.hour], from: Date())
        let hourx = componentsCurrent.hour
        if hourx != nil {
            if arrHoursInt.contains(hourx!) {
                let indexsection = arrHoursInt.index(of: hourx!)
                let numberOfRows = self.FULLDAYTABLEVIEW.numberOfRows(inSection: indexsection!)
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: indexsection!)
                    self.FULLDAYTABLEVIEW.scrollToRow(at: indexPath,
                                                      at: UITableView.ScrollPosition.top, animated: true)
                }
            }
        }
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
    //FIX GOING BACK AND FORTH WHEN CHANGING MONTHS ALSO FROM ARROWS
    func GetCustomerOrders()  {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
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
            api.sharedInstance.GetCustomerOrdersNoLogo(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if self.isfromSPECIALSUPPLIER == false {
                        let ps:OrderDetailsObj = OrderDetailsObj()
                        if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                            Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            print(Global.sharedInstance.ordersOfClientsArray)
                        }
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
                        if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                            ARRAYoRDERSFORisfromSPECIALiCustomerUserId = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            print("day ARRAYoRDERSFORisfromSPECIALiCustomerUserId.count \(ARRAYoRDERSFORisfromSPECIALiCustomerUserId.count)")
                        }
                        Global.sharedInstance.ordersOfClientsArray =  Array<OrderDetailsObj>()
                        for item in ARRAYoRDERSFORisfromSPECIALiCustomerUserId {
                            
                            if item.iSupplierId == providerID {
                         //\\       print("item to test \(item.getDic())")
                                if !Global.sharedInstance.ordersOfClientsArray.contains(item) {
                                    Global.sharedInstance.ordersOfClientsArray.append(item)
                                }
                            }
                        }
                        print("day Global.sharedInstance.ordersOfClientsArray.count \(Global.sharedInstance.ordersOfClientsArray.count)")
                    }
                }
                self.updatefornextbtn(self.bIsNext,ISNONEED:self.ISNONEED )
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    func updatefornextbtn(_ bIsNext:Bool,ISNONEED:Bool){
        print("wwwwww Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")
        
        let COMPOSEDONEDATE:String = String(iYear) + "-" + String(iMonth) + "-" + String(iDay) + " 03:00:00  +0000"
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dates = dateFormatterx.date(from: COMPOSEDONEDATE)
        Calendar.sharedInstance.carrentDate  =  dates!
        print("Calendar.sharedInstance.carrentDate  perfect sense\(Calendar.sharedInstance.carrentDate)")
        //\\let Mycalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierHebrew)!
        print("whheck\( Calendar.sharedInstance.carrentDate)")
        setDate()
        setDateClick(currentDate)
        
        
        
        
    }
    func PREETYJSON_J(_ params:Dictionary<String,AnyObject>, pathofweb: String) {
        print("********************************* \(pathofweb) my data ********************\n")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print("\n********************************* END of \(pathofweb)  ********************\n")
    }
    
    
    
    
    @IBAction func btnequal(_ sender: AnyObject){
        
        Global.sharedInstance.freeHoursForCurrentDay = []
        hasEvent = false
        let componentsCurrent2222 = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        let monthtoask1 = componentsCurrent2222.month
        let yeartoask1 = componentsCurrent2222.year
        let daytoask1 = componentsCurrent2222.day
        iMonth = monthtoask1!
        iYear = yeartoask1!
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        
        let components = (calendar as NSCalendar).components([.year, .month], from: currentDate)
        
        let startOfMonth = calendar.date(from: components)!
        let endOfMonth = (calendar as NSCalendar).date(byAdding: comps2, to: startOfMonth, options: [])!
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd"
        Global.sharedInstance.currDateSelected = currentDate
            arrBThereEventsCurrentDay = []
            ALLSECTIONSFINAL = []
            for inthour in arrHoursInt {
                let onetoadd = (inthour,Array<allKindEventsForListDesign>())
                ALLSECTIONSFINAL.append(onetoadd)
            }
            self.FULLDAYTABLEVIEW.reloadData()
            let componentsCurrent = (calendar as NSCalendar).components([.hour], from: Date())
            let hourx = componentsCurrent.hour
            if hourx != nil {
                if arrHoursInt.contains(hourx!) {
                    let indexsection = arrHoursInt.index(of: hourx!)
                    let numberOfRows = self.FULLDAYTABLEVIEW.numberOfRows(inSection: indexsection!)
                    if numberOfRows > 0 {
                        let indexPath = IndexPath(row: 0, section: indexsection!)
                        self.FULLDAYTABLEVIEW.scrollToRow(at: indexPath,
                                                          at: UITableView.ScrollPosition.top, animated: true)
                    }
                }
            }
            
            self.GetCustomerOrders()
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date1String = dateFormatter.string(from: currentDate)
        let date2String = dateFormatter.string(from: Date())
        if date1String == date2String {
            imgCircleToday.isHidden = false
        }
        else
        {
            imgCircleToday.isHidden = true
        }
        
        Global.sharedInstance.dateDayClick = currentDate
        Global.sharedInstance.currDateSelected = currentDate
        let componentsCurrentz = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        yearToday =  componentsCurrentz.year!
        monthToday = componentsCurrentz.month!
        dayToday = componentsCurrentz.day!
        setDate()
        setDateClick(currentDate)
    }
    @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            
            pointOne = recognizer.location(ofTouch: 0, in: FULLDAYTABLEVIEW)
            pointTwo = recognizer.location(ofTouch: 1, in: FULLDAYTABLEVIEW)
            isexpanded = true
            FULLDAYTABLEVIEW.reloadData()
     
        }
        if recognizer.state == .changed
            && pinchInProgress
            && recognizer.numberOfTouches == 2 {
            print("changed")
        }
        if recognizer.state == .ended {
            print("ended")
        }
    }
    
   
    
    
}

