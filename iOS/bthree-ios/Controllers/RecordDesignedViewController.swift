//
//  RecordDesignedViewController.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/14/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
//(int iUserId, int iSupplierId,  int iFilterByMonth, int iFilterByYear)
//לקוח -תצוגת רשימה
class RecordDesignedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //MARK: - varibals
    var isfromSPECIALiCustomerUserId:Int = 0
    var headersArray:Array<String> = ["2015 אוק׳ 23ו׳,  ","2015 אוק׳ 23ו׳,  ","2015 אוק׳ 23ו׳,  "]
    var RowsArrayHours:Array<String> = ["08:00-09:30","08:00-09:30","08:00-09:30"]
    var RowsArrayDescs:Array<String> = ["מירב כהן )פסיכולוגית(","מירב כהן )פסיכולוגית(","מירב כהן )פסיכולוגית("]
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    //var arrEventsIn5Month:Array<EKEvent> = []
    var year5Month =  0
    var month5Month = 0
    var day5Month = 0
    var yearEvent =  0
    var monthEvent = 0
    var dayEvent = 0
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var MyWeekDayNames:NSArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var MyHebrewWeekDayNames:NSArray = ["יוֹם רִאשׁוֹן" ,"יוֹם שֵׁנִי‎","יוֹם שְׁלִישִׁי‎","יוֹם רְבִיעִי","יוֹם חֲמִישִׁי" ,"יוֹם שִׁישִּׁי" ,"יוֹם שַׁבָּת"]
    //מכיל את כל הארועים מהמכשיר ושל ביזר להצגה מחולק לפי תאריך(לכל תאריך יש את הארועים שלו:הקי=תאריך הארוע)
    var dicArrayEventsToShow:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var sortDicEvents:[(String,Array<allKindEventsForListDesign>)] = []//מכיל את כל הארועים הנ״ל בצורה ממויינת לפי תאריך ולפי שעות לכל יום
    
    var dicBthereEvent:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()//למקרה שהסנכרון עם המכשיר מכובה משתמשים במערך זה
    var sortDicBTHEREevent:[(String,Array<allKindEventsForListDesign>)] = []//מכיל את כל ארועים ביזר בצורה ממויינת לפי תאריך ולפי שעות לכל יום
    
    let dateFormatter = DateFormatter()
    var reloadTotalNumber:Int = 0
    var refreshControl: UIRefreshControl!
    var localOrdersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()
    var generic:Generic = Generic()
    var reloadFromInitEvents = false//מציין האם הגיעו לריענון הטבלה מהפונקציה ל initEvents
    //ואז יש שאול האם אין נתונים להציג
    
    //MARK: - @IBAction
    //click on sync eye
    @IBAction func btnSync(_ sender: eyeSynCheckBox) {
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            if sender.isCecked == false{
                Global.sharedInstance.getEventsFromMyCalendar()
                Global.sharedInstance.isSyncWithGoogelCalendar = true
            } else{
                Global.sharedInstance.isSyncWithGoogelCalendar = false
            }
        }
    }
    
    @IBOutlet weak var viewSync: UIView!
    
    @IBOutlet weak var btnSync: eyeSynCheckBox!
    
    //MARK: - Initial
    //JMODE TODO
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
        
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            viewSync.isHidden = false
            btnSync.isHidden = false
        } else {
            viewSync.isHidden = true
            btnSync.isHidden = true
        }
        
        reloadFromInitEvents = false
        let todaybe:Date = Date()
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let day = components.day
        let month = components.month
        let year = components.year
        print("d m y \(String(describing: day)) \(String(describing: month)) \(String(describing: year))")
        iFilterByMonth = month!
        iFilterByYear = year!
        reloadTotalNumber = 0
        GetCustomerOrders()
        
        if Global.sharedInstance.isSyncWithGoogelCalendar == true
        {
            btnSync.isCecked = true
        }
        
        AppDelegate.i = 0
        
        tblData.separatorStyle = .none
        
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
        
    }
    
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
        
        for i:OrderDetailsObj in Global.sharedInstance.ordersOfClientsArray
        {
            print("/////////////////////")
            print("order elem in didload: \(i.getDic()) ")
            print("/////////////////////")
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        refreshControl.addTarget(self, action: #selector(ListDesignViewController.refreshTable(_:)), for: UIControl.Event.valueChanged)
        self.tblData.addSubview(refreshControl)
        
        
        
        // Check if calendar is sync
        self.bestmode()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            self.GoogleAnalyticsSendEvent(x:11)
        }
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    
    @IBOutlet var tblData: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    
        @objc func refreshTable(_ sender:AnyObject)
    {
        // Code to refresh table view
        reloadTotalNumber += 1
        GetCustomerOrders()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if Global.sharedInstance.isSyncWithGoogelCalendar == true
        {
            return sortDicEvents.count//כל הארועים
        }
        if reloadFromInitEvents == true && sortDicBTHEREevent.count == 0
            //if sortDicBTHEREevent.count == 0
        {
            Alert.sharedInstance.showAlert("NO_EVENTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        return sortDicBTHEREevent.count//רק ארועי ביזר
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Global.sharedInstance.isSyncWithGoogelCalendar == true
        {
            return sortDicEvents[section].1.count + 1//כל הארועים
        }
        return sortDicBTHEREevent[section].1.count + 1//רק ארועי ביזר
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var event:(String,Array<allKindEventsForListDesign>)?
        if Global.sharedInstance.isSyncWithGoogelCalendar == true
        {
            event = sortDicEvents[indexPath.section]
        }
        else
        {
            event = sortDicBTHEREevent[indexPath.section]
        }
        
        //        let event =  Global.sharedInstance.arrEvents[indexPath.section]
        
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
        let componentsToday = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateFormatter.date(from: event!.0)!)
        //   //\\print(event.startDate)
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        
        let yearEvent =  componentsEvent.year
        let monthEvent = componentsEvent.month
        let dateFormatterx = DateFormatter()
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateFormatterx.locale = Locale(identifier: "he_IL")
        } else {
            dateFormatterx.locale = Locale(identifier: "en_US")
        }
        
        let monthName = dateFormatterx.shortStandaloneMonthSymbols[monthEvent! - 1]
        let dayEvent = componentsEvent.day
        
        if indexPath.row == 0
        {
            let cell:HeaderRecordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HeaderRecordTableViewCell")as!HeaderRecordTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let dayWeek = Calendar.sharedInstance.getDayOfWeek(dateFormatter.date(from: event!.0)!)
            let whatmonthisminus:Int = dayWeek!
            var a:String = ""
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                a = MyHebrewWeekDayNames.object(at: whatmonthisminus - 1) as! String
            } else {
                a = MyWeekDayNames.object(at: whatmonthisminus - 1) as! String
            }
            
            if componentsToday.day == dayEvent && componentsToday.month == monthEvent && componentsToday.year == yearEvent
            {
                cell.imgToday.isHidden = false
            }
            else
            {
                cell.imgToday.isHidden = true
            }
            let dayEventtext = "\(dayEvent ?? dayToday)" as String
            let yearEventtext = "\(yearEvent ?? yearToday)" as String
            let str =  "," + dayEventtext + " " + String(monthName) + " " + yearEventtext
            cell.setDisplayData(str,daydesc: a) //was dayInWeek for short
            return cell
        }
        else
        {
            let cell:RowRecordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RowRecordTableViewCell")as!RowRecordTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.delegate = Global.sharedInstance.calendarClient
            
            cell.event = event!.1[indexPath.row - 1]
            var isFormSyncedCalendar:Bool = false
            let issynced = event!.1[indexPath.row - 1].iDayInWeek
            if issynced == -1 {
                isFormSyncedCalendar = true
            }
            let hour =  "\(event!.1[indexPath.row - 1].fromHour) - \(event!.1[indexPath.row - 1].toHour)"
            cell.setDisplayData(hour, desc:event!.1[indexPath.row - 1].title,EventFrom: event!.1[indexPath.row - 1].tag, _isFormSyncedCalendar:isFormSyncedCalendar)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 32
        }
        return 54
    }
    
    @objc func showSync()
    {
        if btnSync.isCecked == false
        {
            Global.sharedInstance.getEventsFromMyCalendar()
            btnSync.isCecked = true
            Global.sharedInstance.isSyncWithGoogelCalendar = true
        }
        else
        {
            btnSync.isCecked = false
            Global.sharedInstance.isSyncWithGoogelCalendar = false
        }
        tblData.reloadData()
    }
    
    
    
    func small(_ lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
    
    
    
    func GetCustomerOrders()  {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        
        
        if self.isfromSPECIALiCustomerUserId != 0 {
            let USERDEF = Global.sharedInstance.defaults
            USERDEF.set(self.isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
            dic["iUserId"] = self.isfromSPECIALiCustomerUserId as AnyObject
            
        } else {
            dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
            let USERDEF = Global.sharedInstance.defaults
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
        }
        dic["iFilterByMonth"] = iFilterByMonth + reloadTotalNumber as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject
        
        if Reachability.isConnectedToNetwork() == false
        {
            
            //            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomerOrdersNoLogo(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                        let ps:OrderDetailsObj = OrderDetailsObj()
                        self.localOrdersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                        var keysuniquevalues:Array<Int> = Array<Int>()
                        
                        for itemx in Global.sharedInstance.ordersOfClientsArray {
                            keysuniquevalues.append(itemx.iCoordinatedServiceId)
                        }
                        var set = Set(keysuniquevalues)
                        for i:OrderDetailsObj in self.localOrdersOfClientsArray
                        {
                            if !set.contains(i.iCoordinatedServiceId)
                            {
                                Global.sharedInstance.ordersOfClientsArray.append(i)
                            }
                            print("/////////////////////")
                            print("order elem: \(i.getDic()) ")
                            print("/////////////////////")
                        }
                    } else {
                        print("eroare la server")
                    }
                }
                self.initEvents()
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                
                //                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    func initEvents()
    {
        Global.sharedInstance.setAllEventsArray()
        
        dicArrayEventsToShow.removeAll()
        dicArrayEventsToShow = Dictionary<String,Array<allKindEventsForListDesign>>()
        dicBthereEvent.removeAll()
        dicArrayEventsToShow = Dictionary<String,Array<allKindEventsForListDesign>>()
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        Global.sharedInstance.getEventsFromMyCalendar()
        

        //------------------אתחול המערכים להצגת הארועים בצורה ממויינת------------------------
        let dateToday = Date()
        let dateIn5Month = Calendar.sharedInstance.addMonths(Date(), numMonthAdd: 5)
        
        //עובר על הארועים מהמכשיר
        for event in Global.sharedInstance.arrEvents
        {
            let dateEvent = event.startDate
            let calendar:Foundation.Calendar = Foundation.Calendar.current
            
            let components5Month = (calendar as NSCalendar).components([.day, .month, .year], from: dateIn5Month)
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateEvent!)
            year5Month =  components5Month.year!
            month5Month = components5Month.month!
            day5Month = components5Month.day!
            yearEvent =  componentsEvent.year!
            monthEvent = componentsEvent.month!
            dayEvent = componentsEvent.day!
            
            //אם בטווח של 5 חודשים מהיום
            if (small(dateEvent!, rhs: dateIn5Month) == true && small(dateToday, rhs: dateEvent!) == true) || calendar.isDateInToday(dateEvent!) || (year5Month == yearEvent && month5Month == monthEvent && day5Month == dayEvent)
            {
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
                    minuteS_Show = "0" +  minuteS_Show
                }
                if minuteE! < 10
                {
                    minuteE_Show = "0" + minuteE_Show
                }
                
                //ליצור אובקט
                //בדיקה אם קיים כזה קי(תאריך)
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
                    _iCoordinatedServiceId : 0,
                    _iCancelallCoordinatedServiceIds:[],
                    _iCancelalliUserId: [],
                    _isCancelGroup: false,
                    _specialDate: "",
                    _ARRAYiProviderUserId : ARRAYiProviderUserId,
                    _objProviderServiceDetails:objProviderServiceDetails,
                    _nvLogo: "",
                    _chServiceColor: "",
                    _viewsforweek: [],
                    _iCoordinatedServiceStatusType: 0,
                    _nvPhone: "",
                    _iSupplierId: 0
                )
                
                if dicArrayEventsToShow[dateFormatter.string(from: event.startDate)] != nil
                {
                    dicArrayEventsToShow[dateFormatter.string(from: event.startDate)]?.append(eventPhone)
                }
                else
                {
                    dicArrayEventsToShow[dateFormatter.string(from: event.startDate)] = Array<allKindEventsForListDesign>()
                    dicArrayEventsToShow[dateFormatter.string(from: event.startDate)]?.append(eventPhone)
                }
            }
        }
        //עובר על הארועים של ביזר
        for eventBthere in Global.sharedInstance.ordersOfClientsArray
        {
            let dateEvent = eventBthere.dtDateOrder
            let calendar:Foundation.Calendar = Foundation.Calendar.current
            
            let components5Month = (calendar as NSCalendar).components([.day, .month, .year], from: dateIn5Month)
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateEvent as Date)
            year5Month =  components5Month.year!
            month5Month = components5Month.month!
            day5Month = components5Month.day!
            yearEvent =  componentsEvent.year!
            monthEvent = componentsEvent.month!
            dayEvent = componentsEvent.day!
            
            //אם בטווח של 5 חודשים מהיום
            if (small(dateEvent, rhs: dateIn5Month) == true && small(dateToday, rhs: dateEvent) == true) || calendar.isDateInToday(dateEvent) || (year5Month == yearEvent && month5Month == monthEvent && day5Month == dayEvent)
            {
                let hourStart = Global.sharedInstance.getStringFromDateString(eventBthere.nvFromHour)
                let hourEnd = Global.sharedInstance.getStringFromDateString(eventBthere.nvToHour)
                
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
                
                var serviceName = ""
                for item in eventBthere.objProviderServiceDetails
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
                
                var nvServiceName = ""
                for item in eventBthere.objProviderServiceDetails
                {
                    if nvServiceName == ""
                    {
                        nvServiceName = item.nvServiceName
                    }
                    else
                    {
                        nvServiceName = "\(nvServiceName),\(item.nvServiceName)"
                    }
                }
                //\\print( "eventBthere.iProviderUserId \(eventBthere.iProviderUserId)  _iUserId: \(eventBthere.iUserId)")
                let ARRAYiProviderUserId:Array<Int> = []
                if  nvServiceName != "BlockHours" {
                    
                    let objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
                    var nvPhone:String = ""
                    if let _:String = eventBthere.nvPhone as? String {
                        nvPhone = eventBthere.nvPhone 
                    }
                    
                    var iSupplierId:Int = eventBthere.iSupplierId
                    
                    let eventBtheree:allKindEventsForListDesign = allKindEventsForListDesign(
                        _dateEvent: eventBthere.dtDateOrder,
                        _title: "\(nvServiceName),\(eventBthere.nvSupplierName)",
                        _fromHour: "\(hourS_Show):\(minuteS_Show)",
                        _toHour: "\(hourE_Show):\(minuteE_Show)",
                        _tag: 1,
                        _nvAddress: eventBthere.nvAddress,
                        _nvSupplierName: eventBthere.nvSupplierName,
                        _iDayInWeek: eventBthere.iDayInWeek,
                        _nvServiceName: serviceName,
                        _nvComment: eventBthere.nvComment,
                        _iProviderUserId: eventBthere.iProviderUserId,
                        _iUserId: eventBthere.iUserId,
                        _ClientnvFullName: "",
                        _iCoordinatedServiceId: eventBthere.iCoordinatedServiceId,
                        _iCancelallCoordinatedServiceIds:[],
                        _iCancelalliUserId: [],
                        _isCancelGroup: false,
                        _specialDate: "",
                        _ARRAYiProviderUserId : ARRAYiProviderUserId,
                        _objProviderServiceDetails:objProviderServiceDetails,
                        _nvLogo: "",
                        _chServiceColor: eventBthere.chServiceColor,
                        _viewsforweek: [],
                        _iCoordinatedServiceStatusType: 0,
                        _nvPhone: nvPhone,
                        _iSupplierId: iSupplierId
                    )
                    //בשביל שאם לא רוצה סנכרון
                    if dicBthereEvent[dateFormatter.string(from: eventBthere.dtDateOrder as Date)] != nil
                    {
                        dicBthereEvent[dateFormatter.string(from: eventBthere.dtDateOrder as Date)]?.append(eventBtheree)
                    }
                    else
                    {
                        dicBthereEvent[dateFormatter.string(from: eventBthere.dtDateOrder as Date)] = Array<allKindEventsForListDesign>()
                        dicBthereEvent[dateFormatter.string(from: eventBthere.dtDateOrder as Date)]?.append(eventBtheree)
                    }
                    
                    if dicArrayEventsToShow[dateFormatter.string(from: eventBthere.dtDateOrder as Date)] != nil
                    {
                        dicArrayEventsToShow[dateFormatter.string(from: eventBthere.dtDateOrder as Date)]?.append(eventBtheree)
                    }
                    else
                    {
                        dicArrayEventsToShow[dateFormatter.string(from: eventBthere.dtDateOrder as Date)] = Array<allKindEventsForListDesign>()
                        dicArrayEventsToShow[dateFormatter.string(from: eventBthere.dtDateOrder as Date)]?.append(eventBtheree)
                    }
                }
            }
        }
        //----------מיון לפי ימים
        //sortDicEvents = []
        sortDicEvents = [(String,Array<allKindEventsForListDesign>)]()
        sortDicEvents = dicArrayEventsToShow.sorted{ dateFormatter.date(from: $0.0)!.compare(dateFormatter.date(from: $1.0)!) == .orderedAscending}
        //ארועי ביזר בלבד!!
        sortDicBTHEREevent = [(String,Array<allKindEventsForListDesign>)]()
        sortDicBTHEREevent = dicBthereEvent.sorted{ dateFormatter.date(from: $0.0)!.compare(dateFormatter.date(from: $1.0)!) == .orderedAscending}
        //-------מיון לכל יום לפי השעות
        var i = 0
        for _ in sortDicEvents//כל הארועים
        {
            sortDicEvents[i].1.sort(by: { $0.dateEvent.compare($1.dateEvent as Date) == ComparisonResult.orderedAscending })
            i += 1
        }
        
        //        for i:(String,Array<allKindEventsForListDesign>) in sortDicEvents
        //        {
        //            print("11 events in list:")
        //            print(i)
        //        }
        
        i = 0
        for _ in sortDicBTHEREevent//ארועי ביזר
        {
            sortDicBTHEREevent[i].1.sort(by: { $0.dateEvent.compare($1.dateEvent as Date) == ComparisonResult.orderedAscending })
            
            i += 1
        }
        for i:(String,Array<allKindEventsForListDesign>) in sortDicBTHEREevent
        {
            print("12 events in list:")
            print(i)
        }
        reloadFromInitEvents = true
        refreshControl.endRefreshing()
        tblData.reloadData()
    }
    
}
