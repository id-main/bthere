//
//  AddProviderAlertSettings.swift
//  bthree-ios
//
//  Created by User on 7.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class AddProviderAlertSettings: NSObject {

    var iProviderId:Int = 0
    var iIncomingAlertsId:[Int] = []//בחירה מרובה
    var b10minutesBeforeService:Bool = false//דקות לפני התור 10
    var iCustomerResvId:[Int] = []//סוג התראה מעקב אחר לקוחות
    var iCustomerResvFreqId:Int = 0//מעקב אחר לקוחות ­ תדירות­
    var iCustomerEventsId:[Int] = []//אירועים של לקוחות ­ (סוג עדכון) יש אפשרות לבחירה מרובהiCustomerEventsId[] int
    var iCustomerEventsFreqId:Int = 0//אירועים של לקוחות ­ תדירות
    
//    var iProviderId:Int = 0
//    var iIncomingAlertsId:[Int] = []//בחירה מרובה
//    var bEntryExitService:Bool = false
//    var iCustomerResvId:Int = 0//סוג התראה מעקב אחר לקוחות
//    var iCustomerResvFreqId:Int = 0//מעקב אחר לקוחות ­ תדירות­
//    var iPushNotifId:Int = 0
//    var iPushNotifFreqId:Int = 0
//    var i90thAlertTime:Int = 0
//    var b10minutesBeforeService:Bool = false//דקות לפני התור 10
//    var iCustomerEventsId:[Int] = []//אירועים של לקוחות ­ (סוג עדכון) יש אפשרות לבחירה מרובה
//    var iCustomerEventsFreqId:Int = 0//אירועים של לקוחות ­ תדירות
   
    override init() {
        iProviderId = 0
        iIncomingAlertsId = []
        iCustomerResvId = []
        iCustomerResvFreqId = 0
        b10minutesBeforeService = false
        iCustomerEventsFreqId = 0
        iCustomerEventsId = []
        //bEntryExitService = false
        //iPushNotifId = 0
        //iPushNotifFreqId = 0
        //i90thAlertTime = 0
    }
    
    init(_iProviderId:Int,_iIncomingAlertsId:[Int],_iCustomerResvId:[Int],_iCustomerResvFreqId:Int,_b10minutesBeforeService:Bool,_iCustomerEventsFreqId:Int,_iCustomerEventsId:[Int]) {
        
        iProviderId = _iProviderId
        iIncomingAlertsId = _iIncomingAlertsId
        iCustomerResvId = _iCustomerResvId
        iCustomerResvFreqId = _iCustomerResvFreqId
        b10minutesBeforeService = _b10minutesBeforeService
        iCustomerEventsFreqId = _iCustomerEventsFreqId
        iCustomerEventsId = _iCustomerEventsId
    }
    
    func getDic()->Dictionary<String,AnyObject>
    
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iProviderId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
            //Global.sharedInstance.currentProvider.iUserId
        
        var inAl:Array<Int> = Array<Int>()
        for inAlert in iIncomingAlertsId {
            if inAlert != -1
            {
                inAl.append(inAlert)
            }
        }
        dic["iIncomingAlertsId"] = inAl as AnyObject
        
        var iResvId:Array<Int> = Array<Int>()
        for resvId in iCustomerResvId {
            if resvId != -1
            {
                iResvId.append(resvId)
            }
        }
        dic["iCustomerResvId"] = iResvId as AnyObject
        
        dic["iCustomerResvFreqId"] = iCustomerResvFreqId as AnyObject
        dic["b10minutesBeforeService"] = b10minutesBeforeService as AnyObject
        dic["iCustomerEventsFreqId"] = iCustomerEventsFreqId as AnyObject
        var idEvent:Array<Int> = Array<Int>()
        for id in iCustomerEventsId {
            if id != -1
            {
                idEvent.append(id)
            }
        }
        dic["iCustomerEventsId"] = idEvent as AnyObject
        
        return dic
    }
    
    //2do - delete
    func getDicExample()->Dictionary<String,AnyObject>
    {
        let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
       
        
        return dic
    }

    
    func intToArray(_ dic: NSArray) -> [Int] {
        
        var arrInt:[Int] = []
        
        for int in dic {
            arrInt.append(Global.sharedInstance.parseJsonToInt(int as AnyObject))
        }
       return arrInt
    }
    
    
    func dicToaddProviderAlertSettings(_ dic:Dictionary<String,AnyObject>)->AddProviderAlertSettings
    {
        let addProviderAlertSettings:AddProviderAlertSettings = AddProviderAlertSettings()
        
        addProviderAlertSettings.iProviderId = Global.sharedInstance.parseJsonToInt(dic["iProviderId"]!)
        if Global.sharedInstance.parseJsonToString(dic["iIncomingAlertsId"]!) != ""
        {
        addProviderAlertSettings.iIncomingAlertsId = intToArray(dic["iIncomingAlertsId"]! as! NSArray)
        }
        else
        {
            addProviderAlertSettings.iIncomingAlertsId = []
        }
        addProviderAlertSettings.b10minutesBeforeService = dic["b10minutesBeforeService"] as! Bool
        
        if Global.sharedInstance.parseJsonToString(dic["iCustomerResvId"]!) != ""
        {
            addProviderAlertSettings.iCustomerResvId = intToArray(dic["iCustomerResvId"]! as! NSArray)
        }
        else
        {
            addProviderAlertSettings.iCustomerResvId = []
        }
        
        addProviderAlertSettings.iCustomerResvFreqId = Global.sharedInstance.parseJsonToInt(dic["iCustomerResvFreqId"]!)
        addProviderAlertSettings.iCustomerEventsFreqId = Global.sharedInstance.parseJsonToInt(dic["iCustomerEventsFreqId"]!)
        if Global.sharedInstance.parseJsonToString(dic["iCustomerEventsId"]!) != ""
        {
            addProviderAlertSettings.iCustomerEventsId = intToArray(dic["iCustomerEventsId"]! as! NSArray)
        }
        else
        {
            addProviderAlertSettings.iCustomerEventsId = []
        }
        
        return addProviderAlertSettings
    }
}
