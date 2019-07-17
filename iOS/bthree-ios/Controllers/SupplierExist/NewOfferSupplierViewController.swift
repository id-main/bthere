//
//  NewOfferSupplierViewController.swift
//  BThere
//
//  Created by Eduard Stefanescu on 1/15/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class NewOfferSupplierViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate { // NavigationModelViewController
    // Outlets Labels
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var endLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var offerLabel: UILabel!
    @IBOutlet var giftLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var startValueLabel: UILabel!
    @IBOutlet var endValueLabel: UILabel!
    @IBOutlet var typeValueLabel: UILabel!
    @IBOutlet var offerValueLabel: UILabel!
    @IBOutlet var hoursValueLabel: UILabel!
    
    
    // Views
    @IBOutlet var offerTypeView: UIView!
    @IBOutlet var hoursView: UIView!
    @IBOutlet var typeView: UIView!
    @IBOutlet var endDateView: UIView!
    @IBOutlet var startDateView: UIView!
    
    
    // Outlets Text Field
    @IBOutlet var giftTextField: UITextField!
    
    
    // Outlets Text View
    @IBOutlet var textTextView: UITextView!
    
    
    // Outlets Buttons
    @IBOutlet var addButton: UIButton!
    
    
    // Outlets Pickers
    @IBOutlet var offerTypePicker: UIPickerView!
    @IBOutlet var startHoursPicker: UIDatePicker!
    @IBOutlet var endHoursPicker: UIDatePicker!
    @IBOutlet var typePicker: UIPickerView!
    @IBOutlet var endDatePicker: UIDatePicker!
    @IBOutlet var startDatePicker: UIDatePicker!
    
    
    // Constants
    let offerTypeArray = ["NEW_OFFER_GIFT_PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE), "NEW_OFFER_DISCOUNT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    let dateFormatt:DateFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    let defaultTimeHour = DateFormatter()
    
    
    // Variables
    var startDateString: String = ""
    var endDateString: String = ""
    var typeOfString: String = ""
    var startHoursString = ""
    var endHoursString = ""
    var productServicesArray: Array<String> = ["Product 1", "Product 2", "Product 3", "Product 4", "Product 5"]
    var isFirstType: Bool = true
    var isFirstHours: Bool = true
    var isFirstOffer: Bool = true
    var isFirstEnd: Bool = true
    var isFirstStart: Bool = true
    var isFromTable: Bool = false
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProviderServicesForSupplierFunc()
        // Delegates
        self.offerTypePicker.delegate = self
        self.offerTypePicker.dataSource = self
        self.typePicker.delegate = self
        self.typePicker.dataSource = self
        self.textTextView.delegate = self
        
        // Hide pickers and views
        offerTypePicker.isHidden = true
        offerTypeView.isHidden = true
        startHoursPicker.isHidden = true
        endHoursPicker.isHidden = true
        hoursView.isHidden = true
        typeView.isHidden = true
        typePicker.isHidden = true
        endDateView.isHidden = true
        endDatePicker.isHidden = true
        startDateView.isHidden = true
        startDatePicker.isHidden = true
        
        // Date format
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Default settings
        startHoursPicker.locale = Locale(identifier: "en_GB")
        endHoursPicker.locale = Locale(identifier: "en_GB")
        
        // Language
        titleLabel.text = "NEW_OFFER_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        startLabel.text = "START_DATE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        endLabel.text = "END_DATE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        typeLabel.text = "NEW_OFFER_TYPE_OF".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        hoursLabel.text = "HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        offerLabel.text = "NEW_OFFER_OFFER_TYPE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        giftLabel.text = "NEW_OFFER_GIFT_PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        textLabel.text = "NEW_OFFER_OFFER_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        addButton.setTitle("NEW_OFFER_ADD".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        // Default picker value
        self.offerTypePicker.selectRow(0, inComponent: 0, animated: true)
        self.typePicker.selectRow(0, inComponent: 0, animated: true)
        self.startHoursPicker.setValue(false, forKey: "highlightsToday")
        self.endHoursPicker.setValue(false, forKey: "highlightsToday")
        self.endDatePicker.setValue(false, forKey: "highlightsToday")
        self.startDatePicker.setValue(false, forKey: "highlightsToday")
        
        // Pickers color
        self.offerTypePicker.setValue(UIColor.white, forKeyPath: "textColor")
        self.startHoursPicker.setValue(UIColor.white, forKeyPath: "textColor")
        self.endHoursPicker.setValue(UIColor.white, forKeyPath: "textColor")
        self.endDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        self.startDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        // Set tap actions
        startHoursPicker.addTarget(self, action: #selector(RegisterViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        startHoursPicker.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        endHoursPicker.addTarget(self, action: #selector(RegisterViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        endHoursPicker.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        endDatePicker.addTarget(self, action: #selector(RegisterViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        endDatePicker.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        startDatePicker.addTarget(self, action: #selector(RegisterViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        startDatePicker.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Normal
            let calendar = Foundation.Calendar.current
            var components = DateComponents()
            components.hour = 12
            components.minute = 00
            startHoursPicker.setDate(calendar.date(from: components)!, animated: true)
            
            let calendar2 = Foundation.Calendar.current
            var components2 = DateComponents()
            components2.hour = 13
            components2.minute = 30
            endHoursPicker.setDate(calendar2.date(from: components2)!, animated: true)
        } else {
            // Normal
            let calendar = Foundation.Calendar.current
            var components = DateComponents()
            components.hour = 12
            components.minute = 00
            startHoursPicker.setDate(calendar.date(from: components)!, animated: true)
            
            let calendar2 = Foundation.Calendar.current
            var components2 = DateComponents()
            components2.hour = 13
            components2.minute = 30
            endHoursPicker.setDate(calendar2.date(from: components2)!, animated: true)
        }
        
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            giftTextField.textAlignment = .right
            textTextView.textAlignment = .right
            startLabel.textAlignment = .right
            endLabel.textAlignment = .right
            typeLabel.textAlignment = .right
            hoursLabel.textAlignment = .right
            offerLabel.textAlignment = .right
            giftLabel.textAlignment = .right
            textLabel.textAlignment = .right
            startValueLabel.textAlignment = .right
            endValueLabel.textAlignment = .right
            typeValueLabel.textAlignment = .right
            offerValueLabel.textAlignment = .right
            hoursValueLabel.textAlignment = .right
        } else {
            // Other language
            giftTextField.textAlignment = .left
            textTextView.textAlignment = .left
            startLabel.textAlignment = .left
            endLabel.textAlignment = .left
            typeLabel.textAlignment = .left
            hoursLabel.textAlignment = .left
            offerLabel.textAlignment = .left
            giftLabel.textAlignment = .left
            textLabel.textAlignment = .left
            startValueLabel.textAlignment = .left
            endValueLabel.textAlignment = .left
            typeValueLabel.textAlignment = .left
            offerValueLabel.textAlignment = .left
            hoursValueLabel.textAlignment = .left
        }
        
        // Add values if from table
        if (isFromTable == true) {
            
        }
        
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            startDatePicker.locale = Locale(identifier: "he_IL")
            endDatePicker.locale = Locale(identifier: "he_IL")
        } else {
            // English
            startDatePicker.locale = Locale(identifier: "en_GB")
            endDatePicker.locale = Locale(identifier: "en_GB")
        }
    }
    func getProviderServicesForSupplierFunc()
    {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        if Global.sharedInstance.providerID == 0 {
            dicSearch["iProviderId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
                
            }
        } else {
            dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }
        print("CEEE Global.sharedInstance.providerID \(Global.sharedInstance.providerID)")
        api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            Alert.sharedInstance.showAlert("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        })
                        
                        
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        
                        if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                            let ps:objProviderServices = objProviderServices()
                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            }
                            if self.ProviderServicesArray.count == 0
                            {
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    Alert.sharedInstance.showAlert("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                    
                                })
                                
                            }
                            else
                            {
                                for item in self.ProviderServicesArray {
                                    print("self.ProviderServicesArray \(item.getDic())")
                                }
                            }
                        }
                    }
                }
            }
            
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                Alert.sharedInstance.showAlert("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            })
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Close pop out
    @IBAction func closeButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Add offer
    @IBAction func addButton(_ sender: AnyObject) {
        /** LastMinuteCamapign_INS
        INPUT:
        {
            "obj": {
                "iSupplierId": 884,
                "dFromDate": "/Date(1519084800+0200)/",
                "dToDate": "/Date(1519084800+0200)/",
                "tFromHoure": "09:00:00",
                "tToHoure": "21:00:00",
                "nvCampaignTitle": "test",
                "nvCampaignDetails": null,
                "iCampaignStatusType": 1,
                "iCreatedByUserId": 7420
            }
        }
         **/
        let dateFormatterx = DateFormatter()
        
        dateFormatterx.dateFormat = "dd/MM/yyyy"
        let someDate = dateFormatterx.string(from: startDatePicker.date)
        let daycompare = dateFormatterx.string(from: endDatePicker.date)
        let oneDate = Global.sharedInstance.getDateFromString(someDate)
        let finalDate = Global.sharedInstance.getDateFromString(daycompare)
       
        if startValueLabel.text == "" {
            Alert.sharedInstance.showAlert("ERROR_date_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        if endValueLabel.text == "" {
            Alert.sharedInstance.showAlert("ERROR_date_End".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        if startHoursString == "" {
            Alert.sharedInstance.showAlert("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        if endHoursString == "" {
            Alert.sharedInstance.showAlert("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        
        if  oneDate > finalDate  {
            Alert.sharedInstance.showAlert("ERROR_DATE_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        }
        if typeValueLabel.text == "" {
             Alert.sharedInstance.showAlert("NEW_OFFER_ALERT_TYPE_NOT_SELECTED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            return
        }
        let cDate = startHoursPicker.date
        let dDate = endHoursPicker.date
        switch cDate.compare(dDate) {
        case .orderedSame   :
            print("The two dates are the same")
            Alert.sharedInstance.showAlert("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            return
        default:
            print("diff")
        }

        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            if (dDate > cDate) {
                Alert.sharedInstance.showAlert("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                return
            }
        } else {
            // Other
            if cDate > dDate {
                Alert.sharedInstance.showAlert("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                return
            }
        }
        if offerValueLabel.text == "" {
            Alert.sharedInstance.showAlert("NEW_OFFER_ALERT_disc_NOT_SELECTED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            return
        }
        if textTextView.text == "" {
            Alert.sharedInstance.showAlert("NEW_OFFER_OFFER_TEXT_MISSING".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            return

        }
        
        print("oneDate\(oneDate) - finalDate\(finalDate)")

        self.startDateView.isHidden = true
        self.startDatePicker.isHidden = true
        self.endDateView.isHidden = true
        self.endDatePicker.isHidden = true
        self.typeView.isHidden = true
        self.typePicker.isHidden = true
        self.startHoursPicker.isHidden = true
        self.endHoursPicker.isHidden = true
        self.hoursView.isHidden = true
        self.offerTypePicker.isHidden = true
        self.offerTypeView.isHidden = true
        
        print("****************** Start Values ******************")
        print("startDateString: \(startDateString)")
        print("endDateString: \(endDateString)")
        print("startHoursString: \(startHoursString)")
        print("endHoursString: \(endHoursString)")
        print("****************** End Values ******************")
    }
    
    
    // Start picker
    @IBAction func startPickerButton(_ sender: AnyObject) {
        // First time check
        if (isFirstStart == true) {
            isFirstStart = false
            
            startValueLabel.text = dateFormatter.string(from: startDatePicker.date)
        }
        
        if (self.startDateView.isHidden == true && self.startDatePicker.isHidden == true) {
            // Show start
            startDateView.isHidden = false
            startDatePicker.isHidden = false
            
            // Show end
            endDateView.isHidden = true
            endDatePicker.isHidden = true
            
            // Type hide
            self.typeView.isHidden = true
            self.typePicker.isHidden = true
            
            // Hours show
            self.startHoursPicker.isHidden = true
            self.endHoursPicker.isHidden = true
            self.hoursView.isHidden = true
            
            // Offer hide
            self.offerTypePicker.isHidden = true
            self.offerTypeView.isHidden = true
        } else {
            // Hide start
            startDateView.isHidden = true
            startDatePicker.isHidden = true
            
            // Show end
            endDateView.isHidden = true
            endDatePicker.isHidden = true
            
            // Type hide
            self.typeView.isHidden = true
            self.typePicker.isHidden = true
            
            // Hours show
            self.startHoursPicker.isHidden = true
            self.endHoursPicker.isHidden = true
            self.hoursView.isHidden = true
            
            // Offer hide
            self.offerTypePicker.isHidden = true
            self.offerTypeView.isHidden = true
        }
    }
    
    
    // End picker
    @IBAction func endPickerButton(_ sender: AnyObject) {
        // First time check
        if (isFirstEnd == true) {
            isFirstEnd = false
            
            endValueLabel.text = dateFormatter.string(from: endDatePicker.date)
        }
        
        if (self.endDateView.isHidden == true && self.endDatePicker.isHidden == true) {
            // Show end
            endDateView.isHidden = false
            endDatePicker.isHidden = false
            
            // Type hide
            self.typeView.isHidden = true
            self.typePicker.isHidden = true
            
            // Hours show
            self.startHoursPicker.isHidden = true
            self.endHoursPicker.isHidden = true
            self.hoursView.isHidden = true
            
            // Offer hide
            self.offerTypePicker.isHidden = true
            self.offerTypeView.isHidden = true
            
            // Start hide
            self.startDateView.isHidden = true
            self.startDatePicker.isHidden = true
        } else {
            // End date hide
            endDateView.isHidden = true
            endDatePicker.isHidden = true
            
            // Type hide
            self.typeView.isHidden = true
            self.typePicker.isHidden = true
            
            // Hours show
            self.startHoursPicker.isHidden = true
            self.endHoursPicker.isHidden = true
            self.hoursView.isHidden = true
            
            // Offer hide
            self.offerTypePicker.isHidden = true
            self.offerTypeView.isHidden = true
            
            // Start hide
            self.startDateView.isHidden = true
            self.startDatePicker.isHidden = true
        }
    }
    
    
    // Type picker
    @IBAction func typePickerButton(_ sender: AnyObject) {
        // First time check
        if (isFirstType == true) {
            isFirstType = false
            typeOfString = productServicesArray[0]
            typeValueLabel.text = productServicesArray[0]
        }
        
        if (self.typeView.isHidden == true && self.typePicker.isHidden == true) {
            // Type show
            self.typeView.isHidden = false
            self.typePicker.isHidden = false
            
            // Hours show
            self.startHoursPicker.isHidden = true
            self.endHoursPicker.isHidden = true
            self.hoursView.isHidden = true
            
            // Offer hide
            self.offerTypePicker.isHidden = true
            self.offerTypeView.isHidden = true
            
            // End date hide
            endDateView.isHidden = true
            endDatePicker.isHidden = true
            
            // Start hide
            self.startDateView.isHidden = true
            self.startDatePicker.isHidden = true
        } else {
            // Type hide
            self.typeView.isHidden = true
            self.typePicker.isHidden = true
            
            // Hours show
            self.startHoursPicker.isHidden = true
            self.endHoursPicker.isHidden = true
            self.hoursView.isHidden = true
            
            // Offer hide
            self.offerTypePicker.isHidden = true
            self.offerTypeView.isHidden = true
            
            // End date hide
            endDateView.isHidden = true
            endDatePicker.isHidden = true
            
            // Start hide
            self.startDateView.isHidden = true
            self.startDatePicker.isHidden = true
        }
    }
    
    
    // Hours picker
    @IBAction func hoursPickerButton(_ sender: AnyObject) {
        // Check if product/service was selected
        if (typeOfString != "" && typeOfString != " ") {
            // First time check
            if (isFirstHours == true) {
                isFirstHours = false
                
                if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                    // Switch hours in Hebrew
                    startHoursString = "13:30"
                    endHoursString = "12:00"
                    hoursValueLabel.text = "\(startHoursString) - \(endHoursString)"
                } else {
                    // Normal
                    startHoursString = "12:00"
                    endHoursString = "13:30"
                    hoursValueLabel.text = "\(startHoursString) - \(endHoursString)"
                }
            }
            
            if (self.startHoursPicker.isHidden == true && self.endHoursPicker.isHidden == true && self.hoursView.isHidden == true) {
                // Hours show
                self.startHoursPicker.isHidden = false
                self.endHoursPicker.isHidden = false
                self.hoursView.isHidden = false
                
                // Offer hide
                self.offerTypePicker.isHidden = true
                self.offerTypeView.isHidden = true
                
                // Type hide
                self.typeView.isHidden = true
                self.typePicker.isHidden = true
                
                // End date hide
                endDateView.isHidden = true
                endDatePicker.isHidden = true
                
                // Start hide
                self.startDateView.isHidden = true
                self.startDatePicker.isHidden = true
            } else {
                // Hours hide
                self.startHoursPicker.isHidden = true
                self.endHoursPicker.isHidden = true
                self.hoursView.isHidden = true
                
                // Offer hide
                self.offerTypePicker.isHidden = true
                self.offerTypeView.isHidden = true
                
                // Type hide
                self.typeView.isHidden = true
                self.typePicker.isHidden = true
                
                // End date hide
                endDateView.isHidden = true
                endDatePicker.isHidden = true
                
                // Start hide
                self.startDateView.isHidden = true
                self.startDatePicker.isHidden = true
            }
        } else {
            // Product/service not selected
            Alert.sharedInstance.showAlert("NEW_OFFER_ALERT_TYPE_NOT_SELECTED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
    }
    
    
    // Offer picker
    @IBAction func offerPickerButton(_ sender: AnyObject) {
        // First time check
        if (isFirstOffer == true) {
            isFirstOffer = false
            offerValueLabel.text = offerTypeArray[0]
        }
        
        if (self.offerTypePicker.isHidden == true && self.offerTypeView.isHidden == true) {
            // Offer show
            self.offerTypePicker.isHidden = false
            self.offerTypeView.isHidden = false
            
            // Hours hide
            self.startHoursPicker.isHidden = true
            self.endHoursPicker.isHidden = true
            self.hoursView.isHidden = true
            
            // Type hide
            self.typeView.isHidden = true
            self.typePicker.isHidden = true
            
            // End date hide
            endDateView.isHidden = true
            endDatePicker.isHidden = true
            
            // Start hide
            self.startDateView.isHidden = true
            self.startDatePicker.isHidden = true
        } else {
            // Offer hide
            self.offerTypePicker.isHidden = true
            self.offerTypeView.isHidden = true
            
            // Hours hide
            self.startHoursPicker.isHidden = true
            self.endHoursPicker.isHidden = true
            self.hoursView.isHidden = true
            
            // Type hide
            self.typeView.isHidden = true
            self.typePicker.isHidden = true
            
            // End date hide
            endDateView.isHidden = true
            endDatePicker.isHidden = true
            
            // Start hide
            self.startDateView.isHidden = true
            self.startDatePicker.isHidden = true
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // Picker count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Offer type
        if (pickerView == offerTypePicker) {
            return offerTypeArray.count
        }
        
        // Type
        if (pickerView == typePicker) {
            return productServicesArray.count
        }
        
        return 1
    }
    
    
    // Row per picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Offer type
        if (pickerView == offerTypePicker) {
            return offerTypeArray[row]
        }
        
        // Type
        if (pickerView == typePicker) {
            return productServicesArray[row]
        }
        
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Offer type
        if (pickerView == offerTypePicker) {
            offerValueLabel.text = offerTypeArray[row]
            
            // Replace label text
            if (row == 0) {
                // Gift product
                giftLabel.text = "NEW_OFFER_GIFT_PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                giftTextField.text = ""
            } else {
                // Discount percent
                giftLabel.text = "NEW_OFFER_DISCOUNT_PERCENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                giftTextField.text = "10%"
            }
        }
        
        // Type
        if (pickerView == typePicker) {
            typeValueLabel.text = productServicesArray[row]
            typeOfString = productServicesArray[row]
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        // Offer type
        if (pickerView == offerTypePicker) {
            attributedString = NSAttributedString(string: offerTypeArray[row], attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white]))
        }
        
        // Start hours
        if (pickerView == startHoursPicker) {
            attributedString = NSAttributedString(string: offerTypeArray[row], attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white]))
        }
        
        // End hours
        if (pickerView == endHoursPicker) {
            attributedString = NSAttributedString(string: offerTypeArray[row], attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white]))
        }
        
        // Type
        if (pickerView == typePicker) {
            attributedString = NSAttributedString(string: productServicesArray[row], attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white]))
        }
        
        // End date
        if (pickerView == endDatePicker) {
            attributedString = NSAttributedString(string: offerTypeArray[row], attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white]))
        }
        
        return attributedString
    }
    
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        // Start hours
        if (sender == startHoursPicker) {
            // Check if product/service was selected
            if (typeOfString != "" && typeOfString != " ") {
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                
                if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                    // Switch hours in Hebrew
                    startHoursString =  dateFormatter.string(from: sender.date)
                    hoursValueLabel.text = "\(endHoursString) - \(startHoursString)"
                } else {
                    // Normal
                    startHoursString =  dateFormatter.string(from: sender.date)
                    hoursValueLabel.text = "\(startHoursString) - \(endHoursString)"
                }
            } else {
                // Product/service not selected
                Alert.sharedInstance.showAlert("NEW_OFFER_ALERT_TYPE_NOT_SELECTED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
        }
        
        // End hours
        if (sender == endHoursPicker) {
            // Check if product/service was selected
            if (typeOfString != "" && typeOfString != " ") {
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                
                if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                    // Switch hours in Hebrew
                    endHoursString = dateFormatter.string(from: sender.date)
                    hoursValueLabel.text = "\(endHoursString) - \(startHoursString)"
                } else {
                    // Normal
                    endHoursString = dateFormatter.string(from: sender.date)
                    hoursValueLabel.text = "\(startHoursString) - \(endHoursString)"
                }
            } else {
                // Product/service not selected
                Alert.sharedInstance.showAlert("NEW_OFFER_ALERT_TYPE_NOT_SELECTED".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
        }
        
        // End date
        if (sender == endDatePicker) {
            let dateFormatterx = DateFormatter()
            
            dateFormatterx.dateFormat = "dd/MM/yyyy"
            let someDate = dateFormatterx.string(from: sender.date)
            let daycompare = dateFormatterx.date(from: someDate)
            let todayDate = dateFormatterx.string(from: Date())
            let daycomparetoday = dateFormatterx.date(from: todayDate)
            
            if (daycompare! as NSDate).timeIntervalSince(daycomparetoday!).sign == .minus {
                //someDate is berofe than today
                showAlertDelegateX("ERROR_DATE_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                endDatePicker.setDate(Date(), animated: true)
                endValueLabel.text = dateFormatterx.string(from: sender.date)
                
            } else {
                //someDate is equal or after than today
                endValueLabel.text = dateFormatterx.string(from: sender.date)
            }
        }
        
        // Start date
        if (sender == startDatePicker) {
            let dateFormatterx = DateFormatter()
            
            dateFormatterx.dateFormat = "dd/MM/yyyy"
            let someDate = dateFormatterx.string(from: sender.date)
            let daycompare = dateFormatterx.date(from: someDate)
            let todayDate = dateFormatterx.string(from: Date())
            let daycomparetoday = dateFormatterx.date(from: todayDate)
            
            if (daycompare! as NSDate).timeIntervalSince(daycomparetoday!).sign == .minus {
                //someDate is berofe than today
                showAlertDelegateX("ERROR_DATE_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                startDatePicker.setDate(Date(), animated: true)
                startValueLabel.text = dateFormatterx.string(from: sender.date)
                
            } else {
                //someDate is equal or after than today
                startValueLabel.text = dateFormatterx.string(from: sender.date)
            }
        }
    }
    
    
    // Text limit
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 121
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
