//
//  CustomerObj.swift
//  Bthere
//
//  Created by User on 23.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class CustomerObj: NSObject {

    var userObj:objUsers = objUsers()
    var iProviderId:Int = 0
    var bIsVip:Bool = Bool()
    
    override init() {
        userObj = objUsers()
        iProviderId = 0
        bIsVip = Bool()
    }
    
    func dicToCustomerObj(_ dic:Dictionary<String,AnyObject>)->CustomerObj
    {
        let customerObj:CustomerObj = CustomerObj()
        
        customerObj.userObj = customerObj.userObj.dicToObjUsers(dic["userObj"] as! Dictionary<String,AnyObject>)
        customerObj.iProviderId = Global.sharedInstance.parseJsonToInt(dic["iProviderId"]!)
        customerObj.bIsVip = dic["bIsVip"] as! Bool
  
        return customerObj
    }
    
    
    
    func customerObjToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<CustomerObj>
    {
        
        var arrCustomerObj:Array<CustomerObj> = Array<CustomerObj>()
        var objCustomerObj:CustomerObj = CustomerObj()
        
        for i in 0  ..< arrDic.count 
        {
            objCustomerObj = dicToCustomerObj(arrDic[i])
            arrCustomerObj.append(objCustomerObj)
        }
        return arrCustomerObj
    }
}
