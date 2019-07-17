//
//  ProviderServiceDetailsObj.swift
//  Bthere
//
//  Created by User on 22.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class ProviderServiceDetailsObj: NSObject {
  
    var iProviderServiceId:Int = 0
    var nvServiceName:String = ""
    var chServiceColor:String = ""
    override init() {
        iProviderServiceId = 0
         nvServiceName = ""
         chServiceColor = ""
    }
    
    init(_iProviderServiceId:Int,_nvServiceName:String,_chServiceColor:String) {
        iProviderServiceId = _iProviderServiceId
        nvServiceName = _nvServiceName
        chServiceColor = _chServiceColor
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iProviderServiceId"] = iProviderServiceId as AnyObject
        dic["nvServiceName"] = nvServiceName as AnyObject
        dic["chServiceColor"] = chServiceColor as AnyObject
        return dic
    }
    
    
    
    func getFromDic(_ dic:Dictionary<String,AnyObject>) -> ProviderServiceDetailsObj {
        let providerServiceDetailsObj:ProviderServiceDetailsObj = ProviderServiceDetailsObj()
        providerServiceDetailsObj.iProviderServiceId = Global.sharedInstance.parseJsonToInt(dic["iProviderServiceId"]!)
        providerServiceDetailsObj.nvServiceName = Global.sharedInstance.parseJsonToString(dic["nvServiceName"]!)
        if dic["chServiceColor"] != nil {
        providerServiceDetailsObj.chServiceColor = Global.sharedInstance.parseJsonToString(dic["chServiceColor"]!)
        }
        return providerServiceDetailsObj
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
    
    func ProviderServiceDetailsObjToArrayGet(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<ProviderServiceDetailsObj>{
        
        
        //formatter.locale = NSLocale(localeIdentifier: "US_en")
        //formatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00")
        
        var ProviderServiceDetailsObjArray:Array<ProviderServiceDetailsObj> = Array<ProviderServiceDetailsObj>()
        var providerServiceDetailsObj:ProviderServiceDetailsObj = ProviderServiceDetailsObj()
        
        for i in 0  ..< arrDic.count
        {
            providerServiceDetailsObj = getFromDic(arrDic[i])
            ProviderServiceDetailsObjArray.append(providerServiceDetailsObj)
            
            
        }
        return ProviderServiceDetailsObjArray
    }

}
