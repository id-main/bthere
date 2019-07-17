//
//  SearchResulstsObj.swift
//  Bthere
//
//  Created by Lior Ronen on 18/08/2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class SearchResulstsObj: NSObject {

    var iProviderId:Int = 0
    var nvProviderName:String = ""
    var nvProviderSlogan:String = ""
    var nvAdress:String = ""
    var iDistance:Float = 0.0
    var iCustomerRank:Int = 0
    var IInternalRank:Double = 0.0
    var nvProviderLogo:String = ""
    var nvProviderHeader:String = ""
    var iIsApprovedSupplier:Int = 0
    var iSupplierStatus:Int = 0
    var nvCity:String = ""
    var dRankAvg:Float = 0
    var iRankCount:Int = 0
    override init() {
         iProviderId = 0
         nvProviderName = ""
         nvProviderSlogan = ""
         nvAdress = ""
         iDistance = 0.0
         iCustomerRank = 0
         IInternalRank = 0.0
         nvProviderLogo = ""
         nvProviderHeader = ""
         iIsApprovedSupplier = 0
         nvCity = ""
         dRankAvg = 0
         iRankCount = 0
    }
    
    init(_iProviderId:Int,_nvProviderName:String,_nvProviderSlogan:String,_nvAdress:String,_iDistance:Float,_iCustomerRank:Int,_IInternalRank:Double,_nvProviderLogo:String,_nvProviderHeader:String, _iIsApprovedSupplier:Int,_iSupplierStatus:Int,_nvCity:String,_dRankAvg:Float,_iRankCount:Int) {
        
        iProviderId = _iProviderId
        nvProviderName = _nvProviderName
        nvProviderSlogan = _nvProviderSlogan
        nvAdress = _nvAdress
        iDistance = _iDistance
        iCustomerRank = _iCustomerRank
        IInternalRank = _IInternalRank
        nvProviderLogo = _nvProviderLogo
        nvProviderHeader = _nvProviderHeader
        iIsApprovedSupplier = _iIsApprovedSupplier
        iSupplierStatus = _iSupplierStatus
        nvCity = _nvCity
        dRankAvg = _dRankAvg
        iRankCount = _iRankCount
    }
    
    //בשביל לאתחל את currentProviderToCustomer שאז לא צריך לאתחל את כל הפרטים
    init(_nvProviderName:String,_nvAdress:String,_nvProviderSlogan:String,_nvProviderLogo:String){
        
        nvProviderName = _nvProviderName
        nvAdress = _nvAdress
        nvProviderSlogan = _nvProviderSlogan
        nvProviderLogo = _nvProviderLogo
//        nvCity = _nvCity
    }
    func objProvidersToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<SearchResulstsObj>{
        
        var arrProv:Array<SearchResulstsObj> = Array<SearchResulstsObj>()
        var Prov:SearchResulstsObj = SearchResulstsObj()
        
        for i in 0  ..< arrDic.count
        {
            Prov = dicToProviders(arrDic[i])
            arrProv.append(Prov)
        }
        return arrProv
    }
    
    func dicToProviders(_ dic:Dictionary<String,AnyObject>)->SearchResulstsObj
    {

        let provider:SearchResulstsObj = SearchResulstsObj()
        
        provider.iProviderId = Global.sharedInstance.parseJsonToInt(dic["iProviderId"]!)//√
        
        if dic["nvProviderName"] != nil
        {
            provider.nvProviderName = dic["nvProviderName"]! as! String
        }
        else
        {
          provider.nvProviderName =  ""
        }
        if let _ = dic["nvProviderName"] as? String {
        provider.nvProviderName = Global.sharedInstance.parseJsonToString(dic["nvProviderName"]!)//√
        }
         if let _ = dic["nvProviderSlogan"] as? String {
        provider.nvProviderSlogan = Global.sharedInstance.parseJsonToString(dic["nvProviderSlogan"]!)//√
        }
        if let _ = dic["nvAdress"] as? String {
        provider.nvAdress = Global.sharedInstance.parseJsonToString(dic["nvAdress"]!)//√
        }
        
        if let _ = dic["nvCity"] as? String
        {
            provider.nvCity = Global.sharedInstance.parseJsonToString(dic["nvCity"]!)
        }
 
        if let _ = dic["iDistance"] as? Float
        {
            provider.iDistance = Global.sharedInstance.parseJsonToFloat(dic["iDistance"]!)
        }
        else if let _ = dic["iDistance"] as? Double
        {
            provider.iDistance = Float(Global.sharedInstance.parseJsonToDouble(dic["iDistance"]!))
        }
        else if let _ = dic["iDistance"] as? Int
        {
            provider.iDistance = Float(Global.sharedInstance.parseJsonToInt(dic["iDistance"]!))
        }
//        provider.iDistance = Global.sharedInstance.parseJsonToFloat(dic["iDistance"]!)//√
     
        provider.iCustomerRank = Global.sharedInstance.parseJsonToInt(dic["iCustomerRank"]!)//√
        provider.IInternalRank = Global.sharedInstance.parseJsonToDouble(dic["IInternalRank"]!)//√
        provider.nvProviderLogo = Global.sharedInstance.parseJsonToString(dic["nvProviderLogo"]!)//√
        provider.nvProviderHeader = Global.sharedInstance.parseJsonToString(dic["nvProviderHeader"]!)//√

       if let _:Int =  dic["iIsApprovedSupplier"]  as? Int {
        provider.iIsApprovedSupplier = dic["iIsApprovedSupplier"]  as! Int
        }
        if let _ = dic["iSupplierStatus"] as? Int {
        provider.iSupplierStatus = Global.sharedInstance.parseJsonToInt(dic["iSupplierStatus"]!)//√
        } else {
            
         provider.iSupplierStatus = 0
        }
        
        if let _ = dic["dRankAvg"] as? Float
        {
            provider.dRankAvg = Global.sharedInstance.parseJsonToFloat(dic["dRankAvg"]!)
        }
        else if let _ = dic["dRankAvg"] as? Double
        {
            provider.dRankAvg = Float(Global.sharedInstance.parseJsonToDouble(dic["dRankAvg"]!))
        }
        else if let _ = dic["dRankAvg"] as? Int
        {
            provider.dRankAvg = Float(Global.sharedInstance.parseJsonToInt(dic["dRankAvg"]!))
        }
        if let _ = dic["iRankCount"] as? Int
        {
            provider.iRankCount = Global.sharedInstance.parseJsonToInt(dic["iRankCount"]!)
        }
        
        
        return provider

        
        }

    func printSearchResultObject(obj:SearchResulstsObj) ->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iProviderId"] = obj.iProviderId as AnyObject
        dic["nvProviderSlogan"] = obj.nvProviderSlogan as AnyObject
        dic["nvAdress"] = obj.nvAdress as AnyObject
        dic["iDistance"] = obj.iDistance as AnyObject
        dic["iCustomerRank"] = obj.iCustomerRank as AnyObject
        dic["IInternalRank"] = obj.IInternalRank as AnyObject
//        dic["nvProviderLogo"] = obj.nvProviderLogo as AnyObject
//        dic["nvProviderHeader"] = obj.nvProviderHeader as AnyObject
        dic["iIsApprovedSupplier"] = obj.iIsApprovedSupplier as AnyObject
        dic["iSupplierStatus"] = obj.iSupplierStatus as AnyObject
        dic["nvCity"] = obj.nvCity as AnyObject
        dic["dRankAvg"] = obj.dRankAvg as AnyObject
        dic["iRankCount"] = obj.iRankCount as AnyObject
        dic["nvProviderName"] = obj.nvProviderName as AnyObject

        return dic
    }

}
