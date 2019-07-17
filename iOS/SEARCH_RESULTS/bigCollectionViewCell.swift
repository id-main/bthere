
//
//  bigCollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 7.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Font_Awesome_Swift

class bigCollectionViewCell: UICollectionViewCell {
    // Outlets
    @IBOutlet weak var ratePopUpBtn: UIButton!
    @IBOutlet weak var btnOpenBusinessBigcell: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBlack: UIView!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var imgWaze: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblNumKM: UILabel!
    @IBOutlet weak var lblKMFromYou: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRating2: UILabel!
    @IBOutlet weak var lblRating3: UILabel!
    @IBOutlet weak var lblRating4: UILabel!
    @IBOutlet weak var lblRating5: UILabel!
    @IBOutlet weak var lblNumRuting: UILabel!
    @IBOutlet weak var lblNumVoters: UILabel!
    @IBOutlet weak var lblVoters: UILabel!
    var counterRank:Int = 0
    var iIsApprovedSupplier:Int = 0
    var starsarray:Array<Bool> = [false, false, false, false, false]
    var iSupplierStatus:Int = 0
    var nvsuppliernaame:String = ""
    var nvSupplierID:Int = 0
    // Variables
    var indexRow:Int = 0
    //@IBOutlet weak var lblRating2: UILabel!
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var storyboard1 = UIStoryboard(name: "Main", bundle: nil)
    //    var popUpReview:giveRate! = giveRate()
    var bIsAproved:Int = 0
    @IBOutlet weak var openBusinessProfileBtn: UIButton!
    var generic:Generic = Generic()
    var nvAddressForBusiness:String = ""
    var iRankCountForBusinessProfile:String = ""
    @IBOutlet weak var openBusinessProfileFromSearch: UIButton!
    @IBOutlet weak var infoView: UIView!
    var activityIndicatorView:UIActivityIndicatorView = UIActivityIndicatorView()
    var viewForIndicator: UIView = UIView()
    
    override func awakeFromNib() {
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            lblCity.textAlignment = .right
        }
        else // if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 1
        {
            lblCity.textAlignment = .left
        }
    }
    
    @IBAction func openBusinessFromSearch(_ sender: UIButton)
    {
        Global.sharedInstance.providerID = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber as! Int)
        
        self.generic.showNativeActivityIndicator(Global.sharedInstance.searchResult!)
        Global.sharedInstance.isFromSearchResults = true
        var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iProviderId"] = nvSupplierID as AnyObject
        
        //קבלת נתונים לדף פרופיל העסק
        api.sharedInstance.GetProviderProfile(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                
                if let _ =  RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                    let dic:Dictionary<String,AnyObject> =
                        RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                    
                    Global.sharedInstance.providerBusinessProfile = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                    if let _ = self.lblName.text
                    {
                        Global.sharedInstance.viewCon2?.buisnessName = self.lblName.text!
                    }
                    
                    Global.sharedInstance.viewCon2?.address = self.nvAddressForBusiness
                    if let _ = self.lblNumRuting.text
                    {
                        Global.sharedInstance.viewCon2?.mydRankAvg = self.lblNumRuting.text!
                    }
                    
                    if let _ = self.lblNumVoters.text
                    {
                        Global.sharedInstance.viewCon2?.myiRankCount = self.iRankCountForBusinessProfile
                    }
                    if let myViewController = self.parentViewController! as? UIViewController
                    {
                        myViewController.view.endEditing(true)
                        
                    }
                    
                    Global.sharedInstance.viewCon2!.iSupplierStatusVC = self.iSupplierStatus
                    
                    
                    Global.sharedInstance.viewCon2!.currentProviderfromSearch = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                    Global.sharedInstance.searchResult?.present(Global.sharedInstance.viewCon2!, animated: true, completion: nil)
                    
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
        })
    }
    
    
    func continuetoscreensorpopup(_ getbIsAproved:Int) {
        if getbIsAproved == 4 || getbIsAproved == 2  {
            
            if let myViewController = parentViewController! as? UIViewController {
                print(myViewController.title ?? "")
                myViewController.showthePopupDelegate()
            }
        } else {

                self.GetProviderSettingsForCalendarmanagementInSearchResults(_userstatus: getbIsAproved)
           

            //            getProviderServicesForSupplierFunc()
        }
    }
    
    func GetCustomerActiveOrdersBySupplier() {
        
        var viewCon:UIViewController = UIViewController()
        if let myViewController = self.parentViewController! as? UIViewController
        {
            viewCon = myViewController
            self.generic.showNativeActivityIndicator(viewCon)
            
        }
        
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var y:Int = 0
        if  Global.sharedInstance.currentUser.iUserId == 0 {
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        } else {
          y = Global.sharedInstance.currentUser.iUserId 
        }

        dicSearch["iCustomerUserId"] = y as AnyObject
        dicSearch["iSupplierId"] = Global.sharedInstance.providerID as AnyObject
        print("aicie \(Global.sharedInstance.providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            self.generic.hideNativeActivityIndicator(viewCon)
        }
        else
        {
            api.sharedInstance.GetCustomerActiveOrdersBySupplier(dicSearch,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                print("response for GetCustomerActiveOrdersBySupplier \(String(describing: responseObject))")
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if  let _ = RESPONSEOBJECT["Result"] as? Int {
                                let possiblerezult = RESPONSEOBJECT["Result"] as! Int
                                self.bIsAproved = possiblerezult
                                self.continuetoscreensorpopup(self.bIsAproved )
                            }
                        } else {
                            //error user not found
                            self.bIsAproved = 0
                            self.continuetoscreensorpopup(self.bIsAproved)
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                //                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                self.bIsAproved = 0
                self.continuetoscreensorpopup(self.bIsAproved)
                self.generic.hideNativeActivityIndicator(viewCon)
            })
            
            self.generic.hideNativeActivityIndicator(viewCon)
        }
    }
    
    func GetProviderSettingsForCalendarmanagementInSearchResults(_userstatus: Int)
    {
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        var viewCon:UIViewController = UIViewController()
        if let myViewController = self.parentViewController! as? UIViewController
        {
            viewCon = myViewController
            self.generic.showNativeActivityIndicator(viewCon)

        }



        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                  self.generic.hideNativeActivityIndicator(viewCon)
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                print("response for GetProviderSettingsForCalendarmanagement \(responseObject ?? 1 as AnyObject)")
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                     self.generic.hideNativeActivityIndicator(viewCon)
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                let possiblerezult:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                print ("possible rezult: \(possiblerezult)")
                                if let _ = possiblerezult["bIsAvailableForNewCustomer"] as? Bool
                                {
                                    let isAvailable:Bool = possiblerezult["bIsAvailableForNewCustomer"] as! Bool
                                    if isAvailable == false
                                    {
                                        if _userstatus == 1 {
                                            self.getProviderServicesForSupplierFunc()
                                        } else {
                                            self.sendApprovalRequest()
                                        }
                                    }
                                    else if isAvailable == true
                                    {
                                        self.getProviderServicesForSupplierFunc()
                                    }
                                }
                                    //hard coded iustin
                                else
                                {
                                    self.getProviderServicesForSupplierFunc()
                                }
                                
                            }
                        } else {
                            //user was not found
                            //                            self.SETUPDEFAULTSINCASEOFFAILURE()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                 self.generic.hideNativeActivityIndicator(viewCon)
                
            })
        }
    }
    
    
    @IBAction func openBusinessProfileAction(_ sender: UIButton)
    {
        Global.sharedInstance.providerID = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber as! Int)
        
        self.generic.showNativeActivityIndicator(Global.sharedInstance.giveMyServicesForBusinessProfile!)
        Global.sharedInstance.isFromSearchResults = false

        //            Global.sharedInstance.providerID = Int(Global.sharedInstance.dicResults[self.index]["iProviderId"]! as! NSNumber)

        var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

        dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iProviderId"] = nvSupplierID as AnyObject

        //קבלת נתונים לדף פרופיל העסק
        api.sharedInstance.GetProviderProfile(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            self.generic.hideNativeActivityIndicator(Global.sharedInstance.entranceCustomer!)
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                if let _ =  RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                    let dic:Dictionary<String,AnyObject> =
                        RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>

                    Global.sharedInstance.providerBusinessProfile = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                    if let _ = self.lblName.text
                    {
                        Global.sharedInstance.viewCon2?.buisnessName = self.lblName.text!
                    }

                    Global.sharedInstance.viewCon2?.address = self.nvAddressForBusiness
                    if let _ = self.lblNumRuting.text
                    {
                        Global.sharedInstance.viewCon2?.mydRankAvg = self.lblNumRuting.text!
                    }

                    if let _ = self.lblNumVoters.text
                    {
                        Global.sharedInstance.viewCon2?.myiRankCount = self.iRankCountForBusinessProfile
                    }
                    
                    Global.sharedInstance.viewCon2!.iSupplierStatusVC = self.iSupplierStatus

                    Global.sharedInstance.viewCon2!.currentProviderfromSearch = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                    Global.sharedInstance.giveMyServicesForBusinessProfile?.present(Global.sharedInstance.viewCon2!, animated: true, completion: nil)

                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            self.generic.hideNativeActivityIndicator(Global.sharedInstance.giveMyServicesForBusinessProfile!)
        })
    }
    
    
    func sendApprovalRequest()
    {
        
        
        var y = 0
        var dicSendApproval:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if  Global.sharedInstance.currentUser.iUserId == 0 {
            if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
            }
        } else {
            y = Global.sharedInstance.currentUser.iUserId
        }


        dicSendApproval["iCustomerUserId"] = y as AnyObject
        dicSendApproval["iSupplierId"] = Global.sharedInstance.providerID as AnyObject

        if Reachability.isConnectedToNetwork() == false
        {
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.SendApprovalRequest(dicSendApproval, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                print("response for SendApprovalRequest \(responseObject ?? 1 as AnyObject)")
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3

                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let possiblerezult:Int = RESPONSEOBJECT["Result"] as! Int
                                if possiblerezult == 1
                                {
                                    if let myViewController = self.parentViewController! as? UIViewController
                                    {
                                        print(myViewController.title)
                                        myViewController.showthePopupDelegate()
                                    }
                                }
                            }
                        } else {
                            if let myViewController = self.parentViewController! as? UIViewController
                            {
                                print(myViewController.title)
                                myViewController.showthePopupDelegate()
                            }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in

                if let myViewController = self.parentViewController! as? UIViewController
                {
                    print(myViewController.title)
                    myViewController.showthePopupDelegate()
                }

            })
        }
    }
    
    
    @IBAction func btnOpenBusiness(_ sender: AnyObject) {
        // ListServicesViewController
      //  btnOpenBusinessBigcell.isUserInteractionEnabled = false
        var viewCon:UIViewController = UIViewController()
        if let myViewController = self.parentViewController! as? UIViewController
        {
            viewCon = myViewController
            self.generic.showNativeActivityIndicator(viewCon)
            
        }
        
        if self.iSupplierStatus == 0  || self.iSupplierStatus == 2   {
            let nameprovider = self.nvsuppliernaame
            let amessage = "ERROR_SUPPLIER_NOT_PAYED_ONE".localized(LanguageMain.sharedInstance.USERLANGUAGE) + nameprovider  + "ERROR_SUPPLIER_NOT_PAYED_TWO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            Alert.sharedInstance.showAlertDelegate(amessage)
            self.generic.hideNativeActivityIndicator(viewCon)
         //   btnOpenBusinessBigcell.isUserInteractionEnabled = true
            return
        }
        
        Global.sharedInstance.providerID = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber as! Int)
        Global.sharedInstance.viewCon!.indexRow = indexRow
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(self.indexRow, forKey: "listservicesindexRow")
        USERDEF.synchronize()
        self.generic.hideNativeActivityIndicator(viewCon)
        GetCustomerActiveOrdersBySupplier()
        
    }
    
    
    func getProviderServicesForSupplierFunc() {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        
        var viewCon:UIViewController = UIViewController()
        if let myViewController = self.parentViewController! as? UIViewController
        {
            viewCon = myViewController
            self.generic.showNativeActivityIndicator(viewCon)
            
        }
        
        api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
            print("response for GetCustomerActiveOrdersBySupplier \(String(describing: responseObject))")
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if (RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3) {
                        Alert.sharedInstance.showAlertDelegate("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    } else if (RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1) {
                        if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                            let ps:objProviderServices = objProviderServices()
                            self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            
                            if (self.ProviderServicesArray.count == 0) {
                                Alert.sharedInstance.showAlertDelegate("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            } else {
                                Global.sharedInstance.viewCon!.ProviderServicesArray = self.ProviderServicesArray
                                let frontviewcontroller:UINavigationController = UINavigationController()
                                frontviewcontroller.pushViewController(Global.sharedInstance.viewCon!, animated: false)
                                let rearViewController = self.storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                let mainRevealController = SWRevealViewController()
                                mainRevealController.frontViewController = frontviewcontroller
                                mainRevealController.rearViewController = rearViewController
                                let window :UIWindow = UIApplication.shared.keyWindow!
                                window.rootViewController = mainRevealController
//                                self.hideNativeActivityIndicator(self.infoView)
                                
                            }
                        }
                    }
                }
                self.generic.hideNativeActivityIndicator(viewCon)
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            self.hideNativeActivityIndicator(self.infoView)
            self.generic.hideNativeActivityIndicator(viewCon)
        })
    }
    
    func bettercode() {
        var CEVA:Array<UILabel> = Array<UILabel>()
        CEVA.append(lblRating)
        CEVA.append(lblRating2)
        CEVA.append(lblRating3)
        CEVA.append(lblRating4)
        CEVA.append(lblRating5)
        for item in CEVA {
            let indexofitem = CEVA.index(of: item)
            if starsarray[indexofitem!] == false {
                item.setFAText("",icon: FAType.faStarO, postfixText: "", size: 8)
            } else {
                item.setFAText("",icon: FAType.faStar, postfixText: "", size: 8)
            }
        }
    }
    func setDisplayData(_ result:Dictionary<String,AnyObject>) {
        self.bringSubviewToFront(viewBlack)
        lblName.text = result["nvProviderName"]?.description
        if let _ = result["iProviderId"] as? Int
        {
            nvSupplierID = result["iProviderId"] as! Int
        }
        self.nvsuppliernaame = lblName.text!
        //\\  print("distance at search results: \(String(describing: result.description))")
        if (result["iDistance"]?.description != "-1")
        {
            if let _:Float = result["iDistance"] as? Float
            {
                lblCity.text = "\(String(format: "%.1f", (result["iDistance"] as! Float))) km"
            }
            else if let _:Double = result["iDistance"] as? Double
            {
                lblCity.text = "\(String(format: "%.1f", (result["iDistance"] as! Double))) km"
            }
            
            //commit comment
        }
        else
        {
            lblCity.text = "0 km"
        }
        
        if var str :String = result["nvCity"] as? String
        {
            if let dotRange = str.range(of: ",") {
                str.removeSubrange(dotRange.lowerBound..<str.endIndex)
            }
            print("log string \(str)")
            lblNumKM.text = str
        }
        
        if let floatRank:Double = result["dRankAvg"] as? Double
            
        {
            lblNumRuting.text = String(floatRank)

        }
        else if let floatRank:Float = result["dRankAvg"] as? Float
        {
            lblNumRuting.text = String(floatRank)
        }
        else
        {
            lblNumRuting.text = "0.0"
        }
        
        if let numberReviews:Int = result["iRankCount"] as? Int
        {
            if numberReviews == 1
            {
                lblNumVoters.text = String(numberReviews) + " " + "REVIEWS_LABEL_SINGULAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            }
            else
            {
                lblNumVoters.text = String(numberReviews) + " " + "REVIEWS_LABEL_PLURAL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            }
            iRankCountForBusinessProfile = String(numberReviews)
            
        }
        
        //"ERROR_SUPPLIER_NOT_PAYED_ONE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        // old Rating
        //        if (result["IInternalRank"]?.description == "0") {
        //            // 0
        //            lblNumRuting.text = "0"
        //            starsarray = [false, false, false, false, false]
        //            bettercode()
        //            // Set stars rating
        //
        //        } else if (result["IInternalRank"]?.description == "1") {
        //            // 1
        //            lblNumRuting.text = "1"
        //            starsarray = [true, false, false, false, false]
        //
        //            // Set stars rating
        //            bettercode()
        //        } else if (result["IInternalRank"]?.description == "2") {
        //            // 2
        //            lblNumRuting.text = "2"
        //            starsarray = [true, true, false, false, false]
        //            // Set stars rating
        //            bettercode()
        //        } else if (result["IInternalRank"]?.description == "3") {
        //            // 3
        //            lblNumRuting.text = "3"
        //            starsarray = [true, true, true, false, false]
        //            // Set stars rating
        //            bettercode()
        //        } else if (result["IInternalRank"]?.description == "4") {
        //            // 4
        //            lblNumRuting.text = "4"
        //              starsarray = [true, true, true, true, false]
        //            // Set stars rating
        //            bettercode()
        //        } else {
        //            // 5
        //            lblNumRuting.text = "5"
        //               starsarray = [true, true, true, true, true]
        //            // Set stars rating
        //            bettercode()
        //        }
        if let _:Int = result["iSupplierStatus"] as? Int {
            self.iSupplierStatus = result["iSupplierStatus"] as! Int
        }
        if let _:Int =  result["iIsApprovedSupplier"] as? Int {
            let myx =  result["iIsApprovedSupplier"] as! Int
            switch (myx) {
                //            100 - nu are relatie cu supplier-ul
                //            0/4 - a facut o comanda catre supplier (pending request)
                //            1 - a fost aprobat de supplier
            //            2 - a fost respins de supplier
            case 0 :
                self.contentView.alpha = 0.6
            case 100:
                self.contentView.alpha = 1
            case 1:
                self.contentView.alpha = 1
            case 2:
                self.contentView.alpha = 0.6
            case 4:
                self.contentView.alpha = 0.6
            default:
                print("myx")
            }
            iIsApprovedSupplier = myx
            
        }
        if self.iSupplierStatus == 0 || self.iSupplierStatus == 2 {
            self.contentView.alpha = 0.6
        }
        
        //        lblNumVoters.text = result["iCustomerRank"]?.description
        
        var dataDecoded:Data = Data(base64Encoded: (result["nvProviderHeader"]?.description)!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        var decodedimage:UIImage = UIImage()
        
        if (UIImage(data: dataDecoded) != nil) {
            decodedimage = UIImage(data: dataDecoded)!
            imgImage.image = decodedimage
        } else {
            //   imgImage.image = UIImage(named: "IMG_05072016_131013.png") cover_pic.jpg
            imgImage.image = UIImage(named: "cover_pic.jpg")
        }
        
        dataDecoded = Data(base64Encoded: (result["nvProviderLogo"]?.description)!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        
        if (UIImage(data: dataDecoded) != nil) {
            decodedimage = UIImage(data: dataDecoded)!
        }
        
        //iustin calculate stars
        self.calculateStars(result)
    }
    
    func calculateStars(_ result:Dictionary<String,AnyObject>)
    {
        if let floatRank =  result["dRankAvg"]
        {
            if let floatValue = floatRank.floatValue
            {
                print("float value \(floatRank)")
                if floatValue == 0
                {
                    lblRating.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating2.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating3.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating4.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating5.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                }
                else if floatValue > 0 && floatValue < 1.6
                {
                    lblRating.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating2.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating3.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating4.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating5.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                }
                else if floatValue >= 1.6 && floatValue < 2.6
                {
                    lblRating.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating2.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating3.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating4.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating5.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                }
                else if floatValue >= 2.6 && floatValue < 3.6
                {
                    lblRating.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating2.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating3.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating4.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                    lblRating5.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                }
                else if floatValue >= 3.6 && floatValue < 4.6
                {
                    lblRating.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating2.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating3.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating4.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating5.setFAText("", icon: FAType.faStarO, postfixText: "", size: 8)
                }
                else
                {
                    lblRating.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating2.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating3.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating4.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                    lblRating5.setFAText("", icon: FAType.faStar, postfixText: "", size: 8)
                }
            }
            
            
        }
        
    }
    
    

    
    
    @IBAction func loadPopUpStars(_ sender: Any)
    {
//        print("provider id: \(nvSupplierID) + supplierName: \(self.nvsuppliernaame)")
        
        if self.iSupplierStatus == 0  || self.iSupplierStatus == 2
        {
            let nameprovider = self.nvsuppliernaame
            let amessage = "ERROR_SUPPLIER_NOT_PAYED_ONE".localized(LanguageMain.sharedInstance.USERLANGUAGE) + nameprovider  + "ERROR_SUPPLIER_NOT_PAYED_TWO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            Alert.sharedInstance.showAlertDelegate(amessage)
        }
        else
        {
            if let myViewController = parentViewController! as? UIViewController
            {
                myViewController.rateBusiness(idBusiness:nvSupplierID, businessName:self.nvsuppliernaame)
            }
        }
        
        
        
    }
    
    
}
