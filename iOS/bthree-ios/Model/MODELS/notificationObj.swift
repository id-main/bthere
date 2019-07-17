//
//  notificationObj.swift
//  bthree-ios


import UIKit

class notificationObj: NSObject {

    var dtSentDate : String!
    var nvContent : String!
    
        override init() {
        dtSentDate = ""
         nvContent = ""
       
    }
    init(_dtSentDate : String, _nvContent : String)
    {
        dtSentDate = _dtSentDate
        nvContent = _nvContent
        
    }
    
    init(notificationObj : Dictionary<String, AnyObject>) {
        dtSentDate = notificationObj["dtSentDate"] as! String
        nvContent = notificationObj["nvContent"] as! String
    
    }
    
    func getnotificationObjDic() -> Dictionary<String, AnyObject> {
        var dic = Dictionary<String, AnyObject>()
        
        dic["dtSentDate"] = self.dtSentDate as AnyObject
        dic["nvContent"] = self.nvContent as AnyObject
                return dic
    }
}
