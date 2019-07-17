//
//  AdjustCalendarExitPopUp.swift
//  Bthere
//
//  Created by Iustin Bthere on 1/22/19.
//  Copyright © 2019 Webit. All rights reserved.
//

import UIKit

class AdjustCalendarExitPopUp: UIView {

    @IBOutlet weak var popUpTitle: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        confirmBtn.setTitle("CONFIRM_ADJUST".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
                    popUpTitle.text = "ADJUST_CALENDAR_ALERT_TITLE_GOOD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }
    
    override func layoutSubviews()
    {
        self.popUpView.layer.cornerRadius = 15
        self.popUpView.layer.masksToBounds = true
    }
    @IBAction func confirmAction(_ sender: UIButton)
    {
        self.parentViewController?.dismiss(animated: true, completion: nil)
    }
}

