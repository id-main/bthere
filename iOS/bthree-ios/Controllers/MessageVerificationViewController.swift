//
//  MessageVerificationViewController.swift
//  bthree-ios
//
//  Created by Tami wexelbom on 18.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import Darwin
//תת דף של הודעת אימות
class MessageVerificationViewController: UIViewController {

    //MARK: - Properties
    //  var view8 : loadingBthere!
    var numTries = 0
    var phone:String = ""
    var isProviderClickd = false
    var verification:String = ""
    var numClickedSendAgain:Int = 0//מונה את מספר הפעמים שלחצו על שלח שוב
    var generic:Generic = Generic()
    var delegate:openChooseUserDelegate!=nil
    var delegateCon:openControlersDelegate!=nil
    var delegate1:openCustomerDetailsDelegate!=nil
    var delegateShowPhone:popUpPhoneDelegate!=nil
    let window :UIWindow = UIApplication.shared.keyWindow!
    var supplierStoryBoard:UIStoryboard?
    var storyboardMain:UIStoryboard?
    var currentUserToEdit:User?
    var isFromPersonalDetails = Bool()//מציין אם הגיעו מעדכון פרטים אישיים וערכו את הטלפון
    var isemploye:Bool = false // is  employe
    var ismanager:Bool = false //is employe and manager
    var issimpleCustomer:Bool = true //is simple customer
    var providerID:Int = 0
    var ISSYNC:Bool = false
    //MARK: - Outlet

    @IBOutlet weak var notGetVer: UILabel!

    @IBOutlet weak var enterVerification: UILabel!

    @IBOutlet weak var lblTitleMessageVer: UILabel!
    //כפתור שלח שוב
    @IBAction func btnSendAgain(_ sender: AnyObject)
    {
        numClickedSendAgain += 1
        if numClickedSendAgain == 3
        {

            //מעבר חזרה לפופאפ של הכנסת טלפון שוב
            if delegateShowPhone != nil
            {
                self.delegateShowPhone.deleteTxtPhone()
            }
            self.dismiss(animated: true, completion: nil)

        }
        var dicPhone:Dictionary<String,String> = Dictionary<String,String>()
        dicPhone["nvPhoneNumber"] = phone

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetAndSmsValidationCode(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("responseObject  GetAndSmsValidationCode \(RESPONSEOBJECT)")

                }
                self.generic.hideNativeActivityIndicator(self)
            }
                ,failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
            })
        }
    }
    @IBOutlet weak var btnSendAgain: UIButton!
    @IBOutlet weak var txtVerification: UITextField!

    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        Global.sharedInstance.isRegisterProviderClick = false
        Global.sharedInstance.isRegisterClientClick = false
    }

    @IBOutlet weak var btnSendMessage: UIButton!

    //המשך


    @IBAction func btnSendMessage(_ sender: UIButton)
    {
        if isFromPersonalDetails == true
        {
            var dicPhone:Dictionary<String,String> = Dictionary<String,String>()
            dicPhone["nvPhoneNumber"] = phone

            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else
            {
                api.sharedInstance.GetAndSmsValidationCode(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                            print("RESPONSEOBJECT \(RESPONSEOBJECT)")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 0//הצליח
                            {
                                if Int(self.txtVerification.text!) == RESPONSEOBJECT["Result"] as? Int
                                {
                                    self.currentUserToEdit?.nvPhone = self.phone

                                    //שמירת פרטי הבנ״א
                                    self.UpdateUser()
                                }
                                else
                                {
                                    Alert.sharedInstance.showAlert("ILLEGAL_VERIFICATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                    self.txtVerification.text = ""
                                    self.numTries+=1
                                    if self.numTries == 3
                                    {
                                        self.numTries = 0
                                        exit(0)
                                    }
                                }
                            }
                            else
                            {
                                Alert.sharedInstance.showAlert("ILLEGAL_VERIFICATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                self.txtVerification.text = ""
                                self.numTries+=1
                                if self.numTries == 3
                                {
                                    self.numTries = 0
                                    exit(0)
                                }
                            }
                        }
                    }
                }
                    ,failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                })

            }
        }
        else if Global.sharedInstance.isFromRegister == false//הגיע מהלוגין
        {
            if txtVerification.text != ""
            {
                var dicLoginUser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicLoginUser["nvVerCode"] = txtVerification.text as AnyObject
                dicLoginUser["nvPhone"] = phone as AnyObject
                let APPDELnvVerCode:String = txtVerification.text!
                let APPDELnvPhone:String = phone
                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)
//                    showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else
                {
                    api.sharedInstance.LoginUser(dicLoginUser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if (RESPONSEOBJECT["Result"] as! Int) != 0
                            {
                                var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                dicUserId["currentUserId"] = RESPONSEOBJECT["Result"] as! Int as AnyObject
                                //שמירת הuserId- במכשיר
                                Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                                Global.sharedInstance.currentUser.iUserId = RESPONSEOBJECT["Result"] as! Int
                                Global.sharedInstance.defaults.set(APPDELnvVerCode,forKey: "APPDELnvVerCode")
                                Global.sharedInstance.defaults.set(APPDELnvPhone,forKey: "APPDELnvPhone")
                                Global.sharedInstance.defaults.synchronize()
                            }
                            print("APPDELnvVerCode \(Global.sharedInstance.defaults.value(forKey: "APPDELnvVerCode"))")
                            print("APPDELnvPhone \(Global.sharedInstance.defaults.value(forKey:"APPDELnvPhone"))")
                            Global.sharedInstance.defaults.synchronize()
                            self.dismiss(animated: true, completion: nil)

                            self.openCustomerOrProvider()

                            self.numTries = 0

                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dicForDefault["verification"] = self.txtVerification.text as AnyObject
                            dicForDefault["phone"] = self.phone as AnyObject
                            //שמירת הטלפון והקוד ב-default
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "verificationPhone")
                            self.UpdateToken()
                        }
                        else
                        {
                            Alert.sharedInstance.showAlert("ILLEGAL_VERIFICATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            self.txtVerification.text = ""
                            self.numTries+=1
                            if self.numTries == 3
                            {
                                self.numTries = 0
                                exit(0)
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                    })
                }
            }
            else
            {
                Alert.sharedInstance.showAlert("PASSWORD_NOT_ENTERD".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
        }
        else//רישום רגיל
        {
            var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dicPhone["nvPhoneNumber"] = phone as AnyObject

            if self.verification == self.txtVerification.text //הקוד שהכניס תקין
            {
                self.numTries = 0

                var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForDefault["verification"] = self.txtVerification.text as AnyObject
                dicForDefault["phone"] = self.phone as AnyObject
                //שמירת הטלפון והקוד ב-default
                Global.sharedInstance.defaults.set(dicForDefault, forKey: "verificationPhone")
                Global.sharedInstance.defaults.synchronize()
                self.dismiss(animated: true, completion: nil)

                //שמירת הנתונים של ה-user בשרת
                var dicRegister:Dictionary<String,Dictionary<String,AnyObject>> = Dictionary<String,Dictionary<String,AnyObject>>()
                var dicDicRegister:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                Global.sharedInstance.currentUser.nvDeviceToken = ""
                if    Global.sharedInstance.defaults.object(forKey: "62d4b8780f6d4e4e39b73c7454597191") != nil {
                    if let myString:String = Global.sharedInstance.defaults.object(forKey: "62d4b8780f6d4e4e39b73c7454597191") as? String {
                        Global.sharedInstance.currentUser.nvDeviceToken = myString
                    }

                }
                dicDicRegister = Global.sharedInstance.currentUser.getDic()


                print("APPDELnvVerCode \(Global.sharedInstance.defaults.value(forKey: "APPDELnvVerCode"))")
                print("APPDELnvPhone \(Global.sharedInstance.defaults.value(forKey:"APPDELnvPhone"))")
                Global.sharedInstance.defaults.synchronize()
                dicRegister["objUser"] = dicDicRegister
                print("what i send on registerUser: \(dicRegister["objUser"])")
                //setObject(tokenString, forKey:  "62d4b8780f6d4e4e39b73c7454597191")
                if self.ISSYNC == false {
                    self.generic.showNativeActivityIndicator(self)
                    if Reachability.isConnectedToNetwork() == false
                    {
                        self.generic.hideNativeActivityIndicator(self)
//                        showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else
                    {
                        api.sharedInstance.RegisterUser(dicRegister, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                print("RegisterUser response: \(responseObject)")
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                print("need verify to server \(dicRegister.description)")
                                print("RESPONSEOBJECT msg verification: \(String(describing: RESPONSEOBJECT["Result"]))")
                                var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                Global.sharedInstance.isFIRSTREGISTER = true
                                let APPDELnvPhone = Global.sharedInstance.currentUser.nvPhone
                                let APPDELnvVerCode = Global.sharedInstance.currentUser.nvVerification
                                Global.sharedInstance.defaults.set(APPDELnvVerCode,forKey: "APPDELnvVerCode")
                                Global.sharedInstance.defaults.set(APPDELnvPhone,forKey: "APPDELnvPhone")
                                Global.sharedInstance.defaults.synchronize()
                                dicUserId["currentUserId"] = RESPONSEOBJECT["Result"] as! Int as AnyObject
                                //שמירת הuserId- במכשיר
                                Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                                Global.sharedInstance.defaults.synchronize()
                                self.UpdateToken()
                                Global.sharedInstance.currentUser.iUserId = RESPONSEOBJECT["Result"] as! Int

                                if self.isProviderClickd == false
                                {
                                    if Global.sharedInstance.isFromViewMode == true
                                    {
                                        self.openDetailsOrder(1)
                                        Global.sharedInstance.isFromViewMode = false
                                    }else
                                    {
                                        self.openCustomer()//פתיחת לקוח קיים
                                    }
                                }
                                else
                                {
                                    self.openProvider()
                                }
                            }
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        })
                    }
                }

                    //end register step
                    //start update step
                else if self.ISSYNC == true {
                    self.generic.showNativeActivityIndicator(self)
                    var dicRegister:Dictionary<String,Dictionary<String,AnyObject>> = Dictionary<String,Dictionary<String,AnyObject>>()
                    var dicDicRegister:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                    Global.sharedInstance.currentUser.nvDeviceToken = ""
                    if    Global.sharedInstance.defaults.object(forKey: "62d4b8780f6d4e4e39b73c7454597191") != nil {
                        if let myString:String = Global.sharedInstance.defaults.object(forKey: "62d4b8780f6d4e4e39b73c7454597191") as? String {
                            Global.sharedInstance.currentUser.nvDeviceToken = myString
                        }

                    }
                    dicDicRegister = Global.sharedInstance.currentUser.getDic()
                    dicRegister["objUser"] = dicDicRegister
                     print("what i send on updateUser: \(dicRegister["objUser"])")

                    if Reachability.isConnectedToNetwork() == false
                    {
                        self.generic.hideNativeActivityIndicator(self)
//                        showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else
                    {


                        api.sharedInstance.UpdateUser(dicRegister, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                print("UpdateUser response: \(RESPONSEOBJECT)")
                                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {


                                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {

                                        //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                                    } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                        // Show success message
                                        let APPDELnvPhone = Global.sharedInstance.currentUser.nvPhone
                                        let APPDELnvVerCode = Global.sharedInstance.currentUser.nvVerification
                                        Global.sharedInstance.defaults.set(APPDELnvVerCode,forKey: "APPDELnvVerCode")
                                        Global.sharedInstance.defaults.set(APPDELnvPhone,forKey: "APPDELnvPhone")
                                        Global.sharedInstance.defaults.synchronize()
                                        if self.isProviderClickd == false
                                        {
                                            if Global.sharedInstance.isFromViewMode == true
                                            {
                                                self.openDetailsOrder(1)
                                                Global.sharedInstance.isFromViewMode = false
                                            }else
                                            {
                                                self.openCustomer()//פתיחת לקוח קיים
                                            }
                                        }
                                        else
                                        {
                                            self.openProvider()
                                        }
                                    }
                                }
                            }
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        })
                    }
                }
            }
            else//הקוד שהכניס לא תואם למה שקיבל-לא תקין
            {
                Alert.sharedInstance.showAlert("ILLEGAL_VERIFICATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                self.txtVerification.text = ""
                self.numTries+=1
                if self.numTries == 3
                {
                    self.numTries = 0
                    exit(0)
                }

            }
        }
        self.view.endEditing(true)//הורדת המקלדת
    }
    var attrs = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "OpenSansHebrew-Bold", size: 14)!,
        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black,
        convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1] as [String : Any]
    var attributedStringsUserExist = NSMutableAttributedString(string:"")

    //MARK: - Initial


    override func viewDidLoad() {
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
        USERDEF.synchronize()
        let mys = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")
        print("FINDisfromSPECIALiCustomerUserId \(mys)")
        notGetVer.text = "NOT_GET_VERIF".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        enterVerification.text = "ENTER_VERIFICATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //JMOD 15.12.2016
        enterVerification.adjustsFontSizeToFitWidth = true
        notGetVer.adjustsFontSizeToFitWidth = true
        notGetVer.textAlignment = .right
        btnSendMessage.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnSendAgain.setTitle("SEND_AGAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnSendAgain.titleLabel?.textAlignment = .left
        btnSendAgain.titleLabel?.adjustsFontSizeToFitWidth = true
        supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        lblTitleMessageVer.text = "MESSAGE_VERIFICATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnSendMessage.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        if isProviderClickd == true
        {
            lblTitleMessageVer.textColor = Colors.sharedInstance.color4
            btnSendMessage.backgroundColor = Colors.sharedInstance.color4
        }
        else
        {
            lblTitleMessageVer.textColor = Colors.sharedInstance.color3
            btnSendMessage.backgroundColor = Colors.sharedInstance.color3
        }
        let buttonTitleStr = NSMutableAttributedString(string:"SEND_AGAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary(attrs))
        attributedStringsUserExist.append(buttonTitleStr)


        btnSendAgain.setAttributedTitle(attributedStringsUserExist, for: UIControl.State())
        btnSendAgain.contentHorizontalAlignment = .left
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageVerificationViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        if Global.sharedInstance.currentUser.nvImage == ""
        {
            print("nu e poza buna - message verification")
        }
        else
        {
            print("e poza buna - message verification")
        }
        txtVerification.textAlignment = .center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }



    func openCustomer()
    {
        //קבלת פרטי הלקוח
        var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetCustomerDetails["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject

        self.generic.showNativeActivityIndicator(self)
        print("getCustomer details what i send: \(dicGetCustomerDetails)")
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                //                  print("aici doi \(responseObject ?? "" as AnyObject)")
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                    {
                        print("get customer details: \(RESPONSEOBJECT["Result"])")
                        var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        dicForDefault["nvClientName"] = RESPONSEOBJECT["Result"]!["nvFirstName"] as AnyObject
                        dicForDefault["nvPhone"] = RESPONSEOBJECT["Result"]!["nvPhone"] as AnyObject
                        //שמירת שם הלקוח במכשיר
                        Global.sharedInstance.defaults.set(dicForDefault, forKey: "currentClintName")
                        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        dicUserId["currentUserId"] = RESPONSEOBJECT["Result"]!["iUserId"] as AnyObject

                        //שמירת הuserId- במכשיר
                        Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                        ////    Global.sharedInstance.defaults.setObject("", forKey: "nvSupplierNotes") //hjust to have an empty val
                        Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                        //בגלל שנשמר יום אחד קודם צריך להוסיף 3 שעות(זה לא עזר להוסיף timeZone)
                        Global.sharedInstance.currentUser.dBirthdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dBirthdate
                            , options: [])!
                        Global.sharedInstance.currentUser.dMarriageDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dMarriageDate
                            , options: [])!
                        let APPDELnvPhone = Global.sharedInstance.currentUser.nvPhone
                        let APPDELnvVerCode = Global.sharedInstance.currentUser.nvVerification
                        Global.sharedInstance.defaults.set(APPDELnvVerCode,forKey: "APPDELnvVerCode")
                        Global.sharedInstance.defaults.set(APPDELnvPhone,forKey: "APPDELnvPhone")
                        Global.sharedInstance.defaults.synchronize()
                        self.openCustomerExist()
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
    }

    //מעבר ללקוח קיים
    func openCustomerExist()
    {
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        self.dismiss(animated: false, completion: nil)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController

        let rgister:entranceCustomerViewController = self.storyboard!.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        rgister.modalPresentationStyle = UIModalPresentationStyle.custom
        frontViewController.pushViewController(rgister, animated: false)

        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController

        let mainRevealController = SWRevealViewController()

        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController

        self.window.rootViewController = mainRevealController
        self.view.window?.makeKeyAndVisible()
        
        print("observer gone")
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BlockRegisterButton"), object: nil)
    }

    func openProvider()
    {
        var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            if !(Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1) {
                api.sharedInstance.getProviderAllDetails(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                        print("response get provider all details: \(RESPONSEOBJECT)")
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                            {
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                            {
                                self.dismiss(animated: false, completion: nil)
                                //פתיחת רישום ספק
                                self.delegate.openBuisnessDetails()
                            }
                            else
                            {
                                Global.sharedInstance.isProvider = true
                                if let _:Dictionary<String,AnyObject> =  RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                                    Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                    let mydic = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                    var iBusinessStatus:Int = 0
                                    var iSupplierStatus:Int = 0
                                    if let  _:Int = mydic["iBusinessStatus"] as? Int {
                                        iBusinessStatus = mydic["iBusinessStatus"] as! Int
                                    }
                                    if let  _:Int = mydic["iSupplierStatus"] as? Int {
                                        iSupplierStatus = mydic["iSupplierStatus"] as! Int
                                    }


                                    Global.sharedInstance.defaults.set(iBusinessStatus,  forKey: "iBusinessStatus")
                                    Global.sharedInstance.defaults.set(iSupplierStatus,  forKey: "iSupplierStatus")

                                    var iSyncedStatus:Int = 0
                                    if let  _:Int = mydic["iSyncedStatus"] as? Int {
                                        iSyncedStatus = mydic["iSyncedStatus"] as! Int
                                    }
                                    Global.sharedInstance.defaults.set(iSyncedStatus,  forKey: "iSyncedStatus")


                                    //שמירת שם הספק במכשיר
                                    var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                    dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                                    Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")

                                    Global.sharedInstance.defaults.synchronize()
                                    //מעבר לספק קיים
                                    if Global.sharedInstance.defaults.integer(forKey: "iSupplierStatus") == 2 ||   Global.sharedInstance.defaults.integer(forKey: "iSupplierStatus") == 0 {
                                        self.openCustomerExist()
                                        return
                                    }
                                    let frontviewcontroller = self.storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                                    let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
                                    let vc = storyboardSupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
                                    frontviewcontroller?.pushViewController(vc, animated: false)
                                    let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                    let mainRevealController = SWRevealViewController()
                                    mainRevealController.frontViewController = frontviewcontroller
                                    mainRevealController.rearViewController = rearViewController
                                    self.window.rootViewController = mainRevealController
                                    
                                    print("observer gone")
                                    NotificationCenter.default.removeObserver(self, name: Notification.Name("BlockRegisterButton"), object: nil)
                                    
                                }
                            }
                        }
                    }

                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
                })
            } else {

                api.sharedInstance.getProviderAllDetailsbyEmployeID(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                            {
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                            {
                                self.dismiss(animated: false, completion: {
                                //פתיחת רישום ספק
                                self.delegate.openBuisnessDetails()
                                })
                            }
                            else
                            {
                                Global.sharedInstance.isProvider = true
                                if let _:Dictionary<String,AnyObject> =  RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                                    Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                    let mydic = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                    var iBusinessStatus:Int = 0
                                    var iSupplierStatus:Int = 0
                                    if let  _:Int = mydic["iBusinessStatus"] as? Int {
                                        iBusinessStatus = mydic["iBusinessStatus"] as! Int
                                    }
                                    if let  _:Int = mydic["iSupplierStatus"] as? Int {
                                        iSupplierStatus = mydic["iSupplierStatus"] as! Int
                                    }


                                    Global.sharedInstance.defaults.set(iBusinessStatus,  forKey: "iBusinessStatus")
                                    Global.sharedInstance.defaults.set(iSupplierStatus,  forKey: "iSupplierStatus")

                                    var iSyncedStatus:Int = 0
                                    if let  _:Int = mydic["iSyncedStatus"] as? Int {
                                        iSyncedStatus = mydic["iSyncedStatus"] as! Int
                                    }
                                    Global.sharedInstance.defaults.set(iSyncedStatus,  forKey: "iSyncedStatus")


                                    //שמירת שם הספק במכשיר
                                    var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                    dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                                    Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")

                                    Global.sharedInstance.defaults.synchronize()
                                    //מעבר לספק קיים
                                    if Global.sharedInstance.defaults.integer(forKey: "iSupplierStatus") == 2 ||   Global.sharedInstance.defaults.integer(forKey: "iSupplierStatus") == 0 {
                                        self.openCustomerExist()
                                        return
                                    }
                                    let frontviewcontroller = self.storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                                    let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
                                    let vc = storyboardSupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
                                    frontviewcontroller?.pushViewController(vc, animated: false)
                                    let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                    let mainRevealController = SWRevealViewController()
                                    mainRevealController.frontViewController = frontviewcontroller
                                    mainRevealController.rearViewController = rearViewController
                                    self.window.rootViewController = mainRevealController
                                }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
                })
            }
        }
    }

    //say which calendar open
    func openCustomerOrProvider()
    {
        //קבלת פרטי הלקוח
        var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetCustomerDetails["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                //                print("aici unu \(responseObject ?? "" as AnyObject)")
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3


                    if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                    {
                        var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

                        dicForDefault["nvClientName"] = RESPONSEOBJECT["Result"]!["nvFirstName"] as AnyObject
                        dicForDefault["nvPhone"] = RESPONSEOBJECT["Result"]!["nvPhone"] as AnyObject
                        //שמירת שם הלקוח במכשיר
                        Global.sharedInstance.defaults.set(dicForDefault, forKey: "currentClintName")

                        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

                        dicUserId["currentUserId"] = RESPONSEOBJECT["Result"]!["iUserId"]  as AnyObject
                        //שמירת הuserId- במכשיר
                        Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")

                        Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                        //בגלל שנשמר יום אחד קודם צריך להוסיף 3 שעות(זה לא עזר להוסיף timeZone)
                        Global.sharedInstance.currentUser.dBirthdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dBirthdate
                            , options: [])!
                        Global.sharedInstance.currentUser.dMarriageDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dMarriageDate
                            , options: [])!
                        let APPDELnvPhone = Global.sharedInstance.currentUser.nvPhone
                        let APPDELnvVerCode = Global.sharedInstance.currentUser.nvVerification
                        Global.sharedInstance.defaults.set(APPDELnvVerCode,forKey: "APPDELnvVerCode")
                        Global.sharedInstance.defaults.set(APPDELnvPhone,forKey: "APPDELnvPhone")
                        Global.sharedInstance.defaults.synchronize()

                        if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
                        {
                            self.getProviderAllDetailsbyEmployeID(Global.sharedInstance.currentUser.iUserId)
                        }
                        else
                        {
                            self.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                        }
                    }
                    else
                    {
                        NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
                    }
                }
                else
                {
                    NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
                self.generic.hideNativeActivityIndicator(self)
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
    }

    //פתיחת רישום ספק
    func openBuisnessDetails(){

        Global.sharedInstance.isProvider = true

        let viewCon:RgisterModelViewController = self.storyboard?.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
        let viewCon1:GlobalDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController

        viewCon.delegateFirstSection = viewCon1
        viewCon.delegateSecond1Section = viewCon1

        self.navigationController?.pushViewController(viewCon, animated: false)
    }

    //מחזיר את פרטי הספק,אם הוא ספק מעביר ליומן ספק ,אחרת ללקוח קיים
    func getProviderAllDetails(_ iUserId:Int)
    {
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicUserId["iUserId"] = iUserId as AnyObject


        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {

            //קבלת פרטי הספק

            api.sharedInstance.getProviderAllDetails(dicUserId, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {


                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                        {
                            NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                        {
                            NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
                            UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")
                            NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
                            self.openCustomerExist()
                        }

                        else
                        {
                            //\\   print("crash getall \(responseObject["Result"])")
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {

                                Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)

                                //שמירת שם הספק במכשיר
                                var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

                                dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject

                                Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")

                                Global.sharedInstance.isProvider = true
                                Global.sharedInstance.defaults.synchronize()
                                //מעבר ליומן ספק קיים
                                NotificationCenter.default.post(name: Notification.Name("BlockRegisterButton"), object: nil)
                                self.trytogetProviderdata()
                            }
                        }
                    }
                }

            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
    }

    func getProviderAllDetailsbyEmployeID(_ iUserId:Int)
    {
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicUserId["iUserId"] = iUserId as AnyObject


        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            //קבלת פרטי הספק

            api.sharedInstance.getProviderAllDetails(dicUserId, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {


                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                        {
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                        {
                            UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")

                            self.openCustomerExist()
                        }

                        else
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObjByEmploye(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)

                                //שמירת שם הספק במכשיר
                                var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                                Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")
                                Global.sharedInstance.isProvider = true
                                Global.sharedInstance.defaults.synchronize()
                                //מעבר ליומן ספק קיים
                                self.trytogetProviderdata()
                            }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
    }
    //פונקציה זו מופעלת כאשר הגיע לרישום מהזמנת תור במצב צפיה - לאחר הרישום מתבצעת ההזמנה
    func openDetailsOrder(_ tag:Int)  {

        let storyboard = UIStoryboard(name: "ClientExist", bundle: nil)

        let frontviewcontroller = storyboardMain!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "detailsAppointmetClientViewController") as! detailsAppointmetClientViewController
        vc.tag = tag
        vc.fromViewMode = true
        frontviewcontroller?.pushViewController(vc, animated: false)

        let rearViewController = storyboardMain!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController

        let mainRevealController = SWRevealViewController()

        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController

        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController

    }

    //עדכון הפרטים בשרת
    func UpdateUser()
    {
        var dicDicRegister:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var dicRegister:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicDicRegister = currentUserToEdit!.getDicToEdit()

        dicRegister["objUser"] = dicDicRegister as AnyObject

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.UpdateUser(dicRegister as! Dictionary<String, Dictionary<String, AnyObject>>, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            Alert.sharedInstance.showAlert("ERROR_SAVECHANGES".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
                        }

                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            Alert.sharedInstance.showAlert("SUCCESS_SAVECHANGES".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            self.numTries = 0
                            //שמירת הטלפון והקוד ב-default
                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dicForDefault["verification"] = RESPONSEOBJECT["Result"]
                            dicForDefault["phone"] = self.phone as AnyObject
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "verificationPhone")
                            
                            self.reloadclient()
                            //חזרה להגדרות
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let frontviewcontroller:UINavigationController = UINavigationController()
//
//                            let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
//                            let vc = storyboardCExist.instantiateViewController(withIdentifier: "CustomerSettings") as! CustomerSettings
//
//                            frontviewcontroller.pushViewController(vc, animated: false)
//
//                            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//
//                            let mainRevealController = SWRevealViewController()
//
//                            mainRevealController.frontViewController = frontviewcontroller
//                            mainRevealController.rearViewController = rearViewController
//
//                            let window :UIWindow = UIApplication.shared.keyWindow!
//                            window.rootViewController = mainRevealController
                        }
                    }
                }


            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    
    func reloadclient(){
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            
            
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            
            if dicUserId["currentUserId"] as! Int != 0
            {
                //קבלת פרטי הלקוח
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                api.sharedInstance.GetCustomerDetails(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                            let RESULTFULL = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                            //\\     //\\print("GetCustomerDetails \(String(describing: RESPONSEOBJECT["Result"]))")
                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            
                            dicForDefault["nvClientName"] = RESULTFULL["nvFirstName"]
                            dicForDefault["nvPhone"] = RESULTFULL["nvPhone"]
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "currentClintName")
                            
                            var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            
                            dicUserId["currentUserId"] = RESULTFULL["iUserId"]
                            
                            if let _ = RESULTFULL["nvVerification"]
                            {
                                Global.sharedInstance.defaults.set(RESULTFULL["nvVerification"], forKey: "APPDELnvVerCode")
                            }
                            if let _ = RESULTFULL["nvPhone"]
                            {
                                Global.sharedInstance.defaults.set(RESULTFULL["nvPhone"], forKey: "APPDELnvPhone")
                            }
                            //save the userId on device
                            Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                            Global.sharedInstance.defaults.synchronize()
                            //\\   //\\print("user desc \(dicUserId.description)")
                            
                            
                            if let _:User = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>) {
                                Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                
                                Global.sharedInstance.currentUser.dBirthdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dBirthdate
                                    , options: [])!
                                Global.sharedInstance.currentUser.dMarriageDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dMarriageDate
                                    , options: [])!
                            }
                                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                        let frontviewcontroller:UINavigationController = UINavigationController()
                            
                                                        let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
                                                        let vc = storyboardCExist.instantiateViewController(withIdentifier: "CustomerSettings") as! CustomerSettings
                            
                                                        frontviewcontroller.pushViewController(vc, animated: false)
                            
                                                        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                            
                                                        let mainRevealController = SWRevealViewController()
                            
                                                        mainRevealController.frontViewController = frontviewcontroller
                                                        mainRevealController.rearViewController = rearViewController
                            
                                                        let window :UIWindow = UIApplication.shared.keyWindow!
                                                        window.rootViewController = mainRevealController
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            Global.sharedInstance.isProvider = false
//                            Global.sharedInstance.whichReveal = false
//                            let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
//                            let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
//                            frontviewcontroller?.pushViewController(vc, animated: false)
//
//                            //initialize REAR View Controller- it is the LEFT hand menu.
//
//                            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//                            let mainRevealController = SWRevealViewController()
//
//                            mainRevealController.frontViewController = frontviewcontroller
//                            mainRevealController.rearViewController = rearViewController
//                            let window :UIWindow = UIApplication.shared.keyWindow!
//                            window.rootViewController = mainRevealController
//                            window.makeKeyAndVisible()
                        }
                        
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    //                        if AppDelegate.showAlertInAppDelegate == false
                    //                        {
                    //                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    //                            AppDelegate.showAlertInAppDelegate = true
                    //                        }
                })
            }
        }
    }
    //JMODE PLUS
    func tryGetSupplierCustomerUserIdByEmployeeId() {
        var y:Int = 0
        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        dicuser["iUserId"] =  y as AnyObject
        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                {
                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                    print("tryGetSupplierCustomerUserIdByEmployeeId id e ok ? " + myInt.description)
                    if myInt == 0 {
                        //NO EMPL NO BUSINESS
                        //   self.setupdefaults(0)
                        //\\print ("no business")
                    } else {
                        //self.setupdefaults(myInt)
                        api.sharedInstance.GetSecondUserIdByFirstUserId(y)
                        self.callgetprovideralldetails(myInt)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
        })
    }
    func callgetprovideralldetails(_ iUseridSupplier:Int)
    {


        if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
        {
            api.sharedInstance.getProviderAllDetailsbySimpleUserID(iUseridSupplier)
        }
        else
        {
            api.sharedInstance.getProviderAllDetails(iUseridSupplier)
        }
    }

    func setupfinale(_ employeismanager: Int) {
        tryGetSupplierCustomerUserIdByEmployeeId()
        if employeismanager == 0 {
            self.ismanager = false

            Global.sharedInstance.defaults.set(0, forKey: "ismanager") //false
        } else{
            self.ismanager = true
            Global.sharedInstance.defaults.set(1, forKey: "ismanager") //true
        }
        if self.isemploye == true || Global.sharedInstance.providerID > 0 {
            openProvider()


            //\\print ("self.ismanager \(self.ismanager)")
        }
        //tableView.reloadData()
    }
    func trytogetProviderdata() {
        //check if is customer, worker or manager
        if Global.sharedInstance.providerID == 0 {
            //21.03.2017GetSupplierIdByEmployeeId
            if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
            {
                var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>

                if dicUserId["currentUserId"] as! Int != 0
                {
                    //קבלת פרטי הלקוח
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
                                    //NO EMPL NO BUSINESS
                                    self.setupdefaults(0)
                                } else {
                                    self.setupdefaults(myInt)
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        if AppDelegate.showAlertInAppDelegate == false
//                        {
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            AppDelegate.showAlertInAppDelegate = true
//                        }
                    })
                }
            }
        } else {
            self.setupdefaults(Global.sharedInstance.providerID)
        }
        //END JMODE PLUS
    }

    func setupdefaults(_ providerIDD: Int) {
        if providerIDD == 0 {
            //no bussiness simple customer
            self.issimpleCustomer = true
            self.isemploye = false
            Global.sharedInstance.providerID = 0
            Global.sharedInstance.defaults.set(1, forKey: "issimpleCustomer") //true
            Global.sharedInstance.defaults.set(0, forKey: "isemploye") //false
        } else {
            self.issimpleCustomer = false
            self.isemploye = true
            Global.sharedInstance.providerID = providerIDD
            Global.sharedInstance.defaults.set(0, forKey: "issimpleCustomer") //false
            Global.sharedInstance.defaults.set(1, forKey: "isemploye") //true
        }
        print("providerIDD \(Global.sharedInstance.providerID)")
        if  self.isemploye == true {
            if Reachability.isConnectedToNetwork() == false
            {
//                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else {


                var y:Int = 0
                var dicISMANAGERUSER:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                if Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId > 0 {
                    if  Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0{
                        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                                y = x
                            }
                        }
                        dicISMANAGERUSER["iUserId"] =  y as AnyObject

                    } else {
                        dicISMANAGERUSER["iUserId"] =   Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId as AnyObject
                    }
                } else {
                    if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                        let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                        if let x:Int = a.value(forKey: "currentUserId") as? Int{
                            y = x
                        }
                    }
                    dicISMANAGERUSER["iUserId"] =  y as AnyObject
                }


                //    dicISMANAGERUSER["iUserId"] =   Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.iProviderUserId
                print("\n********************************* IsManagerUser  ********************\n")
                //                let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicISMANAGERUSER, options: NSJSONWritingOptions.PrettyPrinted)
                //                let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
                //\\print(jsonString)

                if Reachability.isConnectedToNetwork() == false
                {

//                    showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else
                {
                    api.sharedInstance.IsManagerUser(dicISMANAGERUSER, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                                {
                                    //todo afisez eroare

                                    print("eroare la IsManagerUser \(String(describing: RESPONSEOBJECT["Error"]))")
                                }
                                else
                                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                                    {
                                        //todo afisez eroare

                                        print("eroare la IsManagerUser \(String(describing: RESPONSEOBJECT["Error"]))")
                                    }

                                    else
                                    {
                                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                        {
                                            let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                            if myInt == 1 {

                                                self.setupfinale(1)
                                                print("is manager")
                                            } else {
                                                self.setupfinale(0)
                                            }
                                        }
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        if AppDelegate.showAlertInAppDelegate == false
//                        {
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            AppDelegate.showAlertInAppDelegate = true
//                        }
                    })
                }
            }
        }
    }
    func UpdateToken() {
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if dicUserId["currentUserId"] as! Int != 0
            {
                var isok:Bool = false
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                if    Global.sharedInstance.defaults.object(forKey: "62d4b8780f6d4e4e39b73c7454597191") != nil {
                    if let myString:String = Global.sharedInstance.defaults.object(forKey: "62d4b8780f6d4e4e39b73c7454597191") as? String {
                        dicForServer["nvDeviceToken"] = myString as AnyObject
                        //                    var paths: Array = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                        //                    let documentsDirectory: String = paths[0]
                        //                    let logPath: String = documentsDirectory.stringByAppendingString("/console.log")

                        isok = true

                    }


                    if isok == true {
                        api.sharedInstance.UpdateDeviceTokenByUserId(dicForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                print("update token \(responseObject ?? "ceva" as AnyObject)")
                            }
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                            if AppDelegate.showAlertInAppDelegate == false
//                            {
//                                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                                AppDelegate.showAlertInAppDelegate = true
//                            }
                        })
                    }
                }
            }
        }
    }


    //END JMODEPLUS
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
