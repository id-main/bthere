//
//  CouponObj.swift
//  Bthere
//
//  Created by User on 25.7.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class CouponObj: NSObject {

    var iCouponId:Int = 0
    var iSupplierServiceId:Int = 0
    
      var nvCouponName:String = ""
    var iCouponType:Int = 0
    var dDate:String = ""
    var tFromHour:String = ""
    var tToHour:String = ""
   
    
    override init() {
        iCouponId = 0
        iSupplierServiceId = 0
        
        nvCouponName = ""
         iCouponType = 0
         dDate = ""
         tFromHour = ""
        tToHour = ""
    }
    
    init(_iCouponId:Int,_iSupplierServiceId:Int,_nvCouponName:String,_iCouponType:Int,_dDate:String,_tFromHour:String,_tToHour:String) {
        iCouponId = _iCouponId
    iSupplierServiceId = _iSupplierServiceId
       nvCouponName = _nvCouponName
       iCouponType = _iCouponType
        dDate = _dDate
        tFromHour = _tFromHour
       tToHour = _tToHour
           }
    
    //לשים לב לפני השימוש בפונקציה שהשמשתנים שחוזרים מהשרת הם בדיוק באותם שמות
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iCouponId"] = iCouponId as AnyObject
        dic["iSupplierServiceId"] = iSupplierServiceId as AnyObject
        dic["nvCouponName"] = nvCouponName as AnyObject
        dic["iCouponType"] = iCouponType as AnyObject
         dic["dDate"] = dDate as AnyObject
        dic["tFromHour"] = tFromHour as AnyObject
        dic["tToHour"] = tToHour as AnyObject
        return dic
    }
    
    func dicToCouponObj(_ dic:Dictionary<String,AnyObject>)->CouponObj
    {
        let coupon:CouponObj = CouponObj()
        
        coupon.iCouponId = dic["iCouponId"] as! Int
        coupon.iSupplierServiceId = dic["iSupplierServiceId"] as! Int
        coupon.nvCouponName = dic["nvCouponName"] as! String
        coupon.iCouponType = dic["iCouponType"] as! Int
        coupon.dDate = dic["dDate"] as! String
        coupon.tFromHour = dic["tFromHour"] as! String
        coupon.tToHour = dic["tToHour"] as! String
        
        return coupon
    }
    
    func arrayToCouponObj(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<CouponObj>{
        
        var arrCoupon:Array<CouponObj> = Array<CouponObj>()
        var objCoupon:CouponObj = CouponObj()
        
        for i in 0  ..< arrDic.count 
        {
            objCoupon = dicToCouponObj(arrDic[i])
            arrCoupon.append(objCoupon)
        }
        return arrCoupon
    }
}
