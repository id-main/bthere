//
//  MonthDesignedViewController.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/14/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

//לקוח תצוגת חודש ביומן
class MonthDesignedViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
    //,reloadTableFreeDaysDelegate
{
    //MARK: - @IBOutlet
    var generic = Generic()
    @IBOutlet var arrowleft: UIImageView!
    @IBOutlet var arrowright: UIImageView!
    @IBOutlet weak var tblWorkers: UITableView!
    @IBOutlet weak var lblDayOfWeek1: UILabel!
    @IBOutlet weak var lblDayOfWeek2: UILabel!
    @IBOutlet weak var lblDayOfWeek3: UILabel!
    @IBOutlet weak var lblDayOfWeek4: UILabel!
    @IBOutlet weak var lblDayOfWeek5: UILabel!
    @IBOutlet weak var lblDayOfWeek6: UILabel!
    @IBOutlet weak var lblDayOfWeek7: UILabel!
    @IBOutlet var collDays: UICollectionView!
    @IBOutlet var lblCurrentDate: UILabel!
    @IBOutlet weak var btnBefore: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewSync: UIView!
    @IBOutlet weak var btnSync: eyeSynCheckBox!
    var iMonth:Int = 0
    var iYear:Int = 0
    var iDay:Int = 0
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
     var MyMonthsNames:NSArray = [ "January".localized(LanguageMain.sharedInstance.USERLANGUAGE), "February".localized(LanguageMain.sharedInstance.USERLANGUAGE), "March".localized(LanguageMain.sharedInstance.USERLANGUAGE), "April".localized(LanguageMain.sharedInstance.USERLANGUAGE), "May".localized(LanguageMain.sharedInstance.USERLANGUAGE), "June".localized(LanguageMain.sharedInstance.USERLANGUAGE), "July".localized(LanguageMain.sharedInstance.USERLANGUAGE), "August".localized(LanguageMain.sharedInstance.USERLANGUAGE), "September".localized(LanguageMain.sharedInstance.USERLANGUAGE), "October".localized(LanguageMain.sharedInstance.USERLANGUAGE), "November".localized(LanguageMain.sharedInstance.USERLANGUAGE),  "December".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    //MARK: - @IBAction
    @IBAction func btnSync(_ sender: eyeSynCheckBox) {
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            if (sender.isCecked == false) {
                Global.sharedInstance.getEventsFromMyCalendar()
                Global.sharedInstance.isSyncWithGoogelCalendar = true
                i = 1
                collDays.reloadData()
            } else {
                Global.sharedInstance.isSyncWithGoogelCalendar = false
                i = 1
                collDays.reloadData()
            }
        }
    }
    
    
    //func set prev date on click prev btn
    @IBAction func btnBefore(_ sender: UIButton)
    {
        prevClick()
    }
    
    @IBAction func btnNextAction(_ sender: AnyObject) {
        nextClick()
    }
    
    @IBAction func btnPrevAction(_ sender: AnyObject) {
        prevClick()
    }
    //func set next date on click next btn
    @IBAction func btnNext(_ sender: UIButton) {
        nextClick()
    }
    
    
    //MARK: - varibals
    fileprivate let kKeychainItemName = "Google Calendar API"
    fileprivate let kClientID = "284147586677-69842kmfbfll1dmec57c9gklqnpa5n2u.apps.googleusercontent.com"
    
    var monthName:String = ""
    
    let output = UITextView()
    
    var dateFormatter = DateFormatter()
    
    var today: Date = Date()
    
    let language = Bundle.main.preferredLocalizations.first! as NSString
    var arrEventsCurrentDay:Array<EKEvent> = []
    
    var days:Array<Int> = []
    var numDaysInMonth:Int = 0
    var dateFirst:Date = Date()
    var dayInWeek:Int = 0
    var i = 1
    var dayToday:Int = 0
    var monthToday:Int = 0
    var monthTodayNotChanged = 0
    var yearToday:Int = 0
    var hasEvent = false
    var moneForBackColor = 1
    let calendar = Foundation.Calendar.current
    var titles : [String] = []
    var startDates : [Date] = []
    var endDates : [Date] = []
    
    let eventStore = EKEventStore()
    var shouldShowDaysOut = true
    var animationFinished = true
    var currentDate:Date = Date()
    var bthereEventDateDayInt:Array<Int> = Array<Int>()// ימים שיש בהם אירוע
    
    //MARK: - Initials
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bestmode()
        
        
    }
   
    func nextClick()
    {
        Calendar.sharedInstance.carrentDate = Calendar.sharedInstance.addMonth(Calendar.sharedInstance.carrentDate)
        numDaysInMonth = Calendar.sharedInstance.getNumsDays(Calendar.sharedInstance.carrentDate)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
        dateFirst = Calendar.sharedInstance.getFirstDay(Calendar.sharedInstance.carrentDate)//מחזירה את התאריך הראשון של החודש שנשלח
        dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!
        i = 1
        moneForBackColor = 1
        iDay = 1
        if iMonth == 12 {
            iMonth = 1
            iYear = iYear + 1
            
        } else if iMonth < 12 {
            iMonth = iMonth + 1
        }
        let COMPOSEDONEDATE:String = String(iYear) + "-" + String(iMonth) + "-" + String(iDay) + " 03:00:00"
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dates = dateFormatterx.date(from: COMPOSEDONEDATE)
        iFilterByMonth = iMonth
        iFilterByYear = iYear
       
        
        let Mycalendar: Foundation.Calendar = Foundation.Calendar(identifier: .hebrew)
        //today = Calendar.sharedInstance.carrentDate
        today = (Mycalendar as NSCalendar).date(byAdding: .month, value: 1, to: today, options: [])!
        changeLblDate()
      GetCustomerOrders()
    }
    func finishsetaftergetmonth(){
         self.bthereEventDateDayInt = []
        setEventsArray()
        setEventBthereInMonth()
        i = 1
        collDays.reloadData()
    }
  
    func prevClick()
    {
        //currentDate =
        Calendar.sharedInstance.carrentDate = Calendar.sharedInstance.removeMonth(Calendar.sharedInstance.carrentDate)
        numDaysInMonth = Calendar.sharedInstance.getNumsDays(Calendar.sharedInstance.carrentDate)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
        dateFirst = Calendar.sharedInstance.getFirstDay(Calendar.sharedInstance.carrentDate)//מחזירה את התאריך הראשון של החודש שנשלח
        dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!
        i = 1
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
        let COMPOSEDONEDATE:String = String(iYear) + "-" + String(iMonth) + "-" + String(iDay) + " 03:00:00"
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dates = dateFormatterx.date(from: COMPOSEDONEDATE)
        iFilterByMonth = iMonth
        iFilterByYear = iYear
              let Mycalendar: Foundation.Calendar = Foundation.Calendar(identifier: .hebrew)
        //today = Calendar.sharedInstance.carrentDate
        today = (Mycalendar as NSCalendar).date(byAdding: .month, value: -1, to: today, options: [])!
        
        changeLblDate()
       GetCustomerOrders()
          }
    
    //sort orders by current month
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
//                a = Calendar.sharedInstance.getMonth(orderDetailsObj.dtDateOrder, reduce: 0, add: 0)
//                b = Calendar.sharedInstance.getMonth( Calendar.sharedInstance.carrentDate
//                    , reduce: 0, add: 0)
//                c = Calendar.sharedInstance.getYear(orderDetailsObj.dtDateOrder, reduce: 0, add: 0)
//                d = Calendar.sharedInstance.getYear( Calendar.sharedInstance.carrentDate
//                    , reduce: 0, add: 0)
                //   check if is currentMonth
                if Calendar.sharedInstance.getMonth(orderDetailsObj.dtDateOrder, reduce: 0, add: 0) == Calendar.sharedInstance.getMonth( Calendar.sharedInstance.carrentDate
                    , reduce: 0, add: 0) &&  Calendar.sharedInstance.getYear(orderDetailsObj.dtDateOrder, reduce: 0, add: 0) == Calendar.sharedInstance.getYear( Calendar.sharedInstance.carrentDate
                        , reduce: 0, add: 0)
                {
                    
                    //                    d = Calendar.sharedInstance.getYear( Calendar.sharedInstance.carrentDate
                    //                        , reduce: 0, add: 0)
                    
                    bthereEventDateDayInt.append(Calendar.sharedInstance.getDay(orderDetailsObj.dtDateOrder, reduce: 0, add: 0))
                }
                for a in bthereEventDateDayInt {
                    print(a)
                }
                
            }
        }
        i = 1
        collDays.reloadData()
    }
    
    // When the view appears, ensure that the Google Calendar API service is authorized
    // and perform API calls
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            self.GoogleAnalyticsSendEvent(x:10)
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    // MARK: Optional methods
    
    //    func shouldShowWeekdaysOut() -> Bool {
    //        return shouldShowDaysOut
    //    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    //MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if section == 0{
        //            return 1
        //        }
        if (numDaysInMonth > 30 && dayInWeek == 6
            ) || (numDaysInMonth > 29 && dayInWeek == 7){
            return 42
        }
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //Aligning right to left on UICollectionView
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        let cell:DayMonthCalendarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayMonthCalendarCollectionViewCell",for: indexPath) as! DayMonthCalendarCollectionViewCell
        cell.lblIsBthereEvent.isHidden = true
        //        cell.lblBtEvent.hidden = true
        
        
        //        if Global.sharedInstance.model == 2{//אם זה תחת מודל של יומן תורים מול לקוח
        //        cell.delegate = Global.sharedInstance.calendarAppointment
        //        }
        //        else{
        cell.delegate = Global.sharedInstance.calendarClient//תחת המודל של יומן שלי ללקוח
        
        cell.whichModelOpenMe = 1
        //        }
        cell.imgToday.isHidden = true
        cell.lblDayDesc.alpha = 1.0
        //         cell.viewIsFree.backgroundColor = UIColor.clearColor()
        //     var s =
        // var d:NSDate()
        cell.lblDayDesc.text = ""
        cell.lblDayDesc.textColor = Colors.sharedInstance.color1
        
        if moneForBackColor % 7 == 0{
            if Global.sharedInstance.whichReveal == false{
                cell.lblDayDesc.textColor = Colors.sharedInstance.color3
                
                cell.isShabat = true
                
            }
            else{
                cell.lblDayDesc.textColor = Colors.sharedInstance.color4
            }
        }
        
        moneForBackColor += 1
         print("numDaysInMonth \(numDaysInMonth)")
        if indexPath.row >= (dayInWeek - 1)  && indexPath.row < (numDaysInMonth + dayInWeek - 1 )
        {
            if bthereEventDateDayInt.contains(i)
            {
                cell.lblIsBthereEvent.isHidden = false
                           }
           print(i)
             if i <=  numDaysInMonth {
            
            cell.setDisplayData(i)
            
            
            i += 1
            }
        }
        else
        {
            cell.setNull()
            cell.btnEnterToDay.isEnabled = false
            cell.viewIsFree.backgroundColor =  UIColor.clear
        }
        

        var componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
        componentsCurrent.day = i
        let date:Date = Calendar.sharedInstance.from(componentsCurrent.year! , month: componentsCurrent.month!, day: i)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (numDaysInMonth > 30 && dayInWeek == 6) || (numDaysInMonth > 29 && dayInWeek == 7)
        {
            return CGSize(width: view.frame.size.width / 7.6, height:  view.frame.size.width / 7.6)
        }
        return CGSize(width: view.frame.size.width / 7, height:  view.frame.size.width / 7)
    }
    
    //MARK: - functions
    //bool func that  get date and check if has event in this date
    func ifHasEventInDayFunc( _ dt:Date)-> Bool
    {
        for item in Global.sharedInstance.eventList
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
                //                arrEventsCurrentDay.append(event)
                //                hasEvent = true
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
    
    //sort device event by current Month
    func setEventsArray()
    {
        arrEventsCurrentDay = []
        for  item in Global.sharedInstance.eventList
        {
            let event = item as! EKEvent
            
            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
            
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: event.startDate)
            
            yearToday =  componentsCurrent.year!
            monthToday = componentsCurrent.month!
            dayToday = componentsCurrent.day!
            
            let yearEvent =  componentsEvent.year
            let monthEvent = componentsEvent.month
            //            let dayEvent = componentsEvent.day
            
            if yearEvent == yearToday && monthEvent == monthToday
            {
                arrEventsCurrentDay.append(event)
                hasEvent = true
            }
        }
        
    }
      func  bestmode() {
        
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            self.viewSync.isHidden = false
            self.btnSync.isHidden = false
            
        } else {
            self.viewSync.isHidden = true
            self.btnSync.isHidden = true
        }
        
       
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
        today = Date()
        Calendar.sharedInstance.carrentDate = Date()

        
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        monthTodayNotChanged = componentsCurrent.month!
        
        if Global.sharedInstance.isSyncWithGoogelCalendar == true{//אם הלקוח הנוכחי בחר שהוא רוצה סנכרון עם היומן האישי אז התצוגה נפתחת כשהעין לא מסומנת ז״א יש סנכרון
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
        Global.sharedInstance.desingMonth = self
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
        changeLblDate()
        setEventsArray()
        changeLblDate()
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
     //   setEventBthereInMonth()
        GetCustomerOrders()
        
        
    }
    @objc func showSync()
    {
        if btnSync.isCecked == false
        {
            Global.sharedInstance.getEventsFromMyCalendar()
            btnSync.isCecked = true
            Global.sharedInstance.isSyncWithGoogelCalendar = true// פלאג כללי ליומן לקוח מול ספק שמסמל האם הלקוח בחר סנכרון או לא
            i = 1
            collDays.reloadData()
        }
        else
        {
            btnSync.isCecked = false
            Global.sharedInstance.isSyncWithGoogelCalendar = false
            i = 1
            collDays.reloadData()
            
        }
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
          
            dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
            dic["iFilterByMonth"] = iFilterByMonth as AnyObject
            dic["iFilterByYear"] = iFilterByYear as AnyObject
            api.sharedInstance.GetCustomerOrdersNoLogo(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
               
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if RESPONSEOBJECT["Result"] != nil  || !(RESPONSEOBJECT["Result"] is NSNull)  {
                        if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                      //\\      print("what is getttt \(String(describing: RESPONSEOBJECT["Result"]))")
                            // regular customer
                                let ps:OrderDetailsObj = OrderDetailsObj()
                                Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                print(Global.sharedInstance.ordersOfClientsArray)
                                 self.generic.hideNativeActivityIndicator(self)
                            self.finishsetaftergetmonth()
                                print("Global.sharedInstance.ordersOfClientsArray.count \(Global.sharedInstance.ordersOfClientsArray.count)")
                            }
                    }
                } else {
                     self.generic.hideNativeActivityIndicator(self)
                }
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
               self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    func openProvider()
    {
        var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
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
                                self.dismiss(animated: false, completion: nil)
                                //פתיחת רישום ספק
                         //       self.delegate.openBuisnessDetails()
                            }
                            else
                            {
                                Global.sharedInstance.isProvider = true
                                if let _:Dictionary<String,AnyObject> =  RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                                    Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                    let mydic = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
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
                                    
                                    
                                    //שמירת שם הספק במכשיר
                                    var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                    dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                                    Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")
                                    
                                    Global.sharedInstance.defaults.synchronize()
                                    //מעבר לספק קיים
                                    if Global.sharedInstance.defaults.integer(forKey: "iSupplierStatus") == 2 ||   Global.sharedInstance.defaults.integer(forKey: "iSupplierStatus") == 0 {
                            //            self.openCustomerExist()
                                        return
                                    }
                                    let frontviewcontroller = self.storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                                    let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
                                    let vc = storyboardSupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
                                    frontviewcontroller?.pushViewController(vc, animated: false)
                                    let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                    let mainRevealController = SWRevealViewController()
                                    mainRevealController.frontViewController = frontviewcontroller
                                    mainRevealController.rearViewController = rearViewController
                             //       self.window.rootViewController = mainRevealController
                                }
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
            } else {
                
                api.sharedInstance.getProviderAllDetailsbyEmployeID(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                                self.dismiss(animated: false, completion: nil)
                                //פתיחת רישום ספק
                          //      self.delegate.openBuisnessDetails()
                            }
                            else
                            {
                                Global.sharedInstance.isProvider = true
                                if let _:Dictionary<String,AnyObject> =  RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                                    Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                    let mydic = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
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
                                    
                                    
                                    //שמירת שם הספק במכשיר
                                    var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                    dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                                    Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")
                                    
                                    Global.sharedInstance.defaults.synchronize()
                                    //מעבר לספק קיים
                                    if Global.sharedInstance.defaults.integer(forKey: "iSupplierStatus") == 2 ||   Global.sharedInstance.defaults.integer(forKey: "iSupplierStatus") == 0 {
                               //         self.openCustomerExist()
                                        return
                                    }
                                    let frontviewcontroller = self.storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                                    let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
                                    let vc = storyboardSupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
                                    frontviewcontroller?.pushViewController(vc, animated: false)
                                    let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                    let mainRevealController = SWRevealViewController()
                                    mainRevealController.frontViewController = frontviewcontroller
                                    mainRevealController.rearViewController = rearViewController
                             //       self.window.rootViewController = mainRevealController
                                }
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
}




