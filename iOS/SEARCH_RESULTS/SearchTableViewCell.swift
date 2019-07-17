//
//  SearchTableViewCell.swift
//  bthree-ios
//
//  Created by User on 14.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSubject: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDisplayData(_ text:String)
    {
        lblSubject.text = text
        
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblSubject.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
        }
    }
}
