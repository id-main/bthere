//
//  aprovedandOrdersCountObj.swift
//  bthree-ios


import UIKit

class aprovedandOrdersCountObj: NSObject {

    var iNumberofOrders : Int!
    var bIsAproved : Bool!
    
        override init() {
        iNumberofOrders = 0
        bIsAproved = false
    }
    init(_iNumberofOrders : Int, _bIsAproved : Bool)
    {
        iNumberofOrders = _iNumberofOrders
        bIsAproved = _bIsAproved
    }
    
    init(aprovedandOrdersCountObj : Dictionary<String, AnyObject>) {
        iNumberofOrders = aprovedandOrdersCountObj["iNumberofOrders"] as! Int
        bIsAproved = aprovedandOrdersCountObj["bIsAproved"] as! Bool
    
    }
    
    func getaprovedandOrdersCountObjDic() -> Dictionary<String, AnyObject> {
        var dic = Dictionary<String, AnyObject>()
        dic["iNumberofOrders"] = self.iNumberofOrders as AnyObject
        dic["bIsAproved"] = self.bIsAproved as AnyObject
        return dic
    }
  }
