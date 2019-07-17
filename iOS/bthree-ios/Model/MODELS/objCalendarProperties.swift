//
//  objCalendarProperties.swift
//  bthree-ios
//
//  Created by User on 5.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class objCalendarProperties: NSObject {
    
    var iFirstCalendarViewType:Int = 0
    var dtCalendarOpenDate:String = String()
    var bLimitSeries:Bool = false
    var iMaxServiceForCustomer:Int = 0
    var iPeriodInWeeksForMaxServices:Int = 0
    var bSyncGoogleCalendar = false
    var iCustomerViewLimit:Int = 52
    var iHoursForPreCancelServiceByCustomer:Int = 0  // 1 prevent cancel order  24 h  0 = no limit for hours before meeting to cancel
    var bIsAvailableForNewCustomer:Bool = true  //  1 allow customers to make aapointment without sending aproval request 0 - customers must send first aproval request

    override init() {
        iFirstCalendarViewType = 0
        dtCalendarOpenDate = ""
        bLimitSeries = false
        iMaxServiceForCustomer = 0
        iPeriodInWeeksForMaxServices = 0
        bSyncGoogleCalendar = false
        iCustomerViewLimit = 52
        iHoursForPreCancelServiceByCustomer = 0
        bIsAvailableForNewCustomer = true
    }
    
    init(_iFirstCalendarViewType:Int,_dtCalendarOpenDate:String,_bLimitSeries:Bool,_iMaxServiceForCustomer:Int,_iPeriodInWeeksForMaxServices:Int,_bSyncGoogleCalendar:Bool, _iCustomerViewLimit:Int, _iHoursForPreCancelServiceByCustomer:Int , _bIsAvailableForNewCustomer:Bool) {
        
        iFirstCalendarViewType = _iFirstCalendarViewType
        dtCalendarOpenDate = _dtCalendarOpenDate
        bLimitSeries = _bLimitSeries
        iMaxServiceForCustomer = _iMaxServiceForCustomer
        iPeriodInWeeksForMaxServices = _iPeriodInWeeksForMaxServices
        bSyncGoogleCalendar = _bSyncGoogleCalendar
        iCustomerViewLimit = _iCustomerViewLimit
        iHoursForPreCancelServiceByCustomer = _iHoursForPreCancelServiceByCustomer
        bIsAvailableForNewCustomer = _bIsAvailableForNewCustomer
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iFirstCalendarViewType"] = iFirstCalendarViewType as AnyObject
        if Global.sharedInstance.isDateNil == false
        {
            dic["dtCalendarOpenDate"] = dtCalendarOpenDate as AnyObject
        }
        else
        {
            dic["dtCalendarOpenDate"] = "" as AnyObject
        }
        dic["bLimitSeries"] = bLimitSeries as AnyObject
        dic["iMaxServiceForCustomer"] = iMaxServiceForCustomer as AnyObject
        dic["iPeriodInWeeksForMaxServices"] = iPeriodInWeeksForMaxServices as AnyObject
        dic["iCustomerViewLimit"] = iCustomerViewLimit as AnyObject
        dic["iHoursForPreCancelServiceByCustomer"] = iHoursForPreCancelServiceByCustomer as AnyObject
        dic["bIsAvailableForNewCustomer"] = bIsAvailableForNewCustomer as AnyObject
        //dic["bSyncGoogleCalendar"] = bSyncGoogleCalendar
        
        return dic
    }
    
    //2do - delete
    func getDicExample()->Dictionary<String,AnyObject>
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iFirstCalendarViewType"] = 0 as AnyObject
        dic["dtCalendarOpenDate"] = "" as AnyObject
        dic["bLimitSeries"] = false as AnyObject
        dic["iMaxServiceForCustomer"] = 22 as AnyObject
        dic["iPeriodInWeeksForMaxServices"] = 22 as AnyObject
        //dic["bSyncGoogleCalendar"] = bSyncGoogleCalendar
        
        return dic
    }

    
    
    func objCalendarPropertiesToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<objCalendarProperties>{
        
        var arrServiceProv:Array<objCalendarProperties> = Array<objCalendarProperties>()
        var ProvService:objCalendarProperties = objCalendarProperties()
        
        for i in 0  ..< arrDic.count
        {
            ProvService = dicToCalendarProperties(arrDic[i])
            arrServiceProv.append(ProvService)
        }
        return arrServiceProv
    }
    
    func dicToCalendarProperties(_ dic:Dictionary<String,AnyObject>)->objCalendarProperties
    {
        let calendarProp:objCalendarProperties = objCalendarProperties()
        
        calendarProp.iFirstCalendarViewType = Global.sharedInstance.parseJsonToInt(dic["iFirstCalendarViewType"]!)
        
        calendarProp.dtCalendarOpenDate = dic["dtCalendarOpenDate"]! as! String
        if dic["bLimitSeries"] != nil
        {
              print(dic["bLimitSeries"])

            if let _ =  dic["bLimitSeries"] as? Bool {
                calendarProp.bLimitSeries = dic["bLimitSeries"] as! Bool
            }
            else
            {
                calendarProp.bLimitSeries = false
            }
        }
        else
        {
            calendarProp.bLimitSeries = false
        }
        
        
        if dic["bSyncGoogleCalendar"] != nil
        {
            if Global.sharedInstance.parseJsonToString(dic["bSyncGoogleCalendar"]!) != ""
            {
                calendarProp.bSyncGoogleCalendar = dic["bSyncGoogleCalendar"] as! Bool
            }
            else
            {
                calendarProp.bSyncGoogleCalendar = false
            }
        }
        else
        {
            calendarProp.bSyncGoogleCalendar = false
        }
        calendarProp.iMaxServiceForCustomer = Global.sharedInstance.parseJsonToInt(dic["iMaxServiceForCustomer"]!)
        calendarProp.iPeriodInWeeksForMaxServices =  Global.sharedInstance.parseJsonToInt(dic["iPeriodInWeeksForMaxServices"]!)
        calendarProp.iCustomerViewLimit =  Global.sharedInstance.parseJsonToInt(dic["iCustomerViewLimit"]!)
        if dic["bIsAvailableForNewCustomer"] != nil
        {
            calendarProp.bIsAvailableForNewCustomer  =  dic["bIsAvailableForNewCustomer"]! as! Bool
        } else  {
         calendarProp.bIsAvailableForNewCustomer = true
        }
        if dic["iHoursForPreCancelServiceByCustomer"] != nil
        {
        calendarProp.iHoursForPreCancelServiceByCustomer  =  Global.sharedInstance.parseJsonToInt(dic["iHoursForPreCancelServiceByCustomer"]!)
        } else {
            calendarProp.iHoursForPreCancelServiceByCustomer = 0
        }

        
        return calendarProp
    }
    func getPartialDic()->Dictionary<String,AnyObject>
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

        dic["iFirstCalendarViewType"] = iFirstCalendarViewType as AnyObject
        if Global.sharedInstance.isDateNil == false
        {
            dic["dtCalendarOpenDate"] = dtCalendarOpenDate as AnyObject
        }
        else
        {
            dic["dtCalendarOpenDate"] = "" as AnyObject
        }
        dic["bLimitSeries"] = bLimitSeries as AnyObject
        dic["iMaxServiceForCustomer"] = iMaxServiceForCustomer as AnyObject
        dic["iPeriodInWeeksForMaxServices"] = iPeriodInWeeksForMaxServices as AnyObject
        dic["iCustomerViewLimit"] = iCustomerViewLimit as AnyObject
       //  dic["iHoursForPreCancelServiceByCustomer"] = iHoursForPreCancelServiceByCustomer as AnyObject
       // dic["bIsAvailableForNewCustomer"] = bIsAvailableForNewCustomer as AnyObject
        //dic["bSyncGoogleCalendar"] = bSyncGoogleCalendar

        return dic
    }
}
