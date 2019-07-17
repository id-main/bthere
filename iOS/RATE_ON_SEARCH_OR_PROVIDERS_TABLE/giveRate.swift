//
//  giveRate.swift
//  Bthere
//
//  Created by Iustin Bthere on 10/25/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class giveRate: UIView {
    @IBOutlet weak var oneStarImg: UIImageView!
    @IBOutlet weak var twoStarsImg: UIImageView!
    @IBOutlet weak var threeStarsImg: UIImageView!
    @IBOutlet weak var fourStarsImg: UIImageView!
    @IBOutlet weak var fiveStarsImg: UIImageView!
    @IBOutlet weak var oneStarBtn: UIButton!
    @IBOutlet weak var twoStarsBtn: UIButton!
    @IBOutlet weak var threeStarsBtn: UIButton!
    @IBOutlet weak var fourStarsBtn: UIButton!
    @IBOutlet weak var fiveStarsBtn: UIButton!
    @IBOutlet weak var titlePopUp: UILabel!
    @IBOutlet weak var remindMeBtn: UIButton!
    var providerId:Int = 0
    var businessName:String = ""
    var arrayStarsImages:Array<UIImageView> = Array<UIImageView>()
    var arrayStarsButtons:Array<UIButton> = Array<UIButton>()

    override func awakeFromNib() {
   
        arrayStarsImages = [oneStarImg, twoStarsImg, threeStarsImg, fourStarsImg, fiveStarsImg]
        arrayStarsButtons = [oneStarBtn, twoStarsBtn, threeStarsBtn, fourStarsBtn, fiveStarsBtn]
        
        for i in 0 ..< arrayStarsImages.count
        {
            arrayStarsImages[i].image = UIImage(named: "ratePopUpStarGrey.png")
        }
        
            for i in 0 ..< arrayStarsButtons.count
        {
            arrayStarsButtons[i].tag = i + 1
        }
        

        remindMeBtn.setTitle("REMIND_LATER_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
        
    
        
        //id-ul meu
        //Global.sharedInstance.providerID

        
    }

    override func didMoveToSuperview()
    {
        print("businessName in awake:\(businessName)")
        print("providerId in awake:\(providerId)")
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            if businessName != ""
            {
                titlePopUp.text = "ל " + businessName + " חשוב לדעת מה דעתך"
            }
            else
            {
                titlePopUp.text = "ל אתה חשוב לדעת מה דעתך"
            }
        }
        else // if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 1
        {
            if businessName != ""
            {
                titlePopUp.text = "It is important for " + businessName + " to know what you think"
            }
            else
            {
                titlePopUp.text = "It is important for you to know what you think "
            }
        }

        
    }
    
    
    

    @IBAction func rateItUp(_ sender: UIButton)
        
    {
        
            for i in 0..<sender.tag
        {
            arrayStarsImages[i].image = UIImage(named: "ratePopUpStar.png")
        }
        
        
        var myProviderId:Int = 0
        var notMyProviderId:Int = 0
        
        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0
        {
            //mine
            myProviderId =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
        }
        if providerId != 0
        {
            //not mine
            notMyProviderId = providerId
        }
        print("my provider iddd \(myProviderId)")
        print("not my provider iddd \(notMyProviderId)")
        
        
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            var dicSendToServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            if dicUserId["currentUserId"] as! Int != 0
            {
                print("providerId in request make: \(providerId)")
                self.disableBtns()
                var dicID:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                dicSendToServer["iCustomerUserId"] = dicID["currentUserId"]
                dicSendToServer["iProviderUserId"] = providerId as AnyObject
                
                api.sharedInstance.CheckCustomerReviewedProvider(dicSendToServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.enableBtns()
                    print("response send review \(String(describing: responseObject))")
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                
                                //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                            } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                ///////////////////////
                                
                                if let _ = RESPONSEOBJECT["Result"] as? Int
                                {
                                    if RESPONSEOBJECT["Result"] as! Int == 1
                                    {

                                        //added review already
                                        if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
                                        {
                                            //                                            self.generic.hideNativeActivityIndicator(self)
                                            
                                            if Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil
                                            {
                                                self.GetSupplierIdByEmployeeId(notMyProviderId, sender.tag, true)
                                            }
                                            else
                                            {
                                                self.updateReview(sender.tag)
                                            }
                                            
                                        }
                                        else
                                        {
                                            self.updateReview(sender.tag)
                                        }
                                        
                                        
                                        
                                    }
                                        
                                    else if notMyProviderId == 0
                                    {
                                        //not a valid business
                                        
                                        //                                            NotificationCenter.default.post(name: Notification.Name.UIKeyboardWillHide, object: nil)
//                                        Alert.sharedInstance.showAlertDelegate("NOT_A_VALID_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                        
                                        let alertController = UIAlertController(title: "NOT_A_VALID_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                                            "", preferredStyle: UIAlertController.Style.alert)
                                        alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                                            self.removeFromSuperview()
                                        })
                                                                                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                                    }
                                    else if myProviderId == notMyProviderId
                                    {
                                        
                                        let alertController = UIAlertController(title: "REVIEW_YOURSELF_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                                            "", preferredStyle: UIAlertController.Style.alert)
                                        alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                                            self.removeFromSuperview()
                                        })
                                                                                   self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                                    }
                                        
                                    else
                                    {
                                        if (sender.tag == 0) {
                                            let alertController = UIAlertController(title: "No_Rating".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                                                "Please_rate_the_business".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                                            
                                            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                                        }
                                           //e bine
                                        else
                                        {
                                            if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0
                                            {
                                                if Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil
                                                {
                                                    self.GetSupplierIdByEmployeeId(notMyProviderId, sender.tag, false)
                                                }
                                                else
                                                {
                                                    self.sendRatingAfterValidation(sender.tag)
                                                }
                                                
                                                
                                            }
                                            else
                                            {
                                                self.sendRatingAfterValidation(sender.tag)
                                            }
                                            
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                    }
                    
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.enableBtns()
                    let alertController = UIAlertController(title: "NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                        "", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                        self.removeFromSuperview()
                    })
                                                                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
//                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))

                    
                })
                
            }
        }
        
    }
    
    
    func sendRatingAfterValidation(_ tagg:Int)
    {
        print("Send review to server")
        var dicSendReviewToServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
            //                                                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            
            
            let alertController = UIAlertController(title: "NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                "", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                self.removeFromSuperview()
            })
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        else
        {
            if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
            {
                
                var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                if dicUserId["currentUserId"] as! Int != 0
                {
                    self.disableBtns()
                    dicSendReviewToServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                    dicSendReviewToServer["reviewText"] = "" as AnyObject
                    dicSendReviewToServer["rateStars"] = tagg as AnyObject
                    dicSendReviewToServer["iProviderUserId"] = self.providerId as AnyObject
                    
                    api.sharedInstance.sendRatingForBusiness(dicSendReviewToServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        self.enableBtns()
                        print("response send review \(String(describing: responseObject))")
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                    
                                    //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                                } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                                {
                                    //                                                                        Alert.sharedInstance.showAlertDelegate("SENT_REVIEW_SUCCESS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    let alertController = UIAlertController(title: "SENT_REVIEW_SUCCESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                                        "", preferredStyle: UIAlertController.Style.alert)
                                    alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                                        //  self.removeFromSuperview()
                                        self.gotorootandreload()
                                    })
                                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                                    
                                    
                                    
                                }
                            }
                        }
                        
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.enableBtns()
                        
                        //                                                            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        let alertController = UIAlertController(title: "NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                            "", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                            self.removeFromSuperview()
                        })
                        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                        
                    })
                    
                }
            }
        }
        // }
        
    }
    
    
    
    func GetSupplierIdByEmployeeId(_ notMyProviderID:Int,_ tagg:Int, _ forUpdate:Bool) {
//        self.generic.showNativeActivityIndicator(self)
//        Global.sharedInstance.whichReveal = true
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if dicUserId["currentUserId"] as! Int != 0
            {
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                api.sharedInstance.GetSupplierIdByEmployeeId(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        
                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                        {
                            let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                            print("sup id e ok ? " + myInt.description)
                            if myInt == 0
                            {
                                
                            } else
                            {
                                if notMyProviderID == myInt
                                {
                                    Alert.sharedInstance.showAlertDelegate("REVIEW_YOURSELF_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                                else
                                {
                                    if notMyProviderID == myInt
                                    {
                                        Alert.sharedInstance.showAlertDelegate("REVIEW_YOURSELF_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    }
                                    else
                                    {
                                        if forUpdate
                                        {
                                            self.updateReview(tagg)
                                        }
                                        else
                                        {
                                            self.sendRatingAfterValidation(tagg)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    
//                    self.generic.hideNativeActivityIndicator(self)
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    self.generic.hideNativeActivityIndicator(self)
                })
            }
        }
    }
    
    
    func updateReview(_ tagg:Int)
    {
        
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            var dicSendReviewToServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            if dicUserId["currentUserId"] as! Int != 0
            {
                self.disableBtns()
                dicSendReviewToServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                dicSendReviewToServer["reviewText"] = "" as AnyObject
                dicSendReviewToServer["rateStars"] = tagg as AnyObject
                dicSendReviewToServer["iProviderUserId"] = self.providerId as AnyObject
                
                api.sharedInstance.updateRatingForBusiness(dicSendReviewToServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.enableBtns()
                    print("response send review \(String(describing: responseObject))")
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                print("nu e bine")
                                //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                            } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                //                                                                        Alert.sharedInstance.showAlertDelegate("SENT_REVIEW_SUCCESS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                let alertController = UIAlertController(title: "SENT_REVIEW_SUCCESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                                    "", preferredStyle: UIAlertController.Style.alert)
                                alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                                    // self.removeFromSuperview()
                                    self.gotorootandreload()
                                })
                                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                                
                                
                                
                            }
                        }
                    }
                    
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.enableBtns()
                    
                    //                                                            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    let alertController = UIAlertController(title: "NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                        "", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                        self.removeFromSuperview()
                    })
                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                })
                
            }
        }
        
        
    }
    
    
    
    @IBAction func remindMeLater(_ sender: Any)
    {
        self.removeFromSuperview()
    }
    
    func enableBtns()
    {
        for i in 0 ..< 5
        {
            arrayStarsButtons[i].isUserInteractionEnabled = true
            remindMeBtn.isUserInteractionEnabled = true
        }
    }
    func disableBtns()
    {
        for i in 0 ..< 5
        {
            arrayStarsButtons[i].isUserInteractionEnabled = false
            remindMeBtn.isUserInteractionEnabled = false
        }
    }
    func gotorootandreload() {
        if let myViewController = parentViewController! as? SearchResultsViewController {
            print(myViewController.title ?? "SearchResultsViewController")
            self.removeFromSuperview()
            myViewController.reloadSearchresults()
        }
        else if let myViewController = parentViewController! as? entranceCustomerViewController
        {
            print(myViewController.title ?? "entranceCustomerViewController")
            self.removeFromSuperview()
            myViewController.getProvidersList()
//            myViewController.reloadSearchresults()
        }

    }
}
