//
//  ACCESSPERMISIONCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu 08/03/2019 dmy
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit


class ACCESSPERMISIONCell: UITableViewCell{
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
          delegate.selectedDomain(_WHICHDOMAIN: self.tag, _state: btnAddservicePermission.isSelected)

    }
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    var ISEXPANDED:Bool = false
    var delegate:saveInGlobalDelegate2!=nil
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector (sendmoreInfo))
        tap1.delegate = self
        self.addGestureRecognizer(tap1)
    }
    @objc func sendmoreInfo() {
        self.btnAddservicePermission(self.btnAddservicePermission)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
    
    }
    func setDataForCell(_ selected: Bool) {
        if selected == false {
            btnAddservicePermission.isSelected = false
            btnAddservicePermission.isCecked = false

        } else {
            btnAddservicePermission.isSelected = true
            btnAddservicePermission.isCecked = true
        }
    }
  
    
}
