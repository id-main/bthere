//
//  OrderDetailsObj.swift
//  Bthere
//
//  Created by User on 22.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class OrderDetailsObj: NSObject {
    
    //    int iCoordinatedServiceId
    //    int iProviderUserId
    //    string nvFirstName
    //    string nvSupplierName
    //    //ProviderServiceDetailsObj[] objProviderServiceDetails
    //    int iDayInWeek
    //    string dtDateOrder
    //    string nvFromHour
    //    string nvAddress
    
    var iCoordinatedServiceId:Int = 0
    var iProviderUserId:Int = 0
    var nvFirstName:String = ""
    var nvSupplierName:String = ""
    var objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
    var iDayInWeek:Int = 0
    
    var dtDateOrder:Date = Date()//תאריך הארוע
    
    var nvFromHour:String = ""
    var nvToHour:String = ""
    var nvAddress:String = ""
    var objProviderServiceDetail = ProviderServiceDetailsObj()
    var nvComment:String = ""
    var nvLogo:String = ""
    var iUserId:Int = 0
    var title:String = ""
    var chServiceColor:String = ""
    var iSupplierId:Int = 0
    var iCoordinatedServiceStatusType:Int = 0 //actually is iCoordinatedServiceStatusType
    var nvLastName:String = ""
    var nvPhone:String = ""
    var orderTimeZone:Int = 0   // this is not in init is completed from JSON parse
    override init()
    {
        iCoordinatedServiceId = 0
        iProviderUserId = 0
        nvFirstName = ""
        nvSupplierName = ""
        iDayInWeek = 0
        dtDateOrder = Date()
        nvFromHour = ""
        nvToHour = ""
        nvAddress = ""
        objProviderServiceDetails = []
        nvComment = ""
        nvLogo = ""
        iUserId = 0
        title = ""
        chServiceColor = ""
        iSupplierId = 0
        iCoordinatedServiceStatusType = 0
        nvLastName = ""
        nvPhone = ""
        orderTimeZone = 0
    }
    
    init(_iCoordinatedServiceId:Int,_iProviderUserId:Int,_nvFirstName:String,_nvSupplierName:String,_objProviderServiceDetails:Array<ProviderServiceDetailsObj>,_iDayInWeek:Int,_dtDateOrder:Date,_nvFromHour:String,_nvToHour:String,_nvAddress:String,_nvComment:String, _nvLogo:String, _iUserId:Int,_title:String,_chServiceColor:String,_iSupplierId:Int,_iCoordinatedServiceStatusType:Int,_nvLastName:String,_nvPhone:String) {
        iCoordinatedServiceId = _iCoordinatedServiceId
        iProviderUserId = _iProviderUserId
        nvFirstName = _nvFirstName
        nvSupplierName = _nvSupplierName
        objProviderServiceDetails = _objProviderServiceDetails
        iDayInWeek = _iDayInWeek
        dtDateOrder = _dtDateOrder
        nvFromHour = _nvFromHour
        nvToHour = _nvToHour
        nvAddress = _nvAddress
        nvComment = _nvComment
        nvLogo = _nvLogo
        iUserId = _iUserId
        title = _title
        chServiceColor = _chServiceColor
        iSupplierId = _iSupplierId
        iCoordinatedServiceStatusType = _iCoordinatedServiceStatusType
        nvLastName = _nvLastName
        nvPhone = _nvPhone

    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iCoordinatedServiceId"] = iCoordinatedServiceId as AnyObject
        dic["iProviderUserId"] = iProviderUserId as AnyObject
        dic["nvFirstName"] = nvFirstName as AnyObject
        dic["nvSupplierName"] = nvSupplierName as AnyObject
        dic["dtDateOrder"] = Global.sharedInstance.convertNSDateToString(self.dtDateOrder) as AnyObject
        dic["objProviderServiceDetails"] = objProviderServiceDetails as AnyObject
        dic["iDayInWeek"] = iDayInWeek as AnyObject
        dic["nvFromHour"] = nvFromHour as AnyObject
        dic["nvToHour"] = nvToHour as AnyObject
        dic["nvAddress"] = nvAddress as AnyObject
        dic["nvComment"] = nvComment as AnyObject
        dic["nvLogo"] = nvLogo as AnyObject
        dic["iUserId"] = iUserId as AnyObject
        dic["title"] = title as AnyObject
        dic["chServiceColor"] = chServiceColor as AnyObject
        dic["iSupplierId"] = iSupplierId as AnyObject
        dic["iCoordinatedServiceStatusType"] = iCoordinatedServiceStatusType as AnyObject
        dic["nvLastName"] = nvLastName as AnyObject
        dic["nvPhone"] = nvPhone as AnyObject
        dic["orderTimeZone"] = orderTimeZone as AnyObject
        return dic
    }
    
    func getFromDic(_ dic:Dictionary<String,AnyObject>) -> OrderDetailsObj {
        
        let orderDetailsObj:OrderDetailsObj = OrderDetailsObj()
        if let _:Int = dic["iCoordinatedServiceId"] as? Int {
            orderDetailsObj.iCoordinatedServiceId = Global.sharedInstance.parseJsonToInt(dic["iCoordinatedServiceId"]!)
        } else {
            orderDetailsObj.iCoordinatedServiceId = 0
        }
        
        if let _:Int = dic["iProviderUserId"] as? Int {
            orderDetailsObj.iProviderUserId = Global.sharedInstance.parseJsonToInt(dic["iProviderUserId"]!)
        } else {
            orderDetailsObj.iProviderUserId = 0
        }
        
        if let _:String = dic["nvFirstName"] as? String {
            orderDetailsObj.nvFirstName = Global.sharedInstance.parseJsonToString(dic["nvFirstName"]!)
        } else {
             orderDetailsObj.nvFirstName = ""
        }
        
        if let _:String = dic["nvSupplierName"] as? String {
            orderDetailsObj.nvSupplierName = Global.sharedInstance.parseJsonToString(dic["nvSupplierName"]!)
        } else {
            orderDetailsObj.nvSupplierName = ""
        }
        
        if let _:Int = dic["iDayInWeek"] as? Int {
            orderDetailsObj.iDayInWeek = Global.sharedInstance.parseJsonToInt(dic["iDayInWeek"]!)
        } else {
            orderDetailsObj.iDayInWeek = 0
        }
        
        if let _:String = dic["nvFromHour"] as? String {
            orderDetailsObj.nvFromHour = Global.sharedInstance.parseJsonToString(dic["nvFromHour"]!)
        } else {
            orderDetailsObj.nvFromHour = ""
        }
        
        if let _:String = dic["nvToHour"] as? String {
            orderDetailsObj.nvToHour = Global.sharedInstance.parseJsonToString(dic["nvToHour"]!)
        } else {
            orderDetailsObj.nvToHour = ""
        }
        
        if let _:String = dic["nvAddress"] as? String {
            orderDetailsObj.nvAddress = Global.sharedInstance.parseJsonToString(dic["nvAddress"]!)
        } else {
            orderDetailsObj.nvAddress = ""
        }
        
        if let _:String = dic["dtDateOrder"] as? String {
            let dt:Date = Global.sharedInstance.getStringFromDateString(dic["dtDateOrder"] as! String)
            orderDetailsObj.dtDateOrder = dt
            orderDetailsObj.orderTimeZone = Global.sharedInstance.getTimeZoneFromDateString((dic["dtDateOrder"] as! String))
        } else{
             orderDetailsObj.dtDateOrder = Date()
            orderDetailsObj.orderTimeZone = 0
        }

        
        if let _:String = dic["nvComment"] as? String {
            orderDetailsObj.nvComment = Global.sharedInstance.parseJsonToString(dic["nvComment"]!)
        } else {
            orderDetailsObj.nvComment = ""
        }
        
        if let _:String = dic["nvLogo"] as? String {
            orderDetailsObj.nvLogo = Global.sharedInstance.parseJsonToString(dic["nvLogo"]!)
        } else {
            orderDetailsObj.nvLogo = ""
        }
        
        if let _:Int = dic["iUserId"] as? Int {
            orderDetailsObj.iUserId = Global.sharedInstance.parseJsonToInt(dic["iUserId"]!)
        } else {
             orderDetailsObj.iUserId = 0
        }
        
        orderDetailsObj.title = "BlockedBySupplier"
        
        var arr = NSArray()
        
        arr = dic["objProviderServiceDetails"] as! NSArray
        
        if dic["chServiceColor"] != nil || dic["chServiceColor"] as! String != "<null>"  {
            orderDetailsObj.chServiceColor = Global.sharedInstance.parseJsonToString(dic["chServiceColor"]!)
        } else {
            orderDetailsObj.chServiceColor = ""
        }
        
        if let _:Int = dic["iSupplierId"] as? Int {
            orderDetailsObj.iSupplierId = Global.sharedInstance.parseJsonToInt(dic["iSupplierId"]!)
        } else {
            orderDetailsObj.iSupplierId = 0
        }
        orderDetailsObj.objProviderServiceDetails = objProviderServiceDetail.ProviderServiceDetailsObjToArrayGet(arr as! Array<Dictionary<String, AnyObject>>)//שתי האוביקטים שמוסלשים בגלל שלא ידעתי איך לאתחל אותם ואני לא בטוחה שצריך את זה
        
        if let _:Int = dic["iCoordinatedServiceStatusType"] as? Int {
            orderDetailsObj.iCoordinatedServiceStatusType = Global.sharedInstance.parseJsonToInt(dic["iCoordinatedServiceStatusType"]!)
        } else {
            orderDetailsObj.iCoordinatedServiceStatusType = 0
        }
        
        if let _:String = dic["nvLastName"] as? String {
            orderDetailsObj.nvLastName = Global.sharedInstance.parseJsonToString(dic["nvLastName"]!)
        } else {
            orderDetailsObj.nvLastName = ""
        }
        
        if let _:String = dic["nvPhone"] as? String {
            orderDetailsObj.nvPhone = Global.sharedInstance.parseJsonToString(dic["nvPhone"]!)
        } else {
            orderDetailsObj.nvPhone = ""
        }
        return orderDetailsObj
        
    }
    
    func OrderDetailsObjToArrayGet(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<OrderDetailsObj>{
        
        //formatter.locale = NSLocale(localeIdentifier: "US_en")
        //formatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00")
        
        var arrOrderDetailsObj:Array<OrderDetailsObj> = Array<OrderDetailsObj>()
        var orderDetailsObj:OrderDetailsObj = OrderDetailsObj()
        
        for i in 0  ..< arrDic.count
        {
            orderDetailsObj = getFromDic(arrDic[i])
            arrOrderDetailsObj.append(orderDetailsObj)
            
        }
        return arrOrderDetailsObj
    }
    
    func convertNSDateToString(_ dateTOConvert:Date)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //let dateStr = dateFormatter.stringFromDate(dateTOConvert)
        
        var myDateString = String(Int64(dateTOConvert.timeIntervalSince1970 * 1000))
        myDateString = "/Date(\(myDateString))/"
        
        
        return myDateString
    }
    
}
