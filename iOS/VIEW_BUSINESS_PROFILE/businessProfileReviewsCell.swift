//
//  businessProfileReviewsCell.swift
//  Bthere
//
//  Created by BThere on 9/11/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import MessageUI
class businessProfileReviewsCell: UITableViewCell,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var usernameReview: UILabel!
    @IBOutlet weak var textReview: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var reportReviewBtn: UIButton!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var reportLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0)
        {
            self.usernameReview.textAlignment = .right
            self.textReview.textAlignment = .right
        }
        else if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 1)
        {
            self.usernameReview.textAlignment = .left
            self.textReview.textAlignment = .left
        }
        self.reportLabel.text = "REPORT_LABEL_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    
    @IBAction func openMail(_ sender: UIButton)
    {
        if( MFMailComposeViewController.canSendMail() )
        {
            print("Can send email.")
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            //Set to recipients
            mailComposer.setToRecipients(["btherecompany@bthere-tech.com"])
            //Set the subject
            mailComposer.setSubject("דיווח על ביקורת פוגענית")
            //set mail body
            if let _ = textReview.text
            {
                var stringToBeComposed:String = ""
                stringToBeComposed += "ONE_REVIEW".localized(LanguageMain.sharedInstance.USERLANGUAGE) + " "
                stringToBeComposed += "</br>"
                stringToBeComposed += "</br>"
                stringToBeComposed += "TWO_REVIEW".localized(LanguageMain.sharedInstance.USERLANGUAGE) + " "
                stringToBeComposed += "</br>"
                stringToBeComposed += "THREE_REVIEW".localized(LanguageMain.sharedInstance.USERLANGUAGE) + " "
                stringToBeComposed += textReview.text!
                stringToBeComposed += "</br>"
                mailComposer.setMessageBody(stringToBeComposed, isHTML: true)
            }

            if let topController = UIApplication.topViewController() {
                topController.present(mailComposer, animated: true, completion: nil)
            }
        }
        else
        {
            Alert.sharedInstance.showAlertDelegate("FAILED_EMAIL_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        print("finished ")
        controller.dismiss(animated: true, completion: nil)
    }
    
}
