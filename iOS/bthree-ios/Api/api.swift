//
//  api.swift
//  Bthere
//  Created by User on 21.2.2016.
//
//  Converted to Swift 3.x - clean by Ungureanu Ioan 16/04/2018
//  Copyright © 2018 Bthere. All rights reserved. 

import UIKit

class api: NSObject
{
    static let sharedInstance = api()
    var isemploye:Bool = false          //   is  employe
    var ismanager:Bool = false          //   is employe and manager
    var issimpleCustomer:Bool = true    //   is simple customer               
    var providerID:Int = 0
    var generic:Generic = Generic()
    var view8 : loadingBthere?
    var keyserver = ""
    var WITCHDOMAIN:Int32 = 0// 0 is dev, 1 is qa, 2 is live
    var url:String = ""

    //NEW NEW NEW SERVER SSL remember cer from server must be converted in order to work in iOS openssl x509 -in ServerCertificate.cer -out bthere.cer -outform der
    /*
     AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
     manager.securityPolicy = policy;
     
     // optional
     NSString *pathToCert = [[NSBundle mainBundle]pathForResource:@"github.com" ofType:@"cer"];
     NSData *localCertificate = [NSData dataWithContentsOfFile:pathToCert];
     manager.securityPolicy.pinnedCertificates = @[localCertificate];
     
     */
    
    //QA NOT WORKING
    //    var url:  String  = "http://qa.bthere-tech.com:35981/BThereWS_QA/BTWS.svc/"
    //
    //TestFlight (QA) adress: QA will be environment similar to production   19.02.2018
    // var url: String = "http://94.177.39.140:35981/BThereWS_QA/BTWS.svc/"
    //LIVE PUBLISH APPLE
    //var url: String = "https://app.bthere-tech.com:35982/BThereWS_QA/BTWS.svc/"
    //v2 server ready for AppStore
    // var url: String = "https://app.bthere-tech.com:35982/BThereWS_QA_V2/BTWS.svc/"
    
    //V3 SERVER FOR APP STORE LAST
    //   var url: String = "https://app.bthere-tech.com:35982/BThereWS_QA_V3/BTWS.svc/"
    //dev
    // var url: String = "http://94.177.39.140:35981/BThereWS/BTWS.svc/"
   
    let manager = AFHTTPRequestOperationManager()
    let managerTRANZILA = AFHTTPRequestOperationManager()
    typealias successBlock = (AFHTTPRequestOperation? , Any?)-> Void
    typealias failureBlock = (AFHTTPRequestOperation? , Error?) ->Void
   
    override init()
    {
        if self.WITCHDOMAIN == 0 {  //new dev
            // url = "http://62.4.14.152:35955/DEV/BTWS.svc/"
            url = "https://dev.bthere-tech.com:35958/dev/BTWS.svc/"
        } else if  self.WITCHDOMAIN == 1 {  //new qa
           //  url = "http://62.4.14.152:35955/QA/BTWS.svc/"
             url = "https://qa.bthere-tech.com:35957/qa/BTWS.svc/"
        } else if  self.WITCHDOMAIN == 2 {  //live
           //old v.2.2 in App Store  url = "https://app.bthere-tech.com:35982/BThereWS_QA_V3/btws.svc/"
            //v.4.0 in App Store
            //  url =   "https://app.bthere-tech.com:35982/BThereWS_QA/btws.svc/"
            //v.4.4 in App Store
          url =   "https://app.bthere-tech.com:35982/BThereWS_QA_V2/BTWS.svc/"
            //v.4.5 in App Store
//             url =   "https://app.bthere-tech.com:35982/BThereWS_QA/btws.svc/"
//            url =   "https://app.bthere-tech.com:35982/BThereWS_QA_V2/BTWS.svc/"
        }
      // url = "http://94.177.39.140:35981/BThereWS/BTWS.svc/"
        let ABTESTINGX = CheamaIOSObject()
        let securityPolicy = ABTESTINGX.customSecurityPolicy(self.WITCHDOMAIN)
        manager.securityPolicy = securityPolicy!
        manager.securityPolicy.pinnedCertificates = ABTESTINGX.cerlocal(self.WITCHDOMAIN)
        manager.securityPolicy.allowInvalidCertificates = false // true is not recommended for production
        manager.securityPolicy.validatesDomainName = true
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        //  manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions.allowFragments) as AFJSONResponseSerializer
        manager.requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>
        
        managerTRANZILA.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        managerTRANZILA.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav","application/x-www-form-urlencoded") as Set<NSObject>
        managerTRANZILA.requestSerializer.timeoutInterval = 120
        managerTRANZILA.responseSerializer = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions.allowFragments) as AFJSONResponseSerializer
        managerTRANZILA.requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer
    }
    
    func buildUrl(_ path:String)->String
    {
        let pathUrl:String = url + path
        return pathUrl
    }
    
    func setupfinale(_ employeismanager: Int) {
        if employeismanager == 0 {
            self.ismanager = false
            Global.sharedInstance.defaults.set(0, forKey: "ismanager") //false
        } else{
            self.ismanager = true
            Global.sharedInstance.defaults.set(1, forKey: "ismanager") //true
        }
        tryGetSupplierCustomerUserIdByEmployeeId()
    }
    
    func tryGetSupplierCustomerUserIdByEmployeeId() {           // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
        var y:Int = 0
        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        dicuser["iUserId"] =  y as AnyObject
        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject>  {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                {
                    let myInt :Int = RESPONSEOBJECT["Result"] as! Int
                    print("sup id e ok ? " + myInt.description)
                    if myInt == 0 {
                        print ("no business")
                    } else {
                        self.GetSecondUserIdByFirstUserId(y)
                        self.callgetprovideralldetails(myInt)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
        })
    }
    
    func callgetprovideralldetails(_ iUseridSupplier:Int) {
        api.sharedInstance.getProviderAllDetailsbyEmployeID(iUseridSupplier)
    }
    
    func trytogetProviderdata() {           // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
        //check if is customer, worker or manager
        if Global.sharedInstance.providerID == 0 {
            if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
            {
                var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                if dicUserId["currentUserId"] as! Int != 0
                {
                    var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                    dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                    api.sharedInstance.GetSupplierIdByEmployeeId(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject>  {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {
                                let myInt :Int = RESPONSEOBJECT["Result"] as! Int
                                print("sup id e ok ? " + myInt.description)
                                if myInt == 0 {
                                    //NO EMPL NO BUSINESS
                                    self.setupdefaults(0)
                                } else {
                                    self.setupdefaults(myInt)
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        if AppDelegate.showAlertInAppDelegate == false
//                        {
//                            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            AppDelegate.showAlertInAppDelegate = true
//                        }
                    })
                }
            }
        } else {
            self.setupdefaults(Global.sharedInstance.providerID)
        }
    }
    
    func setupdefaults(_ providerIDD: Int) {       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
        if providerIDD == 0 {
            //no bussiness simple customer
            self.issimpleCustomer = true
            self.isemploye = false
            Global.sharedInstance.providerID = 0
            Global.sharedInstance.defaults.set(1, forKey: "issimpleCustomer")       //true
            Global.sharedInstance.defaults.set(0, forKey: "isemploye")              //false
            Global.sharedInstance.defaults.synchronize()
        } else {
            self.issimpleCustomer = false
            self.isemploye = true
            Global.sharedInstance.providerID = providerIDD
            Global.sharedInstance.defaults.set(0, forKey: "issimpleCustomer")       //false
            Global.sharedInstance.defaults.set(1, forKey: "isemploye")              //true
            Global.sharedInstance.defaults.synchronize()
        }
        print("providerIDD \(Global.sharedInstance.providerID)")
        if  self.isemploye == true {
            if Reachability.isConnectedToNetwork() == false
            {
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else {
                var y:Int = 0
                var dicISMANAGERUSER:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                    let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                    if let x:Int = a.value(forKey: "currentUserId") as? Int{
                        y = x
                    }
                }
                dicISMANAGERUSER["iUserId"] =  y as AnyObject
                //                print("\n********************************* IsManagerUser  ********************\n")
                //                let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicISMANAGERUSER, options: NSJSONWritingOptions.PrettyPrinted)
                //                let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
                //                print(jsonString)
                if Reachability.isConnectedToNetwork() == false
                {
                    
//                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else
                {
                    api.sharedInstance.IsManagerUser(dicISMANAGERUSER, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            //   print("ce astepta \(RESPONSEOBJECT["Result"])")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                            {
                                print("eroare la IsManagerUser \(String(describing: RESPONSEOBJECT["Error"]))")
                            }
                            else
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                                {
                                    print("eroare la IsManagerUser \(String(describing: RESPONSEOBJECT["Error"]))")
                                }
                                else
                                {
                                    if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                    {
                                        let myInt :Int = RESPONSEOBJECT["Result"] as! Int
                                        if myInt == 1 {
                                            self.setupfinale(1)
                                            print("is manager")
                                        } else {
                                            print("is not manager")
                                            self.setupfinale(0)
                                        }
                                    }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        if AppDelegate.showAlertInAppDelegate == false
//                        {
//                            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            AppDelegate.showAlertInAppDelegate = true
//                        }
                    })
                }
            }
        }
    }
    
    
    //iustin
    func GetEmployeeMobilePermissions(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        
        let path = "GetEmployeeMobilePermissions"
        PREETYJSON_J(params as Dictionary<String, AnyObject>, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure:failure)
        
    }
    
    func CheckMailValidity(_ params:Dictionary<String,String>, success: (successBlock)!, failure: (failureBlock)!)
    {
        
        let path = "CheckMailValidity"
        PREETYJSON_J(params as Dictionary<String, AnyObject>, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure:failure)
        
    }
    
    func CheckPhoneValidity(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "CheckPhoneValidity"
        PREETYJSON_J(params as Dictionary<String, AnyObject>, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure:failure)
    }
    
    func RegisterUser(_ params:Dictionary<String,Dictionary<String,AnyObject>>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "RegisterUser"
        PREETYJSON_JEXTEND(params as Dictionary<String,Dictionary<String,AnyObject>>, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func UpdateUser(_ params:Dictionary<String,Dictionary<String,AnyObject>>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateUser"
    //      PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func AddProviderUser(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)     // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "AddProviderUser"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Result"] as? Int {
                    Global.sharedInstance.currentProvider.iUserId = RESPONSEOBJECT["Result"] as! Int
                }
            }
        },failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func AddProviderBuisnessDetails(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)      // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "AddProviderBuisnessDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Result"] as? Int {
                    Global.sharedInstance.currentProvider.iIdBuisnessDetails = RESPONSEOBJECT["Result"] as! Int
                }
            }
        },failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    // מקבלת מספר טלפון ושולחת SMS עם קוד אימות ומחזירה את הקוד גם כן לאפליקציה על מנת לעשות השוואה עם הקוד שמכניס
    func GetAndSmsValidationCode(_ params:Dictionary<String,String> , success: (successBlock)!, failure: (failureBlock)!)        // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "GetAndSmsValidationCode"
        PREETYJSON_J(params as Dictionary<String, AnyObject>, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success:success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetSysAlertsList(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetSysAlertsList"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func RestoreVerCode(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)      // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "RestoreVerCode"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func LoginUser(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "LoginUser"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func AddProviderAllDetails(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddProviderAllDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func GetProviderDetails(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "GetProviderDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetProviderBuisnessDetails(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetProviderBuisnessDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    //get iUserId,returns customer's details
    func GetCustomerDetails(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomerDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func SearchProviders(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "SearchProviders"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    //ומחזירה רשימה של אוביקטים מסוג SearchResulstsObj
    func SearchByKeyWord(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "SearchByKeyWord"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func SearchWordCompletion(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "SearchWordCompletion"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func getServicesProviderForSupplierfunc(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "getServicesProviderForSupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func getProviderServicesForSupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "getProviderServicesForSupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetCouponsForProvider(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "GetCouponsForProvider"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetProviderProfile(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "GetProviderProfile"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //get:iUserId,returns:provider all details he registered
    //if provider not exist -> returns -2
    func getProviderAllDetails(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "getProviderAllDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func getProviderAllDetailsbyEmployeID(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "getProviderAllDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func SendAgainSms(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "SendAgainSms"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: nil, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                print(RESPONSEOBJECT)
            }
        }, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    //GetProviderListForCustomer
    func GetProviderListForCustomer(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "GetProviderListForCustomer"
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    //פונקציה שמוחקת ספקים ללקוח (שלא יראה אותם ברשימת נותני השרות שלו) אך לא באמת מחקת את הציוות.
    func RemoveProviderFromCustomer(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "RemoveProviderFromCustomer"
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    //GetFreeDaysForServiceProvider
    func GetFreeDaysForServiceProvider(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "NewGetFreeTimesForServiceProviderByDaysOrHoures" // replaces "GetFreeDaysForServiceProvider" 12.02.2019
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    //GetCustomerOrders(int iUserId, int iFilterByMonth, int iFilterByYear)
    func GetCustomerOrders(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "GetCustomerOrders"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //newOrder
    func newOrder(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "newOrder"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func CheckProviderExistByMail(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "CheckProviderExistByMail"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func CheckProviderExistByPhone(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)       // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "CheckProviderExistByPhone"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    // Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018 ->
    func getProviderAllDetails(_ iUserId:Int)       //invoke server function to get provider details
    {
        Global.sharedInstance.FREEDAYSALLWORKERS = []
        Global.sharedInstance.NOWORKINGDAYS = []
        //show a loader
        if let topController = UIApplication.topViewController() {
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            view8 = storyboard1.instantiateViewController(withIdentifier: "loadingBthere") as? loadingBthere
            let screenSize: CGRect = UIScreen.main.bounds
            view8?.view.frame = screenSize
            view8?.view.tag = 2000
            view8?.view.frame.origin.x = 0
            view8?.view.frame.origin.y = 0
            topController.view.addSubview((view8?.view)!)
            topController.view.bringSubviewToFront((view8?.view)!)
        }
        //end show
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicUserId["iUserId"] = iUserId as AnyObject
        //קבלת פרטי הספק
        api.sharedInstance.getProviderAllDetails(dicUserId, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            //in any case hide loader
            if (self.view8?.view.window != nil) {
                self.view8?.view.removeFromSuperview()
            }   //end hide
            
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                    {
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                    {
                        UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                            
                        api.sharedInstance.getProviderAllDetailsbySimpleUserID(dicUserId["currentUserId"] as! Int)
                    }
                    else
                    {
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                      print("crash 1 \(String(describing: RESPONSEOBJECT["Result"]))")
                           
                            Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                            // print ("exact \( Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.description)")
                            let mydic :Dictionary<String,AnyObject> = (RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!
                            
                            //IMPORTANT THIS FIX PROVIDERID AFTER SETTING ORDER TO ANOTHER ONE.
                            if let onedic:Dictionary<String,AnyObject> = mydic["objProviderProfile"] as? Dictionary<String,AnyObject> {
                                if let Iprov:Int = onedic["iProviderUserId"] as? Int {
                                    print("dupaget \(Iprov)")
                                    if Iprov != 0 {
                                        Global.sharedInstance.providerID = Iprov
                                    } else {
                                        api.sharedInstance.trytogetProviderdata()
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
                            //שמירת שם העסק במכשיר
                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")
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
                        }
                    }
                }
            }
            
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            if (self.view8?.view.window != nil) {
                self.view8?.view.removeFromSuperview()
            }   //end hide
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
        })
    }
    
    func addNewCoupon(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "addNewCoupon"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func DeleteFromWaitingList(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "DeleteFromWaitingList"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func CancelOrder(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "CancelOrder"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func getWaitingListForCustomer(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "getWaitingListForCustomer"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    //2do
    func addUserToWaitingList(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "addUserToWaitingList"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func CheckIfOrderIsAvailable(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "CheckIfOrderIsAvailable"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetAlertSettingsForCustomer(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetAlertSettingsForCustomer"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func AddAlertSettingsForCustomer(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddAlertSettingsForCustomer"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    func PREETYJSON_JEXTEND(_ params:Dictionary<String,Dictionary<String,AnyObject>>, pathofweb: String) {
        print("********************************* \(pathofweb) my data ********************\n")
        if let _ = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted) {
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
        }
        print("\n********************************* END of \(pathofweb)  ********************\n")
    }
    func PREETYJSON_J(_ params:Dictionary<String,AnyObject>, pathofweb: String) {
        print("********************************* \(pathofweb) my data ********************\n")
        if let _ = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted) {
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        }
        print("\n********************************* END of \(pathofweb)  ********************\n")
    }
    
    func GetCustomersBySupplierId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomersBySupplierId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func SupplierAddCustomer(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "SupplierAddCustomer"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func DeleteCustomerFromSupplierCustomers(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "DeleteCustomerFromSupplierCustomers"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func CheckCustomerExistByPhone(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "CheckCustomerExistByPhone"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func CheckCustomerExistByMail(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "CheckCustomerExistByMail"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func UpdateSupplierCustomer(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateSupplierCustomer"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetCustomerOrdersForSupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomerOrdersForSupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //AddOccasionalUser(string nvPhoneNum, int iSupplierId);
    // returns everytime  134
    func AddOccasionalUser(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddOccasionalUser"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //IsManagerUser(iUserId)
    func IsManagerUser(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "IsManagerUser"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //GetCustomersOrdersForSupplier(int iUserId, int iSupplierId, int iFilterByMonth, int iFilterByYear, int iFilterByMonthEnd, int iFilterByYearEnd)
    //returns all  supplier orders
    func GetCustomersOrdersForSupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomersOrdersForSupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
        
    }
    
    func SupplierCancelOrder(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "SupplierCancelOrder"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
        
    }
    //GetCustomersOrdersByDateForSupplier(int iSupplierId, DateTime dtDateStart, DateTime dtDateEnd)
    func GetCustomersOrdersByDateForSupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomersOrdersByDateForSupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //GetSupplierIdByEmployeeId(int iUserId) intoarce 0 atunci este customer, daca se intoarce o valoare mai mare decat 0 atunci este employee (angajat) iar valoarea este providerid
    func GetSupplierIdByEmployeeId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetSupplierIdByEmployeeId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //    1. GetCustomersOrdersByDateForEmployeeId(int iUserId, DateTime dtDateStart, DateTime dtDateEnd)
    func GetCustomersOrdersByDateForEmployeeId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomersOrdersByDateForEmployeeId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //
    //    2.GetCustomerOrdersForEmployeeId(int iUserId, int iFilterByMonth, int iFilterByYear, int iFilterByMonthEnd, int iFilterByYearEnd)
    func GetCustomerOrdersForEmployeeId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomerOrdersForEmployeeId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
        
    }
    //GetSupplierCustomerUserIdByEmployeeId(int iUserid)
    func GetSupplierCustomerUserIdByEmployeeId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetSupplierCustomerUserIdByEmployeeId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //special function here only when we can not get all provider details  (case employe logged in) AND WE DO NOT WANT TO OVERWRITE CURRENT LOGGED IN EMPLOYE WITH SUPPLIER USER DATA
    func getProviderAllDetailsbyEmployeID(_ iUserId:Int)
    {
        Global.sharedInstance.FREEDAYSALLWORKERS = []
        Global.sharedInstance.NOWORKINGDAYS = []
        print("now getProviderAllDetailsbyEmployeID")
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //  dicUserId["iUserId"] = 20 important! hardcoded for test only do not use in production
        dicUserId["iUserId"] = iUserId as AnyObject
        print("id crashx: \(dicUserId["iUserId"]) ")
        //קבלת פרטי הספק
        api.sharedInstance.getProviderAllDetails(dicUserId, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            //in any case hide loader
            if (self.view8?.view.window != nil) {
                self.view8?.view.removeFromSuperview()
            }   //end hide
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                    {
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                    {
                        UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")
                    }
                    else
                    {
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                       //\\      print("crashx \(String(describing: RESPONSEOBJECT["Result"]))")
                            //KEEP IN MIND TO NOT OVERWRITE CURRENT LOGGED IN EMPLOYE SO USE dicToProviderDetailsObjByEmploye
                            Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObjByEmploye(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                            let mydic :Dictionary<String,AnyObject> = (RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!
                            //IMPORTANT THIS FIX PROVIDERID AFTER SETTING ORDER TO ANOTHER ONE.
                            if let onedic:Dictionary<String,AnyObject> = mydic["objProviderProfile"] as? Dictionary<String,AnyObject> {
                                if let Iprov:Int = onedic["iProviderUserId"] as? Int {
                                    if Iprov != 0 {
                                        Global.sharedInstance.providerID = Iprov
                                    } else {
                                        api.sharedInstance.trytogetProviderdata()
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
                            //שמירת שם העסק במכשיר
                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")
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
                            var y:Int = 0
                            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                                    y = x
                                }
                            }
                            print("crentiduser \(y)")
                        }
                        //  print ("1 x -> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName)")
                        //  print ("2x-> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress)")
                        //  print ("3x -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen)")
                        //  print ("4x -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage)")
                    }
                }
            }
            
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
        })
    }
    
    //iustin
    func getProviderAllDetailsbySimpleUserID(_ id:Int)
    {
        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicuser["iUserId"] =  id as AnyObject
        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject>  {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                {
                    let myInt :Int = RESPONSEOBJECT["Result"] as! Int
                    print("sup id e ok ? " + myInt.description)
                    if myInt == 0 {
                        print ("no business")
                    } else {
                        self.GetSecondUserIdByFirstUserId(id)
                        self.callgetprovideralldetails(myInt)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            //            if AppDelegate.showAlertInAppDelegate == false
            //            {
            //                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            //                AppDelegate.showAlertInAppDelegate = true
            //            }
        })
    }
    
    
    //GetSecondUserIdByFirstUserId(Int iUserId) just for reference, this takes the second id in db for employe
    func GetSecondUserIdByFirstUserId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetSecondUserIdByFirstUserId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    func GetSecondUserIdByFirstUserId(_ employeID:Int)  {
        var y:Int = 0
        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        dicEMPLOYE["iUserId"] =  y as AnyObject
        //              print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
        //              let jsonData = try! NSJSONSerialization.dataWithJSONObject(dicEMPLOYE, options: NSJSONWritingOptions.PrettyPrinted)
        //              let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        //              print(jsonString)
        if Reachability.isConnectedToNetwork() == false
        {
            
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetSecondUserIdByFirstUserId(dicEMPLOYE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("buff \(RESPONSEOBJECT)")
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                        {
                            print("eroare la GetSecondUserIdByFirstUserId \(String(describing: RESPONSEOBJECT["Error"]))")
                        }
                        else
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                print("eroare la GetSecondUserIdByFirstUserId \(String(describing: RESPONSEOBJECT["Error"]))")
                            }
                            else
                            {
                                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                {
                                    let myInt :Int = RESPONSEOBJECT["Result"] as! Int
                                    print("SECOND USER ID \(myInt)")
                                    if myInt > 0 {
                                        //store information for current employe in userdefaults
                                        Global.sharedInstance.defaults.set(myInt, forKey: "idSupplierWorker")
                                        Global.sharedInstance.defaults.synchronize()
                                    }
                                }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                let statuscode = AFHTTPRequestOperation?.response?.statusCode
                if statuscode == 400 {
                    api.sharedInstance.s45FB185D380DEA55FA5BFA335B4B6821ADD7A0794851F185()
                }
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
    }
    //GetServicesPermissionForUsersBySupplier(int iSupplierId)
    func GetServicesPermissionForUsersBySupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetServicesPermissionForUsersBySupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    // AddServicePermissionForUser(int iUserId, int iSupplierServiceId)
    func AddServicePermissionForUser(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddServicePermissionForUser"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //UpdateEmployeeIsManager(int iUserId, bool bIsManager)
    func UpdateEmployeeIsManager(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateEmployeeIsManager"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetEmployeesOfSupplierForService(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetEmployeesOfSupplierForService"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func DeleteServicePermissionByServicePermissionId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "DeleteServicePermissionByServicePermissionId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetProviderAlertSettings(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetProviderAlertSettings"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    //int iProviderId in ProviderAlertsSettingsObj
    func AddProviderAlertSettings(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddProviderAlertSettings"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func UpdateProviderAlertSettings(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateProviderAlertSettings"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func UpdateProviderGeneralDetails(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateProviderGeneralDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func UpdProviderBuisnessDetails(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdProviderBuisnessDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func GetEmployeeDataByPhone(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetEmployeeDataByPhone"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func GetEmployeeDataByEmail(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetEmployeeDataByEmail"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func getServicesProviderForSupplierfuncdoi()
    {
        Global.sharedInstance.giveServiceName = ""
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.providerID == 0 {
            dicSearch["iProviderId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            }
        } else {
            dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }
        var arrUsers:Array<User> = Array<User>()
        if Reachability.isConnectedToNetwork() == false
        {
            
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.getServicesProviderForSupplierfunc(dicSearch,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                let temparrayWorkers:  NSMutableArray = []
                Global.sharedInstance.giveServicesArray = arrUsers
                Global.sharedInstance.arrayGiveServicesKods = []
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            Alert.sharedInstance.showAlertDelegate("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                                let u:User = User()
                                arrUsers = u.usersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                for  item in arrUsers{
                                    Global.sharedInstance.arrayGiveServicesKods.append(item.iUserId)//אחסון הקודים של נותני השרות לצורך השליחה לשרת כדי לקבל את השעות הפנויות
                                }
                                Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
                                Global.sharedInstance.dicGetFreeDaysForServiceProvider["lServiseProviderId"] = Global.sharedInstance.arrayGiveServicesKods as AnyObject
                                if arrUsers.count == 0
                                {
                                    Global.sharedInstance.CurrentProviderArrayWorkers = []
                                    Alert.sharedInstance.showAlertDelegate("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    self.processworkersdoi(temparrayWorkers)
                                }
                                else
                                {
                                    Global.sharedInstance.CurrentProviderArrayWorkers = []
                                    for u:User in arrUsers
                                    {
                                        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
                                            api.sharedInstance.PREETYJSON_J(u.getDic(), pathofweb: "worker details")
                                            temparrayWorkers.add(u)
                                        }
                                    }
                                    var y:Int = 0
                                    if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                                        let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                                        if let x:Int = a.value(forKey: "currentUserId") as? Int{
                                            y = x
                                        }
                                    }
                                    for u:User in arrUsers
                                    {
                                        if Global.sharedInstance.defaults.integer(forKey: "ismanager") != 1 {
                                            if u.iUserId == Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") {
                                                temparrayWorkers.add(u)
                                            }
                                            print("u.iUserId \(u.iUserId) y \(y)")
                                        }
                                    }
                                }
                            }
                        }
                        self.processworkersdoi(temparrayWorkers)
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    func processworkersdoi (_ myWorkers: NSMutableArray) {
        Global.sharedInstance.CurrentProviderArrayWorkers = myWorkers
        print("Global.sharedInstance.CurrentProviderArrayWorkers \(Global.sharedInstance.CurrentProviderArrayWorkers)")
    }
    
    func UpdateSyncContacts(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateSyncContacts"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func UpdateDeviceTokenByUserId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateDeviceTokenByUserId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func AddProviderBusinessProfile(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddProviderBusinessProfile"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func  UpdateProviderBusinessDetails2(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateProviderBusinessDetails2"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func SendApprovalRequest(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure:(failureBlock)!)
    {
        let path = "SendApprovalRequest"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func sendRatingForBusiness (_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure:(failureBlock)!)
    {
        let path = "sendRatingForBusiness"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func updateRatingForBusiness (_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure:(failureBlock)!)
    {
        let path = "updateRatingForBusiness"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func CheckCustomerReviewedProvider (_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure:(failureBlock)!)
    {
        let path = "CheckCustomerReviewedProvider"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func  GetProviderContact(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetProviderContact"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: failure)
    }
    
    func GetFieldsAndCatg(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetFieldsAndCatg"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func AddBlockedHours(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddBlockedHours"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func BlockHoursForServiceProvider(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "BlockHoursForServiceProvider"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func DeleteSupplierBySupplierId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "DeleteSupplierBySupplierId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func DeleteUserByUserId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "DeleteUserByUserId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func MakeCustomerSupplierActiveByCustomerUserId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "MakeCustomerSupplierActiveByCustomerUserId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func SetStatusForCustomerSupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "SetStatusForCustomerSupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func UpdateSupplierAlertSettingsBySupplierId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateSupplierAlertSettingsBySupplierId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func GetSupplierAlertSettingsBySupplierId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetSupplierAlertSettingsBySupplierId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params,success: success, failure: failure)
    }
    
    func GetProviderListForCustomerAuthorizedFromSupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetProviderListForCustomerAuthorizedFromSupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func SyncContacts(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "SyncContacts"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func BlockHoursForSupplierByEmployeeIdWithTimeInterval(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "BlockHoursForSupplierByEmployeeIdWithTimeInterval"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetIsBlockSupReg(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetIsBlockSupReg"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetNewsAndUpdates(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "GetNewsAndUpdates"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetCustomerOrdersForEmployeeIdInLast6Months(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "GetCustomerOrdersForEmployeeIdInLast6Months"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetCustomerOrdersForSupplierIdInLast6Months(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "GetCustomerOrdersForSupplierIdInLast6Months"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func SendPushNotificationFromCustomerWhenCustomerIsLate(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "SendPushNotificationFromCustomerWhenCustomerIsLate"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetPushNotificationListTop50BySupplierId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "GetPushNotificationListTop50BySupplierId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func SetCustomerViewRangeBySupplierId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "SetCustomerViewRangeBySupplierId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetFreeTimesForServiceProviderByDaysOrHoures(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
      //  let path = "GetFreeTimesForServiceProviderByDaysOrHoures"
        let path = "NewGetFreeTimesForServiceProviderByDaysOrHoures"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func SetProviderSettingsForCalendarmanagement(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "SetProviderSettingsForCalendarmanagement"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetProviderSettingsForCalendarmanagement(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "GetProviderSettingsForCalendarmanagement"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    //  GetCustomerActiveOrdersBySupplier
    func GetCustomerActiveOrdersBySupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "GetCustomerActiveOrdersBySupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func LastMinuteCamapign_INS(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "LastMinuteCamapign_INS"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func LastMinuteCampaign_SLCT(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "LastMinuteCampaign_SLCT"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func LastMinuteCamapign_UPD(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "LastMinuteCamapign_UPD"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func UpdateLocationCoordinatesByUserId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "UpdateLocationCoordinatesByUserId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetMaxPacketsForSupplierId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {    // number of pages for my customers
        let path = "GetMaxPacketsForSupplierId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetCustomerPacketForSupplierId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {    //results for page on my customers
        let path = "GetCustomerPacketForSupplierId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    //SearchByKeywords added on 08/052018 - is sorted by distance
    func SearchByKeyWords(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "SearchByKeywords"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func SearchCustomersForSupplierIdByKeyword(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "SearchCustomersForSupplierIdByKeyword"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetBlockedHouresFromCalendar(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "GetBlockedHouresFromCalendar"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func RemoveBlockedHouresFromCalendar(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "RemoveBlockedHouresFromCalendar"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func UpdateiOSVersionByUserId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "UpdateiOSVersionByUserId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func AddBlockedHouresToCalendar(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "AddBlockedHouresToCalendar"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    //24.05.2018
    func AddProviderDetails(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "AddProviderDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func AddProviderProfile(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "AddProviderProfile"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func GetSerial(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "GetSerial"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.get(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    //SyncContactRegistration
    func SyncContactsRegistration(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "SyncContactsRegistration"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //SendNotificationToCustomers
    func SendNotificationToCustomers(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "SendNotificationToCustomers"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
     //GetTokenByPN
    func GetTokenByPN(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetTokenByPN"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //GetTrialDataByUserId
    func GetTrialDataByUserId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetTrialDataByUserId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //getReviewsByProviderID
    func getReviewsByProviderID(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "getReviewsByProviderID"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    func GetRatingForBusiness(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetRatingForBusiness"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    func AddSupplierLead(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddSupplierLead"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
        //    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    func GetServerTime(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetServerTime"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //11.01.2019 JMODE
    func GetCustomerCountBySupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomerCountBySupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //16.01.2019 JMODE
    func GetCustomerPacketForSupplierIdByKeyword(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomerPacketForSupplierIdByKeyword"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //31.01.2019 JMODE
    func RemoveBulkBlockedHoursFromCalendar(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "RemoveBulkBlockedHoursFromCalendar"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //07.02.2019 JMODE
    func GetCustomerOrdersNoLogo(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCustomerOrdersNoLogo"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //27.02.2019 JMODE

    func UpdateProviderWorkingHours(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateProviderWorkingHours"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //20.03.2019 JMODE
    func GetEmployeesOfSupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetEmployeesOfSupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //20.03.2019 JMODE +
    func AddSupplierEmployee(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddSupplierEmployee"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //20.03.2019 JMODE +
    func RemoveSupplierEmployee(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "RemoveSupplierEmployee"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //25.03.2019 JMODE +
    func UpdateSupplierEmployee(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateSupplierEmployee"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //26.03.2019 JMODE +
    func CheckEligibleEmployee(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "CheckEligibleEmployee"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //26.03.2019 JMODE +
    func GetApplicationPermissions(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetApplicationPermissions"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //04.04.2019 JMODE +
    func UpdateWorkHours(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateWorkHours"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //04.04.2019 JMODE +
    func GetCalendarsOfSupplier(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetCalendarsOfSupplier"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //04.04.2019 JMODE +
    func AddSupplierCalendar(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddSupplierCalendar"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //04.04.2019 JMODE +
    func UpdateSupplierCalendar(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateSupplierCalendar"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //04.04.2019 JMODE +
    func RemoveSupplierCalendar(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "RemoveSupplierCalendar"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //15.04.2019 JMODE +
    func GetPushNotificationListTop50ByProviderUserId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetPushNotificationListTop50ByProviderUserId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //15.04.2019 JMODE +
    func AddSupplierService(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "AddSupplierService"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //15.04.2019 JMODE +
    func RemoveSupplierService(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "RemoveSupplierService"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //15.04.2019 JMODE +
    func UpdateSupplierService(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "UpdateSupplierService"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
            //            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //NEW DEVELOP
    func s45FB185D380DEA55FA5BFA335B4B6821ADD7A0794851F185() {
        let dicforserver:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        api.sharedInstance.GetSerial(dicforserver, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                
                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                {
                    if let _:Array<Int> = RESPONSEOBJECT["Result"] as? Array<Int> {
                        let abtys:Array<Int> = RESPONSEOBJECT["Result"] as! Array<Int>
                        print("NUMBER BYTES \(abtys)")
                        //\\  self.a33C46F1734F5CD33BEAB71C8A(bc: abtys)
                        self.keyserver = "access-token"
                    }
                } else {
//                    Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//
//            }
            self.keyserver = "access-token"
        })
        
    }
    
    
    
    func a33C46F1734F5CD33BEAB71C8A(bc:Array<Int>) {
        let ms = readx()
        var myx:String = ""
        for bs in bc {
            if let cs:String = ms.substring(with: bs..<bs+1) as? String  {
                myx =  myx + cs
            } else {
                print("cannot read index \(bs)")
            }
        }
        
        let key = A3C750FC50CB8F7D(ac:  myx.base64Encoded1.string!)
        self.keyserver = key
        
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
   
    
    //////////////////      NOT USED OR OBSOLETE METHODS        //////////////////
    //GetPaymentDetailsByUserId
    func GetPaymentDetailsByUserId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetPaymentDetailsByUserId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    // GetCustomerViewRangeBySupplierId(int iSupplierId) -> not used anymore
    func GetCustomerViewRangeBySupplierId(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "GetCustomerViewRangeBySupplierId"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success: success,failure: failure)
    }
    
    func AddProviderGeneralDetails(_ params:Dictionary<String,AnyObject> , success: (successBlock)!, failure: (failureBlock)!)      // Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
    {
        let path = "AddProviderGeneralDetails"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: params, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
        //        print(RESPONSEOBJECT)
            }
        },failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    func GetListDiscount90(_ params:Dictionary<String,AnyObject>, success: (successBlock)!, failure: (failureBlock)!)
    {
        let path = "GetListDiscount90"
        PREETYJSON_J(params, pathofweb: path)
        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
        manager.requestSerializer.timeoutInterval = 120
        manager.post(self.buildUrl(path), parameters: nil, success: success, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
            print("Error: ", error.localizedDescription)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    //    func GetSysAlertsList(params:Dictionary<String,AnyObject> , success: (successBlock)!, failure: (failureBlock)!)
    //    {
    //        let path = "GetSysAlertsList"
    //
    //        manager.requestSerializer.setValue("access-token",  forHTTPHeaderField: "access-token")
    //        manager.requestSerializer.timeoutInterval = 120
    //        manager.post(self.buildUrl(path), parameters: params, success: { (operation:AFHTTPRequestOperation?, responseObject:AnyObject) -> Void in
    //
    //            let sysAlert:SysAlerts = SysAlerts()
    //
    //            Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(responseObject["Result"] as! Array<Dictionary<String,AnyObject>>)
    //
    //            if Global.sharedInstance.arrSysAlerts.count != 0
    //            {
    //                Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
    //                Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
    //                Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
    //                Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
    //                Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
    //                Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
    //                //2do
    //                //במקום זה צריך להיות textField
    //                //            Global.sharedInstance.arrayDicForTableViewInCell[4]![1] = sysAlert.SysnvAletName(12)
    //            }
    //            }, failure: { (operation: AFHTTPRequestOperation?,error: Error!) in
    //                  print("Error: ", error.localizedDescription)
    //                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
    //        })
    //    }
    func requestTranzilaTokenApi( _ params:Dictionary<String,AnyObject>, urlrequestTranzilaTokenApi:String, success: (successBlock)!, failure: (failureBlock)!) {
        let path = "requestTranzilaTokenApi"
        PREETYJSON_J(params, pathofweb: path)
        managerTRANZILA.requestSerializer.timeoutInterval = 120
        managerTRANZILA.responseSerializer = AFHTTPResponseSerializer()
        managerTRANZILA.get(urlrequestTranzilaTokenApi, parameters: params, success: success,failure: failure)
    }
    //requestTranzilaTokenApi
   
}






