//
//  SettingsJoAddNewEmployeeTableViewCell.swift
//  bthree-ios
//
//  Created byIoan Ungureanu on 18/03/2019
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit


protocol popUpOpenNewEmployee
{
    func openNewEmployeeFunc()
}

class SettingsJoAddNewEmployeeTableViewCell: UITableViewCell,popUpOpenNewEmployee {
    
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    
    @IBOutlet weak var lblAddEmployee: UILabel!
    var isClosed:Bool = true
    var delegate:isOpenRowDelegate5!=nil
    override func awakeFromNib() {
        super.awakeFromNib()
        lblAddEmployee.text = "ADD_EMPLOYEE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }
    @IBAction func newEmployee(_ sender: UIButton) {
//        delegate.showPopupBeforeAddNewEmploye()
        
        presentAccesCodePopup(WHICHSCREEN: 1)
    }
    override func layoutSubviews() {
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
        lineView.backgroundColor = UIColor.white
        self.contentView.addSubview(lineView)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setState(_isClosed: Bool) {
        self.isClosed = _isClosed
    }
   
    
    func closemenu()
    {
        if self.parentViewController?.revealViewController()?.frontViewPosition == FrontViewPosition.right
        {
            self.parentViewController?.revealViewController()?.revealToggle(animated: true)
        }
        
    }
    
    func presentAccesCodePopup(WHICHSCREEN:Int) {
        closemenu()
        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
        let  viewpopupAccessCode:popupAccessCode = storyboardtest.instantiateViewController(withIdentifier: "popupAccessCode") as! popupAccessCode
        //        viewpopupAccessCode.delegate = self
        if self.iOS8 {
            viewpopupAccessCode.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewpopupAccessCode.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        if WHICHSCREEN == 1 {   //set employee
            viewpopupAccessCode.WHICHSCREEN = 1
            viewpopupAccessCode.delegateFromServiceCell = self
            self.parentViewController?.present(viewpopupAccessCode, animated: true, completion: nil)
        }
        if WHICHSCREEN == 2 {   //set calendar
            viewpopupAccessCode.WHICHSCREEN = 2
            self.parentViewController?.present(viewpopupAccessCode, animated: true, completion: nil)
        }
        
        
    }
    
    func openNewEmployeeFunc()
    {
        delegate.showPopupBeforeAddNewEmploye()
    }

}
