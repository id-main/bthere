//
//  AppointmentNearByTableViewCell.swift
//  Bthere
//
//  Created by User on 1.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים:סל של תורים פנויים קרובים
class AppointmentNearByTableViewCell: UITableViewCell {
    
    //MARK: - Outlet
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblHour: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    //MARK: - Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDisplayData(_ date:String,hour:String,text:String)
    {
        lblDate.text = date
        lblHour.text = hour
        lblDesc.text = text
    }
    
}
