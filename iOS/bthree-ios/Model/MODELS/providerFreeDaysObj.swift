//
//  providerFreeDaysObj.swift
//  Bthere
//
//  Created by User on 10.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class providerFreeDaysObj: NSObject {

    var iProviderUserId:Array<Int> = []
    var dtDate:String = ""
    var objProviderHour:ProviderHourObj = ProviderHourObj()
    
    override init() {
        iProviderUserId = []
        dtDate = ""
        objProviderHour = ProviderHourObj()
    }
    
    init(_iProviderUserId:Array<Int>,_dtDate:String,_objProviderHour:ProviderHourObj) {
      iProviderUserId = _iProviderUserId
        dtDate = _dtDate
        objProviderHour = _objProviderHour
    }
    //return to dic of object to send to server
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iProviderUserId"] = iProviderUserId as AnyObject
        dic["dtDate"] = dtDate as AnyObject
        dic["objProviderHour"] = objProviderHour
        return dic
    }
    //get dic from server and return
    func dicFreeDaysObj(_ dic:Dictionary<String,AnyObject>)->providerFreeDaysObj
    {
        let FreeDays:providerFreeDaysObj = providerFreeDaysObj()
        FreeDays.iProviderUserId = dic["iProviderUserId"]! as! Array<Int>
        FreeDays.dtDate = Global.sharedInstance.parseJsonToString(dic["dtDate"]!)
        let providerHour = ProviderHourObj()
        FreeDays.objProviderHour = providerHour.dicProviderHour(dic["objProviderHour"] as! Dictionary<String,AnyObject>)
        return FreeDays
    }

    
//convert from arrdic to array of object providerFreeDaysObj
    func objFreeDaysToArrayGet(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<providerFreeDaysObj>{
        var arrFreeDays:Array<providerFreeDaysObj> = Array<providerFreeDaysObj>()
        var FreeDay:providerFreeDaysObj = providerFreeDaysObj()
        for i in 0  ..< arrDic.count
        {
            FreeDay = dicFreeDaysObj(arrDic[i])
            arrFreeDays.append(FreeDay)
        }
        return arrFreeDays
    }

}
