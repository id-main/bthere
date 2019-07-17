//
//  orderObj.swift
//  Bthere
//
//  Created by User on 10.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class OrderObj: NSObject {
    
    
    var iSupplierId:Int = 0/*ספק*/
    var iUserId:Int = 0/*לקוח*/
    
    var iSupplierUserId:Array<Int> = []/*נותן השרות*/
    var iProviderServiceId:Array<Int> = []/*סוג שירות*/
    var dtDateOrder:Date = Date()
    var nvFromHour:String = ""
    var nvComment:String = ""
    var nvToHour:String = "" //need for blocking hours
    
    override init() {
        iSupplierId = 0
        iUserId = 0
        dtDateOrder = Date()
        nvFromHour = ""
        nvComment = ""
        iSupplierUserId = []
        iProviderServiceId = []
        nvToHour = ""
        
    }
    
    init(_iSupplierId:Int,_iUserId:Int,_iSupplierUserId:Array<Int>,_iProviderServiceId:Array<Int>,_dtDateOrder:Date,_nvFromHour:String,_nvComment:String,_nvToHour:String) {
        iSupplierId = _iSupplierId
        iUserId = _iUserId
        iSupplierUserId = _iSupplierUserId
        iProviderServiceId = _iProviderServiceId
        dtDateOrder = _dtDateOrder
        nvFromHour = _nvFromHour
        nvComment = _nvComment
        nvToHour = _nvToHour
    }
    
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        dic["iSupplierId"] = iSupplierId as AnyObject
        dic["iUserId"] = iUserId as AnyObject
        dic["iSupplierUserId"] = iSupplierUserId as AnyObject
        dic["iProviderServiceId"] = iProviderServiceId as AnyObject
        dic["dtDateOrder"] = Global.sharedInstance.convertNSDateToString(self.dtDateOrder) as AnyObject
        dic["nvFromHour"] = nvFromHour as AnyObject
        dic["nvComment"] = nvComment as AnyObject
        dic["nvToHour"] = nvToHour as AnyObject
        return dic
    }
    
    //לשים לב לפני השימוש בפונקציה שהשמשתנים שחוזרים מהשרת הם בדיוק באותם שמות
    func getOrderDic() -> Dictionary<String, AnyObject> {
        var dic = Dictionary<String, AnyObject>()
        dic["iSupplierId"] = self.iSupplierId as AnyObject
        dic["iUserId"] = self.iUserId as AnyObject
        dic["iSupplierUserId"] = self.iSupplierUserId as AnyObject
        dic["iProviderServiceId"] = self.iProviderServiceId as AnyObject
        dic["dtDateOrder"] = Global.sharedInstance.convertNSDateToString(self.dtDateOrder) as AnyObject
        dic["nvFromHour"] = self.nvFromHour as AnyObject
        dic["nvComment"] = self.nvComment as AnyObject
        dic["nvToHour"] = self.nvToHour as AnyObject
        return dic
    }
    
}
extension StringProtocol where Index == String.Index {
    func substring(from start: String, to end: String? = nil, options: String.CompareOptions = []) -> SubSequence? {
        guard let lower = range(of: start, options: options)?.upperBound else { return nil }
        guard let end = end else { return self[lower...] }
        guard let upper = self[lower...].range(of: end, options: options)?.lowerBound else { return nil }
        return self[lower..<upper]
    }
}
