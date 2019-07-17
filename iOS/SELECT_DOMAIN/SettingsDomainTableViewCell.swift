//
//  SettingsDomainTableViewCell.swift
//  HoursBusinessTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu 04/02/2018 dmy
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit


class SettingsDomainTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    var ISEXPANDED:Bool = false
    var delegate:saveInGlobalDelegate1!=nil
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector (sendmoreInfo))
        tap1.delegate = self
        self.addGestureRecognizer(tap1)
    }
    @objc func sendmoreInfo() {
        delegate.selectedDomain(_WHICHDOMAIN: self.tag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
    
    }
  
    
}
