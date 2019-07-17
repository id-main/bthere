//
//  notificationForDefinationsTableViewCell.swift
//  Bthere
//
//  Created by User on 8.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class notificationForDefinationsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnUnSelect: CheckBoxForExistSupplierCancel!
    @IBOutlet weak var btnSelect: CheckBoxForExistSupplierOk!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var desc: UILabel!
    
    //x
    @IBAction func btnUnSelect(_ sender: CheckBoxForExistSupplierCancel) {
        saveItem(self.tag, selected: false)
        if(btnSelect.isCecked == true)
        {
            btnSelect.isCecked = false
            btnUnSelect.isCecked = true
        }
        else
        {
            btnSelect.isCecked = true
            btnUnSelect.isCecked = false
        }
    }
    //√
    @IBAction func btnSelect(_ sender: CheckBoxForExistSupplierOk) {
        saveItem(self.tag, selected: true)
        if(btnUnSelect.isCecked == true)
        {
            btnUnSelect.isCecked = false
            btnSelect.isCecked = true
        }
        else
        {
            btnUnSelect.isCecked = true
            btnSelect.isCecked = false
        }
    }
    
    
    //MARK: - Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ st:String,select:Bool)  {
        btnSelect.isCecked = select
        if select == false
        {
            btnUnSelect.isCecked = true
        }
        else
        {
            btnUnSelect.isCecked = false
        }
        desc.text = st
    }

    
    //מקבלת אינדקס של השורה בטבלה ואת מה שסומן ושומרת באוביקט את מה שנבחר
    func saveItem(_ indexPath:Int,selected:Bool)
    {
        switch indexPath {
        case 0:
             Global.sharedInstance.customerAlertsSettingsObj.b90thAlertTime = selected
            
        case 1:
             Global.sharedInstance.customerAlertsSettingsObj.b20minutesBeforeService = selected
            
        case 2:
             Global.sharedInstance.customerAlertsSettingsObj.bPermissionsFromBusinesses = selected
            
        case 3:
             Global.sharedInstance.customerAlertsSettingsObj.bOrderInWaiting = selected
            
        case 4:
             Global.sharedInstance.customerAlertsSettingsObj.bUpdatesAndNews = selected
        case 5:
            Global.sharedInstance.customerAlertsSettingsObj.b4hoursBeforeService = selected
        default:
            Global.sharedInstance.customerAlertsSettingsObj.b90thAlertTime = true
        }
    }
}
