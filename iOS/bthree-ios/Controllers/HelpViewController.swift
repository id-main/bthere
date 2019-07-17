//
//  HelpViewController.swift
//  Bthere
//
//  Created by User on 19.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
// דף עזרה
class HelpViewController: NavigationModelViewController { // , UITableViewDelegate, UITableViewDataSource
    // Outlets
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var helpTextView: UITextView!
    @IBOutlet weak var topTblCon: NSLayoutConstraint!
    @IBOutlet weak var tblQuestions: UITableView!
    
    
    // Variables
    var answersEnglishArray:Array<String> = ["Any business that regularly uses a calendar for scheduling appointments and have a fix duration for each service, can use the app."]
    var questionsArray:Array<String> = ["איך אני מוסיף לקוח חדש?","החלפתי שם לעסק מה אני צריך לעשות","באיזה גודל אני צריכהלעשות את הלוגו",""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set language
        titleLabel.text = "HELP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            let path = Bundle.main.path(forResource: "Help_HE", ofType: "txt")
            
            let contents: NSString
            do {
                contents = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
            } catch _ {
                contents = ""
            }
            
            self.helpTextView.text  = contents as String
            self.helpTextView.textAlignment = .right

        } else {
            // Other
            let path = Bundle.main.path(forResource: "Help_EN", ofType: "txt")
            
            let contents: NSString
            do {
                contents = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
            } catch _ {
                contents = ""
            }
            
            self.helpTextView.text  = contents as String
            self.helpTextView.textAlignment = .left

        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
}
