//
//  WelcomeBusinessPopUP.swift
//  BThere
//
//  Created by Ioan Ungureanu on 29/10/18.
//  Copyright © 2018 Bthere. All rights reserved.
//

import Foundation
import UIKit

class  WelcomeBusinessPopUP:UIViewController {
    @IBOutlet weak var TitleScreen:UILabel!
    @IBOutlet weak var LineText1:UILabel!
    @IBOutlet weak var LineText2:UILabel!
    @IBOutlet weak var LineText3:UILabel!
    @IBOutlet weak var LineText4:UILabel!
    @IBOutlet weak var CloseXButton:UIButton!
    @IBOutlet weak var adjustMyCalendarBtn: UIButton!
    
    @IBAction func CloseXButton(_ sender: AnyObject) {
    self.dismiss(animated: false, completion: nil)
    }

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleScreen.text = "WELCOMEPOPUPTITLESSCREEN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText1.text = "WELCOMEPOPUPLINE1TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText2.text = "WELCOMEPOPUPLINE4TEXTBOLD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        adjustMyCalendarBtn.setTitle("ADJUST_CALENDAR_BUTTON_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
        let USERDEFAULT = UserDefaults.standard
        USERDEFAULT.set(1, forKey:"firstpopup_welcomeBusinessalreadyseen")
        USERDEFAULT.synchronize()
        
    }
    
    @IBAction func goAdjustYourCalendar(_ sender: UIButton)
        
    {
        let myViewController = AdjustYourCalendarViewController(nibName: "AdjustYourCalendarViewController", bundle: nil)
        myViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        myViewController.isFromCustomersMenu = false
        self.present(myViewController, animated: true, completion:
            {
                self.dismiss(animated: true, completion: nil)
            })
    }
    
    
    
}
