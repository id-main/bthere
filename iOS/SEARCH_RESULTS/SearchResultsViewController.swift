//
//  SearchResultsViewController.swift
//  bthree-ios
//
//  Created by User on 21.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
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


protocol dismissViewControllerDelegate {
    func dismissViewController()
}

protocol ReloadResultsDelegate {
    func ReloadResultsDelegate()
}

protocol businessProfileBackDelegate
{
    // 1 if the user reviewed the business in ViewBusinessProfileVC, 0 if not
    func reloadSearch(didReview:Int)
}

protocol didPickNewLocation
{
    func showNewLocation(newLocation:String,lat:String,long:String)
}



class SearchResultsViewController: NavigationModelViewController,dismissViewControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,ReloadResultsDelegate,businessProfileBackDelegate, didPickNewLocation,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    
    // Outlets
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet weak var btnByDistance: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblResults: UITableView!
    @IBOutlet weak var lblSortBy: UILabel!
    @IBOutlet weak var btnByRating: UIButton!
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var imgCircleDistance: UIImageView!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var btnChangeLocation: UIButton!
    @IBOutlet var lblResultCount: UILabel!
    @IBOutlet weak var newLocationLabel: UILabel!
    
    var viewhelp : helpPpopup!
    
    // Variables
    var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    var storyboard1:UIStoryboard?
    var dicResultSorted:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
    var generic:Generic = Generic()
    var filterSubArr:NSArray =  NSArray()

    let googlePlacesAutocomplete = SPGooglePlacesAutocompleteQuery()
    var listAutocompletePlace:[SPGooglePlacesAutocompletePlace] = []
    var newLatitude:String = ""
    var newLongitude:String = ""
    
    func LOADHELPERS() {
        var HELPSCREENKEYFORNSUSERDEFAULTS = ""
        let USERDEF = UserDefaults.standard
        var imagesarray:NSArray = NSArray()
        //     returnCURRENTHELPSCREENS() -> (HLPKEY:String, imgs:NSArray)
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        imagesarray = appDelegate.returnCURRENTHELPSCREENS()
        //  HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.HELPSCREENKEY
        HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.returnCURRENTKEY()
        if  imagesarray.count > 0 {
            let fullimgarr:NSMutableArray = imagesarray.mutableCopy() as! NSMutableArray
            print("aaa \(fullimgarr.description)")
            if let mydict:NSMutableDictionary = fullimgarr[1] as? NSMutableDictionary {
                if mydict["seen"] as! Int == 1 { //was not seen
                    let changedictionary: NSMutableDictionary = NSMutableDictionary()
                    changedictionary["needimage"] = mydict["needimage"]
                    changedictionary["seen"] = 0 //seen
                    fullimgarr[1] = changedictionary
                    USERDEF.set(fullimgarr, forKey: HELPSCREENKEYFORNSUSERDEFAULTS)
                    USERDEF.synchronize()
                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    viewhelp = (storyboardtest.instantiateViewController(withIdentifier: "helpPpopup") as! helpPpopup)
                    if self.iOS8 {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    } else {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    }
                    viewhelp.indexOfImg = 1
                    viewhelp.HELPSCREENKEYFORNSUSERDEFAULTS = HELPSCREENKEYFORNSUSERDEFAULTS
                    self.present(viewhelp, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
        USERDEF.synchronize()

        btnByRating.tag = 0
        btnByDistance.tag = 0

        
        Global.sharedInstance.isSettingsOpen = false
        txtSearch.text = Global.sharedInstance.searchDomain
        
        if (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) {
            txtSearch.attributedPlaceholder = NSAttributedString(string: "SEARCH_SERVICE_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.darkGray,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 13)!]))
        } else {
            txtSearch.attributedPlaceholder = NSAttributedString(string: "SEARCH_SERVICE_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.darkGray,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        }
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            txtSearch.textAlignment = .right
        } else {
            txtSearch.textAlignment = .left
        }
        
        btnChangeLocation.setTitle("CHANGE_LOCATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblSortBy.text = "ORDER_BY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnByRating.setTitle("LEVEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnByDistance.setTitle("DISTANCE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        
        
        checkDevice()
        txtSearch.delegate = self
        tblSearch.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchResultsViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        dicResultSorted = Global.sharedInstance.dicResults
        storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        Global.sharedInstance.searchResult = self
        
        tblResults.separatorStyle = .none
        tblResults.separatorColor = UIColor.black
        tblResults.tableFooterView = UIView()
        
        imgCircle.isHidden = true
        imgCircleDistance.isHidden = true
        
        
        Global.sharedInstance.viewCon2 = storyboard1!.instantiateViewController(withIdentifier: "ViewBusinessProfileVC") as? ViewBusinessProfileVC
        Global.sharedInstance.viewCon2?.delegate2 = self
        Global.sharedInstance.viewCon2!.modalPresentationStyle = UIModalPresentationStyle.custom
        Global.sharedInstance.viewCon = self.storyboard?.instantiateViewController(withIdentifier: "ListServicesViewController") as? ListServicesViewController
        Global.sharedInstance.viewCon?.backFromMyListServices = 0
        
        USERDEF.set(0,forKey: "backFromMyListServices")
        USERDEF.synchronize()
        Global.sharedInstance.arrayServicesKods = []
        Global.sharedInstance.viewCon!.delegate = self
        self.lblResultCount.text = "\(Global.sharedInstance.dicResults.count) \("SEARCH_RESULT".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
       
        if (Global.sharedInstance.dicSearchProviders["nvCity"] != nil) {
            Global.sharedInstance.dicResults.sort{
                (($0 )["dRankAvg"] as? Float) > (($1 )["dRankAvg"] as? Float)
            }
            
            self.btnByRating.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 16)
            self.imgCircleDistance.isHidden = true
            self.btnByDistance.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 16)
            self.btnByRating(self.btnByRating)
        } else {
            if CLLocationManager.locationServicesEnabled() == false {
                Global.sharedInstance.dicResults.sort{
                    (($0 )["dRankAvg"] as? Float) > (($1 )["dRankAvg"] as? Float)
                }
                
                self.btnByRating.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 16)
                // self.imgCircle.hidden = false
                self.imgCircleDistance.isHidden = true
                self.btnByDistance.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 16)
                self.btnByRating(self.btnByRating)
            } else if Global.sharedInstance.currentLat == nil {
                Global.sharedInstance.dicResults.sort{
                    (($0 )["dRankAvg"] as? Float) > (($1 )["dRankAvg"] as? Float)
                }
                
                self.btnByRating.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 16)
                // self.imgCircle.hidden = false
                self.imgCircleDistance.isHidden = true
                self.btnByDistance.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 16)
                self.btnByRating(self.btnByRating)
            }
        }
     
    

        Global.sharedInstance.dicResults.sort{
            (($0 )["dRankAvg"] as? Float) > (($1 )["dRankAvg"] as? Float)
        }
        
        self.btnByRating(self.btnByRating)
        self.btnByRating.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 16)
        

        
        // Stop listening notification

        newLocationLabel.isHidden = true
        newLongitude = ""
        newLatitude = ""
        btnChangeLocation.setTitle("CHANGE_LOCATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
        
    }
    
    
    func showNewLocation(newLocation:String,lat:String,long:String)
    {
        if newLocation == ""
        {
            newLocationLabel.isHidden = true
            newLocationLabel.text = newLocation
            newLongitude = ""
            newLatitude = ""
            self.btnSearchClick(self.btnSearch)
        }
        else
        {
            newLocationLabel.isHidden = false
            newLocationLabel.text = newLocation
            newLongitude = long
            newLatitude = lat
            self.btnSearchClick(self.btnSearch)
        }

    }
    
    func reloadTbl()
    {
        self.btnByRating(self.btnByRating)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tblSearch.isHidden = true
        self.view.addBackground2()
        
//        print("search results log ordered\(Global.sharedInstance.dicResults as AnyObject)")
//        dump("search results log ordered \(Global.sharedInstance.dicResults)")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:5)
        
    }
    
    
    @IBAction func btnChangeLocation(_ sender: AnyObject)
    {

        
        let myViewController = ChangeLocationInSearch(nibName: "ChangeLocationInSearch", bundle: nil)
        myViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        myViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myViewController.locationDelegate = self
        self.present(myViewController, animated: false, completion: nil)
        
    }
    
    //OLDCODE
    @IBAction func  x(_ sender: AnyObject) {
        dismissKeyboard()
        Global.sharedInstance.searchDomain = txtSearch.text!
        
        if (txtSearch.text != "") {
            Global.sharedInstance.dicSearch["nvKeyWord"] = txtSearch.text as AnyObject
            Global.sharedInstance.dicSearch["nvlong"] = Global.sharedInstance.currentLong as AnyObject
            Global.sharedInstance.dicSearch["nvlat"] = Global.sharedInstance.currentLat as AnyObject
            Global.sharedInstance.dicSearch["nvCity"] = nil
            
            self.generic.showNativeActivityIndicator(self)
            
            if (Reachability.isConnectedToNetwork() == false) {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            } else {
                api.sharedInstance.SearchByKeyWord(Global.sharedInstance.dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 {
                                self.showAlertDelegateX("NO_RESULTS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                self.tblSearch.isHidden = true
                                Global.sharedInstance.dicResults = []
                                self.tblResults.reloadData()
                                self.lblResultCount.text = "0 \("SEARCH_RESULT".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
                            } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                Global.sharedInstance.dicSearchProviders = Global.sharedInstance.dicSearch
                                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                    Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
//                                    for dic:Dictionary<String,AnyObject> in Global.sharedInstance.dicResults
//                                    {
//                                        print("SearchByKeyWord2: \(dic)")
//                                    }
                                    
                                }
                                self.lblResultCount.text = "\(Global.sharedInstance.dicResults.count) \("SEARCH_RESULT".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
                                Global.sharedInstance.whichSearchTag = 1
                                self.tblResults.reloadData()
                            }
                        }
                    }
                    self.tblResults.reloadData()
                    
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                })
            }
        } else {
            Alert.sharedInstance.showAlert("NOT_DATA_TO_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        }
    }
    

    //NEWDEVELOP
    @IBAction func btnSearchClick(_ sender: AnyObject) {
        dismissKeyboard()
        Global.sharedInstance.searchDomain = txtSearch.text!
        if txtSearch.text == "" {
            Global.sharedInstance.dicResults = []
            tblResults.reloadData()
            Alert.sharedInstance.showAlert("NOT_DATA_TO_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        } else  if txtSearch.text != "" && (txtSearch.text?.count)! < 2 {
            Alert.sharedInstance.showAlert("SEARCHLESS3LETTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
        } else if txtSearch.text != "" && (txtSearch.text?.count)! >= 2
            {
            if newLatitude != ""
            {
                Global.sharedInstance.dicSearch["nvLat"] = newLatitude as AnyObject
            }
            else
            {
                Global.sharedInstance.dicSearch["nvLat"] = Global.sharedInstance.currentLat as AnyObject
            }
            if newLongitude != ""
            {
               Global.sharedInstance.dicSearch["nvLong"] = newLongitude as AnyObject
            }
            else
            {
                Global.sharedInstance.dicSearch["nvLong"] = Global.sharedInstance.currentLong as AnyObject
            }
                
            Global.sharedInstance.dicSearch["nvKeywords"] = txtSearch.text as AnyObject
//            Global.sharedInstance.dicSearch["nvLong"] = Global.sharedInstance.currentLong as AnyObject
//            Global.sharedInstance.dicSearch["nvLat"] = Global.sharedInstance.currentLat as AnyObject
            Global.sharedInstance.dicSearch["nvCity"] = nil
            var y:Int = 0
            if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
            }
            Global.sharedInstance.dicSearch["iUserId"]  = y as AnyObject
            self.generic.showNativeActivityIndicator(self)
            
            if (Reachability.isConnectedToNetwork() == false) {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            } else {
                //mod SearchByKeyWord with SearchByKeyWords on 08/05/2018
                api.sharedInstance.SearchByKeyWords(Global.sharedInstance.dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 {
                        self.showAlertDelegateX("NO_RESULTS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        self.tblSearch.isHidden = true
                        Global.sharedInstance.dicResults = []
                        self.btnByRating(self.btnByRating)
                        self.lblResultCount.text = "0 \("SEARCH_RESULT".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
                    } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                        Global.sharedInstance.dicSearchProviders = Global.sharedInstance.dicSearch
                        if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                        Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
//                            for dic:Dictionary<String,AnyObject> in Global.sharedInstance.dicResults
//                            {
//                                print("SearchByKeyWord3: \(dic)")
//                            }
                        }
                        self.lblResultCount.text = "\(Global.sharedInstance.dicResults.count) \("SEARCH_RESULT".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
                        Global.sharedInstance.whichSearchTag = 1
                        if self.btnByRating.tag == 0 && self.btnByDistance.tag == 0
                        {
                          self.btnByRating(self.btnByRating)
                        }
                        else if self.btnByRating.tag == 1 && self.btnByDistance.tag == 0
                        {
                            self.btnByRating(self.btnByRating)
                        }
                        else if self.btnByRating.tag == 0 && self.btnByDistance.tag == 1
                        {
                            self.btnByDistance(self.btnByDistance)
                        }
                        else
                        {
                            self.btnByRating(self.btnByRating)
                        }
                        
                        
//                        self.tblResults.reloadData()
                        }
                        }
                    }
//                    self.tblResults.reloadData()
//                    self.btnByRating(self.btnByRating)
                  
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                })
            }
        }
    }
    
    
    // Sort by rank
    @IBAction func btnByRating(_ sender: AnyObject) {
        self.generic.showNativeActivityIndicator(self)
        btnByRating.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 16)
        imgCircleDistance.isHidden = true
        btnByDistance.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 16)
        btnByRating.tag = 1
        btnByDistance.tag = 0
//        Global.sharedInstance.dicResults.sort
//        {
//            (($0 )["dRankAvg"] as? Double) > (($1 )["dRankAvg"] as? Double)
//        }
//        Global.sharedInstance.dicResults.sort
//            {
//                return (($0)["nvProviderName"] as? String) < (($1)["nvProviderName"] as? String)
//        }
//        print("adasdasD: \(Global.sharedInstance.dicResults[0])")
        Global.sharedInstance.dicResults.sort
        {
                if (($0)["dRankAvg"] as? Double) < (($1)["dRankAvg"] as? Double)
                {
                    return (($0)["dRankAvg"] as? Double) > (($1)["dRankAvg"] as? Double)
                }
                else if (($0)["dRankAvg"] as? Double) == (($1)["dRankAvg"] as? Double)
                {
                    return (($0)["nvProviderName"] as? String) < (($1)["nvProviderName"] as? String)
                }
                else
                {
                    return true
                }
        }
        let searchObj:SearchResulstsObj = SearchResulstsObj()
        var providersArray:Array<SearchResulstsObj> = Array<SearchResulstsObj>()
        providersArray = searchObj.objProvidersToArray(Global.sharedInstance.dicResults)
//        for i in 0..<providersArray.count
//        {
//            print("array: \(providersArray[i].printSearchResultObject(obj: providersArray[i]))")
//        }
        
         tblResults.reloadData()
        tblResults.setContentOffset(.zero, animated: true)
        self.generic.hideNativeActivityIndicator(self)
//        print("search results log \(Global.sharedInstance.dicResults as AnyObject)")
//        dump("search results log \(Global.sharedInstance.dicResults)")
    }
    
    
    // Sort by distance
    @IBAction func btnByDistance(_ sender: AnyObject) {
        self.generic.showNativeActivityIndicator(self)
        btnByDistance.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 16)
        imgCircle.isHidden = true
        btnByRating.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 16)
        btnByRating.tag = 0
        btnByDistance.tag = 1
        
        if (CLLocationManager.locationServicesEnabled() == false) {
            Global.sharedInstance.dicResults.sort
            {
                 (($0 )["iDistance"] as? Double) > (($1 )["iDistance"] as? Double)
            }
            
            self.btnByRating.titleLabel?.font = UIFont(name: "OpenSansHebrew-Bold", size: 16)
            // self.imgCircle.hidden = false
            self.imgCircleDistance.isHidden = true
            self.btnByDistance.titleLabel?.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            self.tblResults.reloadData()
            self.tblResults.setContentOffset(.zero, animated: true)
            self.generic.hideNativeActivityIndicator(self)
        } else if (Global.sharedInstance.currentLat == nil) {
            Global.sharedInstance.dicResults.sort{
                  (($0 )["iDistance"] as? Double) > (($1 )["iDistance"] as? Double)
            }
            
            self.btnByRating.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 16)
            self.imgCircleDistance.isHidden = true
            self.btnByDistance.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 16)
            
            tblResults.reloadData()
            self.tblResults.setContentOffset(.zero, animated: true)
            self.generic.hideNativeActivityIndicator(self)
        } else {
            var dicPositiveDistance:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
            var dicNegativeDistance:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
            
            for result in Global.sharedInstance.dicResults {
                if let _:Double = result["iDistance"] as? Double {
                if (result["iDistance"] as! Double) == -1 {
                    dicNegativeDistance.append(result)
                }
                else {
                    dicPositiveDistance.append(result)
                }
                } else
                if let _:Double = result["iDistance"] as? Double {
                    if (result["iDistance"] as! Double) == -1 {
                        dicNegativeDistance.append(result)
                    
                }else {
                    dicPositiveDistance.append(result)
                }
                } else
            //float
            if  let _:Double = result["iDistance"] as? Double {
                if (result["iDistance"] as! Double) == -1 {
                    dicNegativeDistance.append(result)
              
            }else {
                dicPositiveDistance.append(result)
                }
                }
            }
                
            //float
            dicPositiveDistance.sort {
                (($0)["iDistance"] as? Double) < (($1)["iDistance"] as? Double)
            }
        
            
            Global.sharedInstance.dicResults = dicPositiveDistance
        //    print("global dic results distance \(Global.sharedInstance.dicResults))")
            for item in dicNegativeDistance {
                Global.sharedInstance.dicResults.append(item)
            }
            //float
            Global.sharedInstance.dicResults.sort {
                (($0)["iDistance"] as? Double) < (($1)["iDistance"] as? Double)
                
            }
            Global.sharedInstance.dicResults.sort
                {
                    if (($0)["iDistance"] as? Double) > (($1)["iDistance"] as? Double)
                    {
                        return (($0)["iDistance"] as? Double) < (($1)["iDistance"] as? Double)
                    }
                    else if (($0)["iDistance"] as? Double) == (($1)["iDistance"] as? Double)
                    {
                        return (($0)["nvProviderName"] as? String) < (($1)["nvProviderName"] as? String)
                    }
                    else
                    {
                        return true
                    }
            }
            
      //      print("search results log by distance \(Global.sharedInstance.dicResults as AnyObject)")
            tblResults.reloadData()
            self.tblResults.setContentOffset(.zero, animated: true)
            self.generic.hideNativeActivityIndicator(self)
        }
    }
    
    
    ////for the autoComplete
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var startString = ""
        if (textField.text != nil) {
            startString += textField.text!
        }
        
        startString += string
        
        if Reachability.isConnectedToNetwork() == false && string != "" {
            textField.text = startString
        }
        
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if substring == "" {
            tblSearch.isHidden = true
        } else {
            if startString.count > 120 {
                Alert.sharedInstance.showAlert("ENTER_ONLY120_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
                return false
            }
            
            tblSearch.isHidden = false
            searchAutocompleteEntriesWithSubstring(substring)
        }
        
        return true
    }
    
    
    //for autoCopmlete:
    func searchAutocompleteEntriesWithSubstring(_ substring: String) {
        if substring.count >= 1 {
          
            if txtSearch.text != "" {
                var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicSearch["nvKeyWord"] = substring as AnyObject
                
                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false {
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                } else {
                    api.sharedInstance.SearchWordCompletion(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                            self.filterSubArr = NSArray()
                            self.filterSubArr = RESPONSEOBJECT["Result"] as! NSArray
                            self.tblSearch.reloadData()
//                            for dic:Dictionary<String,AnyObject> in RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
//                            {
//                                print("SearchByKeyWord1: \(dic)")
//                            }
                            self.btnByRating(self.btnByRating)
                            
                        }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                         self.tblSearch.reloadData()
//                        Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                    })
                }
            }
        }
        
        tblSearch.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblSearch {
            return self.view.frame.height * 0.09687
        }
        
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            let bounds = UIScreen.main.bounds
            let widthscr = bounds.size.width
            var heightscr:CGFloat = 0
            heightscr = 60 + (widthscr * 0.26 )
            
            return heightscr
        }
        
        let bounds = UIScreen.main.bounds
        let widthscr = bounds.size.width
        var heightscr:CGFloat = 0
        heightscr = 60 + (widthscr * 0.26 )
        
        return heightscr
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblSearch {
            return 1
        }
        print("Global.sharedInstance.dicResults.count \(Global.sharedInstance.dicResults.count )")

        return Global.sharedInstance.dicResults.count
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblSearch {
            if filterSubArr.count == 0 {
                tblSearch.isHidden = true
            }
            
            return filterSubArr.count
        }
        
        return  1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblResults {
            let cell1: SearchResultsTableViewCell = self.tblResults.dequeueReusableCell(withIdentifier: "SearchResults") as! SearchResultsTableViewCell
            cell1.setDisplayData(indexPath.section)
            cell1.colViewResult.setContentOffset(CGPoint(x: 0 , y: 0), animated: false)
            cell1.colViewResult.reloadData()
            
            
            return cell1
        }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Search")as! SearchTableViewCell
            cell.setDisplayData(filterSubArr[indexPath.row] as! String)
            return cell
      
       
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == tblSearch) {
            txtSearch.text = filterSubArr[indexPath.row] as? String
            tblSearch.isHidden = true
            btnSearchClick(btnSearch)
        }
    }
    
    
    func dismissViewController() {
        Global.sharedInstance.whichDesignOpenDetailsAppointment = 0
        let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "ModelCalendarForAppointments") as! ModelCalendarForAppointmentsViewController
        Global.sharedInstance.idWorker = -1
        self.navigationController?.pushViewController(viewCon, animated: false)
    }
    
    
    @objc func dismissKeyboard() {
        tblSearch.isHidden = true
        self.view.endEditing(true)
    }
    
    
    func checkDevice() {
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            btnChangeLocation.titleLabel!.font = UIFont(name: (self.btnChangeLocation.titleLabel?.font.familyName)!, size: 16)
            lblSortBy.font = UIFont(name: (self.lblSortBy.font.familyName), size: 18)
            btnByRating.titleLabel!.font = UIFont(name: (self.btnByRating.titleLabel?.font.familyName)!, size: 16)
            btnByDistance.titleLabel!.font = UIFont(name: (self.btnByDistance.titleLabel?.font.familyName)!, size: 16)
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: tblSearch) {
            return false
        }
        
        return true
    }
    
    
    func ReloadResultsDelegate() {
        self.lblResultCount.text = "\(Global.sharedInstance.dicResults.count) \("SEARCH_RESULT".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
        
        tblResults.reloadData()
    
    }
    
    
    func applicationWillEnterForeground(_ p:UIApplication) {
        print("df")
    }
    
    func reloadSearchresults() {
        btnSearchClick(btnSearch)
    }

    func reloadSearch(didReview:Int)
    {
        if didReview == 1
        {
            btnSearchClick(btnSearch)
        }
        
    }
    
}




extension UIViewController {

    func rateBusiness(idBusiness:Int, businessName:String) {
        print ("businessName supplier: \(businessName)")
                if let _ =  Bundle.main.loadNibNamed("giveRate", owner: self, options: nil)?.first as? giveRate
                {
                   let popUpReview = Bundle.main.loadNibNamed("giveRate", owner: self, options: nil)?.first as! giveRate
                    popUpReview.frame = self.view.frame
                    popUpReview.providerId = idBusiness
                    popUpReview.businessName = businessName
                    view.addSubview(popUpReview)
                    
                    
        
                }
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
