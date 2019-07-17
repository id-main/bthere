//
//  dayClientForAppointment12ViewController.swift
//  Bthere
//
//  Created by User on 4.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
protocol CellShowAlertDelegate {
    func showalertx()
}
// יומן ספק שהלקוח רואה - תצוגת יום
class dayClientForAppointment12ViewController: UIViewController,setDateDelegate,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource,iCarouselDataSource,iCarouselDelegate,CellShowAlertDelegate{
    //MARK: - Properties JMODE START
    var HOLLYDAYSSECTIONSFINAL:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
    var bIsAvailableForNewCustomer = 0
    var iHoursForPreCancelServiceByCustomer = 0
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
    @IBOutlet var carousel: iCarousel!
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
        //       if self.isfromSPECIALSUPPLIER == false {
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
        self.getProviderServicesForSupplierFunctoback()
        //        } else {
        //            Global.sharedInstance.whichReveal = true
        //            let frontviewcontroller:UINavigationController? = UINavigationController()
        //            let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        //            let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
        //            isfromSPECIALSUPPLIER = false
        //            Global.sharedInstance.isProvider = true
        //            frontviewcontroller!.pushViewController(viewCon, animated: false)
        //            //initialize REAR View Controller- it is the LEFT hand menu.
        //            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        //            let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        //            let mainRevealController = SWRevealViewController()
        //            mainRevealController.frontViewController = frontviewcontroller
        //            mainRevealController.rearViewController = rearViewController
        //            let window :UIWindow = UIApplication.shared.keyWindow!
        //            window.rootViewController = mainRevealController
        //        }
    }
    //end JMODE
    var pointOneLast:CGPoint = CGPoint()
    var pointOne:CGPoint = CGPoint()
    var pointTwo:CGPoint = CGPoint()
    var fIsBig = false
    var firstViewInFreeHour:Int = -1//הטג של הויו הראשון בשעה פנויה, עליו נציג את השעות
    var selectedCellIndexPath: IndexPath?
    var currentIndexPath:IndexPath?
    var hightCell:CGFloat = 0
    var hightViewBlue:CGFloat = 0//גובה של הוי הצבוע שמראה על התור הפנוי
    var hightViewClear:CGFloat = 0
    var minute:Int = 0
    var minute1:Int = 0
    let pinchRecognizer = UIPinchGestureRecognizer()
    // indicates that the pinch is in progress
    var pinchInProgress = false


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
        //הקודם ולא הבא
        print("go back \(currentDate)")
        Global.sharedInstance.freeHoursForCurrentDay = []
        hasEvent = false

        if Date() > currentDate   {
            print("no more meetings in the past")
            self.view.makeToast(message: "DAY_PASSED".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })

        } else {
            currentDate =  Calendar.sharedInstance.reduceDay(currentDate)
            let USERDEF = UserDefaults.standard
            var weekstoshowandlimit:Int = 0
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



            let flags = NSCalendar.Unit.weekOfYear
            let components = (calendar as NSCalendar).components(flags, from: Date(), to: currentDate, options: [])
            if components.weekOfYear! >= weekstoshowandlimit {
                print("no more show:")
                Global.sharedInstance.dateFreeDays = []
                print("Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")
                Global.sharedInstance.fromHourArray = []
                Global.sharedInstance.endHourArray = []
                Global.sharedInstance.dateFreeDays = []
                Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
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
            } else {
                //            iMonth = monthToday
                //            iYear = yearToday
                //            var isFirst:Bool = false
                //            if dayToday == 1 {
                //                isFirst = true
                //            }
                //
                //            if isFirst == true { //we know month must be reloaded
                //                iDay = 1
                //                if iMonth  < 12  && iMonth != 1{
                //                    iMonth = monthToday - 1
                //                } else {
                //                    iMonth = 12
                //                    iYear = yearToday - 1
                //                }
                //
                //                iFilterByMonth = iMonth
                //                iFilterByYear = iYear
                //
                //            }
                // getFreeDaysForServiceProvider(true, NONEED: true)
                GetFreeTimesForServiceProviderByDaysOrHoures()
            }





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

            //כדי שיציג לכל יום את השעות הפנויות שלו ולא לפי היום הקודם
            setDateClick(currentDate)
            setDate()
            //  colDay.reloadData()



            //JMODE PLUS


        }
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

        let components = (calendar as NSCalendar).components([.year, .month], from: currentDate)

        let startOfMonth = calendar.date(from: components)!
        let endOfMonth = (calendar as NSCalendar).date(byAdding: comps2, to: startOfMonth, options: [])!
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
        print("weekstoshowandlimit \(weekstoshowandlimit)")
        //compare date


        let flags = NSCalendar.Unit.weekOfYear
        let componentsZ = (calendar as NSCalendar).components(flags, from: Date(), to: currentDate, options: [])
        if componentsZ.weekOfYear! >= weekstoshowandlimit {
            print("no more show:")


            Global.sharedInstance.getFreeDaysForService = []
            Global.sharedInstance.dateFreeDays = []
            print("Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")
            Global.sharedInstance.fromHourArray = []
            Global.sharedInstance.endHourArray = []
            Global.sharedInstance.dateFreeDays = []
            Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
            Global.sharedInstance.arrayGiveServicesKods = []
            Global.sharedInstance.dateFreeDays = []
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
                        let indexPath = IndexPath(row:0, section: indexsection!)
                        self.FULLDAYTABLEVIEW.scrollToRow(at: indexPath,
                                                          at: UITableView.ScrollPosition.top, animated: true)
                    }
                }
            }


            self.GetCustomerOrders()
        } else {
            GetFreeTimesForServiceProviderByDaysOrHoures()

            //        if daytoask1 == daytoask && monthtoask1 == monthtoask && yeartoask == yeartoask1 {
            //            // if currentDate == endOfMonth {
            //            //we must reload month again
            //
            //            iDay =  1
            //            //iMonth = monthToday + 1
            //            if iMonth == 12 {
            //                iMonth = 1
            //                iYear = yearToday + 1
            //
            //            } else if iMonth < 12 {
            //                iMonth = monthToday + 1
            //            }
            //            monthchanged = 1
            //            iDay = 1
            //            iFilterByMonth = iMonth
            //            iFilterByYear = iYear
            //       //     getFreeDaysForServiceProvider(true, NONEED: true)
            //
            //                }
        }





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

        //כדי שיציג לכל יום את השעות הפנויות שלו ולא לפי היום הקודם
        setDate()
        setDateClick(currentDate)
        //   colDay.reloadData()




        //הבא ולא הקודם


    }

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
        print("self.arrayWorkers.count \(Global.sharedInstance.arrayWorkers.count)")
        print("array workers give count: \( Global.sharedInstance.giveServicesArray.count)")
        
        return  Global.sharedInstance.giveServicesArray.count
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    //JMODE table -> REPLACES COLLECTIONVIEW
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 32
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {

        return 24 +  1 //hollydays

    }
    //    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    //    {
    //       return self.arrHours[section]
    //    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell:LineHoursTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LineHoursTableViewCell")as!LineHoursTableViewCell
        if section != 0 {
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            // cell.backgroundColor = UIColor.redColor()
            if let _:String = arrHours[section - 1]  {
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
            // expint = ALLSECTIONSFINALFILTERED[section - 1].1.count + 1
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
        //\\        print("si indepathsection \(indexPath.section) si row \(indexPath.row)")
        if indexPath.section != 0 {
            let cell: ClientMakeAppoinmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ClientMakeAppoinmentTableViewCell") as! ClientMakeAppoinmentTableViewCell

            cell.backgroundColor = UIColor.clear
            cell.delegateRegister = Global.sharedInstance.calendarAppointment
            cell.DelegateAlert = self
            cell.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
            var WHATEVENTISNOW:allKindEventsForListDesign = allKindEventsForListDesign()
            for item in ALLSECTIONSFINAL {
                if item.0 == indexPath.section - 1 && item.1.count > 0 {
                    if ALLSECTIONSFINAL.indices.contains(indexPath.section - 1) {
                        if ALLSECTIONSFINAL[indexPath.section - 1].1.indices.contains(indexPath.row) {
                    WHATEVENTISNOW =  ALLSECTIONSFINAL[indexPath.section - 1].1[indexPath.row]
                    cell.setEventData(WHATEVENTISNOW)
                        }
                    }
                }
            }

            return cell
        } else {
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

            return 35
        }

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
        let mys = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")
        print("FINDisfromSPECIALiCustomerUserId \(mys)")
        monthchanged = 0
        //    FULLDAYTABLEVIEW.separatorStyle = .none
        FULLDAYTABLEVIEW.delegate = self
        print("useridglobal \(isfromSPECIALiCustomerUserId)")
        print("e din suplier special \(isfromSPECIALSUPPLIER)")
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let amonth = components.month
        let ayear = components.year
        let aday = components.day
        print("day ENGAGE  \(amonth) \(ayear) \(aday)")
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

        Global.sharedInstance.dayDesigncalendarAppointment12 = self
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
//        }
        print("idSupplierWorker in day: \(Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int)")
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

        GetFreeTimesForServiceProviderByDaysOrHoures()
        self.btnequal(btnNext)
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
                //   getFreeDaysForServiceProvider(false,NONEED: true)
               // GetFreeTimesForServiceProviderByDaysOrHoures()
                self.btnequal(btnNext)
                print("workerid \(workerid) si \(index)")
            }
        }
    }

    //end JMODE


    //MARK: - Initial

    func initDate(_ date:Date)
    {
        currentDate = date
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("\(Global.sharedInstance.giveServicesArray.count)")
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
        print("day ENGAGE  \(amonth) \(ayear) \(aday)")
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

        Global.sharedInstance.dayDesigncalendarAppointment12 = self
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
        carousel.delegate = self
        carousel.dataSource = self
        
        print("idSupplierWorker in day: \(Global.sharedInstance.defaults.object(forKey: "idSupplierWorker") as! Int)")
        
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
        GetProviderSettingsForCalendarmanagement()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            self.GoogleAnalyticsSendEvent(x:13)
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
        Global.sharedInstance.freeHoursForCurrentDay = []
        for i in 0 ..< Global.sharedInstance.getFreeDaysForService.count
        {
            let dateDt = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate)
            //היום שיש בו שעות פנויות
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateClickStr = dateFormatter.string(from: date)

            dateFormatter.timeZone = TimeZone(identifier: "Asia/Jerusalem")
            let dateFreeDayStr = dateFormatter.string(from: dateDt)
            if dateClickStr == dateFreeDayStr
            {
                Global.sharedInstance.freeHoursForCurrentDay.append(Global.sharedInstance.getFreeDaysForService[i])
            }
        }
        initEvents()
        // colDay.reloadData()

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
    //MARK: - Set  Event  Func
    //func that set device events of day
    //        func setEventsArray()
    //        {
    //            arrEventsCurrentDay = []
    //            for item in Global.sharedInstance.eventList
    //            {
    //                let event = item as! EKEvent
    //
    //                let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
    //
    //                let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: event.startDate)
    //
    //                yearToday =  componentsCurrent.year
    //                monthToday = componentsCurrent.month
    //                dayToday = componentsCurrent.day
    //
    //                let yearEvent =  componentsEvent.year
    //                let monthEvent = componentsEvent.month
    //                let dayEvent = componentsEvent.day
    //
    //                if yearEvent == yearToday && monthEvent == monthToday && dayEvent == dayToday
    //                {
    //                    arrEventsCurrentDay.append(event)
    //                    hasEvent = true
    //                }
    //            }
    //    }
    //    //func that set bthere events of day
    //
    //    func setBThereEventsArray()
    //    {
    //        arrBThereEventsCurrentDay = []
    //        for item in Global.sharedInstance.ordersOfClientsArray
    //        {
    //            let btEvent = item
    //
    //            let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
    //
    //            let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: btEvent.dtDateOrder)
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
    //                arrBThereEventsCurrentDay.append(btEvent)
    //                hasEvent = true
    //            }
    //        }
    //
    //
    //    }

    var isShowFreeDay:Int = 0//flag to know if there isnt any free hour in that hour

    //MARK: - Collection View

    //        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
    //
    //
    //            var scalingTransform : CGAffineTransform!
    //            scalingTransform = CGAffineTransformMakeScale(-1, 1)
    //
    //            isShowFreeDay = 0
    //
    //            let cell:EventsWeek12ViewsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventsWeekViews12",forIndexPath: indexPath) as! EventsWeek12ViewsCollectionViewCell
    //
    //            cell.arrBThereEventsCurrentDay = arrBThereEventsCurrentDay
    //            cell.indexHourOfDay = indexPath.row/2
    //
    //            currentIndexPath = indexPath
    //
    //            cell.delegate = Global.sharedInstance.calendarAppointment
    //            cell.delegateRegister = Global.sharedInstance.calendarAppointment
    //
    //            cell.viewTopEvent.backgroundColor = UIColor.clearColor()
    //            cell.viewBottomEvent.backgroundColor = UIColor.clearColor()
    //            cell.lblHoursTop.text = ""
    //            cell.lblDescTop.text = ""
    //            cell.lblHoursBottom.text = ""
    //            cell.lblDescBottom.text = ""
    //
    //            cell.view0to5.backgroundColor = UIColor.clearColor()
    //            cell.view5to10.backgroundColor = UIColor.clearColor()
    //            cell.view10to15.backgroundColor = UIColor.clearColor()
    //            cell.view15to20.backgroundColor = UIColor.clearColor()
    //            cell.view20to25.backgroundColor = UIColor.clearColor()
    //            cell.view25to30.backgroundColor = UIColor.clearColor()
    //            cell.view30to35.backgroundColor = UIColor.clearColor()
    //            cell.view35to40.backgroundColor = UIColor.clearColor()
    //            cell.view40to45.backgroundColor = UIColor.clearColor()
    //            cell.view45to50.backgroundColor = UIColor.clearColor()
    //            cell.view50to55.backgroundColor = UIColor.clearColor()
    //            cell.view55to60.backgroundColor = UIColor.clearColor()
    //
    //            cell.view0to5.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view5to10.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view10to15.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view15to20.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view20to25.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view25to30.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view30to35.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view35to40.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view40to45.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view45to50.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view50to55.subviews.forEach({ $0.removeFromSuperview() })
    //            cell.view55to60.subviews.forEach({ $0.removeFromSuperview() })
    //
    //            cell.lblHours1.text = ""
    //            cell.lblHours2.text = ""
    //            cell.lblHours3.text = ""
    //            cell.lblHours4.text = ""
    //            cell.lblHours5.text = ""
    //            cell.lblHours6.text = ""
    //            cell.lblHours7.text = ""
    //            cell.lblHours8.text = ""
    //            cell.lblHours9.text = ""
    //            cell.lblHours10.text = ""
    //            cell.lblHours11.text = ""
    //            cell.lblHours12.text = ""
    //            cell.lblHours1.backgroundColor = UIColor.clearColor()
    //            cell.lblHours2.backgroundColor = UIColor.clearColor()
    //            cell.lblHours3.backgroundColor = UIColor.clearColor()
    //            cell.lblHours4.backgroundColor = UIColor.clearColor()
    //            cell.lblHours5.backgroundColor = UIColor.clearColor()
    //            cell.lblHours6.backgroundColor = UIColor.clearColor()
    //            cell.lblHours7.backgroundColor = UIColor.clearColor()
    //            cell.lblHours8.backgroundColor = UIColor.clearColor()
    //            cell.lblHours9.backgroundColor = UIColor.clearColor()
    //            cell.lblHours10.backgroundColor = UIColor.clearColor()
    //            cell.lblHours11.backgroundColor = UIColor.clearColor()
    //            cell.lblHours12.backgroundColor = UIColor.clearColor()
    //            cell.SERVICESTARTHOUR.text = ""
    //            cell.SERVICESTARTHOUR.hidden = true
    //          //\\  cell.backgroundColor =  Colors.sharedInstance.color4
    //
    //
    //            //in cellForItemAtIndexPath
    //            //        var scalingTransform : CGAffineTransform!
    //            //        scalingTransform = CGAffineTransformMakeScale(-1, 1);
    //            if Global.sharedInstance.rtl
    //            {
    //                cell.transform = scalingTransform
    //            }
    //
    //
    //
    //            let cell1:HoursCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Hours",forIndexPath: indexPath) as! HoursCollectionViewCell
    //
    //            cell1.lblHours.text = ""
    //            if Global.sharedInstance.rtl
    //            {
    //            cell1.transform = scalingTransform
    //            }
    //            //        if language == "he"
    //            //        {
    //            //            cell.transform = scalingTransform
    //            //            cell1.transform = scalingTransform
    //            //        }
    //
    //            if indexPath.row % 2 == 0//השורה הראשונה
    //            {
    //                cell1.setDisplayData(arrHours[indexPath.row / 2])
    //                return cell1
    //            }
    //            else
    //            {
    //                var index:Int = 0
    //
    //                //מעבר על השעות הפנויות ליום זה והצגתן
    //
    //                for item in Global.sharedInstance.freeHoursForCurrentDay{
    //
    //                    firstViewInFreeHour = -1
    //
    //                    let hourStart = Global.sharedInstance.getStringFromDateString(item.objProviderHour.nvFromHour)
    //
    //                    let hourEnd = Global.sharedInstance.getStringFromDateString(item.objProviderHour.nvToHour)
    //
    //                    let componentsStart = calendar.components([.Hour, .Minute], fromDate: hourStart)
    //
    //                    let componentsEnd = calendar.components([.Hour, .Minute], fromDate: hourEnd)
    //
    //                    let hourS = componentsStart.hour
    //                    let minuteS = componentsStart.minute
    //
    //                    let hourE = componentsEnd.hour
    //                    let minuteE = componentsEnd.minute
    //
    //                    var hourS_Show:String = hourS.description
    //                    var hourE_Show:String = hourE.description
    //                    var minuteS_Show:String = minuteS.description
    //                    var minuteE_Show:String = minuteE.description
    //
    //                    if hourS < 10
    //                    {
    //                        hourS_Show = "0\(hourS)"
    //                    }
    //                    if hourE < 10
    //                    {
    //                        hourE_Show = "0\(hourE)"
    //                    }
    //                    if minuteS < 10
    //                    {
    //                        minuteS_Show = "0\(minuteS)"
    //                    }
    //                    if minuteE < 10
    //                    {
    //                        minuteE_Show = "0\(minuteE)"
    //                    }
    //                   //   print("aaall h \(hourS_Show):\(minuteS_Show)")
    //
    //                    if arrHoursInt[indexPath.row / 2] == hourS//This is a whole row fill
    //                    {
    //
    //                        if hourS == hourE//probally exception
    //                        {
    //                            showView(cell.view0to5, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view5to10, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view10to15, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view15to20, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view20to25, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view25to30, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view30to35, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view35to40, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view40to45, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view45to50, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view50to55, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //                            showView(cell.view55to60, from: minuteS, to: minuteE, param: 0, index: index, cell: cell)
    //
    //                        }
    //                        else//fil of a row
    //                        {
    //                            showView(cell.view0to5, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view5to10, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view10to15, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view15to20, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view20to25, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view25to30, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view30to35, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view35to40, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view40to45, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view45to50, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view50to55, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //                            showView(cell.view55to60, from: minuteS, to: minuteE, param: 1, index: index, cell: cell)
    //
    //                        }
    //                        isShowFreeDay = 1
    //                    }
    //                    else if arrHoursInt[indexPath.row / 2] > hourS && arrHoursInt[indexPath.row / 2] < hourE//השעה המוצגת היא באמצע הארוע
    //                    {
    //                        cell.view0to5.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view0to5.alpha = 0.5
    //                        addRightLeftBorder(cell.view0to5)
    //                        cell.lblHours1.tag = index
    //
    //                        cell.view5to10.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view5to10.alpha = 0.5
    //                        addRightLeftBorder(cell.view5to10)
    //                        cell.lblHours2.tag = index
    //
    //                        cell.view10to15.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view10to15.alpha = 0.5
    //                        addRightLeftBorder(cell.view10to15)
    //                        cell.lblHours3.tag = index
    //
    //                        cell.view15to20.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view15to20.alpha = 0.5
    //                        addRightLeftBorder(cell.view15to20)
    //                        cell.lblHours4.tag = index
    //
    //                        cell.view20to25.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view20to25.alpha = 0.5
    //                        addRightLeftBorder(cell.view20to25)
    //                        cell.lblHours5.tag = index
    //
    //                        cell.view25to30.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view25to30.alpha = 0.5
    //                        addRightLeftBorder(cell.view25to30)
    //                        cell.lblHours6.tag = index
    //
    //                        cell.view30to35.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view30to35.alpha = 0.5
    //                        addRightLeftBorder(cell.view30to35)
    //                        cell.lblHours7.tag = index
    //
    //                        cell.view35to40.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view35to40.alpha = 0.5
    //                        addRightLeftBorder(cell.view35to40)
    //                        cell.lblHours8.tag = index
    //
    //                        cell.view40to45.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view40to45.alpha = 0.5
    //                        addRightLeftBorder(cell.view40to45)
    //                        cell.lblHours9.tag = index
    //
    //                        cell.view45to50.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view45to50.alpha = 0.5
    //                        addRightLeftBorder(cell.view45to50)
    //                        cell.lblHours10.tag = index
    //
    //                        cell.view50to55.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view50to55.alpha = 0.5
    //                        addRightLeftBorder(cell.view50to55)
    //                        cell.lblHours11.tag = index
    //
    //                        cell.view55to60.backgroundColor = Colors.sharedInstance.color4
    //                        cell.view55to60.alpha = 0.5
    //                        addRightLeftBorder(cell.view55to60)
    //                        cell.lblHours12.tag = index
    //
    //                        isShowFreeDay = 1
    //                    }
    //                    else if arrHoursInt[indexPath.row / 2] == hourE//השעה המוצגת שווה לשעת הסיום
    //                    {
    //                        showView(cell.view0to5, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view5to10, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view10to15, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view15to20, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view20to25, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view25to30, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view30to35, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view35to40, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view40to45, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view45to50, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view50to55, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        showView(cell.view55to60, from: 0, to: minuteE, param: 2, index: index, cell: cell)
    //                        isShowFreeDay = 1
    //                    }
    //                    if isShowFreeDay != 0 && firstViewInFreeHour != -1  //&& fIsBig == true//selectedCellIndexPath == indexPath
    //                    {
    //                        selectedCellIndexPath = nil
    //
    //                    cell.showLblHours(firstViewInFreeHour,hourS_Show: "\(hourS_Show):\(minuteS_Show)",hourE_Show:  "\(hourE_Show):\(minuteE_Show)")
    //                    }
    //                    if fIsBig == true {
    //                        cell.SERVICESTARTHOUR.hidden = false
    //                        if arrHoursInt[indexPath.row / 2] == hourS {
    //                            cell.SERVICESTARTHOUR.text = "\(hourS_Show):\(minuteS_Show)"
    //                            break
    //                        }
    //
    //                    }
    //                    index += 1
    //                }
    //
    //                 //מעבר על הארועים של ביזר והצגתם
    //                for item in arrBThereEventsCurrentDay {
    //
    //                    let hourStart = Global.sharedInstance.getStringFromDateString(item.nvFromHour)
    //
    //                    let hourEnd = Global.sharedInstance.getStringFromDateString(item.nvToHour)
    //
    //                    let componentsStart = calendar.components([.Hour, .Minute], fromDate: hourStart)
    //
    //                    let componentsEnd = calendar.components([.Hour, .Minute], fromDate: hourEnd)
    //
    //                    let hourS = componentsStart.hour
    //                    let minuteS = componentsStart.minute
    //
    //                    let hourE = componentsEnd.hour
    //                    let minuteE = componentsEnd.minute
    //
    //                    var hourS_Show:String = hourS.description
    //                    var hourE_Show:String = hourE.description
    //                    var minuteS_Show:String = minuteS.description
    //                    var minuteE_Show:String = minuteE.description
    //
    //                    if hourS < 10
    //                    {
    //                        hourS_Show = "0\(hourS)"
    //                    }
    //                    if hourE < 10
    //                    {
    //                        hourE_Show = "0\(hourE)"
    //                    }
    //                    if minuteS < 10
    //                    {
    //                        minuteS_Show = "0\(minuteS)"
    //                    }
    //                    if minuteE < 10
    //                    {
    //                        minuteE_Show = "0\(minuteE)"
    //                    }
    //
    //                    if arrHoursInt[indexPath.row / 2] == hourS
    //                    {
    //                        if minuteS > 0// שעת התחלה גדולה מ-0
    //                        {
    //                            cell.setDisplayDataDay("", descTop: "", hourBottom: "\(hourS_Show):\(minuteS_Show) - \(hourE_Show):\(minuteE_Show)", descBottom: "\(item.objProviderServiceDetail.nvServiceName) \(item.nvSupplierName)")
    //
    //
    //                            if hourE == hourS//אם שעת סיום זהה לשעת התחלה
    //                            {
    //                                minute = Int(minuteE) - Int(minuteS)//קבלת הזמן של הארוע
    //                                hightViewBlue = ((CGFloat(minute) / 60) * hightCell)
    //                                minute1 = Int(minuteS)
    //                                hightViewClear = ((CGFloat(minute1) / 60) * hightCell)
    //                                cell.hourStart = hourS_Show + ":" + minuteS_Show
    //                                cell.hourEnd = hourE_Show
    //                                cell.setDisplayViewsEvents(false, heightTop: (CGFloat(minute1) / 60), heightButtom: (CGFloat(minute) / 60), eventKind: 1)
    //                                //לעשות שקוף לטופ לצבוע את הבטם
    //                            }
    //
    //                            else
    //                            {
    //                                minute = 60 - Int(minuteS)
    //                                hightViewBlue = ((CGFloat(minute) / 60) *
    //                                    hightCell)
    //                                minute1 = Int(minuteS)
    //                                hightViewClear = ((CGFloat(minute1) / 60) * hightCell)
    //                                cell.hourStart = hourS_Show + ":" + minuteS_Show
    //                                cell.hourEnd = hourE_Show
    //                                cell.setDisplayViewsEvents(false,heightTop: (CGFloat(minute1) / 60), heightButtom:
    //                                    (CGFloat(minute) / 60), eventKind: 1)
    //                                //לעשות שקוף לטופ לצבוע את הבטם
    //                            }
    //
    //                        }
    //                        else//שעת התחלה 00
    //                        {
    //                            cell.setDisplayDataDay("\(hourS_Show):\(minuteS_Show) - \(hourE_Show):\(minuteE_Show)", descTop: "\(item.objProviderServiceDetail.nvServiceName) \(item.nvSupplierName)", hourBottom: "", descBottom: "")
    //
    //                            if hourE == hourS//אם שעת סיום זהה לשעת התחלה
    //                            {
    //                                minute = Int(minuteE)
    //                                hightViewBlue = ((CGFloat(minute) / 60) * hightCell)
    //
    //                                minute1 = 60 - Int(minuteE)
    //                                hightViewClear = ((CGFloat(minute1) / 60) * hightCell)
    //                                cell.hourStart = hourS_Show + ":" + minuteS_Show
    //                                cell.hourEnd = hourE_Show
    //                                cell.setDisplayViewsEvents(true, heightTop: (CGFloat(minute) / 60), heightButtom: (CGFloat(minute1) / 60), eventKind: 1)
    //                                //לצבוע את הטופ
    //                            }
    //                            else
    //                            {
    //                                hightViewBlue = hightCell
    //                                hightViewClear = 0
    //                                cell.setDisplayViewsEvents(true, heightTop: 1, heightButtom: 0, eventKind: 1)
    //                                //לצבוע את הטופ
    //                            }
    //                        }
    //
    //                    }
    //                    else if arrHoursInt[indexPath.row / 2] > hourS && arrHoursInt[indexPath.row / 2] < hourE//אמצע הארוע
    //                    {
    //
    //                        cell.setDisplayDataDay("", descTop: "", hourBottom: "", descBottom: "")
    //
    //                        hightViewBlue = hightCell
    //                        hightViewClear = 0
    // //                       cell.setDisplayViewsEvents(true, heightTop: 1, heightButtom: 0, eventKind: 1)
    //                        //לצבוע את הטופ
    //                    }
    //
    //                    else if arrHoursInt[indexPath.row / 2] == hourE//סיום הארוע
    //                    {
    //                        cell.setDisplayDataDay( "", descTop: "", hourBottom: "", descBottom: "")
    //
    //                        minute = Int(minuteE)
    //                        hightViewBlue = ((CGFloat(minute) / 60) * hightCell)
    //                        minute1 = 60 - Int(minuteE)
    //                        hightViewClear = ((CGFloat(minute1) / 60) * hightCell)
    ////                        if minuteE == 0
    ////                        {
    ////                            cell.setDisplayViewsEvents(false, heightTop: (CGFloat(minute) / 60), heightButtom: (CGFloat(minute1) / 60), eventKind: 1)
    ////                        }
    ////                        else
    ////                        {
    ////                            cell.setDisplayViewsEvents(true, heightTop: (CGFloat(minute) / 60), heightButtom: (CGFloat(minute1) / 60), eventKind: 1)
    ////                        }
    //
    //                        //לצבוע את הטופ
    //                    }
    //
    //                }
    //
    //                if hasEvent == true && Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true
    //                {
    //                     //מעבר על הארועים האישיים מהיומן של המכשיר ליום זה והצגתם
    //                    for eve in arrEventsCurrentDay
    //                    {
    //                        let componentsStart = calendar.components([.Hour, .Minute], fromDate: eve.startDate)
    //
    //                        let componentsEnd = calendar.components([.Hour, .Minute], fromDate: eve.endDate)
    //
    //                        let hourS = componentsStart.hour
    //                        let minuteS = componentsStart.minute
    //
    //                        let hourE = componentsEnd.hour
    //                        let minuteE = componentsEnd.minute
    //
    //                        var hourS_Show:String = hourS.description
    //                        var hourE_Show:String = hourE.description
    //                        var minuteS_Show:String = minuteS.description
    //                        var minuteE_Show:String = minuteE.description
    //
    //                        if hourS < 10
    //                        {
    //                            hourS_Show = "0\(hourS)"
    //                        }
    //                        if hourE < 10
    //                        {
    //                            hourE_Show = "0\(hourE)"
    //                        }
    //                        if minuteS < 10
    //                        {
    //                            minuteS_Show = "0\(minuteS)"
    //                        }
    //                        if minuteE < 10
    //                        {
    //                            minuteE_Show = "0\(minuteE)"
    //                        }
    //
    //                        if arrHoursInt[indexPath.row / 2] == hourS
    //                        {
    //                            if minuteS > 0// שעת התחלה גדולה מ-0
    //                            {
    //                                cell.setDisplayDataDay("", descTop: "", hourBottom: "\(hourS_Show):\(minuteS_Show) - \(hourE_Show):\(minuteE_Show)", descBottom: eve.title)
    //
    //                                if hourE == hourS//אם שעת סיום זהה לשעת התחלה
    //                                {
    //                                    minute = Int(minuteE) - Int(minuteS)//קבלת הזמן של הארוע
    //                                    hightViewBlue = ((CGFloat(minute) / 60) * hightCell)
    //                                    minute1 = Int(minuteS)
    //                                    hightViewClear = ((CGFloat(minute1) / 60) * hightCell)
    //                                    cell.hourStart = hourS_Show + ":" + minuteS_Show
    //                                    cell.hourEnd = hourE_Show
    //                                    cell.setDisplayViewsEvents(false, heightTop: (CGFloat(minute1) / 60), heightButtom: (CGFloat(minute) / 60), eventKind: 0)
    //                                    //לעשות שקוף לטופ לצבוע את הבטם
    //                                }
    //                                else
    //                                {
    //                                    minute = 60 - Int(minuteS)
    //                                    hightViewBlue = ((CGFloat(minute) / 60) *
    //                                        hightCell)
    //                                    minute1 = Int(minuteS)
    //                                    hightViewClear = ((CGFloat(minute1) / 60) * hightCell)
    //                                    cell.hourStart = hourS_Show + ":" + minuteS_Show
    //                                    cell.hourEnd = hourE_Show
    //                                    cell.setDisplayViewsEvents(false,heightTop: (CGFloat(minute1) / 60), heightButtom:
    //                                        (CGFloat(minute) / 60), eventKind: 0)
    //                                    //לעשות שקוף לטופ לצבוע את הבטם
    //                                }
    //                            }
    //                            else//שעת התחלה 00
    //                            {
    //                                cell.setDisplayDataDay("\(hourS_Show):\(minuteS_Show) - \(hourE_Show):\(minuteE_Show)", descTop: eve.title, hourBottom: "", descBottom: "")
    //
    //                                if hourE == hourS//אם שעת סיום זהה לשעת התחלה
    //                                {
    //                                    minute = Int(minuteE)
    //                                    hightViewBlue = ((CGFloat(minute) / 60) * hightCell)
    //
    //                                    minute1 = 60 - Int(minuteE)
    //                                    hightViewClear = ((CGFloat(minute1) / 60) * hightCell)
    //                                    cell.hourStart = hourS_Show + ":" + minuteS_Show
    //                                    cell.hourEnd = hourE_Show
    //                                    cell.setDisplayViewsEvents(true, heightTop: (CGFloat(minute) / 60), heightButtom: (CGFloat(minute1) / 60), eventKind: 0)
    //
    //                                    //לצבוע את הטופ
    //                                }
    //                                else
    //                                {
    //                                    hightViewBlue = hightCell
    //                                    hightViewClear = 0
    //                                    cell.setDisplayViewsEvents(true, heightTop: 1, heightButtom: 0, eventKind: 0)
    //                                    //לצבוע את הטופ
    //                                }
    //                            }
    //
    //                        }
    //                        else if arrHoursInt[indexPath.row / 2] > hourS && arrHoursInt[indexPath.row / 2] < hourE//אמצע הארוע
    //                        {
    //
    //                            cell.setDisplayDataDay("", descTop: "", hourBottom: "", descBottom: "")
    //
    //                            hightViewBlue = hightCell
    //                            hightViewClear = 0
    ////                            cell.setDisplayViewsEvents(true, heightTop: 1, heightButtom: 0, eventKind: 0)
    //                            //לצבוע את הטופ
    //                        }
    //
    //                        else if arrHoursInt[indexPath.row / 2] == hourE//סיום הארוע
    //                        {
    //                            cell.setDisplayDataDay( "", descTop: "", hourBottom: "", descBottom: "")
    //
    //                            minute = Int(minuteE)
    //                            hightViewBlue = ((CGFloat(minute) / 60) * hightCell)
    //                            minute1 = 60 - Int(minuteE)
    //                            hightViewClear = ((CGFloat(minute1) / 60) * hightCell)
    ////                            if minuteE == 0
    ////                            {
    ////                                cell.setDisplayViewsEvents(false, heightTop: (CGFloat(minute) / 60), heightButtom: (CGFloat(minute1) / 60), eventKind: 0)
    ////                            }
    ////                            else
    ////                            {
    ////                                cell.setDisplayViewsEvents(true, heightTop: (CGFloat(minute) / 60), heightButtom: (CGFloat(minute1) / 60), eventKind: 0)
    ////                            }
    //
    //                            //לצבוע את הטופ
    //                        }
    //
    //                    }
    //                }
    //                else if isShowFreeDay == 0
    //                {
    //
    //
    //                    cell.setDisplayDataDay("", descTop: "", hourBottom: "", descBottom: "")
    //                    return cell
    //                }
    //
    //
    //            }
    //
    //
    //            return cell
    //        }
    //
    //        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //            return 48//2*24
    //        }
    //
    //        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    //
    //            if indexPath.row % 2 == 0//העמודה הראשונה
    //            {
    //                if fIsBig == true//selectedCellIndexPath == indexPath
    //                {
    //                    return CGSize(width: view.frame.size.width / 8, height:  (view.frame.size.width / 8) + 100)
    //                }
    //                return CGSize(width: view.frame.size.width / 8, height:  view.frame.size.width / 8)
    //            }
    //            if fIsBig == true//selectedCellIndexPath == indexPath
    //            {
    //                //selectedCellIndexPath = nil
    //                return CGSize(width: view.frame.size.width - (view.frame.size.width / 8), height:  (view.frame.size.width / 8) + 100)
    //
    //            }
    //            return CGSize(width: view.frame.size.width - (view.frame.size.width / 8), height:  view.frame.size.width / 8)
    //        }
    //
    //        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    //        {
    //
    ////            selectedCellIndexPath = indexPath
    ////            colDay.reloadData()
    //
    //
    //        }
    //
    ////        func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    //            if (touch.view!.isDescendantOfView(colDay)) {
    //
    //                return false
    //            }
    //            return true
    //        }







    //        func dismissKeyboard() {
    //
    //            self.view.endEditing(true)
    //        }
    override func viewWillLayoutSubviews() {
        if Global.sharedInstance.isSyncWithGoogleCalendarAppointment == true{
            btnSuny.isCecked = true
        }else{
            btnSuny.isCecked = false
        }

    }
    //MARK: - ScrollView

    //פונקציה הבודקת האם לצבוע את הויו אותו היא מקבלת
    //מקבלת:
    //view: הויו אותו יש לצבוע
    //from,to:לשם הבדיקה האם נמצא בטווח של שעה פנויה - האם לצבוע
    //param: כאשר הוא 0 נבדוק האם נמצא בטווח של הדקות,
    //כאשר הוא 1 נבדוק האם גדול מ from
    //וכאשר הוא 2 נבדוק האם קטן מ to
    //index: המיקום של השעה הפנויה במערך


    func showView(_ view:UIView,from:Int,to:Int,param:Int, index:Int,cell:EventsWeek12ViewsCollectionViewCell)
    {
        // In an event of less than an hour, check whether these minutes at the end of the event
        if param == 0//בארוע של פחות משעה, בדיקה האם דקות אלו בתוך הארוע
        {
            if view.tag >= from && view.tag <= to
            {
                view.backgroundColor = Colors.sharedInstance.color4
                addRightLeftBorder(view)
                view.alpha = 0.5

                saveFreeHourForView(view.tag, index: index, cell: cell)

                if firstViewInFreeHour == -1
                {
                    firstViewInFreeHour = view.tag
                }
            }
        }
        else if param == 1//בשעת התחלה שונה מהסיום, בדיקה אם הדקות גדולות מהדקות של שעת ההתחלה
            // Start time is different from the end, check if the minutes are larger than the start time minutes
        {
            if view.tag >= from
            {
                view.backgroundColor = Colors.sharedInstance.color4
                addRightLeftBorder(view)
                view.alpha = 0.5

                saveFreeHourForView(view.tag, index: index, cell: cell)

                if firstViewInFreeHour == -1
                {
                    firstViewInFreeHour = view.tag
                }
            }
        }
        else if param == 2//בשעת סיום בדיקה אם הדקות קטנות מדקות הסיום   // When testing is finished, the minutes are less than the end minutes
        {
            if view.tag <= to
            {//10-15
                view.backgroundColor = Colors.sharedInstance.color4
                addRightLeftBorder(view)
                if view.tag == to || (view.tag < to && (view.tag + 5) > to)
                {
                    addBottomBorder(view)
                }

                view.alpha = 0.5
                saveFreeHourForView(view.tag, index: index, cell: cell)
            }
        }
    }


    //פונקציה זו שומרת בטג של הלייבל (1 מתוך 12) את המיקום במערך של השעה הפנויה בה הוא נמצא.
    //הפונקציה מקבלת טג של הויו כדי לזהות את הליבל וכן אינדקס של המערך.
    func saveFreeHourForView(_ tag:Int,index:Int, cell:EventsWeek12ViewsCollectionViewCell)
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

    //    func handlePinch(recognizer: UIPinchGestureRecognizer) {
    //        if recognizer.state == .Began {
    //
    //             pointOne = recognizer.locationOfTouch(0, inView: colDay)
    //             pointTwo = recognizer.locationOfTouch(1, inView: colDay)
    //
    //            if pointOneLast == CGPoint()
    //            {
    //                fIsBig = true
    //                pointOneLast = pointOne
    //            }
    //            else
    //            {
    //                if pointOneLast.y < pointOne.y
    //                {
    //                   fIsBig = false
    //                }
    //                else
    //                {
    //                    fIsBig = true
    //                }
    //                pointOneLast = pointOne
    //            }
    //            //selectedCellIndexPath = indexPath
    //            colDay.reloadData()
    //        }
    //        if recognizer.state == .Changed
    //            && pinchInProgress
    //            && recognizer.numberOfTouches() == 2 {
    //            // pinchChanged(recognizer)
    //              print("changed")
    //        }
    //        if recognizer.state == .Ended {
    //            // pinchEnded(recognizer)
    //              print("ended")
    //        }
    //    }
    //change design if device kimd is small of iphone 6
    func checkDevice()
    {
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{


            lblDay.font = UIFont(name: lblDay.font.fontName, size: 20)
            lblDate.font = UIFont(name: lblDate.font.fontName, size: 13)

        }

    }
    //MARK: borders
    //הוספת מסגרת לאירוע

    func addRightLeftBorder(_ myView:UIView)
    {
        let leftBorder = UIView()
        leftBorder.frame = CGRect(x: 0, y: 0, width: 3, height: myView.frame.size.height)
        leftBorder.backgroundColor = Colors.sharedInstance.color6
        myView.addSubview(leftBorder)

        let rightBorder = UIView()
        rightBorder.frame = CGRect(x: view.frame.size.width - (view.frame.size.width / 8) - 3, y: 0, width: 3, height: myView.frame.size.height)
        rightBorder.backgroundColor = Colors.sharedInstance.color6
        myView.addSubview(rightBorder)
    }

    func addBottomBorder(_ myView:UIView)
    {
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = Colors.sharedInstance.color6
        bottomBorder.frame = CGRect(x: 0, y: myView.frame.size.height - 3, width: view.frame.size.width - (view.frame.size.width / 8), height: 3)
        myView.addSubview(bottomBorder)

    }
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
          //\\  print("item \(item.getDic())")
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

        for item in Global.sharedInstance.freeHoursForCurrentDay {
            /*
             var iProviderUserId:Array<Int> = []
             var dtDate:String = ""
             var objProviderHour:ProviderHourObj = ProviderHourObj() var nvFromHour:String = ""
             var nvToHour:String = ""
             */
            print("freehoursatall \(item.getDic())")
            var dateEventw:Date = Date()


            //\\     print("test event \(eventBthere.description)")

            // let dateEvent = eventBthere.dtDateOrder
            if let ORDERDATE:String =  item.dtDate as? String
            {
                dateEventw = Global.sharedInstance.getStringFromDateString(ORDERDATE)
                print("STRdtDatefree\(dateEventw)")
            }
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
            //    var objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
            // var nvLogo:String = ""
            //NOW COMPOSE POSSIBLE ORDER keep in mind it is important to store iDayInWeek as 1000 !!! IN ORDER TO DIFFERENTIATE FROM REGULAR EVENTS
            let objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
            let eventFree:allKindEventsForListDesign = allKindEventsForListDesign(
                _dateEvent: dateEventw,
                _title: "",
                _fromHour: "\(hourS_Show):\(minuteS_Show)",
                _toHour: "\(hourE_Show):\(minuteE_Show)",
                _tag: 0,
                _nvAddress: "",
                _nvSupplierName: "",
                _iDayInWeek: 1000,
                _nvServiceName: "",
                _nvComment: "",
                _iProviderUserId: 0,
                _iUserId: 0,
                _ClientnvFullName: "",
                _iCoordinatedServiceId: 0,
                _iCancelallCoordinatedServiceIds:[],
                _iCancelalliUserId: [],
                _isCancelGroup: false,
                _specialDate: item.dtDate,
                _ARRAYiProviderUserId:item.iProviderUserId,
                _objProviderServiceDetails:objProviderServiceDetails,
                _nvLogo: "",
                _chServiceColor: "",
                _viewsforweek: [],
                _iCoordinatedServiceStatusType:  0,
                _nvPhone: "",
                _iSupplierId: 0
            )
            print("minune mare \(eventFree.getDic())")



            let eventdateday:Date = eventFree.dateEvent as Date
            let componentsCurrent = (self.calendar as NSCalendar).components([.day, .month, .year], from: Date())
            let monthtoask = componentsCurrent.month
            let yeartoask = componentsCurrent.year
            let daytoask = componentsCurrent.day
            let componentsCurrentev = (self.calendar as NSCalendar).components([.day, .month, .year], from: eventdateday)
            let monthtoaskv = componentsCurrentev.month
            let yeartoaskv = componentsCurrentev.year
            let daytoaskv = componentsCurrentev.day

            if (monthtoask == monthtoaskv && yeartoask == yeartoaskv && daytoask == daytoaskv && eventFree.iDayInWeek == 1000 && self.hourislessProviderHour(eventFree) == true )  {
                //do not add past hours in today
                print("no need to add")
            } else {
                if dicArrayEventsToShow[dateFormatter.string(from: eventFree.dateEvent as Date)] != nil
                {
                    dicArrayEventsToShow[dateFormatter.string(from: eventFree.dateEvent as Date)]?.append(eventFree)
                    hasEvent = true

                }
                else
                {

                    dicArrayEventsToShow[dateFormatter.string(from: eventFree.dateEvent as Date)] = Array<allKindEventsForListDesign>()
                    dicArrayEventsToShow[dateFormatter.string(from: eventFree.dateEvent as Date)]?.append(eventFree)
                }
            }

        }
        
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

            /*
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
             _ARRAYiProviderUserId : ARRAYiProviderUserId
             )

             */



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
                    ///// _title: "\(nvServiceName),\(eventBthere.nvSupplierName)",
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
                //\\print( "eventBthere.iProviderUserId \(iProviderUserId)  _iUserId: \(iUserId) si string start \(hourStart) si string end \(hourEnd)")
                //\\print( "yearToday \(yearToday)  monthToday \(monthToday) si dayToday \(dayToday) ")
                //remove past hours events


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



        DispatchQueue.main.async(execute: {
            self.FULLDAYTABLEVIEW.reloadData()
        })
        
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
        self.FULLDAYTABLEVIEW.isUserInteractionEnabled = false
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            self.FULLDAYTABLEVIEW.isUserInteractionEnabled = true
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
                          //\\      print("item to test \(item.getDic())")
                                if !Global.sharedInstance.ordersOfClientsArray.contains(item) {
                                    Global.sharedInstance.ordersOfClientsArray.append(item)
                                }
                            }
                        }
                        print("day Global.sharedInstance.ordersOfClientsArray.count \(Global.sharedInstance.ordersOfClientsArray.count)")
                    }
                }
                self.FULLDAYTABLEVIEW.isUserInteractionEnabled = true
                self.updatefornextbtn(self.bIsNext,ISNONEED:self.ISNONEED )
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.FULLDAYTABLEVIEW.isUserInteractionEnabled = true
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }

    func updatefornextbtn(_ bIsNext:Bool,ISNONEED:Bool){
        print("wwwwww Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")

        //        let COMPOSEDONEDATE:String = String(iYear) + "-" + String(iMonth) + "-" + String(iDay) + " 08:00:00  +0000"
        //        let dateFormatterx = DateFormatter()
        //        dateFormatterx.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //        let dates = dateFormatterx.date(from: COMPOSEDONEDATE)
        //        Calendar.sharedInstance.carrentDate  =  dates!
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

//    func carouselDidEndDecelerating(_ carousel: iCarousel)
//    {
//
//        let  index:Int = carousel.currentItemIndex
//
//        var workerid:Int = 0
//        if  Global.sharedInstance.giveServicesArray.count > 0 {
//            if let _:User = Global.sharedInstance.giveServicesArray[index]  {
//                let MYD:User = Global.sharedInstance.giveServicesArray[index]
//
//                if let _:Int =  MYD.iUserId
//                {
//                    workerid =  MYD.iUserId
//                    Global.sharedInstance.defaults.set(workerid, forKey: "idSupplierWorker")
//                    print("idSupplierWorker after picked: \(Global.sharedInstance.defaults.object(forKey: "idSupplierWorker"))")
//                    Global.sharedInstance.defaults.synchronize()
//                    if workerid > 0 {
//                        Global.sharedInstance.idWorker = workerid
//                        Global.sharedInstance.indexRowForIdGiveService = workerid
//                    } else {
//                        Global.sharedInstance.idWorker = -1
//                        Global.sharedInstance.indexRowForIdGiveService = -1
//                    }
//                }
//
//                let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
//                let monthtoask = componentsCurrent.month
//                let yeartoask = componentsCurrent.year
//                let daytoask = componentsCurrent.day
//                if iMonth == monthtoask && iYear == yeartoask {
//                    iDay = daytoask!
//                    Calendar.sharedInstance.carrentDate = currentDate
//                    print("workerid \(workerid) si \(index)")
//                    // getFreeDaysForServiceProvider(false, NONEED: true)
//                    GetFreeTimesForServiceProviderByDaysOrHoures()
//                    btnequal(btnNext)
//                } else {
//                    if iMonth < monthtoask! || iYear < yeartoask! {
//                        //   getFreeDaysForServiceProvider(true, NONEED: false)
//                        GetFreeTimesForServiceProviderByDaysOrHoures()
//                        btnequal(btnNext)
//                    } else {
//                        //  getFreeDaysForServiceProvider(true, NONEED: true)
//
//                        GetFreeTimesForServiceProviderByDaysOrHoures()
//                        btnequal(btnNext)
//                    }
//                }
//
//            }
//        }
//
//        if  Global.sharedInstance.giveServicesArray.count > 1 {
//            for itemView in carousel.visibleItemViews {
//                for subview in (itemView as AnyObject).subviews as [UIView] {
//                    if let labelView = subview as? UILabel {
//                        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 16)
//                        labelView.font = labelFont
//                        let attr = NSMutableAttributedString(string: labelView.text!)
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
//                        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
//                        let mylblString:String = labelView.text!
//                        let underlineAttributedString = NSAttributedString(string:mylblString, attributes: underlineAttribute)
//                        labelView.attributedText = underlineAttributedString
//
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
//                        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
//                        let mylblString:String = labelView.text!
//                        let underlineAttributedString = NSAttributedString(string:mylblString, attributes: underlineAttribute)
//                        labelView.attributedText = underlineAttributedString
//                        //     labelView.minimumScaleFactor = 0.5
//                        //    labelView.adjustsFontSizeToFitWidth = true
//                    }
//                }
//            }
//        }
//        //\\ setEventBthereInMonth()
//        self.carousel.setNeedsLayout()
//
//    }
    
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
                     print("day item did change idSupplierWorker after picked: \(Global.sharedInstance.defaults.object(forKey: "idSupplierWorker"))")
                    if workerid > 0 {
                        Global.sharedInstance.idWorker = workerid
                        Global.sharedInstance.indexRowForIdGiveService = workerid
                    } else {
                        Global.sharedInstance.idWorker = -1
                        Global.sharedInstance.indexRowForIdGiveService = -1
                    }
                }

                let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
                let monthtoask = componentsCurrent.month
                let yeartoask = componentsCurrent.year
                let daytoask = componentsCurrent.day
                if iMonth == monthtoask && iYear == yeartoask {
                    iDay = daytoask!
                    Calendar.sharedInstance.carrentDate = currentDate
                    print("workerid \(workerid) si \(index)")
                    // getFreeDaysForServiceProvider(false, NONEED: true)
                    GetFreeTimesForServiceProviderByDaysOrHoures()
                    btnequal(btnNext)
                } else {
                    if iMonth < monthtoask! || iYear < yeartoask! {
                        //   getFreeDaysForServiceProvider(true, NONEED: false)
                        GetFreeTimesForServiceProviderByDaysOrHoures()
                        btnequal(btnNext)
                    } else {
                        //  getFreeDaysForServiceProvider(true, NONEED: true)

                        GetFreeTimesForServiceProviderByDaysOrHoures()
                        btnequal(btnNext)
                    }
                }

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

        let componentsCurrents = (calendar as NSCalendar).components([.day, .month, .year], from: endOfMonth)
        let monthtoask = componentsCurrents.month
        let yeartoask = componentsCurrents.year
        let daytoask = componentsCurrents.day



        print("go next \(dateFormatterx.string(from: endOfMonth)) currentDate \(currentDate) ------ > \(daytoask1 ) dd  \(daytoask ) mm\( monthtoask1 )mm \( monthtoask )yy\( yeartoask )yy\( yeartoask1)" ) // 2015-11-30
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
        }        //compare date
        Global.sharedInstance.currDateSelected = currentDate
        let flags = NSCalendar.Unit.weekOfYear
        let componentsZ = (calendar as NSCalendar).components(flags, from: Date(), to: currentDate, options: [])
        if componentsZ.weekOfYear! >= weekstoshowandlimit {
            print("no more show:")


            Global.sharedInstance.getFreeDaysForService = []
            Global.sharedInstance.dateFreeDays = []
            print("Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")
            Global.sharedInstance.fromHourArray = []
            Global.sharedInstance.endHourArray = []
            Global.sharedInstance.dateFreeDays = []
            Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
            Global.sharedInstance.arrayGiveServicesKods = []
            Global.sharedInstance.dateFreeDays = []
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
        } else {


            if daytoask1 == daytoask && monthtoask1 == monthtoask && yeartoask == yeartoask1 {

                iDay = 1
                iFilterByMonth = iMonth
                iFilterByYear = iYear
                //JMODE NOW    getFreeDaysForServiceProvider(true, NONEED: true)
                GetFreeTimesForServiceProviderByDaysOrHoures()
            }
        }



        //   currentDate =  Calendar.sharedInstance.addDay(currentDate)

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
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)

        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!

        //כדי שיציג לכל יום את השעות הפנויות שלו ולא לפי היום הקודם
        setDate()
        setDateClick(currentDate)
        //   colDay.reloadData()




        //הבא ולא הקודם


    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    //magic thing filter mass array
    func hourislessProviderHour (_ itemx: allKindEventsForListDesign) -> Bool {


        print("ce analizeaza \(itemx.getDic())")

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
    //GetFreeDaysForServiceProvider is replaced by call to GetFreeTimesForServiceProviderByDaysOrHours
    func GetFreeTimesForServiceProviderByDaysOrHoures() {
        /*
         {
         "lServiseProviderId" : [
         7697
         ],
         "nvFromDate" : "2018-02-1",
         "lProviderServiceId" : [
         3004
         ],
         "nvToDate": "2018-02-1",
         "bFreeDaysOnly": true,
         "bIsNext" : true
         }
         */
        //one day read only
        var getFreeDaysForServiceCLEAN:Array<providerFreeDaysObj> =  Array<providerFreeDaysObj>()
        var objectstoremove:Array<providerFreeDaysObj> =  Array<providerFreeDaysObj>()
        let dateFormatterx = DateFormatter()
        dateFormatterx.dateFormat = "yyyy-MM-dd"
        let date1String = dateFormatterx.string(from: currentDate)
        print("cdate1String \(date1String)")
        Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
        Global.sharedInstance.arrayGiveServicesKods = []
        Global.sharedInstance.dateFreeDays = []
        Global.sharedInstance.fromHourArray = []
        Global.sharedInstance.endHourArray = []
        Global.sharedInstance.getFreeDaysForService = []
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
        self.FULLDAYTABLEVIEW.isUserInteractionEnabled = false

        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            self.FULLDAYTABLEVIEW.isUserInteractionEnabled = true

//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            //new 14-02-2018
            Global.sharedInstance.dicGetFreeDaysForServiceProvider["nvFromDate"] = date1String as AnyObject
            Global.sharedInstance.dicGetFreeDaysForServiceProvider["nvToDate"] = date1String as AnyObject
            Global.sharedInstance.dicGetFreeDaysForServiceProvider["bFreeDaysOnly"] = false as AnyObject //to get one day not month with free days

       //     print("Global.sharedInstance.dicGetFreeDaysForServiceProvider \(self.PREETYJSON_J(Global.sharedInstance.dicGetFreeDaysForServiceProvider, pathofweb: "cHOSEW"))")
            api.sharedInstance.GetFreeTimesForServiceProviderByDaysOrHoures(Global.sharedInstance.dicGetFreeDaysForServiceProvider, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//
                self.FULLDAYTABLEVIEW.isUserInteractionEnabled = true
                 print(responseObject)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
//                            self.generic.hideNativeActivityIndicator(self)
                             self.generic.hideNativeActivityIndicator(self)
                            self.FULLDAYTABLEVIEW.isUserInteractionEnabled = true
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
                            print("Global.sharedInstance.getFreeDaysForService.count \(Global.sharedInstance.getFreeDaysForService.count)")
                            //firstclean
                            print("getFreeDaysForServiceCLEAN before clean \(getFreeDaysForServiceCLEAN.count)")
                            for i in 0 ..< Global.sharedInstance.getFreeDaysForService.count{
                                let dateDt = Calendar.sharedInstance.addDay(Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate))
                                let provider:providerFreeDaysObj = Global.sharedInstance.getFreeDaysForService[i]
                                let hourStart = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvFromHour)
                                let componentsStart = (self.calendar as NSCalendar).components([.hour, .minute], from: hourStart)
                                let hourS = componentsStart.hour
                                let minuteS = componentsStart.minute
                                var hourS_Show:String = hourS!.description
                                var minuteS_Show:String = minuteS!.description

                                if hourS! < 10
                                {
                                    hourS_Show = "0" + hourS_Show
                                }

                                if minuteS! < 10
                                {
                                    minuteS_Show = "0" +   minuteS_Show
                                }


                                let composedHHMM:String = hourS_Show + ":" + minuteS_Show
                                if Global.sharedInstance.ordersOfClientsTemporaryArray.count > 0 {
                                    for item in  Global.sharedInstance.ordersOfClientsTemporaryArray {
                                        let datecompare = item.dtDateOrder
                                        let dateitemDt = Calendar.sharedInstance.addDay(datecompare)
                                        let hours = item.nvFromHour
                                        let a:Date = dateDt
                                        let b:Date = dateitemDt
                                        var sameday:Bool = false
                                        switch a.compare(b) {
                                        case .orderedSame :
                                            sameday = true
                                        default:
                                            sameday = false
                                        }
                                        if (sameday == true  && composedHHMM == hours) {
                                            //exclude from list
                                            print("item.dtDateOrder \(dateitemDt) dateDt \(dateDt)  hours \(hours) composedHHMM \(composedHHMM)" )

                                            if !objectstoremove.contains(provider) {
                                                objectstoremove.append(provider)
                                            }

                                        } else {

                                            if !getFreeDaysForServiceCLEAN.contains(provider) {
                                                getFreeDaysForServiceCLEAN.append(provider)
                                            }
                                        }
                                    }
                                } else {

                                    if !getFreeDaysForServiceCLEAN.contains(provider) {
                                        getFreeDaysForServiceCLEAN.append(provider)
                                    }
                                }
                            }
                            if objectstoremove.count > 0 {
                                for iremove in objectstoremove {
                                    if getFreeDaysForServiceCLEAN.contains(iremove) {
                                        print("gotcha")
                                        let indextoremove = getFreeDaysForServiceCLEAN.index(of: iremove)
                                        getFreeDaysForServiceCLEAN.remove(at: indextoremove!)
                                    }
                                }
                            }
                            Global.sharedInstance.getFreeDaysForService = getFreeDaysForServiceCLEAN
                            print("getFreeDaysForServiceCLEAN after clean \(getFreeDaysForServiceCLEAN.count)")
                            print("Global.sharedInstance.getFreeDaysForService.count after clean \(Global.sharedInstance.getFreeDaysForService.count)")
                            //it seems it does not parse good


                            for i in 0 ..< Global.sharedInstance.getFreeDaysForService.count{
                                let dateDt = Calendar.sharedInstance.addDay(Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate))
                                let provider:providerFreeDaysObj = Global.sharedInstance.getFreeDaysForService[i]
                                let hourStart = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvFromHour)
                                let hourEnd = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvToHour)

                                Global.sharedInstance.fromHourArray.append(hourStart)
                                Global.sharedInstance.endHourArray.append(hourEnd)
                                Global.sharedInstance.dateFreeDays.append(dateDt)
                                print("ooo dateDt \(dateDt)")
                            }

                         self.generic.hideNativeActivityIndicator(self)
                            self.FULLDAYTABLEVIEW.isUserInteractionEnabled = true

                            self.GetCustomerOrders()

                        }
                    }
                     self.generic.hideNativeActivityIndicator(self)
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.FULLDAYTABLEVIEW.isUserInteractionEnabled = true
                print("NSError \(Error)")

//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }


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
            self.GetCustomerOrders()
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
            Global.sharedInstance.getFreeDaysForService = []
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
                print("Global.sharedInstance.dicGetFreeDaysForServiceProvider \(self.PREETYJSON_J(Global.sharedInstance.dicGetFreeDaysForServiceProvider, pathofweb: "cHOSEW"))")
                api.sharedInstance.GetFreeDaysForServiceProvider(Global.sharedInstance.dicGetFreeDaysForServiceProvider, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
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
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                    Global.sharedInstance.getFreeDaysForService = ps.objFreeDaysToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                }
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
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                })
            }
        }
    }
    func showalertx() {
        self.showAlertDelegateX("NUMBER_OF_MAXIMUM_APPOINTMENTS_EQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
    }
    func GetProviderSettingsForCalendarmanagement() {
        let USERDEF = UserDefaults.standard
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                print("response for GetProviderSettingsForCalendarmanagement \(responseObject ?? 1 as AnyObject)")
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                let possiblerezult:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                if let _:Bool = possiblerezult["bLimitSeries"] as? Bool {
                                    self.bLimitSeries = possiblerezult["bLimitSeries"] as! Bool
                                }
                                if self.bLimitSeries == false { //defaults 26 in 52 weeks...means multiple once
                                    self.iMaxServiceForCustomer = 26
                                    self.iPeriodInWeeksForMaxServices = 52
                                } else {
                                    if let _:Int = possiblerezult["iMaxServiceForCustomer"] as? Int {
                                        self.iMaxServiceForCustomer = possiblerezult["iMaxServiceForCustomer"] as! Int
                                        if self.iMaxServiceForCustomer == 0 {
                                            self.iMaxServiceForCustomer = 3
                                        }
                                    } else {
                                        self.iMaxServiceForCustomer = 3
                                    }

                                    if self.bLimitSeries == false { //defaults 26 in 52 weeks...means multiple once
                                        self.iMaxServiceForCustomer = 26
                                        self.iPeriodInWeeksForMaxServices = 52
                                    } else {
                                        if let _:Int = possiblerezult["iMaxServiceForCustomer"] as? Int {
                                            self.iMaxServiceForCustomer = possiblerezult["iMaxServiceForCustomer"] as! Int
                                            if self.iMaxServiceForCustomer == 0 {
                                                self.iMaxServiceForCustomer = 3
                                            }
                                        } else {
                                            self.iMaxServiceForCustomer = 3
                                        }
                                        if let _:Int = possiblerezult["iPeriodInWeeksForMaxServices"] as? Int {
                                            self.iPeriodInWeeksForMaxServices = possiblerezult["iPeriodInWeeksForMaxServices"] as! Int
                                            if  self.iPeriodInWeeksForMaxServices == 0 {
                                                self.iPeriodInWeeksForMaxServices  = 6
                                            }
                                        } else {
                                            self.iPeriodInWeeksForMaxServices = 6
                                        }
                                    }
                                }

                                if let _:Int = possiblerezult["iCustomerViewLimit"] as? Int {
                                    self.iCustomerViewLimit = possiblerezult["iCustomerViewLimit"] as! Int
                                }
                                if self.iCustomerViewLimit == 0 {
                                    self.iCustomerViewLimit = 52
                                }
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
                                }
                                USERDEF.set(self.iCustomerViewLimit, forKey: "CALENDARWEEKSFORSUPPLIER")
                                USERDEF.set(self.iMaxServiceForCustomer, forKey: "MAXSERVICEFORCUSTOMER")
                                USERDEF.set(self.iPeriodInWeeksForMaxServices , forKey: "WEEKSFORSUPPLIER")
                                USERDEF.set(self.bIsAvailableForNewCustomer, forKey: "bIsAvailableForNewCustomer")
                                USERDEF.set(self.iHoursForPreCancelServiceByCustomer, forKey: "iHoursForPreCancelServiceByCustomer")
                                USERDEF.synchronize()
                            }
                        } else {
                            //user was not found
                            self.SETUPDEFAULTSINCASEOFFAILURE()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.SETUPDEFAULTSINCASEOFFAILURE()
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }

    func SETUPDEFAULTSINCASEOFFAILURE() {
        let USERDEF = UserDefaults.standard
        self.iMaxServiceForCustomer = 3
        self.iPeriodInWeeksForMaxServices = 6
        self.iCustomerViewLimit = 52
        USERDEF.set(self.iCustomerViewLimit, forKey: "CALENDARWEEKSFORSUPPLIER")
        USERDEF.set(self.iMaxServiceForCustomer, forKey: "MAXSERVICEFORCUSTOMER")
        USERDEF.set(self.iPeriodInWeeksForMaxServices , forKey: "WEEKSFORSUPPLIER")
        USERDEF.synchronize()
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
                                } else{
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
extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
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
