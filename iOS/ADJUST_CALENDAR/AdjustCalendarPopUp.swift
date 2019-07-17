//
//  AdjustCalendarPopUp.swift
//  Bthere
//
//  Created by Iustin Bthere on 1/9/19.
//  Copyright © 2019 Webit. All rights reserved.
//

import UIKit

class AdjustCalendarPopUp: UIView
{
    @IBOutlet weak var popUpTitle: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
         AppDelegate.shouldDismissVC = false
        
        confirmBtn.setTitle("CONFIRM_ADJUST".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
        
        // 0 is bad and dismiss, 1 is good and dismiss, 2 is bad and reset, 3 is good and reset

        if AppDelegate.tagPopUp == 0
        {
            popUpTitle.text = "SUCCESS_ADJUST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        else if AppDelegate.tagPopUp == 1
        {
            popUpTitle.text = "ADJUST_CALENDAR_ALERT_TITLE_GOOD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        else if AppDelegate.tagPopUp == 2 || AppDelegate.tagPopUp == 3
        {
            popUpTitle.text = "ADJUST_CALENDAR_ALERT_TITLE_BAD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }



        


        
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = popUpView.frame
//        rectShape.position = popUpView.center
//        rectShape.path = UIBezierPath(roundedRect: popUpView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath
        
        //Here I'm masking the textView's layer with rectShape layer
//        popUpView.layer.mask = rectShape
    }

    override func layoutSubviews()
    {
        self.popUpView.layer.cornerRadius = 15
        self.popUpView.layer.masksToBounds = true
    }

    
    @IBAction func confirmAction(_ sender: Any)
    {
        if AppDelegate.tagPopUp == 1 || AppDelegate.tagPopUp == 3
        {
            AppDelegate.shouldDismissVC = true
        }
        else if AppDelegate.tagPopUp == 2
        {
            AppDelegate.shouldDismissVC = false
        }
        
        self.removeFromSuperview()

        
    }
}
