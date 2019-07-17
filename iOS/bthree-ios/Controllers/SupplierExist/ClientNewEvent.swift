//
//  ClientNewEvent.swift
//  BThere
//
//  Created by Eduard Stefanescu on 8/31/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import EventKit


class ClientNewEvent: NavigationModelViewController, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    // UI Outlets
    @IBOutlet weak var popoutView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
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
    var eventNotesStatus: Bool = true
    var hourstart = ""
    var hourend = ""
    var dicEvent:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    var isFirstTimeDate: Bool = true
    var isFirstTimeHours: Bool = true
    
    
    // Constants
    let dateFormatt:DateFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    let defaultTimeHour = DateFormatter()
    
    // Causes the TextFields to resign the first responder status.
    @objc func endedit(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        print("--------------- ClientNewEvent.swift ---------------")
        dicEvent = Dictionary<String,AnyObject>()
        dPDatestart.isHidden = true
        hhoursCHOOSE.isHidden = true
        hhoursENDCHOOSE.isHidden = true
        viewblack.isHidden = true
        
        
        hhoursCHOOSE.locale = Locale(identifier: "en_GB")
        hhoursENDCHOOSE.locale = Locale(identifier: "en_GB")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BlockHoursViewController.openDatestart))
        tap.delegate = self
        dateTextField.addGestureRecognizer(tap)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BlockHoursViewController.openHHOURS))
        tap2.delegate = self
        timeTextField.addGestureRecognizer(tap2)
        
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        dPDatestart.backgroundColor = Colors.sharedInstance.color1
        dPDatestart.setValue(UIColor.white, forKeyPath: "textColor")
        dPDatestart.setValue(false, forKey: "highlightsToday")
        dPDatestart.date = Date()
        
        hhoursCHOOSE.backgroundColor = Colors.sharedInstance.color1
        hhoursCHOOSE.setValue(UIColor.white, forKeyPath: "textColor")
        hhoursCHOOSE.setValue(false, forKey: "highlightsToday")
        hhoursENDCHOOSE.backgroundColor = Colors.sharedInstance.color1
        hhoursENDCHOOSE.setValue(UIColor.white, forKeyPath: "textColor")
        hhoursENDCHOOSE.setValue(false, forKey: "highlightsToday")
        
        
        
        
        dPDatestart.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        hhoursCHOOSE.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        hhoursENDCHOOSE.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
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
        
        // Set text based on user's language .localized(LanguageMain.sharedInstance.USERLANGUAGE)
        titleLabel.text = "EVENT_TITLE_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        notesLabel.text = "EVENT_NOTES_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
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
        
        var thoseTimes = Date()
        
        defaultTimeHour.timeStyle = .none
        defaultTimeHour.dateFormat = "HH:mm"
        thoseTimes = defaultTimeHour.date(from: "00:00")!
        hhoursCHOOSE.setDate(thoseTimes, animated: true)
        hhoursENDCHOOSE.setDate(thoseTimes, animated: true)
        
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
        }
        
        
        
        
    }
    
    
    // Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Handle date picker
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        // Date
        if (sender == dPDatestart) {
            let dateFormatterx = DateFormatter()
            
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
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "HH:mm"
            
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                hourend =  dateFormatter.string(from: sender.date)
                timeTextField.text = "\(hourstart) - \(hourend)"
            } else {
                hourstart =  dateFormatter.string(from: sender.date)
                timeTextField.text = "\(hourstart) - \(hourend)"
            }
            
            timeErrorLabel.isHidden = true
        }
        
        // Hour end choose
        if (sender == hhoursENDCHOOSE) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "HH:mm"
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                hourstart = dateFormatter.string(from: sender.date)
                timeTextField.text = "\(hourstart) - \(hourend)"
            } else {
                hourend = dateFormatter.string(from: sender.date)
                timeTextField.text = "\(hourstart) - \(hourend)"
            }
            
            timeErrorLabel.isHidden = true
        }
    }
    
    
    // Open hour picker
    func openHHOURS() {
        dPDatestart.isHidden = true
        
        
        // Other
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
    func openDatestart() {
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
    
    
    // Close "New Event" pop out
    @IBAction func btnclose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Create new event
    @IBAction func createEvent(_ sender: AnyObject) {
        
        
        print("hourstart: \(hourstart)")
        print("hourend: \(hourend)")
        
        
        // Check if calendar is synchronized
        if (Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true) {
            // Get submited values
            self.view.endEditing(true)
            
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
            
            
            // Other
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

            
            
            
            
            
            
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                // Hebrew
                if (hhoursENDCHOOSE.date > hhoursCHOOSE.date) {
                    showAlertDelegateX("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    timeErrorLabel.isHidden = false
                    
                    return
                }
            } else {
                // Other
                if ( hhoursCHOOSE.date > hhoursENDCHOOSE.date ) {
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
        print("wrong \(dicEvent["date"])")
        // var eventDate:NSDate = Global.sharedInstance.getDateFromString(dicEvent["date"] as! String)
        
        var eventDate:Date!
        
        if (dicEvent["date"] == nil) {
            // Date not selected
            eventDate = dateFormatter.date(from: dateTextField.text!)
        } else {
            // Date selected
            eventDate = Global.sharedInstance.getDateFromString(dicEvent["date"] as! String)
        }
        
        // Console
        print("evvv date \(eventDate)")
        
        let startHour : String = hourstart
        let endHour : String = hourend
        
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
                let mytitle = self.eventNameTextField.text
                event.title = mytitle!
                let notes = self.notesTextView.text
                event.notes = notes! + " :by_BThere"
                event.isAllDay = false
                event.startDate = startDate!
                event.endDate = endDate!
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.showAlertDelegateX("SUCCESS_NEW_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE))
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
        // self.hidetoast()
        self.dismiss(animated: true, completion: nil)
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
