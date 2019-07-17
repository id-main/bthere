//
//  ServiceInListTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/7/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol editServiceDelegate{
    func reloadTableForEditService(_ tag:Int,my:ServiceInListTableViewCell)
}

class ServiceInListTableViewCell: UITableViewCell {
    var delegate:editServiceDelegate! = nil
    var isOpen:Bool = false
    var isEdit:Int = 0
    @IBOutlet var lblDescService: UILabel!
    
    @IBOutlet weak var viewEditClicked: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let border = CALayer()
        
       // let language = NSBundle.mainBundle().preferredLocalizations.first! as NSString
            
     //   if language == "he"
             if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            border.frame = CGRect(x: btnEditService.layer.frame.width + 16 , y: 0, width: 1, height: btnEditService.layer.frame.height + 16)
        }
        else
        {
            border.frame = CGRect(x: 0, y: 0, width: 1, height: btnEditService.layer.frame.height + 16)
        }
        border.backgroundColor = UIColor.white.cgColor
        
       // btnEditService.layer.addSublayer(border)

    }

    @IBAction func btnEditService(_ sender: UIButton) {
        
            self.isEdit = 1
            delegate?.reloadTableForEditService(self.tag,my: self)
        

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
    
    func setDispalyData(_ str:String){
        lblDescService.text = str
        
    }
    

    @IBAction func btnDeleteService(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message:
            "DELETE_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
        self.isEdit = 0
            //Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission
            if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
              
                 let SERVICETODELETE:objProviderServices = Global.sharedInstance.generalDetails.arrObjProviderServices[self.tag]
                  print("Global.sharedInstance.generalDetails.arrObjProviderServices \(Global.sharedInstance.generalDetails.arrObjProviderServices[self.tag])")
                  print("SERVICETODELETE \(SERVICETODELETE.getDic())")
                if SERVICETODELETE.iProviderServiceId > 0 {
                    if !Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission.contains(SERVICETODELETE.iProviderServiceId ) {
                        Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission.add(SERVICETODELETE.iProviderServiceId)
                    }
                }
                print(" Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission \( Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission)")
            }
        Global.sharedInstance.generalDetails.arrObjProviderServices.remove(at: self.tag)
        if  Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0{
            Global.sharedInstance.isFromFirstSave = false
            
            self.delegate.reloadTableForEditService(self.tag,my: self)
        }
        else{
            self.isEdit = 2
           self.delegate.reloadTableForEditService(self.tag,my: self) 
        }
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
            
        }))
         if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 0
        {
        Global.sharedInstance.globalData.present(alert, animated: true, completion: nil)
        } else {
           Global.sharedInstance.GlobalDataVC!.present(alert, animated: true, completion: nil)
        }
    }

}
