//
//  Discount90Obj.swift
//  BThere
//
//  Created by Racheli Kroiz on 23.1.2017.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit

//new 23-01-17

class Discount90Obj: NSObject {
    var iDiscountId:Int = 0
    var nvImageFilePath:String = ""
    var nvDescription:String = ""
    var dtDateDscount:Date = Date()
    
    override init() {
        iDiscountId = 0
        nvImageFilePath = ""
        nvDescription = ""
        dtDateDscount = Date()
    }
    
    init(iDiscountId_:Int,nvImageFilePath_:String,nvDescription_:String,dtDateDscount_:Date) {
        iDiscountId = iDiscountId_
        nvImageFilePath = nvImageFilePath_
        nvDescription = nvDescription_
        dtDateDscount = dtDateDscount_
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        iDiscountId = dic["iDiscountId"]! as AnyObject as! Int
        nvImageFilePath = dic["nvImageFilePath"]! as AnyObject as! String
        nvDescription = dic["nvDescription"]! as AnyObject as! String
        dtDateDscount = dic["dtDateDscount"]! as AnyObject as! Date
        
        return dic
    }
    
    func dicToDiscount90Obj(_ dic:Dictionary<String,AnyObject>)->Discount90Obj
    {
        let discount90Obj:Discount90Obj = Discount90Obj()
        
        discount90Obj.iDiscountId = dic["iDiscountId"]! as AnyObject as! Int
        discount90Obj.nvImageFilePath = dic["nvImageFilePath"]! as AnyObject as! String
        discount90Obj.nvDescription = dic["nvDescription"]! as AnyObject as! String
        if !(dic["dtDateDscount"] is NSNull)
        {
            discount90Obj.dtDateDscount = Global.sharedInstance.getStringFromDateString(dic["dtDateDscount"]! as AnyObject as! String)
        }
        return discount90Obj
    }
    
    func discount90ObjDicToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<Discount90Obj>{
        
        var arrDiscount90Obj:Array<Discount90Obj> = Array<Discount90Obj>()
        var discount90Obj:Discount90Obj = Discount90Obj()
        
        for i in 0  ..< arrDic.count
        {
            discount90Obj = dicToDiscount90Obj(arrDic[i])
            arrDiscount90Obj.append(discount90Obj)
        }
        return arrDiscount90Obj
    }
}
