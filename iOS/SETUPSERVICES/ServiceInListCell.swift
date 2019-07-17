//  ServiceInListCell.swift

import UIKit

class ServiceInListCell: UITableViewCell {
    var isEdit:Bool = false
    var delegate:isOpenRowDelegate2!=nil
    @IBOutlet var lblDescService: UILabel!
    @IBOutlet weak var viewEditClicked: UIView!
    @IBOutlet var btnEditService: UIButton!
    @IBAction func btnEditService(_ sender: UIButton) {
        if self.isEdit == false {
        delegate.editRow(_WHICHCELL: self.tag, _WHICHSTATE: false)
        } else {
        delegate.closeandclearcell(_WHICHCELL: self.tag)
        }
    }
    override func layoutSubviews() {
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
        lineView.backgroundColor = UIColor.white
        self.contentView.addSubview(lineView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDisplayData(_ str:String){
        lblDescService.text = str
    }
    func setEditState(_isEditOpen: Bool) {
       self.isEdit = _isEditOpen
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let border = CALayer()
        if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            border.frame = CGRect(x: btnEditService.layer.frame.width + 16 , y: 0, width: 1, height: btnEditService.layer.frame.height + 16)
        }
        else
        {
            border.frame = CGRect(x: 0, y: 0, width: 1, height: btnEditService.layer.frame.height + 16)
        }
        border.backgroundColor = UIColor.white.cgColor
    }

    @IBAction func btnDeleteService(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message:
            "DELETE_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
        self.isEdit = false
            if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
                 let SERVICETODELETE:objProviderServices = Global.sharedInstance.generalDetails.arrObjProviderServices[self.tag]
                  print("Global.sharedInstance.generalDetails.arrObjProviderServices \(Global.sharedInstance.generalDetails.arrObjProviderServices[self.tag])")
                  print("SERVICETODELETE \(SERVICETODELETE.getDic())")
            }
            Global.sharedInstance.generalDetails.arrObjProviderServices.remove(at: self.tag)
        if  Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0{
            Global.sharedInstance.isFromFirstSave = false
            self.delegate.reloadTableFull()
        }
        else{
            self.isEdit = false
            self.delegate.closeandclearcell(_WHICHCELL: self.tag)
        }
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
        }))
        if let topController = UIApplication.topViewController() {
            topController.present(alert, animated: true, completion: nil)
        }

    }

}
