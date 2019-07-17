//
//  popupAccessCode.swift
//  BThere
//
//  Created by Ioan Ungureanu on 09/11/17 dmy.
//  Copyright © 2017 Bthere-Tech. All rights reserved.
//

import Foundation
import UIKit



class popupAccessCode: UIViewController, UITextFieldDelegate, TTTAttributedLabelDelegate,UIGestureRecognizerDelegate {
    var constactNumber = ""
    var WHICHSCREEN:Int = 0
    var delegate:OPENVIEWSINPOPUP!=nil
    var delegate1:OPENVIEW2!=nil
    var delegateFromServiceCell:popUpOpenNewEmployee!=nil
    var delegateFromAddCalendarCell:openPopUpFromAddCalendarCell!=nil
    @IBOutlet weak var popUPPASSWORD:UIView!
    @IBOutlet weak var titlepopUPPASSWORD:UILabel!
    @IBOutlet weak var EXPLAIN_PASSWORD:TTTAttributedLabel!
    @IBOutlet weak var EXPLAIN_PASSWORD_LINETWO:TTTAttributedLabel!
    @IBOutlet weak var txtPASSWD: UITextField!
    @IBOutlet weak var btnCONFIRMPASS: UIButton!
    @IBOutlet weak var btnCloseX: UIButton!
    let SOMETEST: [UInt8] =  [62, 47, 4, 4, 85, 66, 28, 31] //NOW IS empl00y1 OBFUSCATED
 // CONTAINS OBFUSCATED PASSWORD
    @IBAction func btnCloseX(_ sender: AnyObject) {
        //self.popUPPASSWORD.hidden = true
        self.txtPASSWD.text = ""
      //  self.dismissKeyboard()
        self.dismiss(animated: false, completion: nil)
    }
//    func dismissKeyboard() {
//        self.view.endEditing(true)
//    }
    @IBAction func checkpassword(_ sender: AnyObject) {
      //  self.dismissKeyboard()
        let o = Obfuscator(withSalt: [AppDelegate.self, NSObject.self, NSString.self])
        //    let bytes = o.bytesByObfuscatingString(string: "empl00y1")
        //    print(bytes) /*[110, 97, 80, 70, 65, 122, 87, 83, 67, 50, 33, 34]*/
        let MYQWRTYCDS = o.reveal(key: SOMETEST) //COD ACEESS
        if self.txtPASSWD.text == "" {
            DispatchQueue.main.async(execute: { () -> Void in
                self.showAlertDelegateX("PASSWORD_NOT_ENTERED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        } else
            if self.txtPASSWD.text != ""  && self.txtPASSWD.text !=  MYQWRTYCDS {   //WAS "zen2088"  NOW IS empl00y1 OBFUSCATED{
                DispatchQueue.main.async(execute: { () -> Void in
                    self.showAlertDelegateX("WRONG_PASSWORD_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                })
            } else  if self.txtPASSWD.text ==     MYQWRTYCDS  { //WAS "zen2088" {
                self.gofaraway()
        }
        
    }
    func openSetupEmployee() {

    }
    func gofaraway() {
     //   self.dismissKeyboard()
        if  self.WHICHSCREEN == 3  {     //user entered calendar supplier and got prompt to add employee
            print("gata")
            Global.sharedInstance.isProvider = true
            Global.sharedInstance.whichReveal = true
            let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
            let  storyBoard1Main = UIStoryboard(name: "Main", bundle: nil)
            let frontviewcontroller = storyBoard1Main.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            let viewcon:  SettingsSetupEmployees = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupEmployees")as! SettingsSetupEmployees
            viewcon.view.frame = CGRect(x: 0, y:  64  , width: self.view.frame.width, height: self.view.frame.height - 64)
            frontviewcontroller!.pushViewController(viewcon, animated: false)
            //initialize REAR View Controller- it is the LEFT hand menu.
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
            return
            //////
        }
        self.dismiss(animated: false, completion: { () -> Void in
            if self.WHICHSCREEN == 1  {     //user tapped employees in settings
//                self.delegate.openView(WHICHINT: 1)
                self.delegateFromServiceCell.openNewEmployeeFunc()
            } else  if self.WHICHSCREEN == 2  {     //user tapped calendars in settings
//                 self.delegate.openView(WHICHINT: 2)
                self.delegateFromAddCalendarCell.addNewEmployee()
                
            }
        })



    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        //ACCESS_CODE_TEXT
        EXPLAIN_PASSWORD_LINETWO.delegate = self
        btnCONFIRMPASS.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        titlepopUPPASSWORD.text = "ACCESS_CODE_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        EXPLAIN_PASSWORD.text = "ACCESS_CODE_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        EXPLAIN_PASSWORD_LINETWO.text = "EXPLAIN_PASSWORD_LINETWO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        EXPLAIN_PASSWORD.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        EXPLAIN_PASSWORD_LINETWO.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
               let subscriptionNoticeAttributedString = NSAttributedString(string:"EXPLAIN_PASSWORD_LINETWO".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes: convertToOptionalNSAttributedStringKeyDictionary([
                convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont (name: "OpenSansHebrew-Regular", size: 18)!,
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black.cgColor,
            ]))
        EXPLAIN_PASSWORD_LINETWO.setText(subscriptionNoticeAttributedString)
        EXPLAIN_PASSWORD_LINETWO.linkAttributes = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.red,
            convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSNumber(value: true as Bool)
        ]

        EXPLAIN_PASSWORD_LINETWO.activeLinkAttributes =  [
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.red,
            convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSNumber(value: false as Bool)
        ]
        let a:NSString = "EXPLAIN_PASSWORD_LINETWO".localized(LanguageMain.sharedInstance.USERLANGUAGE) as NSString
        let subscribeLinkRange = a.range(of: "079-5740780")
        let subscribeURL = URL(string:"tel://ceva")!
        constactNumber = "0795740780"
        EXPLAIN_PASSWORD_LINETWO.addLink(to: subscribeURL, with:subscribeLinkRange)
        EXPLAIN_PASSWORD_LINETWO.isUserInteractionEnabled = true
        let tapGuide:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeCall))
        EXPLAIN_PASSWORD_LINETWO.addGestureRecognizer(tapGuide)
        txtPASSWD.delegate = self
       // txtPASSWD.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       txtPASSWD.text = ""



       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    @objc func makeCall()
    {
                Global.sharedInstance.makeCall(constactNumber as NSString)
        
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
