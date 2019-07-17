//
//  popupSyncContacts.swift
//  BThere
//
//  Created by Ioan Ungureanu on 23/08/18 dmy.
//  Copyright © 2018 Bthere-Tech. All rights reserved.
//

import Foundation
import UIKit

class popupSyncContacts: UIViewController {
    
    @IBOutlet weak var popUPPASSWORD:UIView!
    @IBOutlet weak var titlepopUPPASSWORD:UILabel!
    @IBOutlet weak var btnCloseX: UIButton!
    @IBOutlet weak var labelWelcomeText:TTTAttributedLabel!
    @IBAction func btnCloseX(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        titlepopUPPASSWORD.text = "INVITE_CUSTOMERS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        titlepopUPPASSWORD.textAlignment = .center
        labelWelcomeText.text = "EXPLAIN_SYNC_CONTACTS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        labelWelcomeText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
