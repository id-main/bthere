//
//  ReportLastSixmonthsViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 08.12.2017
//  Copyright © 2017 BTHERE. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import MessageUI


//openFromMenuDelegate

//דף ספק -  תצוגת רשימה
class ReportLastSixmonthsViewController: NavigationModelViewController,UITableViewDataSource,UITableViewDelegate ,openFromMenuDelegate,iCarouselDataSource, iCarouselDelegate,MFMailComposeViewControllerDelegate{
    //NEW DEVELOP
    @IBOutlet var btnBACK: UIButton!
    @IBOutlet var titlescreen:UILabel!
    var firstissuetime:Int = 0
    var BlockHouresObjArray:Array<BlockHouresObj> =  Array<BlockHouresObj>()
    var intSuppliersecondID:Int = 0
    //END NEW
    var FROMPRINT:Bool = false
    var PROVIDERID:Int = 0
    var EMPLOYEISMANAGER:Bool = false
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var carousel: iCarousel!
    var MyWeekDayNames:NSArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var MyHebrewWeekDayNames:NSArray = ["יוֹם רִאשׁוֹן" ,"יוֹם שֵׁנִי‎","יוֹם שְׁלִישִׁי‎","יוֹם רְבִיעִי","יוֹם חֲמִישִׁי" ,"יוֹם שִׁישִּׁי" ,"יוֹם שַׁבָּת"]

    var myArray : NSMutableArray = NSMutableArray()
    var myCustomersArray : NSMutableArray = []
    var arrayWorkers:  NSMutableArray = []
    var selectedWorker:Bool = false
    var selectedWorkerID:Int = 0
    var dateturn:String = ""
    @IBOutlet weak var btnSyncGoogleSupplier: eyeSynCheckBox!
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
    var iFilterByMonthEnd:Int = 0
    var iFilterByYearEnd:Int = 0
    //מכיל את כל הארועים מהמכשיר ושל ביזר להצגה מחולק לפי תאריך(לכל תאריך יש את הארועים שלו:הקי=תאריך הארוע)
    var dicArrayEventsToShow:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var sortDicEvents:[(String,Array<allKindEventsForListDesign>)] = []//מכיל את כל הארועים הנ״ל בצורה ממויינת לפי תאריך ולפי שעות לכל יום
    var dicBthereEvent:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()//למקרה שהסנכרון עם המכשיר מכובה משתמשים במערך זה
    var sortDicBTHEREevent:[(String,Array<allKindEventsForListDesign>)] = []//מכיל את כל ארועים ביזר בצורה ממויינת לפי תאריך ולפי שעות לכל יום
    var sortDicBTHEREeventFiltered:[(String,Array<allKindEventsForListDesign>)] = []
    let dateFormatter = DateFormatter()
    var generic:Generic = Generic()
    var reloadFromInitEvents = false//מציין האם הגיעו לריענון הטבלה מהפונקציה ל initEvents
    var nogoogle = true
    var frombestback:Bool = false
    //ואז יש שאול האם אין נתונים להציג
    @IBAction func btnBACK(_ sender: AnyObject) {
        let   supplierStoryBoard2 = UIStoryboard(name: "SupplierExist", bundle: nil)
        let  storyBoard1Main = UIStoryboard(name: "Main", bundle: nil)
        Global.sharedInstance.isProvider = true
        let frontviewcontroller = storyBoard1Main.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let rearViewController = storyBoard1Main.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let CalendarSupplier: CalendarSupplierViewController = supplierStoryBoard2.instantiateViewController(withIdentifier: "CalendarSupplierViewController")as! CalendarSupplierViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: CalendarSupplier)
        mainRevealController.pushFrontViewController(navigationController, animated: false)
        mainRevealController.revealToggle(animated: true)
        Global.sharedInstance.isFromprintCalender = false
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController

    }
    //MARK: - @IBAction
    //click on sync eye
    @IBAction func btnSyncGoogleSupplier(_ sender: eyeSynCheckBox) {
        if sender.isCecked == false{
            Global.sharedInstance.getEventsFromMyCalendar()
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true
            initEvents()
        }
        else{
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = false
            initEvents()
        }
    }

    @IBOutlet weak var viewSync: UIView!

    //    @IBOutlet weak var btnSync: eyeSynCheckBox!

    //MARK: - Initial
    func openFromMenu(_ con:UIViewController){
        self.present(con, animated: true, completion: nil)
    }
       @objc func refreshTable(_ sender:AnyObject) {
        // Code to refresh table view
        GetSecondUserIdByFirstUserIdEight()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftarrowback = UIImage(named: "sageata2.png")
        self.btnBACK.setImage(leftarrowback, for: UIControl.State())
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnBACK.transform = scalingTransform
        }
        btnBACK.imageView!.contentMode = .scaleAspectFit
        let strtitle:String = "SIX_MONTHS_REPORT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        titlescreen.text =  strtitle
        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 {
            self.EMPLOYEISMANAGER = false
        } else {
            self.EMPLOYEISMANAGER = true
        }
        nogoogle = true

        self.myArray = []
        reloadFromInitEvents = false
        if frombestback == false {
            //no need
        }
        let todaybe:Date = Date()
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let month = components.month
        let year = components.year
        iFilterByMonth = month!
        iFilterByYear = year!
        iFilterByMonthEnd = month!
        iFilterByYearEnd = year!
        if  nogoogle == false
        {
            btnSyncGoogleSupplier.isCecked = true
        }
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        refreshControl.addTarget(self, action: #selector(ListDesignViewController.refreshTable(_:)), for: UIControl.Event.valueChanged)
        self.tblData.addSubview(refreshControl)
        AppDelegate.i = 0
        tblData.separatorStyle = .none

        frombestback = true
        self.myArray = []
        reloadFromInitEvents = false
        GetSecondUserIdByFirstUserIdEight()

    }
    ///JMODE +
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
    func numberOfItems(in carousel: iCarousel) -> Int {
        print("self.arrayWorkers.count \(self.arrayWorkers.count)")
        return self.arrayWorkers.count
    }
    func carouselDidScroll(_ carousel: iCarousel) {
        print("hmz")

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
        if  self.arrayWorkers.count > 0 {
            let  index:Int = carousel.currentItemIndex
            var workerid:Int = 0
            if let _:User = self.arrayWorkers[index] as? User {
                let MYD:User = self.arrayWorkers[index] as! User
                workerid =  MYD.iUserId
                print("workerid \(workerid) si \(index)")
                self.selectedWorker = true
                self.selectedWorkerID = index
                Global.sharedInstance.defaults.set(workerid, forKey: "idSupplierWorker")
                Global.sharedInstance.defaults.synchronize()
                sortDicBTHEREeventFiltered = []
                self.intSuppliersecondID = workerid
                GetBlockedHouresFromCalendar()
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
            if self.arrayWorkers.count > 1 {
                for itemView in carousel.visibleItemViews {
                    for subview in (itemView as AnyObject).subviews as [UIView] {
                        if let labelView = subview as? UILabel {
                            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 14)
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
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3.2, height: 55))
            itemView.image = UIImage(named: "")
            itemView.contentMode = .scaleAspectFill
            itemView.backgroundColor = UIColor.clear
            label = UILabel(frame: CGRect(x: itemView.frame.origin.x , y: itemView.frame.origin.y + 1, width:itemView.frame.size.width, height: itemView.frame.size.height - 6))
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 22)
            label.font = labelFont
            label.numberOfLines = 1
            label.textColor = Colors.sharedInstance.color4
            label.tag = 1
            itemView.addSubview(label)


        }

        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
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
    //    func carouselShouldWrap(carousel:iCarousel) ->Bool {
    //    //wrap all carousels
    //    return true
    //    }



    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         GoogleAnalyticsSendEvent(x:56)
    }


    override func viewDidAppear(_ animated: Bool)
    {
        // initEvents()

    }

    @IBOutlet var tblData: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        if reloadFromInitEvents == true && sortDicBTHEREeventFiltered.count == 0
        {
            self.view.makeToast(message: "NO_EVENTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })
        }
        //  if selectedWorkerID > 0 {
        if sortDicBTHEREeventFiltered.count == 0 {
            self.view.makeToast(message: "NO_EVENTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 2.0, position: HRToastPositionTop as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })
        }
        return sortDicBTHEREeventFiltered.count

        //}


        //    return sortDicBTHEREevent.count//רק ארועי ביזר

    }
    func hidetoast(){
        view.hideToastActivity()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if selectedWorkerID > 0 {
        return sortDicBTHEREeventFiltered[section].1.count + 1
        //  }
        //  print("sortDicBTHEREevent[section].1.count \(sortDicBTHEREevent[section].1.count)")
        //  return sortDicBTHEREevent[section].1.count + 1//רק ארועי ביזר
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var event:(String,Array<allKindEventsForListDesign>)?
        event = sortDicBTHEREeventFiltered[indexPath.section]
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

        let dayEventtext = "\(dayEvent ?? dayToday)"
        let monthEventtext = "\(monthEvent ?? monthToday)"
        let yearEventtext = "\(yearEvent ?? yearToday)"
        if indexPath.row == 0
        {
            let cell:HeaderSixMonthsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HeaderSixMonthsTableViewCell")as!HeaderSixMonthsTableViewCell
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
            let str =  "," + dayEventtext + " " + String(monthName) + " " + yearEventtext
            let myNSString = yearEventtext as NSString
            let str1 = myNSString.substring(with: NSRange(location: 2, length: 2))
            dateturn = dayEventtext + "." + monthEventtext + "." + String(str1)
            cell.setDisplayData(str,daydesc: a) //was dayInWeek for short
            return cell
        }
        else
        {

            let cell:RowInListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RowInListTableViewCell")as!RowInListTableViewCell
            cell.dateTurn = dateturn
            cell.isfromLIST = false
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.sortArrEvnt = sortDicBTHEREevent
            cell.event = event!.1[indexPath.row - 1]
            print("cauta \(cell.event.ClientnvFullName)")
            //  let anyhow:Int = cell.event.iUserId
            var emi:NSMutableDictionary = NSMutableDictionary()
            if let _:String = event!.1[indexPath.row - 1].nvPhone   {
                let nvPhone = event!.1[indexPath.row - 1].nvPhone
                emi["nvPhone"] = nvPhone
            }
            //            if self.findCustomer(anyhow) != NSDictionary() {
            //                emi = self.findCustomer(anyhow)
            //            }

            var isOcasionalCustomer:Bool = false
            if event!.1[indexPath.row - 1].iUserId == 134 {
                isOcasionalCustomer = true
            }
            var isHourPast:Bool = false
            if self.isdateafter(event!.1[indexPath.row - 1]) == true {
                //nothing to change
                isHourPast =  false
            } else {
                if self.hourisless(event!.1[indexPath.row - 1]) == true {
                    isHourPast =  true
                    //\\print(event!.1[indexPath.row - 1].title)
                }
            }
            let st =  "\(event!.1[indexPath.row - 1].fromHour) - \(event!.1[indexPath.row - 1].toHour)"
            cell.setDisplayData(st, _desc:event!.1[indexPath.row - 1].ClientnvFullName,_EventFrom: event!.1[indexPath.row - 1].tag,_index: indexPath.section,_ClientDict: emi,_servicesdesc:event!.1[indexPath.row - 1].title, _isHourPast:isHourPast, _isOcasionalCustomer:isOcasionalCustomer,_fromSixMonthReport: true, _iscancel: event!.1[indexPath.row - 1].iCoordinatedServiceStatusType,_isblocked:false, _isdayevent:false)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell

        }


    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset:CGPoint = scrollView.contentOffset
        let bounds:CGRect = scrollView.bounds
        let size:CGSize = scrollView.contentSize
        let inset:UIEdgeInsets = scrollView.contentInset
        let y:CGFloat = offset.y + bounds.size.height - inset.bottom
        let h:CGFloat = size.height
        let reload_distance:CGFloat = 100
        if(y > h + reload_distance) {
            print("load more rows")
            let todaybe:Date = Date()
            let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
            let month = components.month
            //  let year = components.year
            if iFilterByMonth == 12 {
                iFilterByMonth = 1
                iFilterByYear = iFilterByYear + 1
                iFilterByMonthEnd = 1
                iFilterByYearEnd = iFilterByYear
            } else if month! <= iFilterByMonth && iFilterByMonth < 12 {
                iFilterByMonth = iFilterByMonth + 1
                iFilterByMonthEnd = iFilterByMonth
                iFilterByYearEnd = iFilterByYear
            }

            if self.EMPLOYEISMANAGER == true {
                GetCustomersOrdersForSupplier()
            } else {
                //is employe non manager
                GetCustomerOrdersForEmployeeId()
            }

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 25
        }
        return 54
    }

    @objc func showSync()
    {
        if btnSyncGoogleSupplier.isCecked == false
        {

            btnSyncGoogleSupplier.isCecked = true
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true
            Global.sharedInstance.getEventsFromMyCalendar()
        }
        else
        {
            btnSyncGoogleSupplier.isCecked = false
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = false
        }
        tblData.reloadData()
        self.tblData.setNeedsLayout()
        self.tblData.layoutIfNeeded()
    }



    func small(_ lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedAscending

    }


    func initEvents()
    {
        var axz = Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")
        if axz == -1 {
            if let _:User = self.arrayWorkers[0] as? User {
                let MYD:User = self.arrayWorkers[0] as! User
                let workerid =  MYD.iUserId
                print("workerid \(workerid) si \(index)")
                self.selectedWorker = true
                self.selectedWorkerID = 0
                axz = workerid
                Global.sharedInstance.defaults.set(workerid, forKey: "idSupplierWorker")
                Global.sharedInstance.defaults.synchronize()
            }
        }

            Global.sharedInstance.setAllEventsArray()

            dicBthereEvent.removeAll()


            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"

            Global.sharedInstance.getEventsFromMyCalendar()

            //------------------אתחול המערכים להצגת הארועים בצורה ממויינת------------------------

            let dateIn5Month = Calendar.sharedInstance.addMonths(Date(), numMonthAdd: -6)

            for item in self.myArray

            {
                var dateEvent:Date = Date()
                var hourStart = Date()
                var hourEnd = Date()
                if let _:NSDictionary = item as? NSDictionary {
                    let eventBthere:NSDictionary = item as! NSDictionary
                    print("test event \(eventBthere.description)")
                    if let ORDERDATE:String =  eventBthere.object(forKey: "dtDateOrder") as? String
                    {
                        dateEvent = Global.sharedInstance.getStringFromDateString(ORDERDATE)
                        print("STRdtDateOrder\(dateEvent)")
                    }

                    let calendar:Foundation.Calendar = Foundation.Calendar.current

                    let components5Month = (calendar as NSCalendar).components([.day, .month, .year], from: dateIn5Month)
                    let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateEvent)
                    year5Month =  components5Month.year!
                    month5Month = components5Month.month!
                    day5Month = components5Month.day!
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
                                 if let _:String  = servicedict.object(forKey: "nvServiceName") as? String {
                                if serviceName == ""
                                {
                                        serviceName = servicedict.object(forKey: "nvServiceName") as! String
                                    } else {
                                        serviceName = "\(serviceName),\(servicedict.object(forKey: "nvServiceName") as! String)"
                                    }
                                }
                            }
                        }
                    }


                    var nvServiceName = ""
                    if let _:NSArray =  eventBthere.object(forKey: "objProviderServiceDetails") as? NSArray {
                        let myarrservices = eventBthere.object(forKey: "objProviderServiceDetails") as! NSArray
                        for item in myarrservices {
                            if let servicedict:NSDictionary = item as? NSDictionary {
                                   if let _:String  = servicedict.object(forKey: "nvServiceName") as? String {
                                if nvServiceName == ""
                                {

                                        nvServiceName = servicedict.object(forKey: "nvServiceName") as! String

                                } else {
                                        nvServiceName = "\(nvServiceName),\(servicedict.object(forKey: "nvServiceName") as! String)"
                                    }
                                }
                            }
                        }
                    }
                    

                    print("servicename \(serviceName) si nvServiceName \(nvServiceName)")



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
                    var chServiceColor:String = ""
                    if let _:String = eventBthere.object(forKey: "chServiceColor") as? String{
                        chServiceColor = eventBthere.object(forKey: "chServiceColor") as! String
                    }
                    var wascancel:Int = 1
                    if let _:Int = eventBthere.object(forKey: "iCoordinatedServiceStatusType") as? Int{ //to fix
                        wascancel = eventBthere.object(forKey: "iCoordinatedServiceStatusType") as! Int
                    }
                    let ARRAYiProviderUserId:Array<Int> = []
                    let objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
                    //if string.rangeOfString("Swift") != nil{
                    var nvPhone:String = ""
                    if let _:String = eventBthere.object(forKey: "nvPhone") as? String{
                        nvPhone = eventBthere.object(forKey: "nvPhone") as! String
                    }
                    var iSupplierId:Int = 0
                    if let _:Int = eventBthere.object(forKey: "iSupplierId") as? Int{
                        iSupplierId = eventBthere.object(forKey: "iSupplierId") as! Int
                    }
                    if serviceName.range(of: "Blockhours") == nil && serviceName != "" && nvComment != "BlockedBySupplier" {
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
                            _chServiceColor: chServiceColor,
                            _viewsforweek: [],
                            _iCoordinatedServiceStatusType: wascancel,
                            _nvPhone: nvPhone,
                            _iSupplierId: iSupplierId
                        )
                        print("eventBthereeservicename \( eventBtheree.nvServiceName)")
                        print("gasit ClientnvFullName \(eventBtheree.ClientnvFullName) ")
                        if  eventBtheree.iProviderUserId == axz {

                            if dicBthereEvent[dateFormatter.string(from: dateEvent)] != nil
                            {
                                dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                            }
                            else
                            {
                                dicBthereEvent[dateFormatter.string(from: dateEvent)] = Array<allKindEventsForListDesign>()
                                dicBthereEvent[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                            }

                            if dicArrayEventsToShow[dateFormatter.string(from: dateEvent)] != nil
                            {
                                dicArrayEventsToShow[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                            }
                            else
                            {
                                dicArrayEventsToShow[dateFormatter.string(from: dateEvent)] = Array<allKindEventsForListDesign>()
                                dicArrayEventsToShow[dateFormatter.string(from: dateEvent)]?.append(eventBtheree)
                            }
                        }

                    }

                }

            }


        sortDicEvents = [(String,Array<allKindEventsForListDesign>)]()
        sortDicEvents = dicArrayEventsToShow.sorted{ dateFormatter.date(from: $0.0)!.compare(dateFormatter.date(from: $1.0)!) == .orderedDescending}
        //ארועי ביזר בלבד!!
        sortDicBTHEREevent = [(String,Array<allKindEventsForListDesign>)]()
        sortDicBTHEREevent = dicBthereEvent.sorted{ dateFormatter.date(from: $0.0)!.compare(dateFormatter.date(from: $1.0)!) == .orderedDescending}
        //-------מיון לכל יום לפי השעות
        var i = 0
        for _ in sortDicEvents//כל הארועים
        {
            sortDicEvents[i].1.sort(by: { $0.dateEvent.compare($1.dateEvent as Date) == ComparisonResult.orderedDescending })
            i += 1
        }

        i = 0
        for _ in sortDicBTHEREevent//ארועי ביזר
        {
            sortDicBTHEREevent[i].1.sort(by: { $0.dateEvent.compare($1.dateEvent as Date) == ComparisonResult.orderedDescending })

            i += 1
        }
        sortDicBTHEREeventFiltered = sortDicBTHEREevent
        reloadFromInitEvents = true
        tblData.reloadData()
        self.tblData.setNeedsLayout()
        self.tblData.layoutIfNeeded()
        refreshControl.endRefreshing()
        self.TRYPDFJUSTNOW(sortDicBTHEREevent)

    }

    func isdateafter (_ itemx: allKindEventsForListDesign) -> Bool {
        var isafter:Bool  = false
        let eventDay:Date = itemx.dateEvent as Date
        //\\print ("eventday \(eventDay)")
        let todayStart:Date = Date()
        if eventDay.compare(todayStart) == ComparisonResult.orderedDescending
        {
            NSLog("date1 after date2");
            isafter = true

        } else if eventDay.compare(todayStart) == ComparisonResult.orderedAscending
        {
            NSLog("date1 before date2");
            isafter = false
        } else
        {
            NSLog("dates are equal");
            isafter = false
        }

        return isafter
    }

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

    func TRYPDFJUSTNOW(_ NEWARRAY:[(String,Array<allKindEventsForListDesign>)]) {
        let render = UIPrintPageRenderer()
        var html = ""

        var adate:Date = Date()
        print("NEWARRAY \(NEWARRAY.count)")


        if NEWARRAY.count > 0 {
            //maximum 20 rows per page

            let numberofsections = self.tblData.numberOfSections
            for i in 0..<numberofsections {
                let y = self.tblData.numberOfRows(inSection: i)
                print("number of rows \(y - 1) ") //one is header
                for z in 0..<y {
                    var event:(String,Array<allKindEventsForListDesign>)?
                    event = sortDicBTHEREevent[i]
                    if z == 0 {
                        html = html + "<table style=\"width:100%; border-collapse: collapse;\">"
                        let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: dateFormatter.date(from: event!.0)!)
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
                        let dayWeek = Calendar.sharedInstance.getDayOfWeek(dateFormatter.date(from: event!.0)!)
                        let whatmonthisminus:Int = dayWeek!
                        var a:String = ""
                        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                            a = MyHebrewWeekDayNames.object(at: whatmonthisminus - 1) as! String
                        } else {
                            a = MyWeekDayNames.object(at: whatmonthisminus - 1) as! String
                        }

                        let dayEventtext = "\(dayEvent ?? dayToday)"
                        let monthEventtext = "\(monthEvent ?? monthToday)"
                        let yearEventtext = "\(yearEvent ?? yearToday)"
                        let str =  "," + dayEventtext + " " + String(monthName) + " " + yearEventtext

                        let composeddatefinal = a + str
                        html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align: right; background-color: #f39371; color: #fff; width: 100%;\"> \(composeddatefinal)</td></tr>"


                        //here is a header row with day name and date

                    } else {
                        //here is the event detail with two rows .. one is hour  let st =  "\(event!.1[indexPath.row - 1].fromHour) - \(event!.1[indexPath.row - 1].toHour)"

                        //row 1 hours
                        if z % 18 == 0 {
                            //new table to fit on page
                            html = html + "</table>"
                            html =  html + "<table style=\"width:100%; border-collapse: collapse;\">"
                        } else {
                            let hhours =  "\(event!.1[z - 1 ].fromHour) - \(event!.1[z - 1].toHour)"
                            let clientname = event!.1[z - 1].ClientnvFullName
                            let servicename = event!.1[z - 1].title
                            var statusoforder = event!.1[z - 1].iCoordinatedServiceStatusType
                            var   composedstring = ""

                            composedstring = clientname + " - " + servicename
                            let canceledstring = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + "WAS_CANCELLED".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                            if statusoforder != 92 {
                                html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; width: 100%; \">    \(hhours)</td></tr>"
                            } else {
                                html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; width: 100%; color:#e10e0e; \">    \(hhours)  \(canceledstring) </td></tr>"
                            }
                            //row 2  second is customer name with service name
                            if statusoforder != 92 {
                                html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; width: 100%;border-bottom: 1px solid black;\">    \(composedstring)</td></tr>"
                            } else {
                                html = html + "<tr style =\"height: 40 px;\"><td style= \"text-align:left; color:#e10e0e; width: 100%;border-bottom: 1px solid black;\">    \(composedstring)</td></tr>"
                            }
                        }
                    }
                }
                html = html + "</table>"
            }



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
            // let path = "\(NSTemporaryDirectory())sd.pdf"
            //            let path = "\(NSTemporaryDirectory())\(fileNAMEFINAL)"
            print("fileNAMEFINAL\(fileNAMEFINAL)")
            let documents = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let tempDocumentsDirectory: AnyObject = documents[0] as AnyObject
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

                if let _:String = tempDataPath

                {
                    print("File path loaded.")

                    if let fileData = try? Data(contentsOf: URL(fileURLWithPath: tempDataPath))
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
    //  self.initEvents()
    //NEW DEVELOP


    //CLEAN AND FIXED 12.04.2019
    //1. GetSecondUserIdByFirstUserIdEight()
    //± setupISupplierSecondID()
    //2. getServicesProviderForSupplierfunc()
    //±. processworkers -> carousel did change
    //3. GetBlockedHouresFromCalendar
    //4. GetCustomersOrdersForSupplier or GetCustomerOrdersForEmployeeId

    //1.
    func GetSecondUserIdByFirstUserIdEight()  {
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
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        dic["iSupplierId"] = providerID as AnyObject //881
        if Reachability.isConnectedToNetwork() == false
        {

            //            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomerOrdersForSupplierIdInLast6Months(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                        self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in

                //                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
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
        var y:Int = 0
        if self.arrayWorkers.count > 0 {
            if   Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") == -1 {
                if let myuser:User = self.arrayWorkers[0] as? User {
                    let workerdic:User = myuser
                    y = workerdic.iUserId
                }
            }else {
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
                            print("6month worker selectat anterior \(diciuserid) la index \(x)")
                            y = diciuserid
                        }
                    }
                }
            }
        }

        dic["iSupplierUserId"] =  y as AnyObject
        if Reachability.isConnectedToNetwork() == false
        {

            //            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomerOrdersForEmployeeIdInLast6Months(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                        self.processMYARRAY(newarray, globalcustarray: ordersOfClientsArray)
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in

                //                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            })
        }
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
