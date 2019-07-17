//
//  WaitingListObj.swift
//  Bthere
//
//  Created by User on 26.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class WaitingListObj: NSObject {
    var iWaitingForServiceId:Int = 0
    var nvLogo:String = ""
    var iProviderUserId:Int = 0//נותן שרות
    var ProviderServiceObj:Array<objProviderServices> = Array<objProviderServices>()//סוג שירות
    var iUserId:Int = 0//לקוח
    var dtDateOrder:Date = Date()//תאריך + שעה
    var nvComment:String = ""
    
    
    override init() {
        iWaitingForServiceId = 0
        nvLogo = ""
        iProviderUserId = 0
        ProviderServiceObj = Array<objProviderServices>()
        iUserId = 0
        dtDateOrder = Date()
        nvComment = ""
    }
    
    init(_iWaitingForServiceId:Int,_nvLogo:String,_iProviderUserId:Int,_ProviderServiceObj:Array<objProviderServices>,_iUserId:Int,_dtDateOrder:Date,_nvComment:String) {
        iWaitingForServiceId = _iWaitingForServiceId
        nvLogo = _nvLogo
        iProviderUserId = _iProviderUserId
        ProviderServiceObj = _ProviderServiceObj
        iUserId = _iUserId
        dtDateOrder = _dtDateOrder
        nvComment = _nvComment
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iWaitingForServiceId"] = iWaitingForServiceId as AnyObject
        dic["nvLogo"] = nvLogo as AnyObject
        dic["iProviderUserId"] = iProviderUserId as AnyObject
        dic["ProviderServiceObj"] = ProviderServiceObj as AnyObject
        dic["iUserId"] = iUserId as AnyObject
        dic["dtDateOrder"] = Global.sharedInstance.convertNSDateToString(dtDateOrder) as AnyObject
        dic["nvComment"] = nvComment as AnyObject
        return dic
    }
    
    func dicToWaitingListObj(_ dic:Dictionary<String,AnyObject>)->WaitingListObj
    {
        let waitingList:WaitingListObj = WaitingListObj()
        waitingList.iWaitingForServiceId = Global.sharedInstance.parseJsonToInt(dic["iWaitingForServiceId"]!)
        waitingList.nvLogo = Global.sharedInstance.parseJsonToString(dic["nvLogo"]!)
        waitingList.iProviderUserId = Global.sharedInstance.parseJsonToInt(dic["iProviderUserId"]!)
        waitingList.iUserId = Global.sharedInstance.parseJsonToInt(dic["iUserId"]!)
        let dt:Date = Global.sharedInstance.getStringFromDateString(dic["dtDateOrder"] as! String)
        waitingList.dtDateOrder = dt
        waitingList.nvComment = Global.sharedInstance.parseJsonToString(dic["nvComment"]!)
        let objProviderService:objProviderServices = objProviderServices()
        if dic["providerServiceObj"] != nil
        {
            waitingList.ProviderServiceObj = objProviderService.objProviderServicesToArrayGet(dic["providerServiceObj"] as! NSArray as! Array<Dictionary<String, AnyObject>>)
        }
        return waitingList
    }
    
    func dicToArrayWaitingList(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<WaitingListObj>
    {
        var arrWaitingList:Array<WaitingListObj> = Array<WaitingListObj>()
        var waitingList:WaitingListObj = WaitingListObj()
        for i in 0  ..< arrDic.count
        {
            waitingList = dicToWaitingListObj(arrDic[i])
            arrWaitingList.append(waitingList)
        }
        return arrWaitingList
    }
    
}
