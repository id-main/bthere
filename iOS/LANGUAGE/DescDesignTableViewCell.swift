//
//  DescDesignTableViewCell.swift
//  Bthere
//
//  Created by User on 9.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class DescDesignTableViewCell: UITableViewCell {

    @IBOutlet weak var viewButtom: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var desc: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ st:String){
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            desc.textAlignment = .right
        } else {
             desc.textAlignment = .left
        }
        desc.text = st
    }

}
