//
//  ProviderHourObj.swift
//  Bthere
//
//  Created by User on 10.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class ProviderHourObj: NSObject {
//    string nvFromHour
//    string nvToHour
    var nvFromHour:String = ""
    var nvToHour:String = ""
    
    
    override init() {
       
        nvFromHour = ""
        nvToHour = ""
      
        
    }
    
    init(_nvFromHour:String,_nvToHour:String) {
      nvFromHour = _nvFromHour
    nvToHour = _nvToHour
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
      
        dic["nvFromHour"] = nvFromHour as AnyObject
        dic["nvToHour"] = nvToHour as AnyObject
        return dic
    }
    
    func dicProviderHour(_ dic:Dictionary<String,AnyObject>)->ProviderHourObj
    {
        let ProviderHour:ProviderHourObj = ProviderHourObj()
        //
        ProviderHour.nvToHour = Global.sharedInstance.parseJsonToString(dic["nvToHour"]!)
        ProviderHour.nvFromHour = Global.sharedInstance.parseJsonToString(dic["nvFromHour"]!)
        
        
        return ProviderHour
    }
}
