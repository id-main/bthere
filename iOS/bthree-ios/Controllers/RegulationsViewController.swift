//
//  RegulationsViewController.swift
//  bthree-ios
//
//  Created by User on 8.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class RegulationsViewController: UIViewController {
    // Outlets
    @IBOutlet weak var lblRegulationTitle: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet var termsTextView: UITextView!
    @IBOutlet var wrapView: UIView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    
    // Variables
    var delegate:didReadRegulationDelegte!=nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblRegulationTitle.text =  "TERMS_OF_USE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnCancel.setTitle("CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnOk.setTitle("OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        self.wrapView.addBackground()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            topConstraint.constant = 109
        } else {
            topConstraint.constant = 64
        }
        
        // Set terms of use text
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            if   let rtf = Bundle.main.url(forResource: "Terms_HE", withExtension: "rtf", subdirectory: nil, localization: nil) {
                
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    self.termsTextView.attributedText  = attributedString
                    self.termsTextView.textAlignment = .right
                } catch let error {
                    print("Got an error \(error)")
                }
            }
        } else {
            // Other
            if   let rtf = Bundle.main.url(forResource: "Terms_EN", withExtension: "rtf", subdirectory: nil, localization: nil) {
                
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    self.termsTextView.attributedText  = attributedString
                    self.termsTextView.textAlignment = .left
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
    
    
    @IBAction func btnOk(_ sender: AnyObject) {
        Global.sharedInstance.fReadRegulation = true
        self.delegate.didReadRegulation()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: AnyObject) {
        Global.sharedInstance.fReadRegulation = false
        delegate.didReadRegulation()
        self.dismiss(animated: false, completion: nil)
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
