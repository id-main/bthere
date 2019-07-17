//
//  //\\PrintCalendarSupplierVC.swift
//  bthree-ios
//
//  Created by User on 15.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class PrintCalendarSupplierVC: NavigationModelViewController {
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    
    // Variables
    var viewType: String!
    //JMODE 20.09.2017
    var buttonsarray:Array<UIButton> = Array<UIButton>()
    var WHICHPRINT:Int = 0
    // Constants
    let dateFormatter = DateFormatter()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:57)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PrintCalendarSupplierVC.openCloseStartPicker))
        
        // Change language
        let USERDEF = UserDefaults.standard
        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            titleLabel.textAlignment = .right
            fromLabel.textAlignment = .right
            viewLabel.textAlignment = .right
            weekLabel.textAlignment = .left
            dayLabel.textAlignment = .left
            listLabel.textAlignment = .left
            
        }
        
        titleLabel.text = "print_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        fromLabel.text = "CALENDAR_FROM".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        viewLabel.text = "CALENDAR_VIEW".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        weekLabel.text = "DESIGN_WEEK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        dayLabel.text = "DESIGN_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        listLabel.text = "DESIGN_LIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        sendButton.setTitle("CALENDAR_SEND_PDF".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        // Hide pickers
        startDatePicker.isHidden = true
        
        // Set date format
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // From date picker design
        startDatePicker.locale = Locale(identifier: "en_GB")
        startDatePicker.backgroundColor = Colors.sharedInstance.color1
        startDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        startDatePicker.setValue(false, forKey: "highlightsToday")
        startDatePicker.date = Date()
        fromTextField.text = dateFormatter.string(from: startDatePicker.date)
        
        // Set current date as default
        startDatePicker.addTarget(self, action: #selector(RegisterViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        startDatePicker.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        buttonsarray.append(weekButton)
        buttonsarray.append(dayButton)
        buttonsarray.append(listButton)
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            startDatePicker.locale = Locale(identifier: "he_IL")
        } else {
            // English
            startDatePicker.locale = Locale(identifier: "en_GB")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Close pop out
    @IBAction func closePopButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Select start date
    @IBAction func selectFromButton(_ sender: AnyObject) {
        // Console
        print("Select date from")
        
        // Open/close start picker
        self.openCloseStartPicker()
    }
    
    
    // Select week
    @IBAction func selectWeekButton(_ sender: AnyObject) {
        closeothers(weekButton)
        WHICHPRINT = 2
    }
    
    
    // Select day
    @IBAction func selectDayButton(_ sender: AnyObject) {
        closeothers(dayButton)
        Global.sharedInstance.currDateSelected = startDatePicker.date
        WHICHPRINT = 1
    }
    
    
    // Select list
    @IBAction func selectListButton(_ sender: AnyObject) {
        closeothers(listButton)
        WHICHPRINT = 3
    }
    
    func closeothers(_ sender: UIButton) {
        for item in buttonsarray {
            if item == sender {
                item.setBackgroundImage(UIImage(named: "Close_black_button") as UIImage?, for: UIControl.State())
            } else {
                item.setBackgroundImage(UIImage(named: "16a") as UIImage?, for: UIControl.State())
            }
        }
    }
    
    // Send PDF
    @IBAction func sendPDFButton(_ sender: AnyObject) {
        // Console
        print("Send PDF to email")
        if WHICHPRINT == 0 {
            showAlertDelegateX("DID_NOT_SELECT_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            if WHICHPRINT == 3 {
                let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
                let viewCon = storyBoard.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as!  CalendarSupplierViewController
                viewCon.WHICHPRINT = WHICHPRINT
                self.dismiss(animated: true, completion: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                    frontviewcontroller?.pushViewController(viewCon, animated: false)
                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.frontViewController = frontviewcontroller
                    mainRevealController.rearViewController = rearViewController
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController
                })
            }
            if WHICHPRINT == 1 {
                let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
                let viewCon = storyBoard.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as!  CalendarSupplierViewController
                viewCon.WHICHPRINT = WHICHPRINT
                viewCon.MYDATE = self.startDatePicker.date
                self.dismiss(animated: true, completion: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                    frontviewcontroller?.pushViewController(viewCon, animated: false)
                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.frontViewController = frontviewcontroller
                    mainRevealController.rearViewController = rearViewController
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController
                })
            }
            if WHICHPRINT == 2 {
                let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
                let viewCon = storyBoard.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as!  CalendarSupplierViewController
                viewCon.WHICHPRINT = WHICHPRINT
                viewCon.MYDATE = self.startDatePicker.date
                self.dismiss(animated: true, completion: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                    frontviewcontroller?.pushViewController(viewCon, animated: false)
                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.frontViewController = frontviewcontroller
                    mainRevealController.rearViewController = rearViewController
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController
                })
            }
            
        }
    }
    
    
   @objc func handleDatePicker(_ sender: UIDatePicker) {
        if sender == startDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"
            fromTextField.text = dateFormatter.string(from: sender.date)
        }
    }
    
    
    // Open/close start date
    @objc func openCloseStartPicker() {
        if (startDatePicker.isHidden == true) {
            startDatePicker.isHidden = false
        } else {
            startDatePicker.isHidden = true
        }
    }
    
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
    }
}

