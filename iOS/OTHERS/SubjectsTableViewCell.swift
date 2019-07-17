//
//  SubjectsTableViewCell.swift
//  bthree-ios
//
//  Created by User on 1.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class SubjectsTableViewCell: UITableViewCell {

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
    }

}
