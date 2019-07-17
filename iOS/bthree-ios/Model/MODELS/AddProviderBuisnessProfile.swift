//
//  AddProviderBusinessProfile.swift
//  bthree-ios
//
//  Created by User on 11.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class AddProviderBusinessProfile: NSObject {
    
    var iProviderUserId:Int = 0
    var nvILogoImage:String = ""
    var nvHeaderImage:String = ""
    var nvFooterImage:String = ""
    var nvAboutComment:String = ""
    var nvCampaignImage:String = ""
    var nvSlogen:String = ""
    var nvLat:String = ""
    var nvLong:String = ""
    var nvCity:String = ""
    var nvSiteAddress:String = ""
    var nvPhone:String = ""
    var dRankAvg:Float = 0
    var iRankCount:Int = 0
    var nvFacebookLink:String = ""
    var nvInstagramLink:String = ""
    var ProviderWorkingHoursObj:Array<objWorkingHours> = Array<objWorkingHours>()
    
    
    override init() {
        iProviderUserId = 0
        nvILogoImage = ""
        nvHeaderImage = ""
        nvFooterImage = ""
        nvAboutComment = ""
        nvCampaignImage = ""
        nvSlogen = ""
        nvLat = ""
        nvLong = ""
        nvCity = ""
        nvSiteAddress = ""
        nvPhone = ""
        ProviderWorkingHoursObj = Array<objWorkingHours>()
        dRankAvg = 0
        iRankCount = 0
        nvFacebookLink = ""
        nvInstagramLink = ""
    }
    
    init(_iProviderUserId:Int,_nvILogoImage:String,_nvHeaderImage:String,_nvFooterImage:String,_nvAboutComment:String,_nvCampaignImage:String,_nvSlogen:String,_nvLat:String,_nvLong:String,_ProviderWorkingHoursObj:Array<objWorkingHours>,_nvCity:String,_nvSiteAddress:String,_nvPhone:String,_dRankAvg:Float,_iRankCount:Int, _nvFacebookLink:String, _nvInstagramLink:String ) {
        
        iProviderUserId = _iProviderUserId
        nvILogoImage = _nvILogoImage
        nvHeaderImage = _nvHeaderImage
        nvFooterImage = _nvFooterImage
        nvAboutComment = _nvAboutComment
        nvCampaignImage = _nvCampaignImage
        nvSlogen = _nvSlogen
        nvLat = _nvLat
        nvLong = _nvLong
        nvCity = _nvCity
        nvSiteAddress = _nvSiteAddress
        nvPhone = _nvPhone
        ProviderWorkingHoursObj = _ProviderWorkingHoursObj
        dRankAvg = _dRankAvg
        iRankCount = _iRankCount
        nvFacebookLink = _nvFacebookLink
        nvInstagramLink = _nvInstagramLink
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var iProviderUserId:Int = 0
        if Global.sharedInstance.providerID == 0 {
            iProviderUserId  = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                iProviderUserId =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            iProviderUserId = Global.sharedInstance.providerID
        }
        
        //\\   dic["iProviderUserId"] = Global.sharedInstance.currentProvider.iIdBuisnessDetails
        dic["iProviderUserId"] = iProviderUserId as AnyObject
        //Global.sharedInstance.currentProvider.iUserId
        dic["nvILogoImage"] = nvILogoImage as AnyObject
        dic["nvHeaderImage"] = nvHeaderImage as AnyObject
        dic["nvFooterImage"] = nvFooterImage as AnyObject
        dic["nvAboutComment"] = nvAboutComment as AnyObject
        dic["nvCampaignImage"] =  nvCampaignImage as AnyObject
        dic["nvSlogen"] = nvSlogen as AnyObject
        dic["nvLat"] = nvLat as AnyObject
        dic["nvLong"] = nvLong as AnyObject
        dic["nvCity"] = nvCity as AnyObject
        dic["nvSiteAddress"] = nvSiteAddress as AnyObject
        dic["nvPhone"] = nvPhone as AnyObject
        dic["ProviderWorkingHoursObj"] = ProviderWorkingHoursObj as AnyObject
        if let _ = dRankAvg as? Float
        {
            dic["dRankAvg"] = dRankAvg as AnyObject
        }
        if let _ = iRankCount as? Int
        {
            dic["iRankCount"] = iRankCount as AnyObject
        }
        dic["nvFacebookLink"] = nvFacebookLink as AnyObject
        dic["nvInstagramLink"] = nvInstagramLink as AnyObject

        
        
        return dic
    }
    
    //2do - delete
    func getDicExample()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iProviderUserId"] = 0 as AnyObject
        dic["nvILogoImage"] = "" as AnyObject
        dic["nvHeaderImage"] = "" as AnyObject
        dic["nvFooterImage"] = "" as AnyObject
        dic["nvAboutComment"] = "dsfsd g t ret er" as AnyObject
        dic["nvCampaignImage"] =  "" as AnyObject
        dic["nvSlogen"] = "fdfd" as AnyObject
        
        return dic
    }
    
    func dicToAddProviderBusinessProfile(_ dic:Dictionary<String,AnyObject>)->AddProviderBusinessProfile
    {
        let addProviderBusinessProfile:AddProviderBusinessProfile = AddProviderBusinessProfile()
        
        addProviderBusinessProfile.iProviderUserId = Global.sharedInstance.parseJsonToInt(dic["iProviderUserId"]!)
        addProviderBusinessProfile.nvILogoImage = Global.sharedInstance.parseJsonToString(dic["nvILogoImage"]!)
        addProviderBusinessProfile.nvHeaderImage = Global.sharedInstance.parseJsonToString(dic["nvHeaderImage"]!)
        addProviderBusinessProfile.nvFooterImage =  Global.sharedInstance.parseJsonToString(dic["nvFooterImage"]!)
        addProviderBusinessProfile.nvAboutComment =  Global.sharedInstance.parseJsonToString(dic["nvAboutComment"]!)
        addProviderBusinessProfile.nvCampaignImage =  Global.sharedInstance.parseJsonToString(dic["nvCampaignImage"]!)
        addProviderBusinessProfile.nvSlogen = Global.sharedInstance.parseJsonToString(dic["nvSlogen"]!)
        addProviderBusinessProfile.nvLat = Global.sharedInstance.parseJsonToString(dic["nvLat"]!)
        addProviderBusinessProfile.nvLong = Global.sharedInstance.parseJsonToString(dic["nvLong"]!)
        if (dic["nvCity"]) != nil {
            addProviderBusinessProfile.nvCity = Global.sharedInstance.parseJsonToString(dic["nvCity"]!)
        } else {
            addProviderBusinessProfile.nvCity = ""
        }
        addProviderBusinessProfile.nvSiteAddress = Global.sharedInstance.parseJsonToString(dic["nvSiteAddress"]!)
        addProviderBusinessProfile.nvPhone = Global.sharedInstance.parseJsonToString(dic["nvPhone"]!)
        
        let workingHours:objWorkingHours = objWorkingHours()
        if dic["objWorkingHours"]?.description != "<null>"
        {
            addProviderBusinessProfile.ProviderWorkingHoursObj = workingHours.objWorkingHoursToArray(dic["objWorkingHours"] as! Array<Dictionary<String,AnyObject>>)
        }
        if dic["dRankAvg"] != nil
        {
            addProviderBusinessProfile.dRankAvg = Global.sharedInstance.parseJsonToFloat(dic["dRankAvg"]!)
        }
        if dic["iRankCount"] != nil
        {
            addProviderBusinessProfile.iRankCount = Global.sharedInstance.parseJsonToInt(dic["iRankCount"]!)
        }
        //hard coded iustin
        if dic["nvFacebookLink"] != nil
        {
           addProviderBusinessProfile.nvFacebookLink = Global.sharedInstance.parseJsonToString(dic["nvFacebookLink"]!)
        }
        else
        {
            addProviderBusinessProfile.nvFacebookLink = ""
        }
        if dic["nvInstagramLink"] != nil
        {
           addProviderBusinessProfile.nvInstagramLink = Global.sharedInstance.parseJsonToString(dic["nvInstagramLink"]!)
        }
        else
        {
            addProviderBusinessProfile.nvInstagramLink = ""
        }
        
        return addProviderBusinessProfile
    }
    
    
}
