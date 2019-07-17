//
//  ProviderDetailsObj.swift
//  Bthere
//
//  Created by User on 23.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//contain all provider details
class ProviderDetailsObj: NSObject{
    
    //MARK: - Variables
    
    var userObj:objUsers = objUsers()
    
    var objCustomer:Array<CustomerObj> = Array<CustomerObj>()
    
    var providerBuisnessDetailsObj:Provider = Provider()
    
    var providerGeneralDetailsObj:objGeneralDetails = objGeneralDetails()
    
    var providerAlertsSettingsObj:AddProviderAlertSettings = AddProviderAlertSettings()
    
    var providerProfileObj:AddProviderBusinessProfile = AddProviderBusinessProfile()
    
    //MARK: - Initial
    
    override init() {
        userObj = objUsers()
        
        providerBuisnessDetailsObj = Provider()
        
        providerGeneralDetailsObj = objGeneralDetails()
        
        providerAlertsSettingsObj = AddProviderAlertSettings()
        
        providerProfileObj = AddProviderBusinessProfile()
    }
    
    init(_userObj:objUsers,_providerBuisnessDetailsObj:Provider,_providerGeneralDetailsObj:objGeneralDetails,_providerAlertsSettingsObj:AddProviderAlertSettings,_providerProfileObj:AddProviderBusinessProfile)
    {
        userObj = _userObj
        
        providerBuisnessDetailsObj = _providerBuisnessDetailsObj
        
        providerGeneralDetailsObj = _providerGeneralDetailsObj
        
        providerAlertsSettingsObj = _providerAlertsSettingsObj
        
        providerProfileObj = _providerProfileObj
    }
    
    //MARK: - Functions
    
    //get: dictionary to convert,returns: ProviderDetailsObj from the dictionary
    func dicToProviderDetailsObj(_ dic:Dictionary<String,AnyObject>)->ProviderDetailsObj
    {
        let providerDetailsObj:ProviderDetailsObj = ProviderDetailsObj()
        
        if dic["objProviderBuisnessDetails"] as? Dictionary<String,AnyObject> != nil
        {
            providerDetailsObj.providerBuisnessDetailsObj =  providerDetailsObj.providerBuisnessDetailsObj.dicToProvider(dic["objProviderBuisnessDetails"] as! Dictionary<String,AnyObject>)
        }
        if dic["objProviderGeneralDetails"] as? Dictionary<String,AnyObject> != nil
        {
        providerDetailsObj.providerGeneralDetailsObj = providerDetailsObj.providerGeneralDetailsObj.dicToObjGeneralDetails(dic["objProviderGeneralDetails"] as! Dictionary<String,AnyObject>)
        
        }
        if dic["objProviderAlertsSettings"] as? Dictionary<String,AnyObject> != nil
        {
            providerDetailsObj.providerAlertsSettingsObj = providerDetailsObj.providerAlertsSettingsObj.dicToaddProviderAlertSettings(dic["objProviderAlertsSettings"] as! Dictionary<String,AnyObject>)
            
        }
        if dic["objProviderProfile"] as? Dictionary<String,AnyObject> != nil
        {
        providerDetailsObj.providerProfileObj = providerDetailsObj.providerProfileObj.dicToAddProviderBusinessProfile(dic["objProviderProfile"] as! Dictionary<String,AnyObject>)
        }
        if dic["objUser"] as? Dictionary<String,AnyObject> != nil
        {
        providerDetailsObj.userObj = providerDetailsObj.userObj.dicToObjUsers(dic["objUser"] as! Dictionary<String,AnyObject>)
        }
        
        if dic["objCustomer"] as? Array<Dictionary<String,AnyObject>> != nil
        {
            let customer:CustomerObj = CustomerObj()
            providerDetailsObj.objCustomer = customer.customerObjToArray(dic["objCustomer"] as! Array<Dictionary<String,AnyObject>>)
        }
        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
            Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
             print("wtcccc \( Global.sharedInstance.providerID)")
        }
        
        return providerDetailsObj
    }
    func dicToProviderDetailsObjByEmploye(_ dic:Dictionary<String,AnyObject>)->ProviderDetailsObj //do not overwrite current employe dictionary
    {
        let providerDetailsObj:ProviderDetailsObj = ProviderDetailsObj()
        
        if dic["objProviderBuisnessDetails"] as? Dictionary<String,AnyObject> != nil
        {
            providerDetailsObj.providerBuisnessDetailsObj =  providerDetailsObj.providerBuisnessDetailsObj.dicToProvider(dic["objProviderBuisnessDetails"] as! Dictionary<String,AnyObject>)
        }
        if dic["objProviderGeneralDetails"] as? Dictionary<String,AnyObject> != nil
        {
            providerDetailsObj.providerGeneralDetailsObj = providerDetailsObj.providerGeneralDetailsObj.dicToObjGeneralDetails(dic["objProviderGeneralDetails"] as! Dictionary<String,AnyObject>)
            
        }
        if dic["objProviderAlertsSettings"] as? Dictionary<String,AnyObject> != nil
        {
            providerDetailsObj.providerAlertsSettingsObj = providerDetailsObj.providerAlertsSettingsObj.dicToaddProviderAlertSettings(dic["objProviderAlertsSettings"] as! Dictionary<String,AnyObject>)
        }
        if dic["objProviderProfile"] as? Dictionary<String,AnyObject> != nil
        {
            providerDetailsObj.providerProfileObj = providerDetailsObj.providerProfileObj.dicToAddProviderBusinessProfile(dic["objProviderProfile"] as! Dictionary<String,AnyObject>)
        }
//        if dic["objUser"] as? NSDictionary != nil
//        {
//            providerDetailsObj.userObj = providerDetailsObj.userObj.dicToObjUsers(dic["objUser"] as! Dictionary<String,AnyObject>)
//        }
        
        if dic["objCustomer"] as? Array<Dictionary<String,AnyObject>> != nil
        {
            let customer:CustomerObj = CustomerObj()
            providerDetailsObj.objCustomer = customer.customerObjToArray(dic["objCustomer"] as! Array<Dictionary<String,AnyObject>>)
        }
        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
            Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
              print("wtccc2 \( Global.sharedInstance.providerID)")
        }
//
        return providerDetailsObj
    }

    
}
