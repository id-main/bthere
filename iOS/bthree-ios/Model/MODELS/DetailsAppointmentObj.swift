//
//  DetailsAppointmentObj.swift
//  bthree-ios


import UIKit

class DetailsAppointmentObj: NSObject {
    var service:String
    var date:String
    var hour:String
    var serviceName:String
    var idTurn:Int
    var tag:Int
    var iSupplierId:Int
    var nvPhone:String
    
    override init() {
        service  = ""
        date  = ""
        hour  = ""
        serviceName  = ""
        idTurn  = 0
        tag  = 0
        iSupplierId  = 0
        nvPhone  = ""
    }
    init(_service:String,
         _date:String,
         _hour:String,
         _serviceName:String,
         _idTurn:Int,
         _tag:Int,
         _iSupplierId:Int,
         _nvPhone:String)
    {
        service  = _service
        date  = _date
        hour  = _hour
        serviceName  = _serviceName
        idTurn  = _idTurn
        tag  = _tag
        iSupplierId  = _iSupplierId
        nvPhone  = _nvPhone
    }
}
