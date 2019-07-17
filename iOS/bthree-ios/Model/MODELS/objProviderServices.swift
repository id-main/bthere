//
//  objProviderServices.swift
//  bthree-ios
//
//  Created by User on 30.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class objProviderServices: NSObject {
    
    var nvServiceName:String = ""
    var iPrice:Float = 0
    var nUntilPrice:Float
    var iTimeOfService:Int = 0
    var iUntilSeviceTime:Int = 0
    var iTimeInterval:Int = 0
    var iMaxConcurrentCustomers:Int = 0
    var iDiscount:Int = 0
    var iServiceType:Int = 0//89=שרות=90 או מוצר
    var bDisplayPerCustomer:Bool = true
    var iProviderServiceId:Int = Int()
    var iMinConcurrentCustomers:Int = 0
    var chServiceColor:String = ""

    override init() {
        
        nvServiceName = ""
        iPrice = 0
        iTimeOfService = 0
        nUntilPrice = 0
        iTimeInterval = 0
        iUntilSeviceTime = 0
        iMaxConcurrentCustomers = 0
        iMinConcurrentCustomers = 0
        iDiscount = 0
        iServiceType = 0
        bDisplayPerCustomer = true
        iProviderServiceId = 0
        iMinConcurrentCustomers = 0
        chServiceColor = ""
        iMinConcurrentCustomers = 0
    }
    
    init(_nvServiceName:String,_iPrice:Float,_nUntilPrice:Float,_iTimeOfService:Int,_iUntilSeviceTime:Int//_iConcurrentCustomers:Int
        ,_iTimeInterval:Int,_iMaxConcurrentCustomers:Int,
        _iDiscount:Int,_iServiceType:Int,_bDisplayPerCustomer:Bool,_iProviderServiceId:Int,_iMinConcurrentCustomers:Int) {

        nvServiceName = _nvServiceName
        iPrice = _iPrice
        nUntilPrice = _nUntilPrice
        iTimeOfService = _iTimeOfService
        iUntilSeviceTime = _iUntilSeviceTime
        //iConcurrentCustomers = _iConcurrentCustomers
        iTimeInterval = _iTimeInterval
        iMaxConcurrentCustomers = _iMaxConcurrentCustomers
        
        iDiscount = _iDiscount
        iServiceType = _iServiceType
        bDisplayPerCustomer = _bDisplayPerCustomer
        iProviderServiceId = _iProviderServiceId
        iMinConcurrentCustomers = _iMinConcurrentCustomers
        chServiceColor = ""
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["nvServiceName"] = nvServiceName as AnyObject
        dic["iPrice"] = iPrice as AnyObject
        dic["nUntilPrice"] = nUntilPrice as AnyObject
        dic["iTimeOfService"] = iTimeOfService as AnyObject
        dic["iUntilSeviceTime"] = iUntilSeviceTime as AnyObject
        dic["iTimeInterval"] = iTimeInterval as AnyObject
        dic["iMaxConcurrentCustomers"] = iMaxConcurrentCustomers as AnyObject
        dic["iDiscount"] = iDiscount as AnyObject
        dic["iServiceType"] = iServiceType as AnyObject
        dic["bDisplayPerCustomer"] = bDisplayPerCustomer as AnyObject
        dic["iProviderServiceId"] =  iProviderServiceId as AnyObject
        dic["iMinConcurrentCustomers"] = iMinConcurrentCustomers as AnyObject
        dic["chServiceColor"] = chServiceColor as AnyObject
        return dic
    }
    
    func objProviderServicesToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<objProviderServices>{
        
        var arrServiceProv:Array<objProviderServices> = Array<objProviderServices>()
        var ProvService:objProviderServices = objProviderServices()
        
        for i in 0  ..< arrDic.count
        {
            ProvService = dicToProviderServices(arrDic[i])
            if ProvService.nvServiceName != "BlockHours" {
                arrServiceProv.append(ProvService)
            }
        }
        return arrServiceProv
    }
    
    func dicToProviderServices(_ dic:Dictionary<String,AnyObject>)->objProviderServices
    {
        let serviceProv:objProviderServices = objProviderServices()
        
        serviceProv.nvServiceName = Global.sharedInstance.parseJsonToString(dic["nvServiceName"]!)
        serviceProv.iPrice = Global.sharedInstance.parseJsonToFloat(dic["iPrice"]!)
        serviceProv.nUntilPrice = Global.sharedInstance.parseJsonToFloat(dic["nUntilPrice"]!)
        serviceProv.iTimeOfService = Global.sharedInstance.parseJsonToInt(dic["iTimeOfService"]!)
        serviceProv.iUntilSeviceTime = Global.sharedInstance.parseJsonToInt(dic["iUntilSeviceTime"]!)
        //dic["iConcurrentCustomers"] = iConcurrentCustomers
        serviceProv.iTimeInterval = Global.sharedInstance.parseJsonToInt(dic["iTimeInterval"]!)
        serviceProv.iMaxConcurrentCustomers = Global.sharedInstance.parseJsonToInt(dic["iMaxConcurrentCustomers"]!)
        
        serviceProv.iDiscount =  Global.sharedInstance.parseJsonToInt(dic["iDiscount"]!)
        serviceProv.iServiceType =  Global.sharedInstance.parseJsonToInt(dic["iServiceType"]!)
        serviceProv.bDisplayPerCustomer = dic["bDisplayPerCustomer"]! as! Bool
        
       
        serviceProv.iProviderServiceId =  Global.sharedInstance.parseJsonToInt(dic["iProviderServiceId"]!)
        serviceProv.iMinConcurrentCustomers = Global.sharedInstance.parseJsonToInt(dic["iMinConcurrentCustomers"]!)
        if let _:String = dic["chServiceColor"] as? String {
            serviceProv.chServiceColor = dic["chServiceColor"] as! String
        } else {
             serviceProv.chServiceColor = ""
        }
        return serviceProv
    }
    func objProviderServicesToArrayGet(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<objProviderServices>{
        
        var arrServiceProv:Array<objProviderServices> = Array<objProviderServices>()
        var ProvService:objProviderServices = objProviderServices()
        
        for i in 0  ..< arrDic.count
        {
            ProvService = dicToProviderServicesToGet(arrDic[i])
            if ProvService.nvServiceName != "BlockHours" {
            arrServiceProv.append(ProvService)
           }
        }
        return arrServiceProv
    }

    func dicToProviderServicesToGet(_ dic:Dictionary<String,AnyObject>)->objProviderServices
    {
        let serviceProv:objProviderServices = objProviderServices()
        //
        serviceProv.nvServiceName = Global.sharedInstance.parseJsonToString(dic["nvServiceName"]!)
        serviceProv.iPrice = Global.sharedInstance.parseJsonToFloat(dic["iPrice"]!)
        serviceProv.nUntilPrice = Global.sharedInstance.parseJsonToFloat(dic["nUntilPrice"]!)
        serviceProv.iTimeOfService = Global.sharedInstance.parseJsonToInt(dic["iTimeOfService"]!)
        serviceProv.iUntilSeviceTime = Global.sharedInstance.parseJsonToInt(dic["iUntilSeviceTime"]!)

        //dic["iConcurrentCustomers"] = iConcurrentCustomers
        serviceProv.iTimeInterval = Global.sharedInstance.parseJsonToInt(dic["iTimeInterval"]!)
        serviceProv.iMaxConcurrentCustomers = Global.sharedInstance.parseJsonToInt(dic["iMaxConcurrentCustomers"]!)
        //  dic["iMinConcurrentCustomers"] = iMinConcurrentCustomers
        serviceProv.iDiscount =  Global.sharedInstance.parseJsonToInt(dic["iDiscount"]!)
        serviceProv.iServiceType =  Global.sharedInstance.parseJsonToInt(dic["iServiceType"]!)
        serviceProv.bDisplayPerCustomer = dic["bDisplayPerCustomer"]! as! Bool
        serviceProv.iProviderServiceId =  Global.sharedInstance.parseJsonToInt(dic["iProviderServiceId"]!)
        serviceProv.iMinConcurrentCustomers = Global.sharedInstance.parseJsonToInt(dic["iMinConcurrentCustomers"]!)
        if let _:String = dic["chServiceColor"] as? String {
            serviceProv.chServiceColor = dic["chServiceColor"] as! String
        } else {
            serviceProv.chServiceColor = ""
        }
        return serviceProv
    }

}
