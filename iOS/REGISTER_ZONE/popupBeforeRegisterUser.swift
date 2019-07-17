//
//  popupBeforeRegisterUser.swift
//  BThere
//
//  Created by Ioan Ungureanu on 09/11/17 dmy.
//  Copyright © 2017 Bthere-Tech. All rights reserved.
//

import Foundation
import UIKit

class popupBeforeRegisterUser: UIViewController {
    
    @IBOutlet weak var popUPPASSWORD:UIView!
    @IBOutlet weak var titlepopUPPASSWORD:UILabel!
 //   @IBOutlet weak var EXPLAIN_BEFORE_REGISTER:UITextView!
    @IBOutlet weak var btnCloseX: UIButton!
    @IBOutlet weak var labelWelcomeText:TTTAttributedLabel!
    @IBAction func btnCloseX(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        titlepopUPPASSWORD.text = "WELCOME_TO_BTHERE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        labelWelcomeText.text = "EXPLAIN_BEFORE_REGISTER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        labelWelcomeText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        titlepopUPPASSWORD.isHidden = true
//          if (Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0) {
//            self.EXPLAIN_BEFORE_REGISTER.textAlignment = .Right
//          } else {
//            self.EXPLAIN_BEFORE_REGISTER.textAlignment = .Left
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
//RTF NOT NEEDED FOR THIS LABEL ...
// Set terms of use text
//        if (Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0) {
//            // Hebrew
//            if   let rtf = NSBundle.mainBundle().URLForResource("Permisisions_HE", withExtension: "rtf", subdirectory: nil, localization: nil) {
//
//                do {
//                    let attributedString: NSAttributedString =  try NSAttributedString(URL: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
//                    self.EXPLAIN_BEFORE_REGISTER.attributedText  = attributedString
//                    self.EXPLAIN_BEFORE_REGISTER.textAlignment = .Right
//                } catch let error {
//                    print("Got an error \(error)")
//                }
//            }
//        } else {
//            // Other
//            if   let rtf = NSBundle.mainBundle().URLForResource("Permisisions_EN", withExtension: "rtf", subdirectory: nil, localization: nil) {
//
//                do {
//                    let attributedString: NSAttributedString =  try NSAttributedString(URL: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
//                    self.EXPLAIN_BEFORE_REGISTER.attributedText  = attributedString
//                    self.EXPLAIN_BEFORE_REGISTER.textAlignment = .Left
//                } catch let error {
//                    print("Got an error \(error)")
//                }
//            }
//        }
