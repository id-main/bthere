//
//  MonthDesignSupplierViewController.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/14/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

//ספק קיים- תצוגת חודש יומן
class MonthDesignSupplierViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, iCarouselDataSource, iCarouselDelegate,UIGestureRecognizerDelegate{
    //NEW DEVELOP
    var SameHours:Bool = false
    var BlockHouresObjArray:Array<BlockHouresObj> =  Array<BlockHouresObj>()
    var intSuppliersecondID:Int = 0
    //END NEW
    var EMPLOYEISMANAGER:Bool = false
    var getFreeDaysForService:Array<providerFreeDaysObj> =  Array<providerFreeDaysObj>()
    // var idWorker:Int = -1
    var frombestback:Bool = false
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var dicArrayEventsToShow:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var sortDicEvents:[(String,Array<allKindEventsForListDesign>)] = []
    var dicBthereEvent:Dictionary<String,Array<allKindEventsForListDesign>> = Dictionary<String,Array<allKindEventsForListDesign>>()
    var sortDicBTHEREevent:[(String,Array<allKindEventsForListDesign>)] = []
    var sortDicBTHEREeventFiltered:[(String,Array<allKindEventsForListDesign>)] = []
    var year5Month =  0
    var month5Month = 0
    var day5Month = 0
    var yearEvent =  0
    var monthEvent = 0
    var dayEvent = 0
    fileprivate let kKeychainItemName = "Google Calendar API"
    fileprivate let kClientID = "284147586677-69842kmfbfll1dmec57c9gklqnpa5n2u.apps.googleusercontent.com"
    ///JMODE +
    var myArray : NSMutableArray = NSMutableArray()
    var myCustomersArray : NSMutableArray = []
    var arrayWorkers:  NSMutableArray = []
    var selectedWorker:Bool = false
    var selectedWorkerID:Int = 0
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var iFilterByMonthEnd:Int = 0
    var iFilterByYearEnd:Int = 0
    var generic:Generic = Generic()
    var today: Date = Date()
    let language = Bundle.main.preferredLocalizations.first! as NSString
    var days:Array<Int> = []
    var numDaysInMonth:Int = 0
    var dateFirst:Date = Date()
    var dayInWeek:Int = 0
    var i = 1
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    var hasEvent = false
    var shouldShowDaysOut = true
    var animationFinished = true
    var currentDate:Date = Date()
    let output = UITextView()
    var dateFormatter = DateFormatter()
    var moneForBackColor = 1
    let calendar = Foundation.Calendar.current
    var bthereEventDateDayInt:NSMutableArray = NSMutableArray()
    var blockHoursEventDateDayInt:NSMutableArray = NSMutableArray()
    var MYveryShortStandaloneWeekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"]

    var MyMonthsNames:NSArray = [ "January".localized(LanguageMain.sharedInstance.USERLANGUAGE), "February".localized(LanguageMain.sharedInstance.USERLANGUAGE), "March".localized(LanguageMain.sharedInstance.USERLANGUAGE), "April".localized(LanguageMain.sharedInstance.USERLANGUAGE), "May".localized(LanguageMain.sharedInstance.USERLANGUAGE), "June".localized(LanguageMain.sharedInstance.USERLANGUAGE), "July".localized(LanguageMain.sharedInstance.USERLANGUAGE), "August".localized(LanguageMain.sharedInstance.USERLANGUAGE), "September".localized(LanguageMain.sharedInstance.USERLANGUAGE), "October".localized(LanguageMain.sharedInstance.USERLANGUAGE), "November".localized(LanguageMain.sharedInstance.USERLANGUAGE),  "December".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    var MyWeekDayNames:NSArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var isSyncCalendar: String = "1"



    @IBOutlet var arrowleft: UIImageView!
    @IBOutlet var arrowright: UIImageView!
    @IBOutlet var lblHebrewDate: UILabel!
    @IBOutlet var lblCurrentDate: UILabel!
    @IBOutlet var carousel: iCarousel!
    @IBOutlet weak var viewOpenTblWorkers: UIView!
    @IBOutlet weak var viewSync: UIView!
    @IBOutlet weak var btnSyn: eyeSynCheckBox!





    @IBOutlet weak var lblWorkerName: UILabel!

    @IBOutlet weak var lblDayOfWeek1: UILabel!

    @IBOutlet weak var lblDayOfWeek2: UILabel!

    @IBOutlet weak var lblDayOfWeek3: UILabel!

    @IBOutlet weak var lblDayOfWeek4: UILabel!

    @IBOutlet weak var lblDayOfWeek5: UILabel!

    @IBOutlet weak var lblDayOfWeek6: UILabel!

    @IBOutlet weak var lblDayOfWeek7: UILabel!

    @IBOutlet var collDays: UICollectionView!

    //MARK: - Initial
    ///JMODE +
    ///END  JMODE +

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:62)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        moneForBackColor = 1

        // Check if calendar is sync
        let USERDEF = Global.sharedInstance.defaults
        if let _:Int = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as? Int {
            let y = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as! Int
            if y == 0 {
                viewSync.isHidden = true
                btnSyn.isHidden = true
            } else if y == 1 {
                viewSync.isHidden = false
                btnSyn.isHidden = false
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true{
                    btnSyn.isCecked = true
                } else {
                    btnSyn.isCecked = false
                }
            }
        }

        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 {
            self.EMPLOYEISMANAGER = false
        } else {
            self.EMPLOYEISMANAGER = true
        }
        self.navigationItem.setHidesBackButton(true, animated:false)

        ///JMODE
        if frombestback == true {
            numDaysInMonth = Calendar.sharedInstance.getNumsDays(Calendar.sharedInstance.carrentDate)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
            dateFirst = Calendar.sharedInstance.getFirstDay(Calendar.sharedInstance.carrentDate)//מחזירה את התאריך הראשון של החודש שנשלח
            dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!//מחזירה את היום בשבוע של הראשון בחודש
            let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
            let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
            let day = components.day
            let month = components.month
            let year = components.year
            iFilterByMonth = month!
            iFilterByYear = year!
            iFilterByMonthEnd = month!
            iFilterByYearEnd = year!
            numDaysInMonth = Calendar.sharedInstance.getNumsDays(todaybe)
            dateFirst = Calendar.sharedInstance.getFirstDay(todaybe)
            dayInWeek = Calendar.sharedInstance.getDayOfWeek(todaybe)!
            print("11d m y \(day) \(month) \(year)")
            today = Calendar.sharedInstance.carrentDate as Date


        } else {

            let todaybe:Date = Date()
            let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
            let day = components.day
            let month = components.month
            let year = components.year
            iFilterByMonth = month!
            iFilterByYear = year!
            iFilterByMonthEnd = month!
            iFilterByYearEnd = year!
            numDaysInMonth = Calendar.sharedInstance.getNumsDays(Date())
            dateFirst = Calendar.sharedInstance.getFirstDay(Date())
            dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!
            today = Date()
            Calendar.sharedInstance.carrentDate = today
            print("d m y \(day) \(month) \(year)")

        }
        self.myArray = []
        frombestback = false

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
        let tapSync = UITapGestureRecognizer(target:self, action:#selector(self.showSync))
        viewSync.addGestureRecognizer(tapSync)
        GetSecondUserIdByFirstUserIdSeven()

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate  = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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



    // click on prev date
    //   @IBAction func btnBefore(sender: UIButton) {
    @IBAction func btnNext(_ sender: UIButton) {

        Calendar.sharedInstance.carrentDate = Calendar.sharedInstance.removeMonth(Calendar.sharedInstance.carrentDate)
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let day = components.day
        let month = components.month
        let year = components.year
        print("1d m y \(day) \(month) \(year)")
        numDaysInMonth = Calendar.sharedInstance.getNumsDays(Calendar.sharedInstance.carrentDate)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
        dateFirst = Calendar.sharedInstance.getFirstDay(Calendar.sharedInstance.carrentDate)//מחזירה את התאריך הראשון של החודש שנשלח
        dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!
        i = 1
        moneForBackColor = 1
        if iFilterByMonth == 1{
            iFilterByMonth = 12
            iFilterByYear = iFilterByYear - 1
            iFilterByMonthEnd = 12
            iFilterByYearEnd = iFilterByYear
        } else if iFilterByMonth  < 12 {
            iFilterByMonth = iFilterByMonth - 1
            iFilterByMonthEnd = iFilterByMonth
            iFilterByYearEnd = iFilterByYear
        }
        GetSecondUserIdByFirstUserIdSeven()

    }
    // click on next date

    @IBAction func btnBefore(_ sender: UIButton) {

        Calendar.sharedInstance.carrentDate = Calendar.sharedInstance.addMonth(Calendar.sharedInstance.carrentDate)
        numDaysInMonth = Calendar.sharedInstance.getNumsDays(Calendar.sharedInstance.carrentDate)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
        dateFirst = Calendar.sharedInstance.getFirstDay(Calendar.sharedInstance.carrentDate)//מחזירה את התאריך הראשון של החודש שנשלח
        dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let day = components.day
        let month = components.month
        let year = components.year
        print("2d m y \(day) \(month) \(year)")
        i = 1
        moneForBackColor = 1
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
           GetSecondUserIdByFirstUserIdSeven()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }


    func shouldAnimateResizing() -> Bool {
        return true
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Aligning right to left on UICollectionView

        let cell:dayMonthCalendarSupplierCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayMonthCalendarSupplierCollectionViewCell",for: indexPath) as! dayMonthCalendarSupplierCollectionViewCell

        cell.delegate = Global.sharedInstance.eleventCon//תחת המודל של יומן שלי ללקוח
        //  cell.lblisbhtere.hidden = true
        cell.imgToday.isHidden = true
        cell.lblDayDesc.alpha = 1.0
        cell.lblDayDesc.text = ""
        cell.lblDayDesc.textColor = Colors.sharedInstance.color1


        //\\    print("numDaysInMonth \(numDaysInMonth)")
        // now a bool


        if moneForBackColor % 7 == 0{
            cell.lblDayDesc.textColor = Colors.sharedInstance.color4
            cell.isShabat = true
        }
        else{
            cell.lblDayDesc.textColor = Colors.sharedInstance.color1
        }


        moneForBackColor += 1
        if indexPath.row >= (dayInWeek - 1)  && indexPath.row < (numDaysInMonth + dayInWeek - 1 ) {
            //\\    print("that is bad \(indexPath.row) dayInWeek - 1 \(dayInWeek - 1)  numDaysInMonth + dayInWeek - 1  \(numDaysInMonth + dayInWeek - 1 )")
            //\\     print ("i este ce \(i)")

            var isevent:Bool = false
            var hasblockedhours:Bool = false
            var Iisinrange:Bool = false
            if i <=  numDaysInMonth {
                Iisinrange = true
            }
            //\\      print("bthereEventDateDayInt \(bthereEventDateDayInt.count)")
            if bthereEventDateDayInt.contains(i)
            {
                isevent = true
            } else {
                isevent = false
            }
            if blockHoursEventDateDayInt.contains(i)
            {
                hasblockedhours = true
            } else {
                hasblockedhours = false
            }
            cell.setDisplayData(i,HasEvent: isevent, isinrange: Iisinrange, HasBlockedHoures:  hasblockedhours, SameHours: self.SameHours)

            i += 1
        }
        else{
            cell.setNull()

        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var viewhelp : helpPpopup!
    func LOADHELPERS() {
        var HELPSCREENKEYFORNSUSERDEFAULTS = ""
        let USERDEF = UserDefaults.standard
        var imagesarray:NSArray = NSArray()
        //     returnCURRENTHELPSCREENS() -> (HLPKEY:String, imgs:NSArray)
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        imagesarray = appDelegate.returnCURRENTHELPSCREENS()
        //   HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.HELPSCREENKEY
        HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.returnCURRENTKEY()
        if  imagesarray.count > 0 {
            let fullimgarr:NSMutableArray = imagesarray.mutableCopy() as! NSMutableArray
            print("aaa \(fullimgarr.description)")
            if let mydict:NSMutableDictionary = fullimgarr[5] as? NSMutableDictionary {
                if mydict["seen"] as! Int == 1 { //was not seen
                    let changedictionary: NSMutableDictionary = NSMutableDictionary()
                    changedictionary["needimage"] = mydict["needimage"]
                    changedictionary["seen"] = 0 //seen
                    fullimgarr[5] = changedictionary
                    USERDEF.set(fullimgarr, forKey: HELPSCREENKEYFORNSUSERDEFAULTS)
                    USERDEF.synchronize()
                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    viewhelp = storyboardtest.instantiateViewController(withIdentifier: "helpPpopup") as! helpPpopup
                    if self.iOS8 {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    } else {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    }
                    viewhelp.indexOfImg = 5
                    viewhelp.HELPSCREENKEYFORNSUSERDEFAULTS = HELPSCREENKEYFORNSUSERDEFAULTS
                    self.present(viewhelp, animated: true, completion: nil)
                }
            }
        }
    }

    // helpPpopup

    func bestmode() {
        moneForBackColor = 1
        let USERDEF = Global.sharedInstance.defaults
        if let _:Int = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as? Int {
            let y = USERDEF.value(forKey: "SHOWEYEINCALENDARSUPPLIER") as! Int
            if y == 0 {
                viewSync.isHidden = true
                btnSyn.isHidden = true
            } else if y == 1 {
                viewSync.isHidden = false
                btnSyn.isHidden = false
                if Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true{
                    btnSyn.isCecked = true
                } else {
                    btnSyn.isCecked = false
                }
            }
        }

        frombestback = true
        self.myArray = []
        Global.sharedInstance.ordersOfClientsArray = []
        numDaysInMonth = Calendar.sharedInstance.getNumsDays(Calendar.sharedInstance.carrentDate)//מחזיר מס׳ ימים בחודש שנשלח בפעם הראשונה התאריך של היום
        dateFirst = Calendar.sharedInstance.getFirstDay(Calendar.sharedInstance.carrentDate)//מחזירה את התאריך הראשון של החודש שנשלח
        dayInWeek = Calendar.sharedInstance.getDayOfWeek(dateFirst)!//מחזירה את היום בשבוע של הראשון בחודש
        print("month idSupplierWorker\( Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") )")
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let day = components.day
        let month = components.month
        let year = components.year
        print("best d m y \(day) \(month) \(year)")
        today = Calendar.sharedInstance.carrentDate as Date
        iFilterByMonth = month!
        iFilterByYear = year!
        iFilterByMonthEnd = month!
        iFilterByYearEnd = year!
        GetSecondUserIdByFirstUserIdSeven()

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: view.frame.size.width / 7, height:  view.frame.size.width / 8.5)
        }
        return CGSize(width: view.frame.size.width / 7, height:  view.frame.size.width / 7)
    }

    func changeLblDate(){
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            //let fontSize:CGFloat = self.lblCurrentDate.font.pointSize;
            lblCurrentDate.font = UIFont(name: lblCurrentDate.font.fontName, size: 20)
            lblHebrewDate.font = UIFont(name: lblCurrentDate.font.fontName, size: 11)

        }
        print("Calendar.sharedInstance.carrentDate \(Calendar.sharedInstance.carrentDate)")
        var str:String = ""

        var s1 = dateFormatter.string(from: Calendar.sharedInstance.carrentDate as Date).components(separatedBy: "/")
        if s1.count > 0 {
            print("s1is \(s1)")
            let characters = s1[1].characters.map { String($0) }
            if characters[0] == String(0){
                //////     str = NSDateFormatter().monthSymbols[Int(characters[1])! - 1]
                let whatmonthisminus:Int = Int(characters[1])! - 1
                print("si luna e \(Int(characters[1])! - 1)")
                str = MyMonthsNames.object(at: whatmonthisminus) as! String
                //monthArray[Int(characters[1])!]
            }
            else{
                /////  str = NSDateFormatter().monthSymbols[Int(s1[1])! - 1]
                let whatmonthisminus:Int = Int(s1[1])! - 1
                print("sau luna e \(Int(s1[1])! - 1)")
                str = MyMonthsNames.object(at: whatmonthisminus) as! String
                //monthArray[Int(s1[1])!]

            }
            //MyMonthsNames
            lblCurrentDate.text = str + " " + s1[2]
            let hebrew: Locale?
            // if language == "he"
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
            {
                // Hebrew, Israel
                hebrew = Locale(identifier: "he_IL")
            }
            else
            {
                hebrew = Locale(identifier: "en_IL")
            }

            //NSHebrewCalendar
            let Mycalendar: Foundation.Calendar = Foundation.Calendar(identifier: .hebrew)
            let dateFormat: DateFormatter = DateFormatter()
            dateFormat.locale = hebrew
            dateFormat.calendar = Mycalendar
            dateFormat.dateStyle = DateFormatter.Style.short
            let dateString: String = dateFormat.string(from: today)
            lblHebrewDate.text = dateString
        }
    }

    @objc func showSync()
    {
        if btnSyn.isCecked == false
        {

            Global.sharedInstance.getEventsFromMyCalendar()
            btnSyn.isCecked = true
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = true//משתנה גלובלי המסמל האם יש סנכרון עם היומן האישי ביומן של הספק
            i = 1
            moneForBackColor = 1
            collDays.reloadData()
        }
        else
        {
            btnSyn.isCecked = false
            Global.sharedInstance.isSyncWithGoogelCalendarSupplier = false
            i = 1
            moneForBackColor = 1
            collDays.reloadData()
        }

    }


    func hidetoast(){
        view.hideToastActivity()
    }




    func magicalend(){

        Global.sharedInstance.getEventsFromMyCalendar()
        Global.sharedInstance.setAllEventsArray()
        changeLblDate()

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

        print("self.arrayWorkers.count \(self.arrayWorkers.count)")
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

                //check if employee has the same working hours of business

                if Global.sharedInstance.FREEDAYSALLWORKERS.count > 0
                {

                    let x = workerid
                    for z in Global.sharedInstance.FREEDAYSALLWORKERS {
                         var WhatEmplyeeArrayFreeDay:Array<Int> = Array<Int>()
                        if let _:NSDictionary = z as? NSDictionary {
                            let a:NSDictionary = z as! NSDictionary
                            if let _:Int = a["WORKERID"] as? Int {
                                let ay =  a["WORKERID"] as! Int
                                if ay  == x {
                                    print("ce e :\(a)")
                                    if let _:Int = a["bSameWH"] as? Int {
                                        let y = a["bSameWH"] as! Int
                                        if  y == 1 {
                                            SameHours = true
                                        } else {
                                            SameHours = false
                                            if let _:NSMutableArray = a["FREEDAYS"] as? NSMutableArray {
                                                let  k = a["FREEDAYS"] as! NSMutableArray
                                                for n in k {
                                                    if !WhatEmplyeeArrayFreeDay.contains(n as! Int) {

                                                        WhatEmplyeeArrayFreeDay.append(n as! Int)
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
                if Global.sharedInstance.FREEDAYSALLCALENDARS.count > 0
                {
                    let x = workerid
                    for z in Global.sharedInstance.FREEDAYSALLCALENDARS {
                         var WhatEmplyeeArrayFreeDay:Array<Int> = Array<Int>()
                        if let _:NSDictionary = z as? NSDictionary {
                            let a:NSDictionary = z as! NSDictionary
                            if let _:Int = a["WORKERID"] as? Int {
                                let ay =  a["WORKERID"] as! Int
                                if ay  == x {
                                    print("ce e :\(a)")
                                    if let _:Int = a["bSameWH"] as? Int {
                                        let y = a["bSameWH"] as! Int
                                        if  y == 1 {
                                            SameHours = true
                                        } else {
                                            SameHours = false
                                            if let _:NSMutableArray = a["FREEDAYS"] as? NSMutableArray {
                                                let  k = a["FREEDAYS"] as! NSMutableArray
                                                for n in k {
                                                    if !WhatEmplyeeArrayFreeDay.contains(n as! Int) {

                                                        WhatEmplyeeArrayFreeDay.append(n as! Int)
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
                print("workerid \(workerid) si \(index)")
                self.selectedWorker = true
                self.selectedWorkerID = index
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

            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.carousel.frame.size.width / 2.4  , height: 55))
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



    func setEventBthereInMonth()
    {
        self.bthereEventDateDayInt = NSMutableArray()
        var orderDetailsObj:OrderDetailsObj =  OrderDetailsObj()
        if Global.sharedInstance.ordersOfClientsArray.count > 0
        {
            for item in Global.sharedInstance.ordersOfClientsArray
            {
                orderDetailsObj = item as  OrderDetailsObj

                if Calendar.sharedInstance.getMonth(orderDetailsObj.dtDateOrder, reduce: 0, add: 0) == Calendar.sharedInstance.getMonth( Calendar.sharedInstance.carrentDate
                    , reduce: 0, add: 0) &&  Calendar.sharedInstance.getYear(orderDetailsObj.dtDateOrder, reduce: 0, add: 0) == Calendar.sharedInstance.getYear( Calendar.sharedInstance.carrentDate
                        , reduce: 0, add: 0)
                {

                    if let myID:Int = Calendar.sharedInstance.getDay(orderDetailsObj.dtDateOrder, reduce: 0, add: 0)  {
                        print("day found \(myID)")
                        print("orderDetailsObj worker \(orderDetailsObj.iProviderUserId)")
                        var workerid:Int = 0
                            if let _:User = self.arrayWorkers[selectedWorkerID] as? User {
                                let MYD:User = self.arrayWorkers[selectedWorkerID] as! User
                                if let _:Int =  MYD.iUserId
                                {
                                    workerid =  MYD.iUserId

                                }
                            }

                            if orderDetailsObj.iProviderUserId == workerid {
                                if !bthereEventDateDayInt.contains(myID) {
                                    bthereEventDateDayInt.add(myID)
                                }
                            }
                        }

                    }
                }

            }

        self.blockHoursEventDateDayInt = NSMutableArray()
        if self.BlockHouresObjArray.count > 0 {
            for itemx in self.BlockHouresObjArray {
                print(Global.sharedInstance.getStringFromDateString(itemx.cDate))
                let blockeddate = Global.sharedInstance.getStringFromDateString(itemx.cDate)
                if Calendar.sharedInstance.getMonth(blockeddate, reduce: 0, add: 0) == Calendar.sharedInstance.getMonth( Calendar.sharedInstance.carrentDate
                    , reduce: 0, add: 0) &&  Calendar.sharedInstance.getYear(blockeddate, reduce: 0, add: 0) == Calendar.sharedInstance.getYear( Calendar.sharedInstance.carrentDate
                        , reduce: 0, add: 0)
                {

                    if let myID:Int = Calendar.sharedInstance.getDay(blockeddate, reduce: 0, add: 0)  {
                        print("blocked day found \(myID)")
                        var workerid:Int = 0

                            if let _:User = self.arrayWorkers[selectedWorkerID] as? User {
                                let MYD:User = self.arrayWorkers[selectedWorkerID] as! User
                                if let _:Int =  MYD.iUserId
                                {
                                    workerid =  MYD.iUserId
                                }
                            }

                                if !blockHoursEventDateDayInt.contains(myID) {
                                    blockHoursEventDateDayInt.add(myID)
                                }
                        }



                    }
                }

        }
        print("bthereEventDateDayInt \(bthereEventDateDayInt.count)")
        if (Global.sharedInstance.isSyncWithGoogelCalendarSupplier/*Global.sharedInstance.currentUser.bIsGoogleCalendarSync*/ == true)
        {
            btnSyn.isCecked = true
            i = 1
            moneForBackColor = 1

                self.collDays.reloadData()

        }
        else
        {
            btnSyn.isCecked = false
            i = 1
            moneForBackColor = 1

                self.collDays.reloadData()

        }
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

        print("Global.sharedInstance.providerID  \(Global.sharedInstance.providerID) ")
        dic["iSupplierId"] = providerID as AnyObject
        self.generic.showNativeActivityIndicator(self)
        var newarray:NSMutableArray = NSMutableArray()
        var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>() //empty first
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
                        let newarray = REZULTATE.mutableCopy() as! NSMutableArray
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
        self.setEventBthereInMonth()
        Global.sharedInstance.setEventsArray()
        changeLblDate()
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




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
