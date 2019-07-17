//
//  MainTableViewCell.swift
//  bthree-ios
//
//  Created by User on 23.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var btnOpenCell: UIButton!
    
    @IBOutlet weak var txtHolder: UITextField!
    
    @IBOutlet weak var lblGwiazdka: UILabel!//כוכבית
    @IBOutlet weak var lblMessageError: UILabel!
    @IBOutlet var txtSub: UITextField!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var viewtop: UIView!
    
    var delegateKb:delKbNotificationDelegate!=nil
    var delegateKbBusiness:delKbNotifBusinessDelegate!=nil
    var delegateKbCalendar:delKbCalenderNotifDelegate!=nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnOpenCell.isEnabled = false
        btnOpenCell.adjustsImageWhenDisabled = false
        
        txtSub.isEnabled = false
        
        txtSub.delegate = self
        txtHolder.delegate = self
        
        txtSub.text = ""
        txtSub.textColor = UIColor.black
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDisplayData(_ str:String,hidden:Bool,imageArrow:String,textArrow:String){
        btnOpenCell.setTitle(textArrow, for: UIControl.State())
        if imageArrow == ""
        {
            //JMODE 29.12.2016
            //btnOpenCell.setBackgroundImage(UIImage(), forState: .Normal)
            btnOpenCell.setImage(UIImage(), for: UIControl.State())
        }
        else
        {
            //jmode 29.12.2016
            //btnOpenCell.setBackgroundImage(UIImage(named: imageArrow), forState: .Normal)
            btnOpenCell.setImage(UIImage(named: imageArrow), for: UIControl.State())
            
        }
        btnOpenCell.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        self.contentView.sendSubviewToBack(btnOpenCell)
        lblDesc.text = str
        lblGwiazdka.isHidden = hidden
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            lblDesc.textAlignment = .right
        }
     //   else {
////            lblDesc.textAlignment = .left
//        }
        if lblDesc.textAlignment == .right
        {
            print("right align")
            print("label value \(String(describing: lblDesc.text))")
        }
        else
        {
            print("left align")
            print("label value \(String(describing: lblDesc.text))")
        }
//        lblDesc.layer.borderColor = UIColor.green.cgColor
//        lblDesc.layer.borderWidth = 3.0;
        
        
    }
    
    //    func setDisplayData(str:String){
    //        lblDesc.text = str
    //    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.delegateKb = Global.sharedInstance.itemInSection3TableViewCell
        self.delegateKbBusiness = Global.sharedInstance.businessService
        
        if delegateKbCalendar != nil
        {
            delegateKbCalendar.delKbCalenderNotif()
        }
        
        if delegateKb != nil
        {
            delegateKb.delKbNotification()
        }
        if delegateKbBusiness != nil
        {
            delegateKbBusiness.delKbNotifBusiness()
        }
        
        if textField == txtSub
        {
            print("txtsub")
        }
        else if textField == txtHolder
        {
            print("holder")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //        Global.sharedInstance.generalDetails.nvSlogen = txtHolder.text!
    }
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        if textField == txtSub
        {
            var startString = ""
            if (textField.text != nil)
            {
                startString += textField.text!
            }
            startString += string
            if startString.characters.count > 120
            {
                return false
            }
            else
            {
                return true
            }
        }
        return true
    }
    
    
    
    
    
    //לא חוקי או שדה חובה
    func setInvalid(_ message:String)
    {
        txtSub.text = message
        txtSub.textColor = UIColor.red
    }
}
