//
//  CustomerAlertsSettingsObj.swift
//  Bthere
//
//  Created by Racheli Kroiz on 25.10.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class CustomerAlertsSettingsObj: NSObject {

    var iCustomerUserId:Int = 0
    var b90thAlertTime:Bool = true
    var b20minutesBeforeService:Bool = true
    var bPermissionsFromBusinesses:Bool = true
    var bOrderInWaiting:Bool = true
    var bUpdatesAndNews:Bool = true
    var b4hoursBeforeService:Bool = true
    
    override init() {
        iCustomerUserId = 0
        b90thAlertTime = true
        b20minutesBeforeService = true
        bPermissionsFromBusinesses = true
        bOrderInWaiting = true
        bUpdatesAndNews = true
        b4hoursBeforeService = true
        
    }
    
    init(_iCustomerUserId:Int,_b90thAlertTime:Bool,_b20minutesBeforeService:Bool,_bPermissionsFromBusinesses:Bool,_bOrderInWaiting:Bool,_bUpdatesAndNews:Bool,_b4hoursBeforeService:Bool) {
        
        iCustomerUserId = _iCustomerUserId
        b90thAlertTime = _b90thAlertTime
        b20minutesBeforeService = _b20minutesBeforeService
        bPermissionsFromBusinesses = _bPermissionsFromBusinesses
        bOrderInWaiting = _bOrderInWaiting
        bUpdatesAndNews = _bUpdatesAndNews
        b4hoursBeforeService = _b4hoursBeforeService
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iCustomerUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        dic["b90thAlertTime"] = b90thAlertTime as AnyObject
        dic["b20minutesBeforeService"] = b20minutesBeforeService as AnyObject
        dic["bPermissionsFromBusinesses"] = bPermissionsFromBusinesses as AnyObject
        dic["bOrderInWaiting"] = bOrderInWaiting as AnyObject
        dic["bUpdatesAndNews"] = bUpdatesAndNews as AnyObject
        dic["b4hoursBeforeService"] = b4hoursBeforeService as AnyObject
        
        return dic
    }
    
    func getFromDic(_ dic:Dictionary<String,AnyObject>) -> CustomerAlertsSettingsObj {
        let customerAlertsSettingsObj:CustomerAlertsSettingsObj = CustomerAlertsSettingsObj()
        
        customerAlertsSettingsObj.iCustomerUserId = Global.sharedInstance.parseJsonToInt(dic["iCustomerUserId"]!)
        customerAlertsSettingsObj.b90thAlertTime = dic["b90thAlertTime"] as! Bool
        customerAlertsSettingsObj.b20minutesBeforeService = dic["b20minutesBeforeService"] as! Bool
        customerAlertsSettingsObj.bPermissionsFromBusinesses = dic["bPermissionsFromBusinesses"] as! Bool
        customerAlertsSettingsObj.bOrderInWaiting = dic["bOrderInWaiting"] as! Bool
        customerAlertsSettingsObj.bUpdatesAndNews = dic["bUpdatesAndNews"] as! Bool
        customerAlertsSettingsObj.b4hoursBeforeService = dic["b4hoursBeforeService"] as! Bool
        
        return customerAlertsSettingsObj
    }
    
}
