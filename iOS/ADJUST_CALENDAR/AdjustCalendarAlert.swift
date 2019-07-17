//
//  AdjustCalendarAlert.swift
//  Bthere
//
//  Created by Iustin Bthere on 1/10/19.
//  Copyright © 2019 Webit. All rights reserved.
//

import UIKit

class AdjustCalendarAlert: UIViewController {
    var tagPopUp:Int = -1
    // -1 default, 0 failed newOrder, 1 finished with success newOrder
    @IBOutlet weak var alertText: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = confirmBtn.titleLabel?.text
        {
                   confirmBtn.titleLabel!.text = "CONFIRM".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }

        
        if tagPopUp == 1
        {
                    alertText.text = "ADJUST_CALENDAR_ALERT_TITLE_GOOD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            
        }
        else if tagPopUp == 0
        {
                    alertText.text = "ADJUST_CALENDAR_ALERT_TITLE_BAD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }


        let rectShape = CAShapeLayer()
        rectShape.bounds = popUpView.frame
        rectShape.position = popUpView.center
        rectShape.path = UIBezierPath(roundedRect: popUpView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
        popUpView.layer.backgroundColor = UIColor.green.cgColor
        //Here I'm masking the textView's layer with rectShape layer
        popUpView.layer.mask = rectShape
        
    }


    @IBAction func confirmAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
