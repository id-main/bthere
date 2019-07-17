//
//  entranceViewController.swift
//  bthree-ios
//
//  Created by Tami wexelbom on 21.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol openControlersDelegate
{
    func openVerification(_ phone:String)
    func openCustomerOrProvider()
}

protocol openLoginDelegate
{
    func showPopUp()
}

protocol languageFromRegister
{
    func openLanguage()
}
//דף כניסה ראשוני(כולל חיפוש מתקדם)
class entranceViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,openSearchResultsDelegate,openControlersDelegate,openChooseUserDelegate,openCustomerDetailsDelegate
    ,openFromMenuDelegate, openLoginDelegate,languageFromRegister
{
    
    //MARK: - Outlet
    //===========Outlet====================
    @IBOutlet weak var newsDealsLabel: MarqueeLabel!
    
    @IBOutlet weak var btnLogIn: UIButton!
    
    @IBOutlet weak var tblSearch: UITableView!
    
    @IBOutlet var imgView: UIView!
    
    @IBOutlet weak var btnOpemMenu: UIImageView!
    
    @IBOutlet weak var btnOpenMenu: UIImageView!
    
    @IBOutlet weak var btnRegisterOutlet: UIButton!
    @IBAction func btnRegister(_ sender: AnyObject)
    {
        
        
        Global.sharedInstance.isFromViewMode = false
        let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        viewCon.loginDelegate = self
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        viewCon.languageDelegate = self
        self.navigationController?.pushViewController(viewCon, animated: false)
    }
    @IBAction func btnSearchAction(_ sender: UIButton)
    {
        Global.sharedInstance.isProvider = false
        let viewCon:AdvantageSearchViewController = clientStoryBoard!.instantiateViewController(withIdentifier: "AdvantageSearchViewController") as! AdvantageSearchViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        viewCon.delegateSearch = self
        self.present(viewCon, animated: true, completion: nil)
    }
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var viewOnLogin: UIView!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBAction func btnLogIn(_ sender: AnyObject) {
        
        showPopUp()
    }
    
    var attributedStrings = NSMutableAttributedString(string:"")
    var myformchangelanguage:Bool = false
    var isAuto = false
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var btnSearch: UIButton!
    //OLDCODE
    @IBAction func btnSearchx(_ sender: AnyObject) {
        Global.sharedInstance.viewConNoInternet = self
        dismissKeyboard()
        
        Global.sharedInstance.searchDomain = txtSearch.text!
        
        if txtSearch.text != ""
        {
            self.generic.showNativeActivityIndicator(self)
            
            Global.sharedInstance.dicSearch["nvKeyWord"] = txtSearch.text as AnyObject
            Global.sharedInstance.dicSearch["nvlong"] = Global.sharedInstance.currentLong as AnyObject
            Global.sharedInstance.dicSearch["nvlat"] = Global.sharedInstance.currentLat as AnyObject
            Global.sharedInstance.dicSearch["nvCity"] = nil
            
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
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                    Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                }
                                self.dismiss(animated: false, completion: nil)
                                Global.sharedInstance.dicSearchProviders = Global.sharedInstance.dicSearch
                                Global.sharedInstance.whichSearchTag = 1
                                self.delegateSearch.openSearchResults()
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                })
            }
        }
        else
        {
            Alert.sharedInstance.showAlert("NOT_DATA_TO_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        }
    }

    //NEWDEVELOP
    @IBAction func btnSearch(_ sender: AnyObject) {
        Global.sharedInstance.viewConNoInternet = self
        dismissKeyboard()
        
        Global.sharedInstance.searchDomain = txtSearch.text!
        
        if txtSearch.text != ""
        {
            self.generic.showNativeActivityIndicator(self)
            
            Global.sharedInstance.dicSearch["nvKeywords"] = txtSearch.text as AnyObject
            Global.sharedInstance.dicSearch["nvLong"] = Global.sharedInstance.currentLong as AnyObject
            Global.sharedInstance.dicSearch["nvLat"] = Global.sharedInstance.currentLat as AnyObject
            Global.sharedInstance.dicSearch["nvCity"] = nil
        //\\    print("Global.sharedInstance.dicSearch \(Global.sharedInstance.dicSearch)")
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                api.sharedInstance.SearchByKeyWords(Global.sharedInstance.dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
               
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                        Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                        }
                        self.dismiss(animated: false, completion: nil)
                        Global.sharedInstance.dicSearchProviders = Global.sharedInstance.dicSearch
                        Global.sharedInstance.whichSearchTag = 1
                        self.delegateSearch.openSearchResults()
                    }
                    }
                    }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
//                        Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                })
            }
        }
        else
        {
            Alert.sharedInstance.showAlert("NOT_DATA_TO_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        }
    }
    func getnews(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //    dic["iLanguageId"] = finalIntforlang
        
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
                        self.newsDealsLabel.tag = 101
                        self.newsDealsLabel.type = .continuous
                        self.newsDealsLabel.animationCurve = .linear //.EaseInOut
                        self.newsDealsLabel.type = .leftRight
                        self.newsDealsLabel.text  = abcd
                    self.newsDealsLabel.restartLabel()
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
    
    @IBOutlet weak var btnSeachAdvantage: UIButton!
    
    @IBAction func btnLanguage(_ sender: AnyObject) {
        openLanguage()
    }
    
    //    @IBOutlet weak var lblAdvertisings: UILabel!
    @IBOutlet weak var btnLanguage: UIButton!
    
    //MARK: - Properties
    //===========Properties============
    
    var filterSubArr:NSArray =  NSArray()
    var delegateSearch:openSearchResultsDelegate!=nil
    
    var clientStoryBoard:UIStoryboard?
    var filtered:Array<String> = []
    
    var searchActive : Bool = false
    
    var generic:Generic = Generic()
    
    ///for underline of buttons
    var attrs = [
        
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "OpenSansHebrew-Regular", size: 18)!,
        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : Colors.sharedInstance.color1,
        convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1] as [String : Any]
    var attributedStringsUserExist = NSMutableAttributedString(string:"")
    var attributedStringsLanguage = NSMutableAttributedString(string:"")
    
    //MARK: - Initial
    //==============Initial============
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rtlRELOAD()
        GoogleAnalyticsSendEvent(x:1)
        

      //  appDelegate.setHELPSCREENS()
      //  self.getnews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
        USERDEF.synchronize()
        let mys = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")
        print("FINDisfromSPECIALiCustomerUserId \(mys)")
        self.getnews()
        self.newsDealsLabel.restartLabel()
 
        
        Global.sharedInstance.defaults.set(0, forKey: "mustreloadprovider")
        Global.sharedInstance.defaults.synchronize()
        btnRegisterOutlet.setTitle("REGISTER_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnSeachAdvantage.setTitle("ADVANTAGED_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnSeachAdvantage.titleLabel?.sizeToFit()
        //  txtSearch.placeholder =  "SERACH_SERVICE_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            txtSearch.attributedPlaceholder = NSAttributedString(string: "SEARCH_SERVICE_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.darkGray,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 13)!]))
        }
        else
        {
            txtSearch.attributedPlaceholder = NSAttributedString(string: "SEARCH_SERVICE_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.darkGray,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        }
        
        
        //   if Global.sharedInstance.rtl == true {
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            txtSearch.textAlignment = .right
        } else {
            txtSearch.textAlignment = .left
        }
        
        
        btnLogin.setTitle("LOGIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        //JMODE +
        btnLogin.titleLabel!.numberOfLines = 1
        //btnLogin.titleLabel!.adjustsFontSizeToFitWidth = true
        // btnLogin.titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        btnLogIn.titleLabel?.font = UIFont(name: "OpenSansHebrew-Regular", size: 15)!
        //   lblAdvertisings.text = "ADVERTISINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        Global.sharedInstance.dicSearch = Dictionary<String,AnyObject>()//עבור השליחה לשרת
        
        delegateSearch = self
        
        let tapViewLogin = UITapGestureRecognizer(target: self, action: #selector(showPopUp))
        viewOnLogin.addGestureRecognizer(tapViewLogin)
        
        clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        txtSearch.delegate = self
        
        // לפי בקשת הלקוחה, הורדתי את הכפתור לפתיחת תפריט +
        
        //        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(entranceViewController.imageTapped))
        //        btnOpemMenu.userInteractionEnabled = true
        //        btnOpemMenu.addGestureRecognizer(tapGestureRecognizer)
        self.view.bringSubviewToFront(tblSearch)
        
        let buttonTitleStr1 = NSMutableAttributedString(string:"Language", attributes:convertToOptionalNSAttributedStringKeyDictionary(attrs))
        attributedStringsLanguage.append(buttonTitleStr1)
        btnLanguage.setAttributedTitle(attributedStringsLanguage, for: UIControl.State())
        
        
        // self.imgView.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        self.view.addBackground()
        tblSearch.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(entranceViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        let backView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        
        let titleImageView: UIImageView = UIImageView(image: UIImage(named: "3.png"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleImageView.frame.size.width * 0.8, height: 40)
        // Here I am passing origin as (45,5) but can pass them as your requirement.
        backView.addSubview(titleImageView)
        
        self.navigationItem.titleView = backView
        
        UIApplication.shared.statusBarFrame.size.height
        
        self.navigationItem.setHidesBackButton(true, animated:true)
         btnRegister(btnRegisterOutlet)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Colors.sharedInstance.addBottomBorderWithColor(UIColor.black, width: 1, any: lineView)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - TableView
    //==========TableView===============
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filterSubArr.count == 0
        {
            tblSearch.isHidden = true
        }
        return filterSubArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search")as! SearchTableViewCell
        cell.setDisplayData(filterSubArr[indexPath.row] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.09687
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        txtSearch.text = filterSubArr[indexPath.row] as? String
        tblSearch.isHidden = true
        btnSearch(self.btnSearch)
    }
    
    //MARK: - Searching
    //==========Searching===========
    
    func searching(_ searchText: String) {
        searchActive = true
        if searchText == ""{
            filtered =  []
        }
        else
        {
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
    
    ///dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin")
    }
    @objc func dismissKeyboard() {
        //        tblSearch.hidden = true
        self.view.endEditing(true)
    }
    
    //for autoCopmlete:
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
                        {//1.fix 2.3
                            self.filterSubArr = NSArray() //from NSMutableArray
                            if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                            self.filterSubArr = RESPONSEOBJECT["Result"] as! NSArray
                            }
                            self.tblSearch.reloadData()
                        }
                            }
                        }
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
//                            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                    })
                }
            }
        }
    }
    
    ////for the autoComplete
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //בשביל ה-autoComplete
        
        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        startString += string
        
        
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
    
    func openSearchResults()
    {
        let frontviewcontroller = storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = clientStoryBoard?.instantiateViewController(withIdentifier: "SearchResults") as! SearchResultsViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        
        //initialize REAR View Controller- it is the LEFT hand menu.
        
        let rearViewController = storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
    //פתיחת קוד אימות
    func openVerification(_ phone:String)
    {
        let viewCon:MessageVerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageVerificationViewController") as! MessageVerificationViewController
        viewCon.phone = phone
        viewCon.delegateCon = self
        viewCon.isFromPersonalDetails = false
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }
    
    func openCustomerOrProvider()
    {
        let viewCon:CustomerOrDistributorViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomerOrDistributorViewController") as! CustomerOrDistributorViewController
        viewCon.delegate = self
        viewCon.delegate1 = self
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
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
    
    func openFromMenu(_ con:UIViewController)
    {
        self.present(con, animated: true, completion: nil)
    }
    
    //שהלחיצה ב-didSelect של טבלת חיפוש התחומים תהיה יותר בקלות
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: tblSearch)) {
            
            return false
        }
        return true
    }
    
    @objc func showPopUp() {
        let viewCon:ExistingUserPhoneViewController = storyboard?.instantiateViewController(withIdentifier: "existsUserPhone") as! ExistingUserPhoneViewController
        viewCon.delegate = self
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }
    
    @objc func openLanguage(){
        
        let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
        let vc:langForEntranceViewController = storyboardCExist.instantiateViewController(withIdentifier: "langForEntranceViewController") as! langForEntranceViewController
        
        let front = self.storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        
        front.pushViewController(vc, animated: false)
        
        
        let rearViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = front
        mainRevealController.rearViewController = rearViewController
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
        
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
