//
//  ExplainPopUp24HoursViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 26/02/2019
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit


class ExplainPopUp24HoursViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var firstlabel: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var imgbutton: UIImageView!
    var nvPhone:String = ""
    var _whichtext:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        firstlabel.numberOfLines = 0
        imgbutton.image = UIImage()
        if _whichtext == 2 {

            firstlabel.text = "EXPLAIN_NO_CANCEL_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            imgbutton.image = UIImage(named: "okSelected.png")
        }
        if _whichtext == 1 {
            firstlabel.text = "EXPLAIN_NO_APROVAL_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            imgbutton.image = UIImage(named: "Cancel-selected.png")
        }
        btnOK.setTitle("OK_GOTIT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //func to dismiss the popUp
    @IBAction func btnOK(_ sender:AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }

    
}
