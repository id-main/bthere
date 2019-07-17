//
//  RecessesTableViewCell.swift
//  Bthere
//
//  Created by User on 11.7.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//סל של הוסף הפסקות, קיים בשעות פעילות וכן בהוספת עובדים בבחירת שעות לעובד  - בדף נתונים כלליים
class RecessesTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    var delegateReloadTbl:reloadTblDelegate!=nil
    var delgateEnabledDays:enabledBtnDaysDelegate!=nil
    var delegateSetPicker:datePickerDelegate!=nil
    
    //MARK: - Outlet
    
    @IBOutlet weak var lblAddReccess: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewAddRecess: UIView!
    
    
    //MARK: - Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblAddReccess.text = "ADD_RECCESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        let tapAddRecess:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addReccess))
        viewAddRecess.addGestureRecognizer(tapAddRecess)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - tap function
    
    //בלחיצה על הוסף הפסקות
    @objc func addReccess()
    {
        if Global.sharedInstance.hoursForWorker == true//יש שעות פעילות לעובד כשמוסיפים עובד ראשון בפעם הראשונה
        {
            Global.sharedInstance.recessForWorker = true
            Global.sharedInstance.hoursForWorker = false
        }
        if Global.sharedInstance.hoursForWorkerFromPlus == true
        {
            Global.sharedInstance.hoursForWorkerFromPlus = false
            Global.sharedInstance.recessForWorkerFromPlus = true
        }
        if Global.sharedInstance.hoursForWorkerFromEdit == true
        {
            Global.sharedInstance.hoursForWorkerFromEdit = false
            Global.sharedInstance.recessForWorkerFromEdit = true
        }
        
        delegateReloadTbl.reloadTbl()
        
        Global.sharedInstance.addRecess = true
        
        Global.sharedInstance.onOpenRecessHours = true
        delgateEnabledDays.enabledBtnDays()
        if delegateSetPicker != nil
        {
          //  delegateSetPicker.setDatePickerNull()
        }
    }
}
