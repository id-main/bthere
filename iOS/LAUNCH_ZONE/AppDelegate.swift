//  AppDelegate.swift
//  bthree-ios
//
//  Created by Lior Ronen on 2/9/16.
//  Copyright © 2016 Webit. All rights reserved.
//
import UIKit
import Foundation
import EventKit
import EventKitUI
import Security
import Fabric
import Crashlytics
import Siren
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import Firebase
import IQKeyboardManagerSwift
import FirebaseAnalytics
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}




@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var view8 : loadingBthere?
    var isDEBUG = 1
    var languageBundle = Bundle()
    var fromBackGround = false
    static var JHASVALIDHOURS:Bool = false
    static var bIslimitseries:Bool = false
    static var showAlertInAppDelegate = false//מציין האם כבר הוצגה הודעה אחת בappDelegate כדי למנוע כפילות הודעות
    var window: UIWindow?
    var screenBounds = UIScreen.main.bounds
    static var y = 0
    static var isOpenHoursWhichCell = false
    static var x = 0
    static var isFirstWorker = true
    static var isBtnCheck = false
    static var isDidReload = false
    static var isOpenHoursForNewService = false
    static var i = 0
    static var isFirst = false
    static var fromChangeLanguage = false
    var locationManager = CLLocationManager()
    var keyserver = ""
    //שומר את כל מה שחוזר מהפונקציה:GetFieldsAndCatg
    static var arrDomains:Array<Domain> = Array<Domain>()
    static var arrDomainFilter:Array<Domain> = Array<Domain>()
    var HELPSCREENKEY = ""
    static var countCellEditOpenService = 0
    //adjust calendar

    static var tagPopUp:Int = -1
    static var shouldDismissVC:Bool = false
    func setHELPSCREENS() {
        //sets of 10 images for iPad /iPhone English / Hebrew = 4 sets * 10 each array index will be in this order
        //0   entranceCustomerViewController
        //1   SearchResultsViewController
        //2   ListServicesViewController
        //3   not used yet - view business profile
        //4   MonthDesignSupplierViewController in bestmode
        //5   not used yet -
        //6   can make business
        //7   Dayview supplier
        //8   Mycostomers - show profile
        //9   Mycustomers - see appointments
        //10. eye on weekview supplier
        let FORIMAGES:NSMutableArray = NSMutableArray()
        var imagesarray:NSArray = NSArray()
        let USERDEF = UserDefaults.standard
        //TO DO TO DO this key keeps default number of weeks for supplier

        if  USERDEF.object(forKey: "WEEKSFORSUPPLIER") == nil {
            USERDEF.set(26, forKey: "WEEKSFORSUPPLIER")
            USERDEF.synchronize()
        } else {
            USERDEF.set(26, forKey: "WEEKSFORSUPPLIER")
            USERDEF.synchronize()
        }
        if  USERDEF.object(forKey: "MAXSERVICEFORCUSTOMER") == nil {
            USERDEF.set(13, forKey: "MAXSERVICEFORCUSTOMER")
            USERDEF.synchronize()
        } else {
            USERDEF.set(13, forKey: "MAXSERVICEFORCUSTOMER")
            USERDEF.synchronize()
        }
        if  USERDEF.object(forKey: "CALENDARWEEKSFORSUPPLIER") == nil {
            USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
            USERDEF.synchronize()
        } else {
            USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
            USERDEF.synchronize()
        }
        if  USERDEF.object(forKey: "CHOOSEN_LANGUAGE") == nil {
            USERDEF.set(0, forKey: "CHOOSEN_LANGUAGE")
            USERDEF.synchronize()
        }
        if  USERDEF.object(forKey: "ONETIMEALRETFORMASSMESSAGE") == nil {
            USERDEF.set(0, forKey: "ONETIMEALRETFORMASSMESSAGE")
            USERDEF.synchronize()
        }
        //        if  USERDEF.objectForKey("HELPSCREENSIPADHEB") != nil {
        //            USERDEF.removeObjectForKey("HELPSCREENSIPADHEB")
        //        }
        //        if  USERDEF.objectForKey("HELPSCREENSIPADEN") != nil {
        //             USERDEF.removeObjectForKey("HELPSCREENSIPADEN")
        //        }
        //        if  USERDEF.objectForKey("HELPSCREENSIPHONEHEB") != nil {
        //             USERDEF.removeObjectForKey("HELPSCREENSIPHONEHEB")
        //        }
        //        if  USERDEF.objectForKey("HELPSCREENSIPHONEEN") != nil {
        //             USERDEF.removeObjectForKey("HELPSCREENSIPHONEEN")
        //        }
        USERDEF.synchronize()
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 { //hebrew set
                imagesarray = [
                    "ipad1-heb.png",
                    "ipad2-heb.png",
                    "ipad3-heb.png",
                    "ipad4-heb.png",
                    "ipad5-heb.png",
                    "ipad6-heb.png",
                    "ipad7-heb.png",
                    "ipad8-heb.png",
                    "ipad9-heb.png",
                    "ipad10-heb.png",
                    "ipad11-heb.png"
                ]
                if  USERDEF.object(forKey: "HELPSCREENSIPADHEB") == nil {
                    for i in 0..<imagesarray.count {
                        print("imagesarray \(imagesarray[i])")
                        let imgdictionary:NSMutableDictionary = NSMutableDictionary()
                        imgdictionary["seen"] = 1
                        imgdictionary["needimage"] = imagesarray[i]
                        FORIMAGES.add(imgdictionary)
                    }
                    USERDEF.set(FORIMAGES, forKey: "HELPSCREENSIPADHEB")
                    USERDEF.synchronize()
                }

            }
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 1 { //english set
                imagesarray = [
                    "ipad1-en.png",
                    "ipad2-en.png",
                    "ipad3-en.png",
                    "ipad4-en.png",
                    "ipad5-en.png",
                    "ipad6-en.png",
                    "ipad7-en.png",
                    "ipad8-en.png",
                    "ipad9-en.png",
                    "ipad10-en.png",
                    "ipad11-en.png"
                ]
                if  USERDEF.object(forKey: "HELPSCREENSIPADEN") == nil {
                    for i in 0..<imagesarray.count {
                        print("imagesarray \(imagesarray[i])")
                        let imgdictionary:NSMutableDictionary = NSMutableDictionary()
                        imgdictionary["seen"] = 1
                        imgdictionary["needimage"] = imagesarray[i]
                        FORIMAGES.add(imgdictionary)
                    }
                    USERDEF.set(FORIMAGES, forKey: "HELPSCREENSIPADEN")
                    USERDEF.synchronize()
                }
            }
        } else { //IPHONE
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 { //hebrew set
                imagesarray = [
                    "ip1-heb.png",
                    "ip2-heb.png",
                    "ip3-heb.png",
                    "ip4-heb.png",
                    "ip5-heb.png",
                    "ip6-heb.png",
                    "ip7-heb.png",
                    "ip8-heb.png",
                    "ip9-heb.png",
                    "ip10-heb.png",
                    "ip11-heb.png"
                ]
                if  USERDEF.object(forKey: "HELPSCREENSIPHONEHEB") == nil {
                    for i in 0..<imagesarray.count {
                        print("imagesarray \(imagesarray[i])")
                        let imgdictionary:NSMutableDictionary = NSMutableDictionary()
                        imgdictionary["seen"] = 1
                        imgdictionary["needimage"] = imagesarray[i]
                        FORIMAGES.add(imgdictionary)
                    }
                    USERDEF.set(FORIMAGES, forKey: "HELPSCREENSIPHONEHEB")
                    USERDEF.synchronize()
                }

            }
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 1 { //english set
                imagesarray = [
                    "ip1-en.png",
                    "ip2-en.png",
                    "ip3-en.png",
                    "ip4-en.png",
                    "ip5-en.png",
                    "ip6-en.png",
                    "ip7-en.png",
                    "ip8-en.png",
                    "ip9-en.png",
                    "ip10-en.png",
                    "ip11-en.png"
                ]
                if  USERDEF.object(forKey: "HELPSCREENSIPHONEEN") == nil {
                    for i in 0..<imagesarray.count {
                        print("imagesarray \(imagesarray[i])")
                        let imgdictionary:NSMutableDictionary = NSMutableDictionary()
                        imgdictionary["seen"] = 1
                        imgdictionary["needimage"] = imagesarray[i]
                        FORIMAGES.add(imgdictionary)
                    }
                    USERDEF.set(FORIMAGES, forKey: "HELPSCREENSIPHONEEN")
                    USERDEF.synchronize()
                }
            }
        }


    }
    func UpdateiOSVersionByUserId(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var myversion:String = ""
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            myversion = version
        }
        if myversion.count > 0 {
            var y:Int = 0
            let USERDEF = UserDefaults.standard
            if let _:NSDictionary =  (USERDEF.object(forKey: "currentUserId") as? NSDictionary) {
                let a:NSDictionary = USERDEF.object(forKey: "currentUserId") as! NSDictionary
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
            }
            print("crentiduser \(y)")
            dic["iUserId"] = y as AnyObject
            dic["nviOSVersion"] = myversion as AnyObject
            print(dic.description)
            if Reachability.isConnectedToNetwork() == false
            {
                //      Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else
            {
                api.sharedInstance.UpdateiOSVersionByUserId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        print("UpdateiOSVersionByUserId \(RESPONSEOBJECT)")
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    print("error \(Error)")
                })
            }
        } else {
            print("error .. cannot read short budle version")
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // For remote Notification

        let USERDEF = UserDefaults.standard
        USERDEF.set(1, forKey: "UPDATEVERSIONFORUSER")
        if USERDEF.integer(forKey: "UPDATEVERSIONFORUSER") == 1 {
            UpdateiOSVersionByUserId()
            USERDEF.set(0, forKey: "UPDATEVERSIONFORUSER")
        }
        USERDEF.setValue(0, forKey: "wasseenTextTOShow")
        USERDEF.setValue(0, forKey:"FORCEDAYOPEN")
        USERDEF.setValue(0, forKey:"DAYTOOPEN")
        USERDEF.setValue(0, forKey:"HOURTOOPEN")
        USERDEF.set(1, forKey: "SHOWEYEINCALENDARSUPPLIER") //by default all events are show in calendars
        USERDEF.set(0, forKey:"firstpopup_welcomeBusinessalreadyseen")
        if USERDEF.value(forKey: "firstpopup_addEmployeesalreadyseen") == nil {
        USERDEF.set(0, forKey:"firstpopup_addEmployeesalreadyseen")
        }
        USERDEF.synchronize()

        if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as! [NSObject : AnyObject]? {
            print("remoteNotification \(remoteNotification)")
            let USERDEF = Global.sharedInstance.defaults
            let TextTOShow:String = self.extractMessage(fromPushNotificationUserInfo: remoteNotification)!
            USERDEF.set(TextTOShow, forKey: "TextTOShow")
            USERDEF.synchronize()
        }


        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
        }
        //DEV MODE J ONLY
        //IOAN ID
        if api.sharedInstance.WITCHDOMAIN == 0 || api.sharedInstance.WITCHDOMAIN == 1  {
            gai.tracker(withTrackingId: "UA-127211712-11")
          //  gai.logger.logLevel = .verbose;
        }
        //B.There ID
        if api.sharedInstance.WITCHDOMAIN == 2 {
            gai.tracker(withTrackingId: "UA-127574616-1")
        }
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true

        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        //


        if USERDEF.value(forKey: "TextTOShow") != nil {
            print("TextTOShow \(USERDEF.value(forKey: "TextTOShow"))")
        }

        // Global.sharedInstance.getnews()
        //        self.keyserver = "access-token"
        //        api.sharedInstance.keyserver = self.keyserver
        self.s45FB185D380DEA55FA5BFA335B4B6821ADD7A0794851F185()


        determineMyCurrentLocation()

        if  USERDEF.object(forKey: "wasshownwelcometoBthere") == nil {
            USERDEF.set(0, forKey: "wasshownwelcometoBthere")
        }
        USERDEF.set(0, forKey: "listservicesindexRow")
        USERDEF.set(0,forKey: "backFromMyListServices")
        USERDEF.set(1, forKey: "UPDATELOCATIONFORUSER")
        USERDEF.set(0, forKey: "isfromSPECIALSUPPLIER")
        USERDEF.set(0, forKey: "ISFROMSETTINGS")
        USERDEF.set(0, forKey: "RELOADAFTERSERVICEADD")
        USERDEF.set(0, forKey: "PRESENTEDSYNCONTACTSPOPUPEXPLAIN")
        USERDEF.set(0, forKey: "PRESENTED2ODAYSPASSED") //there were 20 days since busines has joined and this is a prompt once per session
        USERDEF.set(0,  forKey: "isenteringregister")
        USERDEF.set(0, forKey: "hasrecomendedbusiness")
        USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId") //because default meeting are done by current logged user
        if  USERDEF.object(forKey: "WEEKSFORSUPPLIER") == nil {
            USERDEF.set(26, forKey: "WEEKSFORSUPPLIER")
        } else {
            USERDEF.set(26, forKey: "WEEKSFORSUPPLIER")
        }
        if  USERDEF.object(forKey: "MAXSERVICEFORCUSTOMER") == nil {
            USERDEF.set(13, forKey: "MAXSERVICEFORCUSTOMER")
        } else {
            USERDEF.set(13, forKey: "MAXSERVICEFORCUSTOMER")
        }
        if  USERDEF.object(forKey: "CALENDARWEEKSFORSUPPLIER") == nil {
            USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
        } else {
            USERDEF.set(52, forKey: "CALENDARWEEKSFORSUPPLIER")
        }
        if  USERDEF.object(forKey: "ONETIMEALRETFORMASSMESSAGE") == nil {
            USERDEF.set(0, forKey: "ONETIMEALRETFORMASSMESSAGE")
        }

        if USERDEF.object(forKey: "hassowntutorial") == nil {
            USERDEF.set(0, forKey: "hassowntutorial")
        }
        if USERDEF.object(forKey: "iSupplierStatus") == nil {
            USERDEF.set(0,  forKey: "iSupplierStatus")
        }
        if USERDEF.object(forKey: "iSyncedStatus") == nil {
            USERDEF.set(0,  forKey: "iSyncedStatus")
        }
        if  USERDEF.object(forKey: "CHOOSEN_LANGUAGE") == nil {
            USERDEF.set(0, forKey: "CHOOSEN_LANGUAGE")

        }
        if  USERDEF.object(forKey: "CHOOSEN_LANGUAGE") == nil {
            USERDEF.set(0, forKey: "CHOOSEN_LANGUAGE")
            USERDEF.synchronize()
        }
        var langCode = "he"
        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 1 {
            langCode = "en"
            USERDEF.set([langCode/*, "he", "ro"*/], forKey: "AppleLanguages")


        } else  if USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            langCode = "he"
            USERDEF.set([langCode/*, "en","ro"*/], forKey: "AppleLanguages")

        } else if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 2 {
            langCode = "ro"
            USERDEF.set([langCode/*, "en", "he"*/], forKey: "AppleLanguages")

        }
        USERDEF.synchronize()

        //   setHELPSCREENS()
        LanguageMain.sharedInstance.setLanguage()
        print(Locale.current)

        application.isStatusBarHidden = false
        application.statusBarStyle = .lightContent


        UIApplication.shared.applicationIconBadgeNumber = 0
        let screenSize: CGRect = UIScreen.main.bounds

        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        print("now is screenWidth\(screenWidth) screenHeight \(screenHeight)  ")
        Global.sharedInstance.isFIRSTREGISTER = false
        //
        //        if AppDelegate.isDeviceLanguageRTL()
        //        {
        //            Global.sharedInstance.rtl = true
        //        }
        //        else
        //        {
        //            Global.sharedInstance.rtl = false
        //        }
        //        //show a loader
        //        if let topController = UIApplication.topViewController() {
        //            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        //            view8 = storyboard1.instantiateViewController(withIdentifier: "loadingBthere") as? loadingBthere
        //            let screenSize: CGRect = UIScreen.main.bounds
        //            view8?.view.frame = screenSize
        //            view8?.view.tag = 2000
        //            view8?.view.frame.origin.x = 0
        //            view8?.view.frame.origin.y = 0
        //            topController.view.addSubview((view8?.view)!)
        //            topController.view.bringSubview(toFront: (view8?.view)!)
        //        }
        //        //end show

        Global.sharedInstance.setContacts()
        //        if (self.view8?.view.window != nil) {
        //            self.view8?.view.removeFromSuperview()
        //        }   //end hide
        //

        //        if isDEBUG == 1
        //        {
        //            /* Device is iPad and in pilot will force to  750 x 1334
        //             */
        //           self.window?.frame =  CGRectMake(0,0, 750, 1334)
        //           // self.window?.frame =  CGRectMake(0,0, 187, 333)
        //              print("self.window.frame.size \(self.window?.frame.size.width) \(self.window?.frame.size.height)")
        //        }
        let ABTESTINGX = CheamaIOSObject()
        Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker") //every time on start selected supplier worker will be reinit to -1
        var ABTESTING :String  = ""
        ABTESTING +=   ABTESTINGX.cheamaIOS();
        print("myabtesting " + ABTESTING)

        fromBackGround = false


        UserDefaults.standard.synchronize()


        //get the events from my calender
        Global.sharedInstance.getEventsFromMyCalendar()

        //מחיקה מהמכשיר

        //        NSUserDefaults.standardUserDefaults().removeObjectForKey("verificationPhone")
        //        NSUserDefaults.standardUserDefaults().removeObjectForKey("currentClintName")
        //        NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUserId")
        //        NSUserDefaults.standardUserDefaults().removeObjectForKey("providerDic")
        //        NSUserDefaults.standardUserDefaults().removeObjectForKey("isSupplierRegistered")
        //        NSUserDefaults.standardUserDefaults().removeObjectForKey("supplierNameRegistered")
        //
        //        NSUserDefaults.standardUserDefaults().synchronize()
        //

        // application.registerForRemoteNotifications()
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications() //important one
        //note: the project is registered from eztaxi10 mail and the name of the project in apis console is:bthere-31-10-16
        //   GMSServices.provideAPIKey("AIzaSyCZFlWab7bPnumji9Ia47JSl3hrbWsZxRY")
        //   GMSServices.provideAPIKey("AIzaSyBbaJZXmIyCsMeNRTpVu3V5lhDCPo3Vv4E")
        //before the new key in 31-10-16
        //GMSServices.provideAPIKey("AIzaSyAMB_zlzBk2-_URbKg8wqvgrvkLN0Y5Kog")
        print( USERDEF.value(forKey:"AppleLanguages"))

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
          IQKeyboardManager.shared.enable = true
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

    }

    func afterkeya() {
        //delete it
        //        //show a loader
        //        if let topController = UIApplication.topViewController() {
        //            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        //            view8 = storyboard1.instantiateViewController(withIdentifier: "loadingBthere") as? loadingBthere
        //            let screenSize: CGRect = UIScreen.main.bounds
        //            view8?.view.frame = screenSize
        //            view8?.view.tag = 2000
        //            view8?.view.frame.origin.x = 0
        //            view8?.view.frame.origin.y = 0
        //            topController.view.addSubview((view8?.view)!)
        //            topController.view.bringSubview(toFront: (view8?.view)!)
        //        }
        //        //end show
        //        Global.sharedInstance.setContacts()
        //        if (self.view8?.view.window != nil) {
        //            self.view8?.view.removeFromSuperview()
        //        }   //end hide
        //

        let USERDEF = UserDefaults.standard
        print("AppDelegate.arrDomains.count \(AppDelegate.arrDomains.count)")
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

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
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetFieldsAndCatg(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("alte alea \(RESPONSEOBJECT)")
                    let domain:Domain = Domain()
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        AppDelegate.arrDomains = domain.domainToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)

                        if AppDelegate.arrDomains.count == 0
                        {
                            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        //    var idLast = -1
                        for domain in AppDelegate.arrDomains
                        {
                            //                    let domain:Domain = domain
                            //                      //\\print( "iCategoryRowId \(  domain.iCategoryRowId)")
                            //                      //\\print( "nvCategoryName name  \(  domain.nvCategoryName)")
                            //                      //\\print( "nvFieldName   \(  domain.nvFieldName)")
                            //                      //\\print( "iFieldRowId   \(  domain.iFieldRowId)")
                            //הבדיקה היא כדי שלא יהיו כפולים כאשר נגשנו לשדה nvFieldName
                            //                if domain.iFieldRowId != idLast || idLast == -1
                            //                {
                            AppDelegate.arrDomainFilter.append(domain)
                            // }
                            //idLast = domain.iFieldRowId
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                //    if AppDelegate.showAlertInAppDelegate == false
                //    {
                //    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                //    AppDelegate.showAlertInAppDelegate = true
                //    }
                print("Eroare \(Error!.localizedDescription)")
            })

            var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            let USERDEF = UserDefaults.standard
            var defaultForlanguage:Int = 0
            var finalIntforlang:Int = 2 //default english
            if  USERDEF.object(forKey: "CHOOSEN_LANGUAGE") == nil {
                USERDEF.set(0, forKey: "CHOOSEN_LANGUAGE")
                USERDEF.synchronize()
                defaultForlanguage = 0
            } else {
                defaultForlanguage = USERDEF.integer(forKey: "CHOOSEN_LANGUAGE")
            }
            //we have 1 as hebrew in db but 0 in app so add 1, en = 2, ro = 3
            finalIntforlang = defaultForlanguage + 1
            //TO DO   dic["iLanguageId"] = finalIntforlang
            dic["iLanguageId"] = finalIntforlang as AnyObject
            //                        Hebrew - iLanguageId =  1
            //                        English - iLanguageId =  2
            //                        Romanian - iLanguageId =  3

            api.sharedInstance.GetSysAlertsList(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3


                    let sysAlert:SysAlerts = SysAlerts()
                    if let _:Array<SysAlerts> = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>) {
                        print("sysalerts \(String(describing: RESPONSEOBJECT["Result"]))")
                        Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                        print("sysalll \(Global.sharedInstance.arrSysAlerts.count)")
                        if Global.sharedInstance.arrSysAlerts.count != 0
                        {
                            Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
                            Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
                            Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
                            Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
                            Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
                            Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
                            //2do
                            //במקום זה צריך להיות textField
                            //            Global.sharedInstance.arrayDicForTableViewInCell[4]![1] = sysAlert.SysnvAletName(12)
                        }
                    }
                }

                //}
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                let statuscode = AFHTTPRequestOperation?.response?.statusCode
                if statuscode == 400 {
                    api.sharedInstance.s45FB185D380DEA55FA5BFA335B4B6821ADD7A0794851F185()
                }
                //    if AppDelegate.showAlertInAppDelegate == false
                //    {
                //    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                //    AppDelegate.showAlertInAppDelegate = true
                //    }
            })

            //27.08.2018 verify logged in user
            if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
            {
                var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>

                if dicUserId["currentUserId"] as! Int != 0
                {
                    //קבלת פרטי הלקוח
                    var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                    dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                    /*
                     Global.sharedInstance.defaults.set(APPDELnvVerCode,forKey: "APPDELnvVerCode")
                     Global.sharedInstance.defaults.set(APPDELnvPhone,forKey: "APPDELnvPhone")
                     */
                    api.sharedInstance.GetCustomerDetails(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                var nvPhone = ""
                                var nvStoredPhone = "0000000000"
                                var nvStoredVerificationCode = "0000"
                                let MYDICTIONARY:Dictionary<String,AnyObject> = (RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!
                                if let _ = MYDICTIONARY["nvPhone"] as? String {
                                    nvPhone = MYDICTIONARY["nvPhone"] as! String
                                }
                                var nvVerification = ""
                                if let _ = MYDICTIONARY["nvVerification"] as? String {
                                    nvVerification = MYDICTIONARY["nvVerification"] as! String
                                }
                                if Global.sharedInstance.defaults.value(forKey: "APPDELnvPhone") != nil {
                                    nvStoredPhone = Global.sharedInstance.defaults.value(forKey: "APPDELnvPhone") as! String
                                }
                                if Global.sharedInstance.defaults.value(forKey: "APPDELnvVerCode") != nil {
                                    nvStoredVerificationCode = Global.sharedInstance.defaults.value(forKey: "APPDELnvVerCode") as! String
                                }
                                if nvPhone != nvStoredPhone || nvVerification !=  nvStoredVerificationCode {
                                    Global.sharedInstance.defaults.removeObject(forKey: "currentUserId")
                                    Global.sharedInstance.defaults.removeObject(forKey: "currentClintName")
                                    Global.sharedInstance.defaults.synchronize()
                                    //go to entrance
                                    Global.sharedInstance.logoutUSER()
                                    let siren = Siren.shared
                                    siren.debugEnabled = true
                                    siren.alertType = .option
                                    siren.majorUpdateAlertType = .option
                                    siren.minorUpdateAlertType = .option
                                    siren.patchUpdateAlertType = .option
                                    siren.revisionUpdateAlertType = .option
                                    siren.countryCode = "IL"
                                    siren.checkVersion(checkType: .immediately)

                                    return
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        //                    if AppDelegate.showAlertInAppDelegate == false
                        //                    {
                        //                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        //                        AppDelegate.showAlertInAppDelegate = true
                        //                    }
                    })
                }
            }
            //21.03.2017GetSupplierIdByEmployeeId
            if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
            {
                var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                if dicUserId["currentUserId"] as! Int != 0
                {
                    //קבלת פרטי הלקוח
                    var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                    dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                    api.sharedInstance.GetSupplierIdByEmployeeId(dicForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                            print("here again \(RESPONSEOBJECT)")
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                print("sup id e ok ? " + myInt.description)
                                if Global.sharedInstance.providerID == 0 {
                                    api.sharedInstance.trytogetProviderdata()
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        //    if AppDelegate.showAlertInAppDelegate == false
                        //    {
                        //    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        //    AppDelegate.showAlertInAppDelegate = true
                        //    }
                    })
                }
            }

            if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
            {
                var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>

                if dicUserId["currentUserId"] as! Int != 0
                {
                    //קבלת פרטי הלקוח
                    var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                    dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                    /*
                     Global.sharedInstance.defaults.set(APPDELnvVerCode,forKey: "APPDELnvVerCode")
                     Global.sharedInstance.defaults.set(APPDELnvPhone,forKey: "APPDELnvPhone")
                     */
                    api.sharedInstance.GetCustomerDetails(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {

                                    let MYDICTIONARY:Dictionary<String,AnyObject> = (RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!
                                //\\  print("GetCustomerDetails \(String(describing: RESPONSEOBJECT["Result"]))")
                                var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                var nvFirstName = ""

                                if let _ = MYDICTIONARY["nvFirstName"] as? String {
                                    nvFirstName = MYDICTIONARY["nvFirstName"] as! String
                                    dicForDefault["nvClientName"] = nvFirstName as AnyObject
                                    Global.sharedInstance.defaults.set(dicForDefault, forKey: "currentClintName")
                                }
                                var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                var neediUserId = 0
                                if let _ = MYDICTIONARY["iUserId"] as? Int {
                                    neediUserId = MYDICTIONARY["iUserId"] as! Int
                                    dicUserId["currentUserId"] = neediUserId as AnyObject
                                    //save the userId on device
                                    Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                                    //\\  print("user desc \(dicUserId.description)")
                                }
                                if let _:User = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>) {
                                    Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                    if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil {
                                        //       print("aici \(Global.sharedInstance.currentUser.getDic())")
                                    }
                                    //בגלל שנשמר יום אחד קודם צריך להוסיף 3 שעות(זה לא עזר להוסיף timeZone)
                                    Global.sharedInstance.currentUser.dBirthdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dBirthdate
                                        , options: [])!
                                    Global.sharedInstance.currentUser.dMarriageDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dMarriageDate
                                        , options: [])!
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        //    if AppDelegate.showAlertInAppDelegate == false
                        //    {
                        //    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        //    AppDelegate.showAlertInAppDelegate = true
                        //    }
                    })
                }
                //GetTrialDataByUserId

                //        reponseGetTrialDataByUserId ["Result": {
                //            dtCreateDate = "/Date(1535109962880+0300)/";
                //            iTrialDays = 25;
                //            }, "Error": {
                //            ErrorCode = 1;
                //            ErrorMessage = Success;
                //            }]
                //-- si cand da eroare "Error" -1
                if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
                {
                    var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                    if dicUserId["currentUserId"] as! Int != 0  {
                        var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject


                        api.sharedInstance.GetTrialDataByUserId(dicForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                print("reponseGetTrialDataByUserId \(RESPONSEOBJECT)")
                                let MYDICTIONARY:Dictionary<String,AnyObject> = (RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject>)!
                                if let _ = MYDICTIONARY["ErrorCode"] as? Int {
                                    if MYDICTIONARY["ErrorCode"] as! Int == 0 {
                                        //no record found
                                        Global.sharedInstance.defaults.removeObject(forKey: "APPDELiTrialDays")
                                        Global.sharedInstance.defaults.removeObject(forKey: "APPDELdtCreateDate")
                                        Global.sharedInstance.defaults.synchronize()
                                    }
                                    if MYDICTIONARY["ErrorCode"] as! Int == 1
                                    {
                                        //2 keys
                                        var APPDELiTrialDays = 0
                                        var APPDELdtCreateDate = Date()
                                        let  reponseGetTrialDataByUserId = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                        if let _:String =  reponseGetTrialDataByUserId["dtCreateDate"] as? String {
                                            let APPLDELdtCreateDateserver = reponseGetTrialDataByUserId["dtCreateDate"] as! String
                                            if let _:Date =  Global.sharedInstance.getStringFromDateString(APPLDELdtCreateDateserver) {
                                                APPDELdtCreateDate = Global.sharedInstance.getStringFromDateString(APPLDELdtCreateDateserver)
                                            }
                                        }
                                        if let _:Int =  reponseGetTrialDataByUserId["iTrialDays"] as? Int {
                                            APPDELiTrialDays = reponseGetTrialDataByUserId["iTrialDays"] as! Int
                                        }
                                        Global.sharedInstance.defaults.set(APPDELiTrialDays,forKey: "APPDELiTrialDays")
                                        Global.sharedInstance.defaults.set(APPDELdtCreateDate,forKey: "APPDELdtCreateDate")
                                        Global.sharedInstance.defaults.synchronize()
                                    }
                                    if MYDICTIONARY["ErrorCode"] as! Int == -1 {
                                        //error from server
                                        Global.sharedInstance.defaults.removeObject(forKey: "APPDELiTrialDays")
                                        Global.sharedInstance.defaults.removeObject(forKey: "APPDELdtCreateDate")
                                        Global.sharedInstance.defaults.synchronize()
                                    }
                                }
                            }
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        })
                    }
                }
                //End GetTrialDataByUserId
                //קבלת פרטי הספק
//                if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
//
//                    api.sharedInstance.getProviderAllDetails(dicUserId["currentUserId"] as! Int)
//                } else {
//                    api.sharedInstance.getProviderAllDetailsbyEmployeID(dicUserId["currentUserId"] as! Int)
//                }
                
                if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
                {
                    api.sharedInstance.getProviderAllDetailsbySimpleUserID(dicUserId["currentUserId"] as! Int)
                }
                else
                {
                   api.sharedInstance.getProviderAllDetails(dicUserId["currentUserId"] as! Int)
                }

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                Global.sharedInstance.whichReveal = false
                let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
                frontviewcontroller?.pushViewController(vc, animated: false)

                //initialize REAR View Controller- it is the LEFT hand menu.

                let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                let mainRevealController = SWRevealViewController()

                mainRevealController.frontViewController = frontviewcontroller
                mainRevealController.rearViewController = rearViewController

                self.window!.rootViewController = mainRevealController
                self.window?.makeKeyAndVisible()
                let siren = Siren.shared
                siren.debugEnabled = true
                siren.alertType = .option
                siren.majorUpdateAlertType = .option
                siren.minorUpdateAlertType = .option
                siren.patchUpdateAlertType = .option
                siren.revisionUpdateAlertType = .option
                siren.countryCode = "IL"
                siren.checkVersion(checkType: .immediately)
            }
            else
            {
                let USERDEF = UserDefaults.standard
                if USERDEF.integer(forKey: "hassowntutorial") == 0 {
                    let mainstoryb = UIStoryboard(name: "CustomersRecommendations", bundle: nil)
                    let vc: TutorialScreenSlider = mainstoryb.instantiateViewController(withIdentifier: "TutorialScreenSlider")as! TutorialScreenSlider

                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window!.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                    let siren = Siren.shared
                    siren.debugEnabled = true
                    siren.alertType = .option
                    siren.majorUpdateAlertType = .option
                    siren.minorUpdateAlertType = .option
                    siren.patchUpdateAlertType = .option
                    siren.revisionUpdateAlertType = .option
                    siren.countryCode = "IL"
                    siren.checkVersion(checkType: .immediately)
                } else {


                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                    let vc = storyboard.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
                    if self.iOS8 {
                        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    } else {
                        vc.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    }
                    frontviewcontroller?.pushViewController(vc, animated: false)

                    //initialize REAR View Controller- it is the LEFT hand menu.

                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    let mainRevealController = SWRevealViewController()

                    mainRevealController.frontViewController = frontviewcontroller
                    mainRevealController.rearViewController = rearViewController

                    self.window!.rootViewController = mainRevealController



                    let siren = Siren.shared
                    siren.debugEnabled = true
                    siren.alertType = .option
                    siren.majorUpdateAlertType = .option
                    siren.minorUpdateAlertType = .option
                    siren.patchUpdateAlertType = .option
                    siren.revisionUpdateAlertType = .option
                    siren.countryCode = "IL"
                    siren.checkVersion(checkType: .immediately)
                }
            }
        }
        //JMODE PLUS

      

        print("Global.sharedInstance.defaults.objectForKey: currentUserId \(String(describing: Global.sharedInstance.defaults.object(forKey: "currentUserId")))")


    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        if Global.sharedInstance.isGooglePlusChecked == true
        {
            Global.sharedInstance.isGooglePlusChecked = false
        //    return GPPURLHandler.handle(url, sourceApplication:sourceApplication, annotation: annotation)
        }

        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //  self.locationManager.startMonitoringSignificantLocationChanges()
        print("entered background Mode")
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        Siren.shared.checkVersion(checkType: .immediately)
        // send user to whatever screen
        //        let storyBoard1 =  UIStoryboard(name: "Main", bundle: nil)
        //        let frontviewcontroller = storyBoard1.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        //        let vc = storyBoard1.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        //        frontviewcontroller?.pushViewController(vc, animated: false)
        //        Global.sharedInstance.whichReveal = false
        //        let rearViewController = storyBoard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        //        let mainRevealController = SWRevealViewController()
        //        mainRevealController.frontViewController = frontviewcontroller
        //        mainRevealController.rearViewController = rearViewController
        //        let window:UIWindow = UIApplication.shared.keyWindow!
        //        window.rootViewController = mainRevealController

    }

    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()

        } else {

        }
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        FBSDKAppEvents.activateApp()
        //JMODE addfix
        //ask for camera


        if Global.sharedInstance.isSettingsOpen == true
        {
            fromBackGround = true
        }
    }
    func askforcamerapermissionsIOS9() {

    }
    func rtlRELOAD() {
        let USERDEF = UserDefaults.standard
        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let _:CLLocationCoordinate2D = manager.location?.coordinate {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            if let _:Double = locValue.latitude {
                Global.sharedInstance.currentLat = locValue.latitude
            }
            if let _:Double = locValue.longitude {
                Global.sharedInstance.currentLong = locValue.longitude
            }
        }
        print("ccccc\( Global.sharedInstance.currentLat) \(Global.sharedInstance.currentLong)")
        locationManager.stopUpdatingLocation() //in order to not drain battery
        if fromBackGround == true
        {
            fromBackGround = false
            if Global.sharedInstance.searchResult != nil
            {
                if Global.sharedInstance.currentLat != nil
                {
                    Global.sharedInstance.searchResult?.btnByDistance.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 20)
                    Global.sharedInstance.searchResult?.imgCircleDistance.isHidden = false
                    Global.sharedInstance.searchResult?.imgCircle.isHidden = true
                    Global.sharedInstance.searchResult?.btnByRating.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 20)

                    Global.sharedInstance.dicSearch["nvlong"] = Global.sharedInstance.currentLong as AnyObject
                    Global.sharedInstance.dicSearch["nvlat"] = Global.sharedInstance.currentLat as AnyObject

                    api.sharedInstance.SearchByKeyWord(Global.sharedInstance.dicSearch,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                             let MYDICTIONARY:Dictionary<String,AnyObject> = (RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject>)!
                            if let _ = MYDICTIONARY["ErrorCode"] as? Int {

                                if MYDICTIONARY["ErrorCode"] as! Int == 1
                                {
                                    Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                    Global.sharedInstance.dicSearchProviders = Global.sharedInstance.dicSearch
                                    var dicPositiveDistance:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
                                    var dicNegativeDistance:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()

                                    for result in Global.sharedInstance.dicResults {
                                        if (result["iDistance"] as! Int) == -1
                                        {
                                            dicNegativeDistance.append(result)
                                        }
                                        else
                                        {
                                            dicPositiveDistance.append(result)
                                        }
                                    }
                                    dicPositiveDistance.sort{
                                        (($0 )["iDistance"] as? Float) < (($1 )["iDistance"] as? Float)
                                    }
                                    Global.sharedInstance.dicResults = dicPositiveDistance

                                    for item in dicNegativeDistance
                                    {
                                        Global.sharedInstance.dicResults.append(item)
                                    }
                                    /////

                                    Global.sharedInstance.searchResult?.btnByDistance.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 20)
                                    Global.sharedInstance.searchResult?.imgCircleDistance.isHidden = false
                                    Global.sharedInstance.searchResult?.imgCircle.isHidden = true
                                    Global.sharedInstance.searchResult?.btnByRating.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 20)

                                    Global.sharedInstance.searchResult?.lblResultCount.text = "\(Global.sharedInstance.dicResults.count) תוצאות חיפוש"
                                    Global.sharedInstance.searchResult?.tblResults.reloadData()
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        //                            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    })
                }
                else
                {
                    //פתיחת דף שנה מיקום
                    let viewCon:ChangeCityViewController = Global.sharedInstance.searchResult!.storyboard!.instantiateViewController(withIdentifier: "ChangeCityViewController") as! ChangeCityViewController
                    viewCon.delegate = Global.sharedInstance.searchResult
                    viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                    Global.sharedInstance.searchResult!.present(viewCon, animated: true, completion: nil)
                }
            }
        }
    }

    func changeLanguage(_ lang:String)
    {
        //        NSUserDefaults.standardUserDefaults().synchronize()
        //        NSUserDefaults.standardUserDefaults().setObject([lang], forKey: "AppleLanguages")
        //        NSUserDefaults.standardUserDefaults().synchronize()
        //
        //        NSUserDefaults.standardUserDefaults().synchronize()
        //        NSUserDefaults.standardUserDefaults().setObject([lang], forKey: "AppleLanguages")
        //
        //        NSUserDefaults.standardUserDefaults().synchronize()
        //        let language: String = NSLocale.preferredLanguages()[0]
        //          //\\print(language)
        //
        //        let path = NSBundle.mainBundle().pathForResource(lang, ofType: "lproj")
        //        let bundle = NSBundle(path: path!)
        //
        //        languageBundle = NSBundle(path: NSBundle.mainBundle().pathForResource(NSLocale.preferredLanguages()[0], ofType: "lproj")!)!
    }
    //JMODE IMPLEMENT OF PUSH NOTIFICATIONS APNS
    //1. did register
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE TOKEN = \(deviceToken)")
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""

        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }

        print("tokenString: \(tokenString)")
        if tokenString.count == 64 {
            //here is a inversed md5 string just for safe :)
            Global.sharedInstance.defaults.set(tokenString, forKey:  "62d4b8780f6d4e4e39b73c7454597191")
            Global.sharedInstance.defaults.synchronize()
            UpdateToken()
        }
    }
    //2. did receive
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        print("notification with message: \(userInfo)")
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            // background
            let increment:Int =    UIApplication.shared.applicationIconBadgeNumber + 1
            UIApplication.shared.applicationIconBadgeNumber = increment
        } else if state == .active {
            // foreground
        }
        let TextTOShow:String = self.extractMessage(fromPushNotificationUserInfo: userInfo)!

        print("TextTOShow \(TextTOShow)")
        let USERDEF =  UserDefaults.standard
        USERDEF.set(TextTOShow, forKey: "TextTOShow")
        USERDEF.synchronize()
//        Global.sharedInstance.numberOfNotifications += 1
//        Alert.sharedInstance.showAlertDelegate("number of received push notifications: \(Global.sharedInstance.numberOfNotifications)")
//        Alert.sharedInstance.showAlertDelegate("userInfo of notifications: \(userInfo)")
        DispatchQueue.main.async(execute: { () -> Void in
         Alert.sharedInstance.showAlertDelegate(TextTOShow)
         //    Alert.sharedInstance.showAlertAppDelegate(TextTOShow)
        })
       AppDelegate.showAlertInAppDelegate = true
    }
    //3. get push notification body
    fileprivate func extractMessage(fromPushNotificationUserInfo userInfo:[AnyHashable: Any]) -> String? {
        var message: String?
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? String {
                message = alert
            }
        }
        return message
    }
    //4. get push notification title

    fileprivate func extractTitle(fromPushNotificationUserInfo userInfo:[AnyHashable: Any]) -> String? {
        var message: String?
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let alertMessage = alert["title"] as? String {
                    message = alertMessage
                }
            }
        }
        return message
    }

    //5.in case of error
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("eror apns \(error)")
    }
    //6. just update to server  nvDeviceToken, int iUserId
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
                        isok = true
                    }
                    if isok == true {
                        api.sharedInstance.UpdateDeviceTokenByUserId(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                print("token result \(RESPONSEOBJECT)")
                            }
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            //                                if AppDelegate.showAlertInAppDelegate == false
                            //                                {
                            //                                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            //                                    AppDelegate.showAlertInAppDelegate = true
                            //                                }
                        })
                    }
                }
            }
        }
    }
    //7 app is in background  this works only in iOS 10

    func reloadsyscategandalerts(){
        print("AppDelegate.arrDomains.count \(AppDelegate.arrDomains.count)")
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
        var finalIntforlang:Int = 2

        finalIntforlang = defaultForlanguage  + 1
        dic["iLanguageId"] = finalIntforlang as AnyObject
        AppDelegate.arrDomains = Array<Domain>()
        AppDelegate.arrDomainFilter = Array<Domain>()
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetFieldsAndCatg(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    let domain:Domain = Domain()
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        AppDelegate.arrDomains = domain.domainToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)

                        if AppDelegate.arrDomains.count == 0
                        {
                            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))

                        }
                        //     var idLast = -1
                        for domain in AppDelegate.arrDomains
                        {
                            AppDelegate.arrDomainFilter.append(domain)
                        }
                        print("AppDelegate.arrDomains.count \(AppDelegate.arrDomains.count)")

                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                //                    if AppDelegate.showAlertInAppDelegate == false
                //                    {
                //                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                //                        AppDelegate.showAlertInAppDelegate = true
                //                    }
                print("Eroare aici: \(Error!.localizedDescription)")
            })
        }


        //\\todofix on server dic["iLanguageId"] = 1
        dic["iLanguageId"] = finalIntforlang as AnyObject

        api.sharedInstance.GetSysAlertsList(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {

                    let sysAlert:SysAlerts = SysAlerts()
                    if let _:Array<SysAlerts> = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>) {
                        Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                        print("sysalll \(Global.sharedInstance.arrSysAlerts.count)")
                        if Global.sharedInstance.arrSysAlerts.count != 0
                        {
                            Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
                            Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
                            Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
                            Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
                            Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
                            Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
                            //   Global.sharedInstance.arrayDicForTableViewInCell[4]![1] = sysAlert.SysnvAletName(12)
                        }
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            //                    if AppDelegate.showAlertInAppDelegate == false
            //                    {
            //                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            //                        AppDelegate.showAlertInAppDelegate = true
            //                    }
        })
    }
    
    func returnCURRENTKEY() -> String {
        let USERDEF = UserDefaults.standard
        var HELPSCREENKEYFORNSUSERDEFAULTSread:String = ""
        if USERDEF.object(forKey: "HELPSCREENKEYFORNSUSERDEFAULTS") != nil {
            HELPSCREENKEYFORNSUSERDEFAULTSread = USERDEF.object(forKey: "HELPSCREENKEYFORNSUSERDEFAULTS") as! String
        }
        print("HELPSCREENKEYFORNSUSERDEFAULTSread \(HELPSCREENKEYFORNSUSERDEFAULTSread)")
        return HELPSCREENKEYFORNSUSERDEFAULTSread
    }

    func returnCURRENTHELPSCREENS() -> (NSArray) {
        let USERDEF = UserDefaults.standard
        var HELPSCREENKEYFORNSUSERDEFAULTS = ""

        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var imagesarray:NSArray = NSArray()
        if deviceIdiom == .pad {
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                if  USERDEF.object(forKey: "HELPSCREENSIPADHEB") != nil {
                    imagesarray = USERDEF.object(forKey: "HELPSCREENSIPADHEB") as! NSArray
                    HELPSCREENKEYFORNSUSERDEFAULTS = "HELPSCREENSIPADHEB"
                }
            }
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 1 {
                if  USERDEF.object(forKey: "HELPSCREENSIPADEN") != nil {
                    imagesarray = USERDEF.object(forKey: "HELPSCREENSIPADEN") as! NSArray
                    HELPSCREENKEYFORNSUSERDEFAULTS = "HELPSCREENSIPADEN"
                }
            }
        }else {
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                if  USERDEF.object(forKey: "HELPSCREENSIPHONEHEB") != nil {
                    imagesarray = USERDEF.object(forKey: "HELPSCREENSIPHONEHEB") as! NSArray
                    HELPSCREENKEYFORNSUSERDEFAULTS = "HELPSCREENSIPHONEHEB"
                }
            }
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 1 {
                if  USERDEF.object(forKey: "HELPSCREENSIPHONEEN") != nil {
                    imagesarray = USERDEF.object(forKey: "HELPSCREENSIPHONEEN") as! NSArray
                    HELPSCREENKEYFORNSUSERDEFAULTS = "HELPSCREENSIPHONEEN"
                }
            }
        }


        USERDEF.set(HELPSCREENKEYFORNSUSERDEFAULTS,forKey :"HELPSCREENKEYFORNSUSERDEFAULTS")
        USERDEF.synchronize()
        self.HELPSCREENKEY = HELPSCREENKEYFORNSUSERDEFAULTS


        return imagesarray
    }
    //NEW DEVELOP
    func s45FB185D380DEA55FA5BFA335B4B6821ADD7A0794851F185() {
        let dicforserver:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        api.sharedInstance.GetSerial(dicforserver, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                print("GetSerial \(RESPONSEOBJECT)")
                 let MYDICTIONARY:Dictionary<String,AnyObject> = (RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject>)!
                if MYDICTIONARY["ErrorCode"] as! Int == 1
                {
                    if let _:Array<Int> = RESPONSEOBJECT["Result"] as? Array<Int> {
                        let abtys:Array<Int> = RESPONSEOBJECT["Result"] as! Array<Int>
                        print("NUMBER BYTES \(abtys)")
                        //\\  self.a33C46F1734F5CD33BEAB71C8A(bc: abtys)
                        self.keyserver = "access-token"
                        api.sharedInstance.keyserver = self.keyserver
                        self.afterkeya()
                    }
                } else {
                    //                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    //\\  self.afterkeya()
                    self.keyserver = "access-token"
                    api.sharedInstance.keyserver = self.keyserver
                    self.afterkeya()
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            //            if AppDelegate.showAlertInAppDelegate == false
            //            {
            //                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            //
            //            }
            self.keyserver = "access-token"
            api.sharedInstance.keyserver = self.keyserver
            self.afterkeya()
        })

    }



    func a33C46F1734F5CD33BEAB71C8A(bc:Array<Int>) {
        let ms = readx()
        var myx:String = ""
        //  let bc = [0,1,2,3,4,5,6]
        // for bs in 0...31 {
        for bs in bc {
            if let cs:String = ms.substring(with: bs..<bs+1) as? String  {
                myx =  myx + cs
            } else {
                print("cannot read index \(bs)")
            }
        }
        //        print("myx   \(myx)")
        //        print("myxutf   \(myx.utf8)")
        //        let utf8Data = myx.data                             // 36 bytes
        //        let base64EncodedString = utf8Data.base64EncodedString() //  aU9TIERldmVsb3BlciBUaXBzIGVuY29kZWQgaW4gQmFzZTY0\n"
        //        let base64EncodedData = utf8Data.base64EncodedData()     //  48 bytes"
        //
        //        print("base64EncodedData:", myx.base64Encoded1)      //  48 bytes
        //        print("base64EncodedString:", myx.base64Encoded1.string ?? "") // "aU9TIERldmVsb3BlciBUaXBzIGVuY29kZWQgaW4gQmFzZTY0"
        //        let MYXFI = myx.base64Encoded1.string
        //
        //        print("base64DecodedData:", myx.base64Encoded1.string?.base64Decoded1  ?? "") // 36 bytes
        //        print("base64DecodedString:", myx.base64Encoded1.string?.base64Decoded1?.string ?? "") // origin
        //        print(A3C750FC50CB8F7D(ac:  myx.base64Encoded1.string!))
        let key = A3C750FC50CB8F7D(ac:  myx.base64Encoded1.string!)
        //\\  self.keyserver = key
        self.keyserver = "access-token"
        api.sharedInstance.keyserver = self.keyserver
        self.afterkeya()
        // api.sharedInstance.keyserver = key
        //    self.afterkeya()
        //
    }

    func readx()-> String{
        var mydata = ""
        let path1 = Bundle.main.url(forResource: "f1D0071C90843880915F9A5" , withExtension: "c0d")
        do {
            mydata = try String(contentsOf: path1!, encoding: String.Encoding.utf8 )
        } catch {
            print(error)
        }
        return mydata
    }
    func A3C750FC50CB8F7D(ac:String) -> String {
        let data = ac.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })

        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
}
extension UIApplication {
    var cstm_userInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
        get {
            let USERDEF = UserDefaults.standard
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {

                return UIUserInterfaceLayoutDirection.rightToLeft
            }

            return UIUserInterfaceLayoutDirection.leftToRight
        }
    }
}
extension UIApplication {
    class func topViewController(_ controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }

        return controller
    }
}
public extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    func base64Encoded() -> String? {
        if let data = self.data(using: .ascii) {
            return data.base64EncodedString()
        }
        return nil
    }

}
extension String {
    var data:          Data  { return Data(utf8) }
    var base64Encoded1: Data  { return data.base64EncodedData() }
    var base64Decoded1: Data? { return Data(base64Encoded: self) }
}

extension Data {
    var string: String? { return String(data: self, encoding: .utf8) }
}
extension UIViewController
{
    func GoogleAnalyticsSendEvent(x:Int) {
        DispatchQueue.global(qos: .background).async {
        //        if api.sharedInstance.WITCHDOMAIN != 2 {
        //            return
        //        }
        let myarray = ["", //empty to keep 0 clear all screens start from 1
            "Entrance screen",
            "Customer Registration",
            "Supplier Registration",
            "Customer HomePage",
            "Search Results",
            "List Of Services",
            "Customer Side Calendar",
            "Customer Side Calendar - Day View",
            "Customer Side Calendar - Week View",
            "Customer Side Calendar - Month View",
            "Customer Side Calendar - List View",
            "Meeting Process- Calendar",
            "Meeting Process- Calendar - Day View",
            "Meeting Process- Calendar - Week View",
            "Meeting Process- Calendar - Month View",
            "Customer Side Plus Menu",
            "Short delay",
            "Help",
            "Meeting Cancelation",
            "My appointments",
            "Live Chat",
            "Providers list",
            "Customer settings",
            "Personal information",
            "Notifications",
            "Language Screen",
            "About us",
            "Meeting Details - Customer",
            "Meeting Details - Supplier",
            "Supplier Side Plus Menu",
            "New Meeting",
            "New Event",
            "Add Block Hours",
            "Cancel Block Hours",
            "Customer Approval",
            "Supplier Help",
            "Mass Notification For Customer",
            "Supplier Settings - Business Profile",
            "My Customers",
            "Suppliers Profile Page View",
            "Add Occasional Customer",
            "Add New Customer",
            "Delete Customer",
            "Supplier Side- Customer List of Meetings",
            "Customer Profile",
            "Update Customer",
            "Supplier Settings",
            "Supplier Settings- Notifications",
            "Supplier Settings- General Details",
            "Supplier Settings- Business Details ",
            "Supplier Settings- Manage Calendar",
            "Supplier Settings- Sync Contacts",
            "Supplier Settings- Employees",
            "Supplier Settings- Payment ",
            "Supplier Notification List",
            "Tax Report ",
            "Print Calendar",
            "Multiple Appoinments",
            "Supplier Side Calendar",
            "Supplier Side Calendar - Day View",
            "Supplier Side Calendar - Week View",
            "Supplier Side Calendar - Month View",
            "Supplier Side Calendar - List View"]

        let screentitle = myarray[x] as String
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(screentitle)",
            AnalyticsParameterItemName: screentitle,
            AnalyticsParameterContentType: "cont"
            ])
        }
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set(kGAIScreenName, value: screentitle)
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as NSDictionary  as [NSObject : AnyObject])
    }
}
public extension UIDevice {

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
