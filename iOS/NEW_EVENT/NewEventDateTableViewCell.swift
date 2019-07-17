//
//  NewEventDateTableViewCell.swift
//  Bthere
//
//  Created by User on 12.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//קבע אירוע -  הסל של התאריך
class NewEventDateTableViewCell: UITableViewCell {

    var delegate:editTextInCellDelegate!=nil
    @IBOutlet weak var dpDate: UIDatePicker!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        dpDate.layer.borderWidth = 1
        dpDate.layer.borderColor = UIColor.black.cgColor
        
        dpDate.backgroundColor = UIColor.clear
        dpDate.setValue(UIColor.black, forKeyPath: "textColor")
        dpDate.datePickerMode = UIDatePicker.Mode.date
        dpDate.setValue(false, forKey: "highlightsToday")
        dpDate.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        dpDate.layer.borderWidth = 1
        dpDate.layer.borderColor = UIColor.black.cgColor
        
        dpDate.backgroundColor = UIColor.clear
        dpDate.setValue(UIColor.black, forKeyPath: "textColor")
        dpDate.datePickerMode = UIDatePicker.Mode.date
        dpDate.setValue(false, forKey: "highlightsToday")
        dpDate.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        delegate.editTextInCell(1, text: sender.date as AnyObject)
        //Global.sharedInstance.dateEvent = sender.date
 
    }

}
