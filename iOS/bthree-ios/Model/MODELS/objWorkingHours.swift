//
//  objWorkingHours.swift
//  bthree-ios
//
//  Created by User on 30.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class objWorkingHours: NSObject {
    
    var iDayInWeekType:Int = 0
    var nvFromHour:String = ""
    var nvToHour:String = ""
    
    override init() {
        iDayInWeekType = 0
        nvFromHour = ""
        nvToHour = ""
    }
    
    init(_iDayInWeekType:Int,_nvFromHour:String,_nvToHour:String) {
        iDayInWeekType = _iDayInWeekType
        nvFromHour = _nvFromHour
        nvToHour = _nvToHour
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iDayInWeekType"] = iDayInWeekType as AnyObject
        dic["nvFromHour"] = nvFromHour as AnyObject
        dic["nvToHour"] = nvToHour as AnyObject
        
        return dic
    }
    
    func objWorkingHoursToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<objWorkingHours>{
        
        var arrWorkingHours:Array<objWorkingHours> = Array<objWorkingHours>()
        var workingHours:objWorkingHours = objWorkingHours()
        
        for i in 0  ..< arrDic.count 
        {
            workingHours = dicToWorkingHours(arrDic[i])
            arrWorkingHours.append(workingHours)
        }
        return arrWorkingHours
    }
    
    func dicToWorkingHours(_ dic:Dictionary<String,AnyObject>)->objWorkingHours
    {
        let workingHours:objWorkingHours = objWorkingHours()
        
        workingHours.iDayInWeekType = dic["iDayInWeekType"] as! Int
        workingHours.nvFromHour = dic["nvFromHour"] as! String
        workingHours.nvToHour = dic["nvToHour"] as! String
        
        return workingHours
    }
    
    func sortHoursArrayByDays(_ arrHours:Array<objWorkingHours>) -> Array<Array<objWorkingHours>>
    {
        var arrSortHours:Array<Array<objWorkingHours>> = Array<Array<objWorkingHours>>()
        
        arrSortHours = [Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>()]
        
        for item in arrHours {
            arrSortHours[item.iDayInWeekType - 1].append(item)
        }
        
        return arrSortHours
    }
    


}
