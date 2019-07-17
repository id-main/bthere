//
//  Domain.swift
//  bthree-ios
//
//  Created by User on 20.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class Domain: NSObject {

    var iCategoryRowId:Int = 0
    var iFieldRowId:Int = 0
    var nvCategoryName:String = ""
    var nvFieldName:String = ""
    
    override init() {
        iCategoryRowId = 0
        iFieldRowId = 0
        nvCategoryName = ""
        nvFieldName = ""
    }
    
    init(_iCategoryRowId:Int,_iFieldRowId:Int,_nvCategoryName:String,_nvFieldName:String) {
        
        iCategoryRowId = _iCategoryRowId
        iFieldRowId = _iFieldRowId
        nvCategoryName = _nvCategoryName
        nvFieldName = _nvFieldName
    }
    
    func dicToDomain(dic:Dictionary<String,AnyObject>)->Domain
    {
        let domain:Domain = Domain()
        domain.iCategoryRowId = dic["iCategoryRowId"] as! Int
        domain.iFieldRowId = dic["iFieldRowId"] as! Int
        domain.nvCategoryName = dic["nvCategoryName"] as! String
        domain.nvFieldName = dic["nvFieldName"] as! String
        
        return domain
    }
    
    func domainToArray(arrDic:Array<Dictionary<String,AnyObject>>)->Array<Domain>{
      
        var arrDomain:Array<Domain> = Array<Domain>()
        var objDomain:Domain = Domain()
        
        for i in 0  ..< arrDic.count 
        {
            objDomain = dicToDomain(arrDic[i])
            arrDomain.append(objDomain)
        }
       return arrDomain
    }
}
