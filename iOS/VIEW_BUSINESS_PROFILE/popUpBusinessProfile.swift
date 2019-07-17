//
//  popUpBusinessProfile.swift
//  Bthere
//
//  Created by BThere on 8/23/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class popUpBusinessProfile: UIViewController {
    
    @IBOutlet weak var popUPPASSWORD:UIView!
    @IBOutlet weak var titlepopUPPASSWORD:UILabel!
    @IBOutlet weak var btnCloseX: UIButton!
    @IBOutlet weak var labelWelcomeText:TTTAttributedLabel!
    @IBAction func btnCloseX(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        popUPPASSWORD.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
        titlepopUPPASSWORD.text = "POP_UP_BUSINESS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        labelWelcomeText.text = "POP_UP_BODY_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        labelWelcomeText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
    }
}
