//
//  PopSyncContactViewController.swift
//  Bthere
//
//  Created by BThere on 25/10/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class PopSyncContactViewController: UIViewController {
   
    @IBOutlet weak var popUPPASSWORD:UIView!
    @IBOutlet weak var titlepopUPPASSWORD:UILabel!
    //   @IBOutlet weak var EXPLAIN_BEFORE_REGISTER:UITextView!
    @IBOutlet weak var btnCloseX: UIButton!
    @IBOutlet weak var labelWelcomeText:UILabel!
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
            titlepopUPPASSWORD.text = "INVITE_CUSTOMERS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            labelWelcomeText.text = "INVITE_CUSTOMERS_BODY_TEXT2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//            labelWelcomeText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0)
            {
                let text: NSMutableAttributedString = NSMutableAttributedString(string: labelWelcomeText.text!)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .justified
                paragraphStyle.baseWritingDirection = .rightToLeft
                paragraphStyle.lineBreakMode = .byWordWrapping
                
                text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
                
                labelWelcomeText.attributedText = text
            }
            else if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 1)
            {
                let text: NSMutableAttributedString = NSMutableAttributedString(string: labelWelcomeText.text!)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .justified
                paragraphStyle.baseWritingDirection = .leftToRight
                paragraphStyle.lineBreakMode = .byWordWrapping
                
                text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
                
                labelWelcomeText.attributedText = text
            }
            

            }
}
