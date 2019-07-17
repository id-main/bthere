//
//  DomainTableViewCell.swift
//  HoursBusinessTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu 04/12/2017
//  Copyright © 2017 Bthere. All rights reserved.
//

import UIKit


class DomainTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    var ISEXPANDED:Bool = false
    var delegate:saveInGlobalDelegate!=nil
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
    //    super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  
    
}
