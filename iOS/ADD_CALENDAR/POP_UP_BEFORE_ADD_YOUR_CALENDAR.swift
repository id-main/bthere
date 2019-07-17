//
//  POP_UP_BEFORE_ADD_YOUR_CALENDAR.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 29/03/2019
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit


class POP_UP_BEFORE_ADD_YOUR_CALENDAR: UIViewController, UIGestureRecognizerDelegate {
    var UserAgreedWithTerms:Bool = false
    var delegate:SettingsSetupCalendars!=nil
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var titletext:UILabel!
    @IBOutlet weak var WHAT_DO_YOU_GET_WHEN_ADDING_AN_EMPLOYEE:UILabel!
    @IBOutlet weak var AGREE_THAT_YOU_HAVE_READ_THE_PAYMENT_TERMS_AFTER_THE_TRIAL_PERIOD:UILabel!
    @IBOutlet weak var btncontinue: UIButton!
    @IBOutlet weak var btnYesSelect: BoxForAddEmployee!
    @IBOutlet weak var btnYesSelectHebrew: BoxForAddEmployee!
    @IBAction func btnYesSelectHebrew(_ sender: AnyObject) {
        btnYesSelectHebrew.isCecked = !btnYesSelectHebrew.isCecked
        UserAgreedWithTerms = !UserAgreedWithTerms
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UserAgreedWithTerms = false
        btnYesSelect.isCecked = false
        self.view.addBackground()
        WHAT_DO_YOU_GET_WHEN_ADDING_AN_EMPLOYEE.textAlignment = .center
        let USERDEF = UserDefaults.standard
        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            btnYesSelectHebrew.isHidden = false
            btnYesSelectHebrew.isUserInteractionEnabled = true
            btnYesSelect.isHidden = true
            btnYesSelect.isUserInteractionEnabled = false
            txtView.textAlignment = .right
            AGREE_THAT_YOU_HAVE_READ_THE_PAYMENT_TERMS_AFTER_THE_TRIAL_PERIOD.textAlignment = .right
        } else {
            btnYesSelectHebrew.isHidden = true
            btnYesSelectHebrew.isUserInteractionEnabled = false
            btnYesSelect.isHidden = false
            btnYesSelect.isUserInteractionEnabled = true
            txtView.textAlignment = .left
            txtView.textAlignment = .left
            AGREE_THAT_YOU_HAVE_READ_THE_PAYMENT_TERMS_AFTER_THE_TRIAL_PERIOD.textAlignment = .left
        }
        titletext.text = "ADD_CALENDARS".localized(LanguageMain.sharedInstance.USERLANGUAGE)  //title
        titletext.textAlignment = .center
        WHAT_DO_YOU_GET_WHEN_ADDING_AN_EMPLOYEE.text = "WHAT_IT_MEANS_TO_ADD_A_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE) //second line
        txtView.text = "EXPLAIN_ADD_CALENDAR_PRICE".localized(LanguageMain.sharedInstance.USERLANGUAGE) //long text explain manager and employee benefits
        AGREE_THAT_YOU_HAVE_READ_THE_PAYMENT_TERMS_AFTER_THE_TRIAL_PERIOD.text = "AGREE_THAT_YOU_HAVE_READ_THE_PAYMENT_TERMS_AFTER_THE_TRIAL_PERIOD".localized(LanguageMain.sharedInstance.USERLANGUAGE)  //last label
        btncontinue.setTitle("CONTINUE_TO_ADDING_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
    }
    @IBAction func btnYesSelect(_ sender: AnyObject) {
        btnYesSelect.isCecked = !btnYesSelect.isCecked
        UserAgreedWithTerms = !UserAgreedWithTerms
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //func to dismiss the popUp
    @IBAction func closePopup(_ sender:AnyObject) {
     self.dismiss(animated: false, completion: nil)
       
    }
    @IBAction func btncontinue(_ sender:AnyObject) {
        if UserAgreedWithTerms == true {
            print("agree")
            let mainstoryb = UIStoryboard(name: "addeditcalendar", bundle: nil)
            let viewRegulation: ADD_CALENDAR_FIRST_SCREEN = mainstoryb.instantiateViewController(withIdentifier: "ADD_CALENDAR_FIRST_SCREEN")as! ADD_CALENDAR_FIRST_SCREEN
            viewRegulation.delegate = self.delegate
            viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
            viewRegulation.modalPresentationStyle = .custom
            self.present(viewRegulation, animated: true, completion: {
                self.dismiss(animated: false, completion: nil)
            })

        } else {
            print("not agree")
            let alert = UIAlertController(title: "", message:
                "DID_NOT_AGREE_WITH_TERMS_POPUP_EMPLOYEES".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            self.present(alert, animated: false, completion: nil)
        }

    }
    
}
