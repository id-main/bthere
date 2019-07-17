//
//  DescTableViewCell.swift
//  bthree-ios
//
//  Created by User on 31.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
// הסל של הטבלה הפנימית של התראות
class DescTableViewCell: UITableViewCell {
    
    var sectionKindCell:Int = 0
    var rowKindCell:Int = 0
    var rowCell:Int = 0
    
    var delgateReloadTextSelected:KindNotificationsTableViewCell!=nil
    //לחיצה על בחירה(וי או איקס)
    @IBAction func btnSelect(_ sender: CheckBoxForDetailsWorker2)
    {
        Global.sharedInstance.isOpen = false
        
        if sectionKindCell == 0//עדכוני פגישה
        {
            if Global.sharedInstance.headersForTblInCell[rowCell] != Global.sharedInstance.headersForTblInCell[0]
            {
                if sender.isCecked == true
                {
                    Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][rowCell] = 0//לא בחור
                    Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[rowCell] = -1
                    Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][0] = 0//ביטול הסימון הכל
                    
                    if !Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell].contains(1)//הכל איקס
                    {
                        for i in 0 ..< Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell].count
                        {
                        Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][i] = 1//שמירת הערך הדיפולטיבי
                        }
                    }
                }
                else
                {
                    Global.sharedInstance.lastChooseIndex = rowCell
                    Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][rowCell] = 1//בחור
                    Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[rowCell] = SysTableRowId(8, str: lblDesc.text!)
                    Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[0] = -1
                    Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][0] = 0
                }
            }
            else//הכל
            {
                if sender.isCecked == true
                {
                    Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][rowCell] = 0//לא בחור
                    
                    Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[rowCell] = -1
                    
                    if !Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell].contains(1)//הכל איקס
                    {
                        for i in 0 ..< Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell].count
                        {
                            Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][i] = 1//שמירת הערך הדיפולטיבי
                        }
                    }
                }
                else
                {
                    Global.sharedInstance.lastChooseIndex = rowCell
                    
                    Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][rowCell] = 1//בחור
                    Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[rowCell] = SysTableRowId(8, str: lblDesc.text!)
                    
                    for i in 0 ..< Global.sharedInstance.headersForTblInCell.count
                    {
                        Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[i] = SysTableRowId(8, str: Global.sharedInstance.headersForTblInCell[i])
                        Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][i] = 1
                    }
                }
            }
            
        }
        else if sectionKindCell == 3//ארועים של לקוחות
        {
            if sender.isCecked == true
            {
                Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId[rowCell] = -1
                Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][rowCell] = 0//לא בחור
                if !Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell].contains(1)//הכל איקס
                {
                    Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][0] = 1//שמירת הערך הדיפולטיבי
                }
            }
            else
            {
                Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][rowCell] = 1//בחור
                Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId[rowCell] = SysTableRowId(10, str: lblDesc.text!)
            }
        }
            
        else if sectionKindCell == 2//מעקב אחר לקוחות
        {
            if sender.isCecked == true
            {
                Global.sharedInstance.addProviderAlertSettings.iCustomerResvId[rowCell] = -1
                Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][rowCell] = 0//לא בחור
//                if !Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell].contains(1)//הכל איקס
//                {
//                    Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][1] = 1//שמירת הערך הדיפולטיבי
//                }
            }
            else
            {
                Global.sharedInstance.flagsHeadersForTblInCell[sectionKindCell]![rowKindCell][rowCell] = 1//בחור
                Global.sharedInstance.addProviderAlertSettings.iCustomerResvId[rowCell] = SysTableRowId(9, str: lblDesc.text!)
            }
        }
        
    }
    
    @IBOutlet weak var btnSelect: CheckBoxForDetailsWorker2!
    @IBOutlet weak var lblDesc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        btnSelect.isCecked = true
//        btnSelect.setImage(UIImage(named: "ok (1).png"), forState:.Normal)
    }
    
    func setDisplayData(_ str:String){
        lblDesc.text = str
        
    }

    //מחזיר את הקוד לשורה מסויימת מהטבלה שנבחרה-בשביל השליחה לשרת
    //מקבלת את קוד הטבלה אליה לגשת ואת הסטרינג שנבחר
    func SysTableRowId(_ iTableRowId:Int,str:String)->Int
    {
        for sys in Global.sharedInstance.dicSysAlerts[iTableRowId.description]!
        {
            if sys.iTableId == iTableRowId && sys.nvAletName == str
            {
                return sys.iSysTableRowId
            }
        }
        return 0
    }
    
}
