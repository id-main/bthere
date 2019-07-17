//
//  NOTIFICATIONSTableViewCell.swift
//  BThere
//
//  Created by Eduard Stefanescu on 11/29/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit

class NOTIFICATIONSTableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var receivedon: UILabel!
    @IBOutlet weak var datesent: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        receivedon.text = "RECEIVED_ON".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setDisplayData(_ notification:String, datesenton:String) {
        questionLabel.text = notification
       // datesent.text = datesenton
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            questionLabel.textAlignment = .right
            receivedon.textAlignment = .right
            datesent.textAlignment = .right
        } else {
            // Hebrew
            questionLabel.textAlignment = .left
            receivedon.textAlignment = .left
            datesent.textAlignment = .left
        }
    }
}
