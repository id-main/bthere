//
//  BlockHoursViewController.swift
//  Bthere
//
//  Created by User on 5.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//  ספק קיים חסימת שעות ביומן בהם א״א להזמין תור
class BlockHoursViewController: NavigationModelViewController {
    //NEW DEVELOP
    var wasFinishblock:Bool = false
    var arrayWorkers:NSMutableArray = NSMutableArray()
    var intSuppliersecondID:Int = 0
    var DATEFINALE:NSMutableArray = NSMutableArray()
    var generic:Generic = Generic()
    @IBOutlet weak var btnDay1: UIButton!
    @IBOutlet weak var btnDay2: UIButton!
    @IBOutlet weak var btnDay3: UIButton!
    @IBOutlet weak var btnDay4: UIButton!
    @IBOutlet weak var btnDay5: UIButton!
    @IBOutlet weak var btnDay6: UIButton!
    @IBOutlet weak var btnDay7: UIButton!
    var daybtnarray:Array<UIButton> = Array<UIButton>() //days buttons
    var daysarray:Array<Bool> = Array<Bool>() //can select monday, tw, we...etcs
    @IBOutlet weak var SEL_DAYS_TO_BLOCK: UILabel!
    @IBOutlet weak var ALL_HOURS_OF_DAY: UILabel!
    @IBOutlet weak var btnNoSelect: UIButton!
    @IBOutlet weak var btnYesSelect: UIButton!
    //END NEW DEVELOP
    //JMODE PLUS
    var EMPLOYECURRENT:Int = 0
    var ARIEFINALA: NSMutableArray = []
    var PERMISSIONSArray: NSMutableArray = []
    var DAYSTOSEND:NSMutableArray = NSMutableArray()
    @IBOutlet weak var lblDatefromDateToBlock: UILabel!
    @IBOutlet weak var lblDatetoDateToBlock: UILabel!
    @IBOutlet weak var lblhhoursToBlock: UILabel!
    @IBOutlet weak var lbltitleToBlock: UILabel!
    @IBOutlet weak var lbtitleEndToBlock: UILabel!
    @IBOutlet weak var lbtitlehhours: UILabel!
    @IBOutlet weak var vDatefromToBlock: UIView!
    @IBOutlet weak var vDateendToBlock: UIView!
    @IBOutlet weak var vHHOURSBlock: UIView!
    @IBOutlet weak var dPDatestart: UIDatePicker!
    @IBOutlet weak var dPDateend: UIDatePicker!
    @IBOutlet weak var hhoursCHOOSE: UIDatePicker!
    @IBOutlet weak var viewblack: UIView!
    @IBOutlet weak var hhoursENDCHOOSE: UIDatePicker!
    @IBOutlet weak var btn: UIDatePicker!
    var HOWMANYLEFT:Int = 0
    var ARRAYRESPONSECODES:Array<Int> = Array<Int>()
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var hourstart = ""
    var hourend = ""
    
    @IBOutlet weak var TITLESCREEN: UILabel!
    @IBOutlet weak var BTNBLOCK: UIButton!
    @IBAction func btnSelectDay(_ sender:AnyObject) {
        let neededtag = sender.tag
        daybtnarray[neededtag!].isSelected = !daybtnarray[neededtag!].isSelected
        if daybtnarray[neededtag!].isSelected == true  {
           daybtnarray[neededtag!].backgroundColor =  Colors.sharedInstance.color4
        } else {
           daybtnarray[neededtag!].backgroundColor =  UIColor.darkGray
        }
    }
    @IBAction func btnNoSelect(_ sender: AnyObject) {
        vHHOURSBlock.isUserInteractionEnabled = true
        vHHOURSBlock.backgroundColor = .clear
        btnYesSelect.isSelected = false
        btnNoSelect.isSelected = true
        let oknotselect = UIImage(named: "OK-strock-black")
        let cancelselect = UIImage(named: "Cancel-select.png")
        self.btnNoSelect.setImage(cancelselect, for: UIControl.State())
        self.btnYesSelect.setImage(oknotselect, for: UIControl.State())
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            let calendar = Foundation.Calendar.current
            var components = DateComponents()
            components.hour = 15
            components.minute = 30
            hhoursCHOOSE.setDate(calendar.date(from: components)!, animated: true)
            
            let calendar2 = Foundation.Calendar.current
            var components2 = DateComponents()
            components2.hour = 15
            components2.minute = 00
            hhoursENDCHOOSE.setDate(calendar2.date(from: components2)!, animated: true)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeStyle = .none
            dateFormatter2.dateFormat = "HH:mm"
            hourstart = dateFormatter2.string(from: hhoursCHOOSE.date)
            hourend = dateFormatter2.string(from: hhoursENDCHOOSE.date)
            lblhhoursToBlock.text = "\(hourend)  - \(hourstart)"
        } else {
            let calendar = Foundation.Calendar.current
            var components = DateComponents()
            components.hour = 15
            components.minute = 00
            hhoursCHOOSE.setDate(calendar.date(from: components)!, animated: true)
            
            let calendar2 = Foundation.Calendar.current
            var components2 = DateComponents()
            components2.hour = 15
            components2.minute = 30
            hhoursENDCHOOSE.setDate(calendar2.date(from: components2)!, animated: true)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeStyle = .none
            dateFormatter2.dateFormat = "HH:mm"
            hourstart = dateFormatter2.string(from: hhoursCHOOSE.date)
            hourend = dateFormatter2.string(from: hhoursENDCHOOSE.date)
            lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
        }

    }
    

    @IBAction func btnYesSelect(_ sender: AnyObject) {
        vHHOURSBlock.isUserInteractionEnabled = false
        vHHOURSBlock.backgroundColor = .lightGray
        hhoursCHOOSE.isHidden = true
        hhoursENDCHOOSE.isHidden = true
        viewblack.isHidden = true
        btnYesSelect.isSelected = true
        btnNoSelect.isSelected = false
        let okselect = UIImage(named: "OK-select.png")
        let cancelunselect = UIImage(named: "Cancel_unSelected.png")
        self.btnNoSelect.setImage(cancelunselect, for: UIControl.State())
        self.btnYesSelect.setImage(okselect, for: UIControl.State())
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            let calendar = Foundation.Calendar.current
            var components = DateComponents()
            components.hour = 23
            components.minute = 59
            hhoursCHOOSE.setDate(calendar.date(from: components)!, animated: true)
            
            let calendar2 = Foundation.Calendar.current
            var components2 = DateComponents()
            components2.hour = 00
            components2.minute = 00
            hhoursENDCHOOSE.setDate(calendar2.date(from: components2)!, animated: true)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeStyle = .none
            dateFormatter2.dateFormat = "HH:mm"
            hourstart = dateFormatter2.string(from: hhoursCHOOSE.date)
            hourend = dateFormatter2.string(from: hhoursENDCHOOSE.date)
           lblhhoursToBlock.text = "\(hourend)  - \(hourstart)"
        } else {
            let calendar = Foundation.Calendar.current
            var components = DateComponents()
            components.hour = 00
            components.minute = 00
            hhoursCHOOSE.setDate(calendar.date(from: components)!, animated: true)
            
            let calendar2 = Foundation.Calendar.current
            var components2 = DateComponents()
            components2.hour = 23
            components2.minute = 59
            hhoursENDCHOOSE.setDate(calendar2.date(from: components2)!, animated: true)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeStyle = .none
            dateFormatter2.dateFormat = "HH:mm"
            hourstart = dateFormatter2.string(from: hhoursCHOOSE.date)
            hourend = dateFormatter2.string(from: hhoursENDCHOOSE.date)
            lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
        }

        
    }
    
    @IBAction func btnBLOCK(_ sender: UIButton) {
        print("hourstart \(hourstart)")
        print("hourend \(hourend)")
        DAYSTOSEND = []
        DATEFINALE = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let startdate = dateFormatter.string(from: dPDatestart.date)
        let enddate = dateFormatter.string(from: dPDateend.date)
        var dayclean = dateFormatter.date(from: startdate)
        let endclean = dateFormatter.date(from: enddate)
        
        if lblDatefromDateToBlock.text == "" {
            Alert.sharedInstance.showAlert("ERROR_date_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        if lblDatetoDateToBlock.text == "" {
            Alert.sharedInstance.showAlert("ERROR_date_End".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        if hourstart == "" {
            Alert.sharedInstance.showAlert("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        if hourend == "" {
            Alert.sharedInstance.showAlert("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        let dateFormatters = DateFormatter()
        dateFormatters.timeStyle = .none
        dateFormatters.dateFormat = "HH:mm"
       let hourstartZ =  dateFormatters.string(from:hhoursCHOOSE.date)
        let hoursendZ = dateFormatters.string(from:hhoursENDCHOOSE.date)

        let aDate = hhoursENDCHOOSE.date
        let bDate = hhoursCHOOSE.date
        switch aDate.compare(bDate) {
        case .orderedSame   :
            print("The two dates are the same")
            Alert.sharedInstance.showAlert("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        default:
            print("diff")
        }
    
        if  dayclean! > endclean!  {
            Alert.sharedInstance.showAlert("ERROR_DATE_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
     //       if (hhoursENDCHOOSE.date > hhoursCHOOSE.date) {
            if hoursendZ > hourstartZ {
                Alert.sharedInstance.showAlert("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                return
            }
        } else {
            // Other
        //    if hhoursCHOOSE.date > hhoursENDCHOOSE.date {
            if hourstartZ > hoursendZ  {
                Alert.sharedInstance.showAlert("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                return
            }
        }
        
        
        print("startdate\(startdate) - finalDate\(enddate)")
        var onedateplus = dPDatestart.date
        if dayclean != endclean {
                if !DAYSTOSEND.contains(dPDatestart.date) {
                DAYSTOSEND.add(dPDatestart.date)
            }
            if !DAYSTOSEND.contains(dPDateend.date) {
                DAYSTOSEND.add(dPDateend.date)
            }
        } else {
            if !DAYSTOSEND.contains(dPDatestart.date) {
                DAYSTOSEND.add(dPDatestart.date)
            }
        }
        
        for a in 0..<DAYSTOSEND.count {
            print("mydatetry nice \(DAYSTOSEND[a])")
        }
        // Formatter for //\\printing the date, adjust it according to your needs:
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        let calendar = Foundation.Calendar.current
        while endclean! > onedateplus  {
            // Advance by one day:
            onedateplus = (calendar as NSCalendar).date(byAdding: .day, value: 1, to: onedateplus, options: [])!
           print("oneDate is plus\(onedateplus)")
            
            if !DAYSTOSEND.contains(onedateplus) {
                DAYSTOSEND.add(onedateplus)
            }
        }
// format all date as strings and add to DATEFINALE
        if DAYSTOSEND.count  == 1 {
            let mydatetosend = DAYSTOSEND[0] as! Date
            let formatedstringforserverdate =  Global.sharedInstance.convertNSDateToString(mydatetosend) as AnyObject
            if !DATEFINALE.contains(formatedstringforserverdate) {
                DATEFINALE.add(formatedstringforserverdate)
            }
            
        } else {
        checkifcanselectdays()
        print(daysarray.description)
        for itemx in DAYSTOSEND {
            let mydatetosend:Date = (itemx as? Date)!
            let myComponents = (calendar as NSCalendar).components(.weekday, from: mydatetosend)
            let weekDay = myComponents.weekday
            print("ziua \(itemx) si day in week \(weekDay! as Int)")
            print(daysarray.description)
            var hasdayselected:Bool = false
            for itemz in daybtnarray {
                if itemz.isSelected == true {
                    hasdayselected = true
                    break
            }
            }
            if hasdayselected == false { //no day was clicked so send all to server
                let formatedstringforserverdate =  Global.sharedInstance.convertNSDateToString(mydatetosend) as AnyObject
                if !DATEFINALE.contains(formatedstringforserverdate) {
                    DATEFINALE.add(formatedstringforserverdate)
                }
            } else { //at last one day of week was selected so get those
            for check in daybtnarray {
                if check.isSelected == true {
                let whichindexwasselected = daybtnarray.index(of: check)! + 1
              //  let dayintval = daysarray.index(of: check)! + 1
                    if weekDay == whichindexwasselected {
                        let formatedstringforserverdate =  Global.sharedInstance.convertNSDateToString(mydatetosend) as AnyObject
                        if !DATEFINALE.contains(formatedstringforserverdate) {
                            DATEFINALE.add(formatedstringforserverdate)
                        }
                    }
                }
                }
            }
            }
        }
        for ay in DATEFINALE {
            print("string to send \(ay)")
        }
//NEWDEVELOP
        let calendarx = Foundation.Calendar.current
        print("este sau nu azi: \(calendarx.isDateInToday(dPDatestart.date))")
        if calendarx.isDateInToday(dPDatestart.date) && calendarx.isDateInToday(dPDateend.date) {

        let currentTime = Date()
        let dateFormatterx = DateFormatter()
        dateFormatterx.timeStyle = .none
        dateFormatterx.dateFormat = "HH:mm"
        let interesteddate = dateFormatterx.string(from: currentTime)
        var strtime = ""
        var strendtime = ""
            strendtime = self.hourend
            strtime = self.hourstart
            let hhstartendarraydefault = hoursminutesfromString(hminutes : interesteddate)
            var hhstartendarray = hoursminutesfromString(hminutes: strtime)

            if hhstartendarraydefault.count == 2 && hhstartendarray.count == 2 {
                let hstart = hhstartendarraydefault[0]
                let minstart = hhstartendarraydefault[1]
                let hstartselected = hhstartendarray[0]
                let minstartselected = hhstartendarray[1]
                if hstartselected <= hstart && minstartselected <= minstart {
                    print("no event in the past ")
                    showAlertDelegateX("NO_HOURS_IN_THE_PAST".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return
                }
            }

            hhstartendarray = hoursminutesfromString(hminutes: strendtime)
            if hhstartendarraydefault.count == 2 && hhstartendarray.count == 2 {
                let hstart = hhstartendarraydefault[0]
                let minstart = hhstartendarraydefault[1]
                let hstartselected = hhstartendarray[0]
                let minstartselected = hhstartendarray[1]
                if hstartselected <= hstart && minstartselected <= minstart {
                    print("no event in the past ")
                    showAlertDelegateX("NO_HOURS_IN_THE_PAST".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return
                }
            }

            let alertController = UIAlertController(title: "", message:
                "POP_ALLERT_IN_START_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
            //  alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)


            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alertController.dismiss(animated: true, completion: nil)
                self.AddBlockedHouresToCalendar()

            }


        } else {

        let alertController = UIAlertController(title: "", message:
            "POP_ALLERT_IN_START_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
      //  alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alertController.dismiss(animated: true, completion: nil)
                self.AddBlockedHouresToCalendar()

                }
        }

    }

    //    START_DATE = "תאריך התחלה";
    //    END_DATE = "תאריך סיום";
    //    HHOURS = "שעות";
    //    BTNBLOCK = "לַחסוֹם";
    
    func rereadcalendar() {
         self.generic.hideNativeActivityIndicator(self)
//        let displayedwindows = UIApplication.shared.keyWindow
//        for subview in displayedwindows!.subviews as [UIView] {
//            if let alertvisible = subview as? UIAlertController {
//                alertvisible.dismiss(animated: false, completion: nil)
//            }
//        }

        Global.sharedInstance.isProvider = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        let viewCon = SupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as!  CalendarSupplierViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        frontViewController.pushViewController(viewCon, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        if self.wasFinishblock == false {
        self.dismiss(animated: true, completion: nil)
        } else { //reread calendar
            self.dismiss(animated: true, completion: {
           self.rereadcalendar()
            })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:33)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GetSecondUserIdByFirstUserIdFour()
        for view in hhoursCHOOSE.subviews {
            let USERDEF = UserDefaults.standard
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                view.semanticContentAttribute = .forceRightToLeft
                
            } else {
                //this must fix uipicker being flipped
                view.semanticContentAttribute = .forceLeftToRight
            }
        }
        for view in hhoursENDCHOOSE.subviews {
            let USERDEF = UserDefaults.standard
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                view.semanticContentAttribute = .forceRightToLeft
                
            } else {
                //this must fix uipicker being flipped
                view.semanticContentAttribute = .forceLeftToRight
            }
        }

        DAYSTOSEND =  NSMutableArray()
        DAYSTOSEND = []
        DATEFINALE =  NSMutableArray()
        DATEFINALE = []
        self.TITLESCREEN.text = "BLOCK_HOURS_PLUSMENU_caps".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.SEL_DAYS_TO_BLOCK.text = "SEL_DAYS_TO_BLOCK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.ALL_HOURS_OF_DAY.text = "ALL_HOURS_OF_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.lblDatefromDateToBlock.text = ""
        self.lblDatetoDateToBlock.text = ""
        self.lblhhoursToBlock.text = ""
        self.lbltitleToBlock.text = "START_DATE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.lbtitleEndToBlock.text = "END_DATE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.lbtitlehhours.text = "HHOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.BTNBLOCK.setTitle("BTNBLOCK".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay1.setTitle("SUNDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay2.setTitle("MONDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay3.setTitle("TUESDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay4.setTitle("WEDNSDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay5.setTitle("THIRTHDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay6.setTitle("FRIDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay7.setTitle("SHABAT2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        daybtnarray = [btnDay1,btnDay2,btnDay3,btnDay4,btnDay5,btnDay6,btnDay7]
        daysarray = [false, false,false,false,false,false,false]
        dPDatestart.isHidden = true
        dPDateend.isHidden = true
        hhoursCHOOSE.locale = Locale(identifier: "en_GB")
        hhoursENDCHOOSE.locale = Locale(identifier: "en_GB")
        hhoursCHOOSE.isHidden = true
        hhoursENDCHOOSE.isHidden = true
        viewblack.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BlockHoursViewController.openDatestart))
        vDatefromToBlock.addGestureRecognizer(tap)
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BlockHoursViewController.openDateend))
        vDateendToBlock.addGestureRecognizer(tap1)
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BlockHoursViewController.openHHOURS))
        vHHOURSBlock.addGestureRecognizer(tap2)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dPDatestart.backgroundColor = Colors.sharedInstance.color1
        dPDatestart.setValue(UIColor.white, forKeyPath: "textColor")
        dPDatestart.setValue(false, forKey: "highlightsToday")
        dPDatestart.date = Date()
        dPDateend.minimumDate = Date()
        dPDateend.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .year, value: 2, to: Date(), options: [])
        lblDatefromDateToBlock.text = dateFormatter.string(from: dPDatestart.date)
        dPDateend.backgroundColor = Colors.sharedInstance.color1
        dPDateend.setValue(UIColor.white, forKeyPath: "textColor")
        dPDateend.setValue(false, forKey: "highlightsToday")
        dPDateend.date = dPDatestart.date
        lblDatetoDateToBlock.text = dateFormatter.string(from: dPDateend.date)
        hhoursCHOOSE.backgroundColor = Colors.sharedInstance.color1
        hhoursCHOOSE.setValue(UIColor.white, forKeyPath: "textColor")
        hhoursCHOOSE.setValue(false, forKey: "highlightsToday")
        hhoursENDCHOOSE.backgroundColor = Colors.sharedInstance.color1
        hhoursENDCHOOSE.setValue(UIColor.white, forKeyPath: "textColor")
        hhoursENDCHOOSE.setValue(false, forKey: "highlightsToday")
        dPDatestart.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        dPDatestart.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        dPDateend.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        dPDateend.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        hhoursCHOOSE.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        hhoursCHOOSE.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        hhoursENDCHOOSE.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        hhoursENDCHOOSE.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        // If Hebrew flip rollers
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            let calendar = Foundation.Calendar.current
            var components = DateComponents()
            components.hour = 15
            components.minute = 30
            hhoursCHOOSE.setDate(calendar.date(from: components)!, animated: true)
            
            let calendar2 = Foundation.Calendar.current
            var components2 = DateComponents()
            components2.hour = 15
            components2.minute = 00
            hhoursENDCHOOSE.setDate(calendar2.date(from: components2)!, animated: true)
        } else {
            let calendar = Foundation.Calendar.current
            var components = DateComponents()
            components.hour = 15
            components.minute = 00
            hhoursCHOOSE.setDate(calendar.date(from: components)!, animated: true)
            
            let calendar2 = Foundation.Calendar.current
            var components2 = DateComponents()
            components2.hour = 15
            components2.minute = 30
            hhoursENDCHOOSE.setDate(calendar2.date(from: components2)!, animated: true)
        }
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            dPDatestart.locale = Locale(identifier: "he_IL")
            dPDateend.locale = Locale(identifier: "he_IL")
            SEL_DAYS_TO_BLOCK.textAlignment = .right
            ALL_HOURS_OF_DAY.textAlignment = .right
            lblDatefromDateToBlock.textAlignment = .right
            lblDatetoDateToBlock.textAlignment = .right
            lblhhoursToBlock.textAlignment = .right
            lbltitleToBlock.textAlignment = .right
            lbtitleEndToBlock.textAlignment = .right
            lbtitlehhours.textAlignment = .right
            
        } else {
            // English
            dPDatestart.locale = Locale(identifier: "en_GB")
            dPDateend.locale = Locale(identifier: "en_GB")
            SEL_DAYS_TO_BLOCK.textAlignment = .left
            ALL_HOURS_OF_DAY.textAlignment = .left
            lblDatefromDateToBlock.textAlignment = .left
            lblDatetoDateToBlock.textAlignment = .left
            lblhhoursToBlock.textAlignment = .left
            lbltitleToBlock.textAlignment = .left
            lbtitleEndToBlock.textAlignment = .left
            lbtitlehhours.textAlignment = .left
        }
      
       let oknotselect = UIImage(named: "OK-strock-black")
       let cancelselect = UIImage(named: "Cancel-select.png")
        self.btnNoSelect.setImage(cancelselect, for: UIControl.State())
        self.btnYesSelect.setImage(oknotselect, for: UIControl.State())
        self.btnNoSelect.isSelected = true
        self.btnYesSelect.isSelected = false

        


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func resetalldata() {
        lblDatefromDateToBlock.text = ""
        lblhhoursToBlock.text = ""
        lblDatetoDateToBlock.text = ""
        dPDatestart.date = Date()
        dPDateend.date = dPDatestart.date
        let oknotselect = UIImage(named: "OK-strock-black")
        let cancelselect = UIImage(named: "Cancel-select.png")
        self.btnNoSelect.setImage(cancelselect, for: UIControl.State())
        self.btnYesSelect.setImage(oknotselect, for: UIControl.State())
        self.btnNoSelect.isSelected = true
        self.btnYesSelect.isSelected = false
        checkifcanselectdays()
        self.btnNoSelect(btnNoSelect)
        
    }
    // MARK: - DatePicker
    func comparedate(_ datecurrentday:Date){
        
    }
    func checkifcanselectdays(){
        var sameHours:Int = 0
        print("Global.sharedInstance.FREEDAYSALLWORKERS: \(Global.sharedInstance.FREEDAYSALLWORKERS)")
        print("Global.sharedInstance.NOWORKINGDAYS: \(Global.sharedInstance.NOWORKINGDAYS)")
        //check if employee has the same working hours of business
        var WhatEmplyeeArrayFreeDay:Array<Int> = Array<Int>()
        if Global.sharedInstance.FREEDAYSALLWORKERS.count > 0
        {
           let x = self.intSuppliersecondID
            for z in Global.sharedInstance.FREEDAYSALLWORKERS {
                if let _:NSDictionary = z as? NSDictionary {
                    let a:NSDictionary = z as! NSDictionary
                    if let _:Int = a["WORKERID"] as? Int {
                    let ay =  a["WORKERID"] as! Int

                if ay  == x {
                    print("ce e :\(a)")
                    if let _:Int = a["bSameWH"] as? Int {
                        let y = a["bSameWH"] as! Int
                        if  y == 1 {
                        sameHours = 1


                } else {

                    sameHours = 0
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


        self.generic.showNativeActivityIndicator(self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let startdate = dateFormatter.string(from: dPDatestart.date)
        let daycompare = dateFormatter.date(from: startdate)
        let todayDate = dateFormatter.string(from: dPDateend.date)
        let daycomparetoday = dateFormatter.date(from: todayDate)
        if (daycomparetoday! as NSDate).timeIntervalSince(daycompare!).sign == .minus || startdate == todayDate {
                for item in daybtnarray {
                item.isUserInteractionEnabled = false
                item.backgroundColor = .clear
                item.setBackgroundImage(UIImage(named: "patrat.png"), for: UIControl.State())
                item.alpha = 1.0
                item.titleLabel?.textColor = .black
                item.setTitleColor(UIColor.darkGray, for: .normal)
                }
        } else {
            var DAYCLICKABLE:NSMutableArray = NSMutableArray()
            var FINALSTRINSDAYCLICKABLE:NSMutableArray = NSMutableArray()
            var allWeekDaysPosibble:Array<Int> = Array<Int>()
            DAYCLICKABLE = []
            var oneDate = dPDatestart.date
            var finalDate = dPDateend.date
           
            if oneDate != finalDate {
                    if !DAYCLICKABLE.contains(oneDate) {
                    DAYCLICKABLE.add(oneDate)
                }
                if !DAYCLICKABLE.contains(finalDate) {
                    DAYCLICKABLE.add(finalDate)
                }
            }
            let calendar = Foundation.Calendar.current
            while finalDate > oneDate   {
                // Advance by one day:
                oneDate = (calendar as NSCalendar).date(byAdding: .day, value: 1, to: oneDate, options: [])!
             print("oneDate is plus\(oneDate)")
                    if !DAYCLICKABLE.contains(oneDate) {
                        let myComponents = (calendar as NSCalendar).components(.weekday, from: oneDate)
                        let weekDay = myComponents.weekday

                        //    case 1
                        if sameHours == 1 {
                        if Global.sharedInstance.NOWORKINGDAYS.count == 0 {
                            DAYCLICKABLE.add(oneDate)
                        } else {
                        for i in Global.sharedInstance.NOWORKINGDAYS {
                            if weekDay == i as! Int{
                                //nothing

                            } else {
                               DAYCLICKABLE.add(oneDate)

                            }
                        }
                        }
                        } else {
                            //case 2
                            if WhatEmplyeeArrayFreeDay.count == 0 {
                                DAYCLICKABLE.add(oneDate)
                            } else {
                                for i in WhatEmplyeeArrayFreeDay {
                                    if weekDay == i {
                                        //nothing

                                    } else {
                                        DAYCLICKABLE.add(oneDate)

                                    }
                                }
                            }
                        }

                }
            }
            let fmt = DateFormatter()
            fmt.dateFormat = "dd/MM/yyyy"
            for itemx in DAYCLICKABLE {
                let myx:Date = (itemx as? Date)!
                let adate = fmt.string(from: myx)
                if !FINALSTRINSDAYCLICKABLE.contains(adate) {
                    FINALSTRINSDAYCLICKABLE.add(adate)
                }
                let myComponents = (calendar as NSCalendar).components(.weekday, from: myx)
                let weekDay = myComponents.weekday
                print("ziua \(itemx) si day in week \(weekDay! as Int)")
                allWeekDaysPosibble.append(weekDay! as Int)
            }
            print(allWeekDaysPosibble)
              var finalallWeekDaysPosibble:Array<Int> = Array<Int>()
            for i in 0..<allWeekDaysPosibble.count {
                let z = allWeekDaysPosibble[i]
                //case 1
                if sameHours == 1 {
                if  Global.sharedInstance.NOWORKINGDAYS.contains(z) {
                //nothing
                } else {
                    if   !finalallWeekDaysPosibble.contains(z) {
                        finalallWeekDaysPosibble.append(z)
                    }
                }

                } else {
                    //case 2
                    if  WhatEmplyeeArrayFreeDay.contains(z) {
                        //nothing
                    } else {
                        if   !finalallWeekDaysPosibble.contains(z) {
                            finalallWeekDaysPosibble.append(z)
                        }
                    }

                }
            }
            daysarray = [false, false,false,false,false,false,false]
            print("finalallWeekDaysPosibble \(finalallWeekDaysPosibble)")
            for item in finalallWeekDaysPosibble {
                switch(item) {
                case 1:
                    daysarray[0] = true
                    break
                case 2:
                    daysarray[1] = true
                    break
                case 3:
                    daysarray[2] = true
                    break
                case 4:
                    daysarray[3] = true
                    break
                    case 5:
                    daysarray[4] = true
                    break
                    case 6:
                    daysarray[5] = true
                    break
                    case 7:
                    daysarray[6] = true
                    break
                    default:
                    print("l")
                }
            }
            for item in daybtnarray {
                let indexOf = daybtnarray.index(of: item)
                if daysarray[indexOf!] == true {
                item.isUserInteractionEnabled = true
                item.backgroundColor = .clear
                item.setImage(nil, for: UIControl.State())
                item.titleLabel?.textColor = UIColor.white
                item.setTitleColor(UIColor.white, for: .normal)
                item.alpha = 1.0
                item.backgroundColor =  UIColor.darkGray
                item.setBackgroundImage(UIImage(named: "patrat.png"), for: UIControl.State())
                } else {
                    //there are no mondays etc in interval so cannot be selected at all
                    item.isUserInteractionEnabled = false
                    item.backgroundColor = .clear
                    item.setBackgroundImage(UIImage(named: "hash anca.png"), for: UIControl.State())
                    item.alpha = 1.0
                    item.titleLabel?.textColor = .black
                    item.setTitleColor(UIColor.darkGray, for: .normal)
                }
            
            }
        }
         self.generic.hideNativeActivityIndicator(self)
    }
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        if sender == dPDatestart {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let someDate = dateFormatter.string(from: sender.date)
            let daycompare = dateFormatter.date(from: someDate)
            let todayDate = dateFormatter.string(from: Date())
            let daycomparetoday = dateFormatter.date(from: todayDate)
            
            if (daycompare! as NSDate).timeIntervalSince(daycomparetoday!).sign == .minus {
                //someDate is berofe than today
                Alert.sharedInstance.showAlert("DAY_PASSED_BLOCK".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                dPDatestart.date = Date()
                lblDatefromDateToBlock.text = dateFormatter.string(from: dPDatestart.date)
            } else {
                //someDate is equal or after than today
                lblDatefromDateToBlock.text = dateFormatter.string(from: sender.date)
            }
        }
        if sender == dPDateend  {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let someDate = dateFormatter.string(from: sender.date)
            let daycompare = dateFormatter.date(from: someDate)
            let todayDate = dateFormatter.string(from: Date())
            let daycomparetoday = dateFormatter.date(from: todayDate)
            
            if (daycompare! as NSDate).timeIntervalSince(daycomparetoday!).sign == .minus {
                //someDate is berofe than today
                Alert.sharedInstance.showAlert("DAY_PASSED_BLOCK".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                dPDateend.date = Date()
                lblDatetoDateToBlock.text = dateFormatter.string(from: dPDateend.date)
            } else {
                //someDate is equal or after than today
                lblDatetoDateToBlock.text = dateFormatter.string(from: sender.date)
            }
        }
        
        // Start hours
        if sender == hhoursCHOOSE  {
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                // Hebrew language
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                hourend =  dateFormatter.string(from: sender.date)
                hourstart = dateFormatter.string(from: hhoursENDCHOOSE.date)
                
                let interval = hhoursCHOOSE.date.timeIntervalSince(hhoursENDCHOOSE.date) / 60
                
                
                if (hourstart == hourend || interval < 30.0) {
                    let calendar = Foundation.Calendar.current
                    let date = (calendar as NSCalendar).date(byAdding: .minute, value: -30, to: hhoursCHOOSE.date, options: [])
                    hhoursENDCHOOSE.setDate(date!, animated: true)
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.timeStyle = .none
                    dateFormatter2.dateFormat = "HH:mm"
                    hourstart = dateFormatter2.string(from: hhoursENDCHOOSE.date)
                    
                    lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
                } else {
                    lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
                }
                
                print ("hourstart: \(hourstart)")
                print ("hourend: \(hourend)")
                print("minutes \(interval)")
                
            } else {
                // Other language
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                hourstart =  dateFormatter.string(from: sender.date)
                hourend =  dateFormatter.string(from: hhoursENDCHOOSE.date)
                
                let interval = hhoursENDCHOOSE.date.timeIntervalSince(hhoursCHOOSE.date) / 60
                print("minutes \(interval)")
                
                if (hourstart == hourend || interval < 30.0) {
                    let calendar = Foundation.Calendar.current
                    let date = (calendar as NSCalendar).date(byAdding: .minute, value: 30, to: hhoursCHOOSE.date, options: [])
                    hhoursENDCHOOSE.setDate(date!, animated: true)
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.timeStyle = .none
                    dateFormatter2.dateFormat = "HH:mm"
                    hourend = dateFormatter2.string(from: hhoursENDCHOOSE.date)
                    
                    lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
                } else {
                    lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
                }
                
                print ("hourstart: \(hourstart)")
                print ("hourend: \(hourend)")
                print("minutes \(interval)")
                
            }
        }
        
        // End hours
        if sender == hhoursENDCHOOSE  {
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                // Hebrew language
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                hourstart = dateFormatter.string(from: sender.date)
                hourend = dateFormatter.string(from: hhoursCHOOSE.date)
                
                let interval = hhoursCHOOSE.date.timeIntervalSince(hhoursENDCHOOSE.date) / 60
                print("minutes \(interval)")
                
                if (hourstart == hourend || interval < 30.0) {
                    let calendar = Foundation.Calendar.current
                    let date = (calendar as NSCalendar).date(byAdding: .minute, value: 30, to: hhoursENDCHOOSE.date, options: [])
                    hhoursCHOOSE.setDate(date!, animated: true)
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.timeStyle = .none
                    dateFormatter2.dateFormat = "HH:mm"
                    hourend = dateFormatter2.string(from: hhoursCHOOSE.date)
                    lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
                } else {
                    lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
                }
                
                print ("hourstart: \(hourstart)")
                print ("hourend: \(hourend)")
                print("minutes \(interval)")
                
            } else {
                // Other language
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                hourend = dateFormatter.string(from: sender.date)
                hourstart = dateFormatter.string(from: hhoursCHOOSE.date)
                
                let interval = hhoursENDCHOOSE.date.timeIntervalSince(hhoursCHOOSE.date) / 60
                print("minutes \(interval)")
                
                if (hourstart == hourend || interval < 30.0) {
                    let calendar = Foundation.Calendar.current
                    let date = (calendar as NSCalendar).date(byAdding: .minute, value: -30, to: hhoursENDCHOOSE.date, options: [])
                    hhoursCHOOSE.setDate(date!, animated: true)
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.timeStyle = .none
                    dateFormatter2.dateFormat = "HH:mm"
                    hourstart = dateFormatter2.string(from: hhoursCHOOSE.date)
                    lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
                } else {
                    lblhhoursToBlock.text = "\(hourstart) - \(hourend)"
                }
                
                print ("hourstart: \(hourstart)")
                print ("hourend: \(hourend)")
                print("minutes \(interval)")
                
            }
        }
        checkifcanselectdays()
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        
    }
    
    
    // Open/close hours
    @objc func openHHOURS() {
          self.view.endEditing(true)
        // Other language
        dPDatestart.isHidden = true
        dPDateend.isHidden = true
        
        if (hhoursCHOOSE.isHidden == true && hhoursENDCHOOSE.isHidden == true) {
            // Open
            hhoursCHOOSE.isHidden = false
            hhoursENDCHOOSE.isHidden = false
            viewblack.isHidden = false
        } else {
            // False
            hhoursCHOOSE.isHidden = true
            hhoursENDCHOOSE.isHidden = true
            viewblack.isHidden = true
        }
        
    }
    
    
    // Open/close start date
    @objc func openDatestart() {
          self.view.endEditing(true)
        // Other
        hhoursCHOOSE.isHidden = true
        hhoursENDCHOOSE.isHidden = true
        dPDateend.isHidden = true
        viewblack.isHidden = true
        
        if (dPDatestart.isHidden == true) {
            dPDatestart.isHidden = false
        } else {
            dPDatestart.isHidden = true
        }
        
    }
    
    
    // Open/close end date
    @objc func openDateend() {
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            
            dPDatestart.isHidden = true
            
            
            if (dPDateend.isHidden == true) {
                dPDateend.isHidden = false
            } else {
                dPDateend.isHidden = true
            }
        } else {
            // Other
            hhoursCHOOSE.isHidden = true
            hhoursENDCHOOSE.isHidden = true
            dPDatestart.isHidden = true
            viewblack.isHidden = true
            
            if (dPDateend.isHidden == true) {
                dPDateend.isHidden = false
            } else {
                dPDateend.isHidden = true
            }
        }
    }


    func sendMultipleOrderBlock(_ selecteddate:Date) {
        var iProviderServiceId:Array<Int> = Array<Int>()
        iProviderServiceId = []
        let i:Int = 0
        iProviderServiceId.append(i)
        
        var supplierID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                supplierID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            supplierID = Global.sharedInstance.providerID
        }
        var y:Int = 0
        if Global.sharedInstance.arrayGiveServicesKods.count > 0 {
            y = Global.sharedInstance.arrayGiveServicesKods[0]
        }
        EMPLOYECURRENT = y
        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        let styler = DateFormatter()
        styler.dateFormat = "yyyy-MM-dd"
        dicOrderObj["dtDateOrder"] = Global.sharedInstance.convertNSDateToString(selecteddate) as AnyObject
         if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            dicOrderObj["nvFromHour"] = self.hourend as AnyObject
            dicOrderObj["nvToHour"] = self.hourstart as AnyObject
         } else {
        dicOrderObj["nvFromHour"] = self.hourstart as AnyObject
        dicOrderObj["nvToHour"] = self.hourend as AnyObject
        }
        dicOrderObj["iSupplierId"] = supplierID as AnyObject
        dicOrderObj["iSupplierUserId"] = y as AnyObject
        api.sharedInstance.PREETYJSON_J(dicOrderObj, pathofweb: "sometest")
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            HOWMANYLEFT = HOWMANYLEFT - 1
            ARRAYRESPONSECODES.append(-1)
            self.generic.hideNativeActivityIndicator(self)
            if HOWMANYLEFT == 0 {
                self.parseResponseCodes()
            }
            
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            //-3 -> does not block nothing,  -2 -> partial -1 -> fail of server 1-> full succes
            api.sharedInstance.BlockHoursForSupplierByEmployeeIdWithTimeInterval(dicOrderObj,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in        //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                self.generic.hideNativeActivityIndicator(self)
                self.HOWMANYLEFT = self.HOWMANYLEFT - 1
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    let X = RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int
                    self.ARRAYRESPONSECODES.append(X)
                }
                if  self.HOWMANYLEFT == 0 {
                    self.parseResponseCodes()
                }
                }
            },failure:
                {
                    (AFHTTPRequestOperation, Error) -> Void in
                    self.HOWMANYLEFT = self.HOWMANYLEFT - 1
                    self.ARRAYRESPONSECODES.append(-1)
                    self.generic.hideNativeActivityIndicator(self)
                    if  self.HOWMANYLEFT == 0 {
                        self.parseResponseCodes()
                    }
            })
        }
    }
    func parseResponseCodes() {
        if (!ARRAYRESPONSECODES.contains(1) && !ARRAYRESPONSECODES.contains(-2)) {
            Alert.sharedInstance.showAlert("ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        } else
            
            if (!ARRAYRESPONSECODES.contains(-1) && !ARRAYRESPONSECODES.contains(-3) && !ARRAYRESPONSECODES.contains(-2)) {
                if ARRAYRESPONSECODES.contains(1) {
                    Alert.sharedInstance.showAlert("FULL_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                }
            } else
                  if (ARRAYRESPONSECODES.contains(-1) || ARRAYRESPONSECODES.contains(-3)) {
                    if (ARRAYRESPONSECODES.contains(-2) || ARRAYRESPONSECODES.contains(1)) {
                        Alert.sharedInstance.showAlert("SOME_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    }
        }
        print("ARRAYRESPONSECODES \(ARRAYRESPONSECODES)")
        self.resetalldata()
    }
    //NEWDEVELOP
   /*
 {
    "iProviderUserId" : 12036,
    "dtDates": [
    "/Date(1526947200000)/",
    "/Date(1527033600000)/",
    "/Date(1527552000000)/"
    ],
    "nvBlockedFrom" : "16:00",
    "nvBlockedTo" : "17:00"
    }
 */
    func hidetoast(){
        view.hideToastActivity()
    }
    func AddBlockedHouresToCalendar() {
        let calendar = Foundation.Calendar.current
        print("este sau nu azi: \(calendar.isDateInToday(dPDatestart.date))")

        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
       // try to find which employee am I
       // workerid
        self.generic.showNativeActivityIndicator(self)
        dicOrderObj["iProviderUserId"] = self.intSuppliersecondID as AnyObject
        dicOrderObj["dtDates"] = self.DATEFINALE as AnyObject
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            dicOrderObj["nvBlockedFrom"] = self.hourend as AnyObject
            dicOrderObj["nvBlockedTo"] = self.hourstart as AnyObject
         } else {
        dicOrderObj["nvBlockedFrom"] = self.hourstart as AnyObject
        dicOrderObj["nvBlockedTo"] = self.hourend as AnyObject
        }
        api.sharedInstance.PREETYJSON_J(dicOrderObj, pathofweb: "AddBlockedHouresToCalendar DICTIONARY")
       
        if Reachability.isConnectedToNetwork() == false
        {
           self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            
         //    self.generic.showNativeActivityIndicator(self)
            //-3 -> does not block nothing,  -2 -> partial -1 -> fail of server 1-> full succes
            api.sharedInstance.AddBlockedHouresToCalendar(dicOrderObj,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in       //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
               self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print(responseObject)


                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            //server fail
                             self.wasFinishblock = false
                            self.resetalldata()
                            let alertController = UIAlertController(title: "", message:
                                "ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                            self.rereadcalendar()
                                        })
                                    })
                                })
                            }


                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            //full succes
                            self.resetalldata()
                            self.wasFinishblock = true
                            let alertController = UIAlertController(title: "", message:
                                "FULL_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                            self.rereadcalendar()
                                        })
                                    })
                                })
                            }



                            
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2
                        {
                            //partial
                            self.resetalldata()
                            self.wasFinishblock = true
                            let alertController = UIAlertController(title: "", message:
                                "SOME_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                            self.rereadcalendar()
                                        })
                                    })
                                })
                            }

                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            //zero minutes
                             self.generic.hideNativeActivityIndicator(self)
                            self.resetalldata()
                            self.wasFinishblock = false
                            let alertController = UIAlertController(title: "", message:
                                "SOME_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                            self.rereadcalendar()
                                        })
                                    })
                                })
                            }

                        }
                       
                    }
                }
                
            },failure:
                {
                    (AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    self.resetalldata()
                    self.wasFinishblock = false
                    let alertController = UIAlertController(title: "", message:
                        "ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                    self.present(alertController, animated: true, completion: nil)
                    let when = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: when){
                        alertController.dismiss(animated: true, completion: {
                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                self.dismiss(animated: false, completion: {
                                    self.rereadcalendar()
                                })
                            })
                        })
                    }



            })
        }
    }
    //0 get second id
    func GetSecondUserIdByFirstUserIdFour()  {
        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var y:Int = 0
        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
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
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.setupISupplierSecondID(0)
                })
            }
        }


    }

    func setupISupplierSecondID (_ ISupplierSecondID:Int){
        self.intSuppliersecondID = ISupplierSecondID
        print("self.intSuppliersecondID \(self.intSuppliersecondID)")
        if ISupplierSecondID == 0 {
            if Global.sharedInstance.giveServicesArray.count > 0
            {

                let myowner = Global.sharedInstance.giveServicesArray[0]
                Global.sharedInstance.defaults.setValue(myowner.iUserId , forKey: "idSupplierWorker")
                self.intSuppliersecondID = myowner.iUserId
                Global.sharedInstance.defaults.synchronize()
            }
        }
        checkifcanselectdays()
    }

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


    
//    let delucru:NSMutableArray =  Global.sharedInstance.FREEDAYSALLWORKERS
//    for item in delucru {
//    if let _:NSDictionary = item as? NSDictionary {
//    let workerdic:NSDictionary = item as! NSDictionary
//    let diciuserid:Int = workerdic["WORKERID"] as! Int
//    let iuseridselect:Int = Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")
//    if diciuserid == iuseridselect {
//    if let _ = workerdic["bSameWH"] as? Int {
//    let whatint =  workerdic["bSameWH"] as! Int
//    if whatint == 1 {
//    if Global.sharedInstance.NOWORKINGDAYS.contains(dayWeek) &&  HasEvent == false {
//
//    self.patternImg.image = UIImage(named: "hash anca.png")!
//    } else {
//
//    self.patternImg.image = nil
//    }
//    }
//    else {
//    let FREEDAYS:NSArray = workerdic["FREEDAYS"] as! NSArray
//    if   FREEDAYS.contains(dayWeek) &&  HasEvent == false {
//    self.patternImg.image = UIImage(named: "hash anca.png")!
//    } else {
//    self.patternImg.image = nil
//    }
//    }
//    }
//    else {
//    let FREEDAYS:NSArray = workerdic["FREEDAYS"] as! NSArray
//    if   FREEDAYS.contains(dayWeek) &&  HasEvent == false {
//    self.patternImg.image = UIImage(named: "hash anca.png")!
//    } else {
//    self.patternImg.image = nil
//    }
//    }
//    break
//    }
//    }
//    }
//    func sendOrderBlock(_ selecteddate:Date) {
//        var iProviderServiceId:Array<Int> = Array<Int>()
//        iProviderServiceId = []
//        let i:Int = 0
//        iProviderServiceId.append(i)
//
//        var supplierID:Int = 0
//        if Global.sharedInstance.providerID == 0 {
//            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
//                supplierID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//            }
//        } else {
//            supplierID = Global.sharedInstance.providerID
//        }
//        var y:Int = 0
//        if Global.sharedInstance.arrayGiveServicesKods.count > 0 {
//            y = Global.sharedInstance.arrayGiveServicesKods[0]
//        }
//        EMPLOYECURRENT = y
//        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        let styler = DateFormatter()
//        styler.dateFormat = "yyyy-MM-dd"
//        dicOrderObj["dtDateOrder"] = Global.sharedInstance.convertNSDateToString(selecteddate) as AnyObject
//        dicOrderObj["nvFromHour"] = self.hourstart as AnyObject
//        dicOrderObj["nvToHour"] = self.hourend as AnyObject
//        dicOrderObj["iSupplierId"] = supplierID as AnyObject
//        dicOrderObj["iSupplierUserId"] = y as AnyObject
//        api.sharedInstance.PREETYJSON_J(dicOrderObj, pathofweb: "sometest")
//        // print("dicOrderObj \(dicOrderObj)")
//        self.generic.showNativeActivityIndicator(self)
//        if Reachability.isConnectedToNetwork() == false
//        {
//            self.generic.hideNativeActivityIndicator(self)
//            //            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//        }
//        else
//        {
//            //-3 -> does not block nothing,  -2 -> partial -1 -> fail of server 1-> full succes
//            api.sharedInstance.BlockHoursForSupplierByEmployeeIdWithTimeInterval(dicOrderObj,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in       //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
//                self.generic.hideNativeActivityIndicator(self)
//                if let _ = responseObject as? Dictionary<String,AnyObject> {
//                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                    print(responseObject)
//                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//
//                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
//                        {
//                            //server fail
//                            Alert.sharedInstance.showAlert("ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//
//                        }
//                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
//                        {
//                            //full succes
//                            Alert.sharedInstance.showAlert("FULL_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                            self.resetalldata()
//
//                        }
//                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2
//                        {
//                            //partial
//                            Alert.sharedInstance.showAlert("SOME_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//
//                        }
//                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
//                        {
//                            //zero minutes
//                            Alert.sharedInstance.showAlert("ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//
//                        }
//                    }
//                }
//
//            },failure:
//                {
//                    (AFHTTPRequestOperation, Error) -> Void in
//
//                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
//            })
//        }
//    }


    //END JMODE
}

extension Array where Element : Hashable {
    var uniqueDAYS: [Element] {
        return Array(Set(self))
    }
}
extension UIAlertController {

    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        self.view.tag = 34000
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
    func SELFremoveFromParent() {
        self.view.isHidden = true
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.viewWithTag(34000)?.removeFromSuperview()
        
    }

}
