//
//  User.swift
//  bthree-ios
//
//  Created by Lior Ronen on 2/10/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var iUserId:Int = 0
    var nvUserName:String = ""
    var nvFirstName:String = ""
    var nvLastName:String = ""
    var dBirthdate:Date = Date()//* = added later
    var nvMail:String = ""
    var iCityType:Int = 0
    var nvPhone:String = ""
    var nvPassword:String = ""
    var nvVerification:String = ""
    var bAutomaticUpdateApproval:Bool = false
    var bDataDownloadApproval:Bool = false
    var bTermOfUseApproval:Bool = false
    var bAdvertisingApproval:Bool = false//* = added later
    var iUserStatusType:Int = 0
    var bIsGoogleCalendarSync:Bool = true//* = added later
    var nvImage:String = ""
    var iCreatedByUserId:Int = 0
    var iLastModifyUserId:Int = 0
    var iSysRowStatus:Int = 0
    var dMarriageDate:Date = Date()//תאריך נישואין לצורך עדכון בלבד
    var iCalendarViewType:Int = Int() //לצורך עדכון בלבד תצוגת יומן
    var bIsManager:Int = 0
    var nvDeviceToken:String = ""
    var iStatus:Int = 0
    var nvNickName:String = ""
    var iProviderUserId:Int = 0 //need in object for UpdateSupplierEmployee
    var iCustomerUserId:Int = 0 //need in object for AddSupplierEmployee
    override init() {
        iUserId = 0
        nvUserName = ""
        nvFirstName = ""
        nvLastName = ""
        dBirthdate = Date()
        nvMail = ""
        iCityType = 1
        nvPhone = ""
        nvPassword = "1234"
        nvVerification = "1234"
        bAutomaticUpdateApproval = false
        bDataDownloadApproval = true
        bTermOfUseApproval = false
        bAdvertisingApproval = false
        iUserStatusType = 0
        bIsGoogleCalendarSync = true
        nvImage = ""
        iCreatedByUserId = 0
        iLastModifyUserId = 0
        iSysRowStatus = 0
        bIsManager = 0
        nvDeviceToken = ""
        iStatus = 0
        nvNickName = ""
        iProviderUserId = 0
        iCustomerUserId = 0
       
    }
    
    init(_iUserId:Int,_nvUserName:String,_nvFirstName:String,_nvLastName:String,/*_nvSupplierNotes:String,*/_dBirthdate:Date,_nvMail:String,/*_nvAdress:String,*/_iCityType:Int,_nvPhone:String,_nvPassword:String,_nvVerification:String,_bAutomaticUpdateApproval:Bool,_bDataDownloadApproval:Bool,_bAdvertisingApproval:Bool,_bTermOfUseApproval:Bool,_iUserStatusType:Int,
        //_iUserType:Int
        _bIsGoogleCalendarSync:Bool,_nvImage:String,_iCreatedByUserId:Int,_iLastModifyUserId:Int,_iSysRowStatus:Int,_bIsManager:Int,_nvDeviceToken:String, _iStatus:Int, _nvNickName:String) {
        
        iUserId = _iUserId
        nvUserName = _nvUserName
        nvFirstName = _nvFirstName
        nvLastName = _nvLastName
       // nvSupplierNotes = _nvSupplierNotes
        dBirthdate = _dBirthdate //*
        nvMail = _nvMail
      //  nvAdress = _nvAdress
        iCityType = _iCityType
        nvPhone = _nvPhone
        nvPassword = _nvPassword
        nvVerification = _nvVerification
        bAutomaticUpdateApproval = _bAutomaticUpdateApproval
        bDataDownloadApproval = _bDataDownloadApproval
        bTermOfUseApproval = _bTermOfUseApproval
        bAdvertisingApproval = _bAdvertisingApproval //*
        iUserStatusType = _iUserStatusType
        //iUserType = _iUserType
        bIsGoogleCalendarSync = _bIsGoogleCalendarSync //*
        nvImage = _nvImage
        iCreatedByUserId = _iCreatedByUserId
        iLastModifyUserId = _iLastModifyUserId
        iSysRowStatus = _iSysRowStatus
        bIsManager = _bIsManager
        nvDeviceToken = _nvDeviceToken
        iStatus = _iStatus
        nvNickName = _nvNickName
        iProviderUserId = iUserId
        iCustomerUserId = iUserId
    }

    
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iUserId"] = iUserId as AnyObject
        dic["nvUserName"] = nvUserName as AnyObject
        dic["nvFirstName"] = nvFirstName as AnyObject
        dic["nvLastName"] = nvLastName as AnyObject
       // dic["nvSupplierNotes"] = nvSupplierNotes
        let calendar:Foundation.Calendar = Foundation.Calendar.current
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        
        let componentsBDay = (calendar as NSCalendar).components([.day, .month, .year], from: dBirthdate)
        
        if componentsCurrent.year != componentsBDay.year || componentsCurrent.month != componentsBDay.month || componentsCurrent.day != componentsBDay.day
        {
            dic["dBirthdate"] = Global.sharedInstance.convertNSDateToString(dBirthdate) as AnyObject //*
        }
        else
        {
            dic["dBirthdate"] = nil
        }
//        componentsBDay = calendar.components([.Day, .Month, .Year], fromDate: dMarried)
//        if componentsCurrent.year != componentsBDay.year || componentsCurrent.month != componentsBDay.month || componentsCurrent.day != componentsBDay.day
//        {
//            dic["dMarried"] = Global.sharedInstance.convertNSDateToString(dMarried) //*
//        }
//        else
//        {
             dic["dMarriageDate"] = nil
//        }
        
        dic["nvMail"] = nvMail as AnyObject
     //   dic["nvAdress"] = nvAdress
        dic["iCityType"] = iCityType as AnyObject
        dic["nvPhone"] = nvPhone as AnyObject
        dic["nvPassword"] = nvPassword as AnyObject
        dic["nvVerification"] = nvVerification as AnyObject
        dic["bAutomaticUpdateApproval"] = bAutomaticUpdateApproval as AnyObject
        dic["bDataDownloadApproval"] = bDataDownloadApproval as AnyObject
        dic["bTermOfUseApproval"] = bTermOfUseApproval as AnyObject
        dic["bAdvertisingApproval"] = bAdvertisingApproval as AnyObject //*
        dic["iUserStatusType"] = iUserStatusType as AnyObject
        //dic["iUserType"] = iUserType
        dic["bIsGoogleCalendarSync"] = bIsGoogleCalendarSync as AnyObject //*
        dic["nvImage"] = nvImage as AnyObject
        dic["iCreatedByUserId"] = iCreatedByUserId as AnyObject
        dic["iLastModifyUserId"] = iLastModifyUserId as AnyObject
        dic["iSysRowStatus"] = iSysRowStatus as AnyObject
        dic["bIsManager"] = bIsManager as AnyObject
        dic["nvDeviceToken"] = nvDeviceToken as AnyObject
        dic["iStatus"] = iStatus as AnyObject
        dic["nvNickName"] = nvNickName as AnyObject
        dic["iProviderUserId"] = iUserId as AnyObject
        dic["iCustomerUserId"] = iUserId as AnyObject
        return dic
    }
    
    func dicToUser(_ dic:Dictionary<String,AnyObject>)->User
    {
        let user:User = User()
        if let _:Int = dic["iUserId"] as? Int {
        user.iUserId = Global.sharedInstance.parseJsonToInt(dic["iUserId"]!)
            user.iProviderUserId =  user.iUserId
            user.iCustomerUserId = user.iUserId
        }
        if let _:String = dic["nvUserName"] as? String {
            user.nvUserName = Global.sharedInstance.parseJsonToString(dic["nvUserName"]!)
        }
        if let _:String = dic["nvFirstName"] as? String {
            user.nvFirstName = Global.sharedInstance.parseJsonToString(dic["nvFirstName"]!)
        }
        if let _:String = dic["nvLastName"] as? String {
            user.nvLastName = Global.sharedInstance.parseJsonToString(dic["nvLastName"]!)
        }
        if let _:String = dic["dBirthdate"] as? String {
           user.dBirthdate = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.parseJsonToString(dic["dBirthdate"]!))
        }
        if let _:String = dic["dMarriageDate"] as? String {
             user.dMarriageDate = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.parseJsonToString(dic["dMarriageDate"]!))
        }
        //  user.nvSupplierNotes = Global.sharedInstance.parseJsonToString(dic["nvSupplierNotes"]!)
        if let _:String = dic["nvMail"] as? String {
          user.nvMail = Global.sharedInstance.parseJsonToString(dic["nvMail"]!)
        }
        if let _:Int = dic["iCityType"] as? Int {
        user.iCityType = Global.sharedInstance.parseJsonToInt(dic["iCityType"]!)
        }
        
    //        user.nvAdress = Global.sharedInstance.parseJsonToString(dic["nvAdress"]!)
        if let _:String = dic["nvPhone"] as? String {
             user.nvPhone = Global.sharedInstance.parseJsonToString(dic["nvPhone"]!)
        }
        if let _:String = dic["nvPassword"] as? String {
            user.nvPassword = Global.sharedInstance.parseJsonToString(dic["nvPassword"]!)
        }
        if let _:String = dic["nvVerification"] as? String {
            user.nvVerification = Global.sharedInstance.parseJsonToString(dic["nvVerification"]!)
        }
        if let _:Bool = dic["bAutomaticUpdateApproval"] as? Bool {
           user.bAutomaticUpdateApproval = dic["bAutomaticUpdateApproval"] as! Bool
        }
        if let _:Bool = dic["bDataDownloadApproval"] as? Bool {
           user.bDataDownloadApproval = dic["bDataDownloadApproval"] as! Bool
        }
        if let _:Bool = dic["bTermOfUseApproval"] as? Bool {
            user.bTermOfUseApproval = dic["bTermOfUseApproval"] as! Bool
        }
        if let _:Bool = dic["bAdvertisingApproval"] as? Bool {
            user.bAdvertisingApproval = dic["bAdvertisingApproval"] as! Bool
        }
        if let _:Int = dic["iCityType"] as? Int {
           user.iUserStatusType = Global.sharedInstance.parseJsonToInt(dic["iUserStatusType"]!)
        }
        if let _:Bool = dic["bIsGoogleCalendarSync"] as? Bool {
           user.bIsGoogleCalendarSync = dic["bIsGoogleCalendarSync"] as! Bool
        }
        if let _:String = dic["nvImage"] as? String {
               user.nvImage = Global.sharedInstance.parseJsonToString(dic["nvImage"]!)
        }
        if let _:Int = dic["iCreatedByUserId"] as? Int {
            user.iCreatedByUserId = Global.sharedInstance.parseJsonToInt(dic["iCreatedByUserId"]!)
        }
       //*
      
        //dic["iUserType"] = iUserType
        //*
        if let _:Int = dic["iLastModifyUserId"] as? Int {
            user.iLastModifyUserId = Global.sharedInstance.parseJsonToInt(dic["iLastModifyUserId"]!)
        }
        if let _:Int = dic["iSysRowStatus"] as? Int {
            user.iSysRowStatus = Global.sharedInstance.parseJsonToInt(dic["iSysRowStatus"]!)
        }
        if let _:Int = dic["iCalendarViewType"] as? Int {
            user.iCalendarViewType = Global.sharedInstance.parseJsonToInt(dic["iCalendarViewType"]!)
        }
        if let _:Int = dic["bIsManager"] as? Int {
            user.bIsManager = Global.sharedInstance.parseJsonToInt(dic["bIsManager"]!)
        } else  if let _:Bool = dic["bIsManager"] as? Bool {
             user.bIsManager = Global.sharedInstance.parseJsonToBool(dic["bIsManager"]! as! Bool)
        }
        if let _:String = dic["nvDeviceToken"] as? String {
            user.nvDeviceToken = Global.sharedInstance.parseJsonToString(dic["nvDeviceToken"]!)
        }
        if let _:Int = dic["iStatus"] as? Int {
            user.iStatus = Global.sharedInstance.parseJsonToInt(dic["iStatus"]!)
        } else {
            user.iStatus = 1
        }
        if let _:String = dic["nvNickName"] as? String {
            user.nvNickName = Global.sharedInstance.parseJsonToString(dic["nvNickName"]!)
        }
        return user
    }
    func usersToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<User>{
        
        var arrDomain:Array<User> = Array<User>()
        var objUser:User = User()
        
        for i in 0  ..< arrDic.count 
        {
            objUser = dicToUser(arrDic[i])
            arrDomain.append(objUser)
        }
        return arrDomain
    }
    func getDicToEdit()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iUserId"] = iUserId as AnyObject
        
        dic["nvUserName"] = nvUserName as AnyObject
        dic["nvFirstName"] = nvFirstName as AnyObject
        dic["nvLastName"] = nvLastName as AnyObject
   ///     dic["nvSupplierNotes"] = nvSupplierNotes
//        let calendar:NSCalendar = NSCalendar.currentCalendar()
//        let componentsCurrent = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
//        
//        let componentsBDay = calendar.components([.Day, .Month, .Year], fromDate: dBirthdate)
//        
//        if componentsCurrent.year != componentsBDay.year || componentsCurrent.month != componentsBDay.month || componentsCurrent.day != componentsBDay.day
//        {
//            dic["dBirthdate"] = Global.sharedInstance.convertNSDateToString(dBirthdate) //*
//        }
//        else
//        {
//            dic["dBirthdate"] = nil
//        }
//        let componentsMDay = calendar.components([.Day, .Month, .Year], fromDate: dMarried)
//        if componentsCurrent.year != componentsMDay.year || componentsCurrent.month != componentsMDay.month || componentsCurrent.day != componentsMDay.day
//        {
//            dic["dMarriageDate"] = Global.sharedInstance.convertNSDateToString(dMarried) //*
//        }
//        else
//        {
//            dic["dMarriageDate"] = nil
//        }
        dic["nvMail"] = nvMail as AnyObject
     //   dic["nvAdress"] = nvAdress
        dic["iCityType"] = iCityType as AnyObject
        dic["nvPhone"] = nvPhone as AnyObject
        dic["nvPassword"] = nvPassword as AnyObject
        dic["nvVerification"] = nvVerification as AnyObject
        dic["bAutomaticUpdateApproval"] = true as AnyObject
        dic["bDataDownloadApproval"] = true as AnyObject// bDataDownloadApproval
        dic["bTermOfUseApproval"] = bTermOfUseApproval as AnyObject
        dic["bAdvertisingApproval"] = true as AnyObject//bAdvertisingApproval //*
        dic["iUserStatusType"] = iUserStatusType as AnyObject
        //dic["iUserType"] = iUserType
        dic["bIsGoogleCalendarSync"] = bIsGoogleCalendarSync as AnyObject //*
        dic["nvImage"] = nvImage as AnyObject
        dic["iCreatedByUserId"] = iCreatedByUserId as AnyObject
        dic["iLastModifyUserId"] = iLastModifyUserId as AnyObject
        dic["iSysRowStatus"] = iSysRowStatus as AnyObject
        dic["dBirthdate"] = Global.sharedInstance.convertNSDateToString(dBirthdate) as AnyObject //*
        dic["dMarriageDate"] = Global.sharedInstance.convertNSDateToString(dMarriageDate) as AnyObject
        dic["iCalendarViewType"] = iCalendarViewType as AnyObject// change
        dic["bIsManager"] = bIsManager as AnyObject
        dic["nvDeviceToken"] = nvDeviceToken as AnyObject
        dic["iStatus"] = iStatus as AnyObject
        dic["nvNickName"] = nvNickName as AnyObject
        dic["iProviderUserId"] = iUserId as AnyObject
        dic["iCustomerUserId"] = iUserId as AnyObject
        return dic
    }

}
