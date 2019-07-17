//  entranceCustomerViewController.swift
//  Bthere
//
//  Created by User on 7.7.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import MarqueeLabel
import CoreLocation
//import Crashlytics

protocol ParentpresentViewControllerDelegate {
    func ParentpresentViewController()
    func showindicator()
    func hideindicator()
}


protocol reloadFromBackBusiness
{
   func getProvidersList()
}
 struct A {
    var myphone = "990"
}
class B {
    var myphone = "070"
    var a:Int = 6
    init(myphone:String, a:Int){
        self.myphone = myphone
        self.a = a
        print("\(myphone) is being initialized.")
    }
}
    class C:B {
        var newone:Int = 0
        override init(myphone:String, a:Int) {
        super.init(myphone:"0000", a:10)
            self.myphone = "aaaa"

        }

        func callme() {


            print("ccc")
        }
    }
//    deinit {
//        print(" hhh ")
//    }


class entranceCustomerViewController: NavigationModelViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, openFromMenuDelegate, openSearchResultsDelegate,TTTAttributedLabelDelegate, ParentpresentViewControllerDelegate,reloadFromBackBusiness,CLLocationManagerDelegate {
    /* 30.10.2018 Add GetToKnowThesystem */
    @IBOutlet weak var CentralButton:UIView!
    @IBOutlet weak var TitleScreen:UILabel!
    @IBOutlet weak var LineText1:UILabel!
    @IBOutlet weak var ViewButtonProvider:UIView!
    @IBOutlet weak var ViewButtonCustomer:UIView!
    @IBOutlet weak var LineTextButtonProvider:UILabel!
    @IBOutlet weak var LineTextButtonCustomer:UILabel!
    @IBOutlet weak var CloseXButton:UIButton!
    @IBOutlet weak var lefmargintalign:NSLayoutConstraint!
    @IBOutlet weak var rightmargintalign:NSLayoutConstraint!

    /* end GetToKnowThesystem */

    @IBOutlet weak var butonwidth: NSLayoutConstraint!
    var constactNumber = ""
    var isLOCKEDREGISTRATION:Bool = true
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet var imgView: UIView!
    @IBOutlet weak var btnOpemMenu: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var SCREENCONSUMER: UIView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var resgisterToBusinessLabel: UILabel!
    @IBOutlet var suppliersView: UIView!
    @IBOutlet var suppliersTable: UITableView!
    @IBOutlet var loadingSuppliersActivity: UIActivityIndicatorView!
    @IBOutlet var lblAdvertising: MarqueeLabel! // weak UILabel
    @IBOutlet weak var btnSeachAdvantage: UIButton!
    @IBOutlet weak var btnOpenMenuEnglish: UIImageView!
    
    
    //MARK: - Properties
    //===========Properties============
    var clientStoryBoard:UIStoryboard?
    var filtered:Array<String> = []
    
    var searchActive : Bool = false
    // Variables
    var myformchangelanguage:Bool = false
    var suppliersNamesValues:Array<String> = Array<String>()
    var providersArray:Array<SearchResulstsObj> = Array<SearchResulstsObj>()
    var isSearching:Bool = false
    //  GetProviderListForCustomerAuthorizedFromSupplier(int iUserId)
    var dicResultsOK:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
    //    var filterSubArr:Array<String> = []
    //fix 2.3
    var filterSubArr:NSArray =  NSArray()
    //var filterSubArr:NSMutableArray =  NSMutableArray()//fix 2.3
    var attributedStrings = NSMutableAttributedString(string:"")
    var generic:Generic = Generic()
    
    var isAuto = false
    
    let defaultScrollDuration: CGFloat = 20.0
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()//עבור השליחה לשרת
    @IBOutlet weak var popUPPASSWORD:UIView!
    @IBOutlet weak var titlepopUPPASSWORD:UILabel!
    @IBOutlet weak var EXPLAIN_PASSWORD:TTTAttributedLabel!
    @IBOutlet weak var EXPLAIN_PASSWORD_LINETWO:TTTAttributedLabel!
    @IBOutlet weak var txtPASSWD: UITextField!
    @IBOutlet weak var btnCONFIRMPASS: UIButton!
    @IBOutlet weak var btnCloseX: UIButton!
    @IBAction func btnContinueAction(_ sender: AnyObject) {
                Global.sharedInstance.defaults.set(0, forKey: "ISFROMSETTINGS")
                Global.sharedInstance.defaults.synchronize()
                Global.sharedInstance.defaults.set(1,  forKey: "isenteringregister")
                Global.sharedInstance.defaults.synchronize()
                Global.sharedInstance.isProvider = true
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewCon:RgisterModelViewController = storyboard.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
                let viewCon1:GlobalDataViewController = storyboard.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
                viewCon.delegateFirstSection = viewCon1
                viewCon.delegateSecond1Section = viewCon1
                let front = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                front.pushViewController(viewCon, animated: false)
                let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                let mainRevealController = SWRevealViewController()
                mainRevealController.frontViewController = front
                mainRevealController.rearViewController = rearViewController
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.rootViewController = mainRevealController
                
         
     //   }
    }
    func openTrialScreen() {
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
    @IBAction func btnCloseX(_ sender: AnyObject) {
        self.popUPPASSWORD.isHidden = true
        self.txtPASSWD.text = ""
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.setHELPSCREENS()
//        self.LOADHELPERS(6)
    }
    @IBAction func checkpassword(_ sender: AnyObject) {
        //   self.dismissKeyboard()
        if self.txtPASSWD.text == "" {
            DispatchQueue.main.async(execute: { () -> Void in
                self.showAlertDelegateX("PASSWORD_NOT_ENTERED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        } else
            if self.txtPASSWD.text != ""  && self.txtPASSWD.text != "zen2088" {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.showAlertDelegateX("WRONG_PASSWORD_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                })
            } else  if self.txtPASSWD.text == "zen2088" {
               // self.gofaraway()
        }
        
    }
    func ParentpresentViewController() {
        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
        let viewpop:PopUpGenericViewController = storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController
        if self.iOS8 {
            viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        viewpop.isfromWhichScreen = 3
        self.present(viewpop, animated: true, completion: nil)
    }
   
    @IBAction func btnSkipAction(_ sender: AnyObject) {
       self.SCREENCONSUMER.isHidden = true
//        self.LOADHELPERS(6)
        
    }
    
    //MARK: - TextField
    func getnews(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
             var y:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
                dic["iUserId"] = y as AnyObject
            }
            api.sharedInstance.GetNewsAndUpdates(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        if let abcd = RESPONSEOBJECT["Result"] as? String {
                            self.lblAdvertising.tag = 101
                            self.lblAdvertising.type = .continuous
                            self.lblAdvertising.animationCurve = .linear
                            self.lblAdvertising.type = .leftRight
                            self.lblAdvertising.text  = abcd
                            self.lblAdvertising.restartLabel()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
    }
    
    func UpdateiOSVersionByUserId(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var myversion:String = ""
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            myversion = version
        }
        if myversion.characters.count > 0 {
            var y:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
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
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
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
    
    func UpdateLocationCoordinatesByUserId(){
        if Reachabilitya.isLocationServiceEnabled() == true {
           
            var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dic["dLongitude"] = Global.sharedInstance.currentLong?.description as AnyObject
            dic["dLatitude"] = Global.sharedInstance.currentLat?.description as AnyObject
            if Global.sharedInstance.currentUser.iUserId != 0  {
                dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
            }
            print(dic.description)
            if Reachability.isConnectedToNetwork() == false
            {
                Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else
            {
                api.sharedInstance.UpdateLocationCoordinatesByUserId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        print("UpdateLocationCoordinatesByUserId \(RESPONSEOBJECT)")
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    print("error \(Error)")
                })
            }
        } else {

            let alert = UIAlertController(title: nil, message: "REQUEST_LOCATION_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
            })
            
            self.present(alert, animated: true, completion: nil)
        }
        
       
}
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtPASSWD.textColor = UIColor.white
        // txtPASSWD.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    //OLDCODE
    @IBAction func btnSearchx(_ sender: AnyObject) {
        isSearching = true
        dismissKeyboard()
        Global.sharedInstance.searchDomain = txtSearch.text!
        
        if txtSearch.text != ""
        {
            Global.sharedInstance.dicSearch["nvKeyWord"] = txtSearch.text as AnyObject
            Global.sharedInstance.dicSearch["nvlong"] = Global.sharedInstance.currentLong as AnyObject
            Global.sharedInstance.dicSearch["nvlat"] = Global.sharedInstance.currentLat as AnyObject
            Global.sharedInstance.dicSearch["nvCity"] = nil
            
            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                api.sharedInstance.SearchByKeyWord(Global.sharedInstance.dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        print("**************** SearchByKeyWord ****************\n")
                        let jsonData = try! JSONSerialization.data(withJSONObject: RESPONSEOBJECT, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                        print(jsonString)
                        print("**************** End SearchByKeyWord ****************\n")
                        if  let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject> {
                        let MYDICTIONARY:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as! Dictionary<String,AnyObject>
                            if let _ = MYDICTIONARY["ErrorCode"] as? Int {
                            if MYDICTIONARY["ErrorCode"] as! Int == -3
                            {
                                self.showAlertDelegateX("NO_RESULTS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else if MYDICTIONARY["ErrorCode"] as! Int == 1
                            {
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                    Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                    print("תוצאות חיפוש :\(Global.sharedInstance.dicResults)" )
                                }
                                Global.sharedInstance.dicSearchProviders = Global.sharedInstance.dicSearch
                                Global.sharedInstance.whichSearchTag = 1
                                self.openSearchResults()
                            }
                        }
                    }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                })
            }
        }
        else
        {
            Alert.sharedInstance.showAlert("NOT_DATA_TO_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        }
    }
    

   // dispatch async
//    DispatchQueue.global(qos: .background).async {
//
//    DispatchQueue.main.async {
//
//    }
//    }
    
    
    
    
    //NEWDEVELOP
    @IBAction func btnSearch(_ sender: AnyObject) {
        isSearching = true
        dismissKeyboard()
        Global.sharedInstance.searchDomain = txtSearch.text!
        if txtSearch.text == "" {
            Alert.sharedInstance.showAlert("NOT_DATA_TO_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        } else  if txtSearch.text != "" && (txtSearch.text?.count)! < 2 {
            Alert.sharedInstance.showAlert("SEARCHLESS3LETTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        } else
        if txtSearch.text != "" && (txtSearch.text?.count)! >= 2
        {
            //    Global.sharedInstance.dicSearch["nvKeyWord"] = txtSearch.text as AnyObject
            Global.sharedInstance.dicSearch["nvKeywords"] = txtSearch.text as AnyObject
            Global.sharedInstance.dicSearch["nvLong"] = Global.sharedInstance.currentLong as AnyObject
            Global.sharedInstance.dicSearch["nvLat"] = Global.sharedInstance.currentLat as AnyObject
            Global.sharedInstance.dicSearch["nvCity"] = nil
            var y:Int = 0
            var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
            }
            Global.sharedInstance.dicSearch["iUserId"]  = y as AnyObject
            self.generic.showNativeActivityIndicator (self)
            
            
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                api.sharedInstance.SearchByKeyWords(Global.sharedInstance.dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                     //\\   print(responseObject)
                        print("**************** SearchByKeyWords ****************\n")
                        let jsonData = try! JSONSerialization.data(withJSONObject: RESPONSEOBJECT, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//                        print(jsonString)
                        print("**************** End SearchByKeyWords ****************\n")
                        if  let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject> {
                            let MYDICTIONARY:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as! Dictionary<String,AnyObject>

                        if let _ = MYDICTIONARY["ErrorCode"] as? Int {
                            if MYDICTIONARY["ErrorCode"] as! Int == -3
                            {
                                self.showAlertDelegateX("NO_RESULTS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else if MYDICTIONARY["ErrorCode"] as! Int == 1
                            {
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                    Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                          //          print("תוצאות חיפוש :\(Global.sharedInstance.dicResults)" )
                                }
                                Global.sharedInstance.dicSearchProviders = Global.sharedInstance.dicSearch
                                Global.sharedInstance.whichSearchTag = 1
                                self.openSearchResults()
                            }
                        }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                })
            }
        }


    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async(execute: { () -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                print("AAAA")

            })
            print("bbbbbb")
        })

        SCREENCONSUMER.addBackground()
        let USERDEF = UserDefaults.standard
        if  USERDEF.object(forKey: "CHOOSEN_LANGUAGE") == nil {
            USERDEF.set(0, forKey: "CHOOSEN_LANGUAGE")
            USERDEF.synchronize()
            
        }
        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        if myformchangelanguage == true {
            
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
            myformchangelanguage = false
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set(kGAIScreenName, value: "entranceCustomerViewController")
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as NSDictionary  as [NSObject : AnyObject])
        /* 30.10.2018 Add GetToKnowThesystem */
        if UIDevice.current.userInterfaceIdiom == .pad {
            lefmargintalign.constant = 80
            rightmargintalign.constant = 80

        } else {
            lefmargintalign.constant = 30
            rightmargintalign.constant = 30

        }
        /* end GetToKnowThesystem */
        GoogleAnalyticsSendEvent(x:4)
        let USERDEF = UserDefaults.standard
        if USERDEF.object(forKey: "iFirstCalendarViewType") != nil {
            print(USERDEF.integer(forKey: "iFirstCalendarViewType"))
            USERDEF.removeObject(forKey: "iFirstCalendarViewType")
            USERDEF.synchronize()
        }
      //  checkisLOCKEDREGISTRATION()
        btnSeachAdvantage.setTitle("MY_GIVESERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        //   lblAdvertising.text = ("ADVERTISINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rtlRELOAD()
      //  appDelegate.setHELPSCREENS()
        // Hide table
        suppliersTable.isHidden = true
        suppliersTable.delegate = self
        suppliersTable.dataSource = self
       self.getProvidersList()
        suppliersNamesValues = ["Some Business", "Another Company", "A Person", "A Dog", "A Cat", "Corporation"]
        self.suppliersTable.reloadData()
        
    }
    //MARK: - initial
    /*
     JOIN_US = "הצטרף אלינו";
     SKIP ="לדלג";
     */
    func checkisLOCKEDREGISTRATION() {
        let dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetIsBlockSupReg(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else   if let _:Int = RESPONSEOBJECT["Result"] as? Int {
                        let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                        print("sup id e ok ? " + myInt.description)
                        if myInt == 0 {
                            self.isLOCKEDREGISTRATION = false
                        } else{
                            self.isLOCKEDREGISTRATION = true
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                print("Eroare \(Error!.localizedDescription)")
            })
        }
    }
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var viewhelp : helpPpopup!
    func LOADHELPERS(_ a:Int) {
        var HELPSCREENKEYFORNSUSERDEFAULTS = ""
        let USERDEF = UserDefaults.standard
        var imagesarray:NSArray = NSArray()
        //     returnCURRENTHELPSCREENS() -> (HLPKEY:String, imgs:NSArray)
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        imagesarray = appDelegate.returnCURRENTHELPSCREENS()
        //  HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.HELPSCREENKEY
        HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.returnCURRENTKEY()
        print("HELPSCREENKEYFORNSUSERDEFAULTS \(HELPSCREENKEYFORNSUSERDEFAULTS)")
        if  imagesarray.count > 0 {
            let fullimgarr:NSMutableArray = imagesarray.mutableCopy() as! NSMutableArray
            print("aaa \(fullimgarr.description)")
            if let mydict:NSMutableDictionary = fullimgarr[a] as? NSMutableDictionary {
                if mydict["seen"] as! Int == 1 { //was not seen
                    let changedictionary: NSMutableDictionary = NSMutableDictionary()
                    changedictionary["needimage"] = mydict["needimage"]
                    changedictionary["seen"] = a //seen
                    print("changedic \(changedictionary)")
                    fullimgarr[a] = changedictionary
                    print("fullimgarr \(fullimgarr.description)")
                    USERDEF.set(fullimgarr, forKey: HELPSCREENKEYFORNSUSERDEFAULTS)
                    USERDEF.synchronize()
                    print("USERDEF key arr \(USERDEF.object(forKey: HELPSCREENKEYFORNSUSERDEFAULTS))")
                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    viewhelp = storyboardtest.instantiateViewController(withIdentifier: "helpPpopup") as! helpPpopup
                    if self.iOS8 {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    } else {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    }
                    viewhelp.indexOfImg = a
                    viewhelp.HELPSCREENKEYFORNSUSERDEFAULTS = HELPSCREENKEYFORNSUSERDEFAULTS
                    self.present(viewhelp, animated: true, completion: nil)
                }
            }
        }
    }
    func generateforDragos() {
        let cal = Foundation.Calendar.current
        var date = cal.startOfDay(for: Date())
        var days = [Date]()
        for _ in 1 ... 30 {
            let day:Date =  date
            days.append(day)
            date = (cal as NSCalendar).date(byAdding: .day, value: 1, to: date, options: [])!
        }
        for a in days {
            print("\nzile in luna \(a) : \(Global.sharedInstance.convertNSDateToString(a))")
        }
        
    }
    @objc func makeCall()
    {
        Global.sharedInstance.makeCall(constactNumber as NSString)
        
    }
    func openprov() {
        Global.sharedInstance.isProvider = true
        ///

        ////////
        let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController

        //                    let vc = supplierStoryBoard!.instantiateViewControllerWithIdentifier("CalendarSupplierViewController") as! CalendarSupplierViewController
        //                    Global.sharedInstance.whichReveal = true
        //                     Global.sharedInstance.isFromprintCalender = false
        //                    frontviewcontroller?.pushViewController(vc, animated: false)

        // initialize REAR View Controller- it is the LEFT hand menu.

        let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController

        let mainRevealController = SWRevealViewController()

        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let CalendarSupplier: CalendarSupplierViewController = supplierStoryBoard!.instantiateViewController(withIdentifier: "CalendarSupplierViewController")as! CalendarSupplierViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: CalendarSupplier)
        mainRevealController.pushFrontViewController(navigationController, animated: false)
        mainRevealController.revealToggle(animated: true)
        Global.sharedInstance.isFromprintCalender = false
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    func allFrameworks() -> [AnyObject] {
        return Bundle.allFrameworks
    }

    func ceva( somestatic:String...) {
        print(somestatic[0])
    }

    override func viewDidLoad() {
        ceva(somestatic: "c00l", "op", "cal")

        super.viewDidLoad()
        let S = A()
        let Z = S
        let D = C(myphone: "99999", a: 4)
        D.newone = 10
      
        var nmod = S.myphone
        nmod = nmod + "0000"
        print(nmod)
        print(Z.myphone)





//        let my = allFrameworks()
//            for a in my {
//                print(a.description)
//            }
// DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
    var T:B? = B(myphone: "99990",a :90)
    let Y = T
    print(Y!.myphone)
    T!.myphone = "05505"
    print(Y!.myphone)
    print(T!.myphone)
    T = nil
    print(T ?? nil)
    let result = T == nil ? "Pass" : "Fail"
    print(result ?? "ok")
//        }



    //    Crashlytics.sharedInstance().crash()
        Global.sharedInstance.nameOfCustomer = ""
        
        var storyboard1:UIStoryboard?
        storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        Global.sharedInstance.viewCon2 = storyboard1!.instantiateViewController(withIdentifier: "ViewBusinessProfileVC") as? ViewBusinessProfileVC
        Global.sharedInstance.viewCon2!.modalPresentationStyle = UIModalPresentationStyle.custom
        Global.sharedInstance.entranceCustomer = self
        Global.sharedInstance.viewCon2!.backDelegate = self
        Global.sharedInstance.isFromEntranceOrProviders = 1
//        Global.sharedInstance.viewCon2?.oneTimeCounter = 1
        //play with unicode J
//        let mystra = "چهار راه"
//        let mystrb = "خیابان."
//        let mystrc = "خیابان 5"
//        let mystrd = "چرا copy کردی؟"
//        for a in mystra {
//            if String(a).matches("[\u{600}-\u{6FF}\u{064b}\u{064d}\u{064c}\u{064e}\u{064f}\u{0650}\u{0651}\u{0020}]") { // /^[\u0600-\u06FF\s]+$/    ^[\x{600}-\x{6FF}\x{200c}\x{064b}\x{064d}\x{064c}\x{064e}\x{064f}\x{0650}\x{0651}\s]
//
//        } else {
//            print("ano--\(a)---zzzz")
//            break
//            }
//        }
//        for a in mystrb {
//            if String(a).matches("[\u{600}-\u{6FF}\u{064b}\u{064d}\u{064c}\u{064e}\u{064f}\u{0650}\u{0651}\u{0020}]") { // /^[\u0600-\u06FF\s]+$/    ^[\x{600}-\x{6FF}\x{200c}\x{064b}\x{064d}\x{064c}\x{064e}\x{064f}\x{0650}\x{0651}\s]
//
//            } else {
//                print("bno--\(a)---zzzz")
//                break
//            }
//        }
//        for a in mystrc {
//            if String(a).matches("[\u{600}-\u{6FF}\u{064b}\u{064d}\u{064c}\u{064e}\u{064f}\u{0650}\u{0651}\u{0020}]") { // /^[\u0600-\u06FF\s]+$/    ^[\x{600}-\x{6FF}\x{200c}\x{064b}\x{064d}\x{064c}\x{064e}\x{064f}\x{0650}\x{0651}\s]
//
//            } else {
//                print("cno--\(a)---zzzz")
//                break
//            }
//        }
//        for a in mystrd {
//            if String(a).matches("[\u{600}-\u{6FF}\u{064b}\u{064d}\u{064c}\u{064e}\u{064f}\u{0650}\u{0651}\u{0020}]") { // /^[\u0600-\u06FF\s]+$/    ^[\x{600}-\x{6FF}\x{200c}\x{064b}\x{064d}\x{064c}\x{064e}\x{064f}\x{0650}\x{0651}\s]
//
//            } else {
//                print("dno--\(a)---zzzz")
//                break
//            }
//        }


        /* 30.10.2018 Add GetToKnowThesystem */
        let tapProvider:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openVideoProviderScreen))
        ViewButtonProvider.addGestureRecognizer(tapProvider)
        let tapCustomer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openVideoCustomerScreen))
        ViewButtonCustomer.addGestureRecognizer(tapCustomer)
        ViewButtonCustomer.backgroundColor = Colors.sharedInstance.color4
        ViewButtonCustomer.backgroundColor = Colors.sharedInstance.color3
        TitleScreen.text = "GETTOKNOWTHESYSTEMSCREENTITLESCREEN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText1.text = "GETTOKNOWTHESYSTEMSCREENLINE1TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineTextButtonProvider.text = "GETTOKNOWTHESYSTEMSCREENTEXTBUTTONPROVIDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineTextButtonCustomer.text = "GETTOKNOWTHESYSTEMSCREENTEXTBUTTONCUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        /* end GetToKnowThesystem */
        Global.sharedInstance.defaults.set(0,  forKey: "isenteringregister")
        Global.sharedInstance.defaults.set(0,  forKey: "isfromSPECIALiCustomerUserId")
        Global.sharedInstance.defaults.synchronize()
        
        suppliersTable.separatorStyle = .none
        
        let USERDEF = UserDefaults.standard
        USERDEF.set(0, forKey: "listservicesindexRow")
        let mys = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")
        print("FINDisfromSPECIALiCustomerUserId \(mys)")
        //NEWDEVELOP
        if USERDEF.integer(forKey: "UPDATELOCATIONFORUSER") == 1 {
            UpdateLocationCoordinatesByUserId()
            USERDEF.set(0, forKey: "UPDATELOCATIONFORUSER")
            USERDEF.synchronize()
            
        }
        //end NEWDEVELOP uncomment for branch 2.4
      
        Global.sharedInstance.ordersOfClientsTemporaryArray = Array<OrderDetailsObj>() //always clean temporary array of multiple appointments
        Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS = false //close multiple appoinments case
  
        if  USERDEF.object(forKey: "WEEKSFORSUPPLIER") == nil {
            USERDEF.set(52, forKey: "WEEKSFORSUPPLIER")
            USERDEF.synchronize()
        } else {
            USERDEF.set(52, forKey: "WEEKSFORSUPPLIER")
            USERDEF.synchronize()
        }
        if  USERDEF.object(forKey: "MAXSERVICEFORCUSTOMER") == nil {
            USERDEF.set(26, forKey: "MAXSERVICEFORCUSTOMER")
            USERDEF.synchronize()
        } else {
            USERDEF.set(26, forKey: "MAXSERVICEFORCUSTOMER")
            USERDEF.synchronize()
        }
        
        
        
        // helpPpopup
        //\\TOdo
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
       // appDelegate.setHELPSCREENS()
       // self.LOADHELPERS(0)
        generateforDragos()
        
        
        loadingSuppliersActivity.isHidden = true
        // self.generic.showNativeActivityIndicator(self)
        
        //loadingSuppliersActivity.startAnimating()
        if UIDevice.current.userInterfaceIdiom == .pad {
            btnContinue.titleLabel!.font = UIFont (name: "OpenSansHebrew-Bold", size: 28)
            btnSkip.titleLabel!.font = UIFont (name: "OpenSansHebrew-Bold", size: 28)
            // btnCONFIRMPASS.titleLabel!.font  = UIFont (name: "OpenSansHebrew-Bold", size: 28)
            
        } else {
            btnContinue.titleLabel!.font = UIFont (name: "OpenSansHebrew-Bold", size: 18)
            btnSkip.titleLabel!.font = UIFont (name: "OpenSansHebrew-Bold", size: 18)
            //  btnCONFIRMPASS.titleLabel!.font  = UIFont (name: "OpenSansHebrew-Bold", size: 18)
        }
        
        // Start spin loading
        // loadingSuppliersActivity.hidesWhenStopped = true
        // Update text based on user"s language
        btnSeachAdvantage.setTitle("MY_GIVESERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        //  lblAdvertising.text = "ADVERTISINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        resgisterToBusinessLabel.text = "REGISTER_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnContinue.setTitle("JOIN_US".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnSkip.setTitle("SKIP".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        btnCONFIRMPASS.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        titlepopUPPASSWORD.text = "ENTER_PASSWORD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        EXPLAIN_PASSWORD.text = "EXPLAIN_PASSWORD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
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
        popUPPASSWORD.isHidden = true
        txtPASSWD.delegate = self
        txtPASSWD.text = ""
        Global.sharedInstance.defaults.set(0, forKey: "mustreloadprovider")
        Global.sharedInstance.defaults.synchronize()
        //JOPPP
        //jjjj self.SCREENCONSUMER.hidden = false
        self.SCREENCONSUMER.isHidden = true
        self.SCREENCONSUMER.isHidden = false
        //        var eprimadata : Bool = false
        //        let ABTESTINGX = CheamaIOSObject()
        let DBHELPER = DataMasterProcessor()
        
        //  eprimadata =   ABTESTINGX.primaDatainApp()
        //    print("PRIMA ", eprimadata);
        //  currentUserId
        //commit comment
        //     Global.sharedInstance.defaults.objectForKey("currentUserId")
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            //\\print( "userid \(   Global.sharedInstance.defaults.objectForKey("currentUserId"))")
            
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            
            if dicUserId["currentUserId"] as! Int != 0
            {
                let myint =  dicUserId["currentUserId"] as! Int
                
                let telefonuser = String(myint)
                if(telefonuser != "0") {
                    
                    if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
                    {
                        api.sharedInstance.getProviderAllDetailsbySimpleUserID(myint)
                    }
                    else
                    {
                        api.sharedInstance.getProviderAllDetails(myint)
                    }

                    let arrayverify:NSArray = DBHELPER.getUser(telefonuser) as! NSArray
                    if(arrayverify.count > 0) {
                        //user is already logged and in db
                        //JOPPP
                         self.SCREENCONSUMER.isHidden = true
                         //jjjj self.SCREENCONSUMER.isHidden = false
                    }
                    else {
                        //do insert
                        let DBHELPER = DataMasterProcessor()
                        var exista : Bool = false
                        exista = DBHELPER.insertUser (telefonuser)
                        if(exista == true) {
                            //\\print ("USER SAVED IN DB   2")
                            //\\it is a case  when user registered on another device so keep a flag
                            if Global.sharedInstance.isFIRSTREGISTER == true {
// removed on 11.06.2018 added back on 17.08.2018
                                self.SCREENCONSUMER.isHidden = false
                                self.view.bringSubviewToFront(SCREENCONSUMER)
                                Global.sharedInstance.isFIRSTREGISTER = false
                            } else {
                               self.SCREENCONSUMER.isHidden = true
                             //jjjj     self.SCREENCONSUMER.isHidden = false
                            }
                        }
                    }
                }
            }
        }

        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(entranceCustomerViewController.imageTapped))

        if UIDevice.current.userInterfaceIdiom == .pad {
            butonwidth.constant = 80
        } else {
            butonwidth.constant = 70
        }
        
//        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
//        {
//            btnOpemMenu.image = UIImage(named: "plushebrewcustomer.png")
//            btnOpemMenu.isHidden = false
//            btnOpemMenu.isUserInteractionEnabled = true
//            btnOpenMenuEnglish.isHidden = true
//            btnOpenMenuEnglish.isUserInteractionEnabled = false
//            btnOpemMenu.addGestureRecognizer(tapGestureRecognizer)
//
//        }
//        else
//        {
////            btnOpemMenu.image = UIImage(named: "plusEnglish.png")
//            btnOpenMenuEnglish.image = UIImage(named: "plushebrewcustomer.png")
//            btnOpenMenuEnglish.isHidden = false
//            btnOpenMenuEnglish.isUserInteractionEnabled = true
//            btnOpemMenu.isHidden = true
//            btnOpemMenu.isUserInteractionEnabled = true
//            btnOpenMenuEnglish.addGestureRecognizer(tapGestureRecognizer)
//            
////            var scalingTransform : CGAffineTransform!
////            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
////            btnOpemMenu.transform = scalingTransform
//        }
        ///txtSearch.placeholder = NSLocalizedString("SERACH_SERVICE_DOMAIN", comment: "")
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            txtSearch.attributedPlaceholder = NSAttributedString(string: "SEARCH_SERVICE_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.darkGray,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 13)!]))
        }
        else
        {
            txtSearch.attributedPlaceholder = NSAttributedString(string: "SEARCH_SERVICE_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.darkGray,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        }
        
        
        //  if Global.sharedInstance.rtl == true {
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            txtSearch.textAlignment = .right
        } else {
            txtSearch.textAlignment = .left
        }
        
        
        
        clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        txtSearch.delegate = self
        

        
        self.view.bringSubviewToFront(tblSearch)
        
        
        self.view.addBackground()
        tblSearch.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(entranceCustomerViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        //TutorialScreenSlider
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let secondStoryboard = UIStoryboard(name:"CustomersRecommendations", bundle:nil)
//        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
//        let vc = secondStoryboard.instantiateViewController(withIdentifier: "TutorialScreenSlider") as! TutorialScreenSlider
//        frontviewcontroller?.pushViewController(vc, animated: false)
//        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//        let mainRevealController = SWRevealViewController()
//        mainRevealController.frontViewController = frontviewcontroller
//        mainRevealController.rearViewController = rearViewController
//        let window :UIWindow = UIApplication.shared.keyWindow!
//        window.rootViewController = mainRevealController
        //        ////        //test
//        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
//        //
//        let viewRegulation: JGeneralDetails = mainstoryb.instantiateViewController(withIdentifier: "JGeneralDetails")as! JGeneralDetails
//        viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//        viewRegulation.modalPresentationStyle = .custom
//        self.present(viewRegulation, animated: true, completion: nil)
//                let mainstoryb = UIStoryboard(name: "CustomersRecommendations", bundle: nil)
//                //
//              //  let viewRegulation: CustomersRecommendations = mainstoryb.instantiateViewController(withIdentifier: "CustomersRecommendations")as! CustomersRecommendations
//                let viewRegulation: TutorialScreenSlider = mainstoryb.instantiateViewController(withIdentifier: "TutorialScreenSlider")as! TutorialScreenSlider
//                viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//                viewRegulation.modalPresentationStyle = .custom
//                self.present(viewRegulation, animated: true, completion: nil)

        //        ////        //end test
        ////
//            let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
//            let viewRegulation: TrialScreenViewController = mainstoryb.instantiateViewController(withIdentifier: "TrialScreenViewController")as! TrialScreenViewController
//            viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//            viewRegulation.modalPresentationStyle = .custom
//            self.present(viewRegulation, animated: true, completion: nil)
//        self.suppliersTable.separatorStyle = UITableViewCellSeparatorStyle.none
////         openTrialScreen()
//        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
////        let abc:ExplainWorkingHoursPopUP = mainstoryb.instantiateViewController(withIdentifier: "ExplainWorkingHoursPopUP")as! ExplainWorkingHoursPopUP
////                    abc.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
////                    abc.modalPresentationStyle = .custom
////                    self.present(abc, animated: true, completion: nil) //GettoKnowtheSystemScreen
//        let abc:GettoKnowtheSystemScreen = mainstoryb.instantiateViewController(withIdentifier: "GettoKnowtheSystemScreen")as! GettoKnowtheSystemScreen
//                        //    abc.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//                            abc.modalPresentationStyle = .custom
//                            self.present(abc, animated: true, completion: nil) //GettoKnowtheSystemScreen
        ////
//        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
//        //        let abc:ExplainWorkingHoursPopUP = mainstoryb.instantiateViewController(withIdentifier: "ExplainWorkingHoursPopUP")as! ExplainWorkingHoursPopUP
//        //                    abc.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//        //                    abc.modalPresentationStyle = .custom
//        //                    self.present(abc, animated: true, completion: nil) //GettoKnowtheSystemScreen
//        let abc:GettoKnowtheSystemScreen = mainstoryb.instantiateViewController(withIdentifier: "GettoKnowtheSystemScreen")as! GettoKnowtheSystemScreen
//        //    abc.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//        abc.modalPresentationStyle = .custom
//        self.present(abc, animated: true, completion: nil) //GettoKnowtheSystemScreen
     
        self.getnews()
        self.lblAdvertising.restartLabel()
        //SEND APP VERSION TO SERVER
        if USERDEF.integer(forKey: "UPDATEVERSIONFORUSER") == 1 {
            UpdateiOSVersionByUserId()
            USERDEF.set(0, forKey: "UPDATEVERSIONFORUSER")
            USERDEF.synchronize()
        }
        if  USERDEF.value (forKey: "wasseenTextTOShow") != nil {
            if  USERDEF.value (forKey: "wasseenTextTOShow") as! Int  == 0 {
                if USERDEF.value(forKey: "TextTOShow") != nil {
                    if let _ = USERDEF.value(forKey: "TextTOShow") as? String {

                    let mytexttoshow = USERDEF.value(forKey: "TextTOShow") as! String
                        if mytexttoshow != "ABCDEFGH" {
                    Alert.sharedInstance.showAlert(mytexttoshow, vc: self)
                        }
                }
                }
                 USERDEF.set("ABCDEFGH", forKey: "TextTOShow")
                USERDEF.set(1, forKey: "wasseenTextTOShow")
            USERDEF.synchronize()
        }
        }
        let tapOpenPlusMenuNewCustomer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewCustomer))
        tapOpenPlusMenuNewCustomer.delegate = self
        CentralButton.addGestureRecognizer(tapOpenPlusMenuNewCustomer)

        // openprov()
        // gameon()
//                var clientStoryBoard2:UIStoryboard?
//        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
//        let viewRegulation: JGeneralDetails = mainstoryb.instantiateViewController(withIdentifier: "JGeneralDetails")as! JGeneralDetails
//        viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//                viewRegulation.modalPresentationStyle = .custom
//                self.present(viewRegulation, animated: true, completion: nil)
        //SetupWorkingHours
//                let mainstoryb = UIStoryboard(name: "NewDevel", bundle: nil)
//                let viewRegulation: SetupWorkingHours = mainstoryb.instantiateViewController(withIdentifier: "SetupWorkingHours")as! SetupWorkingHours
//                viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//                        viewRegulation.modalPresentationStyle = .custom
//                        self.present(viewRegulation, animated: true, completion: nil)
        //SetupServices
//                        let mainstoryb = UIStoryboard(name: "newlistservices", bundle: nil)
//                        let viewRegulation: SetupServices = mainstoryb.instantiateViewController(withIdentifier: "SetupServices")as! SetupServices
//                        viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//                                viewRegulation.modalPresentationStyle = .custom
//                                self.present(viewRegulation, animated: true, completion: nil)
//        let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
//                                let viewRegulation: ADD_EMPLOYE_FIRST_SCREEN = mainstoryb.instantiateViewController(withIdentifier: "ADD_EMPLOYE_FIRST_SCREEN")as! ADD_EMPLOYE_FIRST_SCREEN
//                                viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//                                viewRegulation.modalPresentationStyle = .custom
//                                self.present(viewRegulation, animated: true, completion: nil)
        GetServerTime()
    }
    @objc func openPlusMenuNewCustomer(){
    if let _ =  Bundle.main.loadNibNamed("PlusMenu3CirclesNewCustomer", owner: self, options: nil)?.first as? PlusMenuNewCustomer
    {
    let openpopmenu = Bundle.main.loadNibNamed("PlusMenu3CirclesNewCustomer", owner: self, options: nil)?.first as! PlusMenuNewCustomer
    openpopmenu.frame = self.view.frame
    self.view.addSubview(openpopmenu)
    self.view.bringSubviewToFront(openpopmenu)
    }

    }
    func GetServerTime() {
         var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {

//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            tblSearch.isHidden = true
        }
        else
        {
            api.sharedInstance.GetServerTime(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                  print("GetServerTime \(RESPONSEOBJECT)")
                    if  let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject> {
                        let MYDICTIONARY:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as! Dictionary<String,AnyObject>
                    if let _ = MYDICTIONARY["ErrorCode"] as? Int {

                        if  MYDICTIONARY["ErrorCode"] as! Int == 1
                        {
                            if let _ = RESPONSEOBJECT["Result"] as? String {
                                let mystr =   RESPONSEOBJECT["Result"] as! String

                                let myd = Global.sharedInstance.getDateFromString(mystr)
                                //add 2 h because +0200s
                                let onedate = Foundation.Calendar.current.date(byAdding: .hour, value: 2, to: myd)
                                print("onedate \(onedate) decoded date \(myd) AND DATE \(Date())")
                            }
                        }
                    }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - TableView
    //==========TableView===============
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == suppliersTable) {
            // Suppliers table rows
            if (self.providersArray.count == 0) {
                suppliersTable.isHidden = true
                loadingSuppliersActivity.stopAnimating()
                return 0
            } else {
                suppliersTable.isHidden = false
                return self.providersArray.count
            }
        } else {
            if (filterSubArr.count == 0) {
                tblSearch.isHidden = true
            }
            
            return filterSubArr.count
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == suppliersTable) {
            //   if isSearching == false{
            // Suppliers table rows
            let cell0: ApprovedBySuppliersTableViewCell = self.suppliersTable.dequeueReusableCell(withIdentifier: "ApprovedBySuppliers") as! ApprovedBySuppliersTableViewCell
            print("indexPath.row \(indexPath.row)")
            if self.providersArray.count > 0 {
             
                cell0.setDisplayData(self.providersArray[indexPath.row],allsearch: self.dicResultsOK, elindexRow:indexPath.row)
                cell0.PARENTDELEGATE = self
               
            }
            return cell0
        } else {
            // Search table rows
            let cell = tableView.dequeueReusableCell(withIdentifier: "Search")as! SearchTableViewCell
            cell.setDisplayData(filterSubArr[indexPath.row] as! String)
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == suppliersTable) {
            // Suppliers table rows
            if (DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS) {
                let bounds = UIScreen.main.bounds
                let widthscr = bounds.size.width
                var heightscr:CGFloat = 0
                heightscr = 60 + (widthscr * 0.26)
                
                return heightscr
            } else {
                let bounds = UIScreen.main.bounds
                let widthscr = bounds.size.width
                var heightscr:CGFloat = 0
                heightscr = 60 + (widthscr * 0.26)
                
                return heightscr
            }
        } else {
            // Search table rows
            return self.view.frame.height * 0.09687
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        txtSearch.text = filterSubArr[indexPath.row] as? String
        tblSearch.isHidden = true
        btnSearch(self.btnSearch)
    }
    
    //MARK: - Searching
    //==========Searching===========
    
    func textFieldDidChange(_ textField: UITextField) {
        
        searching(txtSearch.text!)
    }
    
    func searching(_ searchText: String) {
        //  let s:CGFloat = view.frame.size.height - tblSearch.frame.origin.x
        searchActive = true
        isSearching = true
        if searchText == ""{
            filtered =  []
        }else{
            filtered = Global.sharedInstance.categoriesArray.filter({(city) ->  Bool in
                var tmp: NSString = ""
                if tmp.description.characters.count >= searchText.characters.count{
                    tmp = tmp.substring(to: searchText.characters.count) as NSString
                }
                
                let range = tmp.range(of: searchText,options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            
            
        }
        if(filtered.count == 0){
            self.tblSearch.isHidden = true
        }
        else{
            self.tblSearch.isHidden = false
        }
        
        uploadTable()
    }
    
    func uploadTable(){
        self.tblSearch.reloadData()
    }
    
    
    @objc func imageTapped(){
        Global.sharedInstance.currentOpenedMenu = self
        let viewCon:MenuPlusViewController = storyboard?.instantiateViewController(withIdentifier: "MenuPlusViewController") as! MenuPlusViewController
        viewCon.delegate = self
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }
    
    
    //MARK: - keyboard
    
    
    
    
    //for autoCopmlete:
    /**
     func searchAutocompleteEntriesWithSubstring
     - parameter bar: substring from textfield
     */
    func searchAutocompleteEntriesWithSubstring(_ substring: String)
    {
        if substring.characters.count > 0
        {
            if txtSearch.text != ""
            {
                var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicSearch["nvKeyWord"] = substring as AnyObject
                
                
                if Reachability.isConnectedToNetwork() == false
                {
                    
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    tblSearch.isHidden = true
                }
                else
                {
                    api.sharedInstance.SearchWordCompletion(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if  let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject> {
                                let MYDICTIONARY:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as! Dictionary<String,AnyObject>
                            if let _ = MYDICTIONARY["ErrorCode"] as? Int {
                                
                                if MYDICTIONARY["ErrorCode"] as! Int == 1
                                {
                                    self.filterSubArr = NSArray()
                                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                                        self.filterSubArr = RESPONSEOBJECT["Result"] as! NSArray //fix 2.3
                                    }
                                    self.tblSearch.isHidden = false
                                    self.tblSearch.reloadData()
                                }
                            }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                    })
                }
            }
        }
        
        self.tblSearch.reloadData()
        
    }
    
    ////for the autoComplete
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {        //בשביל ה-autoComplete
        tblSearch.isHidden = false
        
        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        
        startString += string
        if Reachability.isConnectedToNetwork() == false && string != ""//כדי שהטקסט יכיל גם את האות האחרונה שהקליד
        {
            textField.text = startString
        }
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if substring == ""
        {
            tblSearch.isHidden = true
        }
        else
        {
            if startString.characters.count > 120
            {
                Alert.sharedInstance.showAlert("ENTER_ONLY120_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
                return false
            }
            tblSearch.isHidden = false
            
            searchAutocompleteEntriesWithSubstring(substring)
        }
        return true
    }
    
    
    func btnSearchAction(_ sender: UIButton) {
        Global.sharedInstance.isProvider = false
        let viewCon:giveMyServicesViewController = clientStoryBoard!.instantiateViewController(withIdentifier: "giveMyServicesViewController") as! giveMyServicesViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: false, completion: nil)
    }
    
    
    func openSearchResults() {
        
                    let frontviewcontroller = storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                    let vc = clientStoryBoard?.instantiateViewController(withIdentifier: "SearchResults") as! SearchResultsViewController
                    frontviewcontroller?.pushViewController(vc, animated: false)
                    let rearViewController = storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.frontViewController = frontviewcontroller
                    mainRevealController.rearViewController = rearViewController
                    let window :UIWindow = UIApplication.shared.keyWindow!
                    window.rootViewController = mainRevealController



    }
    
    
    func openFromMenu(_ con:UIViewController) {
        self.present(con, animated: true, completion: nil)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: tblSearch)) {
            
            return false
        }
        return true
    }
    
    
    // Get providers function
    func getProvidersList() {
        self.providersArray  = []
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.currentUser.iUserId != 0  {
            dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
            dic["nvlat"] = Global.sharedInstance.currentLat as AnyObject
            dic["nvlong"] = Global.sharedInstance.currentLong as AnyObject
            dic["iNumberOfEntries"] = 3 as AnyObject
            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            } else {
                api.sharedInstance.GetProviderListForCustomerAuthorizedFromSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if  let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject> {
                            let MYDICTIONARY:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as! Dictionary<String,AnyObject>
                        if let _ = MYDICTIONARY["ErrorCode"] as? Int {
                            
                            
                            if MYDICTIONARY["ErrorCode"] as! Int == -3 {
                                self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            } else if MYDICTIONARY["ErrorCode"] as! Int == 1 {
                                self.dicResultsOK = Array<Dictionary<String,AnyObject>>()
                                let searchObj:SearchResulstsObj = SearchResulstsObj()
                                var dicResultsfull:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                    let mydicarray = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                    for element in mydicarray {
                                        if let _ = element["iIsApprovedSupplier"] as? Int {
                                            let isaproved = element["iIsApprovedSupplier"] as! Int
                                            if isaproved != 2 {
                                                dicResultsfull.append(element)
                                            }
                                        }
                                    }
                                    
                               // self.dicResultsOK = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                    self.dicResultsOK = dicResultsfull
//                                    print("asdasdadadassa: \(String(describing: self.dicResultsOK[0]["iDistance"]))")
                                    
                                }
                                
                                self.providersArray = searchObj.objProvidersToArray(self.dicResultsOK)
                                for i in self.providersArray {
                                    print("ce are \(i.iDistance)")
                                }
                                print("providersArray \(self.providersArray.count)")
                                self.suppliersTable.reloadData()
                            }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                })
                
            }
        } else if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil {
            print("need currentUserId \(Global.sharedInstance.defaults.value(forKey: "currentUserId"))")
            var iUserId = 0
            var  DICTGET:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            DICTGET = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if DICTGET["currentUserId"] != nil {
                iUserId = DICTGET["currentUserId"] as! Int
            }
            if iUserId > 0 {
                dic["iUserId"] = iUserId as AnyObject
                dic["iNumberOfEntries"] = 3 as AnyObject
                dic["nvlat"] = Global.sharedInstance.currentLat as AnyObject
                dic["nvlong"] = Global.sharedInstance.currentLong as AnyObject
                if Reachability.isConnectedToNetwork() == false {
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                } else {
                    api.sharedInstance.GetProviderListForCustomerAuthorizedFromSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if  let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject> {
                                let MYDICTIONARY:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as! Dictionary<String,AnyObject>
                            if let _ = MYDICTIONARY["ErrorCode"] as? Int {
                                
                                
                                if MYDICTIONARY["ErrorCode"] as! Int == -3 {
                                    self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                } else if MYDICTIONARY["ErrorCode"] as! Int == 1 {
                                    self.dicResultsOK = Array<Dictionary<String,AnyObject>>()
                                    let searchObj:SearchResulstsObj = SearchResulstsObj()
                                    if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                        self.dicResultsOK = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                    }
                                    self.providersArray = searchObj.objProvidersToArray(self.dicResultsOK)
                                    print("providersArray \(self.providersArray.count)")
                                    self.suppliersTable.reloadData()
                                }
                            }
                        }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                    })
                }
            }
        }
    }
    
    
    
    // Delete provider from table function
    func deleteProfiderFromList(_ indexPath:Int){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iCustomerUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        dic["iProviderId"] = Global.sharedInstance.dicResults[indexPath]["iProviderId"]
        
        if Reachability.isConnectedToNetwork() == false {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        } else {
            api.sharedInstance.RemoveProviderFromCustomer(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if  let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject> {
                        let MYDICTIONARY:Dictionary<String,AnyObject> = RESPONSEOBJECT["Error"] as! Dictionary<String,AnyObject>
                    if let _ = MYDICTIONARY["ErrorCode"] as? Int {
                        
                        
                        if MYDICTIONARY["ErrorCode"] as! Int == -1 {
                            self.showAlertDelegateX("לא ניתן למחוק ספק זה")
                        } else if MYDICTIONARY["ErrorCode"] as! Int == 1 {
                            Global.sharedInstance.dicResults.remove(at: indexPath)
                            Global.sharedInstance.isDeletedGiveMyService = true
                            
                            self.suppliersTable.reloadData()
                        }
                    }
                }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
            })
        }
    }
    //playing with sort model
    @objc func openVideoProviderScreen() {
        //AddSupplierLead
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
         //   Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))

        }
        else
        {
            var y:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
                dic["iUserId"] = y as AnyObject
            }
            api.sharedInstance.AddSupplierLead(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                  //      Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                      print(RESPONSEOBJECT)
//                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
////                        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
////                        let abc:IntroVideoPlayerScreen = mainstoryb.instantiateViewController(withIdentifier: "IntroVideoPlayerScreen")as! IntroVideoPlayerScreen
////                        //    abc.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
////                        abc.modalPresentationStyle = .custom
////                        abc.whichvideo = 0
////                        self.present(abc, animated: true, completion: nil)
//                        }
//                        }
                    }
                    }

            },failure: {(AFHTTPRequestOperation, Error) -> Void in


            })
        }
        self.playideo()

    }
    func playideo() {
        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
        let abc:IntroVideoPlayerScreen = mainstoryb.instantiateViewController(withIdentifier: "IntroVideoPlayerScreen")as! IntroVideoPlayerScreen
        //    abc.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        abc.modalPresentationStyle = .custom
        abc.whichvideo = 0
        self.present(abc, animated: true, completion: nil)
    }

    @objc func openVideoCustomerScreen() {
        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
        let abc:IntroVideoPlayerScreen = mainstoryb.instantiateViewController(withIdentifier: "IntroVideoPlayerScreen")as! IntroVideoPlayerScreen
        //    abc.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        abc.modalPresentationStyle = .custom
        abc.whichvideo = 1
        self.present(abc, animated: true, completion: nil)
    }
    func showindicator() {
        self.generic.showNativeActivityIndicator(self)
    }
    func hideindicator() {
        self.generic.hideNativeActivityIndicator(self)
    }

    /*
     
     Cerlocal(whichDomain: 0)
     formatStringWithoutCommas(mystr: "asdas, asasas, asdasd")
     trimStrings(mystr: "asdas, asda adsasd,,")
     primaDatainApp()
     
     func Cerlocal (whichDomain:Int) -> NSArray
     {
     let rezultat : NSMutableArray = NSMutableArray()
     if whichDomain == 0
     {
     if let _ = Bundle.main.path (forResource: "bthere", ofType: "cer")
     {
     let pathToCert  = Bundle.main.path (forResource: "bthere", ofType: "cer")
     rezultat.add(pathToCert!)
     }
     print("rezultatul \(rezultat)")
     
     }
     
     else if whichDomain == 1
     {
     if let _ = Bundle.main.path(forResource: "bthere", ofType: "cer")
     {
     let pathToCert = Bundle.main.path(forResource: "bthere", ofType: "cer")
     rezultat.add(pathToCert!)
     }
     }
     
     else if whichDomain == 2
     {
     let pathToCert = Bundle.main.path(forResource: "bthere", ofType: "cer")
     rezultat.add(pathToCert!)
     }
     
     else if whichDomain == 3
     {
     let pathToCert = Bundle.main.path(forResource: "bthere", ofType: "cer")
     rezultat.add(pathToCert!)
     }
     
     return rezultat
     }
     
     
     func formatStringWithoutCommas (mystr:String)-> String
     {
     var newStr:String = ""
     if mystr.count > 2
     {
     let secondChar: String = mystr.substring(to: 2)
     if secondChar == ", "
     {
     let startIndex = mystr.index(mystr.startIndex, offsetBy: 2)
     let endIndex = mystr.index(mystr.endIndex, offsetBy: -2)
     newStr = mystr.substring(with: startIndex..<endIndex)
     }
     else
     {
     newStr = mystr
     }
     
     }
     else
     {
     newStr = mystr
     }
     print("stringul fara , \(newStr)")
     return newStr
     }
     
     func trimStrings (mystr:String) ->String
     {
     let result = String(mystr.characters.filter { "abcdefghijklmnopqrstuvwxz.".characters.contains($0) })
     print("result \(result)")
     return result
     }
     
     
     
     */
}
extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}
func between<T>(_ x: T, _ ys: [T]) -> [[T]] {
    guard let (head, tail) = ys.decompose() else { return [[x]] }
    return [[x] + ys] + between(x, tail).map { [head] + $0 }
}



func permutations<T>(_ xs: [T]) -> [[T]] {
    guard let (head, tail) = xs.decompose() else { return [[]] }
    return permutations(tail).flatMap { between(head, $0) }
}
open class Reachabilitya {
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
   
}
extension GAIDictionaryBuilder
{
    func buildSwiftCompatible() -> [NSObject:AnyObject]
    {
        return self.build() as [NSObject:AnyObject]
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
