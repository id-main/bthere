//
//  PersonalDetailsTableViewCell.swift
//  BThereMy
//
//  Created by User on 8.2.2016.
//  Copyright © 2016 Gili. All rights reserved.
//

import UIKit

class PersonalDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var txtfDetails: UITextField!    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ detailsText:String)
    {
    lblDetails.text = detailsText
    txtfDetails.borderStyle = .none
    txtfDetails.layer.cornerRadius = 10
    }

}
