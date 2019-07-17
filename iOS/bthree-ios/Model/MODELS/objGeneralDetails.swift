//  objGeneralDetails.swift
//  bthree-ios
//
//  Created by User on 30.3.2016.
//  Copyright © 2016 Webit. All rights reserved.

import UIKit

class objGeneralDetails: NSObject {

    var iProviderUserId:Int = 0
    var iFieldId:Int = 0
    
    var arrObjWorkingHours:Array<objWorkingHours> = Array<objWorkingHours>()
    var arrObjServiceProviders:Array<objServiceProviders> = Array<objServiceProviders>()
    var arrObjProviderServices:Array<objProviderServices> = Array<objProviderServices>()
    var calendarProperties:objCalendarProperties = objCalendarProperties()
    //JMODE 10.01.2019 forget about old scheme for working hours
    override init() {
        iProviderUserId = 0
        iFieldId = 0
        arrObjWorkingHours = Array<objWorkingHours>()
        arrObjServiceProviders = Array<objServiceProviders>()
        arrObjProviderServices = Array<objProviderServices>()
        calendarProperties = objCalendarProperties()
    }
    
    init(_iProviderUserId:Int,_iFieldId:Int,_arrObjWorkingHours:Array<objWorkingHours>,_arrObjServiceProviders:Array<objServiceProviders>,_arrObjProviderServices:Array<objProviderServices>,_calendarProperties:objCalendarProperties, _MYE:Bool) {
        
        iProviderUserId = _iProviderUserId
        iFieldId = _iFieldId
        arrObjWorkingHours = _arrObjWorkingHours
        arrObjServiceProviders = _arrObjServiceProviders
        arrObjProviderServices = _arrObjProviderServices
        calendarProperties = _calendarProperties
    }
    
    func getDicWorkingHours()->Array<AnyObject>{
        
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        var arr:Array<AnyObject> = []
          print("Global.sharedInstance.generalDetails.arrObjWorkingHours.count \(Global.sharedInstance.generalDetails.arrObjWorkingHours.count)")
        for it in Global.sharedInstance.generalDetails.arrObjWorkingHours
        {
            dic = it.getDic()
          
            arr.append(dic as AnyObject)
       
         
               print("whxd \(dic)")
         
        }
        return arr
    }
    
    func getDicServiceProviders()->Array<AnyObject>{
        
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        var arr:Array<AnyObject> = []
        
        for it in arrObjServiceProviders
        {
            dic = it.getDic()
              print("dicemploye \(dic.description)")
            arr.append(dic as AnyObject)
        }
        return arr
    }
    
    func getDicProviderServices()->Array<AnyObject>{
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var arr:Array<AnyObject> = []
        for  it in arrObjProviderServices
        {
            dic = it.getDic()
            arr.append(dic as AnyObject)
        }
        return arr
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iProviderUserId"] = Global.sharedInstance.currentProvider.iIdBuisnessDetails as AnyObject
        dic["iFieldId"] = iFieldId as AnyObject
        dic["objWorkingHours"] = getDicWorkingHours() as AnyObject
        //employes
        dic["objServiceProviders"] = getDicServiceProviders() as AnyObject
        //services
        dic["objProviderServices"] = getDicProviderServices() as AnyObject
        dic["objCalendarProperties"] = calendarProperties.getDic() as AnyObject
        return dic
    }
    
    
    func dicToObjGeneralDetails(_ dic:Dictionary<String,AnyObject>)->objGeneralDetails
    {
        let generalDetails:objGeneralDetails = objGeneralDetails()
        
        generalDetails.iProviderUserId = Global.sharedInstance.parseJsonToInt(dic["iProviderUserId"]!)
//          print("crash2 \(dic["iProviderUserId"])")
        generalDetails.iFieldId = Global.sharedInstance.parseJsonToInt(dic["iFieldId"]!)
        if dic["objWorkingHours"] as? Array<Dictionary<String,AnyObject>> != nil
        {
            let wrHours:objWorkingHours = objWorkingHours()
            generalDetails.arrObjWorkingHours =  wrHours.objWorkingHoursToArray(dic["objWorkingHours"] as! Array<Dictionary<String,AnyObject>>)
        }
        if dic["objServiceProviders"] as? Array<Dictionary<String,AnyObject>> != nil
        {
            let servProviders:objServiceProviders = objServiceProviders()
            generalDetails.arrObjServiceProviders = servProviders.objServiceProvidersToArray(dic["objServiceProviders"] as! Array<Dictionary<String,AnyObject>>)
        }
        if dic["objProviderServices"] as? Array<Dictionary<String,AnyObject>> != nil
        {
            let providerServ:objProviderServices = objProviderServices()
            generalDetails.arrObjProviderServices = providerServ.objProviderServicesToArray(dic["objProviderServices"] as! Array<Dictionary<String,AnyObject>>)
        }
        if dic["objCalendarProperties"] as? NSDictionary != nil
        {
            let calendarProp:objCalendarProperties = objCalendarProperties()
            generalDetails.calendarProperties = calendarProp.dicToCalendarProperties(dic["objCalendarProperties"] as! Dictionary<String,AnyObject>)
        }
        
        return generalDetails
    }
    
    func getSecondDic(_ iProviderUserId:Int,iFieldId:Int )->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iProviderUserId"] = iProviderUserId as AnyObject
        dic["iFieldId"] = iFieldId as AnyObject
        dic["objWorkingHours"] = getDicWorkingHours() as AnyObject
        dic["objServiceProviders"] = getDicServiceProviders() as AnyObject
        dic["objProviderServices"] = getDicProviderServices() as AnyObject
        dic["objCalendarProperties"] = calendarProperties.getDic() as AnyObject
        
        return dic
    }

    func getSecondDicWorkingHours()->Array<AnyObject>{
     
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
   
        var arr:Array<AnyObject> = []
        
        for it in Global.sharedInstance.arrWorkHours
        {
            dic = it.getDic()
            if it.nvFromHour != "00:00:00" && it.nvToHour != "00:00:00" && it.nvFromHour != "" &&  it.nvToHour != "" &&  it.iDayInWeekType != 0 {
                arr.append(dic as AnyObject)
            }
        }
        for it in Global.sharedInstance.arrWorkHoursRest
        {
            dic = it.getDic()
            if it.nvFromHour != "00:00:00" && it.nvToHour != "00:00:00" && it.nvFromHour != "" &&  it.nvToHour != "" &&  it.iDayInWeekType != 0 {
                arr.append(dic as AnyObject)
            }
        }
        return arr
    }
    func geMASTERSecondDic(_ iProviderUserId:Int,iFieldId:Int )->Dictionary<String,AnyObject>
    {
    var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    dic["iProviderUserId"] = iProviderUserId as AnyObject
    dic["iFieldId"] = iFieldId as AnyObject
    dic["objWorkingHours"] = getMASTERDicWorkingHours() as AnyObject
    dic["objServiceProviders"] = getDicServiceProviders() as AnyObject
    dic["objProviderServices"] = getDicProviderServices() as AnyObject
    dic["objCalendarProperties"] = calendarProperties.getDic() as AnyObject
        print("ce calp \(dic["objCalendarProperties"])")
    return dic
    }
    func getMASTERDicWorkingHours()->Array<AnyObject>{

        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

        var arr:Array<AnyObject> = []
        print("NEWARRAYOBJWORKINGHOURS \(Global.sharedInstance.NEWARRAYOBJWORKINGHOURS.count)")
        for it in Global.sharedInstance.NEWARRAYOBJWORKINGHOURS
        {
            dic = it.getDic()

            arr.append(dic as AnyObject)


            print("whxd \(dic)")

        }
        return arr
    }
    func getPartialDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iProviderUserId"] = Global.sharedInstance.currentProvider.iIdBuisnessDetails as AnyObject
        dic["iFieldId"] = iFieldId as AnyObject
        dic["objWorkingHours"] = getDicWorkingHours() as AnyObject
        //employes
        dic["objServiceProviders"] = getDicServiceProviders() as AnyObject
        //services
        dic["objProviderServices"] = getDicProviderServices() as AnyObject
        dic["objCalendarProperties"] = calendarProperties.getPartialDic() as AnyObject
        return dic
    }

}
