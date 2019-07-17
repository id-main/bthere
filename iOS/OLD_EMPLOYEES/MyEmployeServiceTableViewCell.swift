//
//  MyEmployeServiceTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 29.03.2017
//  Copyright © 2017 Bthere. All rights reserved.
//

import UIKit


class MyEmployeServiceTableViewCell: UITableViewCell {
  //  var delegate:refreshTextField!=nil
    var servicesname:Array<String> = []
    @IBOutlet var lblServiceName: UILabel!
    var PERMISSIONSArray:NSMutableArray = NSMutableArray()
    var Usera:User = User()
    var service:objProviderServices = objProviderServices()
    @IBOutlet weak var btnAddservicePermission: CheckBoxForExistServiceOk!
    @IBAction func btnAddservicePermission(_ sender: CheckBoxForExistServiceOk) {
        btnAddservicePermission.isSelected = !btnAddservicePermission.isSelected
        if btnAddservicePermission.isSelected {
            // set selected
            btnAddservicePermission.isSelected = true
            btnAddservicePermission.isCecked = true
        } else {
            // set deselected
            btnAddservicePermission.isSelected = false
            btnAddservicePermission.isCecked = false
        }
        
    }
    
  ///  @IBOutlet weak var top: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setDisplayData(_ st:String, aPERMISSIONSArray:NSMutableArray, myuser:User,myservice:objProviderServices){
        self.btnAddservicePermission.isCecked = false
        lblServiceName.text = st
        self.PERMISSIONSArray = aPERMISSIONSArray
        self.Usera = myuser
        self.service = myservice
        let userid:Int = Usera.iUserId
        let serviceID:Int = service.iProviderServiceId
        for i in 0..<self.PERMISSIONSArray.count {
            if let _:NSDictionary = self.PERMISSIONSArray[i] as? NSDictionary {
                let MOD:NSDictionary = self.PERMISSIONSArray[i] as! NSDictionary
                if let _:Int = MOD["iUserId"] as? Int {
                    let currentuserid:Int = MOD["iUserId"] as! Int
                    if let _:Int = MOD["iSupplierServiceId"] as? Int {
                        let currentserviceID:Int = MOD["iSupplierServiceId"] as! Int
                    if currentuserid == userid && currentserviceID == serviceID {
                        self.btnAddservicePermission.isCecked = true
                    }
                        
//                        if currentuserid != userid && currentserviceID != serviceID {
//                        self.btnAddservicePermission.isCecked = false
//                    }
                }
                }
            }
        }
//            PERMISSIONSArray (
//                {
//                    iServicePermissionId = 21;
//                    iSupplierServiceId = 54;
//                    iUserId = 235;
//                },
//                {
//                    iServicePermissionId = 22;
//                    iSupplierServiceId = 54;
//                    iUserId = 237;
//            },
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        
        
    }
}

