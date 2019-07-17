//
//  ExistingUserPhoneViewController.swift
//  bthree-ios
//
//  Created by User on 12.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//להזין טלפון אם משתמש קיים
class ExistingUserPhoneViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var leftlabel972:NSLayoutConstraint!
    var didClickOnConnect:Bool = false//פלג זה מיועד למנוע מהמשתמש ללחוץ כמה פעמים על הכפתור התחבר.
    var delegate:openControlersDelegate!=nil
    var notValid = false
    var generic:Generic = Generic()

    @IBOutlet weak var existUser: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtFPhone: UITextField!
    @IBOutlet weak var btnConnect: UIButton!
    @IBAction func btnConnect(_ sender: AnyObject) {

        if didClickOnConnect == false
        {
            didClickOnConnect = true
            if txtFPhone.text == "" || txtFPhone.text == "REQUIRED_FIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                didClickOnConnect = false
                self.txtFPhone.textColor = UIColor.red
                self.txtFPhone.text = "REQUIRED_FIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                notValid = true
                self.txtFPhone.resignFirstResponder()
            }
            else
            {

                notValid = false
                var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                //JMODE 12.01.2018
                dicPhone["nvPhone"] = txtFPhone.text as AnyObject

                if Reachability.isConnectedToNetwork() == false
                {

                    //                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    didClickOnConnect = false
                }
                else
                {
                    api.sharedInstance.CheckPhoneValidity(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            //to do case 2 pana aici
                            if RESPONSEOBJECT["Result"] as! Int == 1 //לא קיים
                            {
                                self.txtFPhone.textColor = UIColor.red
                                self.txtFPhone.text = "PHONE_ERROR2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                self.notValid = true
                                self.didClickOnConnect = false
                                self.view.endEditing(true)
                            }
                            else if RESPONSEOBJECT["Result"] as! Int == 2 //this is existing with status 26 in db so we must tell him user not full registered
                            {
                                self.txtFPhone.textColor = UIColor.red
                                self.txtFPhone.text = "PHONE_ERROR3".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                self.notValid = true
                                self.didClickOnConnect = false
                                self.view.endEditing(true)
                            }
                            else
                            {
                                self.didClickOnConnect = true
                                self.notValid = false
                                var dicRestoreVerCode:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                //JMODE 12.01.2018
                                dicRestoreVerCode["nvPhone"] = self.txtFPhone.text as AnyObject
                                //     dicRestoreVerCode["nvPhone"] = finalservernumber
                                if Reachability.isConnectedToNetwork() == false
                                {
                                    //                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                                else
                                {

                                    if Reachability.isConnectedToNetwork() == false
                                    {
                                        //                                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                    }
                                    else
                                    {
                                        api.sharedInstance.RestoreVerCode(dicRestoreVerCode, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                                print("RestoreVerCode \(RESPONSEOBJECT)")
                                                Global.sharedInstance.isFromRegister = false
                                                self.dismiss(animated: false, completion: nil)
                                                //JMODE 12.01.2018
                                                self.delegate.openVerification(self.txtFPhone.text!)
                                            }
                                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                                        })
                                    }
                                }
                            }
                        }

                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.didClickOnConnect = false
                        self.txtFPhone.resignFirstResponder()
                    })
                }
            }
        }
    }

    //MARK: - Initial

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
        USERDEF.synchronize()
        let mys = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")
        print("FINDisfromSPECIALiCustomerUserId \(mys)")

        //        self.view.bringSubviewToFront(cancelBtn)

        txtFPhone.addTarget(self, action: #selector(ExistingUserPhoneViewController.textFieldDidChange), for: .editingChanged)

        txtFPhone.delegate = self
        
        txtFPhone.textAlignment = .center
        //        txtFPhone.borderStyle = .None

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ExistingUserPhoneViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)

        //        txtFPhone.layer.cornerRadius = 6

        //    lblPhone.text = "PHONE_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        existUser.text = "EXISTS_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnConnect.setTitle("BTN_CONNECT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: - KeyBoard

    ///dismiss keyboard

    @IBOutlet weak var cancelBtn: UIButton!

    @IBAction func cancelbtn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - TextField

    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtFPhone.textColor = UIColor.white
        txtFPhone.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @objc func textFieldDidChange()
    {
        if notValid == true
        {
            let lastCharacter = txtFPhone.text!.substring(from: txtFPhone.text!.characters.index(before: txtFPhone.text!.endIndex))

            notValid = false
            txtFPhone.text = lastCharacter
            txtFPhone.textColor = UIColor.white
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenSize: CGRect = UIScreen.main.bounds
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            leftlabel972.constant = screenSize.width - 60
        }
        else {
            leftlabel972.constant = 0

        }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        startString += string

        if startString.characters.count > 10
            //            startString != "REQUIRED_FIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            txtFPhone.resignFirstResponder()
            Alert.sharedInstance.showAlert("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)

            return false
        }
        else
        {
            return true
        }
    }
}
