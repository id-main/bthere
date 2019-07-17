//
//  objUsers.swift
//  bthree-ios
//
//  Created by User on 30.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//contains user details as customer
class objUsers: NSObject {

    //MARK: - Variables
    
    var nvUserName:String = ""
    var nvFirstName:String = ""
    var nvLastName:String = ""
    var dBirthdate:Date = Date()
    var nvMail:String = ""
   /// var nvAdress:String = ""
    var iCityType:Int = 0
    var nvPhone:String = ""
    var nvPassword:String = ""
    var nvVerification:String = ""
    var bAutomaticUpdateApproval:Bool = false
    var bDataDownloadApproval:Bool = false
    var bTermOfUseApproval:Bool = false
    var bAdvertisingApproval:Bool = false
    var iUserStatusType:Int = 0
    var bIsGoogleCalendarSync:Bool = true
    var iCreatedByUserId:Int = 0
    var iLastModifyUserId:Int = 0
    var iSysRowStatus:Int = 0
    var bIsManager:Int = 0
    var iUserId:Int = 0
    var allPHONES:Array<String> = Array<String>()
    var nvNickName:String = ""
    
   // var nvSupplierNotes = ""
    //MARK: - Initial
    
    override init() {
        nvUserName = ""
        nvFirstName = ""
        nvLastName = ""
        dBirthdate = Date()
        nvMail = ""
      //  nvAdress = ""
        iCityType = 0
        nvPhone = ""
        nvPassword = ""
        nvVerification = ""
        bAutomaticUpdateApproval = false
        bDataDownloadApproval = false
        bTermOfUseApproval = false
        bAdvertisingApproval = false
        iUserStatusType = 0
        bIsGoogleCalendarSync = false
        iCreatedByUserId = 0
        iLastModifyUserId = 0
        iSysRowStatus = 0
        bIsManager = 0
        iUserId = 0
        allPHONES = []
        nvNickName = ""
       
     //   nvSupplierNotes = ""
    }
    
    init( _nvUserName:String,_nvFirstName:String,_nvLastName:String, _dBirthdate:Date,_nvMail:String,/*_nvAdress:String,*/_iCityType:Int,_nvPhone:String,_nvPassword:String,_nvVerification:String,_bAutomaticUpdateApproval:Bool,_bDataDownloadApproval:Bool,_bTermOfUseApproval:Bool,_bAdvertisingApproval:Bool,_iUserStatusType:Int,_bIsGoogleCalendarSync:Bool,_iCreatedByUserId:Int,_iLastModifyUserId:Int,_iSysRowStatus:Int, _bIsManager:Int, _iUserId:Int, _allPHONES:Array<String>, _nvNickName:String /*_nvSupplierNotes:String*/)
    {
        nvUserName = _nvUserName
        nvFirstName = _nvFirstName
        nvLastName = _nvLastName
        dBirthdate = _dBirthdate
        nvMail = _nvMail
       // nvAdress = _nvAdress
        iCityType = _iCityType
        nvPhone = _nvPhone
        nvPassword = _nvPassword
        nvVerification = _nvVerification
        bAutomaticUpdateApproval = _bAutomaticUpdateApproval
        bDataDownloadApproval = _bDataDownloadApproval
        bTermOfUseApproval = _bTermOfUseApproval
        bAdvertisingApproval = _bAdvertisingApproval
        iUserStatusType = _iUserStatusType
        bIsGoogleCalendarSync = _bIsGoogleCalendarSync
        iCreatedByUserId = _iCreatedByUserId
        iLastModifyUserId = _iLastModifyUserId
        iSysRowStatus = _iSysRowStatus
        bIsManager = _bIsManager
        iUserId = _iUserId
        allPHONES = _allPHONES
        nvNickName = _nvNickName
        //nvSupplierNotes = _nvSupplierNotes
    }
    
    //MARK: - Functions
    
    //return the obj as dictionary, help to send to server
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        dic["nvUserName"] = nvUserName as AnyObject
        dic["nvFirstName"] = nvFirstName as AnyObject
        dic["nvLastName"] = nvLastName as AnyObject
        dic["dBirthdate"] = Global.sharedInstance.convertNSDateToString(dBirthdate) as AnyObject
        dic["nvMail"] = nvMail as AnyObject
       // dic["nvAdress"] = nvAdress
        dic["iCityType"] = iCityType as AnyObject
        dic["nvPhone"] = nvPhone as AnyObject
        dic["nvPassword"] = nvPassword as AnyObject
        dic["nvVerification"] = nvVerification as AnyObject
        dic["bAutomaticUpdateApproval"] = bAutomaticUpdateApproval as AnyObject
        dic["bDataDownloadApproval"] = bDataDownloadApproval as AnyObject
        dic["bTermOfUseApproval"] = bTermOfUseApproval as AnyObject
        dic["bAdvertisingApproval"] = bAdvertisingApproval as AnyObject
        dic["iUserStatusType"] = iUserStatusType as AnyObject
        dic["bIsGoogleCalendarSync"] = bIsGoogleCalendarSync as AnyObject
        dic["iCreatedByUserId"] = iCreatedByUserId as AnyObject
        dic["iLastModifyUserId"] = iLastModifyUserId as AnyObject
        dic["iSysRowStatus"] = iSysRowStatus as AnyObject
        dic["bIsManager"] = bIsManager as AnyObject
        dic["iUserId"] = iUserId as AnyObject
        dic["allPHONES"] = allPHONES as AnyObject
        dic["nvNickName"] = nvNickName as AnyObject
     //   dic["nvSupplierNotes"] =  nvSupplierNotes
        
        return dic
    }
    
    //convert dictionary to objUsers object
    //get:dictionary, return objUsers object
    func dicToObjUsers(_ dic:Dictionary<String,AnyObject>) -> objUsers {
        
        let user:objUsers = objUsers()
        
        user.nvUserName = Global.sharedInstance.parseJsonToString(dic["nvUserName"]!)
        user.nvFirstName = Global.sharedInstance.parseJsonToString(dic["nvFirstName"]!)
        user.nvLastName = Global.sharedInstance.parseJsonToString(dic["nvLastName"]!)
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.dateStyle = DateFormatter.Style.long
        if Global.sharedInstance.parseJsonToString(dic["dBirthdate"]!) != ""
        {
            user.dBirthdate = Global.sharedInstance.getStringFromDateString(dic["dBirthdate"]! as! String)
        }
        user.nvMail = Global.sharedInstance.parseJsonToString(dic["nvMail"]!)
//        if dic["nvAdress"] != nil
//        {
//            user.nvAdress = Global.sharedInstance.parseJsonToString(dic["nvAdress"]!)
//        }
        user.iCityType = Global.sharedInstance.parseJsonToInt(dic["iCityType"]!)
        user.nvPhone = Global.sharedInstance.parseJsonToString(dic["nvPhone"]!)
        user.nvPassword = Global.sharedInstance.parseJsonToString(dic["nvPassword"]!)
        user.nvVerification = Global.sharedInstance.parseJsonToString(dic["nvVerification"]!)
        user.bAutomaticUpdateApproval = dic["bAutomaticUpdateApproval"] as! Bool
        user.bDataDownloadApproval = dic["bDataDownloadApproval"] as! Bool
        user.bTermOfUseApproval = dic["bTermOfUseApproval"] as! Bool
        user.bAdvertisingApproval = dic["bAdvertisingApproval"] as! Bool
        user.iUserStatusType = Global.sharedInstance.parseJsonToInt(dic["iUserStatusType"]!)
        if dic["bIsGoogleCalendarSync"] != nil
        {
            user.bIsGoogleCalendarSync = dic["bIsGoogleCalendarSync"] as! Bool
        }
        else
        {
            user.bIsGoogleCalendarSync = false
        }
        user.iCreatedByUserId = Global.sharedInstance.parseJsonToInt(dic["iCreatedByUserId"]!)
        user.iLastModifyUserId = Global.sharedInstance.parseJsonToInt(dic["iLastModifyUserId"]!)
        user.iSysRowStatus = Global.sharedInstance.parseJsonToInt(dic["iSysRowStatus"]!)
        user.bIsManager = Global.sharedInstance.parseJsonToInt(dic["bIsManager"]!)
        user.iUserId = Global.sharedInstance.parseJsonToInt(dic["iUserId"]!)
        user.allPHONES = []
        user.nvNickName =  Global.sharedInstance.parseJsonToString(dic["nvNickName"]!)
      //  user.nvSupplierNotes = Global.sharedInstance.parseJsonToString(dic["nvSupplierNotes"]!)
        return user
    }
}
