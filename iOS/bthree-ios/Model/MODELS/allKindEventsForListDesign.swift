//
//  allKindEventsForListDesign.swift
//  Bthere
//
//  Created by Racheli Kroiz on 8.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//
/* Update to reflect actual datasets
 Ungureanu Ioan 13/01/2017
 {
 dtDateOrder = "/Date(1487205360000+0200)/";
 iCoordinatedServiceId = 70;
 iDayInWeek = 5;
 iProviderUserId = 124;
 iUserId = 65;
 nvAddress = "Pima County 11";
 nvComment = "";
 nvFirstName = dddff;
 nvFromHour = "/Date(1487205360000+0200)/";
 nvLogo = "<null>";
 nvSupplierName = "alta companie";
 nvToHour = "/Date(1487207100000+0200)/";
 objProviderServiceDetails =         (
 {
 iProviderServiceId = 21;
 nvServiceName = "tuns dama";
 },
 {
 iProviderServiceId = 23;
 nvServiceName = "tuns barbati";
 }
 
 */
import UIKit

class allKindEventsForListDesign: NSObject {

    var dateEvent:Date = Date()
    var title:String = ""
    var fromHour:String = ""
    var toHour:String = ""
    var tag:Int = 0//1=Bthere,2=phone
    var nvAddress:String = ""
    var nvSupplierName:String = ""
    var iDayInWeek:Int = 0
    var nvServiceName:String = ""
    var nvComment:String = ""
    var iProviderUserId:Int = 0 //need it to filter results with worker assigned to order
    var iUserId:Int = 0 //need it to know customer who initated it
    var ClientnvFullName:String = ""
    var iCoordinatedServiceId:Int = 0
    var iCancelallCoordinatedServiceIds:Array<Int> = [] //this is when we have multiple ids and want to send cancel order to server
    var iCancelalliUserId:Array<Int> = []
    var isCancelGroup:Bool = false
    var specialDate:String = ""
    var ARRAYiProviderUserId:Array<Int> = []
    var objProviderServiceDetails:Array<ProviderServiceDetailsObj> = []
    var nvLogo:String = ""
    var chServiceColor:String = ""
    var viewsforweek:Array<Array<Int>> = []
    var iCoordinatedServiceStatusType = 0
    var nvPhone:String = ""
    var iSupplierId:Int = 0

    override init() {
        dateEvent = Date()
        title = ""
        fromHour = ""
        toHour = ""
        tag = 0
        nvAddress = ""
        iDayInWeek = 0
        nvServiceName = ""
        nvComment = ""
        iProviderUserId = 0
        iUserId = 0
        ClientnvFullName = ""
        iCoordinatedServiceId = 0
        iCancelallCoordinatedServiceIds = []
        iCancelalliUserId = []
        isCancelGroup = false
        specialDate = "" //this field is needed for day view appoinments in customer side
        ARRAYiProviderUserId = []
        objProviderServiceDetails = []
        nvLogo = ""
        chServiceColor = ""
        viewsforweek = []
        iCoordinatedServiceStatusType = 0
        nvPhone = ""
        iSupplierId = 0
        
    }
    
    init(_dateEvent:Date,_title:String,_fromHour:String,_toHour:String,_tag:Int,_nvAddress:String,_nvSupplierName:String,_iDayInWeek:Int,_nvServiceName:String,_nvComment:String, _iProviderUserId:Int, _iUserId:Int, _ClientnvFullName:String,_iCoordinatedServiceId:Int,_iCancelallCoordinatedServiceIds:Array<Int>,_iCancelalliUserId:Array<Int>,_isCancelGroup:Bool,_specialDate:String,
         _ARRAYiProviderUserId:Array<Int>, _objProviderServiceDetails:Array<ProviderServiceDetailsObj>,_nvLogo:String,_chServiceColor:String,_viewsforweek:Array<Array<Int>>, _iCoordinatedServiceStatusType:Int,_nvPhone:String,_iSupplierId:Int) {
        dateEvent = _dateEvent
        title = _title
        fromHour = _fromHour
        toHour = _toHour
        tag = _tag
        nvAddress = _nvAddress
        nvSupplierName = _nvSupplierName
        iDayInWeek = _iDayInWeek
        nvServiceName = _nvServiceName
        nvComment = _nvComment
        iProviderUserId = _iProviderUserId
        iUserId = _iUserId
        ClientnvFullName = _ClientnvFullName
        iCoordinatedServiceId = _iCoordinatedServiceId
        iCancelallCoordinatedServiceIds = _iCancelallCoordinatedServiceIds
        iCancelalliUserId = _iCancelalliUserId
        isCancelGroup = _isCancelGroup
        specialDate = _specialDate
        ARRAYiProviderUserId = _ARRAYiProviderUserId
        objProviderServiceDetails = _objProviderServiceDetails
        nvLogo = _nvLogo
        chServiceColor = _chServiceColor
        viewsforweek = _viewsforweek
        iCoordinatedServiceStatusType = _iCoordinatedServiceStatusType
        nvPhone = _nvPhone
        iSupplierId = _iSupplierId
       
    }
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["dateEvent"] = dateEvent as AnyObject
        dic["title"] = title as AnyObject
        dic["fromHour"] = fromHour as AnyObject
        dic["toHour"] = toHour as AnyObject
        dic["tag"] = tag as AnyObject
        dic["nvAddress"] = nvAddress as AnyObject
        dic["nvSupplierName"] = nvSupplierName as AnyObject
        dic["iDayInWeek"] = iDayInWeek as AnyObject
        dic["nvServiceName"] = nvServiceName as AnyObject
        dic["nvComment"] = nvComment as AnyObject
        dic["iProviderUserId"] = iProviderUserId as AnyObject
        dic["ClientnvFullName"] = ClientnvFullName as AnyObject
        dic["iCoordinatedServiceId"] = iCoordinatedServiceId as AnyObject
        dic["iCancelallCoordinatedServiceIds"] = iCancelallCoordinatedServiceIds as AnyObject //*
        dic["iCancelalliUserId"] = iCancelalliUserId as AnyObject
        dic["iUserId"] = iUserId as AnyObject
        dic["isCancelGroup"] = isCancelGroup as AnyObject
        dic["specialDate"] = specialDate as AnyObject
        dic["ARRAYiProviderUserId"] = ARRAYiProviderUserId as AnyObject
        dic["objProviderServiceDetails"] = objProviderServiceDetails.uniquevals as AnyObject
        dic["nvLogo"] = nvLogo as AnyObject
        dic["chServiceColor"] = chServiceColor as AnyObject
        dic["viewsforweek"] = viewsforweek as AnyObject
        dic["iCoordinatedServiceStatusType"] = iCoordinatedServiceStatusType as AnyObject
        dic["nvPhone"] = nvPhone as AnyObject
        dic["iSupplierId"] = iSupplierId as AnyObject
        return dic
    }

}
extension Array where Element : Hashable {
    var uniquevals: [Element] {
        return Array(Set(self))
    }
}

