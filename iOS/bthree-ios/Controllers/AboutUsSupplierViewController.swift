//
//  AboutUsSupplierViewController.swift
//  BThere
//
//  Created by Eduard Stefanescu on 11/22/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit

class AboutUsSupplierViewController: NavigationModelViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnRegulation: UIButton!
    @IBOutlet weak var txtVAbout: UITextView!
    
    
    @IBAction func btnRegulation(_ sender: AnyObject) {
        
        let clientStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        
        let viewRegulation: TermsOfUseSupplierViewController = clientStoryBoard.instantiateViewController(withIdentifier: "TermsOfUseSupplierViewController")as! TermsOfUseSupplierViewController
        viewRegulation.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        //        self.view.addSubview(viewRegulation.view)
        viewRegulation.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewRegulation, animated: true, completion: nil)
        //        self.presentViewController(viewRegulation, animated: true, completion: nil)
    }
    //MARK: - Outlet
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:27)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRegulation.setTitle("VIEW_TERMS_OF_USE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblTitle.text = "ABOUT_US".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        txtVAbout.text = "VIEW_ABOUT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        // Set terms of use text
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            if   let rtf = Bundle.main.url(forResource: "About_HE", withExtension: "rtf", subdirectory: nil, localization: nil) {
                
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    self.txtVAbout.attributedText  = attributedString
                    self.txtVAbout.textAlignment = .right
                } catch let error {
                    print("Got an error \(error)")
                }
            }
        } else {
            // Other
            if   let rtf = Bundle.main.url(forResource: "About_EN", withExtension: "rtf", subdirectory: nil, localization: nil) {
                
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    self.txtVAbout.attributedText  = attributedString
                    self.txtVAbout.textAlignment = .left
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
    
    override func viewDidAppear(_ animated: Bool) {
        //  self.view.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        self.view.addBackground()
        
    }
}
//extension UIView {
//    func addBackground() {
//        // screen width and height:
//        let width = UIScreen.mainScreen().bounds.size.width
//        let height = UIScreen.mainScreen().bounds.size.height
//
//        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
//        imageViewBackground.image = UIImage(named: "client.jpg")
//
//        // you can change the content mode:
//        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
//
//        self.addSubview(imageViewBackground)
//        self.sendSubviewToBack(imageViewBackground)
//    }}
//extension UIView {
//    func addBackground2() {
//        // screen width and height:
//        let width = UIScreen.mainScreen().bounds.size.width
//        let height = UIScreen.mainScreen().bounds.size.height
//
//        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
//        imageViewBackground.image = UIImage(named: "Search Result Hairdresser.jpg")
//
//        // you can change the content mode:
//        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
//
//        self.addSubview(imageViewBackground)
//        self.sendSubviewToBack(imageViewBackground)
//    }}

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
