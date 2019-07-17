//
//  SupplierAlertSettingsObj.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 02.10.2017
//  Copyright © 2017 BThere. All rights reserved.
//

import UIKit

class SupplierAlertSettingsObj: NSObject {

    var iSupplierId:Int = 0
    var bIncomingAppointment:Bool = false
    var bCancellation:Bool = false
    var b10MinutesBeforeAppointment:Bool = false
    var bCustomersFollowUp:Bool = false
    var bBirthday:Bool = false
    var bAnniversary:Bool = false
  

    override init() {
        iSupplierId = 0
        bIncomingAppointment  = false
        bCancellation  = false
        b10MinutesBeforeAppointment  = false
        bCustomersFollowUp = false
        bBirthday = false
        bAnniversary  = false
     }
    
    init(_iSupplierId:Int,_bIncomingAppointment:Bool,_bCancellation:Bool,_b10MinutesBeforeAppointment:Bool,_bCustomersFollowUp:Bool,_bBirthday:Bool,_bAnniversary:Bool) {
        iSupplierId = _iSupplierId
        bIncomingAppointment  = _bIncomingAppointment
        bCancellation  = _bCancellation
        b10MinutesBeforeAppointment  = _b10MinutesBeforeAppointment
        bCustomersFollowUp = _bCustomersFollowUp
        bBirthday = _bBirthday
        bAnniversary  = _bAnniversary

    }
    
    func getDic()->Dictionary<String,AnyObject>
    
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //provider
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        dic["iSupplierId"] = providerID as AnyObject
        dic["bIncomingAppointment"] = bIncomingAppointment as AnyObject
        dic["bCancellation"] = bCancellation as AnyObject
        dic["b10MinutesBeforeAppointment"] =  b10MinutesBeforeAppointment as AnyObject
        dic["bCustomersFollowUp"] = bCustomersFollowUp as AnyObject
        dic["bBirthday"] = bBirthday as AnyObject
        dic["bAnniversary"] = bAnniversary as AnyObject
        return dic
    }
    
    func dicToSupplierAlertSettingsObj(_ rezult: NSDictionary) -> SupplierAlertSettingsObj{
        let returnObj:SupplierAlertSettingsObj = SupplierAlertSettingsObj()
        returnObj.iSupplierId =  rezult["iSupplierId"] as! Int
        returnObj.bIncomingAppointment = rezult["bIncomingAppointment"] as! Bool
        returnObj.bCancellation = rezult["bCancellation"] as! Bool
        returnObj.b10MinutesBeforeAppointment = rezult["b10MinutesBeforeAppointment"] as! Bool
        returnObj.bCustomersFollowUp = rezult["bCustomersFollowUp"] as! Bool
        returnObj.bBirthday = rezult["bBirthday"] as! Bool
        returnObj.bAnniversary = rezult["bAnniversary"] as! Bool
        return returnObj
    }
    func SupplierAlertSettingsObjToArray (_ dic: SupplierAlertSettingsObj) -> Array<Bool> {
        var arrayvalues:Array<Bool> = Array<Bool>()
        var isappoinmentupdatesclick:Bool = false
        var iscustomerseventsclick:Bool = false
        if (dic.bIncomingAppointment == true || dic.bCancellation == true ) {
            isappoinmentupdatesclick = true
        }
        if (dic.bBirthday == true || dic.bAnniversary == true ) {
            iscustomerseventsclick = true
        }
        
        arrayvalues.append(isappoinmentupdatesclick) //this is just for design reason
        arrayvalues.append(dic.bIncomingAppointment)
        arrayvalues.append(dic.bCancellation)
        arrayvalues.append(dic.b10MinutesBeforeAppointment)
        arrayvalues.append(dic.bCustomersFollowUp)
        arrayvalues.append(iscustomerseventsclick) //this is just for design reason
        arrayvalues.append(dic.bBirthday)
        arrayvalues.append(dic.bAnniversary)
        return arrayvalues
    }
   
  }
