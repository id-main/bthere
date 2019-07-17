//
//  appPermissions.swift
//  bthree-ios


import UIKit

class appPermissions: NSObject {

    var iPermissionType : Int!
    var nvValue : String!
    
    override init() {
        iPermissionType = 0
        nvValue = ""
    }
    init(_iPermissionType : Int, _nvValue : String)
    {
        iPermissionType = _iPermissionType
        nvValue = _nvValue
    }
    func appPermissionsToArray(_ arrDic:Array<Dictionary<String,AnyObject>>)->Array<appPermissions>{
        var arrAppPermissions:Array<appPermissions> = Array<appPermissions>()
        var permission:appPermissions = appPermissions()
        for i in 0  ..< arrDic.count
        {
            permission = dicToappPermissions(arrDic[i])
            if (permission.iPermissionType != 0 && permission.nvValue != "") {
            arrAppPermissions.append(permission)
            }
        }
        return arrAppPermissions
    }
    func dicToappPermissions(_ permissionDic:Dictionary<String,AnyObject>)->appPermissions
    {
        let permission:appPermissions = appPermissions()
        permission.iPermissionType = 0
        permission.nvValue = ""
        if let _ = permissionDic["iPermissionType"] as? Int {
            permission.iPermissionType = (permissionDic["iPermissionType"] as! Int)
        }
        if let _ = permissionDic["nvValue"] as? String {
            permission.nvValue = (permissionDic["nvValue"] as! String)
        }
        return permission
    }
    func getDic()->Dictionary<String,AnyObject>
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iPermissionType"] = iPermissionType as AnyObject
        dic["nvValue"] = nvValue as AnyObject
        return dic
    }
  }
