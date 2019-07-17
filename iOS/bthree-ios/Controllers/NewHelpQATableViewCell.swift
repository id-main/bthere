//
//  NewHelpQATableViewCell.swift
//  BThere
//
//  Created by Eduard Stefanescu on 11/29/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit

class NewHelpQATableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setDisplayData(_ question:String, answer:String) {
        questionLabel.text = question
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            questionLabel.textAlignment = .right
        } else {
            // Hebrew
            questionLabel.textAlignment = .left
        }
    }
}
