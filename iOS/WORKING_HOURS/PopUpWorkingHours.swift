//
//  PopUpWorkingHours.swift
//  Bthere
//
//  Created by BThere on 8/27/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class PopUpWorkingHours: UIViewController {
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

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
        override func viewDidLayoutSubviews() {
            popUPPASSWORD.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
            titlepopUPPASSWORD.text = "POP_UP_WORKING_HOURS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            titlepopUPPASSWORD.font = UIFont (name: "OpenSansHebrew-Bold", size: 26)
//            titlepopUPPASSWORD.sizeToFit()
          if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0)
          {
            if   let rtf = Bundle.main.url(forResource: "Working_hours_PopUp_HE", withExtension: "rtf", subdirectory: nil, localization: nil) {
                do {
                    
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    labelWelcomeText.attributedText  = attributedString
                }
                catch let error
                {
                    print("Got an error \(error)")
                }
            }
            
        }
            else
          {
            
            if   let rtf = Bundle.main.url(forResource: "Working_Hours_PopUp_EN", withExtension: "rtf", subdirectory: nil, localization: nil) {
                do {
                    
                    let attributedString: NSMutableAttributedString =  try NSMutableAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    labelWelcomeText.attributedText  = attributedString
//                    labelWelcomeText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top

                }
                catch let error
                {
                    print("Got an error \(error)")
                }
            }
            
         }
            
//            labelWelcomeText.text = "POP_UP_BODY_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//            labelWelcomeText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
            
//            view.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
        }
    

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}
