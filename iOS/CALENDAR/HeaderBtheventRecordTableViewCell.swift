//
//  HeaderBtheventRecordTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu 20/03/2017
//  Copyright © 2017 Bthere. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class HeaderBtheventRecordTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var i  = 0
    var DICTUSER:NSDictionary = NSDictionary()
    var indexPathRow:Int = 0
    var ORDERDETAIL:allKindEventsForListDesign =  allKindEventsForListDesign()


    @IBOutlet var lblDescDate: UILabel!
     var dateFormatter = DateFormatter()
    
    
    @IBOutlet var EYEORBTHERE: UIImageView!
    @IBOutlet var USERNAME: UILabel!
    @IBOutlet var TITLEEVENT: UILabel!
    @IBOutlet var DAYOFEVENT: UILabel!
     @IBOutlet var DATEEVENT: UILabel!
    @IBOutlet var HOURSEVENT: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDisplayData(_ EVENT:allKindEventsForListDesign){
 
        ORDERDETAIL = EVENT
          print("EVENT \(EVENT)")
        if ORDERDETAIL.iCoordinatedServiceId > 0 {
            EYEORBTHERE.image =  UIImage(named: "bthere-small-weekd.png")!
        } else {
            EYEORBTHERE.image = UIImage(named: "small-eye.png")!
        }
        DATEEVENT.text = dateFormatter.string(from: ORDERDETAIL.dateEvent as Date)
       // lblHour.text = st
        HOURSEVENT.text =   "\(ORDERDETAIL.fromHour) - \(ORDERDETAIL.toHour)"
        let dayWeek = Calendar.sharedInstance.getDayOfWeek(ORDERDETAIL.dateEvent)
        
        let dayInWeek = DateFormatter().weekdaySymbols[dayWeek! - 1]
        DAYOFEVENT.text = dayInWeek
        TITLEEVENT.text = ORDERDETAIL.title
     //   lblSupllierName.text = nvSupplierName
     //   lblSupplierService.text = descrierealong
     //   lblSupplierAddress.text = nvAddress

        
    }

}
