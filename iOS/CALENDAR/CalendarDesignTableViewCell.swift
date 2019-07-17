//
//  CalendarDesignTableViewCell.swift
//  bthree-ios
//
//  Created by User on 5.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class CalendarDesignTableViewCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ value:String) {
        lblText.text = value
    }

}
