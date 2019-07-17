//
//  NewEventRemarkTableViewCell.swift
//  Bthere
//
//  Created by User on 12.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

//קבע אירוע -  הסל של הערות
class NewEventRemarkTableViewCell: UITableViewCell,UITextViewDelegate {

    var delegate:editTextInCellDelegate!=nil
    
    @IBOutlet weak var txtVRemark: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       txtVRemark.font = UIFont (name: "OpenSansHebrew-Light", size: 18)
       txtVRemark.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtVRemark.text == "ENTER_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            txtVRemark.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate.editTextInCell(3, text: txtVRemark.text as AnyObject)
    }
    
    @objc func dismissKeyBoard()
    {
        txtVRemark.resignFirstResponder()
    }
    

}
