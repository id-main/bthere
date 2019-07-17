// SettingsCalendarInListCell.swift

import UIKit

class SettingsCalendarInListCell: UITableViewCell {
    var isEdit:Bool = false
    var delegate:isOpenRowDelegate7!=nil
    var EMPLOYEE:objEMPLOYEE = objEMPLOYEE()
    @IBOutlet var lblDescEmployee: UILabel!
    @IBOutlet weak var viewEditClicked: UIView!
    @IBOutlet weak var btnEditEmployee: UIButton!
    @IBOutlet weak var btnDeleteEmployee: UIButton!
    @IBOutlet weak var imageDeleteEmployee:UIImageView!
    @IBAction func btnEditEmployee(_ sender: UIButton) {
        delegate.editRow(_WHICHCELL: self.tag, _WHICHSTATE: false)
    }
    override func layoutSubviews() {
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
        lineView.backgroundColor = UIColor.white
        self.contentView.addSubview(lineView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func completeEmployeeData(_EMPLOYEE : objEMPLOYEE) {
        self.EMPLOYEE = _EMPLOYEE
        let myEmployee = self.EMPLOYEE.objsers
        let myEmployee_firstname = myEmployee.nvFirstName
        let myEmployee_lastname = myEmployee.nvLastName
        let composed_name = myEmployee_firstname + " " + myEmployee_lastname
        lblDescEmployee.text = composed_name
    }
   
    func setEditState(_isEditOpen: Bool) {
       self.isEdit = _isEditOpen
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let border = CALayer()
        if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            border.frame = CGRect(x: btnEditEmployee.layer.frame.width + 16 , y: 0, width: 1, height: btnEditEmployee.layer.frame.height + 16)
        }
        else
        {
            border.frame = CGRect(x: 0, y: 0, width: 1, height: btnEditEmployee.layer.frame.height + 16)
        }
        border.backgroundColor = UIColor.white.cgColor
    }

    @IBAction func btnDeleteEmployee(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message:
            "ARE_YOU_SURE_YOU_WANT_TO_DELETE_THE_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
           let ax = Global.sharedInstance.ARRAYCALENDAR[self.tag].objsers.iUserId
           self.delegate.deleteEmployeaddtoArray(_whichID: ax)
           Global.sharedInstance.ARRAYCALENDAR.remove(at: self.tag)

            self.delegate.reloadTableFull()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
        }))
        if let topController = UIApplication.topViewController() {
            topController.present(alert, animated: true, completion: nil)
        }

    }

}
