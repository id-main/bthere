//
//  popUpPaymentVC.swift
//  Bthere
//
//  Created by BThere on 9/17/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class popUpPaymentVC: UIViewController {
    @IBOutlet weak var popUPPASSWORD:UIView!
    @IBOutlet weak var titlepopUPPASSWORD:UILabel!
    @IBOutlet weak var btnCloseX: UIButton!
    @IBOutlet weak var labelWelcomeText:UILabel!
    @IBAction func btnCloseX(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    var isfliped:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func flip() {
        isfliped =  !isfliped
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        popUPPASSWORD.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
        titlepopUPPASSWORD.text = "POP_UP_PAYMENT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        titlepopUPPASSWORD.font = UIFont (name: "OpenSansHebrew-Bold", size: 26)
        //            titlepopUPPASSWORD.sizeToFit()
        
        labelWelcomeText.text = "ERROR_PAYMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        titlepopUPPASSWORD.font = UIFont (name: "OpenSansHebrew-Bold", size: 18)
        
//        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0)
//        {
//            if   let rtf = Bundle.main.url(forResource: "Working_hours_PopUp_HE", withExtension: "rtf", subdirectory: nil, localization: nil) {
//                do {
//
//                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
//                    labelWelcomeText.attributedText  = attributedString
//                }
//                catch let error
//                {
//                    print("Got an error \(error)")
//                }
//            }
//
//        }
//        else
//        {
//
//            if   let rtf = Bundle.main.url(forResource: "Working_Hours_PopUp_EN", withExtension: "rtf", subdirectory: nil, localization: nil) {
//                do {
//
//                    let attributedString: NSMutableAttributedString =  try NSMutableAttributedString(url: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
//                    labelWelcomeText.attributedText  = attributedString
//                    //                    labelWelcomeText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
//
//                }
//                catch let error
//                {
//                    print("Got an error \(error)")
//                }
//            }
//
//        }
        
        //            labelWelcomeText.text = "POP_UP_BODY_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //            labelWelcomeText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        
        //            view.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
    }

}
