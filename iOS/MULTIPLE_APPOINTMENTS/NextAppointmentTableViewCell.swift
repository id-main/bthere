//
//  NextAppointmentTableViewCell.swift
//  BThere
//
//  Created by Ioan Ungureanu on 01/03/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit

class NextAppointmentTableViewCell: UITableViewCell {
    @IBOutlet weak var BTN_NEXT_APPOINTMENT: UIButton!
    var delegate:openNextAppointmentDelegate! = nil
    
    @IBAction func goback(_ sender:AnyObject) {
        delegate.goback()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BTN_NEXT_APPOINTMENT.setTitle("BTN_NEXT_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE) , for: UIControl.State())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
}
