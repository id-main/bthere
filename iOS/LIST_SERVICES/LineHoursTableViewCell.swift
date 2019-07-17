//
//  LineHoursTableViewCell.swift
//  bthree-ios
//
//  Created by User on 16.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class LineHoursTableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lineseparator: UIView!
    
    func setDisplayData(_ str:String) {
        lblHours.text = str
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
      //\\  lblHours.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
    }
}
