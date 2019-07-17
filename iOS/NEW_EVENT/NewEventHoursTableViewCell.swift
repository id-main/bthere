//
//  NewEventHoursTableViewCell.swift
//  Bthere
//
//  Created by User on 12.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

//קבע אירוע -  הסל של השעות
class NewEventHoursTableViewCell: UITableViewCell {

    var delegate:editTextInCellDelegate!=nil
    @IBOutlet weak var dpToHour: UIDatePicker!
    
    @IBOutlet weak var dpFromHour: UIDatePicker!
    
    @IBOutlet weak var viewLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dpFromHour.layer.borderWidth = 1
        dpToHour.layer.borderWidth = 1
        viewLine.layer.borderWidth = 1
        
        dpFromHour.layer.borderColor = UIColor.white.cgColor
        dpToHour.layer.borderColor = UIColor.white.cgColor
        viewLine.layer.borderColor = UIColor.white.cgColor
        
        dpFromHour.backgroundColor = UIColor.black
        dpFromHour.setValue(UIColor.white, forKeyPath: "textColor")
        dpFromHour.datePickerMode = UIDatePicker.Mode.time
        dpFromHour.setValue(false, forKey: "highlightsToday")
        dpFromHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        dpToHour.backgroundColor = UIColor.black
        dpToHour.setValue(UIColor.white, forKeyPath: "textColor")
        dpToHour.datePickerMode = UIDatePicker.Mode.time
        dpToHour.setValue(false, forKey: "highlightsToday")
        dpToHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        dpFromHour.layer.borderWidth = 1
        dpToHour.layer.borderWidth = 1
        viewLine.layer.borderWidth = 1
        
        dpFromHour.layer.borderColor = UIColor.white.cgColor
        dpToHour.layer.borderColor = UIColor.white.cgColor
        viewLine.layer.borderColor = UIColor.white.cgColor
        
        dpFromHour.backgroundColor = UIColor.black
        dpFromHour.setValue(UIColor.white, forKeyPath: "textColor")
        dpFromHour.datePickerMode = UIDatePicker.Mode.time
        dpFromHour.setValue(false, forKey: "highlightsToday")
        dpFromHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        dpToHour.backgroundColor = UIColor.black
        dpToHour.setValue(UIColor.white, forKeyPath: "textColor")
        dpToHour.datePickerMode = UIDatePicker.Mode.time
        dpToHour.setValue(false, forKey: "highlightsToday")
        dpToHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
    }
    
    // MARK: - DatePicker
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {


            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "HH:mm"
        
        delegate.editTextInCell(2, text: "\(dateFormatter.string(from: dpFromHour.date))-\(dateFormatter.string(from: dpToHour.date))" as AnyObject)
            
            // דליגייט שעורך את הלייבל בסקשן הנוכחי עבור כל דייט פיקר
        
    }
    


}
