//
//  WorkerInListTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/6/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol editWorkerDelegate{
    func reloadTableForEdit(_ tag:Int,my:WorkerInListTableViewCell)
}
class WorkerInListTableViewCell: UITableViewCell {
    var delegate:editWorkerDelegate! = nil
    @IBOutlet var lblWorkerName: UILabel!
    var isOpen:Bool = false
    var isOpenHours:Bool = false
    var row:Int = 0
    var isEdit:Int = 0
    @IBOutlet weak var btnCoverEdit: UIButton!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet var btnCCEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    var isOpenHoursForCell:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }
    
    func setDisplayData(_ st:String){
         imgEdit.alpha = 1
        btnCCEdit.isHidden = false
        btnCCEdit.isUserInteractionEnabled = true
        lblWorkerName.text = st
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
            btnCCEdit.isHidden = true
            btnCCEdit.isUserInteractionEnabled = false
            imgEdit.alpha = 0.45
            btnDelete.isHidden = true
            btnDelete.isUserInteractionEnabled = false
            imgDelete.alpha = 0.45
            self.isUserInteractionEnabled = false
            lblWorkerName.alpha = 0.45
        }
        
    }
    
    @IBAction func btnEditWorker(_ sender: UIButton) {
        self.isEdit = 1
        delegate.reloadTableForEdit(self.tag,my: self)
    }
    
    @IBAction func btntry(_ sender: UIButton) {
        self.isEdit = 1
        delegate.reloadTableForEdit(self.tag,my: self)
    }
    @IBAction func btnDeleteWorker(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message:
           "DELETE_WORKER".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
            let edit = self.isEdit
            self.isEdit = 0
            Global.sharedInstance.generalDetails.arrObjServiceProviders.remove(at: self.tag)
            if Global.sharedInstance.generalDetails.arrObjServiceProviders.count == 0{
                Global.sharedInstance.isFromSave = false
                Global.sharedInstance.isOpenNewWorker = false
                //----
                Global.sharedInstance.isOpenWorker = false
                //----
                Global.sharedInstance.isOpenHoursForPlus = false
                Global.sharedInstance.isOpenHoursForPlusAction = false
                Global.sharedInstance.isSetDataNull = true
                Global.sharedInstance.isOpenHours = false
                self.delegate.reloadTableForEdit(self.tag,my: self)
            }
            else
            {
                self.isEdit = 2
                self.delegate.reloadTableForEdit(self.tag,my: self)
            }
            
            if edit == 1
            {
                Global.sharedInstance.selectedCell[2] = false
                Global.sharedInstance.currentEditCellOpen = -1
            }
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        // alert.setValue(attributedString, forKey: "attributedMessage")
        //J TEST FROM SETTINGS Global.sharedInstance.GlobalDataForDelegate?.presentViewController(alert, animated: true, completion: nil)
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 0 {
        Global.sharedInstance.globalData.present(alert, animated: true, completion: nil)
        } else {
          Global.sharedInstance.GlobalDataVC!.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
      
        
    }
}
