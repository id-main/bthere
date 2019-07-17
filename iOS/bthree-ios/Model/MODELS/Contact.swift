//
//  Contact.swift
//  bthree-ios
//
//  Created by User on 11.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

@objc class Contact: NSObject {

    @objc var iUserId : Int
    @objc var iUserStatusType : Int
    @objc var nvContactName : String = ""
    @objc var nvPhone : String = ""
    @objc var bIsNegotiableOnly : Bool
    @objc var bPostdatedCheck  = false
    @objc var bIsVCheckMember = false
    @objc var bIsSync = true
    //JMODE + IMPORTANT !!!
    @objc  var nvFirstName : String = ""
    @objc var nvLastName : String = ""
    @objc  var allPHONES : Array<String> = Array<String>()
    @objc  var nvNickName:String
    override init() {
        
        iUserId = 0
        iUserStatusType = 0
        nvContactName = ""
        nvPhone = ""
        bIsNegotiableOnly = false
        bPostdatedCheck  = false
        bIsVCheckMember = false
        bIsSync = true
        //JMODE + IMPORTANT !!!
        nvFirstName  = ""
        nvLastName = ""
        allPHONES = []
        nvNickName = ""
    }
    @objc init(_iUserId : Int, _iUserStatusType : Int, _nvContactName : String, _nvPhone : String, _bIsVCheckMamber : Bool, _bIsNegotiableOnly : Bool, _bPostdatedCheck : Bool,_bIsSync:Bool, _nvFirstName : String, _nvLastName : String, _allPHONES:Array<String>,_nvNickName:String)
    {
        iUserId = _iUserId
        iUserStatusType = _iUserStatusType
        nvContactName = _nvContactName
        nvPhone = _nvPhone
        bIsVCheckMember = _bIsVCheckMamber
        bIsNegotiableOnly = _bIsNegotiableOnly
        bPostdatedCheck = _bPostdatedCheck
        bIsSync = _bIsSync
        //JMODE + IMPORTANT !!!
        nvFirstName  = _nvFirstName
        nvLastName = _nvLastName
        allPHONES = _allPHONES
        nvNickName = _nvNickName
    }
    
    @objc init(contactDic : Dictionary<String, AnyObject>) {
        iUserId = contactDic["iUserId"] as! Int
        iUserStatusType = contactDic["iUserStatusType"] as! Int
        nvContactName = contactDic["nvContactName"] as! String
        nvPhone = contactDic["nvPhone"] as! String
        bIsVCheckMember = contactDic["bIsVCheckMember"] as! Bool
        bIsNegotiableOnly = contactDic["bIsNegotiableOnly"] as! Bool
        bPostdatedCheck = contactDic["bPostdatedCheck"] as! Bool
        bIsSync = contactDic["bIsSync"] as! Bool
        //JMODE + IMPORTANT !!!
        nvFirstName = contactDic["nvFirstName"] as! String
        nvLastName = contactDic["nvLastName"] as! String
        allPHONES =  contactDic["allPHONES"] as! Array<String>
        nvNickName = contactDic["nvNickName"] as! String
    }
    
    @objc   func getContactDic() -> Dictionary<String, AnyObject> {
        var dic = Dictionary<String, AnyObject>()
        
        dic["iUserId"] = self.iUserId as AnyObject
        dic["iUserStatusType"] = self.iUserStatusType as AnyObject
        dic["nvContactName"] = self.nvContactName as AnyObject
        dic["nvPhone"] = self.nvPhone as AnyObject
        dic["bIsVCheckMember"] = self.bIsVCheckMember as AnyObject
        dic["bIsNegotiableOnly"] = self.bIsNegotiableOnly as AnyObject
        dic["bPostdatedCheck"] = self.bPostdatedCheck as AnyObject
        dic["bIsSync"] = self.bIsSync as AnyObject
        //JMODE + IMPORTANT !!!
        dic["nvFirstName"] = self.nvFirstName as AnyObject
        dic["nvLastName"] = self.nvLastName as AnyObject
        dic["allPHONES"] = self.allPHONES as AnyObject
        dic["nvNickName"] = self.nvNickName as AnyObject
        return dic
    }
    //    func getContactFromJson(dicArray:NSDictionary)-> Contact
    //    {
    //        let contact:Contact = Contact()
    //        contact.nvPhone = Global.sharedInstance.parseJsonToString(dicArray["nvPhone"]!)
    //        contact.nvContactName = Global.sharedInstance.parseJsonToString(dicArray["nvContactName"]!)
    //        contact.iUserId = Global.sharedInstance.parseJsonToInt(dicArray["iUserId"]!)
    //        contact.iUserStatusType = Global.sharedInstance.parseJsonToInt(dicArray["iUserStatusType"]!)
    //        contact.bIsVCheckMember = dicArray["bIsVCheckMember"] as! Bool
    //        contact.bIsNegotiableOnly = dicArray["bIsNegotiableOnly"] as! Bool
    //        contact.bPostdatedCheck = dicArray["bPostdatedCheck"] as! Bool
    //        return contact
    //    }
    
}
