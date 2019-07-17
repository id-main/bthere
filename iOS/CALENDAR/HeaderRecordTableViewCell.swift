//
//  HeaderRecordTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/14/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class HeaderRecordTableViewCell: UITableViewCell {

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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        Global.sharedInstance.setAllEventsArray()
        // Configure the view for the selected state
    }
    
    func setDisplayData(_ dateDesc:String,daydesc:String){
//
//        for var item in Global.sharedInstance.arrEvents{
            //  //\\print(item.startDate)
            //lblDescDate.text = item.startDate
            lblDescDate.text = dateDesc
        lblDayDesc.text = daydesc
        AppDelegate.i += 1
        
        
      //  }
        
    }

}
