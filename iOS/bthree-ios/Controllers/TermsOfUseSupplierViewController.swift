//
//  TermsOfUseSupplierViewController.swift
//  BThere
//
//  Created by Eduard Stefanescu on 11/22/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit
//תקנון ותנאי השימוש
class TermsOfUseSupplierViewController: NavigationModelViewController {
    
    //MARK: - Outlet
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnClose: UIButton!
    
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "TERMS_OF_USE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        txtView.text = "REGULATION_VIEW".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        // Set terms of use text
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            if   let rtf = Bundle.main.url(forResource: "Terms_HE", withExtension: "rtf", subdirectory: nil, localization: nil) {
                
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    self.txtView.attributedText  = attributedString
                    self.txtView.textAlignment = .right
                } catch let error {
                    print("Got an error \(error)")
                }
            }
        } else {
            // Other
            if   let rtf = Bundle.main.url(forResource: "Terms_EN", withExtension: "rtf", subdirectory: nil, localization: nil) {
                
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    self.txtView.attributedText  = attributedString
                    self.txtView.textAlignment = .left
                } catch let error {
                    print("Got an error \(error)")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
