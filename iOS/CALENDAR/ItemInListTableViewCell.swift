//
//  ItemInListTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/27/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class ItemInListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ st:String){
        lblDesc.text = st
        lblDesc.textAlignment = .center
    }

}
