//
//  BlockHouresObj.swift
//  BThere
//
//  Created by Ioan Ungureanu on 14/05/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit

class BlockHouresObj: NSObject {
    var iProviderUserId:Int = 0
    var cDate:String = "'"
    var iServiceProviderCalendarId:Int = 0
    var tFromHoure:String = ""
    var tToHoure:String = ""
    override init() {
        iProviderUserId = 0
        iServiceProviderCalendarId = 0
        tFromHoure = ""
        tToHoure = ""
        cDate = ""
    }
    
    init(_iProviderUserId:Int,_iServiceProviderCalendarId:Int,_tFromHoure:String,_tToHoure:String, _cDate:String) {
        iProviderUserId = _iProviderUserId
        iServiceProviderCalendarId = _iServiceProviderCalendarId
        tFromHoure = _tFromHoure
        tToHoure = _tToHoure
        cDate = _cDate
    }
    

    
    func dicToBlockHouresObj(_ dic:Dictionary<String,AnyObject>)->BlockHouresObj
    {
        let blockHouresObj:BlockHouresObj = BlockHouresObj()
        blockHouresObj.iProviderUserId = dic["iProviderUserId"]! as AnyObject as! Int
        blockHouresObj.iServiceProviderCalendarId = dic["iServiceProviderCalendarId"]! as AnyObject as! Int
        blockHouresObj.tFromHoure = dic["tFromHoure"]! as AnyObject as! String
        blockHouresObj.tToHoure = dic["tToHoure"]! as AnyObject as! String
        blockHouresObj.cDate = dic["dDate"]! as AnyObject as! String
        return blockHouresObj
    }
    
    func dicToBlockHouresToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<BlockHouresObj>{
        var arrBlockHoures:Array<BlockHouresObj> = Array<BlockHouresObj>()
        var blockHoureObj:BlockHouresObj = BlockHouresObj()
        for i in 0  ..< arrDic.count
        {
            blockHoureObj = dicToBlockHouresObj(arrDic[i])
            arrBlockHoures.append(blockHoureObj)
        }
        return arrBlockHoures
    }
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iProviderUserId"] = iProviderUserId as AnyObject
        dic["iServiceProviderCalendarId"] = iServiceProviderCalendarId as AnyObject
        dic["tFromHoure"] = tFromHoure as AnyObject
        dic["tToHoure"] = tToHoure as AnyObject
        dic["cDate"] = cDate as AnyObject
        return dic
    }

}
