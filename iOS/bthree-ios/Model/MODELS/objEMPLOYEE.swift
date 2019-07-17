//
//  objEMPLOYEE.swift
//  bthree-ios

import UIKit

class objEMPLOYEE: NSObject {
    var objsers:User = User()
    var arrObjWorkingHours:Array<objWorkingHours> = Array<objWorkingHours>()
    var bSameWH:Bool = false
    var liPermissionType:Array<Int> = Array<Int>()       //[1001,1002]
    var objProviderServicesIDS:Array<Int> = Array<Int>()
    var objProviderServicesx:Array<objProviderServices> = Array<objProviderServices>()// {"iProviderServiceId":3289,"nvServiceName":"O PL"}

    override init() {
        objsers = User()
        arrObjWorkingHours = Array<objWorkingHours>()
        bSameWH = false
        liPermissionType = []
        objProviderServicesIDS = []
        objProviderServicesx = Array<objProviderServices>()
    }
    
    init(_objsers:User,_arrObjWorkingHours:Array<objWorkingHours>,_bSameWH:Bool, _liPermissionType:Array<Int>, _objProviderServices:Array<Int>) {
        objsers = _objsers
        arrObjWorkingHours = _arrObjWorkingHours
        bSameWH = _bSameWH
        liPermissionType = _liPermissionType
        objProviderServicesIDS = _objProviderServices
      //  objProviderServicesx = _objProviderServices

    }
    
    func getdicWorkingHours()->Array<AnyObject>{
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var arr:Array<AnyObject> = []
        for it in arrObjWorkingHours
        {
            dic = it.getDic()
            arr.append(dic as AnyObject)
        }
        return arr
    }
    func getdicservicesarray()->Array<AnyObject>{
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var arr:Array<AnyObject> = []
        for it in objProviderServicesx
        {
            dic = it.getDic()
            arr.append(dic as AnyObject)
        }
        return arr
    }



    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["objUsers"] = objsers.getDic() as AnyObject
        dic["bSameWH"] = bSameWH as AnyObject
        dic["objWorkingHours"] = getdicWorkingHours() as AnyObject
        dic["liPermissionType"] = liPermissionType as AnyObject
        dic["objProviderServices"] = objProviderServicesIDS as AnyObject // getdicservicesarray() as AnyObject
        return dic
    }
    
    func objServiceProvidersToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<objEMPLOYEE>{
        var arrServiceProv:Array<objEMPLOYEE> = Array<objEMPLOYEE>()
        var ServiceProv:objEMPLOYEE = objEMPLOYEE()
        for i in 0  ..< arrDic.count
        {
            ServiceProv = dicToServiceProviders(arrDic[i])
            arrServiceProv.append(ServiceProv)
        }
        return arrServiceProv
    }
    
    func dicToServiceProviders(_ dic:Dictionary<String,AnyObject>)->objEMPLOYEE
    {
        let serviceProv:objEMPLOYEE = objEMPLOYEE()
        serviceProv.objsers = objsers.dicToUser(dic["objUsers"]! as! Dictionary<String,AnyObject>)
        serviceProv.bSameWH = dic["bSameWH"] as! Bool
        let workingHours:objWorkingHours = objWorkingHours()
        if dic["objWorkingHours"] as? Array<Dictionary<String,AnyObject>> != nil {
        serviceProv.arrObjWorkingHours = workingHours.objWorkingHoursToArray(dic["objWorkingHours"] as! Array<Dictionary<String,AnyObject>>)
        }
        if dic["liPermissionType"] as? Array<Int> != nil {
            serviceProv.liPermissionType = dic["liPermissionType"] as! Array<Int>
        }
  //      if dic["objProviderServices"] as? Array<Dictionary<String,AnyObject>> != nil {
        if dic["objProviderServices"] as? Array<Int> != nil {
         //   serviceProv.objProviderServicesx = objProviderServicesToArray(dic["objProviderServices"]  as! Array<Dictionary<String,AnyObject>>)
            serviceProv.objProviderServicesIDS = dic["objProviderServices"] as! Array<Int>
        }
        print(serviceProv.getDic())
        return serviceProv
    }
    func objProviderServicesToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<objProviderServices>{
        var arrServiceProv:Array<objProviderServices> = Array<objProviderServices>()
        var ProvService:objProviderServices = objProviderServices()
        for i in 0  ..< arrDic.count
        {
            ProvService = dicToProviderServices(arrDic[i])
                arrServiceProv.append(ProvService)
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
}
