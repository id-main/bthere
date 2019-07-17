//
//  RgisterModelViewController.swift
//  bthree-ios
//
//  Created by Lior Ronen on 2/17/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Contacts
protocol viewErrorForFirstSectionDelegate{
    func viewErrorForFirstSection()
}
protocol openRegisterDelegate {
    func openRegisterView()
}
//מודל רישום ספק
class RgisterModelViewController: UIViewController,presentPaymentByCardDelegate,dismissPayByCardDelegate,openChooseUserDelegate,openCustomerDetailsDelegate,openRegisterDelegate,UIGestureRecognizerDelegate
{
    var isbackfromSetWorkingHours:Bool = false
    var nofirsttimemesage:Bool = false
    var  blockOperation:BlockOperation!
    @IBOutlet   weak var VIELOADER:UIView!
    //MARK: - Properties
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var receivedIPROVIDERID:Int = 0
    var startedAdddetails:Bool = false
    var startedAddprofile:Bool = false
    var onlyfirsttime:Bool = true
    var phone:Array<String> = []
    var chunksarryarr:[[objSyncContact]] =  [[objSyncContact]]()
    var whatarraytosend:Int = 0 //contains index of array of 300 contacts to send
    var howmanyarraystosend:Int = 0
    let phoneNumberKit = PhoneNumberKit()
    var subView = UIView()
    var labelPositionisLeft = true
    var isWeb = true
    var lastPageRegistered:Int = 0
    var generic:Generic = Generic()

    var viewCon:RegisterPaymentPage7ViewController = RegisterPaymentPage7ViewController()

    //מערך שמכיל עבור כל מסך בהרשמה מילון ששומר את התצוגה של המסך ואת הגודל שלו
    var viewsArray:Array<Array<AnyObject>> = []
    var delgateNotif:closeInTableDelegate!=nil

    var titles:Array<String> = ["BUSINESS_DETAILS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                               // "GLOBAL_DATA".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                "SET_WORKING_HOURS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                "SETUP_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                "BUSINESS_PROPHIL".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                "INVITE_CUSTOMERS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                "PAYMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    var view1 : BusinessDetailsViewController!
   // var view2 : GlobalDataViewController!
    //    let mainstoryb = UIStoryboard(name: "NewDevel", bundle: nil)
    //    let viewRegulation: SetupWorkingHours = mainstoryb.instantiateViewController(withIdentifier: "SetupWorkingHours")as! SetupWorkingHours
    //    viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
    //    viewRegulation.modalPresentationStyle = .custom
    //    self.present(viewRegulation, animated: true, completion: nil)
    var view3 : SetupWorkingHours!// AboutUsClientViewController!
    var viewServices : SetupServices!
    var view4 : RegisterBuisnessProphielViewController!
    var view5 : ContactSyncViewController!
    var view6 : PaymethodViewController!
    var view7 : BusinessDetailsViewController!
    var view8 : loadingBthere!

    var arrayLabel:Array<UILabel> = []
    var arrayImages:Array<UIImageView> = []
    var arrayViews:Array<UIView> = []

    var delegateCloseLast:closeLastCellSelegate!=nil
    var delegate:saveInGlobalDelegate!=nil
    var delegateFirstSection:viewErrorForFirstSectionDelegate!=nil
    var delegateSecond1Section:validSection1Delegate!=nil
    var supplierStoryBoard:UIStoryboard?
    var x = 0
    var getSysAlert = false//מציין האם קבלו נתונים לדף התראות
    var getFieldsAndCatg = false//מציין האם קבלו נתונים לדף נתונים כלליים
    var viewPopUpRegisterBusiness:popUpBusinessProfile!
    //MARK: - Outlets

    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var lbl4: UILabel!
    @IBOutlet var lbl5: UILabel!
    @IBOutlet var lbl6: UILabel!
    @IBOutlet var lbl7: UILabel!
    @IBOutlet weak var leftarrowblue: UIImageView!
    @IBOutlet weak var rightarrowblue: UIImageView!

    @IBOutlet weak var containerImagesRound: UIView! //blue or black circles

    @IBOutlet weak var lblNews: UILabel!

    @IBOutlet weak var viewBack: UIView!

    @IBOutlet weak var lblBack: UILabel!

    @IBOutlet weak var viewStep1: UIView!

    @IBOutlet weak var viewStep2: UIView!

    @IBOutlet weak var viewStep3: UIView!

    @IBOutlet weak var viewStep4: UIView!

    @IBOutlet weak var viewStep5: UIView!

    @IBOutlet weak var viewStep6: UIView!

    @IBOutlet weak var png1: UIImageView!

    @IBOutlet weak var png2: UIImageView!

    @IBOutlet weak var png3: UIImageView!

    @IBOutlet weak var png4: UIImageView!

    @IBOutlet weak var png5: UIImageView!

    @IBOutlet weak var png6: UIImageView!

    @IBOutlet weak var png7: UIImageView!

    @IBOutlet var view1_2: UIView!
    @IBOutlet var view2_3: UIView!
    @IBOutlet var view3_4: UIView!
    @IBOutlet var view4_5: UIView!
    @IBOutlet var view5_6: UIView!
    @IBOutlet var view6_7: UIView!
    @IBOutlet var imgModel: UIView!
    @IBOutlet var modelModel: UIView!

    @IBOutlet weak var viewContainBack: UIView!

    @IBOutlet weak var reqFieldLbl: UILabel!

    @IBOutlet weak var titleModelLbl: UILabel!

    @IBOutlet weak var btnCon: UIButton!

    //press on contine button
    @IBAction func btnCon(_ sender: UIButton) {

        // if AppDelegate.x < 5//במהלך הרישום
        //JMODE 5 is 4 now
        if AppDelegate.x < 4 // JMODE 4 is 5 now
        {
            if AppDelegate.x == 0
            {
                ///save the provider details in global
                delegate.saveDataInGlobal()
                print("AppDelegate.arrDomains.count \(AppDelegate.arrDomains.count)")
                if AppDelegate.arrDomains.count == 0
                {
                    self.generic.showNativeActivityIndicator(self)
                    if Reachability.isConnectedToNetwork() == false
                    {
                        self.generic.hideNativeActivityIndicator(self)
//                        Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)

                    }
                    else
                    {
                        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        let USERDEF = UserDefaults.standard
                        var defaultForlanguage:Int = 0
                        if  USERDEF.object(forKey: "CHOOSEN_LANGUAGE") == nil {
                            USERDEF.set(0, forKey: "CHOOSEN_LANGUAGE")
                            USERDEF.synchronize()
                            defaultForlanguage = 0
                        } else {
                            defaultForlanguage = USERDEF.integer(forKey: "CHOOSEN_LANGUAGE")
                        }

                        var finalIntforlang:Int = 2 //default english
                        //                        Hebrew - iLanguageId =  1
                        //                        English - iLanguageId =  2
                        //                        Romanian - iLanguageId =  3
                        finalIntforlang = defaultForlanguage  + 1
                        dic["iLanguageId"] = finalIntforlang as AnyObject
                        AppDelegate.arrDomains = Array<Domain>()
                        AppDelegate.arrDomainFilter = Array<Domain>()
                        api.sharedInstance.GetFieldsAndCatg(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3


                                self.getFieldsAndCatg = true

                                let domain:Domain = Domain()
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                    AppDelegate.arrDomains = domain.domainToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                }
                                if AppDelegate.arrDomains.count == 0
                                {
                                    Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))

                                }
                                else
                                {
                                    //      var idLast = -1
                                    for domain in AppDelegate.arrDomains
                                    {
                                        AppDelegate.arrDomainFilter.append(domain)
                                    }
                                }
                                self.addViewToModel()
                            }

                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
//                            if AppDelegate.showAlertInAppDelegate == false
//                            {
//                                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                                AppDelegate.showAlertInAppDelegate = true
//                            }
                        })
                    }
                }
                else
                {
                    getFieldsAndCatg = true
                }
            }

       /*JMODE removed on 21.02.2019     if AppDelegate.x == 1//נתונים כלליים general data
            {

                Global.sharedInstance.defaults.set(0, forKey:"ISFROMMENU")
                Global.sharedInstance.defaults.synchronize()
                //קריאה לפונקציה שתסגור ותשמור את הסל שהיה פתוח בלחיצה על המשך
                delegateCloseLast.closeCellFromOtherCell()

                Global.sharedInstance.isContinuPressed = true

                if Global.sharedInstance.domainBuisness != "" &&
                    //    Global.sharedInstance.isValidHours == true &&
                    //JMODE 09.01.2019     Global.sharedInstance.isHoursSelected.contains(true) &&
                    Global.sharedInstance.generalDetails.arrObjProviderServices.count != 0 &&
                    Global.sharedInstance.fIsSaveConBussinesServicesPressed == true
                {
                    //   move to step 2                 x = 0
                    //                    AddProviderDetails()
                    //                    startedAdddetails = true
                    self.addViewToModel()
                }
                else
                {
                    //ריענון הטבלה להצגת ההודעות שגיאה
                    Global.sharedInstance.delegateValidData.validData()
                    x = 1
                }
                if Global.sharedInstance.dicSysAlerts.count == 0
                {
                    self.generic.showNativeActivityIndicator(self)
                    if Reachability.isConnectedToNetwork() == false
                    {
//                        Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                        self.generic.hideNativeActivityIndicator(self)
                    }
                    else
                    {
                        let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        api.sharedInstance.GetSysAlertsList(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                self.getSysAlert = true
                                print("sysalerts \(String(describing: RESPONSEOBJECT["Result"]))")
                                let sysAlert:SysAlerts = SysAlerts()
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                    Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                }
                                if Global.sharedInstance.arrSysAlerts.count != 0
                                {
                                    Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
                                    Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
                                    Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
                                    Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
                                    Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
                                    Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
                                    self.addViewToModel()
                                    self.titleModelLbl.text = self.titles[AppDelegate.x]
                                }
                            }

                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
//                            if AppDelegate.showAlertInAppDelegate == false
//                            {
//                                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                                AppDelegate.showAlertInAppDelegate = true
//                            }
                        })

                    }
                }
                else
                {
                    self.getSysAlert = true
                }
            }
            //JMODE 3 is 2 now
            //            if AppDelegate.x == 3 //פרופיל עסקי
            //            {
            //                Global.sharedInstance.isFromSearchResults = false
            //            }

            if AppDelegate.x == 1
            {
                if Global.sharedInstance.domainBuisness == ""
                {
                    x = 1
                    delegateFirstSection.viewErrorForFirstSection()
                }
                if  x == 1
                {
                    return
                }
            }
           */

            if AppDelegate.x == 1 { // WAS 2 21.02.2019
//                startedAdddetails = false
//                if isbackfromSetWorkingHours ==  true {
//// nothing
//                isbackfromSetWorkingHours = false
//
//                } else {
                if AppDelegate.JHASVALIDHOURS == true
                {
                    //move to step 3

                } else {
                    x = 1 //WAS 2
//                    if nofirsttimemesage == false {
//                        nofirsttimemesage = true
//                    } else {
                    Alert.sharedInstance.showAlertDelegate("SELECT_HOURS_FOR_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                //    }
                    return
               // }
                }
            }
            if AppDelegate.x == 2 { //SERVICE VALIDATION
                if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
                     Alert.sharedInstance.showAlertDelegate("SELECT_SERVICE_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return
                } else {
                x = 0
                AddProviderDetails()
                startedAdddetails = true
                }
            }
            if AppDelegate.x == 3 //JMODE 21.02.2019 was 4 now 5 business profile page
            {
                Global.sharedInstance.isFromSearchResults = false
                if self.receivedIPROVIDERID > 0 {
                    AddProviderProfile(ida: self.receivedIPROVIDERID)
                }

            }
            //JMODE 4 is 3 now
            //  if AppDelegate.x == 4//סנכרון עם אנשי קשר

            if Global.sharedInstance.fIsValidDetails == false{
                return
            }



            if isWeb == true
            {
                if (getSysAlert == true && AppDelegate.x == 1) || (getFieldsAndCatg == true && AppDelegate.x == 0) || (AppDelegate.x != 0 && AppDelegate.x != 2)
                {
                    if startedAdddetails == true {
                        //nothing yet
                    } else {
                        startedAdddetails = false

                        addViewToModel()

                    }

                    titleModelLbl.text = titles[AppDelegate.x]
                }
            }
        }

        else//סיום הרישום
        {
            /*
             "objSyncContactsUsers": [
             {
             "nvFirstName" : "fn cust 1",
             "bAutomaticUpdateApproval" : false,
             "iLastModifyUserId" : 0,
             "nvPassword" : "",
             "nvUserName" : "",
             "iCityType" : 1,
             "nvVerification" : "",
             "bAdvertisingApproval" : false,
             "iCreatedByUserId" : 0,
             "bIsManager" : 0,
             "dBirthdate" : "\/Date(-2177459064000)\/",
             "nvMail" : "",
             "iUserStatusType" : 25,
             "bIsGoogleCalendarSync" : false,
             "bDataDownloadApproval" : false,
             "nvLastName" : "ln cust 1",
             "iSysRowStatus" : 1,
             "nvPhone" : "0547124500",
             "bTermOfUseApproval" : false
             }
             */
            //iustin old 3, new 4
            if AppDelegate.x == 4 { // 5 is 4 now
                //sync contacts
                var myarr:Array<Contact> = Array<Contact>()
                for contact in Global.sharedInstance.contactList {
                    if contact.bIsSync == true
                    {
                        myarr.append(contact)
                        if myarr.count >= 3 {
                            break
                        }
                    }
                }
                if myarr.count >= 3 {
                    // addViewToModel()
                    titleModelLbl.text = titles[AppDelegate.x]
                    // return
                } else {
                    //  self.showAlertDelegateX("PLEASE_SELECT_THREE_CONTACTS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    self.opensyncontactspopup()
                    return
                }
            }
            if AppDelegate.x == 3 // (before contacts)
            {

                Global.sharedInstance.dicSyncContacts["nvPhoneList"] = [] as AnyObject//it will throw an error if not empty
                Global.sharedInstance.dicSyncContacts["iProviderId"] = Global.sharedInstance.currentProvider.iIdBuisnessDetails as AnyObject
            }

            sender.isUserInteractionEnabled = false

            self.generic.showNativeActivityIndicator(self)
            //קבלת פרטי הלקוח
            var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

            dicGetCustomerDetails["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject

            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                            let RESPONSEFULL = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dicForDefault["nvClientName"] = RESPONSEFULL["nvFirstName"]
                            dicForDefault["nvPhone"] = RESPONSEFULL["nvPhone"]
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "currentClintName")
                            var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dicUserId["currentUserId"] = RESPONSEFULL["iUserId"]
                            
//                            dicUserId["currentUserId"] = RESPONSEFULL["nvPhone"]
                            Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                            Global.sharedInstance.defaults.synchronize()
                            Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                            Global.sharedInstance.currentUser.dBirthdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dBirthdate
                                , options: [])!
                            Global.sharedInstance.currentUser.dMarriageDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dMarriageDate
                                , options: [])!

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

            //--------------save providerAllDetails in server-------------
            preparesendContacts(_ida: self.receivedIPROVIDERID)

        }
    }
    func AddProviderDetails(){
        if let topController = UIApplication.topViewController() {
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            view8 = storyboard1.instantiateViewController(withIdentifier: "loadingBthere") as! loadingBthere
            let screenSize: CGRect = UIScreen.main.bounds
            view8.view.frame = screenSize
            view8.view.tag = 2000

            topController.view.addSubview(view8.view)
            topController.view.bringSubviewToFront(view8.view)
        }
        var dicAddProviderDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //1st step AddProviderDetails
        dicAddProviderDetails["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        dicAddProviderDetails["objProviderBuisnessDetails"] = Global.sharedInstance.currentProvider.getDic() as AnyObject
        dicAddProviderDetails["objProviderGeneralDetails"] = Global.sharedInstance.generalDetails.getDic() as AnyObject

        self.generic.showNativeActivityIndicator(self)

        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            //here must load loader
            api.sharedInstance.AddProviderDetails(dicAddProviderDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _ = RESPONSEOBJECT["Result"] as? Int {
                                self.view8.view.isHidden = true
                                //    self.showAlertDelegateX("ADDPROVIDERSUCCESMESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                let a = RESPONSEOBJECT["Result"] as! Int
                                if a > 0 {
                                    //put businesss in state of not pay in case user close app in this point
                                    //                                    Global.sharedInstance.defaults.set(0,  forKey: "iBusinessStatus")
                                    //                                    Global.sharedInstance.defaults.set(0,  forKey: "iSupplierStatus")
                                    Global.sharedInstance.defaults.set(0,  forKey: "iSyncedStatus")
                                    Global.sharedInstance.defaults.synchronize()
                                    self.receivedIPROVIDERID = a
                                    self.btnBack.isUserInteractionEnabled = false
                                    self.btnBack.isHidden = true
                                    self.vBack.isHidden = true
                                    self.vBack.isUserInteractionEnabled = false
                                    //                                    let alert = UIAlertController(title: nil, message: "ADDPROVIDERSUCCESMESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                                    //                                    alert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                                    print("go to page  2")
                                    self.addViewToModel()
                                    self.startedAdddetails = false
                                    //                                    })
                                    //                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    self.generic.hideNativeActivityIndicator(self)
                                    self.view8.view.isHidden = true
                                    self.startedAdddetails = false
                                    self.showAlertDelegateX("ERROR_REGISTER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                                //       self.AddProviderProfile(ida: a)hangeima
                            }

                            //

                            //\\JMODE PLUS IMPORTANT!
                            //   AppDelegate.x = 0

                        }
                        else
                        {
                            self.generic.hideNativeActivityIndicator(self)
                            self.view8.view.isHidden = true
                            self.startedAdddetails = false
                            self.showAlertDelegateX("ERROR_REGISTER".localized(LanguageMain.sharedInstance.USERLANGUAGE))

                            //מעבר ללקוח קיים
                            self.openRegisterView()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.view8.view.isHidden = true
                self.startedAdddetails = false
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })

        }
    }
    //2nd step
    func AddProviderProfile(ida:Int) {
        var idax:Int = 0
        if self.receivedIPROVIDERID > 0 {
            idax = self.receivedIPROVIDERID
        }
        var dicAddProviderDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicAddProviderDetails["objProviderAlertsSettings"] = Global.sharedInstance.addProviderAlertSettings.getDic() as AnyObject
        dicAddProviderDetails["objProviderProfile"] = Global.sharedInstance.addProviderBusinessProfile.getDic() as AnyObject
        dicAddProviderDetails["iBusinessId"] = idax as AnyObject
        self.generic.showNativeActivityIndicator(self)


        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            //here must load loader
            api.sharedInstance.AddProviderProfile(dicAddProviderDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _ = RESPONSEOBJECT["Result"] as? Int {

                                let a = RESPONSEOBJECT["Result"] as! Int
                                print(a)
                                if a != 1 {
                                    self.view8.view.isHidden = true
                                    self.showAlertDelegateX("ERROR_REGISTER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    self.openRegisterView()
                                } else {
                                    self.view8.view.isHidden = true
                                    //   self.preparesendContacts(_ida: ida)
                                }
                            }

                            //go to 3rd step sync contacts
                            //   AppDelegate.x = 0

                        }
                        else
                        {
                            self.generic.hideNativeActivityIndicator(self)
                            self.view8.view.isHidden = true
                            self.showAlertDelegateX("ERROR_REGISTER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            self.openRegisterView()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.view8.view.isHidden = true

//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })

        }

    }
    func opensyncontactspopup() {
        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
        let viewpopupSyncContacts = storyboardtest.instantiateViewController(withIdentifier: "popupSyncContacts") as! popupSyncContacts
        if self.iOS8 {
            viewpopupSyncContacts.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewpopupSyncContacts.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }

        self.present(viewpopupSyncContacts, animated: true, completion: nil)
    }
    //3rd step send sync by blocks of data
    func preparesendContacts(_ida:Int) {
        self.generic.showNativeActivityIndicator(self)
        var idax:Int = 0
        if self.receivedIPROVIDERID > 0 {
            idax = self.receivedIPROVIDERID
        }
        var swiftarr:Array<objSyncContact> = Array<objSyncContact>()
        var phones:Array<String> = []
        let dateString = "01/01/1901" // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        let birthday = dateFormatter.date(from: dateString)

        for contact in Global.sharedInstance.contactList {
            if contact.bIsSync == true
            {
                phones.append(contact.nvPhone)
            }
        }
        for contact in Global.sharedInstance.contactList {
            if contact.bIsSync == true
            {
                var nvfirstname = ""
                var nvlastname = ""
                if contact.nvFirstName != ""  {
                    nvfirstname = contact.nvFirstName
                }
                if contact.nvLastName != ""  {
                    nvlastname = contact.nvLastName
                }
                var nvNickName:String = ""
                nvNickName = nvfirstname + " " + nvlastname
                var cleannumber = ""
                if contact.nvPhone != "" {
                    cleannumber = cleanPhoneNumber(contact.nvPhone)
                }
                if cleannumber.count > 2 {
                    let numertocompare = cleannumber
                    let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                    let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                    if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {

                        //ignore all bad numbers
                    }
                    else
                    {
                        let  objSyncContactnew:objSyncContact =  objSyncContact(_nvFirstName: "", _bAutomaticUpdateApproval: false, _iLastModifyUserId: 0, _nvPassword: "", _nvUserName: "", _iCityType: 0, _nvVerification: "", _bAdvertisingApproval: false, _iCreatedByUserId: 0, _bIsManager: 0, _dBirthdate: birthday!, _nvMail: "", _iUserStatusType: 26, _bIsGoogleCalendarSync: false, _bDataDownloadApproval: false, _nvLastName: "", _nvPhone: /*contact.nvPhone*/ cleannumber, _iSysRowStatus: 1, _bTermOfUseApproval: false, _iUserId: 0,_allPHONES: [], _nvNickName: nvNickName)
                        if !swiftarr.contains(objSyncContactnew) {
                            swiftarr.append(objSyncContactnew)
                        }
                    }
                }
            }
        }
        if swiftarr.count == 0 {
            self.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
            // self.openTrialScreen()
        } else
            if swiftarr.count > 100 {
                let chunkSize = 100
                let chunks = stride(from: 0, to: swiftarr.count, by: chunkSize).map {
                    Array(swiftarr[$0..<min($0 + chunkSize, swiftarr.count)])
                }
                print("chunks \(chunks)")
                howmanyarraystosend = chunks.count
                self.chunksarryarr = chunks
                self.alldatasend(_ida: idax )
            }
            else {
                howmanyarraystosend = 1
                sendContacts(listof300: swiftarr, ida: idax)
        }


    }
    func alldatasend( _ida:Int) {
        let whatgroup = self.whatarraytosend
        let arr = self.chunksarryarr
        if let _ = arr[whatgroup] as [objSyncContact]? {
            let listof300 = arr[whatgroup]
            sendContacts(listof300: listof300, ida: _ida)
        }
    }
    func sendContacts(listof300:Array<objSyncContact>, ida:Int){
        if let topController = UIApplication.topViewController() {
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            view8 = (storyboard1.instantiateViewController(withIdentifier: "loadingBthere") as! loadingBthere)
            let screenSize: CGRect = UIScreen.main.bounds
            view8.view.frame = screenSize
            view8.view.tag = 2000

            topController.view.addSubview(view8.view)
            topController.view.bringSubviewToFront(view8.view)
        }
        var dicAddProviderDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        let emptyarr:Array = [] as Array
        dicAddProviderDetails["nvPhoneList"] = emptyarr as AnyObject
        if dicAddProviderDetails["bAutoApproval"] != nil
        {
            dicAddProviderDetails["bAutoApproval"] = Global.sharedInstance.dicSyncContacts["bAutoApproval"]
        }
        else
        {
            dicAddProviderDetails["bAutoApproval"] = true as AnyObject
        }

        var asend:NSMutableArray = NSMutableArray()
        asend = []
        for item in listof300 {
            let objtoadd = item.getDic()
            if !asend.contains(objtoadd) {
                asend.add(objtoadd)
            }
        }
        self.generic.showNativeActivityIndicator(self)
        howmanyarraystosend = howmanyarraystosend - 1
        self.whatarraytosend = self.whatarraytosend + 1

        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            self.view8.view.isHidden = true
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            dicAddProviderDetails["objSyncContactsUsers"] = asend as AnyObject
            dicAddProviderDetails["iProviderId"] = ida as AnyObject


            api.sharedInstance.SyncContactsRegistration(dicAddProviderDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.view8.view.isHidden = true
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            if self.howmanyarraystosend == 0 {
                                AppDelegate.x = 0 //IMPORTANT
                                self.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                                //  self.openTrialScreen()
                            } else {
                                self.alldatasend(_ida: ida)
                            }
                        }
                        else
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!

                                if myInt == 1 {
                                    if self.howmanyarraystosend == 0 {
                                        AppDelegate.x = 0 //IMPORTANT
                                        self.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                                        //    self.openTrialScreen()
                                    } else {
                                        self.alldatasend(_ida: ida)
                                    }
                                }
                        }
                    }
                }

            },failure: {(AFHTTPRequestOperation, Error) -> Void in

                self.generic.hideNativeActivityIndicator(self)
                self.view8.view.isHidden = true
                if self.howmanyarraystosend == 0 {
                    AppDelegate.x = 0 //IMPORTANT
                    self.getProviderAllDetails(Global.sharedInstance.currentUser.iUserId)
                    //  self.openTrialScreen()
                } else {
                    self.alldatasend(_ida: ida)
                }

            })
        }
    }
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var vBack: UIView!
    //press on back button
    @IBAction func btnBack(_ sender: UIButton) {
        goBack()
    }

    //go to prev page
    @objc func goBack() {
        //\\     self.blockOperation.cancel()
        if AppDelegate.x != 0//לא עמוד ראשון
        {
            if AppDelegate.x == 1//נתונים כלליים
            {
                Global.sharedInstance.isFromBack = true
            }
            if AppDelegate.x == 1 {
                isbackfromSetWorkingHours = true //because need revalidation if user goes back
            }
            if  AppDelegate.x == 2 {
                 startedAdddetails = false
            }
            //            else if AppDelegate.x == 2//נמצאים עכשיו בדף התראות
            //            {
            //                //סגירת הטבלה הפנימית-ע״מ למנוע בעיות במיקום הטבלה
            //                delgateNotif.closeInTable()
            //            }


            Global.sharedInstance.arrayViewModel[AppDelegate.x].view.removeFromSuperview()
            //  arrayViews[AppDelegate.x - 1].backgroundColor = Colors.sharedInstance.color6
            //  arrayImages[AppDelegate.x].hidden = false


            AppDelegate.x -= 1
            if AppDelegate.x > 1{
                reqFieldLbl.isHidden = true
            }
            else{
                reqFieldLbl.isHidden = false

            }
            //JMODE 5 is 4 and 4 is 3 now
            self.view.addSubview(Global.sharedInstance.arrayViewModel[AppDelegate.x].view)
            //            if AppDelegate.x == 4 || AppDelegate.x == 5{
            //                reqFieldLbl.textColor = UIColor.clearColor()
            //            }
            //iustin old 3, new 4
            if AppDelegate.x == 4 || AppDelegate.x == 5{
                reqFieldLbl.textColor = UIColor.clear
            }
            else{
                reqFieldLbl.textColor = UIColor.black
            }
            titleModelLbl.text = titles[AppDelegate.x]
            arrayImages[AppDelegate.x].isHidden = false
            //            for i in 0 ..< AppDelegate.x  {
            //                arrayViews[i].backgroundColor = Colors.sharedInstance.color4
            //            }

        }
        else//העמוד הראשון של הרישום
        {
            // Create the alert controller
            let alertController = UIAlertController(title: "MESSAGE_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE), message: "EXIT_REGISTER".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)

            // Create the actions
            let okAction = UIAlertAction(title: "YES".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.openRegisterView()
            }
            let cancelAction = UIAlertAction(title: "NO".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        changeImgforbullets()
    }

    //MARK: - initial
    override func viewDidLoad() {
        super.viewDidLoad()

        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {

            rightarrowblue.image =    UIImage(named: "leftarrowblue.png")
            leftarrowblue.image =    UIImage(named: "returnarrowinsuppliuerregistrationhebrew.png")
        }
        else
        {
            rightarrowblue.image =    UIImage(named: "rightarrowblue.png")
            leftarrowblue.image =    UIImage(named: "returnarrowinsuppliuerregistration.png")
        }

        self.navigationItem.setHidesBackButton(true, animated:false)


        reqFieldLbl.text = "REQUIRED_FIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        Global.sharedInstance.globalData = self

        supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor.black

        let backView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))

        let titleImageView: UIImageView = UIImageView(image: UIImage(named: "3.png"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleImageView.frame.size.width * 0.8, height: 40)
        backView.addSubview(titleImageView)

        self.navigationItem.titleView = backView

        Global.sharedInstance.arrayViewModel = []
        /////\\JCHECK   IMPORTANT
        AppDelegate.x = 0

        btnBack.isEnabled = true
        //    viewBack.hidden = false
        //  lblBack.hidden = false
        //תמיכה באייפון 5 ובקטנים יותר
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS{
            titleModelLbl.font = Colors.sharedInstance.fontSecondHeader
            //   lblBack.font = Colors.sharedInstance.fontText3
        }
        Global.sharedInstance.heightModel = self.view.frame.size.height
        Global.sharedInstance.rgisterModelViewController = self

        self.view.bringSubviewToFront(btnCon)
        titleModelLbl.text = titles[AppDelegate.x]

        arrayImages.append(png1)
        arrayImages.append(png2)
        arrayImages.append(png3)
        arrayImages.append(png4)
        arrayImages.append(png5)
      //  arrayImages.append(png6)

        subView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + self.navigationController!.navigationBar.frame.size.height  , width: view.frame.width, height: view.frame.height * 0.2 - 9)

        view1 = (self.storyboard?.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as! BusinessDetailsViewController)

        view1.view.frame = CGRect(x: 0, y: 90  , width: view.frame.width, height: view.frame.height - subView.frame.height - self.navigationController!.navigationBar.frame.size.height - ( (view.frame.size.height * 0.1) + 18 ))

        Global.sharedInstance.defaults.set(0, forKey: "ISFROMSETTINGS")
        Global.sharedInstance.defaults.synchronize()
//        view2 = (self.storyboard?.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController)
//        view2.view.frame = CGRect(x: 0, y: 120, width: view.frame.width, height: self.view.frame.size.height - self.view.frame.height * 0.08 - self.navigationController!.navigationBar.frame.size.height * 2 )
        Global.sharedInstance.ISFROMSETTINGS = false
        print("what is h: \(self.view.frame.size.height - self.view.frame.height * 0.08 - self.navigationController!.navigationBar.frame.size.height)")
        //iustin
        //        let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        //        view3 = clientStoryBoard.instantiateViewController(withIdentifier: "AboutUsClientViewController") as! AboutUsClientViewController
        let mainstoryb = UIStoryboard(name: "NewDevel", bundle: nil)
        view3 = (mainstoryb.instantiateViewController(withIdentifier: "SetupWorkingHours")as! SetupWorkingHours)
        view3.view.frame = CGRect(x: 0, y: 120, width: view.frame.width, height: self.view.frame.size.height - self.view.frame.height * 0.08 - self.navigationController!.navigationBar.frame.size.height * 2 - 40 )
        let mainstorybd = UIStoryboard(name: "newlistservices", bundle: nil)
        viewServices = mainstorybd.instantiateViewController(withIdentifier: "SetupServices")as! SetupServices
        viewServices.view.frame = CGRect(x: 0, y: 8, width: view.frame.width, height:  self.view.frame.height  - self.navigationController!.navigationBar.frame.size.height  - 20)
        view4 = (self.storyboard?.instantiateViewController(withIdentifier: "RegisterBuisnessProphielViewController") as! RegisterBuisnessProphielViewController)
        view4.view.frame = CGRect(x: 0, y: 120, width: view.frame.width, height: self.view.frame.size.height - self.view.frame.height * 0.08 - self.navigationController!.navigationBar.frame.size.height * 2 - 40 )
        view5 = (self.storyboard?.instantiateViewController(withIdentifier: "ContactSyncViewController") as! ContactSyncViewController)
        view5.view.frame = CGRect(x: 0, y: 90, width: view.frame.width, height: self.view.frame.size.height - self.view.frame.height * 0.08 - self.navigationController!.navigationBar.frame.size.height * 2 - 40)
        Global.sharedInstance.arrayViewModel = []
        Global.sharedInstance.arrayViewModel.append(view1)
    //    Global.sharedInstance.arrayViewModel.append(view2)
        Global.sharedInstance.arrayViewModel.append(view3)
        Global.sharedInstance.arrayViewModel.append(viewServices)
        Global.sharedInstance.arrayViewModel.append(view4)
        Global.sharedInstance.arrayViewModel.append(view5)

        UIView.animate(withDuration: 4, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.repeat,.transitionFlipFromRight], animations:
        {
        }, completion: nil)

        labelPositionisLeft = !labelPositionisLeft
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RgisterModelViewController.dismissKeyboard))
        vBack.addGestureRecognizer(tap1)
        tap1.delegate = self
        //add tap to back
        let tapBack: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RgisterModelViewController.goBack))

        btnBack.addGestureRecognizer(tapBack)
        self.view.bringSubviewToFront(modelModel)

        self.view.addSubview(Global.sharedInstance.arrayViewModel[AppDelegate.x].view)
        self.view.addBackground2()
        changeImgforbullets()
        //DispatchQueue.global(qos: .userInitiated).async {
        DispatchQueue.main.async {
            self.reloadCateg()
        }
        DispatchQueue.global(qos: .background).async {
            //        blockOperation = BlockOperation {
            self.setContacts()
            //        }
            //        let queue = OperationQueue()
            //        queue.addOperation(blockOperation)

        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:3)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func setContacts() {
        //  self.generic.showNativeActivityIndicator(self)

        Global.sharedInstance.contactList = []
        let store = CNContactStore()
        print(CNContactStore.authorizationStatus(for: .contacts).hashValue)
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .denied:
            //            self.generic.hideNativeActivityIndicator(self)
            //            self.generic.hideNativeActivityIndicator(self.view1)

            print("ask")
            let alert = UIAlertController(title: nil, message: "REQUEST_CONTACTS_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
            })
            var rootViewController = UIApplication.shared.keyWindow?.rootViewController
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.first
            }
            if let tabBarController = rootViewController as? UITabBarController {
                rootViewController = tabBarController.selectedViewController
            }
            rootViewController?.present(alert, animated: true, completion: nil)
        case .authorized:
            print("access granted")
            // getContactNames()
            // print("lazy \(self.contacts)")
            var contactsFull: [CNContact] = []
            contactsFull = self.contacts()
            /////// JMODE PLUS NEW iOS 10 CONTACT LOCATIONS ////////
            
            var indexForUserid : Int = 0

            for record:CNContact in contactsFull
            {
                phone = []
                let contactPerson: CNContact = record
                var givenName = ""
                var familyName = ""
                var numecompus = ""
                var MobNumVar = ""

                givenName = contactPerson.givenName;
                familyName = contactPerson.familyName;
                numecompus = givenName + " " + familyName
                if numecompus.count > 0 {
                    if contactPerson.phoneNumbers.count > 0 {
                        //person has 1 or more numbers
                        for i in 0..<contactPerson.phoneNumbers.count {
                            MobNumVar = (contactPerson.phoneNumbers[i].value ).value(forKey: "digits") as! String
                            let cleaned =  cleanPhoneNumber(MobNumVar)
                            if cleaned.count > 2 {
                                let numertocompare = cleaned
                                let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                                let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                                if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {

                                    //ignore all bad numbers
                                    // print("bad number? \(numertocompare)")
                                } else {
                                    //all this person numbers go to _allPHONES:phone array see below
                                    if !phone.contains(cleaned)   {
                                        phone.append(cleaned)
                                    }
                                }
                            }
                        }
                        if phone.count > 0 {
                            for i in 0..<phone.count { //JMODE+ 28.01.2019
                            indexForUserid = indexForUserid + 1
                            let firstvalidphone = phone[i] // JMODE phone[0]old code only first valid number found is added to _nvPhone
                            let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:phone,_nvNickName:numecompus)
                            Global.sharedInstance.contactList.append(c)
                        }
                        }
                    }
                }
            }
            var myafterset =   Global.sharedInstance.contactList.uniquevals
            Global.sharedInstance.contactList = myafterset
            //   let descriptor: NSSortDescriptor = NSSortDescriptor(key: "nvLastName", ascending: true)
            let sortedByFirstNameSwifty =  Global.sharedInstance.contactList.sorted(by: { $0.nvLastName < $1.nvLastName })
            Global.sharedInstance.contactList = sortedByFirstNameSwifty

            //            print("ce are aici iar \(Global.sharedInstance.contactList )")
            ////    END PARSING ////
            //    self.generic.hideNativeActivityIndicator(self)
            //  self.generic.hideNativeActivityIndicator(self.view1)

        case .notDetermined:
            //  self.generic.hideNativeActivityIndicator(self)
            print("requesting access...")
            store.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded
                    else{
                        print("error")
                        return
                }
                print("no try access granted")
                //  self.getContactNames()
                let alert = UIAlertController(title: nil, message: "REQUEST_CONTACTS_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
                })
                var rootViewController = UIApplication.shared.keyWindow?.rootViewController
                if let navigationController = rootViewController as? UINavigationController {
                    rootViewController = navigationController.viewControllers.first
                }
                if let tabBarController = rootViewController as? UITabBarController {
                    rootViewController = tabBarController.selectedViewController
                }
                rootViewController?.present(alert, animated: true, completion: nil)

            }
        default:
            print("Not handled")
            //            self.generic.hideNativeActivityIndicator(self)
            //            self.generic.hideNativeActivityIndicator(self.view1)
        }
        //        self.generic.hideNativeActivityIndicator(self)
        //        self.generic.hideNativeActivityIndicator(self.view1)
    }

    func contacts() -> [CNContact]  {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            //  CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            //  CNContactImageDataAvailableKey,
            //   CNContactThumbnailImageDataKey
            ] as [Any]

        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }

        return results
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - presentPaymentByCardDelegate

    //show payment page
    func presentPaymentByCard(){
        viewCon = storyboard?.instantiateViewController(withIdentifier: "RegisterPaymentPage7ViewController") as! RegisterPaymentPage7ViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        viewCon.delegate = self
        self.present(viewCon, animated: true, completion: nil)

    }
    //dismiss payment page
    func dismissPayByCard()
    {
        viewCon.dismiss(animated: true, completion: nil)
    }

    func openBuisnessDetails()
    {
        let viewCon:RgisterModelViewController = self.storyboard?.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
        let viewCon1:GlobalDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController

        viewCon.delegateFirstSection = viewCon1
        viewCon.delegateSecond1Section = viewCon1

        let front = self.storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController

        front.pushViewController(viewCon, animated: false)

        let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController

        let mainRevealController = SWRevealViewController()

        mainRevealController.frontViewController = front
        mainRevealController.rearViewController = rearViewController

        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }

    //פתיחת לקוח קיים
    func openCustomerDetails()
    {
        let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        Global.sharedInstance.whichDesignOpenDetailsAppointment = 0
        let viewCon:ModelCalenderViewController = clientStoryBoard.instantiateViewController(withIdentifier: "ModelCalenderViewController") as! ModelCalenderViewController

        let front = self.storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController

        front.pushViewController(viewCon, animated: false)

        let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController

        let mainRevealController = SWRevealViewController()

        mainRevealController.frontViewController = front
        mainRevealController.rearViewController = rearViewController

        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    //פתיחת לקוח קיים ,במקרה שיצא מרישום ספק ע״י חזור חזור
    func openRegisterView(){
        Global.sharedInstance.defaults.set(0,  forKey: "isenteringregister")
        Global.sharedInstance.defaults.synchronize()
        Global.sharedInstance.isProvider = false

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
        Global.sharedInstance.defaults.synchronize()
        let rgister:entranceCustomerViewController = self.storyboard!.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        rgister.modalPresentationStyle = UIModalPresentationStyle.custom
        frontViewController.pushViewController(rgister, animated: false)

        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController

        let mainRevealController = SWRevealViewController()

        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController

        self.view.window!.rootViewController = mainRevealController
        self.view.window?.makeKeyAndVisible()
    }

    func addViewToModel()
    {
        Global.sharedInstance.arrayViewModel[AppDelegate.x].view.removeFromSuperview()
        changeImgforbullets()
        AppDelegate.x += 1

        if AppDelegate.x > lastPageRegistered
        {
            lastPageRegistered += 1
        }
        //iustin old 3, new 4
        if AppDelegate.x == 4{
            Global.sharedInstance.isClickCon = true
        }
        if AppDelegate.x > 1{
            reqFieldLbl.isHidden = true
        }
        else{
            reqFieldLbl.isHidden = false
        }
        self.view.addSubview(Global.sharedInstance.arrayViewModel[AppDelegate.x].view)
        self.view.bringSubviewToFront(Global.sharedInstance.arrayViewModel[AppDelegate.x].view)
        //iustin old 4, new 3
        if AppDelegate.x == 3
        {
            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
            viewPopUpRegisterBusiness = storyboardtest.instantiateViewController(withIdentifier: "popUpBusinessProfile") as! popUpBusinessProfile
            self.present(viewPopUpRegisterBusiness, animated: true, completion: nil)
        }
        //iustin old 3, new 4
        if AppDelegate.x == 4 || AppDelegate.x == 5{
            reqFieldLbl.textColor = UIColor.clear
        }
        else{
            reqFieldLbl.textColor = UIColor.black
        }
        titleModelLbl.text = titles[AppDelegate.x]
        changeImgforbullets()

    }
    func changeImgforbullets() {
        //\\print ("value for x is \(AppDelegate.x)")
        for MyImg in  arrayImages {
            MyImg.image = UIImage(named:"blackcircleof.png")
            if AppDelegate.x == 0 {
                arrayImages[AppDelegate.x].image = UIImage(named:"bluecircleon.png")
                png1.setNeedsDisplay()
            } else {
                let isIndexValid = arrayImages.indices.contains(AppDelegate.x)
                if (isIndexValid == true) {
                    arrayImages[AppDelegate.x].image = UIImage(named:"bluecircleon.png")
                } else {
                    //\\print ("index img out of bound")
                }
            }

        }

        self.view.bringSubviewToFront(modelModel)
    }
    func getProviderAllDetails(_ iUserId:Int)
    {
        Global.sharedInstance.FREEDAYSALLWORKERS = []
        Global.sharedInstance.NOWORKINGDAYS = []
        //show a loader
        if let topController = UIApplication.topViewController() {
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            view8 = storyboard1.instantiateViewController(withIdentifier: "loadingBthere") as! loadingBthere
            let screenSize: CGRect = UIScreen.main.bounds
            view8.view.frame = screenSize
            view8.view.tag = 2000

            topController.view.addSubview(view8.view)
            topController.view.bringSubviewToFront(view8.view)
        }
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicUserId["iUserId"] = iUserId as AnyObject



        api.sharedInstance.getProviderAllDetails(dicUserId, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                    {
                        if (self.view8.view.window != nil) {
                            self.view8.view.removeFromSuperview()
                        }
                        self.generic.hideNativeActivityIndicator(self)
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                    {
                        if (self.view8.view.window != nil) {
                            self.view8.view.removeFromSuperview()
                        }
                        UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")
                        self.generic.hideNativeActivityIndicator(self)
                    }

                    else
                    {
                        self.generic.hideNativeActivityIndicator(self)
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                            //\\    print("crash 1 \(String(describing: RESPONSEOBJECT["Result"]))")
                            if (self.view8.view.window != nil) {
                                self.view8.view.removeFromSuperview()
                            }
                            if let _:ProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj((RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!) {

                                Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                //\\print ("exact \( Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.description)")

                                let mydic :Dictionary<String,AnyObject> = (RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!
                                //IMPORTANT THIS FIX PROVIDERID AFTER SETTING ORDER TO ANOTHER ONE.
                                if let onedic:Dictionary<String,AnyObject> = mydic["objProviderProfile"] as? Dictionary<String,AnyObject> {
                                    if let Iprov:Int = onedic["iProviderUserId"] as? Int {
                                        print("dupaget \(Iprov)")
                                        if Iprov != 0 {
                                            Global.sharedInstance.providerID = Iprov
                                        }
                                    }

                                    //BLOCKED DAYS ARE GENERAL FOR PROVIDER AND
                                    // 1. SEPARATE FOR EVERY WORKER IF HE HAS bSameWH = 0
                                    // 2. SAME AS PROVIDER IF WORKER has bSameWH = 1
                                    let anotherarray:NSMutableArray = NSMutableArray()
                                    if let onearray:NSArray = onedic["objWorkingHours"] as? NSArray {

                                        for item in onearray {
                                            if let mydicfast:NSDictionary = item as? NSDictionary {
                                                if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                    if !anotherarray.contains(MYDAYINTS) {
                                                        anotherarray.add(MYDAYINTS)
                                                    }
                                                }
                                            }
                                        }
                                        //       Global.sharedInstance.FREEDAYSSUPPLIER
                                        let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                        for item in FIXEDNUMBERS {
                                            if !anotherarray.contains(item) {
                                                if !Global.sharedInstance.NOWORKINGDAYS.contains(item) {
                                                    Global.sharedInstance.NOWORKINGDAYS.add(item)
                                                }
                                            }
                                        }
                                    }
                                    print("NOWORKINGDAYS \(Global.sharedInstance.NOWORKINGDAYS)")
                                }

                                if let seconddic:Dictionary<String,AnyObject> = mydic["objProviderGeneralDetails"] as? Dictionary<String,AnyObject> {
                                    if let onearray:NSArray = seconddic["objServiceProviders"] as? NSArray
                                    {
                                        for item in onearray {
                                            let freedaysworkersrarray:NSMutableArray = NSMutableArray()
                                            let blockdaysworkersrarray:NSMutableArray = NSMutableArray()
                                            let USERX:NSMutableDictionary = NSMutableDictionary()
                                            if let mydicfast:NSDictionary = item as? NSDictionary {
                                                if let MYDAYINTS:Int = mydicfast["bSameWH"] as? Int {
                                                    var miUSERID:Int = 0
                                                    if let mydicuser:NSDictionary = mydicfast["objUsers"] as? NSDictionary {
                                                        if let _:Int = mydicuser["iUserId"] as? Int {
                                                            miUSERID = mydicuser["iUserId"] as! Int
                                                        }
                                                    }

                                                    if MYDAYINTS == 1 {
                                                        //same hours as provider
                                                        USERX["bSameWH"] = MYDAYINTS
                                                        USERX["WORKERID"] = miUSERID
                                                        USERX["FREEDAYS"] = Global.sharedInstance.NOWORKINGDAYS
                                                        if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                            Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                        }
                                                    } else {
                                                        //custom hours
                                                        if let workerhoursarraay:NSArray = mydicfast["objWorkingHours"] as? NSArray {
                                                            for item in workerhoursarraay {
                                                                if let mydicfast:NSDictionary = item as? NSDictionary {
                                                                    if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                                        if !freedaysworkersrarray.contains(MYDAYINTS) {
                                                                            freedaysworkersrarray.add(MYDAYINTS)
                                                                            print("MYDAYINTS \(MYDAYINTS)")
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            //       Global.sharedInstance.FREEDAYSSUPPLIER
                                                            let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                                            for item in FIXEDNUMBERS {
                                                                if !freedaysworkersrarray.contains(item) {
                                                                    if !blockdaysworkersrarray.contains(item) {
                                                                        blockdaysworkersrarray.add(item)
                                                                    }

                                                                }
                                                            }
                                                        }
                                                        USERX["bSameWH"] = MYDAYINTS
                                                        USERX["WORKERID"] = miUSERID
                                                        USERX["FREEDAYS"] = blockdaysworkersrarray
                                                        if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                            Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                        }
                                                    }
                                                }
                                            }

                                        }
                                    }
                                }


                                print("Global.sharedInstance.FREEDAYSALLWORKERS \(Global.sharedInstance.FREEDAYSALLWORKERS)")
                                Global.sharedInstance.isFIRSTSUPPLIER = true
                                var dicForDefault1:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                dicForDefault1["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                                Global.sharedInstance.defaults.set(dicForDefault1, forKey: "supplierNameRegistered")
                                var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                dicForDefault["supplierRegistered"] = true as AnyObject
                                Global.sharedInstance.defaults.set(dicForDefault, forKey: "isSupplierRegistered")
                                Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
                                //because every new add business make the maker a manager
                                Global.sharedInstance.defaults.set(1, forKey:"ismanager")
                                Global.sharedInstance.isProvider = true
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
                                Global.sharedInstance.defaults.synchronize()
                                let frontviewcontroller = self.storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                                let vc = self.supplierStoryBoard?.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
                                frontviewcontroller?.pushViewController(vc, animated: false)
                                let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                let mainRevealController = SWRevealViewController()
                                mainRevealController.frontViewController = frontviewcontroller
                                mainRevealController.rearViewController = rearViewController
                                let window :UIWindow = UIApplication.shared.keyWindow!
                                window.rootViewController = mainRevealController

                            }
                        }


                    }
                }
                //\\ self.getServicesProviderForSupplierfuncdoi()
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            self.generic.hideNativeActivityIndicator(self)
            if (self.view8.view.window != nil) {
                self.view8.view.removeFromSuperview()
            }
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
        })
    }
    func reloadCateg() {
        print("AppDelegate.arrDomains.count \(AppDelegate.arrDomains.count)")
        //    self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            //   self.generic.hideNativeActivityIndicator(self)
        }
        else
        {
            var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            let USERDEF = UserDefaults.standard
            var defaultForlanguage:Int = 0
            if  USERDEF.object(forKey: "CHOOSEN_LANGUAGE") == nil {
                USERDEF.set(0, forKey: "CHOOSEN_LANGUAGE")
                USERDEF.synchronize()
                defaultForlanguage = 0
            } else {
                defaultForlanguage = USERDEF.integer(forKey: "CHOOSEN_LANGUAGE")
            }

            var finalIntforlang:Int = 2 //default english
            //                        Hebrew - iLanguageId =  1
            //                        English - iLanguageId =  2
            //                        Romanian - iLanguageId =  3
            finalIntforlang = defaultForlanguage  + 1
            dic["iLanguageId"] = finalIntforlang as AnyObject
            AppDelegate.arrDomains = Array<Domain>()
            AppDelegate.arrDomainFilter = Array<Domain>()
            api.sharedInstance.GetFieldsAndCatg(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                //    self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    let domain:Domain = Domain()
                    if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                        AppDelegate.arrDomains = domain.domainToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    }
                    if AppDelegate.arrDomains.count == 0
                    {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))

                    }
                    else
                    {
                        //   var idLast = -1
                        for domain in AppDelegate.arrDomains
                        {
                            AppDelegate.arrDomainFilter.append(domain)
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                //    self.generic.hideNativeActivityIndicator(self)
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
    }
    func cleanPhoneNumber(_ nvPhone:String) -> String {
        var  nvTmpPN2:String = ""
        var modedphone = nvPhone

        if  nvPhone != ""
        {
            //add to check if number has country code
            do {
                let phoneNumber = try phoneNumberKit.parse(nvPhone)
                let phoneNumberCustomDefaultRegion = try phoneNumber.countryCode
                if phoneNumberCustomDefaultRegion != 0 {
                    //  print ("phoneNumberCustomDefaultRegion \(phoneNumberCustomDefaultRegion)")
                    let newString = modedphone.stringByReplacingFirstOccurrenceOfString(target: String(phoneNumberCustomDefaultRegion), withString: "0")
                    modedphone = newString
                    //   print("formated number is \(modedphone)")
                }
            }
            catch {
                //   print("Generic parser error")
            }
            for char in modedphone
            {
                if (char >= "0" && char <= "9") || char == "*"
                {
                    let c:Character = char
                    nvTmpPN2 = nvTmpPN2 + String(c)
                }
            }
        }
        return nvTmpPN2
    }
    func openTrialScreen() {
        Global.sharedInstance.isProvider = false
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let storyboard = UIStoryboard(name: "Testing", bundle: nil)
        let frontViewController = storyboard1.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        let viewCon = storyboard.instantiateViewController(withIdentifier: "TrialScreenViewController") as!  TrialScreenViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom

        frontViewController.pushViewController(viewCon, animated: false)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)


    }

}
