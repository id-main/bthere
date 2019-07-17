//
//  SysAlerts.swift
//  bthree-ios
//
//  Created by User on 7.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class SysAlerts: NSObject {
    
    var iTableId:Int = 0
    var nvSysTableNameEng:String = ""
    var iSysTableRowId:Int = 0
    var nvAletName:String = ""
    
    override init() {
        iTableId = 0
        nvSysTableNameEng = ""
        iSysTableRowId = 0
        nvAletName = ""
    }
    
    init(_iTableId:Int,_nvSysTableNameEng:String,_iSysTableRowId:Int,_nvAletName:String) {
        
        iTableId = _iTableId
        nvSysTableNameEng = _nvSysTableNameEng
        iSysTableRowId = _iSysTableRowId
        nvAletName = _nvAletName
    }
    
    func dicToSys(_ dic:Dictionary<String,AnyObject>)->SysAlerts
    {
        let sysAlerts:SysAlerts = SysAlerts()
        sysAlerts.iTableId = dic["iTableId"] as! Int
        sysAlerts.nvSysTableNameEng = dic["nvSysTableNameEng"] as! String
        sysAlerts.iSysTableRowId = dic["iSysTableRowId"] as! Int
        sysAlerts.nvAletName = dic["nvAletName"] as! String
        
        return sysAlerts
    }
    
    func sysToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<SysAlerts>{
        
        var arrSysAlerts:Array<SysAlerts> = Array<SysAlerts>()
        var objSysAlerts:SysAlerts = SysAlerts()
        
        for i in 0  ..< arrDic.count 
        {
            objSysAlerts = dicToSys(arrDic[i])
            arrSysAlerts.append(objSysAlerts)
        }
        return arrSysAlerts
    }

    
    func sysToDic(_ arrSys:Array<SysAlerts>)->Dictionary<String,Array<SysAlerts>>{
        
        var prevITableIdL:Int = -1
        var prevSTableIdL:String = "-1"
        
        var dicSysAlerts:Dictionary<String,Array<SysAlerts>> = Dictionary<String,Array<SysAlerts>>()
        
        for sys in arrSys
        {
            if sys.iTableId == prevITableIdL
            {
                dicSysAlerts[prevSTableIdL]?.append(sys)
            }
            else
            {
                var arrSys:Array<SysAlerts> = []
                arrSys.append(sys)
                
                dicSysAlerts[sys.iTableId.description] = arrSys
                prevITableIdL = sys.iTableId
                prevSTableIdL = sys.iTableId.description
            }
        }
        return dicSysAlerts
    }

    //מחזיר את הסטרינגים לפי טבלה מסויימת שנשלחת
    func SysnvAletName(_ iTableRowId:Int)->Array<String>
    {
        var arrString:Array<String> = []
        if let _ = Global.sharedInstance.dicSysAlerts[iTableRowId.description] {
        for sys in Global.sharedInstance.dicSysAlerts[iTableRowId.description]!
        {
            if sys.iTableId == iTableRowId
            {
                arrString.append(sys.nvAletName)
            }
        }
        }
        return arrString
    }
}
