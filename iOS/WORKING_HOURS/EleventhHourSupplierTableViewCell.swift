
//  EleventhHourSupplierTableViewCell.swift
//  bthree-ios
//
//  Created by User on 8.5.2016.
//  Copyright © 2016 Webit. All rights reserved.


import UIKit

class EleventhHourSupplierTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblCampaign: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDisplayData(_ date:String,campaign:String)
    {
        lblDate.text = date
        lblCampaign.text = campaign
    }

}
