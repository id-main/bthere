//
//  searchCollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 7.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

protocol getProviderServicesForSupplierDelegate {
    func getProviderServicesForSupplierFunc()
}

import UIKit

//part of search result - נווט, לדף העסק, הזמן
class searchCollectionViewCell: UICollectionViewCell,getProviderServicesForSupplierDelegate {
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var btnOpen: UIButton!
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var indexRow:Int = 0
    var pressedButton:Int =  0
    var generic:Generic = Generic()
    var bIsAproved:Int = 0
    var iSupplierStatus:Int = 0
    var iIsApprovedSupplier:Int = 0
    var nvsuppliernaame:String = ""
    //click on the cell (instead of didSelect)
    
    @IBAction func btnOpen(_ sender: AnyObject) {
        
        if self.iSupplierStatus == 0 || self.iSupplierStatus == 2  {
            let nameprovider = self.nvsuppliernaame
            let amessage = "ERROR_SUPPLIER_NOT_PAYED_ONE".localized(LanguageMain.sharedInstance.USERLANGUAGE) + nameprovider  + "ERROR_SUPPLIER_NOT_PAYED_TWO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            Alert.sharedInstance.showAlertDelegate(amessage)
            return
        }
        if pressedButton == 3//נווט
        {
            generic.showNativeActivityIndicator(Global.sharedInstance.searchResult!)
            Global.sharedInstance.isFromSearchResults = true
            
            Global.sharedInstance.providerID = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber as! Int)
            
            var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            
            dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iProviderId"] = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber as! Int) as AnyObject
            
            //קבלת נתונים לדף פרופיל העסק
            api.sharedInstance.GetProviderProfile(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("lat long \(String(describing: RESPONSEOBJECT["Result"]))")
                    //\\TO DO
                    let dic:Dictionary<String,AnyObject> =
                        RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                    
                    let providerBuisnessProfile:AddProviderBusinessProfile = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                    if providerBuisnessProfile.nvLat == "" || providerBuisnessProfile.nvLong == "" {
                        
                        self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
                        Alert.sharedInstance.showAlertDelegate("WAZE_ADDRESS_CANT_GO".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    } else {
                        self.navigateToLatitude(toLatitude: Double(providerBuisnessProfile.nvLat)!, longitude: Double(providerBuisnessProfile.nvLong)!)
                        
                        
                        
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
            })
        }
        else if pressedButton == 2//לדף העסק
        {
            generic.showNativeActivityIndicator(Global.sharedInstance.searchResult!)
            Global.sharedInstance.isFromSearchResults = true
            
            Global.sharedInstance.providerID = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber as! Int)
            
            var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            
            dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iProviderId"] = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber as! Int) as AnyObject
            
            //קבלת נתונים לדף פרופיל העסק
            api.sharedInstance.GetProviderProfile(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    
                    if let _ =  RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                        let dic:Dictionary<String,AnyObject> =
                            RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                        
                        Global.sharedInstance.providerBusinessProfile = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                        print("crAAA \(Global.sharedInstance.dicResults.count)")
                        var businessname:String = ""
                        if  Global.sharedInstance.dicResults[self.indexRow]["nvProviderName"] != nil {
                            businessname = Global.sharedInstance.dicResults[self.indexRow]["nvProviderName"] as! String
                        }
                        Global.sharedInstance.viewCon2?.buisnessName = businessname
                        
                        Global.sharedInstance.viewCon2?.address = Global.sharedInstance.dicResults[self.indexRow]["nvAdress"]!.description
                        if Global.sharedInstance.dicResults[self.indexRow]["dRankAvg"] != nil
                        {
                            Global.sharedInstance.viewCon2?.mydRankAvg = Global.sharedInstance.dicResults[self.indexRow]["dRankAvg"]?.stringValue as! String
                        }
                        
                        if Global.sharedInstance.dicResults[self.indexRow]["iRankCount"] != nil
                        {
                            Global.sharedInstance.viewCon2?.myiRankCount = String(Global.sharedInstance.dicResults[self.indexRow]["iRankCount"]?.stringValue as! String)
                        }
                        
                        Global.sharedInstance.viewCon2!.delegate = self
                        Global.sharedInstance.viewCon2!.currentProviderfromSearch = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                        Global.sharedInstance.searchResult?.present(Global.sharedInstance.viewCon2!, animated: true, completion: nil)
                        
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
            })
            
        }
        else if pressedButton == 1//הזמן
        {
            
            
            Global.sharedInstance.providerID = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber)
            //            continuetoscreensorpopup()
            GetCustomerActiveOrdersBySupplier()
            
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
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                print("response for GetProviderSettingsForCalendarmanagement \(responseObject ?? 1 as AnyObject)")
                if let _ = responseObject as? Dictionary<String,AnyObject> {
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
                
            })
        }
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
    
    func continuetoscreensorpopup(_ getbIsAproved:Int) {
        if getbIsAproved == 4 || getbIsAproved == 2  {
            if let myViewController = parentViewController! as? UIViewController {
                print(myViewController.title)
                myViewController.showthePopupDelegate()
            }
        } else {
            GetProviderSettingsForCalendarmanagementInSearchResults(_userstatus: getbIsAproved)
            //            getProviderServicesForSupplierFunc()
        }
    }
    
    func GetCustomerActiveOrdersBySupplier() {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var y:Int = 0
        if  Global.sharedInstance.currentUser.iUserId == 0 {
            var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
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
            })
        }
    }
    
    
    
    //func to get the provider free hours
    func getProviderServicesForSupplierFunc()
    {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        
        api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        Alert.sharedInstance.showAlertDelegate("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        
                        
                        if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                            let ps:objProviderServices = objProviderServices()
                            
                            self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            if self.ProviderServicesArray.count == 0
                            {
                                Alert.sharedInstance.showAlertDelegate("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else
                            {
                                Global.sharedInstance.viewCon!.ProviderServicesArray = self.ProviderServicesArray
                                Global.sharedInstance.viewCon!.indexRow = self.indexRow
                                let USERDEF = Global.sharedInstance.defaults
                                USERDEF.set(self.indexRow, forKey: "listservicesindexRow")
                                USERDEF.synchronize()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let frontviewcontroller:UINavigationController = UINavigationController()
                                frontviewcontroller.pushViewController(Global.sharedInstance.viewCon!, animated: false)
                                
                                //initialize REAR View Controller- it is the LEFT hand menu.
                                
                                let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                
                                let mainRevealController = SWRevealViewController()
                                
                                mainRevealController.frontViewController = frontviewcontroller
                                mainRevealController.rearViewController = rearViewController
                                
                                let window :UIWindow = UIApplication.shared.keyWindow!
                                window.rootViewController = mainRevealController
                                
                            }
                        }
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            
        })
        
    }
    
    func setDisplayData(_ image:String,text:String,index:Int, _indexrow:Int)
    {
        self.indexRow = _indexrow
        print("\(index) si \(indexRow)")
        lblText.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        btnOpen.layer.borderColor = UIColor.black.cgColor
        btnOpen.layer.borderWidth = 1
        pressedButton = index
        
        img.image = UIImage(named: image)
        lblText.text = text
        if let _ = Global.sharedInstance.dicResults[indexRow]["iSupplierStatus"] as? Int {
            self.iSupplierStatus = Global.sharedInstance.dicResults[indexRow]["iSupplierStatus"]! as! Int
        }
        
        
        if let _ =  Global.sharedInstance.dicResults[indexRow]["nvProviderName"] as? String {
            self.nvsuppliernaame =  Global.sharedInstance.dicResults[indexRow]["nvProviderName"] as! String
        }
        if let _ = Global.sharedInstance.dicResults[indexRow]["iIsApprovedSupplier"] as? Int {
            let myx =  Global.sharedInstance.dicResults[indexRow]["iIsApprovedSupplier"]  as! Int
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
        
        //        let aline:UIView = UIView()
        //        aline.backgroundColor = UIColor.blackColor()
        //        aline.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.height - 1, self.contentView.frame.size.width, 1)
        //        self.contentView.addSubview(aline)
        //        self.contentView.bringSubviewToFront(aline)
    }
    
    //func to move to waze site - to navigate
    
    //    func navigateToLatitude(toLatitude latitude: Double, longitude: Double) {
    //        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "waze://")!) {
    //            // Waze is installed. Launch Waze and start navigation
    //            let urlStr = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
    //            UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!, options: [:], completionHandler: {
    //                (success) in
    //                  print("succes open settings")
    //            })
    //        }
    //        else {
    //            // Waze is not installed. Launch AppStore to install Waze app
    //            UIApplication.sharedApplication().openURL(NSURL(string: "http://itunes.apple.com/us/app/id323229106")!, options: [:], completionHandler: {
    //                (success) in
    //                  print("succes open settings")
    //            })
    //        }
    //    }
    func navigateToLatitude(toLatitude latitude: Double, longitude: Double) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            // Waze is installed. Launch Waze and start navigation
            let urlStr = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
            if #available(iOS 10, *)
            {
                
                UIApplication.shared.open(URL(string: urlStr)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: {
                    (success) in
                    print("succes open settings")
                })
            } else {
                let wazeUrl = URL(string: urlStr)
                UIApplication.shared.openURL(wazeUrl!)
            }
        }
        else {
            // Waze is not installed. Launch AppStore to install Waze app
            if #available(iOS 10, *)
            {
                
                UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: {
                    (success) in
                    print("succes open settings")
                })
            } else {
                let MYitunesURL = URL(string: "http://itunes.apple.com/us/app/id323229106")
                UIApplication.shared.openURL(MYitunesURL!)
            }
        }
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
