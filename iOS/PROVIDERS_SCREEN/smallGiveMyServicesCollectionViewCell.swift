//
//  smallGiveMyServicesCollectionViewCell.swift
//  Bthere
//
//  Created by User on 25.8.2016.
//  Copyright © 2016 Webit. All rights reserved.

import UIKit

class smallGiveMyServicesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var btnOpen: UIButton!
    
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var indexRow:Int = 0//הסקשין של השורה
    var coll:UICollectionView?
    var pressedButton:Int =  0
    var delegateDeleteItem:deleteItemDelegate!=nil
    var delegateCloseCollection:closeCollectionDelegate!=nil
    var generic:Generic = Generic()
    var bIsAproved:Int = 0
    var iSupplierStatus:Int = 0
    var nvsuppliernaame:String = ""
    @IBAction func btnOpen(_ sender: AnyObject) {
        if self.iSupplierStatus == 0 || self.iSupplierStatus == 2  {
            let nameprovider = self.nvsuppliernaame
            let amessage = "ERROR_SUPPLIER_NOT_PAYED_ONE".localized(LanguageMain.sharedInstance.USERLANGUAGE) + nameprovider  + "ERROR_SUPPLIER_NOT_PAYED_TWO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            Alert.sharedInstance.showAlertDelegate(amessage)
            return
        }
        if pressedButton == 1//מחק
        {
            // Create the alert controller
            //  let alertController = UIAlertController(title: "MESSAGE_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE), message: "DELETE_GIVE_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .Alert)
            let alertController = UIAlertController(title: "", message: "DELETE_GIVE_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: "YES".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.delegateCloseCollection.closeCollection(self.coll!)
                
                Global.sharedInstance.isDeletedGiveMyService = false
                
                //מחיקת הנותן שרות מהמערך
                self.delegateDeleteItem.deleteItem(self.indexRow)
            }
            let cancelAction = UIAlertAction(title: "NO".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            Global.sharedInstance.giveMyServices!.present(alertController, animated: true, completion: nil)
        } else if (pressedButton == 2) {
            
            
            
            
            
            var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iProviderId"] = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber as! Int) as AnyObject
            
            api.sharedInstance.GetProviderProfile(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                let dic:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                let providerBusinessProfile:AddProviderBusinessProfile = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                
                if (Global.sharedInstance.searchResult != nil) {
                    self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
                }
                
                if (providerBusinessProfile.nvCity == "" || providerBusinessProfile.nvCity == "") {
                    if Global.sharedInstance.searchResult != nil {
                        self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
                    }
                    
                    Alert.sharedInstance.showAlertDelegate("WAZE_ADDRESS_CANT_GO".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                } else {
                    let wazeAPP:String = "waze://"
                    let wazeURL = URL(string: wazeAPP)
                    let businessAddress = Global.sharedInstance.dicResults[self.indexRow]["nvAdress"]!
                    
                    print("businessAddress: \(businessAddress)")
                    
                    let strinAddress = "\(businessAddress),\(providerBusinessProfile.nvCity)"
                    
                    if UIApplication.shared.canOpenURL(wazeURL!) {
                        let wazeHook:String = "\(strinAddress)"
                        let allowedQueryParamAndKey =  CharacterSet(charactersIn: ";/?:@&=+$, ").inverted
                        let cleanstring:String =  wazeHook.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)!
                        
                        print("This is waze: \(cleanstring)")
                        if cleanstring.count > 0 {
                            UIApplication.shared.openURL(URL(string: "waze://?q=" + cleanstring)!)
                        } else {
                            Alert.sharedInstance.showAlertDelegate("BUSINESS_PROFILE_ALERT_NO_LOCATION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    } else {
                        // Redirec to get Wazess
                        UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
                    }
                }
                
                if Global.sharedInstance.searchResult != nil {
                    self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
                }
                    }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    if Global.sharedInstance.searchResult != nil {
                        self.generic.hideNativeActivityIndicator(Global.sharedInstance.searchResult!)
                    }
                    
            })
        }
        else if pressedButton == 3//הזמן
        {
            Global.sharedInstance.providerID = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber)
            GetCustomerActiveOrdersBySupplier()
        }
    }
    func continuetoscreensorpopup(_ getbIsAproved:Int) {
        if getbIsAproved == 4 || getbIsAproved == 2  {
            if let myViewController = parentViewController! as? UIViewController {
                print(myViewController.title)
                myViewController.showthePopupDelegate()
            }
        } else {
            getProviderServicesForSupplierFunc()
        }
    }
    
    func GetCustomerActiveOrdersBySupplier() {
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
        }
        else
        {
            api.sharedInstance.GetCustomerActiveOrdersBySupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
//                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    self.bIsAproved = 0
                    self.continuetoscreensorpopup(self.bIsAproved)
            })
        }
    }

    
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
        print(indexRow)
        self.indexRow = _indexrow
        btnOpen.layer.borderColor = UIColor.black.cgColor
        btnOpen.layer.borderWidth = 1
        pressedButton = index
        
        img.image = UIImage(named: image)
        lblText.text = text
        if let _ = Global.sharedInstance.dicResults[indexRow]["iSupplierStatus"] as? Int {
        self.iSupplierStatus =  Global.sharedInstance.dicResults[indexRow]["iSupplierStatus"] as! Int
           
        }
        if let _ =  Global.sharedInstance.dicResults[indexRow]["nvProviderName"] as? String {
            self.nvsuppliernaame =  Global.sharedInstance.dicResults[indexRow]["nvProviderName"] as! String
        }
    }
    /*
     if #available(iOS 10, *)
     {
     if let url = settingsUrl
     {
     UIApplication.sharedApplication().openURL(url, options: [:], completionHandler: {
     (success) in
     })
     }
     }
     else
     {
     if let url = settingsUrl {
     UIApplication.sharedApplication().openURL(url)
     Global.sharedInstance.isSettingsOpen = true
     }
     }
     
     */
    
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
