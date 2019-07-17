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
        LineText2.text = "WELCOMEPOPUPLINE2TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText3.text = "WELCOMEPOPUPLINE3TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText4.text = "WELCOMEPOPUPLINE4TEXTBOLD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
    }
}
