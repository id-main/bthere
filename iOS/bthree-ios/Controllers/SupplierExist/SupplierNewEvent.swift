//
//  SupplierNewEvent.swift
//  BThere
//
//  Created by Eduard Stefanescu on 8/28/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import MediaAccessibility

class SupplierNewEvent: NavigationModelViewController, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    // UI Outlets
    var delegatereload:reloadcalendardelegate!=nil
    var intSuppliersecondID:Int = 0
    @IBOutlet weak var popoutView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var dateErrorLabel: UILabel!
    @IBOutlet weak var timeErrorLabel: UILabel!
    @IBOutlet weak var notesErrorLabel: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UILabel!
    @IBOutlet weak var timeTextField: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var makeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var checkButton: CheckBoxNewEventSupplierOk!
    @IBOutlet weak var dPDatestart: UIDatePicker!
    @IBOutlet weak var hhoursCHOOSE: UIDatePicker!
    @IBOutlet weak var hhoursENDCHOOSE: UIDatePicker!
    @IBOutlet weak var viewblack: UIView!
    
    
    // Variables
    var eventNameValue: String!
    var eventDateValue: String!
    var eventTimeValue: String!
    var eventNotesValue: String!
    var eventNameStatus: Bool = false
    var eventNotesStatus: Bool = false
    var hourstart = ""
    var hourend = ""
    var dicEvent:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    var isFirstTimeDate: Bool = true
    var isFirstTimeHours: Bool = true
    
    // Constants
    let dateFormatt:DateFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    let defaultTimeHour = DateFormatter()
    var generic:Generic = Generic()
    // Causes the TextFields to resign the first responder status.
    @objc func endedit(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:32)
        
        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0
        {
            if Global.sharedInstance.employeesPermissionsArray.contains(5) == false
            {
                checkButton.isHidden = true
                checkButton.isUserInteractionEnabled = false
                checkLabel.isHidden = true
            }
            else
            {
                checkButton.isHidden = false
                checkButton.isUserInteractionEnabled = true
                checkLabel.isHidden = false
            }
        }
    }
    //0 get second id
    func GetSecondUserIdByFirstUserIdFive()  {
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

                })
            }
        }


    }
    // Main function
    override func viewDidLoad() {
        super.viewDidLoad()
       


     //   tryGetSupplierCustomerUserIdByEmployeeId()
        GetSecondUserIdByFirstUserIdFive()
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
        
        // Console
        print("--------------- SupplierNewEvent.swift ---------------")
        dicEvent = Dictionary<String,AnyObject>()
        dPDatestart.isHidden = true
        hhoursCHOOSE.isHidden = true
        hhoursENDCHOOSE.isHidden = true
        viewblack.isHidden = true
        
        
        hhoursCHOOSE.locale = Locale(identifier: "en_GB")
        hhoursENDCHOOSE.locale = Locale(identifier: "en_GB")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openDatestart))
        tap.delegate = self
        dateTextField.addGestureRecognizer(tap)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openHHOURS))
        tap2.delegate = self
        timeTextField.addGestureRecognizer(tap2)
        
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        dPDatestart.backgroundColor = Colors.sharedInstance.color1
        dPDatestart.setValue(UIColor.white, forKeyPath: "textColor")
        dPDatestart.setValue(false, forKey: "highlightsToday")
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            dPDatestart.locale = Locale(identifier: "he_IL")
        } else {
            // English
            dPDatestart.locale = Locale(identifier: "en_GB")
        }
        
        dPDatestart.date = Date()
        
        dPDatestart.minimumDate = Date()
        
        hhoursCHOOSE.backgroundColor = Colors.sharedInstance.color1
        hhoursCHOOSE.setValue(UIColor.white, forKeyPath: "textColor")
        hhoursCHOOSE.setValue(false, forKey: "highlightsToday")
        hhoursENDCHOOSE.backgroundColor = Colors.sharedInstance.color1
        hhoursENDCHOOSE.setValue(UIColor.white, forKeyPath: "textColor")
        hhoursENDCHOOSE.setValue(false, forKey: "highlightsToday")
        
        dPDatestart.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        hhoursCHOOSE.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        hhoursENDCHOOSE.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
//        hhoursCHOOSE.minimumDate = Date()
//        hhoursENDCHOOSE.minimumDate = Date()
        
        // Delegate in order to access all methods of UITextFieldDelegate,UITextViewDelegate
        eventNameTextField.delegate = self
        notesTextView.delegate = self
        
        // Hide error messages
        nameErrorLabel.isHidden = true
        dateErrorLabel.isHidden = true
        timeErrorLabel.isHidden = true
        notesErrorLabel.isHidden = true
        
        // Change TextFields placeholder text and color
        eventNameTextField.attributedPlaceholder = NSAttributedString(string: "Event Name", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black]))
        // dateTextField.text = "Date".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        // timeTextField.text = "Time".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        // Set text based on user's language
        titleLabel.text = "EVENT_TITLE_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        notesLabel.text = "EVENT_NOTES_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        checkLabel.text = "EVENT_CHECK_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        eventNameTextField.placeholder = "EVENT_NAME_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        dateTextField.text = "EVENT_DATE_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        timeTextField.text = "EVENT_TIME_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        notesTextView.text = "EVENT_NOTES_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        makeButton.setTitle("EVENT_MAKE_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        nameErrorLabel.text = "EVENT_ERROR_NAME_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        dateErrorLabel.text = "EVENT_ERROR_DATE_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        timeErrorLabel.text = "EVENT_ERROR_TIME_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        notesErrorLabel.text = "EVENT_ERROR_NOTES_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        // Disable notes label interaction
        notesLabel.isUserInteractionEnabled = false
        
        // Add a gesture when user taps un lable title to close all edits
        let tapendedit:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endedit(_:)))
        tapendedit.delegate = self
        popoutView.addGestureRecognizer(tapendedit)
        
        // Set default date and time
        
      //  var thoseTimes = Date()
        
        defaultTimeHour.timeStyle = .none
        defaultTimeHour.dateFormat = "HH:mm"
//        thoseTimes = defaultTimeHour.date(from: "00:00")!
//        hhoursCHOOSE.setDate(thoseTimes, animated: true)
//        hhoursENDCHOOSE.setDate(thoseTimes, animated: true)
        let mydatef = DateFormatter()
        mydatef.dateStyle = .none
        mydatef.dateFormat = "HH:mm"
        let min = mydatef.date(from: "00:00")!      // min time
        let max = mydatef.date(from: "23:59") // max time
        hhoursCHOOSE.minimumDate = min  //setting min time to picker
        hhoursCHOOSE.maximumDate = max
        hhoursENDCHOOSE.minimumDate = min
        hhoursENDCHOOSE.maximumDate = max
        hhoursCHOOSE.setDate(min, animated: true)
        hhoursENDCHOOSE.setDate(max!, animated: true)

        // Check language
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            eventNameTextField.textAlignment = .right
            dateTextField.textAlignment = .right
            timeTextField.textAlignment = .right
            notesTextView.textAlignment = .right
            nameErrorLabel.textAlignment = .left
            dateErrorLabel.textAlignment = .left
            timeErrorLabel.textAlignment = .left
            notesErrorLabel.textAlignment = .left
            
            for view in hhoursCHOOSE.subviews {
                let USERDEF = UserDefaults.standard
                if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                    //view.semanticContentAttribute = .ForceRightToLeft
                } else {
                    //this must fix uipicker being flipped
                    view.semanticContentAttribute = .forceLeftToRight
                }
            }
            
            for view in hhoursENDCHOOSE.subviews {
                let USERDEF = UserDefaults.standard
                if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                    //view.semanticContentAttribute = .ForceRightToLeft
                } else {
                    //this must fix uipicker being flipped
                    view.semanticContentAttribute = .forceLeftToRight
                }
            }
        }
        
        eventNotesStatus = true
    }
    
    
    // Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Handle date picker
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        // Date
        let dateFormatterx = DateFormatter()
        dateFormatterx.timeStyle = .none
        dateFormatterx.dateFormat = "HH:mm"
        if (sender == dPDatestart) {
            let dateFormatterx = DateFormatter()
//            dPDatestart.minimumDate = Date()
            
            // dateFormatterx.timeStyle = .NoStyle
            dateFormatterx.dateFormat = "dd/MM/yyyy"
            dateTextField.text = dateFormatterx.string(from: sender.date)
            dateErrorLabel.isHidden = true
            dicEvent["date"] = dateFormatterx.string(from: dPDatestart.date) as AnyObject
            
            // Console
            print("ce zice  -> dPDatestart.date\( dateFormatterx.string(from: dPDatestart.date)) -< \(dPDatestart.date)")
            print("testttt \(dicEvent.description) ")
        }
        
        // Hour choose
        if (sender == hhoursCHOOSE) {

            
            
            let calendar = Foundation.Calendar.current
            print("este sau nu azi: \(calendar.isDateInToday(dPDatestart.date))")
            if calendar.isDateInToday(dPDatestart.date)
            {
                //sender.minimumDate = Date()
                let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: Date())
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

                let combinedhourminute = hourS_Show + ":" + minuteS_Show
                let min = dateFormatterx.date(from: combinedhourminute)!
                sender.minimumDate = min
            }
            else
            {
//                let mydatef = DateFormatter()
//                mydatef.dateStyle = .none
//                mydatef.dateFormat = "HH:mm"
//                let min = mydatef.date(from: "00:00")!
//                sender.minimumDate = min
                let mydatef = DateFormatter()
                mydatef.dateStyle = .none
                mydatef.dateFormat = "HH:mm"
                let min = mydatef.date(from: "00:00")!      // min time
                let max = mydatef.date(from: "23:59") // max time
                sender.minimumDate = min  //setting min time to picker
                sender.maximumDate = max


            }
            
            
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                hourend =  dateFormatterx.string(from: sender.date)
                timeTextField.text = "\(hourstart) - \(hourend)"
            } else {
                hourstart =  dateFormatterx.string(from: sender.date)
                timeTextField.text = "\(hourstart) - \(hourend)"
            }
            
            timeErrorLabel.isHidden = true
            
        }
        
        // Hour end choose
        if (sender == hhoursENDCHOOSE) {

            
            let calendar = Foundation.Calendar.current
            if calendar.isDateInToday(dPDatestart.date)
            {
               // sender.minimumDate = Date()
                let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: Date())
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
                let combinedhourminute = hourS_Show + ":" + minuteS_Show
                let min = dateFormatterx.date(from: combinedhourminute)!
                sender.minimumDate = min

            }
            else
            {
//                let mydatef = DateFormatter()
//                mydatef.dateStyle = .none
//                mydatef.dateFormat = "HH:mm"
//                let min = mydatef.date(from: "00:00")!
//                sender.minimumDate = min
                let mydatef = DateFormatter()
                mydatef.dateStyle = .none
                mydatef.dateFormat = "HH:mm"
                let min = mydatef.date(from: "00:00")!      // min time
                let max = mydatef.date(from: "23:59") // max time

                sender.minimumDate = min
                sender.maximumDate = max
            }
            
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                hourstart = dateFormatterx.string(from: sender.date)
                timeTextField.text = "\(hourstart) - \(hourend)"
            } else {
                hourend =  dateFormatterx.string(from: sender.date)
                timeTextField.text = "\(hourstart) - \(hourend)"
            }
            
            timeErrorLabel.isHidden = true
        }
    }
    
    
    // Open hour picker
    @objc func openHHOURS() {
self.view.endEditing(true)
        dPDatestart.isHidden = true
        
        // Check if first pick up for hours
        if (isFirstTimeHours == true) {
            dateTextField.text = dateFormatter.string(from: dPDatestart.date)
            timeTextField.text = "00:00 - 00:00"
            hourstart =  defaultTimeHour.string(from: hhoursCHOOSE.date)
            hourend = defaultTimeHour.string(from: hhoursENDCHOOSE.date)
            
            isFirstTimeHours = false
        }
        
        if (hhoursCHOOSE.isHidden == true && hhoursENDCHOOSE.isHidden == true) {
            hhoursCHOOSE.isHidden = false
            hhoursENDCHOOSE.isHidden = false
            viewblack.isHidden = false
        } else {
            hhoursCHOOSE.isHidden = true
            hhoursENDCHOOSE.isHidden = true
            viewblack.isHidden = true
        }
    }
    
    
    // Open date start picker
    @objc func openDatestart() {
        self.view.endEditing(true)
        hhoursCHOOSE.isHidden = true
        hhoursENDCHOOSE.isHidden = true
        
        // Check if first pick up for date
        if (isFirstTimeDate == true) {
            dateTextField.text = dateFormatter.string(from: dPDatestart.date)
            dicEvent["date"] = dateFormatter.string(from: dPDatestart.date) as AnyObject
            
            isFirstTimeDate = false
        }
        
        viewblack.isHidden = true
        if (dPDatestart.isHidden == true) {
            dPDatestart.isHidden = false
        } else {
            dPDatestart.isHidden = true
        }
    }
    
    
    // Check/uncheck button
    @IBAction func btnchecked(_ sender: CheckBoxForExistSupplierOk)
    {

            checkButton.isCecked = !checkButton.isCecked

        
    }
    
    
    // Close "New Event" pop out
    @IBAction func btnclose(_ sender: AnyObject) {
        delegatereload.rereadcalendar()
        self.dismiss(animated: true, completion: nil)
    }
    
    func rereadcalendar() {
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
    // Create new event
    @IBAction func createEvent(_ sender: AnyObject) {
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            
            // Get submited values
            self.view.endEditing(true)

            let currentTime = Date()

            
//            if currentTime == hhoursCHOOSE.date
//            {
//                print("aceeasi ora")
//            }
//            if currentTime < hhoursCHOOSE.date
//            {
//                print("e bine")
//            }
            
            
            eventNameValue = self.eventNameTextField.text
            eventDateValue = self.dateTextField.text
            eventTimeValue = self.timeTextField.text
            eventNotesValue = self.notesTextView.text
            
            if (eventNameTextField.text == "" ) {
                nameErrorLabel.isHidden = false
                
                return
            }
            
            if (dateTextField.text == "" || dateTextField.text == "EVENT_DATE_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)) {
                showAlertDelegateX("ERROR_date_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                dateErrorLabel.isHidden = false
                
                return
            }
            
            if (hourstart == "") {
                showAlertDelegateX("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                timeErrorLabel.isHidden = false
                
                return
            }
            
            if (hourend == "") {
                showAlertDelegateX("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                timeErrorLabel.isHidden = false
                
                return
            }
            let a:Date = hhoursENDCHOOSE.date
            let b:Date = hhoursCHOOSE.date
            switch a.compare(b) {
            case .orderedSame :
                print("The two dates are the same")
                showAlertDelegateX("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                timeErrorLabel.isHidden = false
                return
            default:
                print("diff")
            }
            
            let calendar = Foundation.Calendar.current
            if calendar.isDateInToday(dPDatestart.date)
            {
                //
                let dateFormatterx = DateFormatter()
                dateFormatterx.timeStyle = .none
                dateFormatterx.dateFormat = "HH:mm"
                let interesteddate = dateFormatterx.string(from: currentTime)
                let interesteddateselected = dateFormatterx.string(from: hhoursCHOOSE.date)
                let hhstartendarraydefault = hoursminutesfromString(hminutes : interesteddate)
                let hhstartendarray = hoursminutesfromString(hminutes: interesteddateselected)
                if hhstartendarraydefault.count == 2 && hhstartendarray.count == 2 {
                    let hstart = hhstartendarraydefault[0]
                    let minstart = hhstartendarraydefault[1]
                    let hstartselected = hhstartendarray[0]
                    let minstartselected = hhstartendarray[1]
                    if hstartselected <= hstart && minstartselected <= minstart {
               // }
               // if currentTime > hhoursCHOOSE.date
            // {
                    print("no event in the past ")
                    showAlertDelegateX("NO_EVENT_IN_THE_PAST".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return
                }
                }
            }

            
            
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                // Hebrew
                if (hhoursENDCHOOSE.date > hhoursCHOOSE.date) {
                    showAlertDelegateX("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    timeErrorLabel.isHidden = false
                    
                    return
                }
            } else {
                // Other
                if (hhoursCHOOSE.date > hhoursENDCHOOSE.date  ) {
                    showAlertDelegateX("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    timeErrorLabel.isHidden = false
                    
                    return
                }
            }
            
            // Console
            print("Make button was pressed.")
            print("Even Name value: \(eventNameValue)")
            print("Date value: \(eventDateValue)")
            print("Time value: \(eventTimeValue)")
            print("Notes value: \(eventNotesValue)")
            
            // Check if everything is ok
            if (eventNameStatus == true &&  eventNotesStatus == true) {
                // Send data to server
                print("Sending data to server...")
                saveEventInDeviceCalander()
                // Handle server response
                
            } else {
                // No data send
                if eventNameStatus == false {
                    nameErrorLabel.isHidden = false
                }
                
                //            if eventNotesStatus == false {
                //                notesErrorLabel.hidden = false
                //            }
                
                print("No data was send to server")
            }
        } else {
            showAlertDelegateX("NEW_EVENT_NOT_SYNC".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
    }
    
    
    // Save the event in the device's calendar
    func saveEventInDeviceCalander() {
        let calendar = Foundation.Calendar.current
        var startDate:Date?
        var endDate:Date?
        let dateFormatts:DateFormatter = DateFormatter()
        
        // Set date format Day/Month/Year
        dateFormatts.dateFormat = "dd/MM/YYYY"
        
        // Console
        print("wrong \(String(describing: dicEvent["date"]))")
        
        var eventDate:Date!
        
        if (dicEvent["date"] == nil) {
            // Date not selected
            eventDate = dateFormatter.date(from: dateTextField.text!)
        } else {
            // Date selected
            eventDate = Global.sharedInstance.getDateFromString(dicEvent["date"] as! String)
        }
        
        
        // var eventDate:NSDate = Global.sharedInstance.getDateFromString(dicEvent["date"] as! String)
        
        // Console
        print("evvv date \(eventDate)")
        
        let startHour : String = hourstart
        let endHour : String = hourend
        let mytitle = self.eventNameTextField.text
        let notes = self.notesTextView.text
        dateFormatts.dateFormat = "HH:mm"
        
        var componentsmStart1 = (calendar as NSCalendar).components([.year,.month,.day,.hour, .minute], from: eventDate)
        
        componentsmStart1.hour = Int(startHour.components(separatedBy: ":")[0])!
        componentsmStart1.minute = Int(startHour.components(separatedBy: ":")[1])!
        
        let gregorian = Foundation.Calendar(identifier: .gregorian)
        
        eventDate = gregorian.date(from: componentsmStart1)!
        startDate = eventDate
        endDate = dateFormatts.date(from: endHour)!
        
        let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: startDate!)
        let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: endDate!)
        
        startDate = Calendar.sharedInstance.getPartsOfDate( eventDate, to: componentsStart)
        endDate = Calendar.sharedInstance.getPartsOfDate(eventDate, to: componentsEnd)
        
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if ((granted) && (error == nil)) {
                let event = EKEvent(eventStore: eventStore)
                event.title = mytitle!
                event.notes = notes! + " :by_BThere"
                event.isAllDay = false
                event.startDate = startDate!
                event.endDate = endDate!
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                print("Event: \(event.description)")
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    DispatchQueue.main.async(execute: { () -> Void in
                    //
                        if self.checkButton.isCecked == true {
                            //also call block hours
                        //    self.sendOrderBlock(eventDate)
                            
                            let alertController = UIAlertController(title: "", message:
                                "POP_ALLERT_IN_START_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                          //  alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            
                            
                            // change to desired number of seconds (in this case 3 seconds)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                alertController.dismiss(animated: true, completion: nil)

                                let ENDDATE =  self.dPDatestart.date
                                
                                self.AddBlockedHouresToCalendar(ENDDATE)
                            }
                            
                            
                        
                            
                        } else {
                         //   self.showAlertDelegateX("SUCCESS_NEW_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            self.view.makeToast(message: "SUCCESS_NEW_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.hidetoast()
                               
                            })
                            
                        }
                    })
                    
                } catch let e as NSError {
                    // Console
                    print(e)
                    
                    return
                }
            } else {
                let alert = UIAlertController(title: nil, message: "REQUEST_CALENDAR_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
                })
               
                self.present(alert, animated: true, completion: nil)
            }
        })
    
      
    }
    func hidetoast(){
          self.generic.hideNativeActivityIndicator(self)
        view.hideToastActivity()
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    func hidetoasts(){
        view.hideToastActivity()
    }
    func AddBlockedHouresToCalendar(_ selecteddate:Date) {
        var DATEFINALE = NSMutableArray()
        DATEFINALE = []
        let dateforserver = Global.sharedInstance.convertNSDateToString(selecteddate)
        if !DATEFINALE.contains(dateforserver) {
            DATEFINALE.add(dateforserver)
        }
               
        var y:Int = 0
//        if Global.sharedInstance.arrayGiveServicesKods.count > 0 {
//            y = Global.sharedInstance.arrayGiveServicesKods[0]
//        }
        y = self.intSuppliersecondID
        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicOrderObj["iProviderUserId"] = y as AnyObject
        dicOrderObj["dtDates"] = DATEFINALE as AnyObject
        dicOrderObj["nvBlockedFrom"] = self.hourstart as AnyObject
        dicOrderObj["nvBlockedTo"] = self.hourend as AnyObject
              // api.sharedInstance.PREETYJSON_J(dicOrderObj, pathofweb: "AddBlockedHouresToCalendar DICTIONARY")
       
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
           
       self.generic.showNativeActivityIndicator(self)
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
                            let alertController = UIAlertController(title: "", message:
                                "ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                            self.delegatereload.rereadcalendar()
                                        })
                                    })
                                })
                            }

                       //     Alert.sharedInstance.showAlert("ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            //full succes
                            let alertController = UIAlertController(title: "", message:
                                "FULL_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                            self.delegatereload.rereadcalendar()
                                        })
                                    })
                                })
                            }
                        //    Alert.sharedInstance.showAlert("FULL_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            //self.resetalldata()
                            
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2
                        {
                            //partial
                            let alertController = UIAlertController(title: "", message:
                                "SOME_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                             self.delegatereload.rereadcalendar()
                                       })
                                    })
                                })
                            }
                       //     Alert.sharedInstance.showAlert("SOME_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            //zero minutes
                            let alertController = UIAlertController(title: "", message:
                                "ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                            self.delegatereload.rereadcalendar()
                                        })
                                    })
                                })
                            }
                        //    Alert.sharedInstance.showAlert("ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            
                        }

                        
                    }
                }
                
            },failure:
                {
                    (AFHTTPRequestOperation, Error) -> Void in
                    
                    self.generic.hideNativeActivityIndicator(self)
                    Alert.sharedInstance.showAlert("ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            })
        }
    }

    func sendOrderBlock(_ selecteddate:Date) {
        var iProviderServiceId:Array<Int> = Array<Int>()
        iProviderServiceId = []
        let i:Int = 0
        iProviderServiceId.append(i)
          self.generic.showNativeActivityIndicator(self)
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
        var dicOrderObj:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicOrderObj["dtDateOrder"] = Global.sharedInstance.convertNSDateToString(selecteddate) as AnyObject
        dicOrderObj["nvFromHour"] = self.hourstart as AnyObject
        dicOrderObj["nvToHour"] = self.hourend as AnyObject
        dicOrderObj["iSupplierId"] = supplierID as AnyObject
        dicOrderObj["iSupplierUserId"] = y as AnyObject
       // api.sharedInstance.PREETYJSON_J(dicOrderObj, pathofweb: "sometest")
        if Reachability.isConnectedToNetwork() == false
        {
              self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.BlockHoursForSupplierByEmployeeIdWithTimeInterval(dicOrderObj, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                {
                    //server fail
                   //  self.showAlertDelegateX("ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                      self.generic.hideNativeActivityIndicator(self)
                    self.view.makeToast(message: "ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                    })
                   
                    
                }
                else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                {
                      self.generic.hideNativeActivityIndicator(self)
                    //full succes
                  //   self.showAlertDelegateX("FULL_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    self.view.makeToast(message: "FULL_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                       
                    })                }
                else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2
                {
                      self.generic.hideNativeActivityIndicator(self)
                    //partial
                   //  self.showAlertDelegateX("SOME_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    self.view.makeToast(message: "SOME_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                     
                    })
                }
                else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                {
                      self.generic.hideNativeActivityIndicator(self)
                    //zero minutes
                    // self.showAlertDelegateX("ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    self.view.makeToast(message: "ZERO_MINUTES_BLOCKED".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                      
                    })

                }
                    }
                }
                
                },failure:
                {
                    (AFHTTPRequestOperation, NSError) -> Void in
                      self.generic.hideNativeActivityIndicator(self)
                   // self.showAlertDelegateX("NO_TIME_FREE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    self.view.makeToast(message: "NO_TIME_FREE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                       
                    })
            })
        }
        
        
    }
    
    
    //UITextViewDelegate  methods notesErrorLabel.hidden = true
    //MARK: - textView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView.text == "EVENT_NOTES_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)) {
            textView.text = ""
        }
        
        var startString = ""
        
        if (textView.text != nil) {
            startString += textView.text!
        }
        
        startString += text
        
        return true
    }
    
    
    // User begin to type something
    func textViewDidBeginEditing(_ textView: UITextView) {
        notesErrorLabel.isHidden = true
        if (textView.text == "EVENT_NOTES_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)) {
            // Clear notes placeholder text
            textView.text = ""
        }
    }
    
    
    // User finished typing
    func textViewDidEndEditing(_ textView: UITextView) {
        // Check if empty
        if(textView.text == "" || textView.text ==  "EVENT_NOTES_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)) {
            // Notes were written
            // notesErrorLabel.hidden = false
            // eventNotesStatus = false
        } else {
            // No notes found
            notesErrorLabel.isHidden = true
            eventNotesStatus = true
        }
    }
    
    
    // Handle the text changes
    func textViewDidChange(_ textView: UITextView) {
        // The textView parameter is the textView where text was changed
        // Console
        print("text vv \(textView.text)")
    }
    
    
    //MARK: - textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // TextFields did begin editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        dPDatestart.isHidden = true
        hhoursCHOOSE.isHidden = true
        hhoursENDCHOOSE.isHidden = true
        viewblack.isHidden = true
        
        if (textField == eventNameTextField) {
            if (eventNameTextField.text == "EVENT_NAME_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)) {
                eventNameTextField.text = ""
                eventNameTextField.textColor = UIColor.black
            }
        }
    }
    
    
    // TextFields should end editing
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField == eventNameTextField) {
            dPDatestart.isHidden = true
            hhoursCHOOSE.isHidden = true
            hhoursENDCHOOSE.isHidden = true
            viewblack.isHidden = true
            
            if (eventNameTextField.text == "") {
                eventNameStatus = false
                nameErrorLabel.isHidden = false
            } else {
                eventNameStatus = true
                nameErrorLabel.isHidden = true
            }
        }
        
        return true;
    }

    func setupISupplierSecondID (_ ISupplierSecondID:Int){
        self.intSuppliersecondID = ISupplierSecondID
        print("self.intSuppliersecondID \(self.intSuppliersecondID)")
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

}









// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
