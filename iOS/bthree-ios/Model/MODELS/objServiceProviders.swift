//
//  objServiceProviders.swift
//  bthree-ios
//
//  Created by User on 30.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class objServiceProviders: NSObject {
    var objsers:objUsers = objUsers()
    var arrObjWorkingHours:Array<objWorkingHours> = Array<objWorkingHours>()
    var bSameWH:Bool = false
    var liPermissionType:Array<Int> = Array<Int>()       //[1001,1002]
    var objProviderServices:Array<objProviderServices> = Array<objProviderServices>()// {"iProviderServiceId":3289,"nvServiceName":"O PL"}

    override init() {
        objsers = objUsers()
        arrObjWorkingHours = Array<objWorkingHours>()
        bSameWH = false
        liPermissionType = []
        objProviderServices = Array<objProviderServices>()
    }
    
    init(_objsers:objUsers,_arrObjWorkingHours:Array<objWorkingHours>,_bSameWH:Bool, _liPermissionType:Array<Int>, _objProviderServices:Array<objProviderServices>) {
        objsers = _objsers
        arrObjWorkingHours = _arrObjWorkingHours
        bSameWH = _bSameWH
        liPermissionType = _liPermissionType
        objProviderServices = _objProviderServices

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
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["objUsers"] = objsers.getDic() as AnyObject
        dic["bSameWH"] = bSameWH as AnyObject
        dic["objWorkingHours"] = getdicWorkingHours() as AnyObject
        dic["liPermissionType"] = liPermissionType as AnyObject
        dic["objProviderServices"] = objProviderServices as AnyObject
        return dic
    }
    
    func objServiceProvidersToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<objServiceProviders>{
        var arrServiceProv:Array<objServiceProviders> = Array<objServiceProviders>()
        var ServiceProv:objServiceProviders = objServiceProviders()
        for i in 0  ..< arrDic.count
        {
            ServiceProv = dicToServiceProviders(arrDic[i])
            arrServiceProv.append(ServiceProv)
        }
        return arrServiceProv
    }
    
    func dicToServiceProviders(_ dic:Dictionary<String,AnyObject>)->objServiceProviders
    {
        let serviceProv:objServiceProviders = objServiceProviders()
        serviceProv.objsers = serviceProv.objsers.dicToObjUsers(dic["objUsers"]! as! Dictionary<String,AnyObject>)
        serviceProv.bSameWH = dic["bSameWH"] as! Bool
        let workingHours:objWorkingHours = objWorkingHours()
        if dic["objWorkingHours"] as? Array<Dictionary<String,AnyObject>> != nil {
        serviceProv.arrObjWorkingHours = workingHours.objWorkingHoursToArray(dic["objWorkingHours"] as! Array<Dictionary<String,AnyObject>>)
        }
        if dic["liPermissionType"] as? Array<Int> != nil {
            serviceProv.liPermissionType = dic["liPermissionType"] as! Array<Int>
        }
        if dic["objProviderServices"] as? Array<objProviderServices> != nil {
            serviceProv.objProviderServices = dic["objProviderServices"] as! Array<objProviderServices>
        }
        print(serviceProv.getDic())
        return serviceProv
    }
}
