//
//  HeaderSixMonthsTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu 16/01/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class HeaderSixMonthsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var i  = 0
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    
   let calendar = Foundation.Calendar.current
    @IBOutlet var lblDescDate: UILabel!
    
    @IBOutlet var imgToday: UIImageView!
    @IBOutlet var lblDayDesc: UILabel!
    @IBOutlet var lblWasCancel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        Global.sharedInstance.setAllEventsArray()
        // Configure the view for the selected state
    }
    
    func setDisplayData(_ dateDesc:String,daydesc:String){
        lblDescDate.text = dateDesc
        lblDayDesc.text = daydesc
        AppDelegate.i += 1
       
    }

}
