//
//  SaveTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/8/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class SaveTableViewCell: UITableViewCell {
   
    var delegateSave:reloadTableForSaveDelegate! = nil
    
    var delegateSaveData:saveDataDelegate!=nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let a = Global.sharedInstance.itemInSection3TableViewCell{
            delegateSaveData = Global.sharedInstance.itemInSection3TableViewCell

        }
        
        btnSave.setTitle("SAVE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
    }
    
    @IBOutlet var btnSave: UIButton!
    @IBAction func btnSave(_ sender: UIButton)
    {
        if delegateSaveData.saveData() == true
        {
           // delegateSaveData.saveData()
            delegateSave.reloadTableForSave(self.tag,btnTag: btnSave.tag)
        }
        else
        {
            if Global.sharedInstance.isAllFlagsFalse == true && Global.sharedInstance.isOpenNewWorker == false
            {
                delegateSave.reloadTableForSave(-100,btnTag: 3)
            }
                //לוחץ על שמור והמשך בכפתור פלוס בלי למלאות כלום
            else if Global.sharedInstance.isAllFlagsFalse == true && Global.sharedInstance.isOpenNewWorker == true {
                 delegateSave.reloadTableForSave(-200,btnTag: -200)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
