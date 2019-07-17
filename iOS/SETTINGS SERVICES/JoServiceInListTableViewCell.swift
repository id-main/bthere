//
//  JoServiceInListTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/7/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit


class JoServiceInListTableViewCell: UITableViewCell {
    var DELEGATERELOAD:reloadTblDelegateParent!=nil
    @IBOutlet var lblDescService: UILabel!
    @IBOutlet weak var viewEditClicked: UIView!
    var SERVICETOEDIT:objProviderServices = objProviderServices()
    var INDEXPATHFROMARRAYOTEDIT:Int = 0
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }

  
    override func layoutSubviews() {
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
        lineView.backgroundColor = UIColor.white
        self.contentView.addSubview(lineView)
    }
    @IBOutlet var btnEditService: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDispalyData(_ str:String, indexRow:Int){
        lblDescService.text = str
        self.SERVICETOEDIT = Global.sharedInstance.generalDetails.arrObjProviderServices[indexRow]
        self.INDEXPATHFROMARRAYOTEDIT = indexRow
    }
    @IBAction func btnEditService(_ sender: UIButton) {
        //open service detail screen is a better solution to avoid crash in main table
        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
        let viewpop:JoEditServiceViewController = storyboardtest.instantiateViewController(withIdentifier: "JoEditServiceViewController") as! JoEditServiceViewController
        viewpop.DELEGATERELOAD = self.DELEGATERELOAD
        viewpop.modalPresentationStyle = UIModalPresentationStyle.custom
        viewpop.INDEXPATHFROMARRAYOTEDIT = self.INDEXPATHFROMARRAYOTEDIT
        viewpop.SERVICETOEDIT = self.SERVICETOEDIT
        if let myViewController = parentViewController! as? UIViewController {
            print(myViewController.title)
            myViewController.present(viewpop, animated: true, completion: nil)
        }

      
    }
    @IBAction func btnDeleteService(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message:
            "DELETE_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
              Global.sharedInstance.generalDetails.arrObjProviderServices.remove(at: self.tag - 1) //keep in mind 0 is headercell in main table
            // parent reload table
            self.DELEGATERELOAD.reloadTbl()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
        }))
        //parent
        self.DELEGATERELOAD.presentVC(alert)
    }

   
}
