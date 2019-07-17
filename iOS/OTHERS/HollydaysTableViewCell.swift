//
//  HollydaysTableViewCell.swift
//  bthree-ios
//
//  Created by User on 16.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class HollydaysTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventday: UILabel!
  
    
    func setDisplayData(_ str:String)
    {
        eventday.text = str
    }
}
