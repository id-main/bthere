//
//  SyncContactsRegistrationTableViewCell.swift
//  Bthere
//
//  Created by User on 29.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class SyncContactsRegistrationTableViewCell: UITableViewCell {

    var delegate:hideChooseAllDelegateax!=nil
    
    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var viewTOp: UIView!
    @IBOutlet weak var btnISsync: UIButton!
    @IBOutlet weak var lblName: UILabel!
    
    @IBAction func btnIsSync(_ sender: UIButton) {
       sender.isHidden = true
       Global.sharedInstance.contactList[sender.tag].bIsSync = false
       delegate.hideChooseAll()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
func setDisplayData(_ str:String)  {
    
    
    if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
    {
       lblName.font = UIFont(name: "OpenSansHebrew-Regular", size: 15)
    }
        lblName.text = str

    
    }

}
