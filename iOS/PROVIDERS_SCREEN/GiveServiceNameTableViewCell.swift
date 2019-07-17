//
//  GiveServiceNameTableViewCell.swift
//  bthree-ios
//
//  Created by User on 21.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class GiveServiceNameTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ st:String){
        lblName.text = st
    }

}
