//
//  OldPopSyncContactViewController.swift
//  Bthere
//
//  Created by User on 3.7.2016.
//  Copyright © 2016 Webit. All rights reserved.
//
import Foundation
import UIKit
import NVActivityIndicatorView

class OldPopSyncContactViewController: NavigationModelViewController {
    var isfromsettings = false
    // IBOutlets
    @IBOutlet weak var popOutView: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    @IBAction func btnCon(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    enum UIUserInterfaceIdiom : Int {
        case unspecified
        case phone // iPhone and iPod touch style UI
        case pad // iPad style UI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnContinue.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControlState())
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            if isfromsettings == false {
            // Hebrew
            if   let rtf = Bundle.main.url(forResource: "Sync_Contacts_HE", withExtension: "rtf", subdirectory: nil, localization: nil) {
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
                    self.myTextView.attributedText  = attributedString
                    self.myTextView.textAlignment = .center
                } catch let error {
                    print("Got an error \(error)")
                }
            }
            } else {
                if   let rtf = Bundle.main.url(forResource: "Sync_Contacts_HE_SUPPLIER", withExtension: "rtf", subdirectory: nil, localization: nil) {
                    do {
                        let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
                        self.myTextView.attributedText  = attributedString
                        self.myTextView.textAlignment = .center
                    } catch let error {
                        print("Got an error \(error)")
                    }
                }
            }
        } else {
            // Other
             if isfromsettings == false {
            if   let rtf = Bundle.main.url(forResource: "Sync_Contacts_EN", withExtension: "rtf", subdirectory: nil, localization: nil) {
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
                    self.myTextView.attributedText  = attributedString
                    self.myTextView.textAlignment = .center
                } catch let error {
                    print("Got an error \(error)")
                }
            }
             } else {
                if   let rtf = Bundle.main.url(forResource: "Sync_Contacts_EN_SUPPLIER", withExtension: "rtf", subdirectory: nil, localization: nil) {
                    do {
                        let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
                        self.myTextView.attributedText  = attributedString
                        self.myTextView.textAlignment = .center
                    } catch let error {
                        print("Got an error \(error)")
                    }
                }
            }
        }
        
        self.viewDidLayoutSubviews()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        
        self.myTextView.textAlignment = .center
        self.myTextView.setContentOffset(.zero, animated: true)
    }
}

