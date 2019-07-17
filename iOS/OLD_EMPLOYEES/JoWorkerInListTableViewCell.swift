//
//  JoWorkerInListTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 06/03/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit

class JoWorkerInListTableViewCell: UITableViewCell {
    var DELEGATERELOAD:reloadTblDelegateParent!=nil
    var INDEXPATHFROMARRAYOTEDIT:Int = 0
    @IBOutlet var lblWorkerName: UILabel!
    @IBOutlet weak var btnCoverEdit: UIButton!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet var btnCCEdit: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }
    
    func setDisplayData(_ st:String){
        imgEdit.alpha = 1
        btnCCEdit.isHidden = false
        btnCCEdit.isUserInteractionEnabled = true
        lblWorkerName.text = st
    }
    
    @IBAction func btnEditWorker(_ sender: UIButton) {
      //open worker detail screen is a better solution to avoid crash in main table
        //JoEditWorkerViewController
        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
        let viewpop:JoEditWorkerViewController = storyboardtest.instantiateViewController(withIdentifier: "JoEditWorkerViewController") as! JoEditWorkerViewController
        viewpop.DELEGATERELOAD = self.DELEGATERELOAD
        viewpop.modalPresentationStyle = UIModalPresentationStyle.custom
        viewpop.INDEXPATHFROMARRAYOTEDIT = self.tag - 1
        if let myViewController = parentViewController! as? UIViewController {
            print(myViewController.title)
            myViewController.present(viewpop, animated: true, completion: nil)
        }

        
    }
    @IBAction func btnDeleteWorker(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message:
           "DELETE_WORKER".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
            Global.sharedInstance.generalDetails.arrObjServiceProviders.remove(at: self.tag - 1) //keep in mind 0 is headercell in main table
            Global.sharedInstance.arrObjServiceProvidersForEdit.remove(at: self.tag - 1) //here also from array to edit
            // parent reload table
            self.DELEGATERELOAD.reloadTbl()
            }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
        }))
        //parent
        self.DELEGATERELOAD.presentVC(alert)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func layoutSubviews() {
    }
}
