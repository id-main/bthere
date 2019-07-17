//
//  GlobalDataTableViewCell.swift
//  BThere
//
//  Created by User on 8.2.2016.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class GlobalDataTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_descriptionCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDisplayData(_ content:String)
    {
        lbl_descriptionCell.text = content
    }
    
}
