//
//  noPictureRegistrationPopUpView.swift
//  Bthere
//
//  Created by Iustin Bthere on 3/8/19.
//  Copyright © 2019 Webit. All rights reserved.
//

import UIKit

class noPictureRegistrationPopUpView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leadingBody: NSLayoutConstraint!
    @IBOutlet weak var trailingBody: NSLayoutConstraint!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var okbtn: UIButton!
    
//    NO_PICTURE_REGISTRATION_BODY
//    OK_THX_BTN
    override func awakeFromNib()
    {
        titleLabel.text = "NO_PICTURE_REGISTRATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        bodyLabel.text = "NO_PICTURE_REGISTRATION_BODY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        okbtn.setTitle("OK_THX_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
        if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            titleLabel.numberOfLines = 2
            bodyLabel.numberOfLines = 3
            leadingBody.constant = 25
            trailingBody.constant = 25
        }
        else
        {
            titleLabel.numberOfLines = 0
            bodyLabel.numberOfLines = 0
            leadingBody.constant = 5
            trailingBody.constant = 5
        }
        
        
    }
    
    @IBAction func okBtn(_ sender: Any)
    {
        self.removeFromSuperview()
    }
    
}
