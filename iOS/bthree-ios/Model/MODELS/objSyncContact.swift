//
//  objSyncContact.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 24/05/2017
//  Copyright © 2017 Bthere. All rights reserved.
//

import UIKit
//caontain user details as customer
class objSyncContact: NSObject {

    //MARK: - Variables
    var nvFirstName:String = ""
    var bAutomaticUpdateApproval:Bool = false
    var iLastModifyUserId:Int = 0
    var nvPassword:String = ""
    var nvUserName:String = ""
    var iCityType:Int = 0
    var nvVerification:String = ""
    var bAdvertisingApproval:Bool = false
    var iCreatedByUserId:Int = 0
    var bIsManager:Int = 0
    var dBirthdate:Date = Date()
    var nvMail:String = ""
    var iUserStatusType:Int = 0
    var bIsGoogleCalendarSync:Bool = false
    var bDataDownloadApproval:Bool = false
    var nvLastName:String = ""
    var nvPhone:String = ""
    var iSysRowStatus:Int = 0
    var bTermOfUseApproval:Bool = false
    var iUserId:Int = 0
    var allPHONES: Array<String> = Array<String>()
    var nvNickName:String = ""
  
    //MARK: - Initial
    
    override init() {
       nvFirstName = ""
         bAutomaticUpdateApproval = false
         iLastModifyUserId = 0
         nvPassword = ""
         nvUserName = ""
         iCityType = 0
         nvVerification = ""
         bAdvertisingApproval = false
         iCreatedByUserId = 0
         bIsManager = 0
        dBirthdate = Date()
         nvMail = ""
         iUserStatusType = 0
         bIsGoogleCalendarSync = false
         bDataDownloadApproval = false
         nvLastName = ""
         nvPhone = ""
         iSysRowStatus = 1
         bTermOfUseApproval = false
         iUserId = 0
         allPHONES = []
         nvNickName = ""
      

    }
    init( _nvFirstName:String, _bAutomaticUpdateApproval:Bool, _iLastModifyUserId:Int, _nvPassword:String, _nvUserName:String,
          _iCityType:Int, _nvVerification:String,_bAdvertisingApproval:Bool,_iCreatedByUserId:Int,_bIsManager:Int, _dBirthdate:Date,
          _nvMail:String,_iUserStatusType:Int,_bIsGoogleCalendarSync:Bool,_bDataDownloadApproval:Bool,_nvLastName:String,_nvPhone:String,
          _iSysRowStatus:Int,_bTermOfUseApproval:Bool,_iUserId:Int, _allPHONES:Array<String>,_nvNickName:String )
       {
        nvFirstName = _nvFirstName
        bAutomaticUpdateApproval = _bAutomaticUpdateApproval
        iLastModifyUserId = _iLastModifyUserId
        nvPassword = _nvPassword
        nvUserName = _nvUserName
        iCityType = _iCityType
        nvVerification = _nvVerification
        bAdvertisingApproval = _bAdvertisingApproval
        iCreatedByUserId = _iCreatedByUserId
        bIsManager = _bIsManager
        dBirthdate = _dBirthdate
        nvMail = _nvMail
        iUserStatusType = _iUserStatusType
        bIsGoogleCalendarSync = _bIsGoogleCalendarSync
        bDataDownloadApproval = _bDataDownloadApproval
        nvLastName = _nvLastName
        nvPhone = _nvPhone
        iSysRowStatus = _iSysRowStatus
        bTermOfUseApproval = _bTermOfUseApproval
        iUserId = _iUserId
        allPHONES = _allPHONES
        nvNickName = _nvNickName
      
    }
    
    //MARK: - Functions

    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        dic["nvFirstName"] = nvFirstName as AnyObject
        dic["bAutomaticUpdateApproval"] = bAutomaticUpdateApproval as AnyObject
        dic["iLastModifyUserId"] = iLastModifyUserId as AnyObject
        dic["nvPassword"] = nvPassword as AnyObject
        dic["nvUserName"] = nvUserName as AnyObject
        dic["iCityType"] = iCityType as AnyObject
        dic["nvVerification"] = nvVerification as AnyObject
        dic["bAdvertisingApproval"] = bAdvertisingApproval as AnyObject
        dic["iCreatedByUserId"] = iCreatedByUserId as AnyObject
        dic["bIsManager"] = bIsManager as AnyObject
        dic["dBirthdate"] = Global.sharedInstance.convertNSDateToString(dBirthdate) as AnyObject
        dic["nvMail"] = nvMail as AnyObject
        dic["iUserStatusType"] = iUserStatusType as AnyObject
        dic["bIsGoogleCalendarSync"] = bIsGoogleCalendarSync as AnyObject
        dic["bDataDownloadApproval"] = bDataDownloadApproval as AnyObject
        dic["nvLastName"] = nvLastName as AnyObject
        dic["nvPhone"] = nvPhone as AnyObject
        dic["iSysRowStatus"] = iSysRowStatus as AnyObject
        dic["bTermOfUseApproval"] = bTermOfUseApproval as AnyObject
        dic["iUserId"] = iUserId as AnyObject
        dic["allPHONES"] = allPHONES as AnyObject
        dic["nvNickName"] = nvNickName as AnyObject
        
        return dic
    }
    
    }
