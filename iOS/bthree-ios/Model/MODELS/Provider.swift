//
//  Provider.swift
//  bthree-ios
//
//  Created by User on 27.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class Provider: NSObject {
    
    var iUserId:Int = 0
    var iIdBuisnessDetails:Int = 0
    
    var nvSupplierName:String = ""
    var nvBusinessIdentity:String = ""
    var nvAddress:String = ""
    var nvCity:String = ""
    var iCityType:Int = 0
    var nvPhone:String = ""
    var nvFax:String = ""
    var nvEmail:String = ""
    var nvSiteAddress:String = ""
    var nvFacebookLink:String = ""
    var nvInstagramLink:String = ""
   
    override init() {
        iUserId = 0
        iIdBuisnessDetails = 0
        
        nvSupplierName = ""
        nvBusinessIdentity = ""
        nvAddress = ""
        nvCity = ""
        iCityType = 0
        nvPhone = ""
        nvFax = ""
        nvEmail = ""
        nvSiteAddress = ""
        nvFacebookLink = ""
        nvInstagramLink = ""
    }
    
    init(_iUserId:Int,_iIdBuisnessDetails:Int,_nvSupplierName:String,_nvBusinessIdentity:String,_nvAddress:String,_nvCity:String,_iCityType:Int,_nvPhone:String,_nvFax:String,_nvEmail:String,_nvSiteAddress:String, _nvFacebookLink:String, _nvInstagramLink:String) {
        
        iUserId = _iUserId
        iIdBuisnessDetails = _iIdBuisnessDetails
        
        nvSupplierName = _nvSupplierName
        nvBusinessIdentity = _nvBusinessIdentity
        nvAddress = _nvAddress
        nvCity = _nvCity
        iCityType = _iCityType
        nvPhone = _nvPhone
        nvFax = _nvFax
        nvEmail = _nvEmail
        nvSiteAddress = _nvSiteAddress
        nvFacebookLink = _nvFacebookLink
        nvInstagramLink = _nvInstagramLink
        
    }

    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iUserId"] = iUserId as AnyObject
        dic["iBusinessId"] = Global.sharedInstance.currentProvider.iIdBuisnessDetails as AnyObject
        //dic["iIdBuisnessDetails"] = iIdBuisnessDetails
        
        dic["nvSupplierName"] = nvSupplierName as AnyObject
        dic["nvBusinessIdentity"] = nvBusinessIdentity as AnyObject
        dic["nvAddress"] = nvAddress as AnyObject
        dic["nvCity"] = nvCity as AnyObject
        dic["iCityType"] = iCityType as AnyObject
        dic["nvPhone"] = nvPhone as AnyObject
        dic["nvFax"] = nvFax as AnyObject
        dic["nvEmail"] = nvEmail as AnyObject
        dic["nvFacebookLink"] = nvFacebookLink as AnyObject
        dic["nvInstagramLink"] = nvInstagramLink as AnyObject
        dic["nvSiteAddress"] = nvSiteAddress as AnyObject
        
        return dic
    }
    //2do-delete
    func getDicExample()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iUserId"] = 14281 as AnyObject
        dic["iBusinessId"] = 0 as AnyObject
        dic["nvSupplierName"] = "abc" as AnyObject
        dic["nvBusinessIdentity"] = "asddf" as AnyObject
        dic["nvAddress"] = "sdfu dsfds" as AnyObject
        dic["nvCity"] = "dfsf" as AnyObject
        dic["iCityType"] = 0 as AnyObject
        dic["nvPhone"] = "054777777" as AnyObject
        dic["nvFax"] = "" as AnyObject
        dic["nvEmail"] = "sdfdf@dfg.dfgd" as AnyObject
        dic["nvSiteAddress"] = "" as AnyObject
        
        return dic
    }

    

    //לשים לב לפני השימוש בפונקציה שהשמשתנים שחוזרים מהשרת הם בדיוק באותם שמות
    func dicToProvider(_ dic:Dictionary<String,AnyObject>)->Provider
    {
        let provider:Provider = Provider()
//          print("crash userid \(dic["iUserId"] ?? 1 as AnyObject)")
        provider.iUserId = Global.sharedInstance.parseJsonToInt(dic["iUserId"]!)//√
        
        if dic["iSupplierId"] != nil
        {
            provider.iIdBuisnessDetails = Global.sharedInstance.parseJsonToInt(dic["iSupplierId"]!)
        }
        else
        {
             provider.iIdBuisnessDetails = Global.sharedInstance.parseJsonToInt(dic["iBusinessId"]!)
        }
        
        provider.nvSupplierName = Global.sharedInstance.parseJsonToString(dic["nvSupplierName"]!)//√
        provider.nvBusinessIdentity = Global.sharedInstance.parseJsonToString(dic["nvBusinessIdentity"]!)//√
        provider.nvAddress = Global.sharedInstance.parseJsonToString(dic["nvAddress"]!)//√
        provider.iCityType = Global.sharedInstance.parseJsonToInt(dic["iCityType"]!)//√
        provider.nvPhone = Global.sharedInstance.parseJsonToString(dic["nvPhone"]!)//√
        provider.nvFax = Global.sharedInstance.parseJsonToString(dic["nvFax"]!)//√
        provider.nvEmail = Global.sharedInstance.parseJsonToString(dic["nvEmail"]!)//√
        provider.nvSiteAddress = Global.sharedInstance.parseJsonToString(dic["nvSiteAddress"]!)//√
        provider.nvCity = Global.sharedInstance.parseJsonToString(dic["nvCity"]!)//√
//        provider.nvFacebookLink = Global.sharedInstance.parseJsonToString(dic["nvFacebookLink"]!)//√ iustin
//        provider.nvInstagramLink = Global.sharedInstance.parseJsonToString(dic["nvInstagramLink"]!)//√ iustin
        provider.nvFacebookLink = "asdasd"//√ iustin
        provider.nvInstagramLink = "adasda"//√ iustin
        
        
        return provider
    }
}
