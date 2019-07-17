//
//  SendMassNotification.swift
//  BThere
//
//  Created by Ioan Ungureanu on 16/07/2018
//  Copyright © 2018 BThere. All rights reserved.
//
import Foundation
import UIKit
import EventKit

class SendMassNotification: NavigationModelViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    // UI Outlets
    @IBOutlet weak var popoutView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var makeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var notesErrorLabel:UILabel!
    @IBOutlet weak var tomuchtextErrorLabel:UILabel!
    let USERDEF = UserDefaults.standard
    // Variables
    var generic:Generic = Generic()
    var istextgood:Bool = false
    // Causes the TextFields to resign the first responder status.
    @objc func endedit(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:37)
    }
    // Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.delegate = self
        //ONE TIME PROMPT  MESSAGE



        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            notesTextView.textAlignment = .right
            tomuchtextErrorLabel.textAlignment = .right
        } else {
            notesTextView.textAlignment = .left
            tomuchtextErrorLabel.textAlignment = .left
        }
        titleLabel.text = "SEND_NOTIFICATION_TO_ALL_CUSTOMERS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        notesTextView.text = "MASS_NOTIFICATION_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        makeButton.setTitle("SEND_BT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        notesErrorLabel.text = "EVENT_ERROR_NO_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        tomuchtextErrorLabel.text = "INSERT_LESS_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        // Disable notes label interaction
        notesErrorLabel.isUserInteractionEnabled = true
        // Add a gesture when user taps un lable title to close all edits
        let tapendedit:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endedit(_:)))
        tapendedit.delegate = self
        popoutView.addGestureRecognizer(tapendedit)
    }

    override func viewDidAppear(_ animated: Bool) {
        if  USERDEF.object(forKey: "ONETIMEALRETFORMASSMESSAGE") == nil {
            USERDEF.set(0, forKey: "ONETIMEALRETFORMASSMESSAGE")
            USERDEF.synchronize()
        } else {
            if let _:Int = USERDEF.value(forKey: "ONETIMEALRETFORMASSMESSAGE") as? Int {
                let myint:Int = USERDEF.value(forKey: "ONETIMEALRETFORMASSMESSAGE") as! Int

                if myint == 0 {
                    //SHOW PROMPT AND  PUT 1 to never show it again
                    USERDEF.set(1, forKey: "ONETIMEALRETFORMASSMESSAGE")
                    USERDEF.synchronize()

                    //                self.showAlertDelegateX("ONE_TIME_PROMPT_FOR_MASS_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    Alert.sharedInstance.showAlertDelegate("ONE_TIME_PROMPT_FOR_MASS_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
            }
        }
    }

    // Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Close "New Event" pop out
    @IBAction func btnclose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion:nil)
        //   self.navigationController!.popToRootViewController(animated: true)
    }

    // Create new event
    @IBAction func createEvent(_ sender: AnyObject) {
        self.view.endEditing(true)
        if istextgood == false {
            //nothing
        } else {
            SendNotificationToCustomers()
        }
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

    //UITextViewDelegate  methods notesErrorLabel.hidden = true
    //MARK: - textView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView.text == "MASS_NOTIFICATION_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)) {
            textView.text = ""
        }
        var startString = ""
        if (textView.text != nil) {
            startString += textView.text!
        }
        startString += text
        var mybusinessname:Int = 0
        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName.count > 0 {
            mybusinessname =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName.count
        }
        let maxstringlenght = 120 - mybusinessname - 1 //space
        if startString.count > maxstringlenght {
            tomuchtextErrorLabel.isHidden =  false
            return false
        } else {
            tomuchtextErrorLabel.isHidden =  true
        }
        return true
    }
    // User begin to type something
    func textViewDidBeginEditing(_ textView: UITextView) {
        notesErrorLabel.isHidden = true
        if (textView.text == "MASS_NOTIFICATION_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)) {
            // Clear notes placeholder text
            textView.text = ""
        }
    }
    // User finished typing
    func textViewDidEndEditing(_ textView: UITextView) {
        // Check if empty
        if(textView.text == "" || textView.text ==  "MASS_NOTIFICATION_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)) {
            notesErrorLabel.text = "EVENT_ERROR_NO_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            textView.text =  "MASS_NOTIFICATION_PLACEHOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            notesErrorLabel.isHidden = false
            tomuchtextErrorLabel.isHidden =  true
            istextgood = false
        }
        else
        {
            istextgood = true
            tomuchtextErrorLabel.isHidden =  true
            notesErrorLabel.isHidden = true
        }
    }
    // Handle the text changes
    func textViewDidChange(_ textView: UITextView) {
        // The textView parameter is the textView where text was changed
        // Console
        print("text vv \(textView.text)")
    }
    //    API call
    func SendNotificationToCustomers() {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var supplierID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                supplierID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            supplierID = Global.sharedInstance.providerID
        }
        let massMessage = self.notesTextView.text
        let messageNoNewLines = massMessage?.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
        dic["iSupplierId"] = supplierID as AnyObject
        dic["nvMessage"] = messageNoNewLines as AnyObject
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            self.generic.showNativeActivityIndicator(self)
            api.sharedInstance.SendNotificationToCustomers(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    //\\     print(responseObject)
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            self.showAlertDelegateX("MESSAGE_SCHEDULED_FOR_SEND".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else {

                            self.showAlertDelegateX("FAIL_SEND_MASS_MEESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                }
            },failure:
                {
                    (AFHTTPRequestOperation, Error) -> Void in

                    self.generic.hideNativeActivityIndicator(self)
                    self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }

}

