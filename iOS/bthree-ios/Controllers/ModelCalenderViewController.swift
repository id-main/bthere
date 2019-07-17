//
//  ModelCalenderViewController.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/13/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol openSearchResultsDelegate
{
    func openSearchResults()
}



class ModelCalenderViewController: NavigationModelViewController,
UITextFieldDelegate,openSearchResultsDelegate,openFromMenuDelegate,UIGestureRecognizerDelegate,clickToDayDelegate,clickToDayInWeekDelegate,openDetailsOrderDelegate{
    @IBOutlet weak var butonwidth: NSLayoutConstraint!
    @IBOutlet weak var CentralButton:UIView!
    @IBOutlet weak var  CentralButtonImg:UIImageView!
    var isfromSPECIALiCustomerUserId:Int = 0
    var WHICHPRINT:Int = 0
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var delegateSetDate:setDateDelegate!=nil
    var attrs = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont.systemFont(ofSize: 18),
        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black,
        convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1] as [String : Any]
    var attrsDeselect = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont.systemFont(ofSize: 18)]
    //the category design if click on month clik design open MonthDesigned
    // if click on Record button open design RecordDesign
    // if click on Week button open design WeekDesign
    // if click on Day button open design DayDesign
    var view1 : MonthDesignedViewController!
    var view2 : RecordDesignedViewController!
    var view3 : WeekDesignCalendarViewController!
    var view4 : DayDesignCalendarViewController!
    var generic:Generic = Generic()
    var attributedString = NSMutableAttributedString(string:"")
    var subView = UIView()
    var selectedView:UIViewController = UIViewController()
    var isAuto = false
    var con:SearchTableViewController?
    var storyboard1:UIStoryboard?
    var filterSubArr:NSArray =  NSArray()
    var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()//עבור השליחה לשרת
    //MARK: - Outlet
    
    @IBOutlet weak var openPlusMenuEnglish: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet var newsDealsLabel: UILabel!
    @IBOutlet var monthlyBtn: UIButton!
    //open month design
    @IBAction func monthlyBtn(_ sender: UIButton) {
        if sender.tag == 0 || selectedView == view1
        {
            Calendar.sharedInstance.carrentDate = Date()
            SelectDesighnedBtn(sender)
            sender.tag = 1
            SelectSingleForMonthly()
            view1.view.isHidden = false
            view3.view.isHidden = true
            view4.view.isHidden = true
            view2.view.isHidden = true
            self.view.bringSubviewToFront(view1.view)
            self.view.bringSubviewToFront((con?.view!)!)
            selectedView = view1
            DispatchQueue.main.async(execute: { () -> Void in
                self.view1.bestmode()
                self.view1.view.setNeedsDisplay()
            })
        }
        else
        {
            sender.tag = 0
            sender.backgroundColor = Colors.sharedInstance.color7
            DeSelectDesighnedBtn(sender)
        }
    }
    @IBOutlet var weekBtn: UIButton!
    //open week design
    @IBAction func weekBtn(_ sender: UIButton) {
        if sender.tag == 0 || selectedView == view3
        {
            SelectDesighnedBtn(sender)
            sender.tag = 1
            SelectSingleForWeek()
            if Global.sharedInstance.isSyncWithGoogelCalendar == true
            {
                view3.btnSync.isCecked = true
            }
            else
            {
                view3.btnSync.isCecked = false
            }
            
            let currentDate:Date = Global.sharedInstance.currDateSelected as Date
            let dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
            for i in 0 ..< 7 {
                let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i + 1)
                Global.sharedInstance.getBthereEvents(curDate, dayOfWeek: i)
            }
            if selectedView == view1//month
            {
                Global.sharedInstance.currDateSelected = Date()
                view3.initDateOfWeek(Date())
            }
            else// day
            {
                view3.initDateOfWeek(Global.sharedInstance.currDateSelected)
            }
            view1.view.isHidden = true
            view2.view.isHidden = true
            view4.view.isHidden = true
            view3.view.isHidden = false
            self.view.bringSubviewToFront(view3.view)
            self.view.bringSubviewToFront((con?.view!)!)
            selectedView = view3
            DispatchQueue.main.async(execute: { () -> Void in
                self.view3.bestmode()
                self.view3.view.setNeedsDisplay()
            })
        }
        else
        {
            sender.tag = 0
            DeSelectDesighnedBtn(sender)
            sender.backgroundColor = Colors.sharedInstance.color8
        }
    }
    
    @IBOutlet var dayBtn: UIButton!
    //open day design
    @IBAction func dayBtn(_ sender: UIButton) {
        if sender.tag == 0 || selectedView == view4
        {
            SelectDesighnedBtn(sender)
            sender.tag = 1
            SelectSingleForDay()
            if Global.sharedInstance.isSyncWithGoogelCalendar == true{
                view4.btnSuny.isCecked = true
            }
            else{
                view4.btnSuny.isCecked = false
            }
            Global.sharedInstance.dateDayClick = Date()
            Global.sharedInstance.currDateSelected = Date()
            view4.initDate(Global.sharedInstance.currDateSelected)
            view1.view.isHidden = true
            view2.view.isHidden = true
            view3.view.isHidden = true
            view4.view.isHidden = false
            self.view.bringSubviewToFront(view4.view)
            self.view.bringSubviewToFront((con?.view!)!)
            selectedView = view4
            DispatchQueue.main.async(execute: { () -> Void in
                self.view4.bestmode()
                self.view4.view.setNeedsDisplay()
            })
            
            self.delegateSetDate = Global.sharedInstance.datDesigncalendar
            delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick)
            
        }
        else
        {
            sender.tag = 0
            DeSelectDesighnedBtn(sender)
            sender.backgroundColor = Colors.sharedInstance.color9
        }
    }
    @IBOutlet var recordBtn: UIButton!
    //open record( list) design
    @IBAction func recordBtn(_ sender: UIButton) {
        if sender.tag == 0 || selectedView == view2{
            SelectDesighnedBtn(sender)
            sender.tag = 1
            SelectSingleForRecord()
    
            if Global.sharedInstance.isSyncWithGoogelCalendar == true{
                view2.btnSync.isCecked = true
            }
            else{
                view2.btnSync.isCecked = false
            }
            view1.view.isHidden = true
            view3.view.isHidden = true
            view4.view.isHidden = true
            view2.view.isHidden = false
            self.view.bringSubviewToFront(view2.view)
            self.view.bringSubviewToFront((con?.view!)!)
            selectedView = view2
            DispatchQueue.main.async(execute: { () -> Void in
                self.view2.bestmode()
                self.view2.view.setNeedsDisplay()
            })
           
        }
        else{
            sender.backgroundColor = Colors.sharedInstance.color6
            DeSelectDesighnedBtn(sender)
            sender.tag = 0
        }
    }
    //OLDCODE
    @IBAction func btnSearchx(_ sender: AnyObject) {
        generic.showNativeActivityIndicator(self)
        Global.sharedInstance.viewConNoInternet = self
        dismissKeyboard()
        
        Global.sharedInstance.searchDomain = txtSearch.text!
        
        if txtSearch.text != ""
        {
            
            
            dicSearch["nvKeyWord"] = txtSearch.text as AnyObject
            dicSearch["nvlong"] = Global.sharedInstance.currentLong as AnyObject
            dicSearch["nvlat"] = Global.sharedInstance.currentLat as AnyObject
            dicSearch["nvCity"] = nil
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                //search object by user text pressed
                api.sharedInstance.SearchByKeyWord(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                Alert.sharedInstance.showAlert("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                    Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                }
                              
                                Global.sharedInstance.dicSearchProviders = self.dicSearch
                                Global.sharedInstance.whichSearchTag = 1
                                self.generic.hideNativeActivityIndicator(self)
                                self.dismiss(animated: false, completion: nil)
                                self.openSearchResults()
                            }
                        }
                    }
                    self.generic.hideNativeActivityIndicator(self)
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                })
            }
        }
        else
        {
            generic.hideNativeActivityIndicator(self)
            Alert.sharedInstance.showAlert("NOT_DATA_TO_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        }
    }

    //NEWDEVELOP
    @IBAction func btnSearch(_ sender: AnyObject) {
        Global.sharedInstance.viewConNoInternet = self
        dismissKeyboard()
        generic.showNativeActivityIndicator(self)
        Global.sharedInstance.searchDomain = txtSearch.text!
        if txtSearch.text == "" {
            generic.hideNativeActivityIndicator(self)
            Alert.sharedInstance.showAlert("NOT_DATA_TO_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        } else  if txtSearch.text != "" && (txtSearch.text?.count)! < 2 {
            generic.hideNativeActivityIndicator(self)
            Alert.sharedInstance.showAlert("SEARCHLESS3LETTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        } else
            if txtSearch.text != "" && (txtSearch.text?.count)! >= 2
            {
            dicSearch["nvKeywords"] = txtSearch.text as AnyObject
            dicSearch["nvLong"] = Global.sharedInstance.currentLong as AnyObject
            dicSearch["nvLat"] = Global.sharedInstance.currentLat as AnyObject
            dicSearch["nvCity"] = nil
            var y:Int = 0
            if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
            }
            Global.sharedInstance.dicSearch["iUserId"]  = y as AnyObject
            dicSearch["iUserId"] = y as AnyObject
            if Reachability.isConnectedToNetwork() == false
            {
               generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                //search object by user text pressed
                //mod SearchByKeyWord with SearchByKeyWords on 08/05/2018
                api.sharedInstance.SearchByKeyWords(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        self.generic.hideNativeActivityIndicator(self)
                        Alert.sharedInstance.showAlert("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                        Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                        }
                        
                        Global.sharedInstance.dicSearchProviders = self.dicSearch
                        Global.sharedInstance.whichSearchTag = 1
                        self.generic.hideNativeActivityIndicator(self)
                        self.dismiss(animated: false, completion: nil)
                        self.openSearchResults()
                    }
                        }
                    }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                        self.generic.hideNativeActivityIndicator(self)
                })
            }
        }
      
    }

    @IBAction func btnAdvantageSearch(_ sender: AnyObject) {
        
        let viewCon:AdvantageSearchViewController = self.storyboard!.instantiateViewController(withIdentifier: "AdvantageSearchViewController") as! AdvantageSearchViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        viewCon.delegateSearch = self
        
        self.present(viewCon, animated: true, completion: nil)
    }
    
        @IBOutlet var imgMenu: UIImageView!
    

    
  
    //MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Global.sharedInstance.isSyncWithGoogleCalendarAppointment = Global.sharedInstance.currentUser.bIsGoogleCalendarSync
        GoogleAnalyticsSendEvent(x:7)
        let USERDEF = Global.sharedInstance.defaults
        if USERDEF.object(forKey: "isfromSPECIALiCustomerUserId") == nil {
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
        } else {
            if let _:Int = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as? Int {
                let myint = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as! Int
                self.isfromSPECIALiCustomerUserId = myint
            }
        }
        let mys = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")
        print("FINDisfromSPECIALiCustomerUserId \(mys)")
        print("ModelCalenderViewController \(isfromSPECIALiCustomerUserId)")
        self.getnews()
    }
    override func viewDidLayoutSubviews() {

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


    override func viewDidLoad() {

        print("navigationController stack: \(self.navigationController?.viewControllers)")
        super.viewDidLoad()
        let tapOpenPlusMenuNewCustomer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewCustomer))
        tapOpenPlusMenuNewCustomer.delegate = self
        CentralButton.addGestureRecognizer(tapOpenPlusMenuNewCustomer)
        CentralButtonImg.image = UIImage(named: "Plus menu icon - Customer")
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            butonwidth.constant = 80
        } else {
            butonwidth.constant = 70
        }
        Calendar.sharedInstance.carrentDate = Date()
       
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ModelCalenderViewController.imageTapped))
//
//        tapGestureRecognizer.delegate = self
//
//
//        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
//        {
//            imgMenu.image = UIImage(named: "plushebrewcustomer.png")
//            imgMenu.isHidden = false
//            imgMenu.isUserInteractionEnabled = true
//            openPlusMenuEnglish.isHidden = true
//            openPlusMenuEnglish.isUserInteractionEnabled = false
//            imgMenu.addGestureRecognizer(tapGestureRecognizer)
//        }
//        else
//        {
//            openPlusMenuEnglish.image = UIImage(named: "plushebrewcustomer.png")
//            openPlusMenuEnglish.isHidden = false
//            openPlusMenuEnglish.isUserInteractionEnabled = true
//            imgMenu.isHidden = true
//            imgMenu.isUserInteractionEnabled = true
//            openPlusMenuEnglish.addGestureRecognizer(tapGestureRecognizer)
//        }

        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            txtSearch.attributedPlaceholder = NSAttributedString(string: "SEARCH_SERVICE_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.darkGray,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 13)!]))
        }
        else
        {
            txtSearch.attributedPlaceholder = NSAttributedString(string: "SEARCH_SERVICE_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.darkGray,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        }
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            txtSearch.textAlignment = .right
        } else {
            txtSearch.textAlignment = .left
        }
        
        
        recordBtn.setTitle("DESIGN_LIST".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        monthlyBtn.setTitle("DESIGN_MONTH".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        weekBtn.setTitle("DESIGN_WEEK".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        dayBtn.setTitle("DESIGN_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        
        if Global.sharedInstance.isCancelAppointmentClick == false//אם הגיעו מפרטי הזמנה כדי שאם משנה את הסנכרון כפי רצונו, הסנכרון יתקיים
        {
            Global.sharedInstance.isSyncWithGoogelCalendar = Global.sharedInstance.currentUser.bIsGoogleCalendarSync
        }
        
        
        storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        
        con = self.storyboard!.instantiateViewController(withIdentifier: "SearchTableViewController") as? SearchTableViewController
        
        Global.sharedInstance.modelCalender = self
        Global.sharedInstance.model = 1
        Global.sharedInstance.calendarClient = self
        Global.sharedInstance.whichReveal = false
        txtSearch.delegate = self
        
        subView.frame = CGRect(x: 0, y: view.frame.origin.y + self.navigationController!.navigationBar.frame.size.height , width: view.frame.width, height: view.frame.height * 0.2)
        self.navigationController?.isNavigationBarHidden = false
        view1 = self.storyboard!.instantiateViewController(withIdentifier: "MonthDesignedViewController") as! MonthDesignedViewController
        let needframe:CGRect = CGRect(x: 0, y: 165 , width: view.frame.width, height: view.frame.height - subView.frame.height - self.navigationController!.navigationBar.frame.size.height - 90)
        view1.view.frame = needframe
        view2 = self.storyboard!.instantiateViewController(withIdentifier: "RecordDesignedViewController") as! RecordDesignedViewController
        view2.view.frame = needframe
        view3 = self.storyboard!.instantiateViewController(withIdentifier: "WeekDesignCalendar") as! WeekDesignCalendarViewController
        view3.view.frame = needframe
        view3.delegate = self
        view4 = self.storyboard!.instantiateViewController(withIdentifier: "DayDesignCalendarViewController") as! DayDesignCalendarViewController
        view4.view.frame = needframe
        self.view.addSubview(self.con!.view)
        view1.view.isHidden = true
        view2.view.isHidden = true
        view3.view.isHidden = true
        view4.view.isHidden = true
        self.addChild(view4)
        self.addChild(view3)
        self.addChild(view2)
        self.addChild(view1)
        
        self.view.addSubview(view4.view)
        self.view.addSubview(view3.view)
        self.view.addSubview(view2.view)
        self.view.addSubview(view1.view)
//        selectedView = view1
//        SelectDesighnedBtn(monthlyBtn)
//        monthlyBtn(monthlyBtn)
   
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ModelCalenderViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        self.GetCustomerOrders()
 

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.view.addBackground()
        self.view.addSubview(self.con!.view)
    }
    
    //MARK: - AutoCopmlete
    
    func searchAutocompleteEntriesWithSubstring(_ substring: String)
    {
        if substring.characters.count > 0
        {
            if txtSearch.text != ""
            {
                var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicSearch["nvKeyWord"] = substring as AnyObject
                
                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                }
                else
                {
                    api.sharedInstance.SearchWordCompletion(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                          self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            self.filterSubArr = NSArray()
                            if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                            self.filterSubArr = RESPONSEOBJECT["Result"] as! NSArray
                            }
                            if self.filterSubArr.count != 0
                            {
                                self.con!.filterSubArr = self.filterSubArr
                                self.view.addSubview((self.con?.view)!)
                                self.view.bringSubviewToFront((self.con?.view)!)
                                self.con?.tableView.reloadData()
                                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                                {
                                    self.con!.view.frame = CGRect(x: 15, y: 124, width: self.view.frame.width - 30,  height: CGFloat(self.view.frame.size.height * 0.2))
                                }
                                else
                                {
                                    self.con!.view.frame = CGRect(x: 15, y: 124, width: self.view.frame.width - 30,  height: CGFloat(self.view.frame.size.height * 0.2))
                                }
                            }
                            else
                            {
                                self.con!.tableView.isHidden = true
                            }
                        }
                            }
                        }
                        
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
                             self.con?.tableView.reloadData()
//                            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                    })
                }
            }
        }
        else
        {
            self.filterSubArr = []
            self.con!.filterSubArr = self.filterSubArr
            self.con?.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - others function
    //open plus menu
    @objc func imageTapped(){
        
        Global.sharedInstance.currentOpenedMenu = self
        
        
        let viewCon:MenuPlusViewController = storyboard1!.instantiateViewController(withIdentifier: "MenuPlusViewController") as! MenuPlusViewController
        viewCon.delegate = self
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)

    }
    //MARK: - Design button function
    //design to click button
    func SelectDesighnedBtn(_ btn:UIButton){
        
        btn.backgroundColor = UIColor.clear
        
    }
    
    func underlineButton(_ button : UIButton, text: String) {
        attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:text, attributes:convertToOptionalNSAttributedStringKeyDictionary(attrs))
        attributedString.append(buttonTitleStr)
        button.setAttributedTitle(attributedString, for: UIControl.State())
    }
    
    func DeSelectDesighnedBtn(_ btn:UIButton){
        
        attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string: (btn.titleLabel?.text)!, attributes:convertToOptionalNSAttributedStringKeyDictionary(attrsDeselect))
        attributedString.append(buttonTitleStr)
        btn.setAttributedTitle(attributedString, for: UIControl.State())
        
    }
    
    
    
    func SelectSingleForRecord(){
        monthlyBtn.tag = 0
        monthlyBtn.backgroundColor = Colors.sharedInstance.color7
        DeSelectDesighnedBtn(monthlyBtn)
        weekBtn.tag = 0
        DeSelectDesighnedBtn(weekBtn)
        weekBtn.backgroundColor = Colors.sharedInstance.color8
        dayBtn.tag = 0
        dayBtn.backgroundColor = Colors.sharedInstance.color9
        DeSelectDesighnedBtn(dayBtn)
    }
    func SelectSingleForMonthly(){
        recordBtn.backgroundColor = Colors.sharedInstance.color6
        DeSelectDesighnedBtn(recordBtn)
        recordBtn.tag = 0
        weekBtn.tag = 0
        DeSelectDesighnedBtn(weekBtn)
        weekBtn.backgroundColor = Colors.sharedInstance.color8
        dayBtn.tag = 0
        dayBtn.backgroundColor = Colors.sharedInstance.color9
        DeSelectDesighnedBtn(dayBtn)
    }
    
    func SelectSingleForWeek(){
        monthlyBtn.tag = 0
        monthlyBtn.backgroundColor = Colors.sharedInstance.color7
        DeSelectDesighnedBtn(monthlyBtn)
        recordBtn.backgroundColor = Colors.sharedInstance.color6
        DeSelectDesighnedBtn(recordBtn)
        recordBtn.tag = 0
        dayBtn.tag = 0
        dayBtn.backgroundColor = Colors.sharedInstance.color9
        DeSelectDesighnedBtn(dayBtn)
    }
    
    func SelectSingleForDay(){
        monthlyBtn.tag = 0
        monthlyBtn.backgroundColor = Colors.sharedInstance.color7
        DeSelectDesighnedBtn(monthlyBtn)
        weekBtn.tag = 0
        DeSelectDesighnedBtn(weekBtn)
        weekBtn.backgroundColor = Colors.sharedInstance.color8
        recordBtn.backgroundColor = Colors.sharedInstance.color6
        DeSelectDesighnedBtn(recordBtn)
        recordBtn.tag = 0
    }
    

    
    //MARK: - searchResult
    //func that open searchResult controller
    func openSearchResults()
    {
        let frontviewcontroller = storyboard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SearchResults") as! SearchResultsViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        let rearViewController = storyboard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
  
    }
    
    
    func openFromMenu(_ con:UIViewController)
    {
        self.present(con, animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: (con?.view)!)) {
            
            return false
        }
        return true
    }
    //func enter to day
    func clickToDay(){//open the day design when click one day in the month design
        SelectDesighnedBtn(dayBtn)
        SelectSingleForDay()
        view4.initDate(Global.sharedInstance.currDateSelected)
        view1.view.isHidden = true
        view2.view.isHidden = true
        view3.view.isHidden = true
        view4.view.isHidden = false
        self.view.bringSubviewToFront(view4.view)
        self.view.bringSubviewToFront((con?.view!)!)
        selectedView = view4
        self.delegateSetDate = Global.sharedInstance.datDesigncalendar
        selectedView = view4
        delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick)
        DispatchQueue.main.async(execute: { () -> Void in
            self.view4.bestmode()
            self.view4.view.setNeedsDisplay()
        })

    }
    //func click To Day In Week
    
    func clickToDayInWeek()
    {
        SelectDesighnedBtn(dayBtn)
        SelectSingleForDay()
        view4.initDate(Global.sharedInstance.currDateSelected)
        view1.view.isHidden = true
        view2.view.isHidden = true
        view3.view.isHidden = true
        view4.view.isHidden = false
        self.view.bringSubviewToFront(view4.view)
        self.view.bringSubviewToFront((con?.view!)!)
        selectedView = view4
        self.delegateSetDate = Global.sharedInstance.datDesigncalendar
        delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick)
        DispatchQueue.main.async(execute: { () -> Void in
            self.view4.bestmode()
            self.view4.view.setNeedsDisplay()
        })
    }
    // get customer to orders
    func GetCustomerOrders()
    {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
       
        //mass MOD
        
        if self.isfromSPECIALiCustomerUserId != 0 {
            dic["iUserId"] = self.isfromSPECIALiCustomerUserId as AnyObject
        } else {
            dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        }
        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject
        
        if Reachability.isConnectedToNetwork() == false
        {
            
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            
            api.sharedInstance.GetCustomerOrdersNoLogo(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                //\\   print(RESPONSEOBJECT["Result"])
                    let ps:OrderDetailsObj = OrderDetailsObj()
                    
                    Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    
                    if Global.sharedInstance.isCancelAppointmentClick == true//לחצו על ביטול תור
                    {
                        Global.sharedInstance.isCancelAppointmentClick = false
                    }
                        if Global.sharedInstance.whichDesignOpenDetailsAppointment == 1//הגיעו מיום day
                        {
                            self.SelectDesighnedBtn(self.dayBtn)
                            self.dayBtn.tag = 1
                            self.SelectSingleForDay()
                            self.view4.initDate(Global.sharedInstance.currDateSelected)
                            self.view1.view.isHidden = true
                            self.view2.view.isHidden = true
                            self.view3.view.isHidden = true
                            self.view4.view.isHidden = false
                            self.selectedView = self.view4
                            self.view.bringSubviewToFront(self.view4.view)
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.view4.bestmode()
                                self.view4.view.setNeedsDisplay()
                            })

                        }
                        else if Global.sharedInstance.whichDesignOpenDetailsAppointment == 2//הגיעו משבוע  week
                        {
                            self.SelectDesighnedBtn(self.weekBtn)
                            self.weekBtn.tag = 1
                            self.SelectSingleForWeek()
                            self.view3.initDateOfWeek(Global.sharedInstance.currDateSelected)
                            self.selectedView = self.view3
                            self.view1.view.isHidden = true
                            self.view2.view.isHidden = true
                            self.view4.view.isHidden = true
                            self.view3.view.isHidden = false
                            self.view.bringSubviewToFront(self.view3.view)
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.view3.bestmode()
                                self.view3.view.setNeedsDisplay()
                            })
                        }
                        else if Global.sharedInstance.whichDesignOpenDetailsAppointment == 3 //list
                        {
                            self.SelectDesighnedBtn(self.recordBtn)
                            self.selectedView = self.view2
                            self.SelectSingleForRecord()
                            self.view1.view.isHidden = true
                            self.view3.view.isHidden = true
                            self.view4.view.isHidden = true
                            self.view2.view.isHidden = false
                            self.view.bringSubviewToFront(self.view2.view)
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.view2.bestmode()
                                self.view2.view.setNeedsDisplay()
                            })

                        } else {
             
                        switch (Global.sharedInstance.currentUser.iCalendarViewType)
                        {
                        case 3: //list to do
                            self.SelectDesighnedBtn(self.recordBtn)
                            self.selectedView = self.view2
                            self.SelectSingleForRecord()
                            self.view1.view.isHidden = true
                            self.view3.view.isHidden = true
                            self.view4.view.isHidden = true
                            self.view2.view.isHidden = false
                            self.view.bringSubviewToFront(self.view2.view)
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.view2.bestmode()
                                self.view2.view.setNeedsDisplay()
                            })
                            break
                        case 2: //month
                            self.selectedView = self.view1
                            self.SelectDesighnedBtn(self.monthlyBtn)
                            self.view1.view.isHidden = false
                            self.view3.view.isHidden = true
                            self.view4.view.isHidden = true
                            self.view2.view.isHidden = true
                            self.view.bringSubviewToFront(self.view1.view)
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.view1.bestmode()
                                self.view1.view.setNeedsDisplay()
                            })

                            break
                            //hide week view
//                        case 1: //week
//                            let currentDate:Date = Global.sharedInstance.currDateSelected
//                            let dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!
//                            for i in 0 ..< 7 {
//                                let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i + 1)
//                                Global.sharedInstance.getBthereEvents(curDate, dayOfWeek: i)
//                            }
//                            self.SelectDesighnedBtn(self.weekBtn)
//                            self.weekBtn.tag = 1
//                            self.SelectSingleForWeek()
//                            self.view3.initDateOfWeek(Global.sharedInstance.currDateSelected)
//                            self.selectedView = self.view3
//                            self.view1.view.isHidden = true
//                            self.view2.view.isHidden = true
//                            self.view4.view.isHidden = true
//                            self.view3.view.isHidden = false
//                            self.view.bringSubview(toFront: self.view3.view)
//                            DispatchQueue.main.async(execute: { () -> Void in
//                                self.view3.bestmode()
//                                self.view3.view.setNeedsDisplay()
//                            })
//                            break
                        case 1: //day again
                            self.SelectDesighnedBtn(self.dayBtn)
                            self.dayBtn.tag = 1
                            self.SelectSingleForDay()
                            self.view4.initDate(Global.sharedInstance.currDateSelected)
                            self.view1.view.isHidden = true
                            self.view2.view.isHidden = true
                            self.view3.view.isHidden = true
                            self.view4.view.isHidden = false
                            self.selectedView = self.view4
                            self.view.bringSubviewToFront(self.view4.view)
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.view4.bestmode()
                                self.view4.view.setNeedsDisplay()
                            })
                            break
                        case 0: //day
                            self.SelectDesighnedBtn(self.dayBtn)
                            self.dayBtn.tag = 1
                            self.SelectSingleForDay()
                            self.view4.initDate(Global.sharedInstance.currDateSelected)
                            self.view1.view.isHidden = true
                            self.view2.view.isHidden = true
                            self.view3.view.isHidden = true
                            self.view4.view.isHidden = false
                            self.selectedView = self.view4
                            self.view.bringSubviewToFront(self.view4.view)
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.view4.bestmode()
                                self.view4.view.setNeedsDisplay()
                            })
                             break
                        default:
                            self.selectedView = self.view1
                            self.SelectDesighnedBtn(self.monthlyBtn)
                            self.view1.view.isHidden = false
                            self.view3.view.isHidden = true
                            self.view4.view.isHidden = true
                            self.view2.view.isHidden = true
                            self.view.bringSubviewToFront(self.view1.view)
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.view1.bestmode()
                                self.view1.view.setNeedsDisplay()
                            })

                            print("moded")
                            break
                        }
                    }
                } else {
//                        self.SelectDesighnedBtn(self.dayBtn)
//                        self.dayBtn.tag = 1
//                        self.SelectSingleForDay()
//                        self.view4.initDate(Global.sharedInstance.currDateSelected)
//                        self.view1.view.isHidden = true
//                        self.view2.view.isHidden = true
//                        self.view3.view.isHidden = true
//                        self.view4.view.isHidden = false
//                        self.selectedView = self.view4
//                        self.view.bringSubview(toFront: self.view4.view)
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            self.view4.bestmode()
//                            self.view4.view.setNeedsDisplay()
//                        })
                        self.selectedView = self.view1
                        self.SelectDesighnedBtn(self.monthlyBtn)
                        self.view1.view.isHidden = false
                        self.view3.view.isHidden = true
                        self.view4.view.isHidden = true
                        self.view2.view.isHidden = true
                        self.view.bringSubviewToFront(self.view1.view)
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.view1.bestmode()
                            self.view1.view.setNeedsDisplay()
                        })

                    print("eroare la server")
                    
                    
                }
                }
                
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
            })
        }
    }
    
    
    
    //openDetailsOrderDelegate
    func openDetailsOrder(_ tag:Int)  {//פונקציה דליגטית שנקראת בעת לחיצה על רבוע פנוי או תפוס(לפי הטאג) ביומן ופותחת את פרטי ההזמנה במודל
        let storyboard = UIStoryboard(name: "ClientExist", bundle: nil)
        let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "detailsAppointmetClientViewController") as! detailsAppointmetClientViewController
        vc.tag = 2
        vc.fromViewMode = false
        if tag == 3 {
          vc.iSupplierId =  Global.sharedInstance.orderDetailsFoBthereEvent.iSupplierId
          vc.nvPhone = Global.sharedInstance.orderDetailsFoBthereEvent.nvPhone
        }
        frontviewcontroller?.pushViewController(vc, animated: false)
        let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
    //מחזיר את ה-string לשורה מסויימת מהטבלה שנבחרה
    //מקבלת את קוד הטבלה אליה לגשת ואת קוד ה-string
    func SysTableRowString(_ iTableRowId:Int,id:Int)->String
    {
        if Global.sharedInstance.dicSysAlerts[iTableRowId.description]?.count > 0 {
            for sys in Global.sharedInstance.dicSysAlerts[iTableRowId.description]!
            {
                if sys.iTableId == iTableRowId && sys.iSysTableRowId == id
                {
                    return sys.nvAletName
                }
            }
        }
        return ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
            self.con!.tableView.isHidden = true
        }
            
        else
        {
            if startString.characters.count > 120
            {
                Alert.sharedInstance.showAlert("ENTER_ONLY120_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
                return false
            }
            self.con!.tableView.isHidden = false
            searchAutocompleteEntriesWithSubstring(substring)
        }
        return true
    }
    
    //MARK: - keyboard
    
    ///dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
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
                        self.newsDealsLabel.text  = abcd
                    }
                }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
            })
        }
    }

    
    
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
