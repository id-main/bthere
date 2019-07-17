//
//  DayDesignSupplierViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 01.03.2017
//  Copyright © 2017 Bthere. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import MessageUI

class DayDesignSupplierViewController: UIViewController,setDateDelegate,iCarouselDataSource, iCarouselDelegate, UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate{  //MASSIVE MODE JPLUS
    //NEW DEVELOP
    var BlockHouresObjArray:Array<BlockHouresObj> =  Array<BlockHouresObj>()
    var intSuppliersecondID:Int = 0
    //END NEW
    var FROMPRINT:Bool = false
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var isfromnavigation:Bool = false
    var isfirsttime:Bool = true
    var EMPLOYEISMANAGER:Bool = false
    var refreshControl: UIRefreshControl!
    @IBOutlet var tblData: UITableView!
    var PERFECTSENSE:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
    var HOLLYDAYSSECTIONSFINAL:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
    var ALLSECTIONSFINAL:[(Int,Array<allKindEventsForListDesign>)] = []
    var ALLSECTIONSFINALFILTERED:[(Int,Array<allKindEventsForListDesign>)] = []
    var isexpanded:Bool = false
    var frommonthorweek:Bool = false //it comes from month or week= true else on false today = NSDate()    var arrBThereEventsCurrentDay:Array<allKindEventsForListDesign> = []
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var iFilterByMonthEnd:Int = 0
    var iFilterByYearEnd:Int = 0
    var yearEvent =  0
    var monthEvent = 0
    var dayEvent = 0
    var numDaysInMonth:Int = 0
    var myCustomersArray : NSMutableArray = []
    var arrayWorkers:  NSMutableArray = []
    var selectedWorker:Bool = false
    var selectedWorkerID:Int = 0
    var generic:Generic = Generic()
    var dicArrayEventsToShow:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var dicBthereEvent:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var sortDicBTHEREevent:[(String,Array<allKindEventsForListDesign>)] = []
    var sortDicBTHEREeventFiltered:[(String,Array<allKindEventsForListDesign>)] = []
    var sortDicEvents:[(String,Array<allKindEventsForListDesign>)] = []
    let dateFormatter = DateFormatter()
    var myArray : NSMutableArray = NSMutableArray()
    var dateturn:String = ""
    var isSyncCalendar: String = "1"
    //MARK: - Properties

    let language = Bundle.main.preferredLocalizations.first! as NSString
    var arrHoursInt:Array<Int> =
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    var arrHours:Array<String> = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]
    var arrEventsCurrentDay:[(String,Array<allKindEventsForListDesign>)] = []

    var flag = false
    var hasEvent = false
    var currentDate:Date = Date()
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    let pinchRecognizer = UIPinchGestureRecognizer()
    let panRecognizer = UIPanGestureRecognizer()
    var pinchInProgress = false
    var pointOneLast:CGPoint = CGPoint()
    var pointOne:CGPoint = CGPoint()
    var pointTwo:CGPoint = CGPoint()
    //MARK: - Outlet
    @IBOutlet var carousel: iCarousel!
    @IBOutlet var arrowleft: UIImageView!
    @IBOutlet var arrowright: UIImageView!
    //    @IBOutlet weak var lblDayOfMonth: UILabel!
    //    @IBOutlet weak var lblDayOfWeek: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblhollydays: UILabel!
    //       func allcommonGroup() {
    //         for item in ALLSECTIONSFINAL {
    //        var onemoretry:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
    //        var oraintreg:Int = item.0
    //        onemoretry = item.1
    //        for inthour in arrHoursInt {
    //            if inthour == oraintreg {
    //                //  var whatifhave:allKindEventsForListDesign = allKindEventsForListDesign()
    //             //   for itemx in onemoretry {
    ////                    itemx.toHour
    ////                    itemx.fromHour
    //                var sharedMovies=[]
    //                for itemx in onemoretry{
    //                    if itemx.fromHour.contains(itemx.fromHour){
    //                        sharedMovies.append(item)
    //                    }
    ////                    let filteredContacts = onemoretry.filterDuplicates { $0.fromHour == $1.fromHour && $0.toHour == $1.toHour }
    ////                      print("filteredContacts \(filteredContacts)")
    ////                          }
    //          //  }
    //            }
    //        }
    //    }

    @objc func panisout(_ recognizer: UIPanGestureRecognizer) {
        isexpanded = false
        tblData.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:60)
        print("Global.sharedInstance.providerID 3: \(Global.sharedInstance.providerID)")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //      if Global.sharedInstance.rtl
        //        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0
        //        {
        //            arrowleft.image =    UIImage(named: "")
        //            arrowright.image =    UIImage(named: "sageata2.png")
        //        }
        //        else
        //        {
        //            arrowleft.image =    UIImage(named: "sageata2.png")
        //            arrowright.image =    UIImage(named: "sageata1.png")
        //        }
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


    }
    //mark init ALLSECTIONSFINAL
    @objc func refreshTable(_ sender:AnyObject) {
        // Code to refresh table view
        print("merge")
       GetSecondUserIdByFirstUserIdSeven()


    }
    func initALLSECTIONSFINAL() {
        ALLSECTIONSFINAL = []
        ALLSECTIONSFINALFILTERED = []
        for inthour in arrHoursInt {
            let onetoadd = (inthour,Array<allKindEventsForListDesign>())
            ALLSECTIONSFINAL.append(onetoadd)
        }

        for inthour in arrHoursInt {
            let onetoadd = (inthour,Array<allKindEventsForListDesign>())
            ALLSECTIONSFINAL.append(onetoadd)
        }

    }
    //MARK TBLVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrHoursInt.count + 1  //this is for hollydays
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var expint:Int = 0
        if section == 0 {
            //holydays
            expint = HOLLYDAYSSECTIONSFINAL.count
            return expint
        } else {

            if ALLSECTIONSFINALFILTERED.count > 0 {
             //   print("ALLSECTIONSFINAL[section].count \( ALLSECTIONSFINALFILTERED[section - 1].1.count)")
                //   print("ALLSECTIONSFINALFILTERED[section].count \( ALLSECTIONSFINALFILTERED[section].1.count)")
                //       if  ALLSECTIONSFINALFILTERED[section].1.count != 0{
                if isexpanded == false {
                    expint = ALLSECTIONSFINALFILTERED[section - 1].1.count + 1
                    if ALLSECTIONSFINALFILTERED[section - 1 ].1.count >= 3 {
                        expint = 3 + 1

                    }
                    return expint



                } else {

                    expint = ALLSECTIONSFINALFILTERED[section - 1].1.count + 1
                    return expint
                }
            }
        }

        return expint

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            //holydays
            return 25
        } else {
            if indexPath.row == 0{
                var ISBLOCKED = false
                var event:(Int,Array<allKindEventsForListDesign>)?
                event = ALLSECTIONSFINALFILTERED[indexPath.section - 1]
                for item in event!.1 {
                    if item.nvComment == "BlockedBySupplier" {
                        ISBLOCKED = true
                    }
                }

                if ISBLOCKED == true {
                    return 0
                }
                return 50
            } else {

                if isexpanded == false {

                    return 50
                }
            }
        }

        return 72
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        if indexPath.section != 0 {
            var event:(Int,Array<allKindEventsForListDesign>)?

            event = ALLSECTIONSFINALFILTERED[indexPath.section - 1]
            print(" ALLSECTIONSFINAL[indexPath.row] \(ALLSECTIONSFINALFILTERED[indexPath.row].1)")




            if indexPath.row == 0
            {
                let cell:LineHoursTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LineHoursTableViewCell")as!LineHoursTableViewCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                if let _:String = arrHours[indexPath.section - 1]  {
                    let oraafisata:String = arrHours[indexPath.section - 1]
                    cell.setDisplayData(oraafisata)

                }
                return cell
            }
            else
            {

                let cell:DaySupplierInListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DaySupplierInListTableViewCell")as!DaySupplierInListTableViewCell

                var islastrow:Bool = false
                var isBthereEvent:Bool = false
                var isHourPast:Bool = false

                cell.dateTurn = dateturn
                cell.isfromLIST = false
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
                let isIndexValid = event!.1.indices.contains(indexPath.row - 1)
                if isIndexValid == true {
                cell.event = event!.1[indexPath.row - 1]

                var lastrow:Int = 0
                let mytotalrows:Int = event!.1.count
                if isexpanded == false {
                    if mytotalrows >= 3 {
                        lastrow = 4

                        print("lastrow \(lastrow)")
                        if indexPath.row == lastrow - 1  {
                            islastrow = true
                        }
                    }
                }





                //   let anyhow:Int = cell.event.iUserId
                var emi:NSMutableDictionary = NSMutableDictionary()
                if let _:String = event!.1[indexPath.row - 1].nvPhone   {
                    let nvPhone = event!.1[indexPath.row - 1].nvPhone
                    emi["nvPhone"] = nvPhone
                }
                //                if self.findCustomer(anyhow) != NSDictionary() {
                //                    emi = self.findCustomer(anyhow)
                //                }
                if self.hourisless(event!.1[indexPath.row - 1]) == true {

                    isHourPast =  true
                    //\\print(event!.1[indexPath.row - 1].title)
                }


                let eventdateday:Date = event!.1[indexPath.row - 1].dateEvent as Date
                let componentsCurrent = (self.calendar as NSCalendar).components([.day, .month, .year], from: eventdateday)
                let monthtoask = componentsCurrent.month
                let yeartoask = componentsCurrent.year
                let daytoask = componentsCurrent.day
                let componentsCurrentev = (self.calendar as NSCalendar).components([.day, .month, .year], from: Date())
                let monthtoaskv = componentsCurrentev.month
                let yeartoaskv = componentsCurrentev.year
                let daytoaskv = componentsCurrentev.day

                if (monthtoask == monthtoaskv && yeartoask == yeartoaskv && daytoask == daytoaskv && isHourPast == true){
                    isHourPast = true
                }
                if (monthtoask! == monthtoaskv! && yeartoask! == yeartoaskv! && daytoask! < daytoaskv!) {
                    isHourPast = true
                }
                if (monthtoask! < monthtoaskv! && yeartoask! == yeartoaskv!)  {
                    isHourPast = true
                }
                if yeartoask! < yeartoaskv! {
                    isHourPast = true
                }
                if (monthtoask == monthtoaskv && yeartoask == yeartoaskv && daytoask == daytoaskv && isHourPast == false){ //just for reference
                    isHourPast = false
                }
                if (monthtoask! == monthtoaskv! && yeartoask! == yeartoaskv! && daytoask! > daytoaskv!) {
                    isHourPast = false
                }
                if (monthtoask! > monthtoaskv! && yeartoask! == yeartoaskv!)  {
                    isHourPast = false
                }
                if yeartoask! > yeartoaskv! {
                    isHourPast = false
                }

                let isbthereevent = event!.1[indexPath.row - 1].iProviderUserId
                let thisday:Date = Date()
                let dateofevent =  event!.1[indexPath.row - 1].dateEvent
                if dateofevent as Date > thisday {
                    isHourPast = false
                }
                var ISBLOCKED :Bool = false
                var ISOCASSIONAL:Bool = false
                if isbthereevent != 0 {
                    isBthereEvent = true
                    if event!.1[indexPath.row - 1].iUserId == 134 {
                        ISOCASSIONAL = true
                    }
                    if event!.1[indexPath.row - 1].nvComment == "BlockedBySupplier" {
                        ISBLOCKED = true
                    }
                    let st =  "\(event!.1[indexPath.row - 1].fromHour) - \(event!.1[indexPath.row - 1].toHour)"
                    cell.setDisplayData(st, _desc:event!.1[indexPath.row - 1].ClientnvFullName,_EventFrom: event!.1[indexPath.row - 1].tag,_index: indexPath.section,_ClientDict: emi,_servicesdesc:event!.1[indexPath.row - 1].title, _isexpanded : isexpanded, _islastrow: islastrow, _isBthereEvent: isBthereEvent, _isHourPast:isHourPast,_isBlocked: ISBLOCKED, _isocassional:ISOCASSIONAL )
                } else {
                    isBthereEvent = false
                    if event!.1[indexPath.row - 1].nvComment == "BlockedBySupplier" {
                        ISBLOCKED = true
                    }
                    let emptyservice:String = ""
                    let st =  "\(event!.1[indexPath.row - 1].fromHour) - \(event!.1[indexPath.row - 1].toHour)"
                    cell.setDisplayData(st, _desc:event!.1[indexPath.row - 1].title,_EventFrom: event!.1[indexPath.row - 1].tag,_index: indexPath.section,_ClientDict: emi,_servicesdesc:emptyservice , _isexpanded : isexpanded, _islastrow: islastrow, _isBthereEvent: isBthereEvent, _isHourPast:isHourPast,_isBlocked: ISBLOCKED, _isocassional:ISOCASSIONAL  )
                }

                }

                return cell

            }
        } else {
            //holydays and other
            let cell:HollydaysTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HollydaysTableViewCell")as!HollydaysTableViewCell
            var event = allKindEventsForListDesign()
            event = HOLLYDAYSSECTIONSFINAL[indexPath.row]
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setDisplayData(event.title)
            return cell
        }

    }




    //MARK: - IBAction
    @IBAction func btnPrevious(_ sender: AnyObject){
        let USERDEF = UserDefaults.standard
        USERDEF.setValue(0, forKey:"FORCEDAYOPEN")
        USERDEF.setValue(0, forKey:"DAYTOOPEN")
        USERDEF.setValue(0, forKey:"HOURTOOPEN")
        USERDEF.synchronize()
        self.frommonthorweek = true
        hasEvent = false
        currentDate = Calendar.sharedInstance.reduceDay(currentDate)
        Global.sharedInstance.currDateSelected = currentDate
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        //\\print ("azidayiFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd)")
        if iFilterByMonth > monthToday {
            iFilterByMonth = monthToday
            iFilterByMonthEnd = monthToday
            if iFilterByYear > yearToday {
                iFilterByYear = yearToday
                iFilterByYear = yearToday
            }

            GetSecondUserIdByFirstUserIdSeven()


        } else {
            iFilterByMonth = monthToday
            iFilterByYear = yearToday
            iFilterByMonthEnd = monthToday
            iFilterByYearEnd = yearToday
            //filter mass array
            //      setEventsArray()
            initEvents()
            // refreshTable(self.refreshControl)
        }
        setDate()
    }

    @IBAction func btnNext(_ sender: AnyObject){
        let USERDEF = UserDefaults.standard
        USERDEF.setValue(0, forKey:"FORCEDAYOPEN")
        USERDEF.setValue(0, forKey:"DAYTOOPEN")
        USERDEF.setValue(0, forKey:"HOURTOOPEN")
        USERDEF.synchronize()
        hasEvent = false
        self.frommonthorweek = true
        currentDate =  Calendar.sharedInstance.addDay(currentDate)
        Global.sharedInstance.currDateSelected = currentDate
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        //\\print ("ayearToday \(yearToday) iFilterByYear \(monthToday) monthToday ")
        //\\print ("nextdayiFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd)")
        if iFilterByMonth < monthToday {
            iFilterByMonth = monthToday
            iFilterByMonthEnd = monthToday
            if iFilterByYear < yearToday {
                iFilterByYear = yearToday
            }
           GetSecondUserIdByFirstUserIdSeven()


        } else {
            iFilterByMonth = monthToday
            iFilterByYear = yearToday
            iFilterByMonthEnd = monthToday
            iFilterByYearEnd = yearToday
            initEvents()
        }
        setDate()

    }

    @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {

            pointOne = recognizer.location(ofTouch: 0, in: tblData)
            pointTwo = recognizer.location(ofTouch: 1, in: tblData)
            isexpanded = true
            tblData.reloadData()
            let numberOfRows = self.tblData.numberOfRows(inSection: 7)
            let indexPath = IndexPath(row: numberOfRows-1, section: 7)
            self.tblData.scrollToRow(at: indexPath,
                                     at: UITableView.ScrollPosition.top, animated: true)
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





    @IBOutlet weak var viewSync: UIView!

    @IBOutlet weak var btnSyncGoogelSupplier: eyeSynCheckBox!

    func bestmode(){
        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 {
            self.EMPLOYEISMANAGER = false
        } else {
            self.EMPLOYEISMANAGER = true
        }
        let USERDEF = Global.sharedInstance.defaults
        if let _:Int = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as? Int {
            let y = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as! Int
            if y == 0 {
                viewSync.isHidden = true
                btnSyncGoogelSupplier.isHidden = true
            } else if y == 1 {
                viewSync.isHidden = false
                btnSyncGoogelSupplier.isHidden = false
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true{
                    btnSyncGoogelSupplier.isCecked = true
                } else {
                    btnSyncGoogelSupplier.isCecked = false
                }
            }
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
        Global.sharedInstance.dayDesignCalendarSupplier = self
        view.sendSubviewToBack(lblDay)

        hasEvent = false
        arrEventsCurrentDay = []


        let todaybe:Date = currentDate
        print("bestdate currentDate \(currentDate)")

        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let month = components.month
        let year = components.year
        iFilterByMonth = month!
        iFilterByYear = year!
        iFilterByMonthEnd = month!
        iFilterByYearEnd = year!
        //\\print ("bestdayiFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd)")
        self.myArray = []
        Global.sharedInstance.ordersOfClientsArray = []
        //2 months
        if iFilterByMonth == 12 {
            iFilterByMonthEnd = 1
            iFilterByYearEnd = iFilterByYear + 1
        } else if iFilterByMonth < 12 {
            iFilterByMonthEnd = iFilterByMonth + 1
            iFilterByYearEnd = iFilterByYear
        }
        GetSecondUserIdByFirstUserIdSeven()
        setDate()
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
        pinchRecognizer.addTarget(self, action: #selector(self.handlePinch(_:)))
        tblData.addGestureRecognizer(pinchRecognizer)

    }
    //MARK: - Initial
    func initDate(_ date:Date)

    {

        currentDate = date
        let todaybe:Date = currentDate

        print("initdate currentDate \(currentDate)")
        numDaysInMonth = Calendar.sharedInstance.getNumsDays(todaybe)
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let month = components.month
        let year = components.year
        iFilterByMonth = month!
        iFilterByYear = year!
        iFilterByMonthEnd = month!
        iFilterByYearEnd = year!
        //\\print ("initdayiFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd)")

        GetSecondUserIdByFirstUserIdSeven()


        setDate()
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
        pinchRecognizer.addTarget(self, action: #selector(self.handlePinch(_:)))
        tblData.addGestureRecognizer(pinchRecognizer)
        //        panRecognizer.addTarget(self, action: #selector(self.panisout(_:)))
        //         panRecognizer.cancelsTouchesInView = false
        //        tblData.addGestureRecognizer(panRecognizer)
        isexpanded = false
        pointOneLast = CGPoint()
        pointOne = CGPoint()
        pointTwo = CGPoint()
        tblData.separatorStyle = .none

    }
    //MARK: - Initial


    var viewhelp : helpPpopup!
    func LOADHELPERS() {
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
            if let mydict:NSMutableDictionary = fullimgarr[7] as? NSMutableDictionary {
                if mydict["seen"] as! Int == 1 { //was not seen
                    let changedictionary: NSMutableDictionary = NSMutableDictionary()
                    changedictionary["needimage"] = mydict["needimage"]
                    changedictionary["seen"] = 0 //seen
                    print("changedic \(changedictionary)")
                    fullimgarr[7] = changedictionary
                    print("fullimgarr \(fullimgarr.description)")
                    USERDEF.set(fullimgarr, forKey: HELPSCREENKEYFORNSUSERDEFAULTS)
                    USERDEF.synchronize()
                    print("USERDEF key arr \(USERDEF.object(forKey: HELPSCREENKEYFORNSUSERDEFAULTS))")
                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    viewhelp = storyboardtest.instantiateViewController(withIdentifier: "helpPpopup") as! helpPpopup
                    if self.iOS8 {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    } else {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    }
                    viewhelp.indexOfImg = 7
                    viewhelp.HELPSCREENKEYFORNSUSERDEFAULTS = HELPSCREENKEYFORNSUSERDEFAULTS
                    self.present(viewhelp, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // helpPpopup


        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 {
            self.EMPLOYEISMANAGER = false
        } else {
            self.EMPLOYEISMANAGER = true
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


        self.automaticallyAdjustsScrollViewInsets = false
        tblData.separatorStyle = .none
        Global.sharedInstance.dayDesignCalendarSupplier = self

        if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true{
            btnSyncGoogelSupplier.isCecked = true
        }

        view.sendSubviewToBack(lblDay)

        hasEvent = false
        arrEventsCurrentDay = []
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        refreshControl.addTarget(self, action: #selector(DayDesignSupplierViewController.refreshTable(_:)), for: UIControl.Event.valueChanged)
        self.tblData.addSubview(refreshControl)
        //        var scalingTransform : CGAffineTransform!
        //        scalingTransform = CGAffineTransformMakeScale(-1, 1)
        //        if Global.sharedInstance.rtl {
        //
        //       //    tblData.transform = scalingTransform
        //        }


        self.myArray = []

        GetSecondUserIdByFirstUserIdSeven()
        setDate()


        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
        pinchRecognizer.addTarget(self, action: #selector(self.handlePinch(_:)))
        tblData.addGestureRecognizer(pinchRecognizer)
        //        panRecognizer.addTarget(self, action: #selector(self.panisout(_:)))
        //         panRecognizer.cancelsTouchesInView = false
        //        tblData.addGestureRecognizer(panRecognizer)
        isexpanded = false
        pointOneLast = CGPoint()
        pointOne = CGPoint()
        pointTwo = CGPoint()


        print("Global.sharedInstance.currentUser.bIsGoogleCalendarSync: \(Global.sharedInstance.currentUser.bIsGoogleCalendarSync)")

        // Check if calendar is sync
        let USERDEF = Global.sharedInstance.defaults
        if let _:Int = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as? Int {
            let y = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as! Int
            if y == 0 {
            viewSync.isHidden = true
            btnSyncGoogelSupplier.isHidden = true
            } else if y == 1 {
                viewSync.isHidden = false
                btnSyncGoogelSupplier.isHidden = false
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true{
                    btnSyncGoogelSupplier.isCecked = true
                } else {
                    btnSyncGoogelSupplier.isCecked = false
                }
            }
        }


    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setDateClick(_ date:Date){// take a date save in global when day in month clicked and show the date in day design
        print("setDateClick \(date)")
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        numDaysInMonth = Calendar.sharedInstance.getNumsDays(date)
        //\\print ("setDateClicksetdayiFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd) dayToday \(dayToday)")
        iFilterByMonth = monthToday
        iFilterByYear = yearToday
        iFilterByMonthEnd = monthToday
        iFilterByYearEnd = yearToday
        //the day of week from date - (int)
        let day:Int = Calendar.sharedInstance.getDayOfWeek(date)! - 1
        print("mayday \(day)")
        //the day of week from date - (letter - string)
        //  lblDayOfWeek.text = NSDateFormatter().veryShortWeekdaySymbols[day]

        //the day of month from date - (int)
        //  lblDayOfMonth.text = dayToday.description

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



        // - long
        //NSDateFormatter().monthSymbols[monthToday - 1]
        //   let dayName = NSDateFormatter().weekdaySymbols[day]
        let dayName = dateFormatter.weekdaySymbols[day]
        //cut the word "יום" from the string
        let myLongDay: String = dayName
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            var myShortDay = myLongDay.components(separatedBy: " ")
            lblDay.text = myShortDay[1]
        } else {
            lblDay.text = myLongDay
        }

        //
        //        if language == "he"
        //        {
        //
        //        }
        //        else
        //        {
        //
        //        }
        lblDate.text = "\(dayToday) \(monthName) \(yearToday)"
        isexpanded = false
        pointOneLast = CGPoint()
        pointOne = CGPoint()
        pointTwo = CGPoint()
    }


    // Set sync Design if eye set on
    @IBAction func btnSyncWithGoogel(_ sender: eyeSynCheckBox) {
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            if (sender.isCecked == false) {
                Global.sharedInstance.getEventsFromMyCalendar()
                Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true
                //  colDay.reloadData()
                setEventsArray()
            } else {
                Global.sharedInstance.isSyncWithGoogelCalendarSupplier = false
                //  colDay.reloadData()
                setEventsArray()
            }
        }
    }


    //set labels context by spech date selected
    func setDate()
    {
        //the day of week from date - (int)
        //        if self.frommonthorweek == false {
        //            let onlytoday:NSDate = NSDate()
        //            currentDate = onlytoday
        //        }
        let day:Int = Calendar.sharedInstance.getDayOfWeek(currentDate)! - 1

        let todaybe:Date = currentDate
        numDaysInMonth = Calendar.sharedInstance.getNumsDays(todaybe)
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let month = components.month
        let year = components.year
        //\\print ("setdayiFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd) dayToday \(todaybe)")
        iFilterByMonth = month!
        iFilterByYear = year!
        iFilterByMonthEnd = month!
        iFilterByYearEnd = year!
        //\\print ("aftersetdayiFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd)")
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!


        if monthToday == 0 {
            monthToday = 1
        }
        var monthName = DateFormatter().shortStandaloneMonthSymbols[monthToday - 1]

        let dateFormatter = DateFormatter()
        let dateFormatterYEAR = DateFormatter()

        dateFormatter.dateFormat = "MMM"
        dateFormatterYEAR.dateFormat = "yyyy"


        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            dateFormatter.locale = Locale(identifier: "he_IL")
        } else if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 1
        {
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        else if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 3
        {
            dateFormatter.locale = Locale(identifier: "ru_RU")
        }
        else
        {
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
    //MARK: -EventFunction
    func getDateFromString(_ dateString: String)->Date
    {
        var datAMEA:Date = Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy"
        //   dateFormatter2.dateStyle = .ShortStyle
        //        print("crASH \(dateString)")
        if let  _ = dateFormatter2.date(from: dateString) {
            datAMEA = dateFormatter2.date(from: dateString)!
            print("datestring \(getDateFromString) si data mea \(datAMEA)")
        }
        return datAMEA
    }

    //get device events of day
    func setEventsArray()
    {
        arrEventsCurrentDay = []

        if   Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true {
            PERFECTSENSE = Array<allKindEventsForListDesign>()
            for  item in sortDicEvents
            {
                // for event in sortDicEvents//כל הארועים

                print("myitem now \(item)")
                //30/11/2016", [<Bthere.allKindEventsForListDesign: 0x1701ffd00>]
                if let _:String = item.0  {
                    let eventdate:String = item.0

                    if  let _:Date = getDateFromString(eventdate) {
                        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
                        let newEVENTDATE:Date = getDateFromString(eventdate)
                        let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: newEVENTDATE)

                        yearToday =  componentsCurrent.year!
                        monthToday = componentsCurrent.month!
                        dayToday = componentsCurrent.day!
                        print("aaaaadayToday \(dayToday)")
                        let yearEvent =  componentsEvent.year
                        let monthEvent = componentsEvent.month
                        let dayEvent = componentsEvent.day

                        if ((yearEvent == yearToday) && (monthEvent == monthToday) && (dayEvent == dayToday))
                        {
                            //     arrEventsCurrentDay.append(item)
                            for myx in item.1 {
                                if !PERFECTSENSE.contains(myx) {
                                    PERFECTSENSE.append(myx)
                                }
                            }
                            hasEvent = true
                        }
                    }
                }

            }
        }else {
            //sortDicBTHEREevent
            PERFECTSENSE = Array<allKindEventsForListDesign>()
            for  itemx in sortDicBTHEREevent
            {
                // for event in sortDicEvents//כל הארועים
                print("myitemx now \(itemx)")
                //30/11/2016", [<Bthere.allKindEventsForListDesign: 0x1701ffd00>]
                if let _:String = itemx.0  {
                    let eventdate:String = itemx.0
                    print("evvv \(eventdate)")
                }
            }
            for  itemx in sortDicBTHEREevent
            {
                // for event in sortDicEvents//כל הארועים
                print("myitemx now \(itemx)")
                //30/11/2016", [<Bthere.allKindEventsForListDesign: 0x1701ffd00>]
                if let _:String = itemx.0  {
                    let eventdate:String = itemx.0

                    if  let _:Date = getDateFromString(eventdate)  {
                        let newEVENTDATE:Date = getDateFromString(eventdate)
                        let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: newEVENTDATE)

                        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)


                        yearToday =  componentsCurrent.year!
                        monthToday = componentsCurrent.month!
                        dayToday = componentsCurrent.day!
                        print("bbbbdayToday \(dayToday)")
                        let yearEvent =  componentsEvent.year
                        let monthEvent = componentsEvent.month
                        let dayEvent = componentsEvent.day

                        if yearEvent == yearToday && monthEvent == monthToday && dayEvent == dayToday
                        {
                            // arrEventsCurrentDay.append(itemx)
                            hasEvent = true
                            for myx in itemx.1 {
                                if !PERFECTSENSE.contains(myx) {
                                    PERFECTSENSE.append(myx)
                                }
                            }
                        }

                    }
                }
            }
        }
        print("ce e in arie \(PERFECTSENSE.count)")
        isexpanded = false
        pointOneLast = CGPoint()
        pointOne = CGPoint()
        pointTwo = CGPoint()
        DAYEventstohours()
    }


    func DAYEventstohours()
    {
         var workerid = 0
        //we know we are in the same day so don't care anymore of datestring from arrEventsCurrentDay
        //clear all hours now
        //1.events for all day - have full hours and will be displayed above list
        //2.events in calendar with hours first in row
        //3.bthere with hours
        initALLSECTIONSFINAL()
        HOLLYDAYSSECTIONSFINAL = Array<allKindEventsForListDesign>()
        for  itemx in PERFECTSENSE
        {
            print(" aria  finala\(itemx.title)")

            //
            let calendar:Foundation.Calendar = Foundation.Calendar.current
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: itemx.dateEvent as Date)
            //           let yearEventz =  componentsEvent.year
            //           let monthEventz = componentsEvent.month
            let dayEventz = componentsEvent.day
            //               let componentsEventtoday = calendar.components([.Day, .Month, .Year], fromDate:  Global.sharedInstance.currDateSelected)
            //            let yearEventtoday =  componentsEventtoday.year
            //            let monthEventtoday = componentsEventtoday.month
            //            let dayEventtoday = componentsEventtoday.day


            print(" fromHour\(itemx.fromHour) tohour\(itemx.toHour)")
            /////1._iDayInWeek: -1,
            //            _nvServiceName: "",
            //            _nvComment: "",
            //            _iProviderUserId: 0,
            //            _iUserId: 0,
            print(" dayEventz\(dayEventz) dayToday\(dayToday)")
            if (itemx.fromHour == "00:00" && itemx.toHour == "23:59" && itemx.iProviderUserId == 0 &&  itemx.iUserId == 0 && itemx.iDayInWeek == -1 && itemx.nvComment != "BlockedBySupplier") {
                print("allday ")
                //\\add to above table list
                //    if  itemx.dateEvent == currentDate {
                //     if yearEventz == yearEventtoday && monthEventz == monthEventtoday && dayEventz == dayEventtoday {
                if  dayEventz == dayToday {
                    if !HOLLYDAYSSECTIONSFINAL.contains(itemx) {
                        HOLLYDAYSSECTIONSFINAL.append(itemx)
                    }
                }
            }
                //    }
                //  else
                //           /////2.
                //\\print ("itemx.iCoordinatedServiceId \(itemx.iCoordinatedServiceId)")
            else  if itemx.iCoordinatedServiceId == 0 { //&& itemx.fromHour != "00:00" && itemx.toHour != "23:59"{
                let strHMIN = hoursminutesfromString(hminutes: itemx.fromHour)
                let endHMIN = hoursminutesfromString(hminutes: itemx.toHour)
                let HST = strHMIN[0]
                let HEND = endHMIN[0]


                if HEND >= HST {
                    if HST == 0 {
                        ALLSECTIONSFINAL[0].1.append(itemx)

                    }  else { //     hour start != 0
                        for inthour in arrHoursInt {
                            if inthour == HST {
                                ALLSECTIONSFINAL[inthour].1.append(itemx)
                            }
                        }

                    }
                }

            }
                /////3.
            else  if itemx.iCoordinatedServiceId > 0 {
                //orders section

                if Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") != 0 {
                workerid = Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")
                print("day change idSupplierWorker \(Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker"))")
                }
                for ArwenEvenstar in PERFECTSENSE {
                    if itemx.fromHour == ArwenEvenstar.fromHour && itemx.toHour == ArwenEvenstar.toHour && itemx.title == ArwenEvenstar.title {
                        print("am gasit Arwen in LOTR")
                    }
                }
                //      let worker:Int = itemx.iProviderUserId
                print("day idSupplierWorker \(Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker"))")

                //NEWDEVELOP

                print("das even make left \(hoursminutesfromString(hminutes: itemx.fromHour))")
                print("das even make right \(hoursminutesfromString(hminutes: itemx.toHour))")


                let strHMIN = hoursminutesfromString(hminutes: itemx.fromHour)
                let endHMIN = hoursminutesfromString(hminutes: itemx.toHour)
                let HST = strHMIN[0]
                let HEND = endHMIN[0]
                let MINEND = endHMIN[1]

                if HEND >= HST {
                    if HST == 0 {

                        if itemx.nvComment == "BlockedBySupplier" {
                            var Myaddedhours:Array<Int>  = Array<Int>()
                            if HEND > 0 {
                                if MINEND == 0 {
                                    for i in 0..<HEND {
                                        if !Myaddedhours.contains(i) {
                                            Myaddedhours.append(i)
                                        }
                                    }
                                } else {
                                    for i in 0...HEND {
                                        if !Myaddedhours.contains(i) {
                                            Myaddedhours.append(i)
                                        }
                                    }
                                }
                            }
                            if Myaddedhours.count > 0 {
                                for inthour in arrHoursInt {
                                    for i in Myaddedhours {
                                        if  i == inthour  {
                                            if !ALLSECTIONSFINAL[inthour].1.contains(itemx) {
                                                ALLSECTIONSFINAL[inthour].1.append(itemx)
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            if itemx.iProviderUserId == workerid {
                                ALLSECTIONSFINAL[0].1.append(itemx)
                            }
                        }
                    }  else { //     hour start != 0
                        for inthour in arrHoursInt {
                            if inthour == HST {
                                if itemx.iProviderUserId == workerid {
                                    ALLSECTIONSFINAL[inthour].1.append(itemx)
                                }
                            }
                        }
                        if itemx.nvComment == "BlockedBySupplier" {
                            var Myaddedhours:Array<Int>  = Array<Int>()
                            if HEND > HST  {
                                if MINEND == 0 {
                                    for i in HST..<HEND {
                                        if !Myaddedhours.contains(i) {
                                            Myaddedhours.append(i)
                                        }
                                    }
                                } else {
                                    for i in HST...HEND {
                                        if !Myaddedhours.contains(i) {
                                            Myaddedhours.append(i)
                                        }
                                    }
                                }
                            }
                            if Myaddedhours.count > 0 {
                                for inthour in arrHoursInt {
                                    for i in Myaddedhours {
                                        if  i == inthour  {
                                            if !ALLSECTIONSFINAL[inthour].1.contains(itemx) {
                                                ALLSECTIONSFINAL[inthour].1.append(itemx)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }


        //END NEWDEVELOP


        print("ALLSECTIONSFINAL \(ALLSECTIONSFINAL) si count \(ALLSECTIONSFINAL.count)")
        ALLSECTIONSFINALFILTERED = ALLSECTIONSFINAL
        tblData.delegate = self
        tblData.dataSource = self
        tblData.separatorStyle = .none
        isexpanded = false
        pointOneLast = CGPoint()
        pointOne = CGPoint()
        pointTwo = CGPoint()
        // allcommonGroup()
        refreshControl.endRefreshing()
        self.tblData.reloadData()



        //\\print ("scrolling to bottom row \(numberOfRows)")
        let USERDEF = Global.sharedInstance.defaults
        if USERDEF.integer(forKey: "FORCEDAYOPEN") == 1 {

            let sectiontoscrool =  USERDEF.integer(forKey: "HOURTOOPEN") + 1 //because 0 is holiday
            let numberOfRows = self.tblData.numberOfRows(inSection: sectiontoscrool )
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: sectiontoscrool )
                self.tblData.scrollToRow(at: indexPath,
                                         at: UITableView.ScrollPosition.top, animated: true)
            } else {
                let indexPath = IndexPath(row: 0, section: sectiontoscrool )
                self.tblData.scrollToRow(at: indexPath,
                                         at: UITableView.ScrollPosition.top, animated: true)
            }
             USERDEF.setValue(0, forKey:"FORCEDAYOPEN")
             USERDEF.synchronize()
        } else {
            let numberOfRows = self.tblData.numberOfRows(inSection: 7)
            let indexPath = IndexPath(row: numberOfRows-1, section: 7)
            self.tblData.scrollToRow(at: indexPath,
                                     at: UITableView.ScrollPosition.top, animated: true)
        }

        //        self.carousel.setNeedsLayout()
        //                var scalingTransform : CGAffineTransform!
        //                scalingTransform = CGAffineTransformMakeScale(-1, 1)
        //              if Global.sharedInstance.rtl {
        //                    carousel.transform = scalingTransform
        //               }
        self.carousel.type = .linear
        self.carousel.delegate = self
        self.carousel.dataSource = self
        if self.arrayWorkers.count > 0 {
            if Global.sharedInstance.defaults.integer(forKey: "mustreloadprovider") == 1 {
                Global.sharedInstance.defaults.set(0, forKey: "mustreloadprovider")
                Global.sharedInstance.defaults.synchronize()
                refreshTable(self.refreshControl)
            } else {

                if Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") == -1 {

                    DispatchQueue.main.async(execute: { () -> Void in
                        self.carousel.scrollToItem(at: 0, animated: true)
                    })

                } else {
                    //get previous selected worker from array
                    var x:Int = 0
                    let delucru:NSMutableArray =  self.arrayWorkers
                    for item in delucru {
                        // if let _:NSDictionary = item as? NSDictionary {
                        if let _:User = item as? User {
                            let workerdic:User = item as! User
                            let diciuserid:Int = workerdic.iUserId
                            print("Global.sharedInstance.defaults.integerForKey idSupplierWorker \(Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker"))")
                            let iuseridselect:Int = Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")
                            if diciuserid == iuseridselect {
                                x = delucru.index(of: workerdic)
                                print("day am gasit worker selectat anterior \(diciuserid) la index \(x)")
                            }
                        }
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.carousel.scrollToItem(at: x, animated: true)

                    })
                }
            }
        //    self.carouselCurrentItemIndexDidChange(self.carousel)


        }

        //  let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        //  appDelegate.setHELPSCREENS()
        //  self.LOADHELPERS()
        if FROMPRINT == true {
            self.TRYPDFJUSTNOW(ALLSECTIONSFINALFILTERED)
            FROMPRINT = false
        }


    }
    func TRYPDFJUSTNOW(_ NEWARRAY:[(Int,Array<allKindEventsForListDesign>)]) {
        let render = UIPrintPageRenderer()
        var html = ""

        var adate:Date = Date()
        print("NEWARRAY \(NEWARRAY.count)")
        html = html + "<table style=\"width:100%; border-collapse: collapse;\">"
        let composeddatefinal = self.lblDay.text! + "," + self.lblDate.text!
        html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align: right; background-color: #f39371; color: #fff; width: 100%;\"> \(composeddatefinal)</td></tr>"
        if NEWARRAY.count > 0 {
            //maximum 20 rows per page
            //here is a header row with day name and date

            let numberofsections = self.tblData.numberOfSections
            for i in 1..<24 {

                var event:(Int,Array<allKindEventsForListDesign>)?
                if ALLSECTIONSFINALFILTERED[i].1.count > 0 {
                    event = ALLSECTIONSFINALFILTERED[i]
                    print(" this event \(ALLSECTIONSFINALFILTERED[i].1)")
                    if ALLSECTIONSFINALFILTERED[i].1.count > 0 {
                        let y = ALLSECTIONSFINALFILTERED[i].1.count
                        print("number of rows \(y ) ") //one is header
                        if y > 0 {
                            print("evvv \(event!.1.count)")
                            for z in 0..<y {
                                let hhours =  "\(event!.1[z ].fromHour) - \(event!.1[z].toHour)"
                                let clientname = event!.1[z ].ClientnvFullName
                                let servicename = event!.1[z].title
                                let composedstring = clientname + " - " + servicename
                                html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; width: 100%; \">    \(hhours)</td></tr>"
                                //row 2  second is customer name with service name
                                html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; width: 100%;border-bottom: 1px solid black;\">    \(composedstring)</td></tr>"
                                //  }
                            }
                        }
                    }
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
            //let writePath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("instagram.igo")
            let tempDataPath = (tempDocumentsDirectory as! NSString).appendingPathComponent(fileNAMEFINAL)
            pdfData.write( toFile: tempDataPath, atomically: true)
            print("open \(tempDataPath)")

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

                if let filePath = tempDataPath as? String

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


    //MARK: - ScrollView

    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //
    //        colDay.reloadData()
    //
    //    }
    //sync design
    @objc func showSync()
    {
        if btnSyncGoogelSupplier.isCecked == false
        {
            Global.sharedInstance.getEventsFromMyCalendar()
            btnSyncGoogelSupplier.isCecked = true
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true
            // colDay.reloadData()
            setEventsArray()
        }
        else
        {
            btnSyncGoogelSupplier.isCecked = false
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = false
            //colDay.reloadData()
            setEventsArray()
        }

    }

    func initEvents()
    {
        //getEventsFromMyCalendar
        Global.sharedInstance.setAllEventsArray()

        dicArrayEventsToShow.removeAll()

        dicBthereEvent.removeAll()
        dicArrayEventsToShow = Dictionary<String,Array<allKindEventsForListDesign>>()

        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy" //to do test with ---

        Global.sharedInstance.getEventsFromMyCalendar()

        //------------------אתחול המערכים להצגת הארועים בצורה ממויינת------------------------
        //  let dateToday = NSDate()


        //עובר על הארועים מהמכשיר
        for event in Global.sharedInstance.arrEvents
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
                _iCoordinatedServiceStatusType: 0,
                _nvPhone: "",
                _iSupplierId: 0
            )

            if dicArrayEventsToShow[dateFormatter.string(from: event.startDate)] != nil
            {
                print("xyearEvent \(yearEvent) xyearToday \(yearToday) xmonthEvent\(monthEvent) xmonthToday\(monthToday) xdayevent \(dayEvent) xdaytoday\(dayToday)")
                if yearEvent == yearToday && monthEvent == monthToday && dayEvent == dayToday
                {

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


                print(Global.sharedInstance.getStringFromDateString(event.cDate))
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
                    _chServiceColor: "",
                    _viewsforweek: [],
                    _iCoordinatedServiceStatusType: 1,
                    _nvPhone: "",
                    _iSupplierId: 0
                )
                print("xyearEvent \(yearEvent) xyearToday \(yearToday) xmonthEvent\(monthEvent) xmonthToday\(monthToday) xdayevent \(dayEvent) xdaytoday\(dayToday)")
                print(eventblock.getDic())
                if dicBthereEvent[dateFormatter.string(from: dateEvent)] != nil
                {
                    if yearEvent == yearToday && monthEvent == monthToday
                        //&& dayEvent == dayToday
                    {

                        dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventblock)
                    }
                }
                else
                {

                    dicBthereEvent[dateFormatter.string(from: dateEvent)] = Array<allKindEventsForListDesign>()
                    dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventblock)
                }

                if dicArrayEventsToShow[dateFormatter.string(from: dateEvent)] != nil
                {
                    if yearEvent == yearToday && monthEvent == monthToday
                        //&& dayEvent == dayToday
                    {

                        dicArrayEventsToShow[dateFormatter.string(from: dateEvent)]?.append(eventblock)
                    }
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

                var anyhow = 0
                if let xor:Int =  eventBthere.object(forKey: "iUserId") as? Int {
                    anyhow = xor
                }

                // var emi:NSDictionary = NSDictionary()
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
                var chServiceColor:String = ""
                if let _:String = eventBthere.object(forKey: "chServiceColor") as? String{
                    chServiceColor = eventBthere.object(forKey: "chServiceColor") as! String
                }

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
                let objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
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
                    _ARRAYiProviderUserId : ARRAYiProviderUserId,
                    _objProviderServiceDetails:objProviderServiceDetails,
                    _nvLogo: "",
                    _chServiceColor:chServiceColor,
                    _viewsforweek: [],
                    _iCoordinatedServiceStatusType: 1,
                    _nvPhone: nvPhone,
                    _iSupplierId: iSupplierId
                )
                print("nvServiceNametitle \(nvServiceName)")
                print("eventBtheree in days \(eventBtheree.getDic())")
                //\\print( "eventBthere.iProviderUserId \(iProviderUserId)  _iUserId: \(iUserId) si string start \(hourStart) si string end \(hourEnd)")
                //\\print( "yearToday \(yearToday)  monthToday \(monthToday) si dayToday \(dayToday) ")
                if dicBthereEvent[dateFormatter.string(from: dateEvent)] != nil
                {
                    if yearEvent == yearToday && monthEvent == monthToday
                        //&& dayEvent == dayToday
                    {

                        dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                    }
                }
                else
                {

                    dicBthereEvent[dateFormatter.string(from: dateEvent)] = Array<allKindEventsForListDesign>()
                    dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                }

                if dicArrayEventsToShow[dateFormatter.string(from: dateEvent)] != nil
                {
                    if yearEvent == yearToday && monthEvent == monthToday
                        //&& dayEvent == dayToday
                    {

                        dicArrayEventsToShow[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                    }
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
        for _ in sortDicEvents
        {
            sortDicEvents[i].1.sort(by: { $0.dateEvent.compare($1.dateEvent as Date) == ComparisonResult.orderedAscending })
            i += 1
        }

        i = 0
        for _ in sortDicBTHEREevent
        {
            sortDicBTHEREevent[i].1.sort(by: { $0.dateEvent.compare($1.dateEvent as Date) == ComparisonResult.orderedAscending })

            i += 1
        }

        //\\WHEN TABLE IS DONE
        //        reloadFromInitEvents = true
        //        tblData.reloadData()
        //        refreshControl.endRefreshing()
        generic.hideNativeActivityIndicator(self)
        setEventsArray()
    }
    func PREETYJSON_J(_ params:Dictionary<String,AnyObject>, pathofweb: String) {
        print("********************************* \(pathofweb) my data ********************\n")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print("\n********************************* END of \(pathofweb)  ********************\n")
    }
    func hidetoast(){
        view.hideToastActivity()
    }





    func numberOfItems(in carousel: iCarousel) -> Int {
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
        let  index:Int = carousel.currentItemIndex
        // if index > 0 {
        //  ALLSECTIONSFINALFILTERED = ALLSECTIONSFINAL
        var workerid:Int = 0
        if  self.arrayWorkers.count > 0 {
            if let _:User = self.arrayWorkers[index] as? User {
                let MYD:User = self.arrayWorkers[index] as! User

                if let _:Int =  MYD.iUserId
                {
                    workerid =  MYD.iUserId
                }

                print("workerid \(workerid) si \(index)")
                self.selectedWorker = true
                self.selectedWorkerID = index // ALLSECTIONSFINALFILTERED.append(inthour,Array<allKindEventsForListDesign>() )
                Global.sharedInstance.defaults.set(workerid, forKey: "idSupplierWorker")
                Global.sharedInstance.defaults.synchronize()
                print("day change idSupplierWorker \(Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker"))")
                ALLSECTIONSFINALFILTERED = []
                for inthour in arrHoursInt {
                    let onetoadd = (inthour,Array<allKindEventsForListDesign>())
                    ALLSECTIONSFINALFILTERED.append(onetoadd)

                }



            }
        }
        for item in ALLSECTIONSFINAL {
            var onemoretry:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
            let oraintreg:Int = item.0
            onemoretry = item.1
            for inthour in arrHoursInt {
                if inthour == oraintreg {
                    //  var whatifhave:allKindEventsForListDesign = allKindEventsForListDesign()
                    for itemx in onemoretry {
                        if itemx.iProviderUserId == workerid {
                            //true add
                            ALLSECTIONSFINALFILTERED[inthour].1.append(itemx)
                        } else {
                            //noadd no need ALLSECTIONSFINALFILTERED[inthour].1.append(whatifhave)

                        }
                    }
                }
            }
        }
        self.selectedWorker = true
        self.selectedWorkerID = index
        self.intSuppliersecondID = workerid
        GetBlockedHouresFromCalendar()

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
            //\\         itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 2.4 , height: 55))
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.carousel.frame.size.width / 2.4  , height: 55))
            itemView.image = UIImage(named: "")
            itemView.contentMode = .scaleAspectFill
            itemView.backgroundColor = UIColor.clear
            label = UILabel(frame: CGRect(x: itemView.frame.origin.x , y: itemView.frame.origin.y + 1, width:itemView.frame.size.width, height: itemView.frame.size.height - 6))
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.numberOfLines = 1
            label.textColor = Colors.sharedInstance.color4
            label.tag = 1
            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
            label.font = labelFont
            //        let mybluecircle:UIImageView = UIImageView()
            //        mybluecircle.frame = itemView.frame
            //        mybluecircle.frame.size = CGSize(width: itemView.frame.size.height/4, height: itemView.frame.size.height/4)
            //        mybluecircle.image = UIImage(named:"bluecircleon.png")
            //        mybluecircle.contentMode = .ScaleAspectFit
            //        mybluecircle.center.y = itemView.center.y
            //        mybluecircle.frame.origin.x = itemView.frame.origin.x + 12
            //        itemView.addSubview(mybluecircle)
            itemView.addSubview(label)
            //   itemView.bringSubviewToFront(mybluecircle)
        }

        // if index > 0 {
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
        //        let STRnvFullName:String = NSLocalizedString("NOT_CARE", comment: "")
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
    //magic thing filter mass array
    func hourisless (_ itemx: allKindEventsForListDesign) -> Bool {



        var islessh:Bool  = false
        var eventHour:Int = 0
        var eventMinutes:Int = 0
        //   if itemx.iCoordinatedServiceId > 0 { don't care all events has starting and ending hours and hollydays are in separated array
        if let a1:Character =  itemx.fromHour[itemx.fromHour.startIndex] {
            if a1 == "0" {
                //now get the real hour
                if let a2:Character =  itemx.fromHour[itemx.fromHour.characters.index(itemx.fromHour.startIndex, offsetBy: 1)]{
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
        // }
        let componentsToday = (calendar as NSCalendar).components([.hour, .minute], from: Date())
        let minutulacum = componentsToday.minute
        let oraacum = componentsToday.hour

        if eventHour < oraacum! {
            islessh = true
        } else  if eventHour == oraacum {
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
    //NEW DEVELOP


    //GET CLEAN HOUR MINUTES FOR EVENT
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
    //CLEAN AND FIXED 12.04.2019
    //1. GetSecondUserIdByFirstUserIdSeven()
    //± setupISupplierSecondID()
    //2. getServicesProviderForSupplierfunc()
    //±. processworkers -> carousel did change
    //3. GetBlockedHouresFromCalendar
    //4. GetCustomersOrdersForSupplier or GetCustomerOrdersForEmployeeId

    //1.
    func GetSecondUserIdByFirstUserIdSeven()  {
        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var y:Int = 0
        let dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        if y != 0
        {
            dicEMPLOYE["iUserId"] =  y as AnyObject
            print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
            if Reachability.isConnectedToNetwork() == false
            {
                self.setupISupplierSecondID(0)
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
                                        print("GetSecondUserIdByFirstUserId \(myInt)")
                                        if myInt > 0 {
                                            self.setupISupplierSecondID(myInt)
                                        }
                                    }
                            }
                        } else {
                            self.setupISupplierSecondID(0)
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.setupISupplierSecondID(0)
                })
            }
        }
    }
    //±
    func setupISupplierSecondID (_ ISupplierSecondID:Int){
        self.intSuppliersecondID = ISupplierSecondID
        print("self.intSuppliersecondID \(self.intSuppliersecondID)")
        getServicesProviderForSupplierfunc()

    }
    //2.
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
            self.processworkers(temparrayWorkers)
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
                            if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                                let u:User = User()
                                arrUsers = u.usersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                Global.sharedInstance.giveServicesArray = arrUsers
                                Global.sharedInstance.arrayGiveServicesKods = []
                                for  item in arrUsers{
                                    //\\print ("ce am \(item.description)")
                                    Global.sharedInstance.arrayGiveServicesKods.append(item.iUserId)//אחסון הקודים של נותני השרות לצורך השליחה לשרת כדי לקבל את השעות הפנויות
                                }
                                Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
                                Global.sharedInstance.dicGetFreeDaysForServiceProvider["lServiseProviderId"] = Global.sharedInstance.arrayGiveServicesKods as AnyObject
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
                                            temparrayWorkers.add(u)
                                        }
                                    }
                                    var y:Int = 0
                                    if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                                        let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                                        if let x:Int = a.value(forKey: "currentUserId") as? Int{
                                            y = x
                                        }
                                    }
                                    for u:User in arrUsers
                                    {
                                        if  self.EMPLOYEISMANAGER == false {
                                            if u.iUserId == Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") {
                                                temparrayWorkers.add(u)
                                            }
                                            print("u.iUserId \(u.iUserId) y \(y)")
                                        }
                                    }
                                    self.processworkers(temparrayWorkers)
                                }
                            }
                        }
                    }
                } else {
                    self.processworkers(temparrayWorkers)
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.processworkers(temparrayWorkers)
            })
        }
    }
    func processworkers (_ myWorkers: NSMutableArray) {
        self.arrayWorkers = myWorkers
        self.carousel.delegate = self
        self.carousel.dataSource = self
        Global.sharedInstance.CurrentProviderArrayWorkers = self.arrayWorkers
        print("Global.sharedInstance.CurrentProviderArrayWorkers \(Global.sharedInstance.CurrentProviderArrayWorkers)")
        if self.arrayWorkers.count > 0 {
            self.carousel.delegate = self
            self.carousel.dataSource = self

            if Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") == -1 {
                self.carousel.currentItemIndex = 0
                self.carousel.scrollToItem(at: 0, animated: true)


            } else {
                //get previous selected worker from array
                var x:Int = 0
                let delucru:NSMutableArray =  self.arrayWorkers
                for item in delucru {
                    if let _:User = item as? User {
                        let workerdic:User = item as! User
                        let diciuserid:Int = workerdic.iUserId
                        print("Global.sharedInstance.defaults.integerForKey idSupplierWorker \(Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker"))")
                        let iuseridselect:Int = Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")
                        if diciuserid == iuseridselect {
                            x = delucru.index(of: workerdic)
                            print(" am gasit worker selectat anterior \(diciuserid) la index \(x)")
                            ////NOW FILTER BY WORKER
                        }
                    }
                }
                self.carousel.currentItemIndex = x
                self.carousel.scrollToItem(at: x, animated: true)

            }
            if self.arrayWorkers.count > 0 {
                if self.arrayWorkers.count > 1 {
                    self.carousel.type = .linear
                } else {
                    self.carousel.type = .linear
                    self.carousel.isUserInteractionEnabled = false
                }
            }
            self.carousel.setNeedsLayout()

            self.carouselCurrentItemIndexDidChange(self.carousel) //this will process from now  ALL     get blocked and orders
        }
    }
    //3
    func GetBlockedHouresFromCalendar() {
        self.BlockHouresObjArray =  Array<BlockHouresObj>()
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var dateComponents = DateComponents()
        dateComponents.year = iFilterByYear
        dateComponents.month = iFilterByMonth
        dateComponents.day = 1
        let STARTDATE = self.calendar.date(from: dateComponents)
        let componentsend:NSDateComponents = self.calendar.dateComponents([.year, .month], from: STARTDATE!) as NSDateComponents
        componentsend.month += 1
        componentsend.day = 1
        componentsend.day -= 1
        let ENDDATE = self.calendar.date(from: componentsend as DateComponents)!
        dicSearch["iProviderUserId"] = self.intSuppliersecondID as AnyObject
        dicSearch["nvFromDate"] = Global.sharedInstance.convertNSDateToString(STARTDATE!) as AnyObject
        dicSearch["nvToDate"] =  Global.sharedInstance.convertNSDateToString(ENDDATE) as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            if self.EMPLOYEISMANAGER == true {
                self.GetCustomersOrdersForSupplier()
            } else {
                //is employe non manager
                self.GetCustomerOrdersForEmployeeId()
            }
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
                }
                for xdobj in self.BlockHouresObjArray {
                    print(xdobj.getDic())
                }
                self.generic.hideNativeActivityIndicator(self)
                if self.EMPLOYEISMANAGER == true {
                    self.GetCustomersOrdersForSupplier()
                } else {
                    //is employe non manager
                    self.GetCustomerOrdersForEmployeeId()
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if self.EMPLOYEISMANAGER == true {
                    self.GetCustomersOrdersForSupplier()
                } else {
                    //is employe non manager
                    self.GetCustomerOrdersForEmployeeId()
                }
            })
        }
    }
    func GetCustomersOrdersForSupplier()
    {
        fixProviderID()
    }
    //FOR NON MANAGER GetCustomersOrdersByDateForEmployeeId(int iUserId, DateTime dtDateStart, DateTime dtDateEnd)
    func GetCustomerOrdersForEmployeeId()
    {
        fixproviderID2()
    }
    func fixProviderID() {

        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if dicUserId["currentUserId"] as! Int != 0
            {
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                api.sharedInstance.GetSupplierIdByEmployeeId(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                        {
                            let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                            print("sup id e ok ? " + myInt.description)
                            if myInt == 0 {

                            } else {
                                Global.sharedInstance.providerID = myInt
                                Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails = myInt

                            }
                        }
                    }
                    self.afterfix1()
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.afterfix1()
                })
            }
        }
    }
    func afterfix1() {


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
        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
        //        dic["iFilterByMonth"] = 0 as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject
        dic["iFilterByMonthEnd"] = iFilterByMonthEnd as AnyObject
        dic["iFilterByYearEnd"] = iFilterByYearEnd as AnyObject
        //\\print ("iFilterByMonth \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd)")
        //        dic["iFilterByMonth"] = 0
        //        dic["iFilterByYear"] = 0
        var newarray:NSMutableArray = NSMutableArray()
        var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>() //empty first
        print("Global.sharedInstance.providerID  \(Global.sharedInstance.providerID) ")
        dic["iSupplierId"] = providerID as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
        }
        else
        {
            api.sharedInstance.GetCustomersOrdersForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
                    {
                        let ps:OrderDetailsObj = OrderDetailsObj()
                        ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                        print("GetCustomersOrdersForSupplier response")
                        for obj:OrderDetailsObj in ordersOfClientsArray
                        {
                            print("orders obj: \(obj.getDic())")

                        }
                    }
                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                        let REZULTATE:NSArray = RESPONSEOBJECT["Result"] as! NSArray
                         newarray = REZULTATE.mutableCopy() as! NSMutableArray
                        self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
            })
        }
    }
    ////GetCustomersOrdersForSupplier(int iUserId, int iSupplierId, int iFilterByMonth, int iFilterByYear, int iFilterByMonthEnd, int iFilterByYearEnd)

    func processMYARRAY (_ mycustomerorder: NSMutableArray , globalcustarray: Array<OrderDetailsObj>) {
        let deadaugat:NSMutableArray = mycustomerorder
        for item in deadaugat {
            if !self.myArray.contains(item) {
                self.myArray.add(item)
            }
        }
        var onearray:Array<OrderDetailsObj> = Array<OrderDetailsObj>()
        for item in globalcustarray {
            if !onearray.contains(item) {
                if  item.nvComment  == "BlockedBySupplier" {
                    item.title = "BlockedBySupplier"
                }
                onearray.append(item)

            }
        }
        Global.sharedInstance.ordersOfClientsArray = []
        Global.sharedInstance.ordersOfClientsArray = onearray // globalcustarray

        print("self.myArray.count FIRST\(self.myArray.count) ordersOfClientsArray \(onearray.count) ")

        if self.myArray.count == 0 {

            self.view.makeToast(message: "NO_APPOINMENTS_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })
        } else {

            print("ok appoi")
        }
        initEvents()
    }

    func fixproviderID2() {
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if dicUserId["currentUserId"] as! Int != 0
            {
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                api.sharedInstance.GetSupplierIdByEmployeeId(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                        {
                            let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                            print("sup id e ok ? " + myInt.description)
                            if myInt == 0 {

                            } else {
                                Global.sharedInstance.providerID = myInt
                                Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails = myInt

                            }
                        }
                    }
                    self.afterfix2()
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.afterfix2()
                })
            }
        }

    }
    func afterfix2() {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        //JMODE in order to get customer's appoinments for current employe and not manager
        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject
        dic["iFilterByMonthEnd"] = iFilterByMonthEnd as AnyObject
        dic["iFilterByYearEnd"] = iFilterByYearEnd as AnyObject
        var newarray:NSMutableArray = NSMutableArray()
        var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>() //empty first
        if Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") > 0 {
            dic["iUserId"] = Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") as AnyObject
        }
        if Reachability.isConnectedToNetwork() == false
        {
            self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
        }
        else
        {
            api.sharedInstance.GetCustomerOrdersForEmployeeId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
                    {
                        let ps:OrderDetailsObj = OrderDetailsObj()

                        ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    }
                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {

                        let REZULTATE:NSArray = RESPONSEOBJECT["Result"] as! NSArray
                        newarray = REZULTATE.mutableCopy() as! NSMutableArray
                        self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
                    }
                }

            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
            })
        }
    }


}

extension Array {

    func filterDuplicates(_ includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
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


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
